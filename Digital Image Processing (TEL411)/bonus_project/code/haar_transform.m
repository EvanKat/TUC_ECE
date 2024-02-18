function output = haar_transform( input_matrix, level )

[rows, columns] = size(input_matrix);

% Info to be proccesed
rows = rows/level;
columns = columns/level;

% zero padding if needed to be symmetric
input_matrix = padarray(input_matrix,[mod(rows,2) mod(columns,2)],0,'post');

% To ensure the correct output image \w respect of tranformation lvl
output = input_matrix;

% Calculations \w respect of rows
for r = 1:rows
    for c = 1:2:columns
        % mean value 
        % 1st pixel at upper right corner 
        output_rows(r,ceil(c/2)) = mean(input_matrix(r,c:c+1));
        
        % diff value
        output_rows(r,( ceil(columns/2) + ceil(c/2))) = (input_matrix(r,c) - input_matrix(r,c+1))/2;
    end
end
 
% output = uint8(output_rows);
% figure;
% imshow(output);

% Calculations \w respect of columns
for c = 1:columns
    for r = 1:2:rows
        % mean value 
        output(ceil(r/2),c) = mean(output_rows(r:r+1,c));
        
        % diff value
        output( (ceil(rows/2) + ceil(r/2)) ,c) = (output_rows(r,c) - output_rows(r+1,c))/2;
    end
end
% output = uint8(output);
end

