function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

%  X(i) = [1, X(1), X(2)]
% Theta = [ th1, th2, th3]'

[X_m,X_n] = size(X);
[th_m,th_n] = size(theta);

% Compute Cross-Entropy error 
s_i = sigmoid(X*theta); % sigmoid value of each sample
J = -(1/m) * sum( y.*log(s_i) + (1-y).*log(1-s_i));

% Compute gradient of cross entropy
for i = 1 : th_m
        gradient(i) = (1/m) * sum( (s_i - y) .* X(:,i));
end
grad = gradient;
end
