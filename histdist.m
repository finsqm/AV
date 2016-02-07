function [ dist ] = histdist(h1, h2)
%UNTITLED Summary of this function goes here
%   Detailed explandation goes here

%euclidean dist
dist = sqrt(sum((h1 - h2) .^ 2));

%bhat.. dist
%dist = sum(sqrt(h1).*sqrt(h2));

end

