function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

[r,c] = size(X);


for i = 1:c
    % Mean of each column (feature)
    mu(i) = mean(X(:,i));
    
    % Standart deviation of each column
    sigma(i) = std(X(:,i));

end

% Normalize each column independently
X_norm = (X - mu) ./ sigma ;

end
