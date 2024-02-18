% Exercise B1
close all;
clear;
T = 0.001;    %Given Period
A = 5;
a = [0, 0.5, 1]; %Roll-off factor
over = 10;  %Oversampling factor
kStep = 1;
k = [0, 1, 2, 3];
t_delay = k.*T;

Ts = T / over; %sampling period
phi = {}; % Initialization of truncated SRRC pulse

%Set vars for each roll-of factor
for i=1:length(a)
    [phi{i}, t] = srrc_pulse(T, over, A, a(i));
end


% SRRc pulse's
figure('Name','SRRC.a.Delay(k)');
for i=1:length(a)
     subplot(3,1,i);
    for j=1:length(k)
        p = plot(t+t_delay(j),phi{i});
        hold on;
    end
    title(['SRRC Pusles with roll-off factor: a = ' num2str(a(i))]);
    legend('k = 0', 'k = 1', 'k = 2', 'k = 3');
    xlabel('Time');
    xlim([-A*T A*T]);
end
hold off;

% Exercise B2

for i=1:length(a)
    figure('Name',['SRRC.a=' num2str(a(i)) '.Delay(k)']);
    for j=1:length(k)
        subplot(4,1,j);
        time = [-A*T:Ts:A*T+k(j)*T];
        phi_ext = [phi{i} zeros(1,k(j)*T/Ts)];
        phi_del = [zeros(1,k(j)*T/Ts) phi{i}];
        phi_product = phi_ext.*phi_del;
        plot(time, phi_product);
        xlim([-A*T A*T+k(j)*T]);
        title(['Product of \phi(t) and \phi(t-KT) with: a = ' num2str(a(i)) ', k = ' num2str(k(j))]);
    end
    xlabel('Time');
end

% Exercise B3
for i=1:length(a)
    fprintf('Integral of phi(t) * phi(t-KT) with a = %.1f and\n', a(i));
    for j=1:length(k)
        phi_ext = [phi{i} zeros(1,k(j)*T/Ts)];
        phi_del = [zeros(1,k(j)*T/Ts) phi{i}];
        phi_product = phi_ext.*phi_del;
        v(i) = sum(phi_ext.*phi_del)*Ts;
        
        fprintf('k = %d: %.6f\n',k(j), v(i));
    end
end
% Table = table(a,v_j)
% for i=1:length(a)
%     for j=1:length(k)
%         disp(['a=' num2str(a(i),'%.1f') ', k=' num2str(k(j)) ' = ' num2str(v(i,j),'%.6f')]);
%     end
% end

% h = {'roll-off fuctor' 'k' 'integral'}
% data=[0     0       ]
% f=figure;
% t=uitable(f,'data',data,'columnname',h)