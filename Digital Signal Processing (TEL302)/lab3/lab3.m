close all;
clear all;
clc


%% Exercise 1: Low Pass Filters
fs = 10^4;
Ts = 1/fs;

% passband 
Wp = 2*pi * 3*10^3;
% stopband
Ws = 2*pi * 4*10^3;
% ripple
Rp = 3;         
% attenuation
Rs = [30 50];

% number of elements
N = 2048;

% x-axis
f=linspace(0, fs/2, N);
fprintf('Low Pass Filters\n');

fig = figure;
for i=1:length(Rs)
    % LPF
    [n,Wc] = buttord(Wp, Ws, Rp, Rs(i), 's');
    fprintf('Attenuation: %d dB\n', Rs(i));
    fprintf('Order: %d, Cut-off frequency(rad/s): %.2f\n', n, Wc);
    
     % Get zeros, poles and gain
    [z,p,k] = buttap(n);

    % Convert z, p, gain to transfer function
    [num, den] = zp2tf(z,p,k);

    [numt,dent] = lp2lp(num,den,Wc);

    % Analog filter frequency response
    H_s = freqs(numt, dent, 2*pi*f);

    % Convert analog filter to digital
    [numd,dend] = bilinear(numt,dent,fs);
    
    % Save them for later
    numd_cell{i} = numd;
    dend_cell{i} = dend;
    
    % Digital filter frequency response
    H_z = freqz(numd, dend, f, fs);

    % Find the cut-off frequency of the digital filter
    for j=1:length(H_z)
        if(20*log10(abs(H_z(j))) < -3)
            break;
        end
    end
    fprintf('Cut-off frequency(digital LPF): %.2f Hz\n', f(j));

    % Plot analog and digital filters
    subplot(1,length(Rs),i)
    plot(2*pi*f, 20*log10(abs(H_s)));
    hold on;
    grid on;
    plot(2*pi*f, 20*log10(abs(H_z)), '--');
    hold off;
    legend('Analog', 'Digital','Location','southwest');
    title(sprintf('Filter Frequency response\nAttenuation = %d dB', Rs(i)));
    ylabel('Amplitude (dB)')
    xlabel('Angular frequency (rad/s)')
    ylim([-350 50])
end
set(fig,'Position',[0 0 1500 600]);


%% Exercise 2: highpass Chebyshev filter

% Orders 
n1 = 2;
n2 = 16;
% Passband ripple
pbr = 3;
% Cut off frequency
wc = 2;
% Sampling frequency
Ts = 0.2;
Fs = 1/Ts;
% # of samples
ns = 265;

f_cutoff = wc/(2*pi);
wc_dig = f_cutoff/(Fs/2);

[z1,p1] = cheby1(n1,pbr,wc_dig,'high');
[z2,p2] = cheby1(n2,pbr,wc_dig,'high');

w = linspace(0,1,ns);
tf1 = freqz(z1,p1,w);
tf2 = freqz(z2,p2,w);

magResponse1 = mag2db(abs(tf1));
magResponse2 = mag2db(abs(tf2));

fprintf('\nHighpass Chebyshev filter\n');
fprintf('Order: %d, Cut-off frequency(rad/s): %.2f\n', n1, wc_dig);
fprintf('Order: %d, Cut-off frequency(rad/s): %.2f\n', n2, wc_dig);

fig = figure('Name','Highpass Chebyshev filter');
plot(w,magResponse1);
hold on;
plot(w,magResponse2,'--');
grid on;
ylabel('Magnitude (dB)')
xlabel('Normalized Frequency (x \pi rad/sec)');
title('Highpass Chebyshev filter Magnitude response');
legend('n = 2','n = 16');
ylim([-300 50])
set(fig,'Position',[0 0 1125 800]);


        %% Exercise 3 1
% Input signal 1
fs = 10^4;
Ts = 1/ fs;
ns = 500;
t1 = 0:Ts:(ns-1)*Ts;
x1 = 1 + cos(1000*t1) + cos(16000*t1) + cos(30000*t1);

% Plot signal_1 sampled
fig = figure('Name','1.Sampled Input Signal');
stem(t1,x1,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title('Sampled Input Signal x(kT_s)');
ylim([-1.5 4.3]);
set(fig,'Position',[0 0 1150 800]);

%Filter signal_1 using the digital LPF
y1_30 = filter(numd_cell{1},dend_cell{1},x1);
y1_50 = filter(numd_cell{2},dend_cell{2},x1);

% Plot filtered signal_1 in frequency domain
fig = figure('Name','1.Sampled Input Signal after filter');
subplot(2,1,1)
stem(t1, y1_30,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title(sprintf('Filtered Sampled Input Signal \nAttenuation 30 db'));
ylim([-1.5 4.3]); 
subplot(2,1,2)
stem(t1, y1_50,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title(sprintf('Filtered Sampled Input Signal \nAttenuation 50 db'));
ylim([-1.5 4.3]);
set(fig,'Position',[0 0 1150 800]);

% Number of samples for fft
NFFT = 2048;

% frequency axis
f = fs*(-NFFT/2:NFFT/2-1)/NFFT;

% fourier transform
x1_F = fftshift(fft(x1,NFFT)*Ts);

% fourier transform
y1_30_F = fftshift(fft(y1_30,NFFT)*Ts);
y1_50_F = fftshift(fft(y1_50,NFFT)*Ts);

% Plot filtered signal_1 sampled
fig = figure('Name','1.Sampled Input Signal before/after filter in spectrum');
subplot(3,1,1)
plot(f, abs(x1_F));
title('Sampled Input Signal in spectrum')
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
subplot(3,1,2)
plot(f, abs(y1_30_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nAttenuation 30 db'));
subplot(3,1,3)
plot(f, abs(y1_50_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nAttenuation 30 db'));
set(fig,'Position',[0 0 1150 800]);


fig = figure('Name','1.Sampled Input Signal after filter in spectrum in log scale');
subplot(3,1,1)
semilogy(f, abs(x1_F));
title('Sampled Input Signal in spectrum')
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
subplot(3,1,2)
semilogy(f, abs(y1_30_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nAttenuation 30 db'));
subplot(3,1,3)
semilogy(f, abs(y1_50_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nAttenuation 50 db'));
set(fig,'Position',[0 0 1150 800]);



        %% Exercise 3 2
Fs = 1/0.2;
ns = 500;
t2 = 0:(1/Fs):ns*(1/Fs) - (1/Fs);

x2 = 1 + cos(1.5*t2) + cos(5*t2);


% Plot signal_2 sampled
fig = figure('Name','1.Sampled Input Signal');
stem(t2,x2,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title('Sampled Input Signal x(kT_s)');
ylim([-1.5 4.3]);
set(fig,'Position',[0 0 1122.24 793.92]);



% Filter signal_2 using the digital HPFs
y2_9 = filter(z1,p1,x2);
y2_16 = filter(z2,p2,x2);

% Plot filtered signal_2 in frequency domain
fig = figure('Name','2.Sampled Input Signal after filter');
subplot(2,1,1)
stem(t2, y2_9,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title(sprintf('Filtered Sampled Input Signal \nOrder: 2'));
subplot(2,1,2)
stem(t2, y2_16,'.');
hold on;
ylabel('Amplitude')
xlabel('Time(s)');
title(sprintf('Filtered Sampled Input Signal \nOrder: 16'));
set(fig,'Position',[0 0 1150 800]);

% FFT of input signals
NFFT = 2048;

% frequency axis
f = Fs*(-NFFT/2:NFFT/2-1)/NFFT;

% fourier transform
x2_F = fftshift(fft(x2,NFFT)*Ts);
% phi_ene = abs(PHI_F).^2;

% FFT of y2 
y2_9_F = fftshift(fft(y2_9,NFFT)*Ts);
y2_16_F = fftshift(fft(y2_16,NFFT)*Ts);

% Plot spectrum of filtered signal_2 sampled in 
fig = figure('Name','2.Sampled Input Signal after filter in spectrum');
subplot(3,1,1)
plot(f, abs(x2_F));
title('Sampled Input Signal in spectrum')
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
subplot(3,1,2)
plot(f, abs(y2_9_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nOrder: 2'));
subplot(3,1,3)
plot(f, abs(y2_16_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nOrder: 16'));
set(fig,'Position',[0 0 1150 800]);

% plot spectrums in log scale
fig = figure('Name','2.Sampled Input Signal after filter in spectrum in log scale');
subplot(3,1,1)
semilogy(f, abs(x2_F));
title('Sampled Input Signal in spectrum')
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
subplot(3,1,2)
semilogy(f, abs(y2_9_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nOrder: 2'));
subplot(3,1,3)
semilogy(f, abs(y2_16_F));
hold on;
ylabel('Amplitude')
xlabel('Frequency (Hz)');
title(sprintf('Filtered Sampled Input Signal in spectrum \nOrder: 16'));
set(fig,'Position',[0 0 1150 800]);

