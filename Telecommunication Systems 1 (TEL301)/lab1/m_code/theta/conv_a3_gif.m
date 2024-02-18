%% This code is used for presentation purposes only
clc; clear all; close all;

Ts = 0.01;
T = 16;
t = -3*T:3*T; % Time range
X = zeros(1,length(t)); x1 = -T; x2 = 0; % Input signal and its range
H = zeros(1,length(t)); h1 = 0; h2 = T; % Impulse responce and its range
Y = zeros(1,length(t)); xh1 = x1+h1; xh2 = x2+h2; % Convolution output

% h = zeros(1,length(t));
% h (t>-T/2+10 & t<T/2+10) = 1./sqrt(T);
h_1 = (t>h1 & t<h2/2).*1/sqrt(T);
h_2 = (t>h2/2 & t<h2).*(-1)/sqrt(T);
h = h_1 + h_2;
% h = (rectangularPulse(x1,x2,x1:0.1:x2).*1/sqrt(T))*/; h1(t==0)=1/sqrt(T);
x = fliplr(h); %x(t==0)=1/sqrt(T)% h(t) = phi(-t) 

% x = sin(pi*t/10)./(pi*t/10); x(t==0)=1; % Generate input signal
% % h = t./t; h(t==0)=1; % Generate impulse respose
% h = exp(-0.002*t.^2); % Generate impulse respose

H(t>=h1&t<=h2) = h(t>=h1&t<=h2); % Fit the input signal within range
X(t>=x1&t<=x2) = x(t>=x1&t<=x2); % Fit the impulse response within range
%disp(h(t>=h1&t<=h2));
disp(X(t>=-x2&t<=x1));
disp(x(t>=-x2&t<=x1));
subplot(3,2,2); 
plot(t,X,'LineWidth',3); title('\phi(-t)'); grid on;
subplot(3,2,1); 
plot(t,H,'r','LineWidth',3); title('\phi(t)'); grid on;

k = 0;
for n = xh1:xh2 % Convolution limits
    % Convolution steps
    f = fliplr(X);           % Step 1: Flip 
    Xm = circshift(f,[0,n]); % Step 2: Shift
    m = Xm.*H;               % Step 3: Multiply 
    Y(t==n) = sum(m);        % Step 4: add/integrate/sum
    
%     Y = conv(H,X)*Ts;

    % Convolution operation live
    subplot(3,2,[3 4]); 
    plot(t,H,'r',t,circshift(fliplr(X),[0,n]),'LineWidth',3); grid on;
    title('Convolution operation: Flip, Shift, Multiply, and add')
    
    % Result of convolution live
    subplot(3,2,[5 6]); 
    p = plot(t,Y,'m','LineWidth',3); axis tight; grid on;
    title('R_{\phi\phi}(\tau)')
    
%     % Save each frame of figure 
%     k = k + 1;
%     saveas(p, ['pepe' num2str(k) '.png'])
    
    pause(0.2); % Pause for a while
end