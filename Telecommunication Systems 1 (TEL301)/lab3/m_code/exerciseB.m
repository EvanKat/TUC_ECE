% B
clear;
clc;
close all;

% Set starcting info
N = 100;
T = 0.001;
over = 10;
Ts = T/over;
a = 0.5;
A = 4;
Nf = 4096;
Fs = 1/Ts; % Sampling Frequency 
f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf);
K = 1000;
F0 = 2000;
% Generate phi[t]
[phi, t] = srrc_pulse(T, over, A, a);
% Symbol transmit duration
time = 0:T:((N*T)-T);

SNRDB = -2 : 2 : 16;
P_Symbol = zeros(1,length(SNRDB));
P_Bit = zeros(1,length(SNRDB));
Upper_bound_symbol = zeros(1,length(SNRDB));
Upper_bound_bit = zeros(1,length(SNRDB));
% For each SRNdb
for i = 1:length(SNRDB);
    SNRdb = SNRDB(i);
    max_num_of_symbol_errors = 0;
    max_num_of_bit_errors = 0;
    
    sq_sigma = 1/(Ts * (10^(SNRdb/10)));
    sq_sigma_N = (Ts*sq_sigma)/2;
%   Upper_bound_symbol(i) = 2*Q(sqrt(2*(10^(SNRdb/10)))*sin(pi/8));
    Upper_bound_symbol(i) = 2*Q((1/sqrt(sq_sigma_N))*sin(pi/8));
    Upper_bound_bit(i) = Upper_bound_symbol(i)/3;
    for k = 1:K
        % 3N bits generation 
        b_seq = (sign(randn((3*N), 1)) + 1)/2;
        % 8PSK Symbols
        X = bits_to_PSK_8(b_seq);
        Xi = X(:,1);
        Xq = X(:,2);
        % Upsample coordinates
        X_upsample=(1/Ts) .* upsample(X, over);
        Xi_upsample = X_upsample(:,1);
        Xq_upsample = X_upsample(:,2);
        X_time = 0:Ts:(N*T)-Ts;
        % Signal formatting
        Xi_conv = conv(Xi_upsample, phi)*Ts;
        Xq_conv = conv(Xq_upsample, phi)*Ts;
        time = t(1) + X_time(1):Ts:t(end) + X_time(end);
        % Modulate with carries
        Ci = (2*cos(2*pi*F0*time))';
        Cq = ((-2)*sin(2*pi*F0*time))';
        
        Xi_c = Xi_conv .* Ci;
        Xq_c = Xq_conv .* Cq;
        % Transmeted signal
        X_t = Xi_c + Xq_c;
        % Set and generate Noise
        mu = 0;
        W_t = randn(length(X_t),1)*sqrt(sq_sigma) + mu;
        % Output signal
        Y_t = X_t + W_t;
        
        time = t(1) + X_time(1):Ts:t(end) + X_time(end);
        % Modulate with carries
        Ci = (cos(2*pi*F0*time))';
        Cq = ((-sin(2*pi*F0*time)))';
        
        Y_t_i = Y_t.*Ci;
        Y_t_q = Y_t.*Cq;
        % Signal formatting
        Y_conv_i = conv(Y_t_i,phi)*Ts;
        Y_conv_q = conv(Y_t_q,phi)*Ts;
        time = time(1) + t(1) : Ts : time(end) + t(end);
        % Sample the output
        index_first = find(abs(time) < Ts/over);
        index_last = find(time >= ((N*T)-Ts), 1);
        
        Yi_t = Y_conv_i(index_first:index_last);
        Yq_t = Y_conv_q(index_first:index_last);
        % Sample the output
        Yi_t = downsample(Yi_t, over);
        Yq_t = downsample(Yq_t, over);
        % Output Sampled Signal 
        Y(:,1) = Yi_t;
        Y(:,2) = Yq_t;
        time = 0:T:(N*T)-T;
        % Estinated Symbol and bit Sequenced
        [est_X, est_bit_Seq] = detect_PSK_8(Y);
        
        num_of_symbol_errors = symbol_errors(est_X, X);
        max_num_of_symbol_errors = max_num_of_symbol_errors + num_of_symbol_errors;
        
        num_of_bit_errors = bit_errors(est_bit_Seq, b_seq);
        max_num_of_bit_errors = max_num_of_bit_errors + num_of_bit_errors;
    end
%     disp(SNRdb)
    P_Symbol(i) = max_num_of_symbol_errors/(K*100); % K-> peiramata, N->Symbols
%     disp(P_Symbol)
    P_Bit(i) = max_num_of_bit_errors/(K*(300));
%     disp(P_Bit)

    
end 

figure('Name', 'Symbol_Error - SNRdb')
semilogy(SNRDB,P_Symbol);
hold on;
semilogy(SNRDB,Upper_bound_symbol);
hold on;
grid on;
xlabel('SNR in db');
ylabel('Symbol Error Rate for 8_PSK')
legend('Experimental', 'Upper Bound')

figure('Name', 'Bit_Error - SNRdb')
semilogy(SNRDB,P_Bit);
hold on;
semilogy(SNRDB,Upper_bound_bit);
hold on;
grid on;
xlabel('SNR in db');
ylabel('Bit Error Rate for 8_PSK')
legend('Experimental', 'Upper Bound')
