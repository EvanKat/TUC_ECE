function [cnv,cnv_time] = my_conv(x1,n1,x2,n2)
%  A custom convolution function 

% Convolutuion duration
cnv_time = n1(1) + n2(1): n1(end) + n2(end);

% Zero padding input signals to mach convolution duration (helps in their multiplaction)
x1_pad = [zeros(1,abs(n2(1))) x1 zeros(1,abs(n2(end)))]; % Zero Pading x1 signal
x2_pad = [zeros(1,abs(n1(1))) x2 zeros(1,abs(n1(end)))]; % Zero Pading x2 signal

% Reverce x2 input (zero-paded) signal
x2_pad_rev = x2_pad(end:-1:1);
n2_rev = fliplr(-cnv_time); % adjust time (no need here)

% Convolution
cnv = zeros(1, length(cnv_time)); % buffer
for k = cnv_time
    % Signal circular shift for every discrete moment.
    x2_shift = circshift(x2_pad_rev,[0,k]);
    % S
    cnv(n2_rev==k) = sum(x1_pad.*x2_shift); % Add Multupled values
end
end

