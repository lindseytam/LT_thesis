function x = MeskinStateFcn_1param(x)
% Trying Meskin in two dimensions
dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE_1param(t, x)*dt;
end
