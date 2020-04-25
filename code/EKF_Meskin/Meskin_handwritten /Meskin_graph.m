xTrue = readtable('Meskin_true.csv'); % meas
xTrue = xTrue{:,:};
yMeas = readtable('Meskin_meas.csv'); % meas
yMeas = yMeas{:,:};
%{
[n,m] = size(xTrue)

figure;
subplot(2,2,1)
plot(xTrue(:,1), 'k-')
hold on;
plot(xhat(:,1))
hold on;
plot(yMeas(:,1))
hold on;
legend('True', 'EKF', 'Meaured')
xlabel('Time step');
title('State 1');
xlim([0 n])


subplot(2,2,2)
plot(xTrue(:,2), 'k-')
hold on;
plot(xhat(:,2))
hold on;

plot(yMeas(:,2))
legend('True', 'EKF', 'Measured')
xlabel('Time step');
title('State 2');
xlim([0 n])

subplot(2,2,3)
plot(xTrue(:,3), 'k-')
hold on;
plot(xhat(:,3))
legend('True', 'EKF')
xlabel('Time step');
title('State 3');
xlim([0 n])



subplot(2,2,4)
plot(xTrue(:,4), 'k-')
hold on;
plot(xhat(:,4))
legend('True', 'EKF')
xlabel('Time step');
title('State 4');
xlim([0 n])
saveas(gcf,'\Users\lindseytam\Desktop\thesis\TEST.png')


%}
%{
[n,m] = size(yMeas);
% n=5;
location ='northeast';
x = 0:0.1:5;
figure('Position', get(0, 'Screensize'));
subplot(3,3,1)
plot(xTrue(:,1), 'k-')
hold on;
plot(xhat(:,1))
hold on;
plot(yMeas(:,1))
hold on;
legend('True', 'EKF', 'Meaured', 'Location', location)

xlabel('Time step');
title('State 1');
xlim([0 n])

subplot(3,3,2)
plot(xTrue(:,2), 'k-')
hold on;
plot(xhat(:,2))
hold on;
plot(yMeas(:,2))
legend('True', 'EKF', 'Measured', 'Location', location)
xlabel('Time step');
title('State 2');
xlim([0 n])

subplot(3,3,3)
plot(xTrue(:,3), 'k-')
hold on;
plot(xhat(:,3))
hold on;
plot(yMeas(:,3))
legend('True', 'EKF', 'Measured', 'Location', location)
xlabel('Time step');
title('State 3');
xlim([0 n])

subplot(3,3,4)
plot(xTrue(:,4), 'k-')
hold on;
plot(xhat(:,4))
hold on;
plot(yMeas(:,4))
legend('True', 'EKF', 'Measured', 'Location', location)
xlabel('Time step');
title('State 4');
xlim([0 50])

x = 3;

subplot(3,3,5)
plot(xTrue(:,5), 'k-')
hold on;
plot(xhat(:,5))
legend('True', 'EKF', 'Location', location)
% ylim([19.5 20.5])
ylim([20-x 20+x])
xlabel('Time step');
title('State 5');
xlim([0 n])

subplot(3,3,6)
plot(xTrue(:,6), 'k-')
hold on;
plot(xhat(:,6))
legend('True', 'EKF', 'Location', location)
% ylim([7.5 8.5])
ylim([8-x 8+x])
xlabel('Time step');
title('State 6');
xlim([0 n])

subplot(3,3,7)
plot(xTrue(:,7), 'k-')
hold on;
plot(xhat(:,7))
legend('True', 'EKF', 'Location', location)
% ylim([2.5 3.5])
ylim([3-x 3+x])
xlabel('Time step');
title('State 7');
xlim([0 n])

subplot(3,3,8)
plot(xTrue(:,8), 'k-')
hold on;
plot(xhat(:,8))
legend('True', 'EKF', 'Location', location)
ylim([2-x 2+x])
% ylabel('x_8');
xlabel('Time step');
title('State 8');
xlim([0 n])
%}
[n,m] = size(yMeas);
% n=5;
location ='northeast';
x = 0:0.1:5;
figure('Position', get(0, 'Screensize'));
subplot(3,2,1)
plot(xTrue(:,1), 'k-')
hold on;
plot(xhat(:,1))
hold on;
plot(yMeas(:,1))
hold on;
legend('True', 'EKF', 'Meaured', 'Location', location)
xlabel('Time step');
title('State 1');
xlim([0 n])

subplot(3,2,2)
plot(xTrue(:,2), 'k-')
hold on;
plot(xhat(:,2))
% hold on;
% plot(yMeas(:,2))
legend('True', 'EKF', 'Location', location)
xlabel('Time step');
title('State 2');
xlim([0 n])

subplot(3,2,3)
plot(xTrue(:,3), 'k-')
hold on;
plot(xhat(:,3))
%hold on;
%plot(yMeas(:,3))
legend('True', 'EKF', 'Location', location)
xlabel('Time step');
title('State 3');
xlim([0 n])

subplot(3,2,4)
plot(xTrue(:,4), 'k-')
hold on;
plot(xhat(:,4))
%hold on;
%plot(yMeas(:,4))
legend('True', 'EKF', 'Location', location)
xlabel('Time step');
title('State 4');
xlim([0 n])

x = 1.5;

%{
subplot(3,2,5)
plot(xTrue(:,5), 'k-')
hold on;
plot(xhat(:,5))
legend('True', 'EKF', 'Location', location)
% ylim([19.5 20.5])
% ylim([20-x 20+x])
xlabel('Time step');
title('State 5');
% xlim([0 n])
%}

% try plotting residuals
destination = strcat('\Users\lindseytam\Desktop\IMAGES\', string(datetime('now')), '.png');
% saveas(gcf,destination)

saveas(gcf,'\Users\lindseytam\Desktop\HW_EKF_1STATE.png')

