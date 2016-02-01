img_cell = load_train();
test = load_test();
N = size(img_cell);
crops = cell(N);
for i = 1 : N
    I = img_cell{i};
    BW = edge(rgb2gray(I), 'canny');
    BW2 = bwareaopen(BW, 700);
    BW3 = imfill(BW2, 'holes');
    [B,~] = bwboundaries(BW2,'noholes');
    % Display the label matrix and draw each boundary
    %figure; imshow(I)
    %hold on
    boundary = B{1};
    %plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 5)
    [ height_min, height_max, width_min, width_max ] = corners( boundary );

    crop = I(height_min:height_max, width_min:width_max, :);
    crops{i} = crop;
    
    BW = im2bw(crop, graythresh(crop));
    BW2 = imcomplement(BW);
    BW3 = imfill(BW2, 'holes');
    STATS = regionprops(BW2, 'all');
            
        
    %[B,L,N,A] = bwboundaries(BW2);
    %figure, imshow(BW2); hold on;
    %colors=['b' 'g' 'r' 'c' 'm' 'y'];
    %for k=1:length(B)
    %    boundary = B{k};
    %    cidx = mod(k,length(colors))+1;
    %    plot(boundary(:,2), boundary(:,1),...
    %         colors(cidx),'LineWidth',2);
        %randomize text position for better visibility
    %    rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
    %    col = boundary(rndRow,2); row = boundary(rndRow,1);
    %    h = text(col+1, row-1, num2str(L(row,col)));
    %    set(h,'Color',colors(cidx),...
    %        'FontSize',14,'FontWeight','bold');
    %end
end

