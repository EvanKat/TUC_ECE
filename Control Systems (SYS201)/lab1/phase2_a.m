clear all; close all; clc;

% Ziegler-Nichols Method

Ks = 1;
T1 = 2;
T2 = 2;
T3 = 2;

% Tranfer Function and unit feedback

tmp1 = tf(1, [T1 1]);
tmp2 = tf(1, [T2 1]);
tmp3 = tf(1, [T3 1]);
% Tf
sys1 = Ks*tmp1*tmp2*tmp3;
% Feedback unit 1
M = feedback(sys1, 1);
% Info of transer Function

% Sys1 = stepinfo(sys1);

% figure
figure('Name','Transfer function & feedback')
subplot(2,1,1);
step(sys1);
title('Step Response.');
xlabel('Time');
hold on;

subplot(2,1,2);
step(M);
title('Step Response with unit feedback');
xlabel('Time');

% find Kp_critical
plants = {}; % initialization of tf objects
i = 1;
Kp_max = 100;
stepper = 0.5;
for Kp=1:stepper:Kp_max
    crtl = pid(Kp);
    % set the new plant
    plants{i} = feedback(crtl*sys1,1);
    plantInfo = stepinfo(plants{i});
    
    % To find Kp_critical we have to find the 1st periodic Tranfer function
    
    % At a Periodic Tranfer Fanction (step response)
    % PeakTime (time at which the peak value occurs) is infinite 
    % due to the fact that its a periodic signal
    if plantInfo.PeakTime == Inf
        Kp_crit = Kp;
        break;
    else 
        i = i+1;
    end
end

% Finding the T_critical
[y,t]=step(plants{i});
[pks,locs] = findpeaks(y,t);
T_crit = max(diff(locs)); 

fprintf('K_critical: %.1f. \nT_critical: %.3f seconds. \n\n', Kp_crit, T_crit);

% Display plots that helped.

% To crate dynamically a matrix of plots in the same figure
% See numSubplots.m for more info.
p = numSubplots(length(plants));

Kp = 1;
figure('Name','Step Responses for each Kp');
for i=1:length(plants)
    subplot(p(1),p(2),i);
    step(plants{i});
    % Last plot (periodic)
    if Kp == Kp_crit
        title(['Kp_{critical} = ' num2str(Kp_crit)]);
        continue;
    end
    title(['Kp = ' num2str(Kp)]);
    Kp = Kp + stepper;
    hold on;
end

% P,PI,PID calculation using ZN method
% We have now gathered the values we want to create the control system
% Below is the implementation of the Ziegler-Nichols model.

% P Control
Kp1 = 0.5*Kp_crit;
PID_controller = pidstd(Kp1);  
p_step = feedback(sys1*PID_controller,1);
% %optimized controller
% Options = pidtuneOptions('PhaseMargin',60);
% opt_c1 = pidtune(sys1, PID_controller, Options);
% opt_p_step = feedback(sys1*opt_c1,1);


% PI Control
Kp2 = 0.45*Kp_crit;
Ti1 = 0.85*T_crit;
PID_controller = pidstd(Kp2,Ti1);  
pi_step = feedback(sys1*PID_controller,1);
% %optimized controller
% Options = pidtuneOptions('PhaseMargin',69);
% opt_c1 = pidtune(sys1, PID_controller, Options);
% opt_pi_step = feedback(sys1*opt_c1,1);
    
% PID Control
Kp3 = 0.6*Kp_crit;
Ti2 = 0.5*T_crit;
Td = 0.12*T_crit;
PID_controller = pidstd(Kp3,Ti2,Td);
opt_pid_c = pidstd(0.77,4.31,1.07);    %optimal pid ctrl
pid_step = feedback(sys1*PID_controller,1);
% %optimized controller
% Options = pidtuneOptions('PhaseMargin',75);
% opt_c1 = pidtune(sys1, PID_controller, Options);
% opt_pid_step = feedback(sys1*opt_c1,1);

% Plot controlers
figure('Name','TF of P,PI,PID controlers');
step([0:100],sys1,p_step,pi_step,pid_step);
%legend(['Sys1','P_stepKp (Kp = ' num2str(Kp1) ')'] ,['PI_step (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ')'] ,['PID_step (Kp = ' num2str(Kp3) ',Ki = ' num2str(Ti2) ',Kd = ' num2str(Td) ')']);

legend(['Sys1','The linear system'],['P_step (Kp = ' num2str(Kp1) ')'] ,['PI_step (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ')'] ,['PID_step (Kp = ' num2str(Kp3) ',Ki = ' num2str(Ti2) ',Kd = ' num2str(Td) ')']);
%plot all the above 

figure('Name','TF of P,PI,PID controlers');
subplot(3,1,1);
step(p_step);
hold on;
% step(opt_p_step)
% hold on
step(sys1);
title(['P controler (Kp = ' num2str(Kp1) ').']);
legend('P_step','Sys1');
hold on;


subplot(3,1,2);
step(pi_step);
hold on;
% step(opt_pi_step);
% hold on
step(sys1);
title(['PI controler (Kp = ' num2str(Kp2) ', Ki = ' num2str(Ti1) ').']);
legend('PI_step','Sys1');
hold on;

subplot(3,1,3);
step(pid_step);
hold on;
% step(opt_pid_step);
% hold on
step(sys1);
title(['PID controler (Kp = ' num2str(Kp3) ', Ki = ' num2str(Ti2) ', Kd = ' num2str(Td) ').']);
legend('PID_step','Sys1');
