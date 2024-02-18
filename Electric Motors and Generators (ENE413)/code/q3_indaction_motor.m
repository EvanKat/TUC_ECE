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

% Frequency
f = (1-s)*f_s;

% Composite resistances
Z_2 = R_2./s + 1j * X_2; % rotor resistances
Z_CM = (R_c * (1j * X_m) ) / (R_c + (1j * X_m) ); % pararell componens
Z_2CM = (Z_2 * Z_CM) ./ (Z_2 + Z_CM); % compination of the above pararrel.
Z_1 = R_1 + 1j * X_1; % stator rasistances

% Total Resistance
Z_total = Z_1 + Z_2CM; 

% Stator Current for each s
I_phase = V_phase ./ Z_total;

% Indaction Voltage and Current
E_1 = V_phase - I_phase.*(R_1 + 1j*X_1);
I_2 = E_1 ./ sqrt( (R_2./s).^2 + X_2.^2);

% Torque Calculations
T_em = (1/omega_s) .* (I_2.^2) .* (R_2./s);
T_3ph = 3*abs(T_em);
max_index =  find(T_3ph == max(T_3ph));

% Approximated Equivalent Circuit
% Different components
R_c_p = 1126.76;
X_m_p = 640;

% Total resistance
Z_CM_p = (R_c_p * (1j * X_m_p) ) / (R_c_p + (1j * X_m_p) ); % pararell componens
Z_series = R_1 + R_2./s + 1j*X_1 + 1j*X_2;
Z_total_p = (Z_CM_p * Z_series) ./ (Z_CM_p + Z_series);

% Input Current for each s
I_phase_p = V_phase ./ Z_total_p;

% Current for Resistances in series
I_2_p = V_phase ./ sqrt( (R_1 + R_2./s).^2 + (X_1 + X_2)^2 );

% Torque
T_em_p = (1/omega_s) * (I_2_p.^2) .* (R_2./s);
T_3ph_p = 3 * abs(T_em_p);
max_index_p =  find(T_3ph_p == max(T_3ph_p));

% Figures
% Torque vs Speed
fig_1 = figure('name', 'torque vs speed');
plot(n_m,T_3ph);
hold on;
plot(n_m,T_3ph_p);
hold on;
% plot(n_m(max_index),T_3ph(max_index), '.r');
plot([n_m(max_index) n_m(max_index)],[0 T_3ph(max_index)],':r')
hold on;
% plot(n_m(max_index_p),T_3ph_p(max_index_p), '.r');
plot([n_m(max_index_p) n_m(max_index_p)],[0 T_3ph_p(max_index_p)],':r')
% hold on;
% plot([n_m(max_index) n_m(max_index)],[0 T_3ph(max_index)],':r')
xlabel('Speed (rpm)');
ylabel('Torque (Nm)');
title('Torque for IEEE circuit');
legend('IEEE', 'Approximation', 'Location','southwest')
grid on;

axes('Position',[.7 .7 .2 .2])
box on
plot(n_m, T_3ph);
hold on
plot(n_m, T_3ph_p);
hold on
plot(n_m(max_index),T_3ph(max_index), '.r');
hold on
plot(n_m(max_index_p),T_3ph_p(max_index_p), '.r');
hold on
plot([n_m(max_index) n_m(max_index)],[51 T_3ph(max_index)],':r')
hold on
plot([n_m(max_index_p) n_m(max_index_p)],[51 T_3ph_p(max_index_p)],':r')
grid on
xlim([1500, 1700])
set(fig_1,'Position',[0 0 1500 600]);

% Current vs Speed
fig_2 = figure('name', 'Current vs speed');
plot(n_m,abs(I_phase));
hold on;
plot(n_m,abs(I_phase_p));
xlabel('Speed (rpm)');
ylabel('Current (A)');
title('Current vs Speed ');
legend('IEEE', 'Approximation', 'Location','southwest')
grid on;
set(fig_2,'Position',[0 0 1500 600]);
% Differenses
% fprintf('Differences for torques: %d\n', mse(T_3ph,T_3ph_p))
fprintf('Differences for torques: %.2f %%\n', mean((T_3ph_p - T_3ph)./T_3ph)*100)
% fprintf('Differences for currents: %d\n', mse(abs(I_phase),abs(I_phase_p)))
fprintf('Differences for currents: %.2f %%\n', mean((abs(I_phase_p) - abs(I_phase))./abs(I_phase))*100)