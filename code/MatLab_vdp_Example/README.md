## UKF for the Van der Pol oscillator

This [example from Matlab](https://www.mathworks.com/help/control/ug/nonlinear-state-estimation-using-unscented-kalman-filter.html)
applies the UKF on the Van der Pol oscillator. Below is an outline of the files used in this example

```
vdp_UKF.m
```
**This is the main function** that calls the other subfunctions to implement the UKF. 
Currently, the UKF runs for 100 iterations and graphs the results of both states as well as the residuals.
```
vdp1.m
```
This file describes the VDP system (through its ODEs) and aids in generating a prediction (think of this as the f function)
```
vdpMeasurementNonAdditiveNoiseFcn.m
```
This file simulates data with multiplicative noise
```
vdpStateFcn.m
```
This file uses Euler's method to discretize the system with a time step of 0.05 seconds.

## Acknowledgements

All of this code is from Matlab's documentation of a UKF example.
