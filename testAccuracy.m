% function testAccuracy()
load('detectFace_4_3_500.mat');
run('C:\Users\86450\Documents\MATLAB\download\vlfeat-0.9.21\toolbox\vl_setup')
data ='C:/Users/86450/Documents/MATLAB/FACE/faceDetectHoG/data'; 
test_gt_path = fullfile(data,'test_scenes/test_jpg'); %CMU+MIT test scenes 
label_path = fullfile(data,'test_scenes/ground_truth_bboxes.txt'); %the ground truth face locations in the test set
[bboxes, confidences, image_ids] = detector(test_gt_path, w, b, feature_params, 0);
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections, num_gt_face] = ...
    evaluate_detections(bboxes, confidences, image_ids, label_path);
detect_true_faces = sum(tp);
detect_false_faces = sum(fp);
rec = detect_true_faces/num_gt_face;
prec = detect_true_faces/(detect_true_faces+detect_false_faces);
fprintf('detect_true_face = %d\ndetect_false_face = %d\n',detect_true_faces,detect_false_faces);
fprintf('Precision is: %.5f\n', prec);
fprintf('Recall rate is: %.5f\n', rec);
% write_detection_results_gt(bboxes, confidences, image_ids, tp, fp, test_gt_path, label_path);
% end

