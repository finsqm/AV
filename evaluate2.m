function [ correct, erroneous ] = evaluate2( centers, ground_centers, prev_centers, prev_ground_centers )

correct = 0;
erroneous = 0;

for i = 1 : 4
    
    id = 0;
    prev_id = 0;
    
    cx = centers(i,1);
    cy = centers(i,2);
    
    pcx = prev_centers(i,1);
    pcy = prev_centers(i,2);
    
    min_dist = 10000000;
    prev_min_dist = 100000000;
    
    for j = 1 : 4
        
        gx = ground_centers(j,:,1);
        gy = ground_centers(j,:,2);
        dist = sqrt((cx - gx)^2 + (cy - gy)^2);
        
        pgx = prev_ground_centers(j,:,1);
        pgy = prev_ground_centers(j,:,2);
        prev_dist = sqrt((pcx - pgx)^2 + (pcy - pgy)^2);
        
        if dist < min_dist
            min_dist = dist;
            id = j;
        end
        
        if prev_dist < prev_min_dist
            prev_min_dist = prev_dist;
            prev_id = j;
        end
        
    end
    
    if id == prev_id
        
        correct = correct + 1;
        
    else
        
        erroneous = erroneous + 1;
        
    end
    
end

end
        
        
        