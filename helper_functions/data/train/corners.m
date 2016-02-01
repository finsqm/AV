function [ height_min, height_max, width_min, width_max ] = corners( boundary )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[N,~] = size(boundary);

height_min = 100000;
height_max = 0;
width_min = 100000;
width_max = 0;

for k = 1 : N
        
        point = boundary(k,:);
        i = point(1);
        j = point(2);
    
        if i < height_min 
                
            height_min = i;
            
        end
        
        if i > height_max 
                
            height_max = i;
                
        end
            
        if j < width_min 
                
            width_min = j;
                
        end
            
        if j > width_max
            
            width_max = j;
            
        end
        
end

