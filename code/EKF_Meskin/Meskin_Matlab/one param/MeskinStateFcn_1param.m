function x = MeskinStateFcn(x)
% Author: Ltam
% Description:
    % This code is called bu EKF_1param.m and is used to discretize the
    % system, which is described by MeskinODE_1param.m, using Euler's method.
% Last Updated: 30 April 2020
% Inputs:   x: vector of intial state values
% Outputs:  x: vector of discretized estimate of state values

dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE_1param(t, x)*dt;

end
