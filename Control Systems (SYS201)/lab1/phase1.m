%% Exercise A
%
%   weight: 30%
%
%           Pacticipants                    AM
%    1. Gioumertakis Apostolos      |    2017030142       
%    2. Ellinitakis Rafail-Antonios |    2017030118
%    3. Katsoupis Evangelos         |    2017030077
%    4. Voulgaris Konstantinos      |    2017030125
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

time = 0:0.01:3.5;
%% a1.Trasfer Functions
% H1
num = 1;
den = [0.3 1];
H1 = tf(num, den)
rH1 = lsim(H1,time,time);

H2 = H1^2
rH2 = lsim(H2,time,time);

% H1
% figure('Name','pepe');
% pidtool(H1);

%% a1.figures 
% H1
figure('Name','Tranfer function H1');
% step response
subplot(2,2,1);
step(H1);
title('Step Response.')
xlabel('Time');
hold on;
% impulse response
subplot(2,2,2);
impulse(H1);
title('Impulse Response.')
xlabel('Time');
hold on;
% ramp response
subplot(2,2,[3,4]);
plot(time,rH1);
title('Ramp Response.')
xlabel('Time');

% H2
figure('Name','Tranfer function H2');
% step response
subplot(2,2,1);
step(H2);
title('Step Response.')
xlabel('Time');
hold on;
% impulse response
subplot(2,2,2);
impulse(H2);
title('Impulse Response.')
xlabel('Time');
hold on;
% ramp response
subplot(2,2,[3,4]);
plot(time,rH2);
title('Ramp Response.')
xlabel('Time');


%% a2.Tranfer Functions
%h1
num = 1;
den = [0.1 1];
h1 = (tf(num,den)^2);

%h2
den = [0.5 1];
h2 = (tf(num,den)^2);

%h3
den = [1 1];
h3 = (tf(num,den)^2);

%h4
den = [0.1 1];
den1 = [0.5 1];
h4 = tf(num,den) * tf(num,den1);

%h5
den = [0.4 1];
den1 = [2 1];
h5 = tf(num,den) * tf(num,den1);

%h6
den = [1 1];
den1 = [5 1];
h6 = tf(num,den) * tf(num,den1);

%h7
den = [0.1 1];
den1 = [10 1];
h7 = tf(num,den) * tf(num,den1);

%h8
h8 = h1^2;

%h9
h9 = h2^2;

%h10
h10 = h3^2;

%h11
den = [0.1 1];
den1 = [0.5 1];
h11 = tf(num,den)^3 * tf(num,den1);

%h12
den = [2.5 1];
den1 = [0.5 1];
h12 = tf(num,den) * tf(num,den1)^3;


%% a2.figures
figure('Name', 'Step Rensposes')
subplot(4,3,1);
step(h1);
legend('h1');
hold on;

subplot(4,3,2);
step(h2);
legend('h2');
hold on;

subplot(4,3,3);
step(h3);
legend('h3');
hold on;

subplot(4,3,4);
step(h4);
legend('h4');
hold on;

subplot(4,3,5);
step(h5);
legend('h5');
hold on;

subplot(4,3,5);
step(h5);
legend('h5');
hold on;

subplot(4,3,6);
step(h6);
legend('h6');
hold on;

subplot(4,3,7);
step(h7);
legend('h7');
hold on;

subplot(4,3,8);
step(h8);
legend('h8');
hold on;


subplot(4,3,9);
step(h9);
legend('h9');
hold on;

subplot(4,3,10);
step(h10);
legend('h10');
hold on;

subplot(4,3,11);
step(h11);
legend('h11');
hold on;

subplot(4,3,12);
step(h12);
legend('h12');
hold on;

%% a2.figures
figure('Name', 'Step Rensposes in same plot')
step(h1,h2,h3,h4,h5,h6,h6,h7,h8,h9,h10,h11,h12);
legend('h1','h2','h3','h4','h5','h6','h7','h8','h9','h10','h11','h12');

