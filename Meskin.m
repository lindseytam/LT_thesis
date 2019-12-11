initialStateGuess = [4;1;3;4]; % xhat[k|k-1]

% Construct the filter
ukf = unscentedKalmanFilter(...
    @MeskinStateFcn,... % State transition function
    @MeskinMeasurementNonAddFcn,... % Measurement function
    initialStateGuess,...
    'HasAdditiveMeasurementNoise',false)%,...
    %'alpha', 0.9);
    
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
%yMeas = yTrue;

%Nsteps = numel(yMeas); % Number of time steps
%xCorrectedUKF = zeros(Nsteps,4); % Corrected state estimates
%PCorrected = zeros(Nsteps,4,4); % Corrected state estimation error covariances
%e = zeros(Nsteps,1); % Residuals (or innovations)

for k=1:numel(yMeas) 
    % Let k denote the current time.
    
    % Residuals (or innovations): Measured output - Predicted output
    
    %e(k) = yMeas(k) - MeskinMeasurementFcn(ukf.State); % ukf.State is x[k|k-1] at this point
    
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    
    %[xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k));
    [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf, yMeas(k));
    %[xCorrectedUKF(k,:,:), PCorrected(k,:,:,:)] = correct(ukf, yMeas(k, 2));
    %for j=1:numel(yMeas) 
    %[xCorrectedUKF(k,:), PCorrected(k,k,:)] = correct(ukf, yMeas(j, 1));
    %[xCorrectedUKF(k+1,:), PCorrected(k+1,:,:)] = correct(ukf, yMeas(j, 2));
    %[xCorrectedUKF(k+2,:), PCorrected(k+2,:,:)] = correct(ukf, yMeas(j, 3));
    %[xCorrectedUKF(k+3,:), PCorrected(k+3,:,:)] = correct(ukf, yMeas(j, 4));
    %end
    
    %xCorrectedUKF(:,1) = first col
    %xCorrectedUKF(1,:) = first row
    %xCorrectedUKF(k,:) = kth row row
    %PCorrected(k,:,:) = first row of each of the 4 matrices
    
    %There are 4 51x4 state covariances
    
    
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ukf);
    
end


figure();

subplot(2,3,1);
plot(timeVector,xTrue(:,1), '-b',timeVector,xCorrectedUKF(:,1), '--b',...
    timeVector,yMeas(:), '*b',...
    'LineWidth', 3);
set(gca, 'FontSize', 20);
legend('True','UKF estimate','Measured')
ylim([0 5]);
ylabel('x_1', 'FontSize', 20);

subplot(2,3,2);
plot(timeVector,xTrue(:,2),'-g', timeVector,xCorrectedUKF(:,2), '--g',...
    'LineWidth', 3);
set(gca, 'FontSize', 20);
ylim([0 5]);
xlabel('Time [s]', 'FontSize', 20);
ylabel('x_2', 'FontSize', 20);

subplot(2,3,3);
plot(timeVector,xTrue(:,3), 'r',timeVector,xCorrectedUKF(:,3), '--r',...
    'LineWidth', 3);
set(gca, 'FontSize', 20);
legend('True','UKF estimate','Measured')
%ylim([-2.6 2.6]);
ylabel('x_3', 'FontSize', 20);

subplot(2,3,4);
plot(timeVector,xTrue(:,4), 'c',timeVector,xCorrectedUKF(:,4), '--c',...
   'LineWidth', 3);
set(gca, 'FontSize', 20);
legend('True','UKF estimate','Measured')
%ylim([-2.6 2.6]);
ylabel('x_4', 'FontSize', 20);

subplot(2,3,5);
plot(timeVector,xTrue(:,1), '-b',timeVector,xCorrectedUKF(:,1), '--b',...
    timeVector,xTrue(:,2), '-g',timeVector,xCorrectedUKF(:,2), '--g',...
    timeVector,xTrue(:,3), '-r',timeVector,xCorrectedUKF(:,3), '--r',...
    timeVector,xTrue(:,4), '-c',timeVector,xCorrectedUKF(:,4), '--c',...
   'LineWidth', 3);
set(gca, 'FontSize', 20);
legend('x1 True','x1 UKF','x2 True', 'x2 UKF', 'x3 True','x3 UKF','x4 True', 'x4 UKF')
ylim([0 5]);
ylabel('x_4', 'FontSize', 20);