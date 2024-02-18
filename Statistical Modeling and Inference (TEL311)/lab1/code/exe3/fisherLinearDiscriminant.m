function v = fisherLinearDiscriminant(X1, X2)

    m1 = size(X1, 1);
    m2 = size(X2, 1);

    mu1 = sum(X1)/m1; % mean value of X1
    mu2 = sum(X2)/m2; % mean value of X2

%     S1 = cov(X1); % scatter matrix of X1
%     S2 = cov(X2); % scatter matrix of X2
    S1 = 0;
    S2 = 0;
    for i = 1:length(X1)
        S1 = S1 + (X1(i,:) - mu1)'*(X1(i,:) - mu1);
        S2 = S2 + (X2(i,:) - mu2)'*(X2(i,:) - mu2);
    end
%    length(S1)
    S1 = S1/(length(X1));
    S2 = S2/(length(X2));


    Sw = S1 + S2;
    
    v = inv(Sw) .* (mu1 - mu2) * (mu1 - mu2)';
%     v = inv(Sw) * (mu1 - mu2); % optimal direction for maximum class separation 

    v = v/norm(v);% return a vector of unit norm
