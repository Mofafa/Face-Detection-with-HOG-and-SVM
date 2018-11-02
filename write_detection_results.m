function write_detection_results(coords, image_ids, test, results)
test_imgs = [dir( fullfile( test, '*.png' ));dir( fullfile( test, '*.jpg' ))];
num_test_imgs = length(test_imgs);

for i=1:num_test_imgs
   cur_test_img = imread( fullfile( test, test_imgs(i).name));
      
   cur_detections = strcmp(test_imgs(i).name, image_ids);
   cur_coords = coords(cur_detections,:);
   
   figure(5)
   imshow(cur_test_img);
   hold on;
   
   num_detections = sum(cur_detections);
   
   for j = 1:num_detections
       xy = cur_coords(j,:);
       plot(xy([1 3 3 1 1]),xy([2 2 4 4 2]),'g','linewidth',1);
   end
 
   hold off;
   axis image;
   axis off;
   title(sprintf('image: "%s"', test_imgs(i).name));
    
   pause(0.1) %let's ui rendering catch up
   detection_img = frame2im(getframe(5));
   imwrite(detection_img, sprintf('%s/detections_%s', results, test_imgs(i).name))
   
end



