function bin_img = makebin( image,threshold,colour,show )
% Creates a binary image based on the the threshold given
% image: image array
% threshold: threshold int
% colour: colour to split on 1=red,2=green,3=blue
% show: 1 if want image to print else 0

[H,W,D] = size(image);
bin_img = zeros(H,W);


for i = 1 : H
    for j = 1 : W
        if image(i,j) > threshold
            bin_img(i,j) = 1;
        else
            bin_img(i,j) = 0;
        end
    end
end

if show > 0
    imshow(image)
    figure
    imshow(bin_img)
end


end

