close all;
clear;

T = 0.1;
over = 10;
a = 0.5;
A = 5;
Ts = T/over;

% C1
% N = 10;
% N = 50;
N = 100;
b = (sign(randn(N,1)) + 1)/2;  % N amount of bits

% C2.a
X = bits_to_2PAM(b); % 

% C2.b
x_delta = (1/Ts) * upsample(X, over); % Pulse train generation
t_pulse = 0:Ts:T*N-Ts; % Pulse Train time scale
% t_pulse = linspace(0, (A*T), N*over);

figure('Name', 'Upscaled.Pulse.Train'); % Plot Pulse Train
hold on;
stem(t_pulse,x_delta);
title('Upscaled Pulse Train')
xlim([0 T*N]);
xlabel('Time');

% C2.c
[phi, t] = srrc_pulse(T, over, A, a); % SRRC pulse generation
X_conv = conv(phi,x_delta)*Ts;  % Convolution of phi and pulse train
X_time = [.(1)+t(1):Ts:t_pulse(end)+t(end)]; % Pulse Train

figure('Name', 'X(t).Conv.phi(t)'); % Plot conlolution
% hold on;
plot(X_time,X_conv);
xlabel('Time')
xlim([X_time(1) X_time(end)]);
title('X(t)');

%C2.d
% Na poume oti to phi einai artio kai phi(-t)=phi(t)
Z = conv(phi,X_conv)*Ts; % Convolution of recieved signal
Z_time = [X_time(1)+t(1):Ts:X_time(end)+t(end)]; % Time

% Plot Z(t)
figure('Name', 'Z(t)');
plot(Z_time,Z);
xlabel('Time')
xlim([Z_time(1) Z_time(end)]);
title('Z(t)');

% Find the index of Z(0) and Z(5)
index_first = find(abs(Z_time) < 0.001); 
index_last = find(abs(Z_time-t_pulse(end)) < 0.001);

Z_sampled = Z(index_first:index_last); % Z(0) - Z(end)
Z_sampled = downsample(Z_sampled, over); % Downsampled Z ('reach' pulse train)

figure('Name', 'Z(t).&.Z_s(t)'); % Plot of Z(t) and Z(t) sampled
plot(Z_time,Z);
hold on;
stem(0:T:(N-1)*T, Z_sampled, 'k');
legend('Z(t)','Z_s(t)');
xlim([Z_time(1) Z_time(end)]);

% Mean squared error of Z_s(t) and X_d(t)
MSE = (1/N)*sum((Z_sampled - X).^2); 
disp(['Mean squared error: ' num2str(MSE)]);

% Plots of Z_sampled(t) and X_delta(t)
figure('Name', 'Z_s(t).&.X_delta(t)');
stem(0:T:(N-1)*T, Z_sampled, 'k');
hold on;
s = stem([0:N-1]*T, X);
s.Color = [0.8500 0.3250 0.0980];
legend('Z_s(t)','X_d(t)');


