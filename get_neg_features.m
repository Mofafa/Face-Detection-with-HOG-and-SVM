function neg_features = get_neg_features(neg_data, feature_params, num_samples)

images = dir( fullfile( neg_data, '*.jpg' ));
num_images = length(images);
neg_features=zeros(num_samples,(feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
num_curr=1;

sfactor = [2,1.5,1];
tsize = round(feature_params.template_size * sfactor);
for m = 1:length(sfactor)
    t_size = tsize(m);
    for i=1:num_images
        if num_curr<num_samples
            img=imread(fullfile(neg_data,images(i).name));
            img=im2single(rgb2gray(img));
            if min(size(img))/t_size < 1
                img = imresize(img,size(img)*2);
            end
            for j1=1:floor(size(img,1)/t_size)
                for j2=1:floor(size(img,2)/t_size)
                    img_temp=imresize(img(t_size*(j1-1)+1:t_size*j1,t_size*(j2-1)+1:t_size*j2),...
                        [feature_params.template_size,feature_params.template_size]);
                    hog=vl_hog(img_temp,feature_params.hog_cell_size);
                    hog=reshape(hog,[1,(feature_params.template_size/feature_params.hog_cell_size)^2 * 31]);
                    neg_features(num_curr,:)=hog;
                    num_curr=num_curr+1;
                end
            end
        else
            return;
        end
    end
end
fprintf('Warning: not enough negative features! Only %d features\n', num_curr);
end


    
    
