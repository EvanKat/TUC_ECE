clc;
clear all;
close all;

% Import original image
im_orig = imread('cameraman.tif');
fig = figure('Name', 'Source Image');
imshow(im_orig);
title('Source Image')
[r, c] = size(im_orig);

A = 255;
R = 0:8;

% Exercise 2
fig = figure('Name', 'Characteristic functions of the uniform quantizer');
for i=R
    input_signal = -255:255;
    output_signal = uni_scalar(input_signal, A, i);
    subplot(3,3,i+1)
    plot(input_signal, output_signal);
    title(sprintf('Characteristics R=%d', i));
    xlabel('Input signal');
    ylabel('Output signal');
    % xlim([-255 255])
    % ylim([-255 255])
end
% set(fig,'Position',[0 0 950 430]);

output_images = {};
% Format: output_images = {i}{1:3} = R, output matrix, mse;

for i = R
    output_images{i+1} = {sprintf('Uniform Quantizer R = %d',i),uni_scalar(im_orig,A,i)};
    
    % MSE calculation \w respect of original image
    output_images{i+1}{3} = immse(output_images{i+1}{2},im_orig);
end

%% Plot images and mse
fig = figure('Name', '');
for i = R
    subplot(3,3,i+1)
    imshow(output_images{i+1}{2});
    title(output_images{i+1}{1});
    % title(sprintf('Quantized image\nR=%d', i));

    % MSE
    xlabel(sprintf('MSE = %.3f',output_images{i+1}{3}));
    fprintf('R = %d | MSE = %f\n',i,output_images{i+1}{3});
end

%% Plot ration-distortion
for i = R
    distortion(i+1) = output_images{i+1}{3};
end
fig = figure('Name','Rate-Distortion');
plot(R,distortion);
title('Rate-Distortion curve D(R)');
ylabel('Distortion (MSE)');
xlabel('Level (R)');
grid on;