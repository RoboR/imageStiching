function homography = GetHomographySVD(x, y, xp, yp)
    format long g

    n = numel(x);
    A = zeros(n * 2, 9);

    for idx = 1 : n
        % first row : [x y 1 0 0 0 -x'x -x'y -x']
        row1Index = (idx - 1) * 2 + 1;
        A(row1Index, 1) = x(idx);
        A(row1Index, 2) = y(idx);
        A(row1Index, 3) = 1;
        A(row1Index, 4) = 0;
        A(row1Index, 5) = 0;
        A(row1Index, 6) = 0;
        A(row1Index, 7) = -1 * xp(idx) * x(idx);
        A(row1Index, 8) = -1 * xp(idx) * y(idx);
        A(row1Index, 9) = -1 * xp(idx);

        % second row : [0 0 0 x y 1 -y'x -y'y -y']
        row2Index = (idx - 1) * 2 + 2;
        A(row2Index, 1) = 0;
        A(row2Index, 2) = 0;
        A(row2Index, 3) = 0;
        A(row2Index, 4) = x(idx);
        A(row2Index, 5) = y(idx);
        A(row2Index, 6) = 1;
        A(row2Index, 7) = -1 * yp(idx) * x(idx);
        A(row2Index, 8) = -1 * yp(idx) * y(idx);
        A(row2Index, 9) = -1 * yp(idx);
    end

    [U, S, V] = svd(A);
    homography = V(:,end);
    homography = reshape(homography,3, 3);
end
