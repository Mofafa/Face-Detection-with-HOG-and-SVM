close all
clear
run('C:\Users\123\Documents\MATLAB\download\vlfeat-0.9.21\toolbox\vl_setup')
% 
data ='C:/Users/123/Documents/MATLAB/FACE/faceDetectHoG/data'; 
pos_data = 'C:\Users\123\Documents\MATLAB\FACE\test\Caltech_processed\totalFace';
neg_data = fullfile(data, 'total_train_non_face_scenes'); 
test = fullfile(data,'test'); %test images path
results = [data,'/results']; %results path
feature_params = struct('template_size', 36, 'hog_cell_size', 4);
threshold = struct('hard_thres',0.2,'detect_thres',0);

[w,b] = faceDetect(pos_data,neg_data,test,feature_params,threshold, results, 2, 800);


%% test accuracy
% load('test_wb.mat');
% load('feature_params');
data ='C:/Users/123/Documents/MATLAB/FACE/faceDetectHoG/data'; 
test_gt_path = fullfile(data,'test_scenes/test_jpg'); %CMU+MIT test scenes 
label_path = fullfile(data,'test_scenes/ground_truth_bboxes.txt'); %the ground truth face locations in the test set
[bboxes, confidences, image_ids] = detector(test_gt_path, w, b, feature_params, threshold.detect_thres);
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections] = ...
    evaluate_detections(bboxes, confidences, image_ids, label_path);
num_gt_face = 511;
detect_true_faces = sum(tp);
detect_false_faces = sum(fp);
rec = detect_true_faces/num_gt_face;
prec = detect_true_faces/(detect_true_faces+detect_false_faces);
fprintf('detect_true_face = %d\ndetect_false_face = %d\n',detect_true_faces,detect_false_faces);
fprintf('Precision is: %.5f\n', prec);
fprintf('Recall rate is: %.5f\n', rec);

% save('detectFace_4_2_800.mat','feature_params','w','b','threshold');
% 
% write_detection_results_gt(bboxes, confidences, image_ids, tp, fp, test_gt_path, label_path);
