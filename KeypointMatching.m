function [matches] = KeypointMatching(descriptor1, descriptor2)
    [kIdx, desc1Count]    = size(descriptor1);
    [kIdx, desc2Count]    = size(descriptor2);
    matches             = [];
    iMatches            = [];
    jMatches            = [];

    % Find matches for descriptor 1
    for i = 1 : desc1Count
        iStart  = (i-1)*128 + 1;
        iEnd    = iStart + kIdx - 1;

        bestScore = intmax;
        bestMatch = 0;
        for j = 1 : desc2Count
            jStart  = (j-1)*128 + 1;
            jEnd    = jStart + kIdx - 1;
            score   = sqrt(sum(power(descriptor1(iStart:iEnd) - ...
                                     descriptor2(jStart:jEnd), 2)));

            if score < bestScore
                bestScore = score;
                bestMatch = j;
            end
        end

        iMatches = [iMatches; [i, bestMatch, bestScore]];
    end

    % Find matches for descriptor 2
    for j = 1 : desc2Count
        jStart  = (j-1) * 128 + 1;
        jEnd    = jStart + kIdx - 1;

        bestScore = intmax;
        bestMatch = 0;
        for i = 1 : desc1Count
            iStart  = (i-1)*128 + 1;
            iEnd    = iStart + kIdx - 1;
            score   = sqrt(sum(power(descriptor2(jStart:jEnd) - descriptor1(iStart:iEnd), 2)));

            if score < bestScore
                bestScore = score;
                bestMatch = i;
            end
        end
        jMatches = [jMatches; [j, bestMatch, bestScore]];
    end

    % Find common match in both matches
    for i = 1 : desc1Count
        matchedJIdx = iMatches(i, 2);
        if jMatches(matchedJIdx, 2) == i
            matches = [matches; [i, matchedJIdx]];
        end
    end

    matches = transpose(matches);
end
