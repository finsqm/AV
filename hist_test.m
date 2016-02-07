%[img_cell, norm_img_cell, hsv_img_cell, bg_img_cell] = getAllImages();

show = 1;

for i = 1 : 1
    
[ centers, radii ] = extractDancers( i , bg_img_cell, hsv_img_cell );

[N, ~] = size(centers);

hists = [];
small_norms = cell(4);
norm_hists = [];


for j = 1 : N
    c1 = floor(centers(j,1));
    c2 = floor(centers(j,2));
    r1 = floor(radii(j));
    
    small_norm = norm_img_cell{i}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    
    small_norm = floor((small_norm * 255));
    figure
    [ hist ] = getRGBhists( small_norm, show );
    hists = [hists hist];
    
    norm_hist = hist ./ max(hist);
    norm_hists = [norm_hists norm_hist];
    
    small_norms{j} = small_norm;
end

% set initial labels
if (img_idx == 1)
   person1 = norm_hists(:,1);
   person1_center = centers(1,:);
   person1_radius =
   person2 = norm_hists(:,2);
   person3 = norm_hists(:,3);
   person4 = norm_hists(:,4);
else
    
end

imshow(img_cell{img_idx});
hold on
viscircles(
hold off

% to get distance between hists (bhata... distance) :
% dist = sum(sqrt(norm_hists(:,1)).*sqrt(norm_hists(:,2)))

%next steps:
% now have normalized histogram for each person in each image
% will compare the individual histograms from the prev image to the 
% current image to try to identify which person is which
% will need 4 labels (ie four different coloured circles)
% 


end