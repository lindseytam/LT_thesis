
%{ 
input values:
Q = 0;
R = 0.01; % measurement noise covariance
m0 = [4;1;3;4]; % states
m0 = [4;1;3;4;20]; % states + first_param (a_1)
m0 = [4;1;3;4;20;8;3;2]; % states + four params (a_1,...,a_4)
%}
function [xTrue, yMeas] = Meskin_true(Q,R,m0)

% xTrue: true values for ALL states
% yTrue: true values for measurable states
% yMeas: system measurements  

T = .1 % Value taken from Meskin
timeVector = 0:T:5; % Value taken from Meskin

[n,m] = size(timeVector); 
yMeas = zeros(m,8); % CHANGE THIS depending on how many states are in the system

% ode45(@Meskin2,timeVector,[4;1;3;4]); % plots true values
[~,xTrue] = ode45(@Meskin_4params,timeVector,m0);
    % CHANGE THIS depending on the system
        % Meskin_4params: ODE for 4 params and 4 states
        % Meskin_states: ODE for 4 states
        % Meskin_1params: ODE for 4 states and 1 param (first param)

yTrue = xTrue; % Since Q is 0, xTrue is simply the output of the ODE solver. 
               % Here, we are setting up the dimension/size for yTrue and
               % will add noise below
               
[n,m] = size(timeVector); % determines how many loops need to be runned
                          % m is how many trials / measurements there are 
for k=1:m
    % CHANGE THIS by commenting out / adding yMeas values (depending on the size of the system)
     yMeas(k, 1) = yTrue(k,1)+normrnd(0,sqrt(R)); 
     yMeas(k, 2) = yTrue(k,2)+normrnd(0,sqrt(R)); 
     yMeas(k, 3) = yTrue(k,3)+normrnd(0,sqrt(R)); 
     yMeas(k, 4) = yTrue(k,4)+normrnd(0,sqrt(R)); 
     yMeas(k, 5) = yTrue(k,5)+normrnd(0,sqrt(R));
     yMeas(k, 6) = yTrue(k,6)+normrnd(0,sqrt(R)); 
     yMeas(k, 7) = yTrue(k,7)+normrnd(0,sqrt(R)); 
     yMeas(k, 8) = yTrue(k,8)+normrnd(0,sqrt(R)); 
     
end

% Output the noise results to use later / make results reproducible
% csv saves in the same dir as this file (can be changed if needed)
csvwrite('Meskin_true_params.csv',xTrue) % true
csvwrite('Meskin_meas_params.csv',yMeas) % measurement

end