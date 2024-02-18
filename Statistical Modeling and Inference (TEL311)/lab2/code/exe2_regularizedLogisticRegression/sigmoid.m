function f = sigmoid(z)
%SIGMOID Compute sigmoid functoon
%   J = SIGMOID(z) computes the sigmoid of z.
%   J(z) = 1\frac{1}{1+e^(-z)}

[rows,columns] = (size(z));

% For each element of input

for r = 1:rows
    for c = 1:columns
        denum = 1 + exp(-z(r,c));
        z_sigmoid(r,c) = 1/denum;
    end
end
% output
f = z_sigmoid;
end