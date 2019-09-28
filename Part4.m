clc;

% % Read Image and prompt user for 4 points
imageOne = imread("inputs/im01.jpg");
subplot(2, 2, 1), imshow(imageOne), title("Select 4 Homography points");
hold on;
imageTwo = imread("inputs/im02.jpg");
subplot(2, 2, 2), imshow(imageTwo), title("Select 4 Homography points");
hold on;
[imageOnePointsX, imageOnePointsY] = GetAndDrawPoints(4);
[imageTwoPointsX, imageTwoPointsY] = GetAndDrawPoints(4); 
x  = imageTwoPointsX
y  = imageTwoPointsY
xp = imageOnePointsX
yp = imageOnePointsY

format long g
% Compute homography matrix
images              = {imageOne imageTwo};
numImages           = numel(images);
tforms(numImages)   = projective2d(eye(3));
imageSize           = zeros(numImages, 3);
for n = 2:numImages
    I               = images{n};   
    imageSize(n,:)  = size(I);
end

tforms(2) = GetHomography(x, y, xp, yp);

% Compute the output limits for each transform
for n = 1:numImages
    [xlim(n, :), ylim(n, :)] = outputLimits(tforms(n), ...
                                            [1 imageSize(n, 2)], ...
                                            [1 imageSize(n, 1)]);    
end

% Ready a canvas that fits all the image
maxImageSize    = max(imageSize);
xMin            = min([1; xlim(:)]);
xMax            = max([maxImageSize(2); xlim(:)]);
yMin            = min([1; ylim(:)]);
yMax            = max([maxImageSize(1); ylim(:)]);
canvasWidth     = round(xMax - xMin);
canvasHeight    = round(yMax - yMin);

panorama = zeros([canvasHeight canvasWidth 3], 'like', imageOne);
blender  = vision.AlphaBlender('Operation', 'Binary mask', ...
                               'MaskSource', 'Input port');
xLimits  = [xMin xMax];
yLimits  = [yMin yMax];
panoramaView = imref2d([canvasHeight canvasWidth], xLimits, yLimits);

% Stitch the image
for n = 1:numImages    
    I = images{n};   
    warpedImage = imwarp(I, tforms(n), 'OutputView', panoramaView);                  
    mask        = imwarp(true(size(I, 1), size(I, 2)), tforms(n), ...
                         'OutputView', panoramaView);
    panorama    = step(blender, panorama, warpedImage, mask);
end

subplot(2, 2, 3), imshow(panorama), title("Stitch image");
