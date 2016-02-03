
thres = 0.25;


a_hsv = hsv_img_cell{1};
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

imshow(a_bw);

[labelled, num] = bwlabel(a_bw,4);

STATS = regionprops(labelled, {'Area', 'BoundingBox', 'Centroid', 'Solidity', 'MajorAxisLength',... 
    'MinorAxisLength'});

centers = cat(1, STATS.Centroid);
majorAx = cat(1, STATS.MajorAxisLength);
minorAx = cat(1, STATS.MinorAxisLength);
diameters = mean([majorAx minorAx], 2);
[radii] = diameters/2;

%only find the indexes of the objects which are big enough
idx = find([STATS.Area] > 800);
bw2 = ismember(labelled, idx);


hold on
viscircles(centers, radii);
hold off
