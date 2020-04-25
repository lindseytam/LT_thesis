function Meskin_baseline

tspan=[0 5];

x0=[4 1 3 4];

[tsol,xsol]=ode45(@MeskinODE,tspan,x0');

figure;
plot(tsol,xsol(:,1),'-o',tsol,xsol(:,2),'-o',tsol,xsol(:,3),'-o',tsol,xsol(:,4),'-o')
title('Solution of Meskin Equation  with ODE45');
xlabel('Time t');
ylabel('Solution x');
legend('x_1','x_2','x_3','x_4')

end