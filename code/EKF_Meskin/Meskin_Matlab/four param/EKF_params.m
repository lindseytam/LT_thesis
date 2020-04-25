initialStateGuess = [4;1;3;4;20;8;3;2];
% initialStateGuess = [17;6;4;9;23;5;7;5]; % bad intial guess for filter

% Construct the filter
ekf = extendedKalmanFilter(...
    @MeskinStateFcn_params,... % State transition function
    @MeskinMeasurementFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',true);
  
R = .01; % Variance of the measurement noise v[k]
ekf.MeasurementNoise = R;

ekf.ProcessNoise = diag([0.2 0.1 0.3 .4 .2 .3 .2 .1]); %stores the process noise covariance

T = 0.1; % [s] Filter sample time
timeVector = 0:T:5;

% [~,xTrue]=ode45(@Meskin3,timeVector,true_initials); 
xTrue = readtable('Meskin_true_params.csv'); 
xTrue = xTrue{:,:};

yMeas = readtable('Meskin_meas_params.csv'); % meas
yMeas = yMeas{:,:};
% yMeas = yMeas(:,:);% CHANGE THIS depending on how many states are being


rng(1); % Fix the random number generator for reproducible results

%true_initials = [4;1;3;4;20;8;3;2];
% [~,xTrue]=ode45(@Meskin3,timeVector,true_initials); 
% yTrue = xTrue(:,1); % CHANGE THIS depending on how many states are being
% corrected
% yTrue = xTrue;
% yMeas = yTrue + (sqrt(R)*randn(size(yTrue))); 
    % sqrt(R): Standard deviation of noise
    % randn(size(yTrue)): randomly sample 51 elements from ytrue
    %yMeas = yTrue; Assumes no noise

[n,m]=size(yMeas);
e=zeros(n,8);
for k=1:n
    % Let k denote the current time.
  
    % Residuals (or innovations): Measured output - Predicted output
    e(k,:) = yMeas(k,:) - transpose(MeskinMeasurementFcn(ekf.State)); % ukf.State is x[k|k-1] at this point
    
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    
    [xCorrectedEKF(k,:), PCorrected(k,:,:)] = correct(ekf, yMeas(k,:));
    
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ekf);
    
end

% Generates a figure with the 4 states variables
figure('Position', get(0, 'Screensize'));
blue=[0,0.4470, 0.7410]; %blue
green=[0.4660 0.6740 0.1880]; %green
orange=[0.8500 0.3250 0.0980]; %orange
yellow=[0.9290 0.6940 0.1250]; %yellow
black=[0,0,0]; 

width=1.5;

subplot(4,2,1);
plot(timeVector, xTrue(:,1), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,1), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,1), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
a = legend('True','EKF estimate','Measured')
a.FontSize = 10;
ylim([0 5]);
ylabel('x_1', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 1")

subplot(4,2,2);
plot(timeVector, xTrue(:,2), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,2), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,2), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
b = legend('True','EKF estimate','Measured')
b.FontSize = 10;
ylim([0 5]);
xlabel('Time [s]', 'FontSize', 15);
ylabel('x_2', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 2")

subplot(4,2,3);
plot(timeVector, xTrue(:,3), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,3), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,3), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
c = legend('True','EKF estimate','Measured')
c.FontSize = 10;
ylabel('x_3', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 3")

subplot(4,2,4);
plot(timeVector, xTrue(:,4), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,4), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,4), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 4")

subplot(4,2,5);
plot(timeVector, xTrue(:,5), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,5), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,5), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_5', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 5 (Parameter a1)")

subplot(4,2,6);
plot(timeVector, xTrue(:,6), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,6), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,6), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_5', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 6 (Parameter a2)")

subplot(4,2,7);
plot(timeVector, xTrue(:,7), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,7), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,7), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_5', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 7 (Parameter a3)")

subplot(4,2,8);
plot(timeVector, xTrue(:,8), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,8), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)
%{
hold on
plot(timeVector,yMeas(:,8), 'Color', green, 'Marker', '.',...
    'LineWidth', width)
%}
set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_5', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 8 (Parameter a4)")

%{
% Generates one figure with all states 
figure();
subplot(1,1,1);
plot(timeVector, xTrue(:,1), 'Color', blue, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,1), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector,yMeas, 'Color', blue, 'Marker', '.',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,2), 'Color', green, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,2), 'Color', green, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,3), 'Color', orange, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,3), 'Color', orange, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,4), 'Color', yellow, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,4), 'Color', yellow, 'LineStyle', '--',...
    'LineWidth', 1)


set(gca, 'FontSize', 15);
% set(gcf, 'color', 'none');
% set(gca, 'color', 'none');
all = legend('x1 True','x1 UKF','x2 True', 'x2 UKF', 'x3 True','x3 UKF','x4 True', 'x4 UKF')
all.FontSize = 10;
ylim([0 5]);
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
%}

% graph residuals
figure();
subplot(1,1,1);
plot(timeVector, e, 'k.');
xlabel('Time [s]');
ylabel('Residual (or innovation)');
title('State Residuals');
