function x = MeskinStateFcn(x)
dt = 0.05;
t = 0; % dummy time variable for MeskinODE
x = x + MeskinODE(t, x)*dt;
end
