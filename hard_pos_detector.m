function [hard_pos_features] = hard_pos_detector(pos_features, w, b, feature_params,num_samples, thres)
%HARD_POS_DETECTOR 此处显示有关此函数的摘要
%   此处显示详细说明
num_images = size(pos_features,1);
pos_features = zeros(num_images, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
hard_pos_features=zeros(0,(feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
cur_num = 0;
for i=1:num_images
    if w'*pos_features(i,:)'+b>=thres
        continue;
    end
    cur_num = cur_num+1;
    hard_pos_features(cur_num,:)=pos_features(i,:);
    if cur_num>=num_samples
        return;
    end
end
fprintf('Warning:  Only find %d hard positive features!\n',cur_num);
end

