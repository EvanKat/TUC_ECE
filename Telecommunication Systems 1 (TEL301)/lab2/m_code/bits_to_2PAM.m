function [X] = bits_to_2PAM(b)
% Convertion of bit array to 2-PAM Symbols
% 
%
%       Input Bit b(i) |     0    |    1
%       -----------------------------------
%       Output 2-PAM   |    +1    |   -1
%        Symbol X(i)   |         
                 

for i =1:length(b)
%     if b(i)~=0 && b(i)~=1
%         disp(['Bit in position' num2str(i-1) 'is not binary']);
%         continue;
%   end
    X(i)=(-1)^b(i);
end

% for i =1:length(b)
%     if (b(i) == 0)
%         X(i) = 1;
%     else
%         X(i) = -1;
%     end
% end
end