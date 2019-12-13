initialStateGuess = [4;1;3;4]; % xhat[k|k-1]
%initialStateGuess = [1;4;2;5]; % bad intials

% Construct the filter
ukf = unscentedKalmanFilter(...
    @MeskinStateFcn,... % State transition function
    @MeskinMeasurementNonAddFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',false)%,...
    %'alpha', 0.9,...
    %'kappa', 3,...
    %'beta', 2);
    
R = .001; % Variance of the measurement noise v[k]
ukf.MeasurementNoise = R;

ukf.ProcessNoise = diag([0.02 0.01 .03 .04]); %stores the process noise covariance

T = 0.1; % [s] Filter sample time
timeVector = 0:T:5;
[~,xTrue]=ode45(@Meskin1,timeVector,initialStateGuess); 

rng(1); % Fix the random number generator for reproducible results
yTrue = xTrue(:,1);
yMeas = yTrue + (sqrt(R)*randn(size(yTrue))); 
% sqrt(R): Standard deviation of noise
% randn(size(yTrue)): randomly sample 51 elements from ytrue
%yMeas = yTrue; Assumes no noise

for k=1:numel(yMeas) 
    % Let k denote the current time.
    
    % Residuals (or innovations): Measured output - Predicted output
    %e(k) = yMeas(k) - MeskinMeasurementFcn(ukf.State); % ukf.State is x[k|k-1] at this point
    
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    
    [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k));
    
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ukf);
    
end


figure();
color1=[0,0.4470, 0.7410]; %blue
color2=[0.4660 0.6740 0.1880]; %green
color3=[0.8500 0.3250 0.0980]; %orange
color4=[0.9290 0.6940 0.1250]; %yellow

subplot(2,2,1);
plot(timeVector, xTrue(:,1), 'Color', color1, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,1), 'Color', color1, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector,yMeas, 'Color', color1, 'Marker', '.',...
    'LineWidth', 1)

set(gca, 'FontSize', 15);
set(gcf, 'Color', 'None');
a = legend('True','UKF estimate','Measured')
a.FontSize = 10;
ylim([0 5]);
ylabel('x_1', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);

subplot(2,2,2);
plot(timeVector, xTrue(:,2), 'Color', color2, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,2), 'Color', color2, 'LineStyle', '--',...
    'LineWidth', 1)
set(gca, 'FontSize', 15);
b = legend('True','UKF estimate')
b.FontSize = 10;
ylim([0 5]);
xlabel('Time [s]', 'FontSize', 15);
ylabel('x_2', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);

subplot(2,2,3);
plot(timeVector, xTrue(:,3), 'Color', color3, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,3), 'Color', color3, 'LineStyle', '--',...
    'LineWidth', 1)
set(gca, 'FontSize', 15);
c = legend('True','UKF estimate')
c.FontSize = 10;
%ylim([-2.6 2.6]);
ylabel('x_3', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);

subplot(2,2,4);
plot(timeVector, xTrue(:,4), 'Color', color4, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,4), 'Color', color4, 'LineStyle', '--',...
    'LineWidth', 1)
set(gca, 'FontSize', 15);
d = legend('True','UKF estimate','Measured')
d.FontSize = 10;
%ylim([-2.6 2.6]);
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);

%saveas(gcf,'\Users\lindseytam\Desktop\thesis\Meskin_states_badIntial.png')
%saveas(gcf,'\Users\lindseytam\Desktop\thesis\Meskin_states.png')

subplot(1,1,1);

plot(timeVector, xTrue(:,1), 'Color', color1, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,1), 'Color', color1, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector,yMeas, 'Color', color1, 'Marker', '.',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,2), 'Color', color2, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,2), 'Color', color2, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,3), 'Color', color3, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,3), 'Color', color3, 'LineStyle', '--',...
    'LineWidth', 1)
hold on
plot(timeVector, xTrue(:,4), 'Color', color4, 'LineStyle', '-',...
    'LineWidth', 1)
hold on 
plot(timeVector,xCorrectedUKF(:,4), 'Color', color4, 'LineStyle', '--',...
    'LineWidth', 1)

set(gca, 'FontSize', 15);
set(gcf, 'color', 'none');
set(gca, 'color', 'none');
e = legend('x1 True','x1 UKF','x2 True', 'x2 UKF', 'x3 True','x3 UKF','x4 True', 'x4 UKF')
e.FontSize = 10;
ylim([0 5]);
ylabel('x_4', 'FontSize', 15);
xlabel('Time [s]', 'FontSize', 15);

%saveas(gcf,'\Users\lindseytam\Desktop\thesis\Meskin_overall_badIntial.png')
saveas(gcf,'\Users\lindseytam\Desktop\thesis\Meskin_overall.png')