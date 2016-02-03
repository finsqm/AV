
thres = 0.25;


a_hsv = hsv_img_cell{87};
a_hsv = a_hsv - bg_img_cell{3}; 

a_bw = a_hsv(:,:,2) >= thres;

%se = strel('diamond', 1);
%a_bw = imerode(a_bw, se);

%map over all pixels to the left of the dancers
a_bw(:, 1:320) = 0;
%map pixels below the dancers
a_bw(240:480, :) = 0;
%map pixels to the right of the dancers
a_bw(:, 540:640) = 0;

se = strel('disk', 6);
a_bw = imdilate(a_bw, se);



[labelled, num] = bwlabel(a_bw,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength'});


%get rid of small objects
idx = find([STATS.Area] > 800);
bw2 = ismember(labelled, idx);



% based on axis of greatest width, chop big blobs perpendicular to
% that axis

[labelled, num] = bwlabel(bw2,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength', 'Orientation'});

idx = find([STATS.Area] > 1500);
bw_fats = ismember(labelled, idx);

%create new image with no fat blobs
idx = find([STATS.Area] <= 1500);
bw_no_fats = ismember(labelled, idx);


%

[labelled, num] = bwlabel(bw_fats,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength', 'Orientation'});

orient_angle = STATS.Orientation;

cent1_x = STATS.Centroid(1) + ( 0.25 * STATS.MajorAxisLength * cosd(orient_angle) ); 
cent1_y = STATS.Centroid(2) + (0.25 * STATS.MajorAxisLength * sind(orient_angle) );

cent2_x = STATS.Centroid(1) - ( 0.25 * STATS.MajorAxisLength * cosd(orient_angle) );
cent2_y = STATS.Centroid(2) - (0.25 * STATS.MajorAxisLength * sind(orient_angle) );

%------------

%draw the circles

%centers = cat(1, STATS.Centroid);
%majorAx = cat(1, STATS.MajorAxisLength);
%minorAx = cat(1, STATS.MinorAxisLength);
%diameters = mean([majorAx minorAx], 2);
%[radii] = diameters/2;

%temp for testing --- 
% the centroid seems ON POINT, 
% but the areas of the circles are crap
centers = cat(1, [cent1_x cent1_y], [cent2_x cent2_y])
majorAx = cat(1, STATS.MajorAxisLength/2);
minorAx = cat(1, STATS.MinorAxisLength/2);
both_axes = cat(1, [majorAx minorAx], [majorAx minorAx]);
diameters = mean(both_axes, 2);
[radii] = diameters/2;

imshow(bw_fats);

hold on
viscircles(centers, radii);
hold off





