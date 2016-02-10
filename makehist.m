[N, ~] = size(centers);

hists = [];
small_norms = cell(4);
norm_hists = [];


for j = 1 : N
    c1 = floor(centers(j,1));
    c2 = floor(centers(j,2));
    r1 = floor(radii(j));
    
    small_norm = img_cell{1}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    small_bg = bg_img_cell{1}(c2-r1 : c2+r1, c1-r1 : c1+r1, :);
    %small_norm = floor((small_norm * 255));
    small_norms{j} = small_norm;
    [ hist ] = getRGBhists( small_norm, 1 );
    hists = [hists hist];
    
    norm_hist = hist ./ sum(hist);
    norm_hists = [norm_hists norm_hist];
    
    small_norms{j} = small_norm;
end