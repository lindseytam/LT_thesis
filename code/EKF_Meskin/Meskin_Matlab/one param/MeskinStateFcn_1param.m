function x = MeskinStateFcn(x)
% Trying Meskin in two dimensions
dt = 0.05;
t = 0; % dummy time variable for MeskinODE
% x = x + MeskinODE(t, x)*dt;
x = x + MeskinODE_1param(t, x)*dt;

end
