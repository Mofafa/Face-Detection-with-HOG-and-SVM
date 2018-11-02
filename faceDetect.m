function [w, b] = faceDetect(pos_data, neg_data, test, feature_params, threshold, results, level, num_hard)
%% obtain HOG features of face data and non-face data
pos_features = get_pos_features( pos_data, feature_params );
num_neg = 15000; %Higher will work strictly better
neg_features = get_neg_features( neg_data, feature_params, num_neg);
% load('pos_features_4.mat');
% load('neg_features_4_15000.mat'); 

%% SVM training
X=[pos_features' neg_features'];
Y=[ones(1,size(pos_features,1)) -ones(1,size(neg_features,1))];
[w,b]=vl_svmtrain(X,Y,0.001);

%% Examine learned classifier
% figure(2);
% examClassifier(X, Y, w, b);
% title('before hard training');
ori_X = X; ori_Y = Y;
% % Visualize the learned detector.
% n_hog_cells = sqrt(length(w) / 31);
% imhog = vl_hog('render', single(reshape(w, [n_hog_cells n_hog_cells 31])), 'verbose') ;
% figure(4); imagesc(imhog) ;
% colormap gray;
% 
% pause(0.1) %let's ui rendering catch up
% hog_template_image = frame2im(getframe(4));
% imwrite(hog_template_image, 'visualizations/hog_template.png');


%% cascade train
% level is the cascade level, each level has num_hard training images
% num_hard=300;
% num_hard_pos = 50;
for i = 1:level
    hard_neg_features =hard_neg_detector(neg_data, w, b, feature_params,num_hard, threshold.hard_thres);
    X=[X,hard_neg_features'];
    Y=[Y, -ones(1,size(hard_neg_features,1))];
%     hard_pos_features =hard_pos_detector(pos_features, w, b, feature_params,num_hard_pos, 0);
%     X=[X hard_pos_features',hard_neg_features'];
%     Y=[Y, ones(1,size(hard_pos_features,1)), -ones(1,size(hard_neg_features,1))];
    [w,b]=vl_svmtrain(X,Y,0.001);
end
% %%
% figure(3);
% examClassifier(X, Y, w, b);
figure(33);
examClassifier(ori_X,ori_Y,w,b);
title('after hard training');
% %% detect faces
% tic;
% [coords, scores, img_ids] = detector(test, w, b, feature_params, threshold.detect_thres);
% toc;
% %% write results
% write_detection_results(coords, img_ids, test, results);
% save('test_wb.mat','w','b');
end