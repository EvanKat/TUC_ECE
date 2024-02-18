function Z = projectDataPCA(X, U, K)
%PROJECTDATA Computes the reduced data representation when projecting only 
%on to the top k eigenvectors
%   Z = projectData(X, U, K) computes the projection of 
%   the normalized inputs X into the reduced dimensional space spanned by
%   the first K columns of U. It returns the projected examples in Z.
%
% Keep the first principal component

% A = U(:,1:K);

Z = (U(:,1:K).') * X.';

end
