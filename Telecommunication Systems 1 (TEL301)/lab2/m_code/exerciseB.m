%B
clear all;
close all;

T = 0.01; %Given Period
over = 10; %Oversampling factor
A = 4; %Half duration of the pulse in symbol periods
a = 0.5; %Roll-off factor
Ts = T / over; %sampling period
Fs = 1/Ts; % Sampling Frequency
K = 1000;
Nf = 4096;
% Generate the palse
[phi, t] = srrc_pulse(T, over, A, a);

% Frequency range
f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf);

% Fourier Transform of Phi
phi_F = fftshift(fft(phi, Nf)*Ts);
abs_phi_F = abs(phi_F);
Energy_phi = power(abs_phi_F,2);

% Exercise A.2
N = 100;
% Bits generation
b = (sign(randn(N, 1)) + 1)/2;

% Generate 2-PAM
X_2pam = bits_to_2PAM(b);

% Upsample X_2pam 
X_Upsampled = (1/Ts) * upsample(X_2pam, over);
X_Upsampled_time = 0:Ts:N*T-Ts;

% The Sum is the convolution X and phi
X = conv(X_Upsampled,phi)*Ts;
X_time = X_Upsampled_time(1)+t(1):Ts:X_Upsampled_time(end)+t(end);

% % Set figure
% figure('Name','2pamConvPhi');
% plot(X_time,X);
% hold on;
% title('X(t)');
% xlabel('Time');
% xlim([X_time(1) X_time(end)]);
% hold off;
% 50 < f < 450
f = 200;
theta = 2*pi*rand(1);
Y1=X.*cos(2*pi*f*X_time + theta);

% Plot Y(t)
figure('Name','Y(t)');
plot(X_time,Y1);
hold on;
title('Y(t)');
xlabel('Time');
xlim([X_time(1) X_time(end)]);
hold off;
% Average Periodogram of Y(t)
PyF_total = 0;
for i=1:K
    % bit array
    b = (sign(randn(N, 1)) + 1)/2;
    % bit 2pam 
    X_2pam = bits_to_2PAM(b);
    
    X_Upsampled = (1/Ts) * upsample(X_2pam, over);
    % X(t)
    X = conv(X_Upsampled,phi)*Ts;
    % Generate theta
    theta = 2*pi*rand(1);
    % Y(t)
    Y1 = X.*cos(2*pi*f*X_time + theta);
    
    Y = fftshift(fft(Y1, Nf)*Ts);
    
    % Periodogram
    Py_F_TotalTime= X_time(end) - X_time(1);
    PyF_total = PyF_total + (power(abs(Y),2)./Py_F_TotalTime);
end

PyF_average = PyF_total./K;
% Sx(f)
SxF = 1/T.*Energy_phi;

indexf0 = round(f/(Fs/Nf));

% SxF delayed
SxF1 = [zeros(1,indexf0) SxF(1:end-indexf0)];
SxF2 = [SxF(indexf0+1:end) zeros(1,indexf0)];

% SyF 
SyF = 1/4*(SxF1 + SxF2);
figure;
semilogy(SyF)


figure('Name','Py_Average')
semilogy(f_axis,PyF_average);
hold on;
title('P_Y(F)');
xlabel('Frequency');
hold on;
semilogy(f_axis,SyF);


figure('Name','Py_Average')
plot(f_axis,PyF_average);
hold on;
title('P_Y(F)');
xlabel('Frequency');
hold on;
plot(f_axis,SyF);
legend('','')