function p = predict(theta, X)
%PREDICT Predict whether the label is 0 or 1 using learned logistic 
%regression parameters theta
%   p = PREDICT(theta, X) computes the predictions for X using a 
%   threshold at 0.5 (i.e., if sigmoid(theta'*x) >= 0.5, predict 1)

m = size(X, 1); % Number of training examples
threshold = 0.5;
%% Compute Sigmoid values
for i = 1 : m
    % Compute Cross-Entropy error 
 
    % Why need of transpose of X?
    sig_value = sigmoid(theta'*X(i,:)');    % sigmoid value of each sample
    
    if (sig_value >= threshold)
        p(i) = 1;
    else 
        p(i) = 0;
    end
end

p = p';
end