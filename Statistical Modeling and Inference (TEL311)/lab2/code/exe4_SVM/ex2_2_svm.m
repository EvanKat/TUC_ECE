clear all;
close all;
clc;

omega_1 = [[2;2] [2;-2] [-2;-2] [-2;2]];
omega_2 = [[1;1] [1;-1] [-1;-1] [-1;1]];

figure();
plot(omega_1(1,:), omega_1(2,:),'+','LineWidth', 2, 'MarkerSize', 7);
hold on;
plot(omega_2(1,:), omega_2(2,:),'o', 'MarkerFaceColor', 'y', 'MarkerSize', 7);
% grid on;
% axis on;
title('Original classes');
axis([-2.5, 2.5, -2.5, 2.5])
legend('\omega_1', '\omega_2')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
box off

%% Transp
omeg_1 = Phi_transp(omega_1);
omeg_2 = Phi_transp(omega_2);

figure();
plot(omeg_1(1,:), omeg_1(2,:),'+','LineWidth', 2, 'MarkerSize', 7);
hold on;
plot(omeg_2(1,:), omeg_2(2,:),'o', 'MarkerFaceColor', 'y', 'MarkerSize', 7);
hold on;
plot(omeg_2(1,3),omeg_2(2,3),'ro','MarkerSize', 12)
hold on;
plot(omeg_1(1,1),omeg_1(2,1),'ro','MarkerSize', 12)
% grid on;
% axis on;
title('Transformed Classes');
legend('\omega_1', '\omega_2','Location','northwest' )
axis([-20, 0.5, -20, 1.1])
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
box off

support_vectors = [omeg_1(:,1), omeg_2(:,3)];

g = hyperSpase(support_vectors);

plot(g')