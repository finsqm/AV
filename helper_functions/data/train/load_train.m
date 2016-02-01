function img_cell = load_train()
% function for loading training data
% no args

img_cell = cell(32);

for i = 1 : 32
    
    img = sprintf('train%d.jpg',i);
    img_cell{i} = imread(img);
    
end


end

