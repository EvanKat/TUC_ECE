clear all;close all;clc
% Data 
V_phase = 400;
f_s = 50;
omega_s = 2*pi*f_s;
poles = 2;
n_s = (60*f_s)/(poles/2);

% Equivalent Circuit (IEEE)
R_1 = 1.35;
R_2 = 6.22;
R_c = 1099.98;
X_total = 13.18;
X_1 = 0.5 * X_total;
X_2 = 0.5 * X_total;
X_m = 635.2;
 
% Slip
s_step = 0.001;
s = 0:s_step:1;
s(1) = s_step;

% Mechanical speed
n_m = (1-s) * n_s;

% Composite resistances
Z_2 = R_2./s + 1j * X_2; % rotor resistances
Z_CM = (R_c * (1j * X_m) ) / (R_c + (1j * X_m) ); % pararell componens
Z_2CM = (Z_2 * Z_CM) ./ (Z_2 + Z_CM); % compination of the above pararrel.
Z_1 = R_1 + 1j * X_1; % stator rasistances

% Total Resistance
Z_total = Z_1 + Z_2CM; 

% Stator Current for each s
I_phase = V_phase ./ Z_total;
% Angle of current
phi = -angle(I_phase);

% Indaction Voltage and Current
E_1 = V_phase - I_phase.*(R_1 + 1j*X_1);
I_2 = E_1 ./ sqrt( (R_2./s).^2 + X_2.^2);

% Electrical Input Power Calculation
P_el = V_phase .* abs(I_phase) .* cos(phi);

% Mechanical Output Power Calculation
P_mech = abs(I_2).^2 .* ( R_2.*((1-s)./s ));

% Efficiency Calculator
Eff = P_mech ./ P_el;

% Mechanical speed at s = 0.04;
n = (1 - 0.04)*n_s;

% Find possition at the efficiency curve
index = find(n_m == n);

% Figures
% Efficiency vs Speed
fig_1 = figure('name', 'efficiency vs speed');
plot(n_m,Eff);
hold on;
plot([n_m(index) n_m(index)],[0 Eff(index)],':r')
hold on;
plot(n_m(index),Eff(index), '*r');
grid on;
xlabel('Speed (rpm)');
ylabel('Efficiency (%)');
title('Efficiency for IEEE circuit');
 
axes('Position',[.2 .7 .2 .2])
box on
t = 40;
plot(n_m,Eff);
hold on;
plot([n_m(index) n_m(index)],[0 Eff(index)],':r')
hold on;
plot(n_m(index),Eff(index), '*r');
xlim([2750,2950])
ylim([0.7,0.9])
grid on
set(fig_1,'Position',[0 0 1500 600]);

fprintf('Max efficiency: a = %.3f %% \n', max(Eff))
fprintf('Efficiency for s = 4%%: a = %.3f %% \n', Eff(index))