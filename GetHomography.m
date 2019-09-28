function homography = GetHomography(x, y, xp, yp)
%CALCULATEHOMOGRAPHY Summary of this function goes here
%   Detailed explanation goes here
    format long g

    affineMatrix        = zeros(8, 8);
    transformedCoor     = [xp(1); yp(1); xp(2); yp(2); 
                           xp(3); yp(3); xp(4); yp(4)];

    for idx = 1 : 4
        % first row : [x y 1 0 0 0 -x'x -x'y]
        row1Index = (idx - 1) * 2 + 1;
        affineMatrix(row1Index, 1) = x(idx);
        affineMatrix(row1Index, 2) = y(idx);
        affineMatrix(row1Index, 3) = 1;
        affineMatrix(row1Index, 4) = 0;
        affineMatrix(row1Index, 5) = 0;
        affineMatrix(row1Index, 6) = 0;
        affineMatrix(row1Index, 7) = -1 * xp(idx) * x(idx);
        affineMatrix(row1Index, 8) = -1 * xp(idx) * y(idx);

        % second row : [0 0 0 x y 1 -y'x -y'y]
        row2Index = (idx - 1) * 2 + 2;
        affineMatrix(row2Index, 1) = 0;
        affineMatrix(row2Index, 2) = 0;
        affineMatrix(row2Index, 3) = 0;
        affineMatrix(row2Index, 4) = x(idx);
        affineMatrix(row2Index, 5) = y(idx);
        affineMatrix(row2Index, 6) = 1;
        affineMatrix(row2Index, 7) = -1 * yp(idx) * x(idx);
        affineMatrix(row2Index, 8) = -1 * yp(idx) * y(idx);
    end

    hEquiv    = (inv(affineMatrix) * transformedCoor);
    h33       = sqrt(1 / (sum(hEquiv .^2) + 1));
    hMatrix   = [hEquiv(1), hEquiv(4), hEquiv(7);
                 hEquiv(2), hEquiv(5), hEquiv(8);
                 hEquiv(3), hEquiv(6), 1];
    hMatrix   = hMatrix .* h33;

    homography = hMatrix;
end
