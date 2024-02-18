%A
% Exercise A.1
clear all;
close all;

T = 0.01; %Given Period
over = 10; %Oversampling factor
A = 4; %Half duration of the pulse in symbol periods
a = 0.5; %Roll-off factor
Ts = T / over; %sampling period
Fs = 1/Ts; % Sampling Frequency 

% Number of samples
K = 1000; 

% Step
% Nf = 1024;
Nf = 4096;

% Generate the palse
[phi, t] = srrc_pulse(T, over, A, a);

% Frequency range
f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf);

% Fourier Transform of Phi
phi_F = fftshift(fft(phi, Nf)*Ts);
abs_phi_F = abs(phi_F);
Energy_phi = power(abs_phi_F,2);
% Set figure
figure('Name','Energy.SRRC.logScale');
semilogy(f_axis,Energy_phi);
hold on;
title('Energy Spectrum of SRRC');
xlabel('Frequency');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
hold off;

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

% Set figure
figure('Name','2pamConvPhi');
plot(X_time,X);
hold on;
title('X(t)');
xlabel('Time');
xlim([X_time(1) X_time(end)]);
hold off;

% Exercise A.3
% Fourier transform of X
X_F = fftshift(fft(X, Nf)*Ts);
% Periodogram Numerator - Denominator
Px_F_num = power(abs(X_F),2);
PX_F_denom = X_time(end) - X_time(1);

% Periodogram of 2_PAM
Px_F_2PAM = Px_F_num/PX_F_denom;

%% Separate the plots
% Set figure
figure('Name','Periodograms');
subplot(1,2,1);
hold on;
plot(f_axis, Px_F_2PAM);
title('P_X(F)');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);
hold off;
hold on;
subplot(1,2,2);
semilogy(f_axis, Px_F_2PAM);
title('P_X(F)');
xlabel('Frequency');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
hold off;

% A.3.2

PxF_total = 0;

% K different bit arrays
for i=1:K
    % Bit array
    b = (sign(randn(N, 1)) + 1)/2;
    
    % 2-PAM
    X_2pam = bits_to_2PAM(b);

    % Upsample x_delta and upsampled time 
    X_Upsampled = (1/Ts) * upsample(X_2pam, over);
    X_Upsampled_time = 0:Ts:N*T-Ts;

    % The Sum is the convolution X and phi
    X = conv(X_Upsampled,phi)*Ts;
    X_time = X_Upsampled_time(1)+t(1):Ts:X_Upsampled_time(end)+t(end);

    % Fourier transform of X
    X_F = fftshift(fft(X, Nf)*Ts);
    % Periodogram
    Px_F_num = power(abs(X_F),2);
    PX_F_denom = X_time(end) - X_time(1);
    PxF_total = PxF_total + (Px_F_num./PX_F_denom);
end

PxF_2PAM_average = PxF_total./K;
PxF_theoretical = 1/T .* Energy_phi;

% Set figure
figure('Name','PxF.Average');
semilogy(f_axis,PxF_2PAM_average);
hold on;
semilogy(f_axis,PxF_theoretical);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
legend('Average','Theoretical');

% Oso afxananete to K kai to N dld plisiazoume
% sto apeiro toso tha

% A.4
% 4PAM symbols
X_4pam = bits_to_4PAM(b);

% Upsample x and upsampled time 
X_Up = (1/Ts) * upsample(X_4pam, over);
X_Up_time = 0:Ts:(N/2)*T-Ts;

% The Sum is convolution X and phi
X = conv(X_Up,phi)*Ts;
X_time = X_Up_time(1)+t(1):Ts:X_Up_time(end)+t(end);

% Fourier transform of X
X_F = fftshift(fft(X, Nf)*Ts);
% Periodogram of 4_PAM
Px_F_4PAM = power(abs(X_F),2)/(X_time(end) - X_time(1));

% Set figure PxF 
% figure('Name','Periodograms');
% subplot(1,2,1);
% hold on;
% plot(f_axis, Px_F_4PAM);
% title('P_X(F)');
% xlabel('Frequency');
% xlim([-Fs/2 Fs/2]);
% hold off;
% hold on;
% subplot(1,2,2);
% semilogy(f_axis, Px_F_4PAM);
% title('P_X(F)');
% xlabel('Frequency');
% ylabel('Logarithmic');
% xlim([-Fs/2 Fs/2]);
% hold off;

% Set figure X(t)
figure('Name','4pamConvPhi');
plot(X_time, X);
hold on;
title('Upsampled X_{4PAM}(t)');
xlabel('Time');
xlim([X_time(1) X_time(end)]);
hold off;

PxF_4pamTotal = 0;

% K different bit arrays
for i=1:K
    % Bit array
    b = (sign(randn(N, 1)) + 1)/2;
    
    % 2-PAM
    X_4pam = bits_to_4PAM(b);

    % Upsample
    X_Up = (1/Ts) * upsample(X_4pam, over);
    X_Up_time = 0:Ts:(N/2)*T-Ts;

    % The Sum is the convolution X and phi
    X = conv(X_Up,phi)*Ts;
    X_time = X_Up_time(1)+t(1):Ts:X_Up_time(end)+t(end);

    % Fourier transform of X
    X_F = fftshift(fft(X, Nf)*Ts);
    % Periodogram
    Px_F_num = power(abs(X_F),2);
    PX_F_denom = X_time(end) - X_time(1);
    PxF_4pamTotal = PxF_4pamTotal + (Px_F_num/PX_F_denom);
end

PxF_4PAM_average = PxF_4pamTotal/K;
PxF_theoretical = 5/T * Energy_phi;

% Set figure
figure('Name','Px4pamF.Average');
semilogy(f_axis,PxF_4PAM_average);
hold on;
semilogy(f_axis,PxF_theoretical);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
legend('Average','Theoretical');


figure('Name','Periodograms');
subplot(1,2,1);
hold on;
plot(f_axis, Px_F_2PAM);
title('P_X(F)');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);
hold off;
hold on;
subplot(1,2,2);
semilogy(f_axis, Px_F_2PAM);
title('P_X(F)');
xlabel('Frequency');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
hold off;


%figure Px_2PAM and Px_4PAM
figure('Name','PxF.2-4.PAM');
subplot(1,2,1);
semilogy(f_axis,PxF_2PAM_average);
hold on;
semilogy(f_axis,PxF_4PAM_average);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
ylabel('Logarithmic');
legend('P_X(F)_{2PAM}','P_X(F)_{4PAM}');

subplot(1,2,2);
plot(f_axis,PxF_2PAM_average);
hold on;
plot(f_axis,PxF_4PAM_average);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
legend('P_X(F)_{2PAM}','P_X(F)_{4PAM}');



% Max amplitudes
% max_2PAM = max(PxF_2PAM_average);
% max_4PAM = max(PxF_4PAM_average);
% fprintf = ('Max of 2PAM periodogram is %.3f and of 4PAM periodogram %.3f', max_2PAM, max_4PAM )

