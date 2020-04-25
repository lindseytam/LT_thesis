initialStateGuess = [4;1;3;4;20;8;3;2]; % true intials
% initialStateGuess = [4;1;3;4;23;5;6;5]; % bad intials

% Construct the filter
ukf = unscentedKalmanFilter(...
    @MeskinStateFcn_params,... % State transition function
    @MeskinMeasurementFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',true)%,...
    %'alpha', 0.9,...
    %'kappa', 3,...
    %'beta', 2);
    
R = .01; % Variance of the measurement noise v[k]
ukf.MeasurementNoise = R;

ukf.ProcessNoise = diag([0.2 0.1 0.3 .4 .2 .3 .2 .1]); %stores the process noise covariance
initialStateGuess = [4;1;3;4;20;8;3;2];

T = 0.1; % [s] Filter sample time
timeVector = 0:T:5;

xTrue = readtable('Meskin_true_params.csv'); % true values
xTrue = xTrue{:,:}; % this changes the format into a matrix

yMeas = readtable('Meskin_meas_params.csv'); % measured values
yMeas = yMeas{:,:};
% yMeas = yMeas(:,:);% CHANGE THIS depending on how many states are being

%{
% uncomment to create new datasets
%[~,xTrue]=ode45(@Meskin3,timeVector,initialStateGuess); 
% yTrue = xTrue;
% yMeas = yTrue + (sqrt(R)*randn(size(yTrue))); 
    % sqrt(R): Standard deviation of noise
    % randn(size(yTrue)): randomly sample 51 elements from ytrue
    %yMeas = yTrue; Assumes no noise
%}

[n,m]=size(yMeas); % determine number of loops
e=zeros(n,8); % set aside space for residuals

for k=1:n
    % Let k denote the current time.
    
    % Residuals (or innovations): Measured output - Predicted output
    e(k,:) = yMeas(k,:) - transpose(MeskinMeasurementFcn(ukf.State)); % ukf.State is x[k|k-1] at this point
    
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    
%     [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k));
    [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k,:));
    
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ukf);
    
end

figure('Position', get(0, 'Screensize'));
blue=[0,0.4470, 0.7410];
green=[0.4660 0.6740 0.1880];
orange=[0.8500 0.3250 0.0980]; 
yellow=[0.9290 0.6940 0.1250];
black=[0,0,0]; 

width=1.5; % line width
rows=4; % number of rows in figure
cols=2; % number of cols in figure

subplot(rows,cols,1);
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

subplot(rows,cols,2);
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

subplot(rows,cols,3);
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

subplot(rows,cols,4);
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

subplot(rows,cols,5);
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
% ylim([19 23])

subplot(rows,cols,6);
plot(timeVector, xTrue(:,6), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,6), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,6), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
ylabel('x_6', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 6 (Parameter a2)")

subplot(rows,cols,7);
plot(timeVector, xTrue(:,7), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,7), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,7), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
ylabel('x_7', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 7 (Parameter a3)")

subplot(rows,cols,8);
plot(timeVector, xTrue(:,8), 'Color', black, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,8), 'Color', blue, 'LineStyle', '--',...
    'LineWidth', width)

hold on
plot(timeVector,yMeas(:,8), 'Color', green, 'Marker', '.',...
    'LineWidth', width)

set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
ylabel('x_8', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);
title("State 8 (Parameter a4)")

% saveas(gcf,'\Users\lindseytam\Desktop\thesis\Meskin_states_updated.png')

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

% graph of all residuals
figure();
subplot(1,1,1);
plot(timeVector, e, 'k.');
xlabel('Time [s]');
ylabel('Residual (or innovation)');
title('State Residuals ');

