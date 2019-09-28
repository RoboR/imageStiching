clc;
% Read Image and prompt user for 4 points
imageOne = imread("inputs/h1.jpeg");
subplot(2, 2, 1), imshow(imageOne), title("Select 4 Homography points");
hold on;

imageTwo = imread("inputs/h2.jpeg");
subplot(2, 2, 2), imshow(imageTwo), title("Select 4 Homography points");
hold on;

[imageOnePointsX, imageOnePointsY] = GetAndDrawPoints(4);
[imageTwoPointsX, imageTwoPointsY] = GetAndDrawPoints(4);

x  = imageOnePointsX;
y  = imageOnePointsY;
xp = imageTwoPointsX;
yp = imageTwoPointsY;

% Compute homography matrix
homography = GetHomography(x, y, xp, yp);
homography = homography / homography(3, 3);

% Apply transform
homography(7) = 0;
homography(8) = 0;
imageOneTrans = imtransform(imageOne, maketform('affine', homography));
subplot(2, 2, 3), imshow(imageOneTrans);