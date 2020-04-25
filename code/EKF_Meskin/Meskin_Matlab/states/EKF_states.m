initialStateGuess = [4;1;3;4]; % true intials
% initialStateGuess = [6;4;2;7]; % bad intials

% Construct the filter
ekf = extendedKalmanFilter(...
    @MeskinStateFcn,... % State transition function
    @MeskinMeasurementFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',true)
    
R = .01; % Variance of the measurement noise v[k]
ekf.MeasurementNoise = R;

ekf.ProcessNoise = diag([0.2 0.1 .3 .4]); %stores the process noise covariance

T = 0.1; % [s] Filter sample time
timeVector = 0:T:5;

xTrue = readtable('Meskin_true.csv'); % loading true values from ODE solver, data generated from Meskin_true.m
xTrue = xTrue{:,:};

yMeas = readtable('Meskin_meas.csv'); % % loading simulated measured, generated from Meskin_true.m
yMeas = yMeas{:,:};% use this if you are correcting for all states
% yMeas = yMeas{:,1}; % CHANGE THIS depending on which states have incoming
% measurements

rng(1); % Fix the random number generator for reproducible results

%{
% uncomment this to create a new dataset
% [~,xTrue]=ode45(@Meskin1,timeVector,initialStateGuess); 
% yTrue = xTrue
% yMeas = yTrue + (sqrt(R)*randn(size(yTrue))); 
    % sqrt(R): Standard deviation of noise
    % randn(size(yTrue)): randomly sample 51 elements from ytrue
    %yMeas = yTrue; Assumes no noise
%}

[n,m]=size(yMeas); % determine how long forloop should run
e=zeros(n,4); % setting aside space for residuals

for k=1:n
    % Let k denote the current time.
    
    % Residuals (or innovations): Measured output - Predicted output
    e(k,:) = yMeas(k,:)- transpose(MeskinMeasurementFcn(ekf.State)); % ukf.State is x[k|k-1] at this point
    
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
blue=[0,0.4470, 0.7410];
green=[0.4660 0.6740 0.1880];
orange=[0.8500 0.3250 0.0980];
yellow=[0.9290 0.6940 0.1250]; 
black=[0,0,0]; 

width=1.5; % width of line

subplot(2,2,1);
plot(timeVector, xTrue(:,1), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,1), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,1), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
a = legend('True','EKF estimate','Measured')
a.FontSize = 10;
ylim([0 5]);
ylabel('x_1', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 1")

subplot(2,2,2);
plot(timeVector, xTrue(:,2), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,2), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,2), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
b = legend('True','EKF estimate','Measured')
b.FontSize = 10;
ylim([0 5]);
xlabel('Time [s]', 'FontSize', 15);
ylabel('x_2', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 2")

subplot(2,2,3);
plot(timeVector, xTrue(:,3), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,3), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,3), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
c = legend('True','EKF estimate','Measured')
c.FontSize = 10;
ylabel('x_3', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 3")

subplot(2,2,4);
plot(timeVector, xTrue(:,4), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedEKF(:,4), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,4), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','EKF estimate','Measured')
d.FontSize = 10;
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 4")

% saveas(gcf,'\Users\lindseytam\Desktop\IM\EKF_4states_badinitials.png')

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

% graph of state residuals
figure();
subplot(1,1,1);
plot(timeVector, e, 'k.');
xlabel('Time [s]');
ylabel('Residual (or innovation)');
title('State Residuals ');
