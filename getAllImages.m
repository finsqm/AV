function [img_cell, norm_img_cell, hsv_img_cell, bg_img_cell] = getAllImages()
%getAllImages returns all images in a 210*480*640*3 cell

img_cell = cell(210);
norm_img_cell = cell(210);
hsv_img_cell = cell(210);
bg_img_cell = cell(3);

for i = 1 : 211
    
    if i == 211
        filename = 'DATA1/bgframe.jpg';
    else
        filename = strcat('DATA1/frame', int2str(109+i), '.jpg');
    end
    
    img = imread(filename);


    %Normalize image
    R = double(img(:,:,1));
    G = double(img(:,:,2));
    B = double(img(:,:,3));

    NormalizedRed = R(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);
    NormalizedGreen = G(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);
    NormalizedBlue = B(:,:)./sqrt(R(:,:).^2+G(:,:).^2+B(:,:).^2);
    
    
    norm(:,:,1) = NormalizedRed(:,:);
    norm(:,:,2) = NormalizedGreen(:,:);
    norm(:,:,3) = NormalizedBlue(:,:);
    
    if i == 211
        bg_img_cell{1} = img;
        bg_img_cell{2} = norm;
        bg_img_cell{3} = rgb2hsv(img);
    else
        img_cell{i} = img;
        norm_img_cell{i} = norm;
        hsv_img_cell{i} = rgb2hsv(img);
    end    
    
end



end

