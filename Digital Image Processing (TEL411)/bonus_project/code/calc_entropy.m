function H = calc_entropy(inp_matrix, A, R)
    L = 2^R;
    Delta = (2*A) / (L);
    
    [r, c] = size(inp_matrix);
    
    % Array for probabilities
    Probs = zeros(1, L+1);
    
    % entropy
    H = 0;
    ki = 0;
    for k=-L/2:L/2
        ki = ki + 1;

        % the number of times the 𝑘-th intensity appears in the image
        counter = length(find(inp_matrix == k*Delta));

        % Calculate the probability for each level
        Probs(ki) = counter / (r*c);
        if(Probs(ki) > 0)
            H = H + Probs(ki)*log2(Probs(ki));
        end
    end
    H = -H;

end
