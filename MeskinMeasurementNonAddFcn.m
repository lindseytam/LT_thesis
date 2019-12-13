function yk = MeskinMeasurementNonAddFcn(xk,vk)
% Author: Ltam
% Date: November 17, 2019
% Summary:  
% Inputs:   xk = states at time k, x[k]
%           vk = measurement noise vector at time, k v[k]
% Outputs:  yk = measurements at time k
%
% The measurement is the first state with multiplicative noise
yk = xk(1)+vk;
%yk =xk*(1+vk);
end