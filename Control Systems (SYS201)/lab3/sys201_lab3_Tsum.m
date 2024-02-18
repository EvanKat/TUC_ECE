close all;
clear all;
pkg load control    %Delete
pkg load signal     %Delete
clc



Ks = 0.75;
Tg = 50;
Tu = 5;

T1 = 10;
T2 = 40;
Tsum = T1 + T2;

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

%% ********* Tsum method ***********
fprintf('\n\t\t20 percent overshoot\n');
        %p controller
%///Parameters
Kp1 = 1/Ks;
%\\\
PID_controller = pidstd(Kp1);
tf(PID_controller)
m1 = feedback(PID_controller*sys,1)
%plots
% figure('name', 'Tsum method')
% subplot(3,1,1),
% step(m1); 
% hold on;
% step(sys);
% title(['P controler (Kp = ' num2str(Kp1) ').']);
% legend('P_step','Sys');


        %pi controller
%///Parameters
Kp2 = 0.5 / Ks;
Ti1 = 0.5 * Tsum;
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
Kp3 = 1 / Ks;
Ti2 = 0.66 * Tsum;
Td = 0.17 * Tsum;
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

%p response
figure('Name','Tsum method controllers')
subplot(3,1,1),
plot(t1, y1)
axis([0 500 0 10])
hold on
resp = lsim(m1,y1,t1);
plot(t1, resp) 
title('P controller response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
% Errors
disp('P errors')
iea = trapz(t1,abs(e))          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)            % ISE 
itae = trapz(t1, t1'.*abs(e))     % ITAE
itse = trapz(t1,t1'.*(e.^2))      % ITSE

%pi response
subplot(3,1,2),
plot(t1, y1)
axis([0 500 10])
hold on
resp = lsim(m2,y1,t1);
plot(t1, resp) 
title('PI controller response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
% Errors
disp('PI errors')
iea = trapz(t1,abs(e))          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)            % ISE 
itae = trapz(t1, t1'.*abs(e))     % ITAE
itse = trapz(t1,t1'.*(e.^2))      % ITSE

%pid response
subplot(3,1,3),
plot(t1, y1)
axis([0 500 0 10])
hold on
resp = lsim(m3,y1,t1);
plot(t1, resp) 
title('PID controller response')
legend('Input', 'System Response')
xlabel('Time (s)'); 
ylabel('Ub (V)'); 
e = resp - (y1.');
% Errors
disp('PID errors')
iea = trapz(t1,abs(e))          % IAE trapz=numerical integration 
ise = trapz(t1,e.^2)            % ISE 
itae = trapz(t1, t1'.*abs(e))    % ITAE
itse = trapz(t1,t1'.*(e.^2))     % ITSE


