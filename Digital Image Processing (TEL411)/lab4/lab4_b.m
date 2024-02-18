close all;
clear all;
clc

images = {'axones2.png'};
% images = {'axones2.png', 'axones1.png'};
for image = images
    %%   Open image
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
    % level = 0.4;
    binary_image = im2bw(gradient,level);
    
    % Fill
    BW2 = bwmorph(binary_image,'bridge',inf);
    
    BW2_open_1 = imopen(BW2, se);
    
%     BW2 = imopen(BW2, se);
    BW2 = imfill(BW2_open_1, 8, 'holes');
    
    
    %% Skeletalization
    se = strel('square',8);
    
    
    % Delete unwanted regions
    BW2_open = imopen(BW2, se);

    % Connect neuron regions
    BW2_open = imdilate(BW2_open, strel('line',20,0));
    BW2_open = imdilate(BW2_open, strel('line',20,0));
    BW2_open = imdilate(BW2_open, strel('line',15,90));
    BW2_open = imdilate(BW2_open, strel('line',20,45));
    BW2_open = imdilate(BW2_open, strel('line',20,-45));
    
    
    % Create skeleton
    BW3 = bwmorph(BW2_open,'thin',inf);
    
    % Convert Binary image to uint8
%     BW3 = im2uint8(BW3);
   
    %% Plots
    figure
    subplot(2,1,1)
    imshow(im_orig);
    title(char(image))
    subplot(2,1,2) 
    imshow(denoised);
    title('Denoised Image');
    
    figure('Name', 'Gradient') 
    imshow(basic_gradient)
    title('Edge Detaction')

    
    
    figure('Name', 'Binarization and fill')    
    subplot(3,1,1)
    imshow(binary_image)
    title('Binary image based on threshold')
    subplot(3,1,2)
    imshow(BW2_open_1)
    title('Opening')
    subplot(3,1,3)    
    imshow(BW2)
    title('Filled image')
   
    
    figure('Name', 'Reopening and Skeletalization') 
    subplot(2,1,1)    
    imshow(BW2_open)
    title('BW2 imerode')
    subplot(2,1,2)    
    imshow(BW3)
    title('Skeleton')       
     
    figure('name', 'Skeletization')
    imshow(set_skel(imread(char(image)),BW3,[255 0 255]))
    title('Skeleton of Neuron')
end
