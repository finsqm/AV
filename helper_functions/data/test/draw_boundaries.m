images = load_test();
N = size(images);
I = imread('00000004.jpg');
BW = edge(rgb2gray(I), 'canny');
BW2 = bwareaopen(BW, 900);
BW3 = imfill(BW2, 'holes');
[B,L] = bwboundaries(BW3,'noholes');
% Display the label matrix and draw each boundary
figure; imshow(I)
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'rx', 'LineWidth', 2)
end