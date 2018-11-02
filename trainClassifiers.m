function [w, b] = trainClassifiers(pos_features,neg_features,num, neg_data, feature_params, thres)
%TRAINCLASSIFIERS 此处显示有关此函数的摘要
%   此处显示详细说明
X = cell(num,1);
Y = cell(num,1);
w = cell(num,1);
b = cell(num,1);
num_pos = floor(size(pos_features,1)/num);
aug_pos_indices = randperm(size(pos_features,1), num_pos);
num_neg = floor(size(neg_features,1)/num);
aug_neg_indices = randperm(size(neg_features,1), num_neg);
for i = 1:num
    pos = [pos_features((i-1)*num_pos+1:i*num_pos,:);pos_features(aug_pos_indices,:)];
    neg = [neg_features((i-1)*num_neg+1:i*num_neg,:);neg_features(aug_neg_indices,:)];    
    X{i} = [pos' neg'];
    Y{i} = [ones(1,num_pos*2), -ones(1,num_neg*2)];
end

%% SVM training
for i = 1:num
    [w{i},b{i}]=vl_svmtrain(X{i},Y{i},0.001);
    figure(2);
    examClassifier(X, Y, w, b);
    title('before hard training');
end

%% hard training
num_hard_neg = round(num_neg/5);
for i = 1:num
    hard_neg_features =hard_neg_detector(neg_data, w{i}, b{i}, feature_params,num_hard_neg);
    X{i} = [X{i} hard_neg_features'];
    Y{i} = [Y{i} -ones(1,size(hard_neg_features,1))];
    [w{i},b{i}]=vl_svmtrain(X{i},Y{i},0.001);
    figure(3);
    examClassifier(X, Y, w, b);
    title('after hard training');
end

%% calc weights
scores = cell(num,1);
XX = [pos_features' neg_features'];
labels = [ones(1,size(pos_features,1)) -ones(1,size(neg_features,1))]';
for i = 1:num
    scores{i} = (XX'*w{i} + b{i})>thres;
end


end
