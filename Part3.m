clc;
% Read Image and prompt user for 4 points
imageOne = imread("inputs/h1.jpeg");
subplot(2, 2, 1), imshow(imageOne), ...
    title("Select 4 Homography points from Image 1");
hold on;

imageTwo = imread("inputs/h2.jpeg");
subplot(2, 2, 2), imshow(imageTwo), ...
    title("Select 4 Homography points from Image 2");
hold on;

[imageOnePointsX, imageOnePointsY] = GetAndDrawPoints(4);
[imageTwoPointsX, imageTwoPointsY] = GetAndDrawPoints(4);

x  = imageOnePointsX;
y  = imageOnePointsY;
xp = imageTwoPointsX;
yp = imageTwoPointsY;

% Compute homography matrix
homography      = GetHomography(x, y, xp, yp);
invHomography   = inv(homography);
homography      = homography / homography(3, 3);
invHomography   = invHomography / invHomography(3, 3);

% Apply transform
homography(7) = 0;
homography(8) = 0;
imageOneTrans = imtransform(imageOne, maketform('affine', homography), 'xyscale', 1);
subplot(2, 2, 3), imshow(imageOneTrans), title("Transformed Image 1");

invHomography(7) = 0;
invHomography(8) = 0;
imageTwoTrans = imtransform(imageTwo, maketform('affine', invHomography), 'xyscale', 1);
subplot(2, 2, 4), imshow(imageTwoTrans), title("Transformed Image 2");