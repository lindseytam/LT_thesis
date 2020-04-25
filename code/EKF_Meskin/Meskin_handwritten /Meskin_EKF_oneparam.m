%{
% input values 
Q = .2
R = .1;
m0= [4;1;3;4;20]; % for parameter estimation
P0=1; 
%}    
function [xhat] = Meskin_EKF_oneparam(Q,R,m0,P0,num_states)

% yMeas: incoming system measurements from Meskin_true
% Q: Process noise covariance
% R: Measurement noise covariance
% m0: initial state
% P0: intial state covariance

yMeas = readtable('Meskin_meas.csv'); 
yMeas = yMeas{:,:};
ymeas = yMeas(:, 1:num_states);

[n,m] = size(ymeas); 
[l,k] = size(m0); 

P = zeros(l,l); 
xhat = zeros(n,l);

% true parameter values
true_params;

Phi = [-b1*h_11*m0(1)^(h_11-1), 0, g_13*m0(5)*m0(3)^(g_13-1), 0, m0(3)^(g_13);
       g_21*a_2*m0(1)^(g_21-1), h_22*-b2*m0(2)^(h_22-1), 0, 0, 0;
       0, g_32*a_3*m0(2)^(g_32-1), -b3*m0(4)^(h_34)*h_33*m0(3)^(h_33-1), -b3*m0(3)^(h_33)*h_34*m0(4)^(h_34-1), 0;
       g_41*a_4*m0(1)^(g_41-1), 0, 0, -b4*h_44*m0(4)^(h_44-1), 0;
       0,0,0,0,1];
   
A = [-b1*m0(1)^(h_11-1), 0, m0(5)*m0(3)^(g_13-1), 0, 0;
    a_2*m0(1)^(g_21-1),-b2*m0(2)^(h_22-1),0,0, 0;
    0,a_3*m0(2)^(g_32-1),-b3*m0(3)^(h_33-1)*m0(4)^(h_34),0, 0;
    a_4*m0(1)^(g_41-1),0,0,-b4*m0(4)^(h_44-1), 0;
    0,0,0,0,0];
A = real(A);
x1 = expm(A) * m0; % prediction step

%{
x1 =[a_1*m0(3)^(g_13)-b1*m0(1)^(h_11);
      a_2*m0(1)^(g_21)-b2*m0(2)^(h_22);
      a_3*m0(2)^(g_32)-b3*m0(3)^(h_33)*m0(4)^(h_34);
      a_4*m0(1)^(g_41)-b4*m0(4)^(h_44)];
%}
x1=real(x1);

H = [-b1*h_11*x1(1)^(h_11-1), 0, g_13*x1(5)*x1(3)^(g_13 - 1), 0,x1(3)^(g_13);
     g_21*a_2*x1(1)^(g_21-1), h_22*-b2*x1(2)^(h_22-1), 0, 0,0;
     0, g_32*a_3*x1(2)^(g_32-1), -b3*x1(4)^(h_34)*h_33*x1(3)^(h_33-1), -b3*x1(3)^(h_33)*h_34*x1(4)^(h_34-1),0;
     g_41*a_4*x1(1)^(g_41-1), 0, 0, -b4*h_44*x1(4)^(h_44-1),0];
 
H=H(1:num_states,:);
H = real(H);
    
P1 = Phi*P0*transpose(Phi)+Q; 
P1 = real(P1);
S = H*P1*transpose(H)+R;
K = P1*transpose(H)/S;
P = (1-K*H)*P1;
h = a_1*x1(3)^(g_13)-b1*x1(1)^(h_11);
h=real(h);
% xhat(1,:) = transpose(x1+K*(transpose(ymeas(1))-h)); 
xhat(1,:) = transpose(x1+K*(transpose(ymeas(1,:))-x1(1:num_states,:))); 

for k=2:n

    Phi = [-b1*h_11*xhat(k-1,1)^(h_11-1), 0, g_13*xhat(k-1,5)*xhat(k-1,3)^(g_13-1), 0, xhat(k-1,3)^(g_13);
       g_21*a_2*xhat(k-1,1)^(g_21-1), h_22*-b2*xhat(k-1,2)^(h_22-1), 0, 0, 0;
       0, g_32*a_3*xhat(k-1,2)^(g_32-1), -b3*xhat(k-1,4)^(h_34)*h_33*xhat(k-1,3)^(h_33-1), -b3*xhat(k-1,3)^(h_33)*h_34*xhat(k-1,4)^(h_34-1), 0;
       g_41*a_4*xhat(k-1,1)^(g_41-1), 0, 0, -b4*h_44*xhat(k-1,4)^(h_44-1), 0;
       0,0,0,0,1];
    
    Phi = real(Phi);

    A = [-b1*xhat(k-1,1)^(h_11-1), 0, xhat(k-1,5)*xhat(k-1,3)^(g_13-1), 0,0;
        a_2*xhat(k-1,1)^(g_21-1),-b2*xhat(k-1,2)^(h_22-1),0,0,0;
        0,a_3*xhat(k-1,2)^(g_32-1),-b3*xhat(k-1,3)^(h_33-1)*xhat(k-1,4)^(h_34),0,0;
        a_4*xhat(k-1,1)^(g_41-1),0,0,a_3*-b4*xhat(k-1,4)^(h_44-1),0;
        0,0,0,0,0];

    A = real(A);

    x1 = expm(A) * transpose(xhat(k-1,:));
% 	x1=real(x1)
    %{
    x1 = [a_1*xhat(k-1,3)^g_13-b1*xhat(k-1,1)^h_11;
          a_2*xhat(k-1,1)^g_21-b2*xhat(k-1,2)^h_22;
          a_3*xhat(k-1,2)^g_32-b3*xhat(k-1,3)^h_33*xhat(k-1,4)^h_34;
          a_4*xhat(k-1,1)^g_41-b4*xhat(k-1,4)^h_44];
    %}
     x1 = real(x1);
   
     H = [-b1*h_11*x1(1)^(h_11-1), 0, g_13*x1(5)*x1(3)^(g_13 - 1), 0,x1(3)^(g_13);
     g_21*a_2*x1(1)^(g_21-1), h_22*-b2*x1(2)^(h_22-1), 0,0, 0;
     0, g_32*a_3*x1(2)^(g_32-1), -b3*x1(4)^(h_34)*h_33*x1(3)^(h_33-1), -b3*x1(3)^(h_33)*h_34*x1(4)^(h_34-1),0;
     g_41*a_4*x1(1)^(g_41-1), 0, 0, -b4*h_44*x1(4)^(h_44-1),0];
 
    H=H(1:num_states,:);
    H = real(H);
    
    P1 = Phi*P*transpose(Phi)+Q; 
    P1 = real(P1);
    S = H*P1*transpose(H)+R;
    K = P1*transpose(H)/S;
    P = (1-K*H)*P1;

    h = a_1*x1(3)^(g_13)-b1*x1(1)^(h_11);
    h = real(h);
  
%     xhat(k,:) = transpose(x1+K*(transpose(ymeas(k))- h));
    xhat(k,:) = transpose(x1+K*(transpose(ymeas(k,:))- x1(1:num_states,:)));

end
end


