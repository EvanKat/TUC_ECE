function [phi, t] = srrc_pulse(T, over, A, a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [phi, t] = srrc_pulse(T, over, A, a)                                          %
% OUTPUT                                                                        %    
%      phi: truncated SRRC pulse, with parameter T,                             %
%                 roll-off factor a, and duration 2*A*T                         %
%      t:   time axis of the truncated pulse                                    %
%                                                                               %
% INPUT                                                                         %      
%      T:  Nyquist parameter or symbol period  (positive real number)           %       
%      over: positive integer equal to T/T_s (oversampling factor)              %
%      A:  half duration of the pulse in symbol periods (positive integer)      %        
%      a:  roll-off factor (real number between 0 and 1)                        %
%                                                                               %
%    A. P. Liavas, Oct. 2020                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts=T/over; 

% Create time axis
t = [-A*T:Ts:A*T] + 10^(-8); % in order to avoid division by zero problems at t=0.

if (a>0 && a<=1)
   num = cos((1+a)*pi*t/T) + sin((1-a)*pi*t/T) ./ (4*a*t/T);
   denom = 1-(4*a*t./T).^2;
   phi = 4*a/(pi*sqrt(T)) * num ./ denom;
elseif (a==0)
   phi = 1/(sqrt(T)) * sin(pi*t/T)./(pi*t/T);
else
    phi = zeros(length(t),1);
    disp('Illegal value of roll-off factor')
    return
end
