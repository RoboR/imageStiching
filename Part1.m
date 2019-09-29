clc;
clear;
%% Kernel Types

KERNEL_SOBEL_HORIZONTAL = [ -1, -2, -1
                             0,  0,  0
                             1,  2,  1];

KERNEL_SOBEL_VERTICAL = [ -1, 0, 1
                          -2, 0, 2
                          -1, 0, 1];

KERNEL_GAUSSIAN_BLUR = [ 0,  0,   0,   5,   0,  0, 0
                         0,  5,  18,  32,  18,  5, 0
                         0, 18,  64, 100,  64, 18, 0
                         5, 32, 100, 100, 100, 32, 5
                         0, 18,  64, 100,  64, 18, 0
                         0,  5,  18,  32,  18,  5, 0
                         0,  0,   0,   5,   0,  0, 0];

KERNEL_LAPLACIAN_GAUSSIAN = [ 0,  0, -1,  0,  0
                              0, -1, -2, -1,  0
                             -1, -2, 16, -2, -1
                              0, -1, -2, -1,  0
                              0,  0, -1,  0,  0];

HAAR_MASK_1 = [1;
               -1];

HAAR_MASK_2 = [1, -1];

HAAR_MASK_3 = [-1;
               1;
               -1];

HAAR_MASK_4 = [-1, 1, -1];

HAAR_MASK_5 = [1, -1;
               -1, 1];

%% Convolution examples
inputImage = double(rgb2gray(imread('inputs/lenna.jpg')));

img1 = Convolution2D(inputImage, KERNEL_SOBEL_HORIZONTAL, 1.0);
img2 = Convolution2D(inputImage, KERNEL_SOBEL_HORIZONTAL, 2.0);
img3 = Convolution2D(inputImage, KERNEL_SOBEL_HORIZONTAL, 4.0);
img4 = Convolution2D(inputImage, KERNEL_SOBEL_VERTICAL, 1.0);
img5 = Convolution2D(inputImage, KERNEL_SOBEL_VERTICAL, 2.0);
img6 = Convolution2D(inputImage, KERNEL_SOBEL_VERTICAL, 4.0);
img7 = Convolution2D(inputImage, KERNEL_LAPLACIAN_GAUSSIAN, 1.0);
img8 = Convolution2D(inputImage, KERNEL_LAPLACIAN_GAUSSIAN, 2.0);
img9 = Convolution2D(inputImage, KERNEL_LAPLACIAN_GAUSSIAN, 4.0);

img10 = ConvolutionHaar(inputImage, HAAR_MASK_1, 1.0);
img11 = ConvolutionHaar(inputImage, HAAR_MASK_1, 2.0);
img12 = ConvolutionHaar(inputImage, HAAR_MASK_1, 4.0);
img13 = ConvolutionHaar(inputImage, HAAR_MASK_2, 4.0);
img14 = ConvolutionHaar(inputImage, HAAR_MASK_3, 4.0);
img15 = ConvolutionHaar(inputImage, HAAR_MASK_4, 4.0);
img16 = ConvolutionHaar(inputImage, HAAR_MASK_5, 4.0);

subplot(5,3,1), imshow(img1), title("Sobel (horizontal) Kernel, scale 1.0");
subplot(6,3,2), imshow(img2), title("Sobel (horizontal) Kernel, scale 2.0");
subplot(6,3,3), imshow(img3), title("Sobel (horizontal) Kernel, scale 4.0");
subplot(6,3,4), imshow(img4), title("Sobel (vertical) Kernel, scale 1.0");
subplot(6,3,5), imshow(img5), title("Sobel (vertical) Kernel, scale 2.0");
subplot(6,3,6), imshow(img6), title("Sobel (vertical) Kernel, scale 4.0");
subplot(6,3,7), imshow(img7), title("Gaussain Kernel, scale 1.0");
subplot(6,3,8), imshow(img8), title("Gaussain Kernel, scale 2.0");
subplot(6,3,9), imshow(img9), title("Gaussain Kernel, scale 4.0");

subplot(6,3,10), imshow(img10), title("Haar Mask 1, scale 1.0");
subplot(6,3,11), imshow(img11), title("Haar Mask 1, scale 2.0");
subplot(6,3,12), imshow(img12), title("Haar Mask 1, scale 4.0");
subplot(6,3,13), imshow(img13), title("Haar Mask 2, scale 1.0");
subplot(6,3,14), imshow(img14), title("Haar Mask 3, scale 1.0");
subplot(6,3,15), imshow(img15), title("Haar Mask 4, scale 1.0");
subplot(6,3,16), imshow(img16), title("Haar Mask 5, scale 1.0");


function convolutionOutput = ConvolutionHaar(inputMatrix, kernel, kScale)
    scaleKernel         = imresize(kernel, kScale, 'nearest');
    [mRow, mCol]        = size(inputMatrix);
    [kRow, kCol]        = size(scaleKernel);
    rowPad              = ceil((kRow - 1) / 2);
    colPad              = ceil((kCol - 1) / 2);
    convolutionOutput   = zeros(mRow, mCol);
    paddedInput         = padarray(inputMatrix, [rowPad, colPad], 0);

    for x = 1 : mCol
        for y = 1 : mRow
            convolutionOutput(y, x) = sum(paddedInput(y:y+kRow-1, x:x+kCol-1) .* scaleKernel, 'all');
        end;
    end
end
