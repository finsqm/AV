
% IDEAS:
% - do not just take square around detected person - floor affects the hist
% too much
% - when people start hugging (big blobs), don't just halve the area - we
% know the area should be about 1000...
%nice ideas


%[img_cell, norm_img_cell, hsv_img_cell, bg_img_cell] = getAllImages();

show = 0;

for img_idx = 1 : 210
    
[ centers, radii ] = extractDancers( img_idx , bg_img_cell, hsv_img_cell );

[N, ~] = size(centers);

hists = [];
small_norms = cell(4);
norm_hists = [];


for j = 1 : N
    c1 = floor(centers(j,1));
    c2 = floor(centers(j,2));
    r1 = floor(radii(j));
    
    small_norm = norm_img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    
    small_norm = floor((small_norm * 255));
    
    %only get the object from small_norm (remove the background)
    small_bg = bg_img_cell{2}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %small_hsv = hsv_img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %small_img = img_cell{img_idx}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    a_norm = small_norm - small_bg;
    
    
    %figure
    [ hist ] = getRGBhists( a_norm, show );
    hists = [hists hist];
    
    norm_hist = hist ./ sum(hist);
    norm_hists = [norm_hists norm_hist];
    
    small_norms{j} = small_norm;
end

dists = cell(4);

% set initial labels
if (img_idx == 1)
   person1 = norm_hists(:,1);
   person1_center = centers(1,:);
   person1_radius = radii(1);
   prev1 = person1;
   
   person2 = norm_hists(:,2);
   person2_center = centers(2,:);
   person2_radius = radii(2);
   prev2 = person2;
   
   person3 = norm_hists(:,3);
   person3_center = centers(3,:);
   person3_radius = radii(3);
   prev3 = person3;
   
   person4 = norm_hists(:,4);
   person4_center = centers(4,:);
   person4_radius = radii(4);
   prev4 = person4;
else
    
    for d = 1 : 4
       d1 = histdist(norm_hists(:,d), prev1);
       d2 = histdist(norm_hists(:,d), prev2);
       d3 = histdist(norm_hists(:,d), prev3);
       d4 = histdist(norm_hists(:,d), prev4);
       
       dists{d} = [d1, d2, d3, d4];
    end
    
    all_perms = perms([1 2 3 4]);
    
    min_score = 5; % because max score can only be 4...
    
    for p = 1 : size(all_perms, 1)
       this_perm = all_perms(p,:);
       score = sum([ dists{1}(this_perm(1)) dists{2}(this_perm(2)) ...
                        dists{3}(this_perm(3)) dists{4}(this_perm(4)) ]);
                    
       if score < min_score
          min_score = score; 
          min_perm = this_perm;
       end
    end
    
   person1 = norm_hists(:,min_perm(1));
   person1_center = centers(min_perm(1),:);
   person1_radius = radii(min_perm(1));
   prev1 = person1;
   
   person2 = norm_hists(:,min_perm(2));
   person2_center = centers(min_perm(2),:);
   person2_radius = radii(min_perm(2));
   prev2 = person2;
   
   person3 = norm_hists(:,min_perm(3));
   person3_center = centers(min_perm(3),:);
   person3_radius = radii(min_perm(3));
   prev3 = person3;
   
   person4 = norm_hists(:,min_perm(4));
   person4_center = centers(min_perm(4),:);
   person4_radius = radii(min_perm(4));
   prev4 = person4;

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