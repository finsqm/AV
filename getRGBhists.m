function [ hists ] = getRGBhists( img, show )
% Returns hists of norm RGB images


%hist_r = dohist(img1, show);
%hist_g = dohist(img2, show);

%hists = vertcat(hist_r, hist_g);

hist_r = dohist(img(:,:,1), show);
hist_g = dohist(img(:,:,2), show);

hists = vertcat(hist_r, hist_g);
