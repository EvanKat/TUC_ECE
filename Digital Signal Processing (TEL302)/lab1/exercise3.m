clear all;
clc;
close all;

% Signal generation
T = 0.001; % step
N = 2000; % pulse duration 10 s
t = 0:T:((N*T)-T);
x = 10*cos(2*pi*20*t)-4*sin(2*pi*40*t+5);

% To encounter aliasing 
fs = 100;
Ts = 1/fs; % step
N = 128; % Number of samples
t1 = 0:Ts:((N*Ts)-Ts);
x_sampled = 10*cos(2*pi*20*t1)-4*sin(2*pi*40*t1+5);

% Plot the signal

figure;
plot(t,x);
hold on;
stem(t1,x_sampled, 'r');
title('Original vs Sampled signal (f_s = 100 Hz)')
xlabel('Time');
ylabel('Amplitude');
legend('x(t)', 'x(nTs)');
xlim([0 t1(end)])
ylim([-10 20])

% fft of x(nTs)
NFFT = 1024;
L=length(t1);
X_sampled = fftshift(fft(x_sampled,NFFT));
f = fs*(-NFFT/2:NFFT/2-1)/NFFT;         % fs = 1/Ts sampled signal
figure
plot(f,abs(X_sampled)/L, 'r');
title('X(f) sampled frequency domain');
xlabel('Frequency (Hz)')
ylabel('Amplitude');


%% B.
fs = 8000; % in Hz
Ts = 1/fs;
tmax = 0.05;
t = 0:Ts:((tmax)-Ts) ;    % in seconds
n = 1:length(t);
phi = 0;             % lab group id
% phi = 90;
% phi = 180;

x = zeros(1, length(t));

% NFFT =  2^nextpow2(length(x));
NFFT =  1024;


k=1;
N = ((475 - 100) / 125) + 1;
fig1 = figure;
for f0=100:125:475
    
    x = sin(2*pi*f0*t + phi);
    
    % fft of x(nTs)
    X_F = fftshift(fft(x,NFFT)*Ts);
    f = fs*(-NFFT/2:NFFT/2-1)/NFFT;         % fs = 1/Ts sampled signal
    
    subplot(N,2,k)
    plot(t, x,'Color',[1, 0, 0, 0.2])
    hold on;
    stem(t, x,'filled','MarkerSize',2, 'LineStyle','none') 
    title(sprintf('f_0= %d Hz', f0))
    xlabel('Time(s)')
    ylabel('Amplitude')
    
    subplot(N,2,(k+1))
    plot(f,abs(X_F))
    title(sprintf('f_0= %d Hz', f0))
    xlabel('Frequency')
    ylabel('Amplitude')
    xlim([-800 800]);

    set(gca,'xtick',[-475 -350 -225 -100 0 100 225 350 475]);
    k = k + 2;
end
set(fig1,'Position',[0 0 950 970]);


k=1;
N = ((475 - 100) / 125) + 1;
fig2 = figure;
for f0=7525:125:7900
    
    x1 = sin(2*pi*f0*t + phi); %wrong time variable 
    
    % fft of x(nTs)
    X_F1 = fftshift(fft(x1,NFFT)*Ts);
    f = fs*(-NFFT/2:NFFT/2-1)/NFFT;         % fs = 1/Ts sampled signal
    
    subplot(N,2,k)
    plot(t, x1,'Color',[1, 0, 0, 0.2])
    hold on;
    stem(t, x1,'filled','MarkerSize',2, 'LineStyle','none') 
    title(sprintf('f_0= %d Hz', f0))
    xlabel('Time(s)')
    ylabel('Amplitude')
    
    subplot(N,2,(k+1))
    plot(f,abs(X_F1))
    title(sprintf('f_0= %d Hz', f0))
    xlabel('Frequency')
    ylabel('Amplitude')
    xlim([-800 800]);

    set(gca,'xtick',[-475 -350 -225 -100 0 100 225 350 475]);
    k = k + 2;
end
set(fig2,'Position',[0 0 950 970]);
