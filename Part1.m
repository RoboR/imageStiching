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

HAAR_MASK_1 = [1
               0];

HAAR_MASK_2 = [1, 0];

HAAR_MASK_3 = [0
               1
               0];

HAAR_MASK_4 = [0, 1, 0];

HAAR_MASK_5 = [1, 0
               0, 1];

%% Convolution examples
X = [105, 102, 100, 97
     103,  99, 103, 101
     101,  98, 104, 102
      99, 101, 106, 104];

inputImage = double(rgb2gray(imread('inputs/lenna.jpg')));

a1 = Convolution2D(inputImage, KERNEL_SOBEL_HORIZONTAL, 1.0);
a2 = Convolution2D(inputImage, KERNEL_SOBEL_VERTICAL, 1.0);
a3 = Convolution2D(inputImage, KERNEL_LAPLACIAN_GAUSSIAN, 1.0);
a4 = Convolution2D(inputImage, HAAR_MASK_1, 4.0);
a5 = Convolution2D(inputImage, HAAR_MASK_4, 4.0);

b1 = conv2(inputImage, KERNEL_SOBEL_HORIZONTAL);
b2 = conv2(inputImage, KERNEL_SOBEL_VERTICAL);
b3 = conv2(inputImage, KERNEL_LAPLACIAN_GAUSSIAN);

subplot(3,2,1), imshow(a1)
subplot(3,2,2), imshow(b1)
subplot(3,2,3), imshow(a2)
subplot(3,2,4), imshow(b2)
subplot(3,2,5), imshow(a3)
subplot(3,2,6), imshow(b3)
