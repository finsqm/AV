function [ centers, radii ] = extractDancers( img_idx, bg_img_cell, hsv_img_cell )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

thres = 0.25;

centers = [];
radii = [];

a_hsv = hsv_img_cell{img_idx};
a_hsv = abs(a_hsv - bg_img_cell{3}); 

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
%a_bw = bwmorph(a_bw, 'dilate', 1);
%a_bw = bwmorph(a_bw, 'open', Inf);
%a_bw = bwmorph(a_bw, 'bridge', Inf);
%a_bw = bwmorph(a_bw, 'fill', 10);

%full labelled image
[labelled, ~] = bwlabel(a_bw,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength'});

%get rid of small objects
idx = find([STATS.Area] > 700);
bw2 = ismember(labelled, idx);

imshow(bw2)

[labelled, num_total] = bwlabel(bw2,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength', 'Orientation'});

%create new image of only fat guys
%identify two people sticking together
idx = find([STATS.Area] > 1600);
bw_fats = ismember(labelled, idx);


%create separate image without people sticking together
idx = find([STATS.Area] <= 1600);
bw_no_fats = ismember(labelled, idx);


[labelled, num] = bwlabel(bw_fats,4);

if num_total == 2 && num == 1
        
    STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
        'MinorAxisLength', 'Orientation'});

    % based on axis of greatest width, we will chop big blobs 
    % perpendicular to that axis

    orient_angle = -1 * [STATS.Orientation];

    cents = cat(1, STATS.Centroid);
    majAx = cat(1, STATS.MajorAxisLength);
    minAx = cat(1, STATS.MinorAxisLength);

    thirds = repmat(0.33, num, 1);

    % TODO -
    % Handle case where fat blob contain 3 people
    % 2 people majAx = ~65
    % 3 people majAx = ~117
    % Based on majAx length, either split into 2 people or 3 people
    
    cent0_x = cents(:,1)
    cent0_y = cents(:,2)
    
    cent1_x = cents(:,1) + ( thirds(:) .* majAx(:) .* cosd(orient_angle(:)) ); 
    cent1_y = cents(:,2) + ( thirds(:) .* majAx(:) .* sind(orient_angle(:)) );

    cent2_x = cents(:,1) - ( thirds(:) .* majAx(:) .* cosd(orient_angle(:)) );
    cent2_y = cents(:,2) - ( thirds(:) .* majAx(:) .* sind(orient_angle(:)) );



    %get the fat circles info
    f_centers = cat(1, [cent0_x cent0_y], [cent1_x cent1_y], [cent2_x cent2_y]);        
    majorAx = cat(1, majAx./2);
    minorAx = cat(1, minAx./2);
    both_axes = cat(1, [majorAx minorAx], [majorAx minorAx],  [majorAx minorAx]);
    diameters = mean(both_axes, 2);
    f_radii = diameters/3;

    
    centers = [centers ; f_centers];
    radii = [radii f_radii];
        
        
elseif num > 0
            
    STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
        'MinorAxisLength', 'Orientation'});

    % based on axis of greatest width, we will chop big blobs 
    % perpendicular to that axis

    orient_angle = -1 * [STATS.Orientation];

    cents = cat(1, STATS.Centroid);
    majAx = cat(1, STATS.MajorAxisLength);
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

    
    centers = [centers ; f_centers];
    radii = [radii f_radii];
    
    
end

%get the non-fat circles info
[labelled2, num2] = bwlabel(bw_no_fats,4);

STATS2 = regionprops(labelled2, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength', 'Orientation', 'PixelIdxList'});

%pixelIdxList = cell(4);
%pixelIdxList{1} = STATS2(1).PixelIdxList;
%pixelIdxList{2} = STATS2(2).PixelIdxList;
%pixelIdxList{3} = STATS2(3).PixelIdxList;
%pixelIdxList{4} = STATS2(4).PixelIdxList;

n_centers = cat(1, STATS2.Centroid);
majorAx = cat(1, STATS2.MajorAxisLength);
minorAx = cat(1, STATS2.MinorAxisLength);
diameters = mean([majorAx minorAx], 2);
[n_radii] = diameters/2;


centers = [centers ; n_centers];
size(radii)
size(n_radii)
radii = [radii ; n_radii];


end

