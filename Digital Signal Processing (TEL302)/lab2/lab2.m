close all;
clear all;
clc

Fs = 1;
Ts = 1/Fs;

%% Exercise 1
        % Q_b
% G_1
num = [0.2 0];
den = [1 -0.9];
G1 = tf(num, den, Ts);

% G_2
num = [0 1];
den = [1 0.2];
G2 = tf(num, den, Ts);

% Total tranfer func
sys = G1*G2

% Get the num and den from tf
[num,den] = tfdata(sys);

% Convert them from cell to array
num = cell2mat(num);
den = cell2mat(den);

% Get the zeros and poles
zeros = roots(num);
poles = roots(den);

% Generate z-plane
fig = figure;
zpl = zplane(zeros, poles);
title('Region of convergence')
set(fig,'Position',[0 0 950 970]);

        % Q_d
f_step = pi/128;
f=-pi:f_step:pi;

% Plot frequency response
fig = figure('Name', 'freqz() with 3 arguments');
freqz(num, den, f);
title('Frequency Response of system')
set(fig,'Position',[0 0 950 970]);
fig = figure('Name', 'freqz() with 2 arguments');
freqz(num, den);
title('Frequency Response of system')
set(fig,'Position',[0 0 950 970]);

        % Q_e
% Add a pole at z=1
num1 = [0 1];
den1 = [1 -1];
sys1 = tf(num1, den1, Ts);

% Calculate new transfer function
sys = sys*sys1

% Get the num and den from tf
[num,den] = tfdata(sys);

% Convert them from cell to array
num = cell2mat(num);
den = cell2mat(den);

% Generate z-plane
fig = figure;
zpl = zplane(num, den);
title('Region of convergence')
set(fig,'Position',[0 0 950 970]);

% Plot frequency response
fig = figure('Name', 'New system, with added pole at z=1');
freqz(num, den, f);
title('Frequency Response of new system')
set(fig,'Position',[0 0 950 970]);


%% Exercise 2
        % Q_a
num = [4 -3.5 0];
den = [1 -2.5 1];

% Transfer function (multiplied by z^2)
H = tf(num, den, Ts);

% Calculate residue and poles for sub fractions
[r,p] = residuez(num, den);
fprintf('Residue:\t %d, %d\n', r(1), r(2));
fprintf('Poles:\t\t %d, %.1f\n\n', p(1), p(2));

% Define z
syms z;

% Create tf^-1
H_sys = (num(1) + num(2)*(z^-1)) / (den(1) + den(2)*(z^-1) + den(3)*(z^-2));

        % Q_b
% Calculate inverse z tranform
H_inv = iztrans(H_sys);
fprintf('Inverse z transform:\n');

% Make it prettier
pretty(H_inv);