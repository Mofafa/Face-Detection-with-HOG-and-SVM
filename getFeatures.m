function [pos_features,neg_features] = getFeatures(data_path,num_neg)
%GETFEATURES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% obtain HOG features of face data and non-face data
% pos_features = get_pos_features( data_path.pos, feature_params );
load('pos_features.mat');
neg_features = get_neg_features( neg_data, feature_params, num_neg);
end

