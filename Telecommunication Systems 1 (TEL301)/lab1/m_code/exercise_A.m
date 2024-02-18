%Exercise A1
close all;
clear all;

T = 0.001;    %Given Period
over = 10;  %Oversampling factor
A = 4;      %Half duration of the pulse in symbol periods
a = [0, 0.5, 1]; %Roll-off factor

Ts = T / over; %sampling period
phi = {}; %Initialization of truncated SRRC pulse
t = 0;    %Initialization of time

%Set vars for each roll-of factor
for i=1:length(a)
    [phi{i}, t] = srrc_pulse(T, over, A, a(i));
end

% SRRc pulse's
figure('Name','SRRC.rollOffFactor');
hold on;
for i=1:length(a)
%   p = plot(t,phi{i});
    plot(t,phi{i});
end
title('SRRC Pusles for each roll off factor');
xlabel('Time')
xlim([-A*T A*T]);

legend('a=0', 'a=0,5', 'a=1');
%legend(p, sprintf('a=%d', a(1)), sprintf('a=%.1f', a(2)), sprintf('a=%d', a(3)));
%title(x,'rol')
hold off;

%Exercise A2

Fs = 1/Ts; % Sampling Frequency
%Nf = 1024;% Step
Nf = 2048;
phi_F = {}; % Initialization of fourier of truncated SRRC pulse
Energy_phi = {}; % 

f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf); % Frequency range

% Set Energy Spectrums
for i=1:length(a)
    phi_F{i} = fftshift(fft(phi{i}, Nf)*Ts);
    Energy_phi{i} = power(abs(phi_F{i}),2);
end

figure('Name','Energy.SRRC');
hold on;
for i=1:length(a)
%    pF = plot(f_axis,Energy_phi{i});
    plot(f_axis,Energy_phi{i});
end

title('Energy Spectrums of SRRC');
xlabel('Frequency');
xlim([-Fs/2 Fs/2]);

legend('a=0', 'a=0,5', 'a=1');

%legend(pF, sprintf('a=%d', a(1)), sprintf('a=%.1f', a(2)), sprintf('a=%d', a(3)));
%title(x,'rol')
hold off;

figure('Name','Energy.SRRC.logScale');
for i=1:length(a)
    semilogy(f_axis,Energy_phi{i});
    hold on;
end

title('Energy Spectrums of SRRC');
xlabel('Frequency');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
legend('a=0', 'a=0,5', 'a=1');
hold off;

% Exercise A3

c1 = zeros(1,length(f_axis))+T/10^3; % Energy "limit" c1 = T/10^3
c2 = zeros(1,length(f_axis))+T/10^5; % Energy "limit" c2 = T/10^3
figure('Name','Energy.SRRC.logScale.c1_c2');
for i=1:length(a)
    semilogy(f_axis,Energy_phi{i});
    hold on;
end
grid on;
plot(f_axis,c1);
plot(f_axis,c2);
title('Energy Spectrums of SRRC');
xlabel('Frequency');
ylabel('Logarithmic');
xlim([-Fs/2 Fs/2]);
legend('a=0', 'a=0,5', 'a=1', 'c1', 'c2');
hold off;




