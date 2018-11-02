function [boxes] = detector_singleImg(inputImg, w, b, feature_params, thres)
% coords(i) is  [x_min, y_min, x_max, y_max] for test img i. 
run('C:\Users\123\Documents\MATLAB\download\vlfeat-0.9.21\toolbox\vl_setup')

boxes = zeros(0,4);
% thres=0.5;

if(size(inputImg,3) > 1)
    inputImg = rgb2gray(inputImg);
end
img = histEqual(inputImg);
img = single(img)/255;

cur_boxes=zeros(0,4);
cur_scores=zeros(0,1);

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
                cur_boxes(size(cur_boxes,1)+1,:)=ceil([feature_params.hog_cell_size*(jj-1)+1,feature_params.hog_cell_size*(ii-1)+1,...
                    feature_params.hog_cell_size*(jj+num),feature_params.hog_cell_size*(ii+num)]*(1/ds_rate)^(cell_num-1));
                cur_scores(length(cur_scores)+1,:)=Y;
            end
        end
    end
    
end


%% non_max_supression
[valids] = non_max_supression(cur_boxes, cur_scores, size(img));
cur_boxes      = cur_boxes(valids,:);
boxes      = [boxes;      cur_boxes];

% %%
% imshow(inputImg); hold on;
% plot(boxes([1 3 3 1 1]),boxes([2 2 4 4 2]),'g','linewidth',1);
% hold off;
end


function [valids] = non_max_supression(coords, scores, img_size)

%in case of out of bounds detections
x_out = coords(:,3) > img_size(2);
y_out = coords(:,4) > img_size(1); 

coords(x_out,3) = img_size(2);
coords(y_out,4) = img_size(1);

num_detections = size(scores,1);

%higher score detections come first.
[scores, ind] = sort(scores, 'descend');
coords = coords(ind,:);

valids = false(1,num_detections);

for i = 1:num_detections
    cur_co = coords(i,:);
    cur_co_valid = true;
    
    for j = find(valids)
        %compute overlap with previous valid coords
        prev_co=coords(j,:);
        bi=[max(cur_co(1),prev_co(1)) ; ...
            max(cur_co(2),prev_co(2)) ; ...
            min(cur_co(3),prev_co(3)) ; ...
            min(cur_co(4),prev_co(4))];
        w=bi(3)-bi(1)+1;
        h=bi(4)-bi(2)+1;
        if w>0 && h>0
            % compute overlap
            ta=(cur_co(3)-cur_co(1)+1)*(cur_co(4)-cur_co(2)+1)+(prev_co(3)-prev_co(1)+1)*(prev_co(4)-prev_co(2)+1)-w*h;
            if w*h/ta > 0.3
                cur_co_valid = false;
                continue;
            end
            
            sr=min((cur_co(3)-cur_co(1)+1)*(cur_co(4)-cur_co(2)+1),(prev_co(3)-prev_co(1)+1)*(prev_co(4)-prev_co(2)+1));
            if  w*h/sr>0.2
                cur_co_valid = false;
                continue;
            end
            
            %The center of one detection can not be within previous detection
            center_coord = [(cur_co(1) + cur_co(3))/2, (cur_co(2) + cur_co(4))/2];
            if( center_coord(1) > prev_co(1) && center_coord(1) < prev_co(3) && ...
                    center_coord(2) > prev_co(2) && center_coord(2) < prev_co(4))                
                cur_co_valid = false;
                continue;
            end
        end
    end
    valids(i) = cur_co_valid;
end

map(ind) = 1:num_detections;
valids = valids(map);

% fprintf(' non-max suppression: %d detections to %d final vaild detections\n', num_detections, sum(valid_coords));
end


