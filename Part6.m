clc;
clear;
startup();

imagePath           = ["inputs/im01.jpg", ...
                       "inputs/im02.jpg", ...
                       "inputs/im03.jpg", ...
                       "inputs/im04.jpg", ...
                       "inputs/im05.jpg"];

totalImage          = numel(imagePath);
images              = cell(totalImage, 1);
tforms(totalImage)  = projective2d(eye(3));
imageSize           = zeros(totalImage, 3);

% Read Image
for n = 1 : totalImage
    imgRead         = imread(imagePath(n));
    images{n}       = imgRead;
    imageSize(n,:)  = size(imgRead);
end
subplot(2, 1, 1), montage(imagePath), title("Images use to form the panorama image");

% Get SIFT descriptor
frame   = cell(totalImage, 1);
desc    = cell(totalImage, 1);
for n = 1 : totalImage
    I = single(rgb2gray(images{n}));
    [frame{n}, desc{n}] = vl_sift(I);
end

% Get transformation between images, final transformation is respect to the
% first image
for n = 2 : totalImage
    matches             = KeypointMatching(desc{n-1}, desc{n});

    % Compute RANSAC to find optimal transformation
    x = [frame{n}(1, matches(2, :))];
    y = [frame{n}(2, matches(2, :))];
    xp  = [frame{n-1}(1, matches(1, :))];
    yp  = [frame{n-1}(2, matches(1, :))];

    [homography, idx]   = FindHomographyRANSAC(x, y, xp, yp);
    tforms(n).T         = homography * tforms(n-1).T;
end

% Compute the output limits for each transform
for n = 1 : totalImage
    [xlim(n, :), ylim(n, :)] = outputLimits(tforms(n), ...
                                            [1 imageSize(n, 2)], ...
                                            [1 imageSize(n, 1)]);
end

% Transform in respect to the middle image
centerIdx       = floor((totalImage + 1)/ 2);
[~, idx]        = sort([mean(xlim, 2)]);
centerImageIdx  = idx(centerIdx);
centerTFormInv  = invert(tforms(centerIdx));

for n = 1 : totalImage
    tforms(n).T = tforms(n).T * centerTFormInv.T;
end
for n = 1 : totalImage
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
for n = 1 : totalImage
    I = images{n};
    warpedImage = imwarp(I, tforms(n), 'OutputView', panoramaView);
    mask        = imwarp(true(size(I, 1), size(I, 2)), tforms(n), ...
                         'OutputView', panoramaView);
    panorama    = step(blender, panorama, warpedImage, mask);
end

subplot(2, 1, 2), imshow(panorama), title("Panoramic image");
