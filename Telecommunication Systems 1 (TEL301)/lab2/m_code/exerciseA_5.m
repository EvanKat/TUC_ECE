%A
% Exercise A.5

T = 0.02; %Given Period
over = 20; %Oversampling factor
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

% Set figure
figure('Name','Energy.SRRC');
semilogy(f_axis,Energy_phi);
hold on;
title('Energy Spectrum of SRRC');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);
hold off;

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

PxF_2PAM_av_2T = PxF_total./K;
PxF_theoretical = 1/T .* Energy_phi;

% Set figure
figure('Name','PxF.Average');
semilogy(f_axis,PxF_2PAM_av_2T);
hold on;
semilogy(f_axis,PxF_theoretical);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
legend('Average','Theoretical');

% Set figure
figure('Name','T` = 2T');
semilogy(f_axis,PxF_2PAM_av_2T);
hold on;
semilogy(f_axis,PxF_2PAM_average);
title('P_X(F)');
xlim([-Fs/2 Fs/2]);
legend('P_X(F)_{2T}','P_X(F)_{T}');

figure('Name','T` = 2T');
plot(f_axis,PxF_2PAM_av_2T);
hold on;
plot(f_axis,PxF_2PAM_average);
title('P_X(F)');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
legend('P_X(F)_{2T}','P_X(F)_{T}');

% Oso afxananete to K kai to N dld plisiazoume
% sto apeiro toso tha



