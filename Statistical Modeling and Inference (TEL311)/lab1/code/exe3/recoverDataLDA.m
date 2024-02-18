function [X_rec] = recoverDataLDA(Z, v)

X_rec = v .* Z;

X_rec = X_rec';


end
