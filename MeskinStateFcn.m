function x = MeskinStateFcn(x)
% Trying Meskin in two dimensions
dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE(t, x)*dt;
end

%{
function dxdt = MeskinStateFcnContinuous(x)
parameter_values;

dxdt = [a_1 * x(3)^g_13 - b_1 * x(1)^h_11;
        a_2 * x(1)^g_21 - b_2 * x(2)^h_22;
        a_3 * x(2)^g_32 - b_3 * x(3)^h_33 * x(4)^h_34;
        a_4 * x(1)^g_41 - b_4 * x(4)^h_44];
end
%}