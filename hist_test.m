
% IDEAS:

% - when people start hugging (big blobs), don't just halve the area - we
% know the area should be about 1000...
% - handle 3 guys hugging
% - consider location of people to do tracking (what about skips in the
% frames?)
% - 


%[img_cell, norm_img_cell, hsv_img_cell, bg_img_cell] = getAllImages();

show = 0;

start = 1;

for img_idx = start : 210
    
[ centers, radii ] = extractDancers( img_idx , bg_img_cell, hsv_img_cell );

[N, ~] = size(centers);

hists = [];
small_norms = cell(4);
norm_hists = [];


for j = 1 : N
    
    % instead of getting square around person, 
    % use the actual pixel list
    %this_pixelIdxs = pixelIdxList{j};
    
    %small_norm = norm_img_cell{img_idx}(this_pixelIdxs);
    
    %small_norm_r = norm_img_cell{img_idx}(:,:,1);
    %small_norm_r = small_norm_r(this_pixelIdxs);
    
    %small_norm_g = norm_img_cell{img_idx}(:,:,1);
    %small_norm_g = small_norm_g(this_pixelIdxs);
    
    %small_norm_r = floor((small_norm_r * 255));
    %small_norm_g = floor((small_norm_g * 255));
    
    %---------------------------------
    % just get the SQUARE around the detected person
    
    c1 = floor(centers(j,1));
    c2 = floor(centers(j,2));
    if img_idx == start && j == 1
        r1 = floor(radii(j));
    end
    small_norm = norm_img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    
    small_norm = floor((small_norm * 255));
    
    %only get the object from small_norm (remove the background)
    %small_bg = bg_img_cell{2}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %small_hsv = hsv_img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %small_img = img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %a_norm = small_norm - small_bg;
    a_norm = small_norm;
    
    %----------------------------------
    
    
    % ---------------------------
    %add weights to the img values based on dist from center
    %a_norm_dists = sqrt(sum((a_norm - floor(centers(j,:))) .^ 2));
    %sigma = 20;
    %win = fspecial('gaussian', size(a_norm,1), sigma);
    %win = win ./ max(win(:));
    
    %a_norm = a_norm .* repmat(win, [1,1,3]);
    %a_norm = a_norm ./ size(a_norm,1)^2;
    %a_norm = floor(a_norm .* 255);
    %imshow(a_norm);
    
    % -----------------------
    
    %figure
    [ hist ] = getRGBhists( a_norm, show );
    %[ hist ] = getRGBhists(small_norm_r, small_norm_g, show);
    hists = [hists hist];
    
    norm_hist = hist ./ sum(hist);
    norm_hists = [norm_hists norm_hist];
    
    small_norms{j} = small_norm;
end

dists = cell(4);
post_dists = cell(4);

% set initial labels
if (img_idx == start)
   person1 = norm_hists(:,1);
   person1_center = centers(1,:);
   person1_radius = radii(1);
   prev1 = person1;
   
   prev_pos1 = person1_center;
   
   person2 = norm_hists(:,2);
   person2_center = centers(2,:);
   person2_radius = radii(2);
   prev2 = person2;
   
   prev_pos2 = person2_center;
   
   person3 = norm_hists(:,3);
   person3_center = centers(3,:);
   person3_radius = radii(3);
   prev3 = person3;
   
   prev_pos3 = person3_center;
   
   person4 = norm_hists(:,4);
   person4_center = centers(4,:);
   person4_radius = radii(4);
   prev4 = person4;
   
   prev_pos4 = person4_center;
else
    
    for d = 1 : 4
       d1 = histdist(norm_hists(:,d), prev1);
       d2 = histdist(norm_hists(:,d), prev2);
       d3 = histdist(norm_hists(:,d), prev3);
       d4 = histdist(norm_hists(:,d), prev4);
       
       dpos1 = sqrt(sum((centers(d,:) - prev_pos1) .^ 2));
       dpos2 = sqrt(sum((centers(d,:) - prev_pos2) .^ 2));
       dpos3 = sqrt(sum((centers(d,:) - prev_pos3) .^ 2));
       dpos4 = sqrt(sum((centers(d,:) - prev_pos4) .^ 2));
       
       norm_dpos_sum = sum([dpos1 dpos2 dpos3 dpos4]);
       
       dpos1 = dpos1 / norm_dpos_sum;
       dpos2 = dpos2 / norm_dpos_sum;
       dpos3 = dpos3 / norm_dpos_sum;
       dpos4 = dpos4 / norm_dpos_sum;
       
       pos_dists{d} = [dpos1, dpos2, dpos3, dpos4];
       
       dists{d} = [d1, d2, d3, d4];
    end
    
    all_perms = perms([1 2 3 4]);
    
    min_score = 100000; % because max score can only be 4...
    
    for p = 1 : size(all_perms, 1)
       this_perm = all_perms(p,:);
       %score = sum([ dists{1}(this_perm(1)) dists{2}(this_perm(2)) ...
       %                 dists{3}(this_perm(3)) dists{4}(this_perm(4)) ]);
                    
       hist_dists_sum = sum([ dists{1}(this_perm(1)) dists{2}(this_perm(2)) ...
                     dists{3}(this_perm(3)) dists{4}(this_perm(4)) ]);
       
       pos_dists_sum = sum([pos_dists{1}(this_perm(1)) pos_dists{2}(this_perm(2)) ...
                      pos_dists{3}(this_perm(3)) pos_dists{4}(this_perm(4))]);
                    
                    
       hw = 0.9;
       hist_dists_sum = hw * hist_dists_sum;
       pos_dists_sum = (1-hw) * pos_dists_sum;
       score = sum([ hist_dists_sum pos_dists_sum]);
                    
       if score < min_score
          min_score = score; 
          min_perm = this_perm;
       end
    end
    
   person1 = norm_hists(:,find(min_perm == 1));
   person1_center = centers(find(min_perm == 1),:);
   person1_radius = radii(find(min_perm == 1));
   prev1 = person1;
   
   prev_pos1 = person1_center;
   
   person2 = norm_hists(:,find(min_perm == 2));
   person2_center = centers(find(min_perm == 2),:);
   person2_radius = radii(find(min_perm == 2));
   prev2 = person2;
   
   prev_pos2 = person2_center;
   
   person3 = norm_hists(:,find(min_perm == 3));
   person3_center = centers(find(min_perm == 3),:);
   person3_radius = radii(find(min_perm == 3));
   prev3 = person3;
   
   prev_pos3 = person3_center;
   
   person4 = norm_hists(:,find(min_perm == 4));
   person4_center = centers(find(min_perm == 4),:);
   person4_radius = radii(find(min_perm == 4));
   prev4 = person4;
   
   prev_pos4 = person4_center;

end


imshow(img_cell{img_idx});
hold on
viscircles(person1_center, person1_radius, 'EdgeColor', 'b');
viscircles(person2_center, person2_radius, 'EdgeColor', 'r');
viscircles(person3_center, person3_radius, 'EdgeColor', 'g');
viscircles(person4_center, person4_radius, 'EdgeColor', 'y');
hold off

w = waitforbuttonpress;

end