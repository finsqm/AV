%[img_cell, norm_img_cell, hsv_img_cell, bg_img_cell] = getAllImages();

show = 1;

for i = 2 : 2
    
[ centers, radii ] = extractDancers( i , bg_img_cell, hsv_img_cell );

[N, ~] = size(centers);

hists = [];
small_norms = cell(4);

%hsv = hsv_img_cell{i};

%v_mean = mean(mean(hsv(:,:,3)));

%H = hsv(:,:,1);
%S = hsv(:,:,2);
%V = hsv(:,:,3);

%norm_hsv(:,:,1) = H;
%norm_hsv(:,:,2) = S;
%norm_hsv(:,:,3) = repmat(v_mean,480,640);

%norm_rgb = hsv2rgb(norm_hsv);


% TODO
% ---------------------
% WILL HAVE TO normalize each histogram over the sum of the histogram
% so num in each bin will be between 0 - 1
%
% idea: concat r and g histograms (512 bins)
% 
% ---------------------

for j = 1 : N
    small_norm = norm_img_cell{i}(centers(j,2) - radii(j) : centers(j,2) + radii(j),...
        centers(j,1) - radii(j) : centers(j,1) + radii(j),:);
    small_norm = floor((small_norm * 255));
    figure
    [ hist ] = getRGBhists( small_norm, show );
    small_norms {j} = small_norm;
end

end