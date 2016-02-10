% extracts the center (cc,cr) and radius of the largest blob
% flag = 0 if failure
function [ccs,crs,radii]=extract_dancers(Imwork,Imback,index)
  
  ccs = 0;
  crs = 0;
  radii=0;

  [MR,MC,Dim] = size(Imback);

  % subtract background & select pixels with a big difference
  fore = zeros(MR,MC);
  fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > 2) ...
     | (abs(Imwork(:,:,2) - Imback(:,:,2)) > 2) ...
     | (abs(Imwork(:,:,3) - Imback(:,:,3)) > 2);

  % erode to remove small noise
  foremm = bwmorph(fore,'erode',2);
  
  imshow(foremm)

  % select largest object
  labeled = bwlabel(foremm,4);
  stats = regionprops(labeled,['basic']);
  [N,W] = size(stats);
  if N < 1
    return   
  end

  % do bubble sort (large to small) on regions in case there are more than 1
  id = zeros(N);
  for i = 1 : N
    id(i) = i;
  end
  for i = 1 : N-1
    for j = i+1 : N
      if stats(i).Area < stats(j).Area
        tmp = stats(i);
        stats(i) = stats(j);
        stats(j) = tmp;
        tmp = id(i);
        id(i) = id(j);
        id(j) = tmp;
      end
    end
  end

  % make sure that there is at least 1 big region
  if stats(1).Area < 100 
    return
  end
  selected = (labeled==id(1));
  if fig3 > 0
    figure(fig3)
    clf
    imshow(selected)
  end

  % get center of mass and radius of largest
  centroid = stats(1).Centroid;
  radii = sqrt(stats(1).Area/pi);
  ccs = centroid(1);
  crs = centroid(2);
  return