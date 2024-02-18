clear all;
close all;
clc
%% Starting signal
F0 = 3/4; % frequency of x
step = 0.001;
% t = step:step:0.5;  % in sec
t = 0:step:0.5;  % in sec
x = 5*cos(24*pi*t) - 2*sin(1.5*pi*t);   %f_max = 12

figure('Name','Starting Signal')
plot(t,x)
title('Starting Signal')
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Sampling
% Sample_1 Ts = 1/48(s)

Ts1 = 1/48; % Fs = 48 = 64 * F0 = 64 * 0.75
% t1 = Ts1:Ts1:(0.5-Ts1);
t1 = 0:Ts1:(0.5-Ts1);

% Take samples manual
% k=0;
% for n = t1
%     x_index = find(abs(t-n) < 0.001,1)
%     length(find(abs(t-n) < 0.001))
%     k = k+1;
%     x_s1(k) = x(x_index);
% end 
x_s1 = (5*cos(24*pi*t1) - 2*sin(1.5*pi*t1));

% Sample_2 Ts = 1/24(s)

Ts2 = 1/24; % Fs = 24 = 32 * F0 = 32 * 0.75
% t2 = Ts2:Ts2:(0.5-Ts2);
t2 = 0:Ts2:(0.5-Ts2);
x_s2 =(5*cos(24*pi*t2) - 2*sin(1.5*pi*t2));

% Sample_3 Ts = 1/12(s)

Ts3 = 1/12; % Fs = 12 = 16 * F0 = 16 * 0.75
% t3 = Ts3:Ts3:(0.5-Ts3);
t3 = 0:Ts3:0.5;
x_s3 = (5*cos(24*pi*t3) - 2*sin(1.5*pi*t3));


figure('Name','Sampled Signal')
subplot(3,1,1);
plot(t,x);
hold on;
stem(t1,x_s1,'MarkerSize',4, 'LineStyle','none','MarkerFaceColor','black');
title('Sampling with Ts=(1/48)s')
xlabel('Time (s)')
ylabel('Amplitude')
hold on;
plot(t1,x_s1);
legend('x(t)','x[t]','x_s(t)','Location','southwest');
legend('boxoff')
% xlim([(min(t1)-0.01) (max(t1)+0.009)]);

subplot(3,1,2);
plot(t,x);
hold on;
stem(t2,x_s2,'MarkerSize',4, 'LineStyle','none','MarkerFaceColor','black');
hold on;
plot(t2,x_s2);
title('Sampling with Ts=(1/24)s')
xlabel('Time (s)')
ylabel('Amplitude')
legend('x(t)','x[t]','x_s(t)','Location','southwest');
legend('boxoff')

subplot(3,1,3);
plot(t,x);
hold on;
stem(t3,x_s3,'MarkerSize',4, 'LineStyle','none','MarkerFaceColor','black');
hold on;
plot(t3,x_s3);
title('Sampling with Ts=(1/12)s')
xlabel('Time (s)')
ylabel('Amplitude')
legend('x(t)','x[t]','x_s(t)','Location','southwest');
legend('boxoff')


