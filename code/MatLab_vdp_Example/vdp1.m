function dydt = vdp1(t,y)
% Code originally from Matlab 
% This function represents the VDP oscillator system and is used to
% generate a prediction, think of it as the f function

%VDP1  Evaluate the van der Pol ODEs for mu = 1
%
%   See also ODE113, ODE23, ODE45.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

dydt = [y(2); 
        (1-y(1)^2)*y(2)-y(1)];