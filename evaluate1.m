function [ num_detections, mean_dist, num_false ] = evaluate1( centers, ground_centers )

% Evaluates detections within 10 pixels of ground truth

num_detections = 0;
num_false = 0;
mean_dist = 0;

for i = 1 : 4
    
    cx = centers(i,1);
    cy = centers(i,2);
    false = 1;
    
    for j = 1 : 4
        
        gx = ground_centers(j,:,1);
        gy = ground_centers(j,:,2);
        dist = sqrt((cx - gx)^2 + (cy - gy)^2);
        
        if dist <= 10
            
            num_detections = num_detections + 1;
            false = 0;
            mean_dist = mean_dist + dist;
        
        end
    end
        
    if false > 0
        
        num_false = num_false + 1;
    
    end
    
end

mean_dist = mean_dist / num_detections;

end

