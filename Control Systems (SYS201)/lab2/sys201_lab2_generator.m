clear all
close all
clc
Ks = 0.87;
Te = 0.1;  %tu
Tb = 1.12;  %tg

T1 = 0.37*Tb;
T2 = 3.33*Te;

sys  = Ks * tf(1, [T1 1]) * tf(1, [T2 1])

% D.4

figure('Name','Transfer function')
% [y,t] = step(sys);
t=0:0.01:20;
for k=1:length(t)
    if(t(k)<5)
        y(k) = 2;
    else
        y(k) = 8;
    end
end
plot(t, y);
hold on
st = lsim(sys,y,t);
plot(t, st);
title('Open-loop Step Response.');
ylabel('Uo (Volts)');
xlabel('Time (s)'); 
axis([0 20 0 10])
legend('Input signal', 'Step response')
hold off

        % PI contoller
%///Parameters
disp('pi')
Kp = (0.35*Tb)/(Ks*Te);
Ti = 1.2*Tb;
%\\\
figure('Name','PI controller')
PID_controller = pidstd(Kp, Ti);
m = feedback(PID_controller*sys,1);
step(m)
title(['PI controler (Kp = ' num2str(Kp) ', Ki = ' num2str(Ti)  ').']);
legend('PI_step')


%D.5
f = 1/16;
t1=0:0.01:60;
pulse = 2*square(2*pi*f*t1)/2 + 4;
figure('Name','Step response')
plot(t1, pulse)
axis([0 60 0 10])
hold on
resp = lsim(m,pulse,t1);
plot(t1, resp) 
title('PI controller step response')
legend('Pulse', 'System Response')
xlabel('Time (s)'); 
ylabel('Uv (volts)');
e = resp - (pulse.');

% Errors
iea = trapz(t1,abs(e));          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2);            % ISE 
itae = trapz(t1, t1'.*abs(e));     % ITAE
itse = trapz(t1,t1'.*(e.^2));      % ITSE


