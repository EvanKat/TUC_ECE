%SYS201 part2.2 
%CHR method

clear all; 
close all;
clc

Ks = 1;
T1 = 2;
T2 = 2;
T3 = 2;

%transfer function
tmp1 = tf(1, [T1 1]);
tmp2 = tf(1, [T2 1]);
tmp3 = tf(1, [T3 1]);
disp('Tranfer Function:')
sys1 = Ks*tmp1*tmp2*tmp3

%M = feedback(sys1, 1);

figure('Name','Transfer function')
% subplot(2,1,1);
step(sys1);
title('Step Response.');
xlabel('Time');
hold on; 
% subplot(2,1,2);
% step(M);
% title('Step Response with unit feedback');
% xlabel('Time');

% Parameters
m = paramCalc(sys1);
% Given parameters
K = 1;
Te = 1.7;     %tu
Tb = 6.7;   %tg

fprintf('\nTranfer function order: %d\n', order(sys1))


%% ********* 0% overshoot ***********
fprintf('\n\t\t0 percent overshoot\n');
        %p controller
%///Parameters
Kp1 = (0.3*Tb)/(K*Te);
%\\\
PID_controller = pidstd(Kp1);
Ptf = tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',85);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
figure('name', '0% overshoot')
fprintf('\nSystem TF');
subplot(3,1,1),
m1 = feedback(PID_controller*sys1,1)
step(m1);
hold on; 
%step(opt_pid_step); hold on;
step(sys1);
title(['P controler (Kp = ' num2str(Kp1) ').']);
legend('P_step','Sys1');


        %pi controller
%///Parameters
disp('pi')
Kp2 = (0.35*Tb)/(K*Te);
Ti1 = 1.2*Tb;
%\\\
PID_controller = pidstd(Kp2, Ti1)
PItf = tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
subplot(3,1,2),
m2 = feedback(PID_controller*sys1,1)
step(m2); 
hold on; 
%%%%step(opt_pid_step); hold on; )))
step(sys1);
title(['PI controler (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ').']);
legend('PI_step','Sys1');

%pid controller
%///Parameters
Kp3 = (0.6*Tb)/(K*Te);
Ti2 = Tb;
Td = 0.5*Te;
%\\\
PID_controller = pidstd(Kp3, Ti2, Td)
tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
subplot(3,1,3),
m3 = feedback(PID_controller*sys1,1)
step(m3); hold on; %step(opt_pid_step); hold on; )))
step(sys1);
title(['PID controler (Kp = ' num2str(Kp3) ', Ki = ' num2str(Ti2) ', Kd = ' num2str(Td) ').']);
legend('PID_step','Sys1');


%% ********* 20% overshoot ***********
fprintf('\n\t\t20 percent overshoot\n');
        %p controller
%///Parameters
Kp1 = (0.7*Tb)/(K*Te);
%\\\
PID_controller = pidstd(Kp1);
tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
figure('name', '20% Overshoot')
subplot(3,1,1),
m1 = feedback(PID_controller*sys1,1)
step(m1); 
hold on;
% step(opt_pid_step); 
% hold on;
step(sys1);
title(['P controler (Kp = ' num2str(Kp1) ').']);
legend('P_step','Sys1');

        %pi controller
%///Parameters
Kp2 = (0.6*Tb)/(K*Te);
Ti1 = Tb;
%\\\
PID_controller = pidstd(Kp2, Ti1);
tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
subplot(3,1,2),
m2 = feedback(PID_controller*sys1,1)
step(m2); hold on; %step(opt_pid_step); hold on; )))
step(sys1);
title(['PI controler (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ').']);
legend('PI_step','Sys1');

        %pid controller
%///Parameters
Kp3 = (1.2*Tb)/(K*Te);
Ti2 = 1.4*Tb;
Td = 0.47*Te;
%\\\
PID_controller = pidstd(Kp3, Ti2, Td);
tf(PID_controller)
% %****optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% tuned_ctrl = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*tuned_ctrl,1);
% %*****
%plots
subplot(3,1,3),
m3 = feedback(PID_controller*sys1,1)
step(m3); hold on; %step(opt_pid_step); hold on; )))
step(sys1);
title(['PID controler (Kp = ' num2str(Kp3) ', Ki = ' num2str(Ti2) ', Kd = ' num2str(Td) ').']);
legend('PID_step','Sys1');
