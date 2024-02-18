function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

[X_m,X_n] = size(X);
[th_m,th_n] = size(theta);

% Compute Cross-Entropy error 
s_i = sigmoid(X*theta); % sigmoid value of each sample
J = -(1/m) * sum( y.*log(s_i) + (1-y).*log(1-s_i)) ...
    + ( ( (lambda)/(2*m) ) * sum(theta(2:end).^2) );

% Compute gradient of cross entropy
for i = 1 : th_m
    gradient(i) = (1/m) * sum( (s_i - y) .* X(:,i)) ...
        + (lambda/m) .* theta(i);
end
grad = gradient;

end
