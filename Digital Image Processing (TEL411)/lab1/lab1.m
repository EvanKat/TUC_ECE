close all;
clear all;
clc;
            

% Original image
im_orig = imread('retriever.tiff');
imshow(im_orig);
title('Original Image');
[r,c] = size(im_orig);

% Downsampling
% Nearest-neighbor 
fig1 = figure('Name', 'Nearest-neighbor interpolation');
type = 'nearest';

im1_nn = imresize(im_orig, [r/2 c/4], type);
subplot(3,2,1)
imshow(im1_nn);
title('Downsampling by 1/2 x 1/4');
im1_nn_aa = imresize(im_orig, [r/2 c/4], type, 'Antialiasing', true);
subplot(3,2,2)
imshow(im1_nn_aa);
title('Downsampling by 1/2 x 1/4 (no aliasing)');

im2_nn = imresize(im_orig, [r/4 c/2], type);
subplot(3,2,3)
imshow(im2_nn);
title('Downsampling by 1/4 x 1/2');
im2_nn_aa = imresize(im_orig, [r/4 c/2], type, 'Antialiasing', true);
subplot(3,2,4)
imshow(im2_nn_aa);
title('Downsampling by 1/4 x 1/2 (no aliasing)');

im3_nn = imresize(im_orig, [r/8 c/8], type);
subplot(3,2,5)
imshow(im3_nn);
title('Downsampling by 1/8 x 1/8');
im3_nn_aa = imresize(im_orig, [r/8 c/8], type, 'Antialiasing', true);
subplot(3,2,6)
imshow(im3_nn_aa);
title('Downsampling by 1/8 x 1/8 (no aliasing)');
set(fig1,'Position',[0 0 950 970]);

% Bilinear 
fig2 = figure('Name', 'Bilinear interpolation');
type = 'bilinear';

im1_bl = imresize(im_orig, [r/2 c/4], type);
subplot(3,2,1)
imshow(im1_bl);
title('Downsampling by 1/2 x 1/4');
im1_bl_aa = imresize(im_orig, [r/2 c/4], type, 'Antialiasing', true);
subplot(3,2,2)
imshow(im1_bl_aa);
title('Downsampling by 1/2 x 1/4 (no aliasing)');

im2_bl = imresize(im_orig, [r/4 c/2], type);
subplot(3,2,3)
imshow(im2_bl);
title('Downsampling by 1/4 x 1/2');
im2_bl_aa = imresize(im_orig, [r/4 c/2], type, 'Antialiasing', true);
subplot(3,2,4)
imshow(im2_bl_aa);
title('Downsampling by 1/4 x 1/2 (no aliasing)');

im3_bl = imresize(im_orig, [r/8 c/8], type);
subplot(3,2,5)
imshow(im3_bl);
title('Downsampling by 1/8 x 1/8');
im3_bl_aa = imresize(im_orig, [r/8 c/8], type, 'Antialiasing', true);
subplot(3,2,6)
imshow(im3_bl_aa);
title('Downsampling by 1/8 x 1/8 (no aliasing)');

set(fig2,'Position',[0 0 950 970]);


% Cubic 
fig3 = figure('Name', 'Cubic interpolation');
type = 'cubic';

im1_cu = imresize(im_orig, [r/2 c/4], type);
subplot(3,2,1)
imshow(im1_cu);
title('Downsampling by 1/2 x 1/4');
im1_cu_aa = imresize(im_orig, [r/2 c/4], type, 'Antialiasing', true);
subplot(3,2,2)
imshow(im1_cu_aa);
title('Downsampling by 1/2 x 1/4 (no aliasing)');

im2_cu = imresize(im_orig, [r/4 c/2], type);
subplot(3,2,3)
imshow(im2_cu);
title('Downsampling by 1/4 x 1/2');
im2_cu_aa = imresize(im_orig, [r/4 c/2], type, 'Antialiasing', true);
subplot(3,2,4)
imshow(im2_cu_aa);
title('Downsampling by 1/4 x 1/2 (no aliasing)');

im3_cu = imresize(im_orig, [r/8 c/8], type);
subplot(3,2,5)
imshow(im3_cu);
title('Downsampling by 1/8 x 1/8');
im3_cu_aa = imresize(im_orig, [r/8 c/8], type, 'Antialiasing', true);
subplot(3,2,6)
imshow(im3_cu_aa);
title('Downsampling by 1/8 x 1/8 (no aliasing)');

set(fig3,'Position',[0 0 950 970]);

% Upsampling
% Nearest-neighbor
fig4 = figure('Name', 'Nearest-neighbor interpolation');
type = 'nearest';

subplot(3,2,1)
im1_up = imresize(im1_nn, [r c], type);
imshow(im1_up);
title('Upsampled to orginal size');
subplot(3,2,2)
im1_up_aa = imresize(im1_nn_aa, [r c], type);
imshow(im1_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,3)
im2_up = imresize(im2_nn, [r c], type);
imshow(im2_up);
title('Upsampled to orginal size');
subplot(3,2,4)
im2_up_aa = imresize(im2_nn_aa, [r c], type);
imshow(im2_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,5)
im3_up = imresize(im3_nn, [r c], type);
imshow(im3_up);
title('Upsampled to orginal size');
subplot(3,2,6)
im3_up_aa = imresize(im3_nn_aa, [r c], type);
imshow(im3_up_aa);
title('Upsampled to orginal size (no aliasing)');

set(fig4,'Position',[0 0 950 970]);

% Mean square error 
err1 = immse(im_orig, im1_up);
err2 = immse(im_orig, im2_up);
err3 = immse(im_orig, im3_up);
% Mean square error with anti-aliasing
err1_aa = immse(im_orig, im1_up_aa);
err2_aa = immse(im_orig, im2_up_aa);
err3_aa = immse(im_orig, im3_up_aa);

% Peak signal-to-noise ratio
peak1 = psnr(im1_up, im_orig);
peak2 = psnr(im2_up, im_orig);
peak3 = psnr(im3_up, im_orig);
% Peak signal-to-noise ratio with anti-aliasing
peak1_aa = psnr(im1_up_aa, im_orig);
peak2_aa = psnr(im2_up_aa, im_orig);
peak3_aa = psnr(im3_up_aa, im_orig);

fprintf('\n-----------------------------------------------------------\n');
fprintf('\n\tInterpolation by Nearest-neighbor method\n')
fprintf('\nMean square error without aliasing for each scale:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1,err2,err3);

fprintf('Mean square error with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1_aa,err2_aa,err3_aa);

fprintf('Peak signal-to-noise ratio:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1,peak2,peak3);

fprintf('Peak signal-to-noise ratio with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1_aa,peak2_aa,peak3_aa);


% Bilinear
fig5 = figure('Name', 'Bilinear interpolation');
type = 'bilinear';

subplot(3,2,1)
im1_up = imresize(im1_bl, [r c], type);
imshow(im1_up);
title('Upsampled to orginal size');
subplot(3,2,2)
im1_up_aa = imresize(im1_bl_aa, [r c], type);
imshow(im1_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,3)
im2_up = imresize(im2_bl, [r c], type);
imshow(im2_up);
title('Upsampled to orginal size');
subplot(3,2,4)
im2_up_aa = imresize(im2_bl_aa, [r c], type);
imshow(im2_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,5)
im3_up = imresize(im3_bl, [r c], type);
imshow(im3_up);
title('Upsampled to orginal size');
subplot(3,2,6)
im3_up_aa = imresize(im3_bl_aa, [r c], type);
imshow(im3_up_aa);
title('Upsampled to orginal size (no aliasing)');

set(fig5,'Position',[0 0 950 970]);

% Mean square error 
err1 = immse(im_orig, im1_up);
err2 = immse(im_orig, im2_up);
err3 = immse(im_orig, im3_up);
% Mean square error with anti-aliasing
err1_aa = immse(im_orig, im1_up_aa);
err2_aa = immse(im_orig, im2_up_aa);
err3_aa = immse(im_orig, im3_up_aa);

% Peak signal-to-noise ratio
peak1 = psnr(im1_up, im_orig);
peak2 = psnr(im2_up, im_orig);
peak3 = psnr(im3_up, im_orig);
% Peak signal-to-noise ratio with anti-aliasing
peak1_aa = psnr(im1_up_aa, im_orig);
peak2_aa = psnr(im2_up_aa, im_orig);
peak3_aa = psnr(im3_up_aa, im_orig);

fprintf('\n-----------------------------------------------------------\n');
fprintf('\n\tInterpolation by Bilinear method\n')
fprintf('\nMean square error without aliasing for each scale:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1,err2,err3);

fprintf('Mean square error with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1_aa,err2_aa,err3_aa);

fprintf('Peak signal-to-noise ratio:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1,peak2,peak3);

fprintf('Peak signal-to-noise ratio with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1_aa,peak2_aa,peak3_aa);


% Cubic
fig6 = figure('Name', 'Cubic interpolation');
type = 'cubic';

subplot(3,2,1)
im1_up = imresize(im1_cu, [r c], type);
imshow(im1_up);
title('Upsampled to orginal size');
subplot(3,2,2)
im1_up_aa = imresize(im1_cu_aa, [r c], type);
imshow(im1_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,3)
im2_up = imresize(im2_cu, [r c], type);
imshow(im2_up);
title('Upsampled to orginal size');
subplot(3,2,4)
im2_up_aa = imresize(im2_cu_aa, [r c], type);
imshow(im2_up_aa);
title('Upsampled to orginal size (no aliasing)');

subplot(3,2,5)
im3_up = imresize(im3_cu, [r c], type);
imshow(im3_up);
title('Upsampled to orginal size');
subplot(3,2,6)
im3_up_aa = imresize(im3_cu_aa, [r c], type);
imshow(im3_up_aa);
title('Upsampled to orginal size (no aliasing)');

set(fig6,'Position',[0 0 950 970]);

% Mean square error 
err1 = immse(im_orig, im1_up);
err2 = immse(im_orig, im2_up);
err3 = immse(im_orig, im3_up);
% Mean square error with anti-aliasing
err1_aa = immse(im_orig, im1_up_aa);
err2_aa = immse(im_orig, im2_up_aa);
err3_aa = immse(im_orig, im3_up_aa);

% Peak signal-to-noise ratio
peak1 = psnr(im1_up, im_orig);
peak2 = psnr(im2_up, im_orig);
peak3 = psnr(im3_up, im_orig);
% Peak signal-to-noise ratio with anti-aliasing
peak1_aa = psnr(im1_up_aa, im_orig);
peak2_aa = psnr(im2_up_aa, im_orig);
peak3_aa = psnr(im3_up_aa, im_orig);

fprintf('\n-----------------------------------------------------------\n');
fprintf('\n\tInterpolation by Cubic method\n')
fprintf('\nMean square error without aliasing for each scale:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1,err2,err3);

fprintf('Mean square error with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',err1_aa,err2_aa,err3_aa);

fprintf('Peak signal-to-noise ratio:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1,peak2,peak3);

fprintf('Peak signal-to-noise ratio with anti-aliasing:\n');
fprintf('(1/2,1/4): %.3f \n(1/4,1/2): %.3f \n(1/8,1/8): %.3f\n',peak1_aa,peak2_aa,peak3_aa);
