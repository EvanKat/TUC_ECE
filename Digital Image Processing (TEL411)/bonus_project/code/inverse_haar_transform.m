function output = inverse_haar_transform( input_matrix, level )

[rows, columns] = size(input_matrix);

% Info to keep track of the image
rows = rows/level;
columns = columns/level;

mid_row = rows / 2;
mid_column= columns / 2;

output = input_matrix;

% Calculations \w respect of columns
for r = 1:rows
    for c = 1:mid_column
        output1(r,(2*c - 1) ) =  input_matrix(r,c) + input_matrix(r, (mid_column + c) );
        output1(r,(2*c - 1) + 1) = input_matrix(r,c) - input_matrix(r, (mid_column + c) );
    end
end

% % Calculations \w respect of rows
for c = 1:columns
    for r = 1:mid_row
        output((2*r - 1) , c) =  output1(r,c) + (output1((mid_row + r), c ));
        output((2*r - 1) + 1 , c) = output1(r,c) - (output1((mid_row + r), c ));
    end
end

% output = uint8(output);
end

