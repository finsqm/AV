function img_cell = load_test()
% function for loading test data
% no args

img_cell = cell(32);

for i = 1 : 32
    
    img = sprintf('data/test/test%d.jpg',i);
    img_cell{i} = im2double(imread(img));
    
end


end

