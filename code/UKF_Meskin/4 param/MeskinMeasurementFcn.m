function yk = MeskinMeasurementFcn(xk)
% Author: Ltam
% Date: November 17, 2019
% Summary:  
% Inputs:   xk = states at time k, x[k]
%           vk = measurement noise vector at time, k v[k]
% Outputs:  yk = measurements at time k
%

yk = xk; %use this to correct for one state (first state in this case)
% yk=xk; %use this to correct for all states

end