close all;
clear all;
clc

wc = 0.4*pi;
Fs = 0.1e3;
N = 21;

% Digital frequency
f_cutoff = wc/(2*pi);
wc_dig = f_cutoff/(Fs/2);

% Create windows
win_rec = rectwin(N);
win_ham = hamming(N);

% low pass filter construction
    % Rectangular
lp1 = fir1(N-1, wc_dig, win_rec);
    % Hamming
lp2 = fir1(N-1, wc_dig, win_ham);

% Filter frequency response
[H_z_rect , w1] = freqz(lp1, N);
[H_z_ham , w2] = freqz(lp2, N);

figure('Name','Filters')
semilogy(w1, (abs(H_z_rect)));
hold on;
semilogy(w2, (abs(H_z_ham)));
grid on;
legend('rectangular','hamming');
xlabel('Frequency')
ylabel('Amplitude')