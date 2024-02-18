%{
Exercise 3b: Max filter computation
    Input arguments:
    img: A matrix, the input image without filtering
    kernel_size: The size of the kernel to implement on the image

    Output:
    out_img: The image, after filtering (same size as original)
%}

function out_img = Compute_Max(img, kernel_size)
    % Size of the picture
    [i_r,i_c] = size(img);
    % Size of the kernel
    k_r = kernel_size(1);
    k_c = kernel_size(2);

    % Calculate the number of rows an columns for padding
    pad_size = [fix(k_r/2) fix(k_c/2)];
    % Pad the image with zeros
    buf_img = padarray(img, pad_size, 'symmetric', 'both');

    % Move the kernel window along each pixel of the image
    % Since we start from position 1,1 we must stop at a length equal to...
    % ... the original Image_size for each row and column
    for i=1:i_r
        for j=1:i_c

            % Copy portion of the image
            p = buf_img(i:i-1+k_r, j:j-1+k_c);

            % Convert 2D matrix to array (row major)
            buf = p(1:end); 
            
            % Find the max value
            % And pass it to the pixel of the image
            out_img(i, j) = max(buf);  
        end
    end
end