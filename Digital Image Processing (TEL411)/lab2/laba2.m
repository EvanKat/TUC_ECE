close all;
clear all;
clc;

choice = input('Choose filter type Mean, Median, Min, Max (1-4): ');
 
switch choice
        %% Mean filter Computation (Exercise 1)
case 1
    filename1 = 'Mean_Image1.jpeg';
    filename2 = 'Mean_Image2.jpeg';
    img_ch = input(sprintf('Choose between \n[%s] and [%s] (1-2): ', filename1, filename2));

    if(img_ch == 1)
        % Original image
        im_orig_rgb = imread(filename1);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    else
        % Original image
        im_orig_rgb = imread(filename2);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    end
    
    % Check if it's RGB or Greyscale
    if(length(size(im_orig_rgb)) == 3)
        % Convert to grayscale
        im_orig = rgb2gray(im_orig_rgb);
    else
        im_orig = im_orig_rgb;
    end
    
    % Get kenrel size
    kernel_x = input('Enter the kernel X size(INT): ');
    kernel_y = input('Enter the kernel Y size(INT): ');

    % A massage so that the user knows
    disp('Please wait....');

    % Plot original image
    fig = figure('Name',sprintf('Mean filter, image: %s', filename));
    subplot(1,2,1)
    imshow(im_orig);
    title('Original Image');

    % Compute Mean filter using kernel
    out_img = Compute_Mean(im_orig, [kernel_x kernel_y]);
    subplot(1,2,2)
    imshow(out_img)
    title(sprintf('Mean Filter %dx%d', kernel_x, kernel_y));

        
        %% Median filter Computation (Exercise 2)
case 2
    filename1 = 'Median_Image1.png';
    filename2 = 'Median_Image2.png';
    img_ch = input(sprintf('Choose between \n[%s] and [%s] (1-2): ', filename1, filename2));

    if(img_ch == 1)
        % Original image
        im_orig_rgb = imread(filename1);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    else
        % Original image
        im_orig_rgb = imread(filename2);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    end
    
    % Check if it's RGB or Greyscale
    if(length(size(im_orig_rgb)) == 3)
        % Convert to grayscale
        im_orig = rgb2gray(im_orig_rgb);
    else
        im_orig = im_orig_rgb;
    end
    
    % Get kenrel size
    kernel_x = input('Enter the kernel X size(INT): ');
    kernel_y = input('Enter the kernel Y size(INT): ');

    % A massage so that the user knows
    disp('Please wait....');

    % Plot original image
    fig = figure('Name',sprintf('Median filter, image: %s', filename));
    subplot(1,2,1)
    imshow(im_orig);
    title('Original Image');

    % Compute Mean filter using kernel
    out_img = Compute_Median(im_orig, [kernel_x kernel_y]);
    subplot(1,2,2)
    imshow(out_img)
    title(sprintf('Median Filter %dx%d', kernel_x, kernel_y));

        %% Min filter Computation (Exercise 3a)
case 3
    filename1 = 'Min_Max_Image1.jpeg';
    filename2 = 'Min_Max_Image2.jpeg';
    img_ch = input(sprintf('Choose between \n[%s] and [%s] (1-2): ', filename1, filename2));

    if(img_ch == 1)
        % Original image
        im_orig_rgb = imread(filename1);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    else
        % Original image
        im_orig_rgb = imread(filename2);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    end
    
    % Check if it's RGB or Greyscale
    if(length(size(im_orig_rgb)) == 3)
        % Convert to grayscale
        im_orig = rgb2gray(im_orig_rgb);
    else
        im_orig = im_orig_rgb;
    end
    
    % Get kenrel size
    kernel_x = input('Enter the kernel X size(INT): ');
    kernel_y = input('Enter the kernel Y size(INT): ');

    % A massage so that the user knows
    disp('Please wait....');

    % Plot original image
    fig = figure('Name',sprintf('Min filter, image: %s', filename));
    subplot(1,2,1)
    imshow(im_orig);
    title('Original Image');

    % Compute Mean filter using kernel
    out_img = Compute_Min(im_orig, [kernel_x kernel_y]);
    subplot(1,2,2)
    imshow(out_img)
    title(sprintf('Min Filter %dx%d', kernel_x, kernel_y));


        %% Max filter Computation (Exercise 3a)
case 4
    filename1 = 'Min_Max_Image1.jpeg';
    filename2 = 'Min_Max_Image2.jpeg';
    img_ch = input(sprintf('Choose between \n[%s] and [%s] (1-2): ', filename1, filename2));

    if(img_ch == 1)
        % Original image
        im_orig_rgb = imread(filename1);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    else
        % Original image
        im_orig_rgb = imread(filename2);
        % Pass the name to 'filename' (for figure title)
        filename = filename1;
    end
    
    % Check if it's RGB or Greyscale
    if(length(size(im_orig_rgb)) == 3)
        % Convert to grayscale
        im_orig = rgb2gray(im_orig_rgb);
    else
        im_orig = im_orig_rgb;
    end
    
    % Get kenrel size
    kernel_x = input('Enter the kernel X size(INT): ');
    kernel_y = input('Enter the kernel Y size(INT): ');

    % A massage so that the user knows
    disp('Please wait....');

    % Plot original image
    fig = figure('Name',sprintf('Max filter, image: %s', filename));
    subplot(1,2,1)
    imshow(im_orig);
    title('Original Image');

    % Compute Mean filter using kernel
    out_img = Compute_Max(im_orig, [kernel_x kernel_y]);
    subplot(1,2,2)
    imshow(out_img)
    title(sprintf('Max Filter %dx%d', kernel_x, kernel_y));
otherwise
    disp('Invalid input')
end

