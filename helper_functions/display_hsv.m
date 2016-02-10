%% convert and display a loaded image in HSV form

% Author / Copyright: T. Breckon, Jan. 2006.
% License: http://www.gnu.org/licenses/gpl.txt

function display_hsv(Image)

%% set display prefs.

iptsetpref('ImshowBorder', 'tight');
iptsetpref('ImshowAxesVisible', 'off');
iptsetpref('ImshowInitialMagnification', 100);
figure(1);
set(1, 'MenuBar', 'none');
set(1, 'ToolBar', 'none');
set(1, 'Name', 'HSV Component Separation');

%% get image size and set up channel a mask of appropriate size

[sizeX, sizeY, colourDepth] = size(Image);

if (colourDepth ~= 3)
    display 'Error: image not an RGB image'
    return
end

mask = ones(sizeX,sizeY);

%% display RGB image

figure(1);
subplot(2, 2, 1);
imshow(Image);
xlabel('RGB Image');

%%convert to HSV

Ihsv = rgb2hsv(Image);

%% display Hue (set S and V to 1 and convert back to RGB for visualisation)

IHue = Ihsv;
IHue(:,:,2) = mask;
IHue(:,:,3) = mask;
   
IHue = hsv2rgb(IHue);
   
subplot(2, 2, 2);
imshow(IHue);
xlabel('Hue (Saturation = 1.0, Variance = 1.0)');
truesize;

%% display Saturation (just as greyscale for visualisation)

subplot(2, 2, 3);
imshow(Ihsv(:,:,2));
xlabel('Saturation (as greyscale intensity)');
truesize;

%% display Variance (just as greyscale for visualisation)
   
subplot(2, 2, 4);  
imshow(Ihsv(:,:,3));
xlabel('Variance (as greyscale intensity)');
truesize;
