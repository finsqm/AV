
thres = 0.25;


for img_idx = 1 : 210
    
    a_hsv = hsv_img_cell{img_idx};
    a_hsv = a_hsv - bg_img_cell{3}; 
    
    %img to black/white
    a_bw = a_hsv(:,:,2) >= thres;
    
    %map over all pixels to the left of the dancers
    a_bw(:, 1:320) = 0;
    %map pixels below the dancers
    a_bw(240:480, :) = 0;
    %map pixels to the right of the dancers
    a_bw(:, 540:640) = 0;
    
    %dilate img
    se = strel('disk', 6);
    a_bw = imdilate(a_bw, se);
    
    
    %full labelled image
    [labelled, num] = bwlabel(a_bw,4);

    STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
        'MinorAxisLength'});
    
    %get rid of small objects
    idx = find([STATS.Area] > 800);
    bw2 = ismember(labelled, idx);

    
   

    [labelled, num] = bwlabel(bw2,4);

    STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
        'MinorAxisLength', 'Orientation'});
    
    %identify two people sticking together
    idx = find([STATS.Area] > 1600);
    bw_fats = ismember(labelled, idx);
    
    
    %create separate image without people sticking together
    idx = find([STATS.Area] <= 1600);
    bw_no_fats = ismember(labelled, idx);
    
    
    
    %display the image with circles
    %imshow(img_cell{img_idx});
    imshow(bw2);
    
    [labelled, num] = bwlabel(bw_fats,4);
    
    if num > 0
    
        STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
            'MinorAxisLength', 'Orientation'});

        % based on axis of greatest width, we will chop big blobs 
        % perpendicular to that axis

        orient_angle = -1 * [STATS.Orientation];

        cents = cat(1, STATS.Centroid);
        majAx = cat(1, STATS.MajorAxisLength)
        minAx = cat(1, STATS.MinorAxisLength);
        
        quarters = repmat(0.25, num, 1);
        
        % TODO -
        % Handle case where fat blob contain 3 people
        % 2 people majAx = ~65
        % 3 people majAx = ~117
        % Based on majAx length, either split into 2 people or 3 people
        
        cent1_x = cents(:,1) + ( quarters(:) .* majAx(:) .* cosd(orient_angle(:)) ); 
        cent1_y = cents(:,2) + ( quarters(:) .* majAx(:) .* sind(orient_angle(:)) );

        cent2_x = cents(:,1) - ( quarters(:) .* majAx(:) .* cosd(orient_angle(:)) );
        cent2_y = cents(:,2) - ( quarters(:) .* majAx(:) .* sind(orient_angle(:)) );

        

        %get the fat circles info
        f_centers = cat(1, [cent1_x cent1_y], [cent2_x cent2_y]);        
        majorAx = cat(1, majAx./2);
        minorAx = cat(1, minAx./2);
        both_axes = cat(1, [majorAx minorAx], [majorAx minorAx]);
        diameters = mean(both_axes, 2);
        f_radii = diameters/2;

        hold on
        viscircles(f_centers, f_radii);
        hold off
    end
    
    %get the non-fat circles info
    [labelled2, num2] = bwlabel(bw_no_fats,4);

    STATS2 = regionprops(labelled2, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
        'MinorAxisLength', 'Orientation'});

    centers = cat(1, STATS2.Centroid);
    majorAx = cat(1, STATS2.MajorAxisLength);
    minorAx = cat(1, STATS2.MinorAxisLength);
    diameters = mean([majorAx minorAx], 2);
    [radii] = diameters/2;


    %display the circles on the image
    hold on
    viscircles(centers, radii);
    hold off

    w = waitforbuttonpress;
    
end
