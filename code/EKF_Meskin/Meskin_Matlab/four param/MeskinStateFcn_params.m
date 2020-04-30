function x = MeskinStateFcn(x)
% Author: Ltam
% Description:
    % This code is called bu EKF_params.m and is used to discretize the
    % system, which is described by MeskinODE_params.m, using Euler's method.
% Last Updated: 30 April 2020
% Inputs:   x: vector of intial state values
% Outputs:  x: vector of discretized estimate of state values

dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE_params(t, x)*dt;
end
