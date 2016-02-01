I = imread('train1.jpg');
BW = edge(rgb2gray(I), 'canny');
imshow(BW);
BW2 = bwareaopen(BW, 700);
BW3 = imfill(BW2, 'holes');
[B,L] = bwboundaries(BW2,'noholes');
% Display the label matrix and draw each boundary
figure; imshow(I)
hold on
boundary = B{1};
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 5)
[ height_min, height_max, width_min, width_max ] = corners( boundary );

crop = I(height_min:height_max, width_min:width_max, :);
hsv = rgb2hsv(crop);
sat = hsv(:,:,2);
figure; imshow(sat)

svm = colour_train( img_cell , gt_training );