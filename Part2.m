startup()

% Read image from file
inputImage  = imread('inputs/im01.jpg');
grayImage   = single(rgb2gray(inputImage));
image(inputImage);

% Get SIFT descriptor
[frame, descriptor] = vl_sift(grayImage);

% Display a 50 random features
perm = randperm(size(frame, 2));
sel = perm(1:50);

h1 = vl_plotframe(frame(:,sel));
h2 = vl_plotframe(frame(:,sel));
set(h1, 'color', 'k', 'linewidth', 3) ;
set(h2, 'color', 'y', 'linewidth', 2) ;

h3 = vl_plotsiftdescriptor(descriptor(:,sel), frame(:,sel)) ;
set(h3,'color', 'g')