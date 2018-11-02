function [coords, scores, img_ids] = detector(test, w, b, feature_params, thres)
% coords(i) is  [x_min, y_min, x_max, y_max] for test img i. 
test_imgs = [dir( fullfile( test, '*.png' ));dir( fullfile( test, '*.jpg' ))];

coords = zeros(0,4);
scores = zeros(0,1);
img_ids = cell(0,1);
% thres=0.3;

for i = 1:length(test_imgs)
    img = imread( fullfile( test, test_imgs(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1) 
        img = rgb2gray(img);
    end
    
    cur_coords=zeros(0,4);
    cur_scores=zeros(0,1);
    cur_img_ids=cell(0,1);
    
    %% Get image pyramid
    ds_rate = 0.8;
    cell_num=1;
    temp_img=img;
    img_cell=cell(1,0);
    while min(size(temp_img))>40
        img_cell{cell_num}=temp_img;
        temp_img=imresize(temp_img,ds_rate);
        cell_num=cell_num+1;
    end   
    
    if cell_num == 1 && min(size(temp_img))>=36
        img_cell{cell_num}=temp_img;
    end
    
    num = feature_params.template_size / feature_params.hog_cell_size - 1;
    for cell_num=1:size(img_cell,2)
        temp_img=img_cell{cell_num};
        hog=vl_hog(temp_img,feature_params.hog_cell_size);
        for ii=1:size(hog,1)-num
            for jj=1:size(hog,2)-num
                cur_hog=reshape(hog(ii:ii+num,jj:jj+num,:),[1,(feature_params.template_size / feature_params.hog_cell_size)^2 * 31]);
                X=cur_hog';
                Y=w'*X+b;
                if Y>thres
                    cur_coords(size(cur_coords,1)+1,:)=ceil([feature_params.hog_cell_size*(jj-1)+1,feature_params.hog_cell_size*(ii-1)+1,...
                        feature_params.hog_cell_size*(jj+num),feature_params.hog_cell_size*(ii+num)]*(1/ds_rate)^(cell_num-1));
                    cur_scores(length(cur_scores)+1,:)=Y;
                end
            end
        end

    end    
    
    
    cur_img_ids(1:length(cur_scores),1) = {test_imgs(i).name};

    %% non_max_supression
    [valids] = non_max_supression(cur_coords, cur_scores, size(img));
    cur_scores = cur_scores(valids,:);
    cur_coords      = cur_coords(valids,:);
    cur_img_ids   = cur_img_ids(  valids,:);
    coords      = [coords;      cur_coords];
    scores = [scores; cur_scores];
    img_ids   = [img_ids;   cur_img_ids];
end

end


