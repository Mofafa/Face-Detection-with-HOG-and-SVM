data ='C:/Users/86450/Documents/MATLAB/FACE/faceDetectHoG/data'; 
neg_data = fullfile(data, 'total_train_non_face_scenes'); 
feature_params = struct('template_size', 36, 'hog_cell_size', 4);
negimg_path = 'C:\Users\86450\Documents\MATLAB\FACE\faceDetectHoG\data\non-face';



images = dir( fullfile( neg_data, '*.jpg' ));
num_images = length(images);

sfactor = [2,1.5,1];
tsize = round(feature_params.template_size * sfactor);
for s = 1:length(sfactor)
    t_size = tsize(s);
    curid = 0;
    for i = 1:num_images
        fprintf('stage %s img %d\n',num2str(sfactor(s)),i);
        img=imread(fullfile(neg_data,images(i).name));
        img = rgb2gray(img);
        if min(size(img))<t_size
            continue;
        end
        for j1=1:floor(size(img,1)/t_size)
            for j2=1:floor(size(img,2)/t_size)
                curid = curid+1;
                img_temp=imresize(img(t_size*(j1-1)+1:t_size*j1,t_size*(j2-1)+1:t_size*j2),...
                    [feature_params.template_size,feature_params.template_size]);
                imwrite(img_temp, sprintf('%s/%s/%d.jpg', negimg_path, num2str(sfactor(s)),curid));
            end
        end
    end
end
        
