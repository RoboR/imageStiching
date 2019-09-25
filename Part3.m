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

% Apply transform
imageOneTrans = imtransform(imageOne, maketform('affine', homography));
subplot(2, 2, 3), imshow(imageOneTrans);


% % Using SVD
% hMatrix = homography(x1(1), x1(2), x1(3), x1(4), ...
%                      y1(1), y1(2), y1(3), y1(4), ...
%                      x2(1), x2(2), x2(3), x2(4), ...
%                      y2(1), y2(2), y2(3), y2(4));
% hMM = hMatrix / hMatrix(3, 3);
% projected_point =[1200, 1200 1] * hMM;
% hMM(7) = 0;
% hMM(8) = 0;
% a = imtransform(imageOne, maketform('affine', hMM));
% subplot(2, 2, 3), imshow(a);

% 
% function H = homography(x1, x2, x3, x4, y1, y2, y3, y4, ...
%                         xp1, xp2, xp3, xp4, yp1, yp2, yp3, yp4)
% %This function will find the homography betweeb 4 points using svd
%     A=[
%     x1  y1  1   0   0  0  -x1*xp1  -y1*xp1  -xp1;
%      0   0   0 x1  y1  1  -x1*yp1  -y1*yp1  -yp1;
%     x2  y2  1   0   0  0  -x2*xp2  -y2*xp2  -xp2;
%      0   0   0 x2  y2  1  -x2*yp2  -y2*yp2  -yp2;
%     x3  y3  1   0   0  0  -x3*xp3  -y3*xp3  -xp3;
%      0   0   0 x3  y3  1  -x3*yp3  -y3*yp3  -yp3;
%     x4  y4   1  0   0  0  -x4*xp4  -y4*xp4  -xp4;
%      0   0   0 x4  y4  1  -x4*yp4  -y4*yp4  -yp4];
% 
%     [U, S, V] = svd(A);
%     H = V(:,end);
%     H = reshape(H,3,3);
% end