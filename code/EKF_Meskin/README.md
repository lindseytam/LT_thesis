# Implementing Meskin using the EKF

This example implements the system in a paper written by [Meskin](https://drive.google.com/file/d/1PYTPskAWuQ-HrS7cBfBXQ_-OeJp-do8H/view?usp=sharing) 
that models the pathway of the body's metabolites. There are currently 3 items in this directory. 
```
1. Meskin_true.m
```
This Matlab file is used to generate simulated data, which are used in both `Meskin_Matlab` and `Meskin_handwritten`. 
The data is created by taking the true values of the system (as given by putting the system through an ODE solver) and adding noise.
The level is noise is normally distributed with a mean of 0 and a variance of R (which can be adjusted).
The simulated data is saved as a csv file; in both `Meskin_Matlab` and `Meskin_handwritten`, the csv data files 
are generated with this function


```
2. Meskin_Matlab
```
This folder implements the example using Matlab's built-in EKF. There is more documentation availble in the folder.

```
3. Meskin_handwritten
```
This folder implements the example using handwritten EKF Matlab code. 
Currently, this code needs to be updated because it attempts to discretize the system using matrix exponentials. 
However, this is an incorrect approach because this system is nonlinear and cannot be discretized using the matrix exponential.
A better way to correct this example would be to discretize the system using Euler's method (as is done in the `Meskin_Matlab` examples).

### Possible Errors / Warnings
There are a few errors that have reoccured in the code. Below are a few of the obstacles encountered and how they were fixed:
```diff
- Warning: Imaginary parts of complex X and/or Y arguements ignored
```
This warning will still allow your code to run. One possible solution to this problem is to reduce measurement noise (R) values.

```diff
- Unable to perform assignment because the size of the left side is X-by-X and the size of the right side is X-by-X.
```
This is a simple error where the dimenions of the matrixes are incorrect.
One may encounter this when they are moving in between files. A solution is to use the command
`clear all` to remove the stored Matlab values. If this problem persists, it could be an issue in the code itself. 
Try looking for the comments `%CHANGE THIS` to see if there is a value that needs to be adjusted.
