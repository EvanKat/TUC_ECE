function [X] = bits_to_4PAM(b)
% Convertion of bit array to 4-PAM Symbols
% 
%
% Input Bit b(i) |  00  |  01  |  11  |  10  |
%--------------------------------------------------
% Output 2-PAM   |  +3  |  +1  |  -1  |  -3  |
% Symbol X(i)    |
                 

for i = 1:2:length(b)
    bits = b(i:i+1);
    index = (i+1)/2;
    
    % B is type of (x1;x2;x3;x4;x5)
    if isequal(bits, [0;0])
        X(index) = +3;
    elseif isequal(bits, [0;1])
        X(index) = +1;
    elseif isequal(bits, [1;1])
        X(index) = -1;
    elseif isequal(bits, [1;0])
        X(index) = -3;
    end
end
end