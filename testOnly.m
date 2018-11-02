%% test no gt butch
% load('detectFace8.mat');
test_path = 'C:\Users\123\Documents\MATLAB\FACE\lfpw\testset';
results = [cd,'/results']; %results path
[bboxes, confidences, image_ids] = detector(test_path, w, b, feature_params, 0);
write_detection_results(bboxes, image_ids, test_path, results)

%% single test
figure(1)
img = imread('class1956.jpg');
[boxes] = detector_singleImg(img, w, b, feature_params, 0);
imshow(img);
hold on;
for j = 1:size(boxes,1)
    xy = boxes(j,:);
    plot(xy([1 3 3 1 1]),xy([2 2 4 4 2]),'g','linewidth',1);
end