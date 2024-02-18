clear all;
close all;
clc

%% Manual Convolution vs System Convolution
% signal_1
nu = -10:27;
u = (nu>=0).*nu;
figure('Name','Starting Signals');
subplot(2,1,1);
stem(nu, u,'filled','MarkerSize',4, 'LineStyle','--','MarkerFaceColor','black')
title('x_1[n] = u[n],  \forall n \in [-10,20]')
xlabel('Time', 'color', 'red')
ylabel('Amplitude', 'color', 'red')
ylim([(min(u)-0.2) (max(u)+0.2)]);
grid on;

% signal_2
nh = -12:14;
h = (1/2).^abs(nh);
subplot(2,1,2);
stem(nh, h,'filled','MarkerSize',4, 'LineStyle','--','MarkerFaceColor','black')
title('x_2[n] =  (^1/_2)^n  ,  \forall n \in [-12,14]')
xlabel('Time', 'color', 'red')
ylabel('Amplitude', 'color', 'red')
ylim([(min(h)-0.2) (max(h)+0.2)]);
grid on;


[my_cnv,my_cnv_time]= my_conv(u,nu,h,nh);

% Manual Convolution
figure('Name','Convolution Signals');
subplot(2,1,1);
stem(my_cnv_time,my_cnv,'filled','MarkerSize',4, 'LineStyle','--','MarkerFaceColor','black');
title('Manual Convolution');
ylabel('Amplitude', 'color', 'red')
xlabel('Time', 'color', 'red')
grid on;

% In system Convolution
subplot(2,1,2);
stem(my_cnv_time,conv(u,h),'filled','MarkerSize',4, 'LineStyle','--','MarkerFaceColor','black');
title('In System Convolution');
ylabel('Amplitude', 'color', 'red')
xlabel('Time', 'color', 'red')
grid on;

%% Theorem Rrove

% Fourier Transormation of each input signal
NFFT = 100;
f = (-NFFT/2:NFFT/2-1)/NFFT; %Frequency Vector
U = fftshift(fft(u,NFFT));
H = fftshift(fft(h,NFFT));
Y = fftshift(fft(my_cnv,NFFT));

figure('Name', 'Input Signal Frequences')
subplot(2,1,1);
plot(f,abs(H)/(length(h)),'r');
title('H(f) frequency domain');
xlabel('Frequency (Hz)')
ylabel('Amplitude');
grid on;

subplot(2,1,2)
plot(f,abs(U)/(length(u)),'r');
title('U(f) frequency domain');
xlabel('Frequency (Hz)')
ylabel('Amplitude');
grid on;

figure('Name', 'Convolution Frequences')
subplot(2,1,1);
plot(f,abs(Y)/(length(Y)),'r');
title('f\{u(t)*h(t)\}');
xlabel('Frequency (Hz)')
ylabel('Amplitude');
grid on;

subplot(2,1,2);
Y_mult = abs(U.*H);
plot(f,Y_mult/(length(Y)));
title('U(F) x H(F)');
xlabel('Frequency (Hz)')
ylabel('Amplitude');
grid on;
