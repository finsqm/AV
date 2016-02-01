function  label = classify_colour( svm, test )
% Given a trained svm this function classifies test images into suit colours
% BLACK = 1
% RED = 0
% svm: trained SVM
% test: cell array of test images

[N, ~] = size(test);
X = zeros(N, 3);

for i = 1 : N
    
    img = test{i};
    r = sum(sum(img(:,:,1)));
    g = sum(sum(img(:,:,2)));
    b = sum(sum(img(:,:,3)));
    X(i,:) = [double(r) double(g) double(b)];
    
end

[label,~] = predict(svm,X);



end

