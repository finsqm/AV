function  label = classify_colour( svm, test )
% Given a trained svm this function classifies test images into suit colours
% BLACK = 1
% RED = 0
% svm: trained SVM
% test: cell array of test images

[N, ~] = size(test);
X = zeros(N, 1);

for i = 1 : N
    
    % Make X (feature vectors) - histogram of hue values, 100 bins
    img = test{i};
    red_img = img(:,:,1);
    green_img = img(:,:,2);
    blue_img = img(:,:,3);
    
    
    r = red_img ./ (red_img + green_img + blue_img);
    
    r_sum = sum(sum(r));
    
    X(i) = r_sum;
    
    
end

[label,~] = predict(svm,X);



end

