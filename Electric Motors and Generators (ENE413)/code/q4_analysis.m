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
s = 0.1;

% Composite resistances
Z_2 = R_2./s + 1j * X_2; % rotor resistances
Z_CM = (R_c * (1j * X_m) ) / (R_c + (1j * X_m) ); % pararell componens
Z_2CM = (Z_2 * Z_CM) ./ (Z_2 + Z_CM); % compination of the above pararrel.
Z_1 = R_1 + 1j * X_1; % stator rasistances
Z_total = Z_1 + Z_2CM; % total Resistance

% Stator Current
I_phase = V_phase ./ Z_total;
I_line = I_phase * sqrt(3);
fprintf('I_phase = I_stator =  %.3f%+.3fj A \n\n',real(I_phase),...
    imag(I_phase));

% Indaction Voltage and Current
E_1 = V_phase - I_phase.*(R_1 + 1j*X_1);
I_2 = E_1 ./ sqrt( (R_2./s).^2 + X_2.^2);

% Power Factor
phi = -angle(I_phase);
PF = cos(phi);
fprintf('Power Factor = cos(%.3f) = %.3f\n\n',phi,PF);

% Apparent power
S = V_phase * conj(I_phase); 
fprintf('Total apparent power: S = %.3f%+.3fj VA, |S| = %.3f VA\n\n' ...
    ,3*real(S),3*imag(S), 3*abs(S));

% Real power
P = real(S);
fprintf('Total real power: P = %.3f W\n\n',3*P);

% Reactive power
Q = imag(S);
fprintf('Total reactive power: Q = %.3f VAr\n\n', 3*Q);

% Mechanical output power
P_mech = abs(I_2)^2 * ( R_2*((1-s)/s ));
fprintf('Total output power: P_{mech} = %.3f W \n\n', 3*P_mech);

% Efficiency 
a = P_mech / P;
fprintf('Efficiency: a = %.3f %% \n\n', a);

