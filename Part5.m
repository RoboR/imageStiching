clc;
clear;
startup();

% Read Image
imageOne = imread("inputs/im01.jpg");
imageTwo = imread("inputs/im02.jpg");
combImg  = imfuse(imageOne, imageTwo, 'montage');
subplot(3, 1, 1), imshow(combImg), title("SIFT matched points");

% Get SIFT descriptor
I1                  = single(rgb2gray(imageOne));
[frame1, desc1]     = vl_sift(I1);
I2                  = single(rgb2gray(imageTwo));
[frame2, desc2]     = vl_sift(I2);
matches             = KeypointMatching(desc1, desc2);

% draw matched descriptor
imgOneSize = size(I1, 2) ;
line([frame1(1, matches(1,:)); frame2(1, matches(2,:)) + imgOneSize], ...
     [frame1(2, matches(1,:)); frame2(2, matches(2,:))])

% Compute RANSAC
x   = [frame2(1, matches(2, :))];
y   = [frame2(2, matches(2, :))];
xp  = [frame1(1, matches(1, :))];
yp  = [frame1(2, matches(1, :))];
[homography, idx] = FindHomographyRANSAC(x, y, xp, yp);

% Draw matched inliners
sizeRan = numel(idx);
xRan    = zeros(1, sizeRan);
yRan    = zeros(1, sizeRan);
xpRan   = zeros(1, sizeRan);
ypRan   = zeros(1, sizeRan);
for i = 1:sizeRan
    xRan    = round(x(idx));
    yRan    = round(y(idx));
    xpRan   = round(xp(idx));
    ypRan   = round(yp(idx));
end
subplot(3, 1, 2), imshow(combImg), title("RANSAC SIFT points");
line([xRan + imgOneSize; xpRan], ...
     [yRan; ypRan]) ;

% Stitch the image
images              = {imageOne imageTwo};
numImages           = numel(images);
tforms(numImages)   = projective2d(eye(3));
imageSize           = zeros(numImages, 3);
for n = 2:numImages
    I               = images{n};
    imageSize(n,:)  = size(I);
end
tforms(2) = homography;

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

panorama = zeros([canvasHeight canvasWidth 3], 'uint8');
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

subplot(3, 1, 3), imshow(panorama), title("Stitch image");
