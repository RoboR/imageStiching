function [x, y] = GetAndDrawPoints(numOfTimes)
    for idx = 1 : numOfTimes
        [x(idx), y(idx)] = ginput(1);
        plot(x, y, 'X', 'LineWidth', 2, 'MarkerSize', 16, 'Color', 'magenta');
    end
end