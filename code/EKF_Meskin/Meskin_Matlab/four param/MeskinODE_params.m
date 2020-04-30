function dxdt = MeskinStateFcnContinuous(t,x)
% Author: Ltam
% Description:
    % This function describes the Meskin system through the ODEs for all
    % four states and is called in the helper function, MeskinStateFcn_params.m, 
    % in order to discretize the system.
    % The subscript parameter_values.m is also called here.
% Last Updated: 30 April 2020
% Inputs:   x: vector of intial state values
%           t: scalar value for time, use t=0
% Outputs:  dxdt: vector that describes state values after they undergo a
%                 transformation

parameter_values;

dxdt = [x(5) * x(3)^g_13 - b_1 * x(1)^h_11;
        x(6) * x(1)^g_21 - b_2 * x(2)^h_22;
        x(7) * x(2)^g_32 - b_3 * x(3)^h_33 * x(4)^h_34;
        x(8) * x(1)^g_41 - b_4 * x(4)^h_44;
        0;
        0;
        0;
        0];
end
