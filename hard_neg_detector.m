function hard_neg_features = hard_neg_detector(test, w, b, feature_params,num_samples, thres)
% thres = 0.2;
test_scenes = dir( fullfile( test, '*.jpg' ));
hard_neg_features=zeros(0,(feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
for i = 1:length(test_scenes)
    img = imread( fullfile( test, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1) 
        img = rgb2gray(img);
    end
    %% Get image pyramid
    cell_num=1;
    temp_img=img;
    img_cell=cell(0,1);
    while min(size(temp_img))>40
        img_cell{cell_num}=temp_img;
        temp_img=imresize(temp_img,0.9);
        cell_num=cell_num+1;
    end   
    if cell_num == 1
        continue;
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
            if Y<=thres
                continue;
            end
            hard_neg_features(size(hard_neg_features,1)+1,:)=cur_hog;
            if size(hard_neg_features,1)>=num_samples
                return;
            end
        end
    end

    end
  
    
    
end
fprintf('Warning:  Only find %d hard negative features!\n',size(hard_neg_features,1));
end




