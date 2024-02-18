close all;
clear all;
clc;

        %% Mean filter Computation (Exercise 1)

        % lab2\Mean_Image1.jpeg
% Original image
im_orig_rgb = imread('Mean_Image1.jpeg');
% Convert to grayscale
im_orig = rgb2gray(im_orig_rgb);
% im_orig = imread('Median_Image1.png');
fig = figure('Name','Mean filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');



% Create empty kernel (3x3)
kernel = [3 3];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (9x9)
kernel = [9 9];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

set(fig,'Position',[0 0 950 970]);

        % lab2\Mean_Image2.jpeg
% Original image
im_orig = imread('Mean_Image2.jpeg');
% im_orig = imread('Median_Image1.png');
fig = figure('Name','Mean filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');

% Create empty kernel (3x3)
kernel = [3 3];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (9x9)
kernel = [9 9];
% Compute Mean filter using kernel
out_img = Compute_Mean(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title(sprintf('Mean Filter %dx%d', kernel(1), kernel(2)));

set(fig,'Position',[0 0 950 970]);


        %% Median filter Computation (Exercise 2)

        % lab2\Median_Image1.png
% Original image
im_orig = imread('Median_Image1.png');

% Plot original image
fig = figure('Name','Median filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x3)
kernel = [3 3];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title(sprintf('Median Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (5x7)
kernel = [5 7];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Median Filter 5x7');

% Create empty kernel (9x11)
kernel = [9 11];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Median Filter 9x11');

set(fig,'Position',[0 0 950 970]);

        % lab2\Median_Image2.png
% Original image
im_orig = imread('Median_Image2.png');

% Plot original image
fig = figure('Name','Median filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x3)
kern_size = [3 3];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title(sprintf('Median Filter %dx%d', kernel(1), kernel(2)));

% Create empty kernel (5x7)
kernel = [5 7];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Median Filter 5x7');

% Create empty kernel (9x11)
kernel = [9 11];
% Compute Median filter using kernel
out_img = Compute_Median(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Median Filter 9x11');

set(fig,'Position',[0 0 950 970]);


        %% Min filter Computation (Exercise 3a)

        % Min_Max_Image1.jpeg
% Original image
im_orig_rgb = imread('Min_Max_Image1.jpeg');
% Convert to grayscale
im_orig = rgb2gray(im_orig_rgb);

% Plot original image
fig = figure('Name', 'Min filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x5)
kernel = [3 5];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title('Min Filter 3x5');

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Min Filter 5x5');

% Create empty kernel (7x7)
kernel = [7 7];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Min Filter 7x7');

set(fig,'Position',[0 0 950 970]);

        % Min_Max_Image2.jpeg
% Original image
im_orig_rgb = imread('Min_Max_Image2.jpeg');
% Convert to grayscale
im_orig = rgb2gray(im_orig_rgb);

% Plot original image
fig = figure('Name', 'Min filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x5)
kernel = [3 5];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title('Min Filter 3x5');

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Min Filter 5x5');

% Create empty kernel (7x7)
kernel = [7 7];
% Compute Min filter using kernel
out_img = Compute_Min(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Min Filter 7x7');

set(fig,'Position',[0 0 950 970]);

        %% Max filter Computation (Exercise 3b)

        % Min_Max_Image1.jpeg
% Original image
im_orig_rgb = imread('Min_Max_Image1.jpeg');
% Convert to grayscale
im_orig = rgb2gray(im_orig_rgb);

% Plot original image
fig = figure('Name', 'Max filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x5)
kernel = [3 5];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title('Max Filter 3x5');

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Max Filter 5x5');

% Create empty kernel (7x7)
kernel = [7 7];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Max Filter 7x7');

set(fig,'Position',[0 0 950 970]);

        % Min_Max_Image2.jpeg
% Original image
im_orig_rgb = imread('Min_Max_Image2.jpeg');
% Convert to grayscale
im_orig = rgb2gray(im_orig_rgb);

% Plot original image
fig = figure('Name', 'Max filter');
subplot(2,2,1)
imshow(im_orig);
title('Original Image');


% Create empty kernel (3x5)
kernel = [3 5];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,2)
imshow(out_img)
title('Max Filter 3x5');

% Create empty kernel (5x5)
kernel = [5 5];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,3)
imshow(out_img)
title('Max Filter 5x5');

% Create empty kernel (7x7)
kernel = [7 7];
% Compute Max filter using kernel
out_img = Compute_Max(im_orig, kernel);
subplot(2,2,4)
imshow(out_img)
title('Max Filter 7x7');

set(fig,'Position',[0 0 950 970]);
