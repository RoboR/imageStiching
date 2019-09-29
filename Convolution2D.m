% kernel assume to be a 3 x 3 matrix
function convolutionOutput = Convolution2D(inputMatrix, kernel, kScale)
    scaleKernel         = imresize(kernel, kScale, 'nearest');
    [mRow, mCol]        = size(inputMatrix);
    [kRow, kCol]        = size(scaleKernel);
    rowPad              = ceil((kRow - 1) / 2);
    colPad              = ceil((kCol - 1) / 2);
    convolutionOutput   = zeros(mRow, mCol);
    paddedInput         = padarray(inputMatrix, [rowPad, colPad], 0);
    transKernel         = transpose(scaleKernel);
    for x = 1 : mCol
        for y = 1 : mRow
             convolutionOutput(y, x) = ConvolutionSum(paddedInput(y:y+kRow-1, x:x+kCol-1), transKernel);
        end
    end
end

function output = ConvolutionSum(matrixAt, transKernel)
    [row, col]      = size(matrixAt);
    output          = 0;

    for r = 1:row
         a       = matrixAt(r,:);
         b       = transKernel((r-1)*col+1 : r*col);
         output  = output + sum(a .* b);
    end
end
