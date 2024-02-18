clc;
clear all;
close all;

% Import original image
im_orig = imread('cameraman.tif');
fig = figure('Name', 'Sourse Image');
imshow(im_orig);
title('Sourse Image')
[row, colomn] = size(im_orig);

im_orig_d = double(im_orig);

%% Haar tranformation
% 1st level 
level = 1;
% keep double value of matrix
output_H1_d = haar_transform(im_orig_d,level);
% Convert to uint8 to be able to print
output_H1 = uint8(output_H1_d);

fig = figure('Name', 'Haar transform lv 1');
imshow(output_H1);
title('Haar Transform lv 1');


% 2nd level Haar
level = 2;
output_H2_d = haar_transform(output_H1_d,level);
output_H2 = uint8(output_H2_d);

fig = figure('Name', 'Haar transform lv 2');
imshow(output_H2);
title('Haar Transform lv 2');

%% Quantization
A = 255;
% 1st lvl
R = 2;
quant_output_H1_d = uni_scalar(output_H1_d,A,R);

quant_output_H1 = uint8(quant_output_H1_d);

fig = figure('Name', 'Quantization lv 1');
imshow(quant_output_H1);
title('Quantization of Haar transform lv 1');


% 2nd lvl
R = 4;
quant_output_H2_d = uni_scalar(output_H2_d,A,R);

quant_output_H2 = uint8(quant_output_H2_d);

fig = figure('Name', 'Quantization lv 2');
imshow(quant_output_H2);
title('Quantization of Haar transform lv 2');

%% Subband entropy
m_rows = row;
m_columns = colomn;
i=0;
% l=1, Break image into 4 quarters H1,..,H4
% l=2, Break first quarter (H1) into 4 quarters H5,...,H8
for l=1:2
    for r=[0 m_rows/2]
        for c=[0 m_columns/2]
            i = i + 1;
            H(i) = calc_entropy(quant_output_H2_d(1+r:m_columns/2+r, 1+c:m_columns/2+c), A, R);
        end
    end
    m_rows = m_rows/2;
    m_columns = m_columns/2;
end

% Total entropy
H_sum = sum(H(2:end));
fprintf('_________________________________\n')
fprintf('|        |       |              |\n')
fprintf('|   H4   |   H5  |              |\n')
fprintf('|________|_______|      H1      |\n')
fprintf('|        |       |              |\n')
fprintf('|   H6   |   H7  |              |\n')
fprintf('|________|_______|______________|\n')
fprintf('|                |              |\n')
fprintf('|                |              |\n')
fprintf('|       H2       |      H3      |\n')
fprintf('|                |              |\n')
fprintf('|                |              |\n')
fprintf('|________________|______________|\n\n')


for i=2:length(H)
    fprintf('Entropy H_%d = %.3f bits/pixel\n', i-1, H(i));
end
fprintf('\nTotal Entropy H=%.3f bits/pixel\n', H_sum);

% Compression ratio
compress = R / H_sum;
fprintf('Compression Ratio C=%.3f\n', compress);


%% Inverse_haar_transform

% 2nd lvl to 1st lvl
level = 2;
inverse_output1_d = inverse_haar_transform( quant_output_H2_d, level );
% 1nd lvl to original
level = 1;
inverse_output_d = inverse_haar_transform( inverse_output1_d, level );

inverse_output_1 = uint8(inverse_output1_d);
inverse_output = uint8(inverse_output_d);

fig = figure('Name', 'Inverse Haar trasmformation lv (2 to 1)');
imshow(inverse_output_1);
title(sprintf('Inverse Haar trasmformation\nlv2 to 1'));

fig = figure('Name', 'Inverse Haar trasmformation lv (1 to original)');
imshow(inverse_output);
title('Inverse Haar trasmformation');

% Mean square error 
err1 = immse(inverse_output_d, im_orig_d);

% Peak signal-to-noise ratio
peak1 = psnr(inverse_output_d, im_orig_d);

fprintf('MSE: %.3f \tPSNR: %.3f\n', err1, peak1)





