
thres = 0.3;


a_hsv = hsv_img_cell{2};
a_hsv = a_hsv - bg_img_cell{3}; 

a_bw = a_hsv(:,:,2) >= thres;

se = strel('diamond', 1);
a_bw = imerode(a_bw, se);

