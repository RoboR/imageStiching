function homography = GetHomographySVD(x1, x2, x3, x4, y1, y2, y3, y4, ...
                                       xp1, xp2, xp3, xp4, yp1, yp2, yp3, yp4)
%This function will find the homography betweeb 4 points using svd
    A=[
    x1  y1  1   0   0  0  -x1*xp1  -y1*xp1  -xp1;
     0   0   0 x1  y1  1  -x1*yp1  -y1*yp1  -yp1;
    x2  y2  1   0   0  0  -x2*xp2  -y2*xp2  -xp2;
     0   0   0 x2  y2  1  -x2*yp2  -y2*yp2  -yp2;
    x3  y3  1   0   0  0  -x3*xp3  -y3*xp3  -xp3;
     0   0   0 x3  y3  1  -x3*yp3  -y3*yp3  -yp3;
    x4  y4   1  0   0  0  -x4*xp4  -y4*xp4  -xp4;
     0   0   0 x4  y4  1  -x4*yp4  -y4*yp4  -yp4];

    [U, S, V] = svd(A);
    homography = V(:,end);
    homography = reshape(homography,3,3);
end