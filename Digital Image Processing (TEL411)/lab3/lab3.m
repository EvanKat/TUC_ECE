clear all;
close all;
clc

% Import original image
im_orig = imread('lena_gray_512.tif');

% Size of original image
[r,c] = size(im_orig);

% imshow(im);
% title('Original Image');

kernel = fspecial('gaussian',[15 15],20);

% Size of kernel
[kr,kc] = size(kernel);

        % Exercise 1

% Convolution using custom function
myConvImage = my_conv2D('lena_gray_512.tif', kernel);

myConvImage = uint8(myConvImage);

% Mean square error 
err1 = immse(im_orig, myConvImage);

% Peak signal-to-noise ratio
peak1 = psnr(im_orig, myConvImage);

fprintf('[my_conv2D()] MSE: %.3f \tPSNR: %.3f\n', err1, peak1);

% Plot original and myConvImage
fig = figure('Name', 'Convolution using my_conv2D()');
subplot(1,2,1)
imshow(im_orig);
title('Original Image');
subplot(1,2,2)
imshow(myConvImage);
title('Convoluted Image with kernel');
set(fig,'Position',[0 0 950 430]);

        % Exercise 2

% Conolution using default function
convImage = conv2(double(im_orig), kernel, 'same');

convImage = uint8(convImage);

% Mean square error 
err1 = immse(im_orig, convImage);

% Peak signal-to-noise ratio
peak1 = psnr(im_orig, convImage);

fprintf('[conv2()] MSE: %.3f \tPSNR: %.3f\n', err1, peak1);

% Plot original and convImage
fig = figure('Name', 'Convolution using conv2()');
subplot(1,2,1)
imshow(im_orig);
title('Original Image');
subplot(1,2,2)
imshow(convImage);
title('Convoluted Image with kernel');
set(fig,'Position',[0 0 950 430]);


        % Exercise 3

filtImage = imfilter(im_orig, kernel, 'conv', 'same');

% Mean square error 
err1 = immse(im_orig, filtImage);

% Peak signal-to-noise ratio
peak1 = psnr(im_orig, filtImage);

fprintf('[imfilter()] MSE: %.3f \tPSNR: %.3f\n', err1, peak1);

% Plot original and convImage
fig = figure('Name', 'Convolution using imfilter()');
subplot(1,2,1)
imshow(im_orig);
title('Original Image');
subplot(1,2,2)
imshow(filtImage);
title('Convoluted Image with kernel');
set(fig,'Position',[0 0 950 430]);


        % Exercise 4

% padding
im_orig_padded = padarray(im_orig, [kr, kc], 0, 'post');
kernel_padded = padarray(kernel, [r, c], 0, 'post');


% Fourier transform of original image
im_orig_F=fftshift(fft2(double(im_orig_padded)));
im_orig_F_abs = abs(im_orig_F);

% Fourier transform of kernel
kernel_F=fftshift(fft2(kernel_padded));
kernel_F_abs = abs(kernel_F);

% Plot original and kernel in the spectrum
fig = figure('Name', 'FT centered');
subplot(1,2,1)
imshow(log(1+im_orig_F_abs), []);
title('Original Image (log scale)');
subplot(1,2,2)
imshow(log(1+kernel_F_abs), []);
title('Kernel (log scale)');
set(fig,'Position',[0 0 950 430]);

% Multiply in the frequency domain
multi = im_orig_F .* kernel_F;

% Return to time domain using ifft
convImageFFT = uint8(abs(ifft2(multi)));

% Crop to original size
pad_rows = floor(kr/2)+1;
pad_columns = floor(kc/2)+1;

convImageFFT = convImageFFT(pad_rows:end-pad_rows, pad_columns:end-pad_columns);

% Mean square error 
err1 = immse(im_orig, convImageFFT);

% Peak signal-to-noise ratio
peak1 = psnr(im_orig, convImageFFT);

fprintf('[fft2()->ifft2()] MSE: %.3f \tPSNR: %.3f\n', err1, peak1);

% Plot original and convImageFFT
fig = figure('Name', 'Convolution using fft2() and ifft2()');
subplot(1,2,1)
imshow(im_orig);
title('Original Image');
subplot(1,2,2)
imshow(convImageFFT);
title('Convoluted Image with kernel');
set(fig,'Position',[0 0 950 430]);
