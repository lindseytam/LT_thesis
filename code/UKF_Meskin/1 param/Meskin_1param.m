% Acknowledgements: This code is adapted from Matlab's VDP example https://www.mathworks.com/help/control/ug/nonlinear-state-estimation-using-unscented-kalman-filter.html
% Author: Ltam
% Description: 
    % This is the main function that implements the UKF on all four states
    % and one parameter in Meskin using joint parameter estimation. Currently, this code reads in previously generated data
    % and corrects for all five states. However, these can be adjusted as
    % neccessary. In addition, this function graphs the results of all
    % five states and their residuals.
% Inputs:   None
% Outputs:  None
% Last updated: 30 April 2020

initialStateGuess = [4;1;3;4;20]; % xhat[k|k-1]
%initialStateGuess = [1;4;2;5;16]; % bad intials

% Construct the filter
ukf = unscentedKalmanFilter(...
    @MeskinStateFcn_1param,... % State transition function
    @MeskinMeasurementFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',true)%,...
    %'alpha', 0.9,...
    %'kappa', 3,...
    %'beta', 2);
    
R = .01; % Variance of the measurement noise v[k]
ukf.MeasurementNoise = R;

ukf.ProcessNoise = diag([0.2 0.1 .3 .4 .2]); %stores the process noise covariance

T = 0.1; % [s] Filter sample time
timeVector = 0:T:5;

xTrue = readtable('Meskin_true_1param.csv'); % meas
xTrue = xTrue{:,:};

yMeas = readtable('Meskin_meas_1param.csv'); % meas
yMeas = yMeas{:,:};
% yMeas = yMeas(:,:);% CHANGE THIS depending on how many states are being

rng(1); % Fix the random number generator for reproducible results

% Uncomment this code chunk if you want to create a new dataset each time
% [~,xTrue]=ode45(@Meskin2,timeVector,initialStateGuess); 
% yTrue = xTrue(:,1:4); % CHANGE THIS depending on how many states are being
% corrected
% yTrue = xTrue;
% yMeas = yTrue + (sqrt(R)*randn(size(yTrue))); 
    % sqrt(R): Standard deviation of noise
    % randn(size(yTrue)): randomly sample 51 elements from ytrue
    %yMeas = yTrue; Assumes no noise

[n,m]=size(yMeas);
e=zeros(n,5);
for k=1:n
    % Let k denote the current time.
    
    % Residuals (or innovations): Measured output - Predicted output
    e(k,:) = yMeas(k,:) - transpose(MeskinMeasurementFcn(ukf.State)); % ukf.State is x[k|k-1] at this point
    
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    
    [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k,:));
    
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ukf);
    
end

% Generates a figure with the 4 states variables
figure('Position', get(0, 'Screensize'));
blue=[0,0.4470, 0.7410]; %blue
green=[0.4660 0.6740 0.1880]; %green
orange=[0.8500 0.3250 0.0980]; %orange
yellow=[0.9290 0.6940 0.1250]; %yellow
black=[0,0,0]; 

width=1.5;

subplot(3,2,1);
plot(timeVector, xTrue(:,1), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,1), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,1), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
a = legend('True','UKF estimate','Measured')
a.FontSize = 10;
ylim([0 5]);
ylabel('x_1', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 1")

subplot(3,2,2);
plot(timeVector, xTrue(:,2), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,2), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,2), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
b = legend('True','UKF estimate','Measured')
b.FontSize = 10;
ylim([0 5]);
xlabel('Time [s]', 'FontSize', 15);
ylabel('x_2', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 2")

subplot(3,2,3);
plot(timeVector, xTrue(:,3), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,3), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,3), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
c = legend('True','UKF estimate','Measured')
c.FontSize = 10;
ylabel('x_3', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 3")

subplot(3,2,4);
plot(timeVector, xTrue(:,4), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,4), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,4), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 4")

subplot(3,2,5);
plot(timeVector, xTrue(:,5), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,5), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,5), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
ylabel('x_5', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 5 (Parameter a1)")

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

% graph of residuals
figure();
subplot(1,1,1);
plot(timeVector, e, 'k.');
xlabel('Time [s]');
ylabel('Residual (or innovation)');
title('State Residuals');
