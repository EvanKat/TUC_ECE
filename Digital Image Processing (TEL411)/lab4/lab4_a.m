close all;
clear all;
clc

image = {'axones1.png'};

    %% Import image
im_orig = imread(char(image));
im_orig = rgb2gray(im_orig);


    %% Denoising by opening and closing
se = strel('square',3);

% Image Opening
im_open = imopen(im_orig,se);
% Image Closing
denoised = imclose(im_open,se);


    %% Edge Detaction 
im_dilation = imdilate(denoised, se);
im_erosion = imerode(denoised, se);

basic_gradient = im_dilation - im_erosion;
internal_gradient = denoised - im_erosion;
external_gradient = im_dilation - denoised;

% Choose the grandient to be used
gradient = basic_gradient;


    %% Binarization
% Finding threshold
[level,x] = graythresh(gradient);
binary_image = im2bw(gradient,level);

% Fill
BW2 = bwmorph(binary_image,'bridge',inf);
BW2 = imfill(BW2, 8, 'holes');


    %% Skeletalization
se = strel('disk',2);
% Open for further denoising
BW2_open = imopen(BW2, se);
% Dilate to cover gaps
BW2_open = imdilate(BW2_open, se);

BW3 = bwmorph(BW2_open,'thin',inf);

% Convert Binary image to uint8
BW3 = im2uint8(BW3);

    %% Plots 

fig = figure('Name', 'Original and denoised');
subplot(2,1,1)   
imshow(im_orig);
title(char(image));
subplot(2,1,2)    
imshow(denoised);
title('Image after open-close (denoised)')
set(fig,'Position',[0 0 950 945]);

fig = figure('Name', 'Dilation and Erosion');
subplot(2,1,1)    
imshow(im_dilation)
title('Dilated Image')
subplot(2,1,2)    
imshow(im_erosion)
title('Eroded Image')
set(fig,'Position',[0 0 950 945]);

fig = figure('Name', 'Gradients');
subplot(3,1,1)    
imshow(basic_gradient)
title('Basic gradient')
subplot(3,1,2)    
imshow(internal_gradient)
title('Internal gradient')
subplot(3,1,3)    
imshow(external_gradient)
title('External gradient')
set(fig,'Position',[0 0 950 945]);


fig = figure('Name', 'Binarization and fill');
subplot(2,1,1)    
imshow(binary_image)
title('Binary image')
subplot(2,1,2)    
imshow(BW2)
title('Fill')
set(fig,'Position',[0 0 950 945]);

fig = figure('Name', 'Reopening and Skeletalization');
subplot(2,1,1)    
imshow(BW2_open)
title('Binary image opening')
subplot(2,1,2)    
imshow(BW3)
title('Skeleton')       
set(fig,'Position',[0 0 950 945]);

figure('name', 'Skeletization')
imshow(set_skel(imread(char(image)),BW3,[255 0 0]))
title('Skeleton of Neuron')
