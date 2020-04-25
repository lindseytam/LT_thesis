function x = MeskinStateFcn_params(x)
% Trying Meskin in two dimensions
dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE_params(t, x)*dt;
end
