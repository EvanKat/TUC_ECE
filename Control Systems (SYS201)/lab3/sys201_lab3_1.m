close all;
clear all;
pkg load control % Delete it
clc

Ks = 0.75;
Tg = 50;
Tu = 5;

T1 = 10;
T2 = 40;

sys  = Ks * tf(1, [T1 1]) * tf(1, [T2 1])

%D1
figure('Name','Transfer function')
% [y,t] = step(sys);
t=0:0.01:300;
for k=1:length(t)
    if(t(k)<0)
        y(k) = 0;
    else
        y(k) = 3;
    end
end
plot(t, y);
hold on
st = lsim(sys,y,t);
plot(t, st);
title('Open-loop Step Response.');
ylabel('Uo (Volts)');
xlabel('Time (s)'); 
legend('Input signal', 'Step response')
axis([0 300 0 10])
hold off

%D2

%% ********* 20% overshoot ***********
fprintf('\n\t\t20 percent overshoot\n');
        %p controller
%///Parameters
Kp1 = (0.7*Tg)/(Ks*Tu);
%\\\
PID_controller = pidstd(Kp1);
tf(PID_controller)
m1 = feedback(PID_controller*sys,1)
%plots
% figure('name', '20% Overshoot')
% subplot(3,1,1),
% step(m1); 
% hold on;
% step(sys);
% title(['P controler (Kp = ' num2str(Kp1) ').']);
% legend('P_step','Sys');


        %pi controller
%///Parameters
Kp2 = (0.6*Tg)/(Ks*Tu);
Ti1 = Tg;
%\\\
PID_controller = pidstd(Kp2, Ti1);
tf(PID_controller)
m2 = feedback(PID_controller*sys,1)
%plots
% subplot(3,1,2),
% step(m2); 
% hold on; 
% step(sys);
% title(['PI controler (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ').']);
% legend('PI_step','Sys');





        %pid controller
%///Parameters
Kp3 = (1.2*Tg)/(Ks*Tu);
Ti2 = 1.4*Tg;
Td = 0.47*Tu;
%\\\
PID_controller = pidstd(Kp3, Ti2, Td);
tf(PID_controller)
m3 = feedback(PID_controller*sys,1)
%plots
% subplot(3,1,3),
% step(m3); 
% hold on; 
% step(sys);
% title(['PID controler (Kp = ' num2str(Kp3) ', Ki = ' num2str(Ti2) ', Kd = ' num2str(Td) ').']);
% legend('PID_step','Sys');

%input
t1=0:0.01:900;
for k=1:length(t1)
    if(t1(k)<0)
        y1(k) = 5;
    elseif(t1(k)>=0 && t1(k)<=150)
        y1(k) = 6;
    else
        y1(k) = 5;
    end
end

% p response
figure('Name','2) 20% Overshoot controllers')
subplot(3,1,1),
plot(t1, y1)
axis([0 900 0 10])
hold on
resp = lsim(m1,y1,t1);
plot(t1, resp) 
title('P controller step response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
disp('P errors')
% Errors
iea = trapz(t1,abs(e))          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)          % ISE 
itae = trapz(t1, t1'.*abs(e))    % ITAE
itse = trapz(t1,t1'.*(e.^2))      % ITSE

% pi response
subplot(3,1,2),
plot(t1, y1)
axis([0 900 0 10])
hold on
resp = lsim(m2,y1,t1);
plot(t1, resp) 
title('P controller step response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
disp('PI errors')
% Errors
iea = trapz(t1,abs(e))          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)            % ISE 
itae = trapz(t1, t1'.*abs(e))    % ITAE
itse = trapz(t1,t1'.*(e.^2))     % ITSE

% pid response
subplot(3,1,3),
plot(t1, y1)
axis([0 900 0 10])
hold on
resp = lsim(m3,y1,t1);
plot(t1, resp) 
title('P controller step response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
% Errors
disp('PID errors')
iea = trapz(t1,abs(e))         % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)           % ISE 
itae = trapz(t1, t1'.*abs(e))    % ITAE
itse = trapz(t1,t1'.*(e.^2))      % ITSE



%% D3

% ********* 0% overshoot ***********
fprintf('\n\t\t0 percent disturbance\n');

        %pid controller
%///Parameters
Kp3 = (0.95*Tg)/(Ks*Tu);
Ti2 = 2.4*Tg;
Td = 0.42*Tu;
%\\\
PID_controller = pidstd(Kp3, Ti2, Td);
tf(PID_controller)
m4 = feedback(PID_controller*sys,1)
%plots
% figure('name', '0% Overshoot')
% step(m4); 
% hold on;
% step(sys);
% title(['PID controler (Kp = ' num2str(Kp3) ', Ki = ' num2str(Ti2) ', Kd = ' num2str(Td) ').']);
% legend('PID_step','Sys');
% hold off;

% input
t1=0:0.001:900;
for k=1:length(t1)
    if(t1(k)<=0)
        y2(k) = 5;
    elseif(t1(k)>0 && t1(k)<=300)
        y2(k) = 6;
    elseif(t1(k)>300 && t1(k)<=600)
        y2(k) = 8;
    else
        y2(k) = 5;
    end
end
% disorder
f = 1/100;
disorder_pulse = square(2*pi*f*t1)/2 + 1/2;

y_disorderd = y2 + disorder_pulse;
% figure('Name','Step response')
% plot(t1, y_disorderd)

figure('Name','3) 0% Overshoot PID')
plot(t1, y2)
axis([0 900 0 10])
hold on
resp = lsim(m4,y_disorderd,t1);
plot(t1, resp) 
hold on;
plot(t1, disorder_pulse);
title('PID controller step response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y2.');
% Errors
disp('PID disturbance errors')
iea = trapz(t1,abs(e))         % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)           % ISE 
itae = trapz(t1, t1'.*abs(e))    % ITAE
itse = trapz(t1,t1'.*(e.^2))     % ITSE
