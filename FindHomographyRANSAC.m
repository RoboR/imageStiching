function [homography, index] = FindHomographyRANSAC(X, Y, XP, YP)
    ITERATION               = 50;
    RANDOM_SELECTED_POINTS  = 5;
    INLIER_DISTANCE         = 25;

    maxInliersFound =  0;
    inliersIndex    = [];
    bestHomography  = eye(3);
    % Run the algorithm for I interations
    for itr = 1 : ITERATION
        matchedNum      = numel(XP);
        selectedIndex   = randperm(matchedNum, RANDOM_SELECTED_POINTS);
        x               = zeros(1, RANDOM_SELECTED_POINTS);
        y               = zeros(1, RANDOM_SELECTED_POINTS);
        xp              = zeros(1, RANDOM_SELECTED_POINTS);
        yp              = zeros(1, RANDOM_SELECTED_POINTS);

        % Randomly select R points from the set
        for r = 1:RANDOM_SELECTED_POINTS
            x(r)  = X(selectedIndex(r));
            y(r)  = Y(selectedIndex(r));
            xp(r) = XP(selectedIndex(r));
            yp(r) = YP(selectedIndex(r));
        end

        % Compute homography of the random selected points
        homography = GetHomographySVD(x, y, xp, yp);

        inlierCount = 0;
        inlierFound = [];
        % Compute inliers for L2 norm within E
        for in = 1:matchedNum
            point   = [X(in) Y(in) 1];
            pointP  = [XP(in) YP(in)];
            pointH  = point * homography;
            pointH  = pointH / pointH(3);
            pointH  = pointH(1:2);

            % Get L2 norm between transform and matched point
            l2 = norm(pointP - pointH, 2);
            if l2 <= INLIER_DISTANCE
                inlierCount = inlierCount + 1;
                inlierFound = [inlierFound, in];
            end
        end

        % Update best homography
        if inlierCount > maxInliersFound
            maxInliersFound = inlierCount;
            inliersIndex    = inlierFound;
            bestHomography  = homography;
        end
    end

    homography  = bestHomography;
    index       = inliersIndex;
end
