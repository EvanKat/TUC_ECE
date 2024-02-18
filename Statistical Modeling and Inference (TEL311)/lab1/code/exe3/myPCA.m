function [U, S] = myPCA(X)
%PCA Run principal component analysis on the dataset X
%   [U, S, X] = myPCA(X) computes eigenvectors of the covariance matrix of X
%   Returns the eigenvectors U, the eigenvalues (on diagonal) in S
%

% Useful values
[m, n] = size(X);

% Calculate covariance
R = 1/m*((X.')*X);

% Calculate eigvectors (U) and eigenvalues (S)
[U,S]=eig(R);


% Sorted eigenvalues 
S = diag(S);
[S,i]=sort(S,1,'descend');
S = diag(S);

% Sorted eigvectors 
 U = U(:,i);
end

