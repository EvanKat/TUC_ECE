% A
clear;
clc;
close all;

%% 1.Generate Bit seq
N = 100;
% 3N bits generation 
b_seq = (sign(randn((3*N), 1)) + 1)/2;

%% 2.bits_to_PSK_8
% 8PSK Symbols
X = bits_to_PSK_8(b_seq);

%% 3.X(t) conv phi(t)
% Generate the palse
T = 0.001;
over = 10;
Ts = T/over;
a = 0.5;
A = 4;
[phi, t] = srrc_pulse(T, over, A, a);

% In-phase -> cos() 
Xi = X(:,1);
% Quadrature -> sin()
Xq = X(:,2);

time = 0:T:((N*T)-T);
figure('Name', 'Symbol train');
% Starting Xi
subplot(2,2,1);
stem(time,X(:,1));
xlabel('Time');
ylabel('X_i');
hold on;
grid on;
% Starting Xq
subplot(2,2,2);
stem(time,X(:,2));
xlabel('Time');
ylabel('X_q');
hold on;
grid on;
% symbol Space
subplot(2,2,3);
plot3(time,X(:,1), X(:,2), 'o');
xlabel('Time');
ylabel('X_i');
zlabel('X_q');
title('X(t)');
hold on
grid on;
% scatter plot of starting info
subplot(2,2,4);
scatter(X(:,1), X(:,2),'o');
hold on;
grid on;
xlabel('Time Duration');
title('"Space" of Symbols.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Upsample the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_upsample=(1/Ts) .* upsample(X, over);
Xi_upsample = X_upsample(:,1);
Xq_upsample = X_upsample(:,2);
% Signal Duration
X_time = 0:Ts:(N*T)-Ts;

% Convolition with SRRC
Xi_conv = conv(Xi_upsample, phi)*Ts;
Xq_conv = conv(Xq_upsample, phi)*Ts;
time_conv = t(1) + X_time(1):Ts:t(end) + X_time(end);

X_conv(:,1) = Xi_conv;
X_conv(:,2) = Xq_conv;

figure('Name','X-PHI');
subplot(1,2,1);
plot(time_conv,Xi_conv);
title('X_i\ast\phi(t)');
xlabel('Time');
xlim([(time_conv(1)-5*Ts) (time_conv(end)+5*Ts)]);
hold on;
subplot(1,2,2);
plot(time_conv,Xq_conv);
title('X_q\ast\phi(t)');
xlabel('Time');
xlim([(time_conv(1)-5*Ts) (time_conv(end)+5*Ts)]);

% Periodograms
Nf = 4096;
Fs = 1/Ts; % Sampling Frequency 
f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf);
% Xi_F
Xi_F = fftshift(fft(Xi_conv, Nf)*Ts);
Pxi_F_num = power(abs(Xi_F),2);
Pxi_F = Pxi_F_num./(time_conv(end)-time_conv(1));

%Xq_F
Xq_F = fftshift(fft(Xq_conv, Nf)*Ts);
Pxq_F = power(abs(Xq_F),2)./(time_conv(end)-time_conv(1));

% Periodogram of Xi
figure('Name','X_i Peridogram');
subplot(1,2,1);
hold on;
plot(f_axis, Pxi_F);
title('P_{X_i}(F)');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);
hold on;
subplot(1,2,2);
semilogy(f_axis, Pxi_F);
title('P_{X_i}(F) in log scale');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);

% Periodogram of Xq
figure('Name','X_q Peridogram');
subplot(1,2,1);
hold on;
plot(f_axis, Pxq_F);
title('P_{X_q}(F)');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);
hold on;
subplot(1,2,2);
semilogy(f_axis, Pxq_F);
title('P_{X_q}(F) in log scale');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);

%% 4.multiply with carries
time = time_conv;
F0 = 2000;
% Caries
Ci = (2*cos(2*pi*F0*time))';
Cq = ((-2)*sin(2*pi*F0*time))';

Xi_c = Xi_conv .* Ci;
Xq_c = Xq_conv .* Cq;

% Plots - Periodograms
figure('Name','Xi_c');
subplot(2,1,1);
plot(time,Xi_c);
title('X_i(t)');
hold on;
subplot(2,1,2);
plot(time,Xq_c);
title('X_q(t)');
xlabel('Time');

% Periogramms
% P_Xi
Xi_c_F = fftshift(fft(Xi_c, Nf)*Ts);
P_Xi_c_F = power(abs(Xi_c_F),2)./(time(end)-time(1));
% P_Xq
Xq_c_F = fftshift(fft(Xq_c, Nf)*Ts);
P_Xq_c_F = power(abs(Xq_c_F),2)./(time(end)-time(1));

% Figures
% P_xi
figure('Name', 'P_X_c_F')
subplot(2,2,1);
plot(f_axis, P_Xi_c_F);
title('P_{X_i}(F)');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency');
hold on;
subplot(2,2,2);
semilogy(f_axis,P_Xi_c_F);
title('P_{X_i}(F) on log scale');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency')
hold on;
% P_xq
% figure('Name', 'P_Xq_c_F')
subplot(2,2,3);
plot(f_axis, P_Xq_c_F);
title('P_{X_q}(F)');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency')
% xlabel('Frequency');
hold on;
subplot(2,2,4);
semilogy(f_axis,P_Xq_c_F);
title('P_{X_q}(F) on log scale');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency')

%% 5.X(t) design
% Entry Signal
X_t = Xi_c + Xq_c;

X_t_F = fftshift(fft(X_t, Nf)*Ts);
P_X_t_F = power(abs(X_t_F),2)./(time(end)-time(1));

% Entry Plot and Periodogramms
figure('Name', 'Entry signal/Peridograms')
subplot(2,1,1);
plot(time, X_t);
title('X(t)');
% xlim([time(1) time(end)]);
xlabel('Time');
hold on;

subplot(2,2,3);
plot(f_axis,P_X_t_F);
title('P_{X}(F)');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency')
hold on;
subplot(2,2,4);
semilogy(f_axis,P_X_t_F);
title('P_{X}(F) on log scale');
xlim([f_axis(1) f_axis(end)]);
xlabel('Frequency')


%% 7.Generate/add White Noise 
% SNR = Ex/En = 1/2*sigma^2_N
SNRdb = 20;
sq_sigma = 1/(Ts * 10^(SNRdb/10)); 
mu = 0;

% White gaussian noise
W_t = randn(length(X_t),1)*sqrt(sq_sigma) + mu;

Y_t = X_t + W_t;


%% 8.Y(t) * Carries
Ci = (cos(2*pi*F0*time))';
Cq = ((-sin(2*pi*F0*time)))';

Y_t_i = Y_t.*Ci;
Y_t_q = Y_t.*Cq;

Y_F_i = fftshift(fft(Y_t_i, Nf)*Ts);
P_Y_F_i = power(abs(Y_F_i),2)./(time(end)-time(1));

Y_F_q = fftshift(fft(Y_t_q, Nf)*Ts);
P_Y_F_q = power(abs(Y_F_q),2)./(time(end)-time(1));

% plots & periodogramms
% Y_i
figure('Name', 'Y(t)_i');
% Yi(t) 
subplot(2,1,1);
plot(time,Y_t_i);
title('Y_i(t)');
xlabel('Time');
hold on;
% Peridogramms
subplot(2,2,3);
plot(f_axis, P_Y_F_i);
title('P_{Y_i}(F)');
xlabel('Frequency');
hold on;
subplot(2,2,4);
semilogy(f_axis, P_Y_F_i);
title('P_{Y_i}(F) in log scale');
xlabel('Frequency');

% Y_q
figure('Name', 'Y(t)_q');
% Yq(t) 
subplot(2,1,1);
plot(time,Y_t_q);
title('Y_q(t)');
hold on
% stem(time,)
xlabel('Time');
hold on;
% Peridogramms
subplot(2,2,3);
plot(f_axis, P_Y_F_q);
title('P_{Y_q}(F)');
xlabel('Frequency');
hold on;
subplot(2,2,4);
semilogy(f_axis, P_Y_F_q);
title('P_{Y_q}(F) in log scale');
xlabel('Frequency');

%% 9. Y(t) conv phi(t)
% Convlolution
Y_conv_i = conv(Y_t_i,phi)*Ts;
Y_conv_q = conv(Y_t_q,phi)*Ts;
time = time(1) + t(1) : Ts : time(end) + t(end);
% periodogramms
Y_F_conv_i = fftshift(fft(Y_conv_i , Nf)*Ts);
P_Y_F_i = power(abs(Y_F_conv_i),2)./(time(end)-time(1));

Y_F_conv_q = fftshift(fft(Y_conv_q , Nf)*Ts);
P_Y_F_q = power(abs(Y_F_conv_q),2)./(time(end)-time(1));

% plots & periodogramms
% Y_conv_i
figure('Name', 'Y(t)_i_conv');
% Yi_conv_(t) 
subplot(2,1,1);
plot(time,Y_conv_i);
hold on;

title('Y_i^''(t) = Y_i(t) \ast \phi(t)');
xlabel('Time');
hold on;
% Peridogramms
subplot(2,2,3);
plot(f_axis, P_Y_F_i);
title('P_{Y_i^''}(F)');
xlabel('Frequency');
hold on;
subplot(2,2,4);
semilogy(f_axis, P_Y_F_i);
title('P_{Y_i^''}(F) in log scale');
xlabel('Frequency');

% Y_q
figure('Name', 'Y(t)_q_conv');
% Yq(t) 
subplot(2,1,1);
plot(time,Y_conv_q);
title('Y_q^''(t) = Y_q(t) \ast \phi(t)');
xlabel('Time');
hold on;
% Peridogramms
subplot(2,2,3);
plot(f_axis, P_Y_F_q);
title('P_{Y_q^''}(F)');
xlabel('Frequency');
hold on;
subplot(2,2,4);
semilogy(f_axis, P_Y_F_q);
title('P_{Y_q^''}(F) in log scale');
xlabel('Frequency');

%% 10.Sample the output
% Find the start and end of each pulse
% Yi'(t)
index_first = find(abs(time) < Ts/over);
index_last = find(time >= ((N*T)-Ts), 1);

% The upscaled "tranmeted info"
Yi_t = Y_conv_i(index_first:index_last);
Yq_t = Y_conv_q(index_first:index_last);

Yi_t = downsample(Yi_t, over);
Yq_t = downsample(Yq_t, over);

% Output Signal 
Y(:,1) = Yi_t;
Y(:,2) = Yq_t;

time = 0:T:(N*T)-T;
% Output figures
figure('Name','Output Coordinates');
subplot(2,1,1);
stem(time,Yi_t);
hold on;
% stem(time,Xi);
title('Y_i(t)');
xlabel('Time');
hold on;
subplot(2,1,2);
stem(time,Yq_t);
hold on;
% stem(time,Xi);
title('Y_q(t)');
xlabel('Time');

figure('Name','Output Signal');
subplot(1,2,1);
plot3(time,Y(:,1),Y(:,2),'o');
hold on;
grid on;
hold on;
% stem(time,Xi);
title('Y(t)');
xlabel('Time');
ylabel('Y_i(t)');
zlabel('Y_q(t)');
hold on;
% plot3(time,X(:,1), X(:,2), 'o');
subplot(1,2,2);
scatter(Y(:,1), Y(:,2),'o');
hold on;
grid on;
xlabel('In-phase');
ylabel('Quardature');
title('Scatterplot of Symbols.');


%% 11.PSK to Bit
[est_X, est_bit_Seq] = detect_PSK_8(Y);


%% Number Of Symbol Error
num_of_symbol_errors = symbol_errors(est_X, X);

%% Number of Bit Error
num_of_bit_errors = bit_errors(est_bit_Seq, b_seq);


% disp(2*Q(1/sqrt(sq_sigma)*sin(pi/8)));
















% figure('Name','Output Signal');
% subplot(2,1,1);
% plot(time,Yi_t);
% hold on;
% stem(time,Xi);
% title('Y_i(t)');
% xlabel('Time');
% hold on;
% subplot(2,1,2);
% plot(time,Yq_t);
% hold on;
% stem(time,Xi);
% title('Y_q(t)');
% xlabel('Time');


% hold on;
% % stem(Yi_t);
% hold on;
% stem(Xi_conv);


% Y_conv_i
% Y_conv_q
% time
