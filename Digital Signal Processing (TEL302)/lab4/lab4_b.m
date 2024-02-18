close all;
clear all;
clc

wc = 0.5*pi;
Fs = 0.1*10^3;

% lengths
N1 = 21;
N2 = 41;

% Digital frequency
f_cutoff = wc/(2*pi);
wc_dig = f_cutoff/(Fs/2);

% Create windows
win_ham_1 = hamming(N1);
win_ham_2 = hamming(N2);
win_han_1 = hann(N1);
win_han_2 = hann(N2);

% low pass filter construction
    % Hamming
lp1_ham = fir1(N1-1, wc_dig, win_ham_1);
lp2_ham = fir1(N2-1, wc_dig, win_ham_2);
    % Hanning
lp1_han = fir1(N1-1, wc_dig, win_han_1);
lp2_han = fir1(N2-1, wc_dig, win_han_2);

% Filter frequency response
[H_z_ham1 , w1] = freqz(lp1_ham, N1);
[H_z_ham2 , w2] = freqz(lp2_ham, N2);
[H_z_han1 , w3] = freqz(lp1_han, N1);
[H_z_han2 , w4] = freqz(lp2_han, N2);

figure('Name', 'Frequency response LPF')
subplot(2,1,1)
plot(w1, 20*log10(abs(H_z_ham1)));
hold on;
plot(w2, 20*log10(abs(H_z_ham2)));
hold off;
title('Hamming Filter Frequency response');
ylabel('Amplitude (dB)')
xlabel('Angular frequency (rad/s)')
legend('N=21', 'N=41')

subplot(2,1,2)
plot(w3, 20*log10(abs(H_z_han1)));
hold on;
plot(w4, 20*log10(abs(H_z_han2)));
hold off;
title('Hanning Filter Frequency response');
ylabel('Amplitude (dB)')
xlabel('Angular frequency (rad/s)')
legend('N=21', 'N=41')

% Create signal x(t)
fs_arr = [50 100];

for fs=fs_arr;
    Ts = 1 / fs;
    ns = 500;
    t = 0:Ts:(ns-1)*Ts;

    x = sin(15*t) + 0.25*sin(200*t);

    % Filter signal_1 using the digital LPF
    y1_ham = filter(abs(H_z_ham1), 1, x);
    y2_ham = filter(abs(H_z_ham2), 1, x);

    y1_han = filter(abs(H_z_han1), 1, x);
    y2_han = filter(abs(H_z_han2), 1, x);

    % Number of samples for fft
    NFFT = 2048;

    % frequency axis
    f = fs*(-NFFT/2:NFFT/2-1)/NFFT;

    % fourier transform
    x_F = fftshift(fft(x,NFFT)*Ts);

    % fourier transform with filters
    y1_ham_F = fftshift(fft(y1_ham,NFFT)*Ts);
    y2_ham_F = fftshift(fft(y2_ham,NFFT)*Ts);
    y1_han_F = fftshift(fft(y1_han,NFFT)*Ts);
    y2_han_F = fftshift(fft(y2_han,NFFT)*Ts);

    % Plot filtered signal_1 sampled
    fig = figure('Name','1.Sampled Input Signal before/after filter in spectrum');
    subplot(3,2,[1 2])
    plot(f, abs(x_F));
    title(sprintf('Sampled Input Signal in spectrum \nFs = %d Hz', fs));
    hold on;
    ylabel('Amplitude')
    xlabel('Frequency (Hz)');
    
    subplot(3,2,3)
    plot(f, abs(y1_ham_F));
    hold on;
    ylabel('Amplitude')
    xlabel('Frequency (Hz)');
    title('Hamming N=21');
    ylim([0 0.9])
    subplot(3,2,4)
    plot(f, abs(y2_ham_F));
    hold on;
    ylabel('Amplitude')
    xlabel('Frequency (Hz)');
    title('Hamming N=41');
    ylim([0 0.9])
    subplot(3,2,5)
    plot(f, abs(y1_han_F));
    hold on;
    ylabel('Amplitude')
    xlabel('Frequency (Hz)');
    title('Hanning N=21');
    ylim([0 0.9])
    subplot(3,2,6)
    plot(f, abs(y2_han_F));
    hold on;
    ylabel('Amplitude')
    xlabel('Frequency (Hz)');
    title('Hanning N=41');
    ylim([0 0.9])
    set(fig,'Position',[0 0 1150 800]);
end