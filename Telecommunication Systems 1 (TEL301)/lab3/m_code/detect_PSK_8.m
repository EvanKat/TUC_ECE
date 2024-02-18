function [est_X, est_bit_seq] = detect_PSK_8(Y)
%DETECT_PSK_8: Detect and returns the estimated Symbol Sequence
%
%   Estimated X Sequence:
%   Each symbol of the given symbol sequence Y, is stored and measured
%   the distance of each Symbol "Center" S. 
%   The estimated output Symbol est_X(i) is the minimum counted distance.
%
%   Estimated Bit Sequnce:
%   The est_b_seq(i:i+2) is a translated 8_PSK Symbol from the estimated 
%   X sequence to a 3 bit Gray Code.
%
%   m = 0 -> [000]
%   m = 1 -> [001]
%   m = 2 -> [011]
%   m = 3 -> [010]
%   m = 4 -> [110]
%   m = 5 -> [111]
%   m = 6 -> [101]
%   m = 7 -> [100]
S = zeros(8,2);
% Set Symbol Centers
for i = 0:1:7
    S((i+1),:) = Coordinates(i);
end

est_X = zeros(length(Y),2);
est_bit_seq = zeros(length(Y)*3,1);


for i = 1:1:length(Y)
    dist = zeros(8,1);
    
    % store all distances for the given
    for j=1:8
        dist(j) = norm(S(j,:) - Y(i,:));
    end
    
    [~, index] = min(dist);
    
    est_X(i,:) = S(index,:);
    
    
    if est_X(i,:) == S(1,:)
        est_bit_seq(i*3-2:i*3) = [0;0;0];
    elseif est_X(i,:) == S(2,:)
        est_bit_seq(i*3-2:i*3) = [0;0;1];
    elseif est_X(i,:) == S(3,:)
        est_bit_seq(i*3-2:i*3) = [0;1;1];
    elseif est_X(i,:) == S(4,:)
        est_bit_seq(i*3-2:i*3) = [0;1;0];
    elseif est_X(i,:) == S(5,:)
        est_bit_seq(i*3-2:i*3) = [1;1;0];
    elseif est_X(i,:) == S(6,:)
        est_bit_seq(i*3-2:i*3) = [1;1;1];
    elseif est_X(i,:) == S(7,:)
        est_bit_seq(i*3-2:i*3) = [1;0;1];
    else
        est_bit_seq(i*3-2:i*3) = [1;0;0];
     end
end

function a = Coordinates(m)
    a = [cos((2*pi*m)/8) sin((2*pi*m)/8)];
end
end
