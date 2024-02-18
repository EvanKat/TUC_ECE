function filterd_image = my_conv2D(imageName, kernel) 
    
    % Shift the kernel by rotating it
    % No need to gaussian kernel 'cause its symmetric
    kernel = rot90(kernel);
    
    [kr,kc] = size(kernel);
    
    % Read image
    im_orig = imread(imageName);
    if  (length(size(im_orig))==3)
        im_orig = rgb2gray(im_orig); 
    else
        im_orig = im2double(im_orig); % Convert its values to double
    end
   
    [row,colomn] = size(im_orig); % original size
    
    % Make the padding
    pad_rows = floor(kr/2);
    pad_columns = floor(kc/2);
    padded_image = padarray(im_orig,[pad_rows, pad_columns ],0,'both');
    
    
    for r = 1:row
        for c =1:colomn
            % Take the window of the image             
            for i = 1:kr
                for j = 1:kc
                   P(i,j) =  padded_image(r+(i-1),c+(j-1));
                end
            end
            % Multiple and sum the matrices and then store
            value = sum(sum(P.*kernel));
            filterd_image(r,c) = value;
        end
    end
    % Convert the values back to uint8 format 
    filterd_image = im2uint8(filterd_image);
end
