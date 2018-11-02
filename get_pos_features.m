function pos_features = get_pos_features(pos_data, feature_params)

images = dir( fullfile( pos_data, '*.jpg') );
num_images = length(images);
pos_features = zeros(num_images, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);

for i=1:num_images
    img_name=fullfile(pos_data,images(i).name);
    img=imread(img_name);
    img=im2single(img);
    hog=vl_hog(img,feature_params.hog_cell_size);
    hog=reshape(hog,[1,(feature_params.template_size / feature_params.hog_cell_size)^2 * 31]);
    pos_features(i,:)=hog;
end
end


    

