clear all;
close all;

Ts = 0.01;
T = 16;
t = -3*T:Ts:3*T;
y = zeros(1,length(t));
y(t>-T/2+10 & t<T/2+10) = 1./sqrt(T);

figure('Name','phi(t-10)CONVphi(-(t-10))');

%%phi(t)
subplot(3,1,1);
plot(t, y);
title('\phi(t)');
xlabel('Time')
xlim([t(1) t(end)]);
hold on;

%%phi(-t)
y_flip = flip(y);
t_y_flip = -fliplr(t);
% t_y_flip = t
subplot(3,1,2);
plot(t, y_flip);
title('\phi(-t)');
xlabel('Time');
xlim([t_y_flip(1) t_y_flip(end)]);
hold on;

Y = conv(y, y_flip)*Ts;
% t_conv = 2*t(1):Ts:2*t(end);
t_conv = (t(1) + t_y_flip(1)):Ts:(t(end)+t_y_flip(end));
subplot(3,1,3);
plot(t_conv, Y);
title('\phi(t) conv \phi(-t)');
xlabel('Time');
xlim([t_y_flip(1) t_y_flip(end)]);