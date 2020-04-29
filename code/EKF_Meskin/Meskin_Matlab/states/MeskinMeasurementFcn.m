function yk = MeskinMeasurementFcn(xk)
% Author: Ltam
% Date: November 17, 2019
% Description:
	% This function defines which states are measurable.
% Inputs:   xk = states at time k
% Outputs:  yk = measurements at time k

% yk = xk(1); % use this to correct for one state (first state in this case)
% yk [xk(2) xk(3)] % use this to correct for a subset of states
yk=xk; % use this to correct for all states

end