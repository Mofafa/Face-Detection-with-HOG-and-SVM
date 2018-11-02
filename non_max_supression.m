function [valids] = non_max_supression(coords, scores, img_size)

%in case of out of bounds detections
x_out = coords(:,3) > img_size(2);
y_out = coords(:,4) > img_size(1); 

coords(x_out,3) = img_size(2);
coords(y_out,4) = img_size(1);

num_detections = size(scores,1);

%higher score detections come first.
[scores, ind] = sort(scores, 'descend');
coords = coords(ind,:);

valids = false(1,num_detections);

for i = 1:num_detections
    cur_co = coords(i,:);
    cur_co_valid = true;
    
    for j = find(valids)
        %compute overlap with previous valid coords
        prev_co=coords(j,:);
        bi=[max(cur_co(1),prev_co(1)) ; ...
            max(cur_co(2),prev_co(2)) ; ...
            min(cur_co(3),prev_co(3)) ; ...
            min(cur_co(4),prev_co(4))];
        w=bi(3)-bi(1)+1;
        h=bi(4)-bi(2)+1;
        if w>0 && h>0
            % compute overlap
            ta=(cur_co(3)-cur_co(1)+1)*(cur_co(4)-cur_co(2)+1)+(prev_co(3)-prev_co(1)+1)*(prev_co(4)-prev_co(2)+1)-w*h;
            if w*h/ta > 0.3
                cur_co_valid = false;
                continue;
            end
            
            sr=min((cur_co(3)-cur_co(1)+1)*(cur_co(4)-cur_co(2)+1),(prev_co(3)-prev_co(1)+1)*(prev_co(4)-prev_co(2)+1));
            if  w*h/sr>0.2
                cur_co_valid = false;
                continue;
            end
            
            %The center of one detection can not be within previous detection
            center_coord = [(cur_co(1) + cur_co(3))/2, (cur_co(2) + cur_co(4))/2];
            if( center_coord(1) > prev_co(1) && center_coord(1) < prev_co(3) && ...
                    center_coord(2) > prev_co(2) && center_coord(2) < prev_co(4))                
                cur_co_valid = false;
                continue;
            end
        end
    end
    valids(i) = cur_co_valid;
end

map(ind) = 1:num_detections;
valids = valids(map);

% fprintf(' non-max suppression: %d detections to %d final vaild detections\n', num_detections, sum(valid_coords));
end

