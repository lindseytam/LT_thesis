
% input values
    % Q = .2
    % R = .1;
    % m0= [4;1;3;4;20;8;3;2]; % for parameter estimation
    % P0=.1; 
    
function [xhat] = Meskin_EKF(Q,R,m0,P0,num_states)
% yMeas: incoming system measurements from Meskin_true
% Q: Process noise covariance
% R: Measurement noise covariance
% m0: initial state
% P0: intial state covariance

% 0. Simulate / store training data
% 1. try running this without parameters (just states)
% 2. Tune filter (P, Q, R, m0)
% 3. Param fitting (one param at a time)
yMeas = readtable('Meskin_meas.csv'); % meas
yMeas = yMeas{:,:};
ymeas = yMeas(:, 1:num_states);

[n,m] = size(ymeas); 
[l,k] = size(m0); 

P = zeros(l,l); 
xhat = zeros(n,l);

% true parameter values
a_1 = 20;
a_2 = 8;
a_3 = 3;
a_4 = 2;

b1 = 10;
b2 = 3;
b3 = 5;
b4 = 6;

g_11 = 0;
g_21 = 0.5;
g_31 = 0;
g_41 = 0.5;

g_12 = 0;
g_22 = 0;
g_32 = 0.75;
g_42 = 0;

g_13 = -0.8;
g_23 = 0;
g_33 = 0;
g_43 = 0;

g_14 = 0;
g_24 = 0;
g_34 = 0;
g_44 = 0;

h_11 = 0.5;
h_21 = 0;
h_31 = 0;
h_41 = 0;

h_12 = 0;
h_22 = 0.75;
h_32 = 0;
h_42 = 0;

h_13 = 0;
h_23 = 0;
h_33 = 0.5;
h_43 = 0;

h_14 = 0;
h_24 = 0;
h_34 = 0.2;
h_44 = 0.8;


% Phi is the Jacobian of the state transition matrix
Phi = [-b1*h_11*m0(1)^(h_11-1), 0, g_13*m0(5)*m0(3)^(g_13-1), 0, m0(3)^(g_13), 0, 0, 0;
       g_21*m0(6)*m0(1)^(g_21-1), h_22*-b2*m0(2)^(h_22-1), 0, 0, 0, m0(1)^g_21, 0, 0;
       0, g_32*m0(7)*m0(2)^(g_32-1), -b3*m0(4)^h_34*h_33*m0(3)^(h_33-1), -b3*m0(3)^(h_33)*h_34*m0(4)^(h_34-1), 0, 0, m0(2)^g_32, 0;
       g_41*m0(8)*m0(1)^(g_41-1), 0, 0, -b4*h_44*m0(4)^(h_44-1), 0, 0, 0, m0(1)^g_41;
       0,0,0,0,1,0,0,0;
       0,0,0,0,0,1,0,0;
       0,0,0,0,0,0,1,0;
       0,0,0,0,0,0,0,1];

A = [-b1*m0(1)^(h_11-1), 0, m0(5)*m0(3)^(g_13-1), 0, 0, 0, 0, 0;
    m0(6)*m0(1)^(g_21-1),-b2*m0(2)^(h_22-1),0,0,0,0,0,0;
    0,m0(7)*m0(2)^(g_32-1),-b3*m0(3)^(h_33-1)*m0(4)^(h_34),0,0,0,0,0;
    0,0,0,-b4*m0(4)^(h_44-1),0,0,0,m0(1)^g_41;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0];

% finish this (state estimation)
% implement in matlab (ekf built in)
% parameter estimation


x1 = expm(A) * m0; % prediction step

H = [-b1*h_11*x1(1)^(h_11-1), 0, g_13*x1(5)*x1(3)^(g_13 - 1), 0, x1(3)^(g_13), 0, 0, 0;
       g_21*x1(6)*x1(1)^(g_21-1), h_22*-b2*x1(2)^(h_22-1), 0, 0, 0, x1(1)^g_21, 0, 0;
       0, g_32*x1(7)*x1(2)^(g_32-1), -b3*x1(4)^h_34*h_33*x1(3)^(h_33-1), -b3*x1(3)^(h_33)*h_34*x1(4)^(h_34-1), 0, 0, x1(2)^g_32, 0;
       g_41*x1(8)*x1(1)^(g_41-1), 0, 0, -b4*h_44*x1(4)^(h_44-1), 0, 0, 0, x1(1)^g_41];
    
H = real(H);
H = H(1:num_states,:);
P1 = Phi*P0*transpose(Phi)+Q;
S = H*P1*transpose(H)+R;
K = P1*transpose(H)/S;
P = (1-K*H)*P1;

xhat(1,:) = transpose(x1+K*(transpose(ymeas(1,:))-x1(1:num_states))); 

for k=2:n
    
    Phi = [-b1*h_11*xhat(k-1,1)^(h_11-1), 0, g_13*xhat(k-1,5)*xhat(k-1,3)^(g_13 - 1), 0, xhat(k-1,3)^(g_13), 0, 0, 0;
       g_21*xhat(k-1,6)*xhat(k-1,1)^(g_21-1), h_22*-b2*xhat(k-1,2)^(h_22-1), 0, 0, 0, xhat(k-1,1)^g_21, 0, 0;
       0, g_32*xhat(k-1,7)*xhat(k-1,2)^(g_32-1), -b3*xhat(k-1,4)^h_34*h_33*xhat(k-1,3)^(h_33-1), -b3*xhat(k-1,3)^(h_33)*h_34*xhat(k-1,4)^(h_34-1), 0, 0, x1(2)^g_32, 0;
       g_41*xhat(k-1,8)*xhat(k-1,1)^(g_41-1), 0, 0, -b4*h_44*xhat(k-1,4)^(h_44-1), 0, 0, 0, xhat(k-1,1)^g_41;
       0,0,0,0,1,0,0,0;
       0,0,0,0,0,1,0,0;
       0,0,0,0,0,0,1,0;
       0,0,0,0,0,0,0,1];
    
   Phi = real(Phi); % fixes code so it doesn't crash with complex values

   A = [-b1*xhat(k-1,1)^(h_11-1), 0, xhat(k-1,5)*xhat(k-1,3)^(g_13-1), 0, 0, 0, 0, 0;
    xhat(k-1,6)*xhat(k-1,1)^(g_21-1),-b2*xhat(k-1,2)^(h_22-1),0,0,0,0,0,0;
    0,xhat(k-1,7)*xhat(k-1,2)^(g_32-1),-b3*xhat(k-1,3)^(h_33-1)*xhat(k-1,4)^(h_34),0,0,0,0,0;
    0,0,0,-b4*xhat(k-1,4)^(h_44-1),0,0,0,xhat(k-1,1)^g_41;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0];

    A = real(A);

    x1 = expm(A) * transpose(xhat(k-1,:));
   
    H = [-b1*h_11*x1(1)^(h_11-1), 0, g_13*x1(5)*x1(3)^(g_13 - 1), 0, x1(3)^(g_13), 0, 0, 0;
       g_21*x1(6)*x1(1)^(g_21-1), h_22*-b2*x1(2)^(h_22-1), 0, 0, 0, x1(1)^g_21, 0, 0;
       0, g_32*x1(7)*x1(2)^(g_32-1), -b3*x1(4)^h_34*h_33*x1(3)^(h_33-1), -b3*x1(3)^(h_33)*h_34*x1(4)^(h_34-1), 0, 0, x1(2)^g_32, 0;
       g_41*x1(8)*x1(1)^(g_41-1), 0, 0, -b4*h_44*x1(4)^(h_44-1), 0, 0, 0, x1(1)^g_41];
    
    H = real(H);
    H = H(1:num_states,:);
   
    P1 = Phi*P*transpose(Phi)+Q; 
    P1 = real(P1);
    S = H*P1*transpose(H)+R;
    K = P1*transpose(H)/S;
    P = (1-K*H)*P1;
    
    xhat(k,:) = transpose(x1+K*(transpose(ymeas(k,:))-x1(1:num_states)));

end
end


