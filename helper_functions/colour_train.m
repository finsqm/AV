function svm = colour_train( img_cell , gt_training )
% Returns SVM binary classifier for deciding if image is a red suit or a black suit
% img_cell: cell array of all training images
% gt_training: 2D, each row describes image, suit 1st element, value 2nd

[N, ~] = size(gt_training);

y = zeros(N,1);
X = zeros(N,1);

for i = 1 : N
    
    % Make y (class labels) BLACK=1 RED=0
    suit = gt_training(i,1);
    y(i) = mod(suit,2);
    
    % Make X (feature vectors) - histogram of hue values, 100 bins
    img = img_cell{i};
    red_img = img(:,:,1);
    green_img = img(:,:,2);
    blue_img = img(:,:,3);
    
    
    r = red_img ./ (red_img + green_img + blue_img);
    
    r_sum = sum(sum(r))
    
    X(i) = r_sum;
    
end

svm = fitcsvm(X,y);
    
end