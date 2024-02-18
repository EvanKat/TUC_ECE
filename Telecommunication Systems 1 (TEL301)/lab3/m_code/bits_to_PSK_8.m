function [X] = bits_to_PSK_8(b_seq)
%BITS_TO_PSK_8 
%   Converts a 3 bit Gray Code (Xn) itno a 8_PSK Symbol (Xm).
%
%          | Xi,m=cos(2*pi*m/8)|
%     Xm = |                   |  
%          | Xq,m=sin(2*pi*m/8)|
%   
%   [000] ->  m = 0
%   [001] ->  m = 1
%   [011] ->  m = 2
%   [010] ->  m = 3
%   [110] ->  m = 4
%   [111] ->  m = 5
%   [101] ->  m = 6
%   [100] ->  m = 7
A = 1;
X=zeros(length(b_seq)/3,2);
for i = 1:3:length(b_seq)
    bits=b_seq(i:i+2);
    index = (i+2)/3;
    if bits == [0;0;0]
        X(index,:) = Coordinates(0);
    elseif  bits == [0;0;1]
        X(index,:) = Coordinates(1);
    elseif  bits == [0;1;1]
        X(index,:) = Coordinates(2);
    elseif  bits == [0;1;0]
        X(index,:) = Coordinates(3);
    elseif  bits == [1;1;0]
        X(index,:) = Coordinates(4);
    elseif  bits == [1;1;1]
        X(index,:) = Coordinates(5);
    elseif  bits == [1;0;1]
        X(index,:) = Coordinates(6);        
    else
        X(index,:) = Coordinates(7);
    end
end
% Returns the Coordinates of the vector
function a = Coordinates(m)
    a=A*[cos((2*pi*m)/8) sin((2*pi*m)/8)];
end
end

