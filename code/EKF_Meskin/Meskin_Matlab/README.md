## Folders in this directory
There are 3 folders in this directory: `states`, `one param`, and `four param`. Each of these foldeers implements the EKF as applied to the system described by [Meskin](https://drive.google.com/file/d/1PYTPskAWuQ-HrS7cBfBXQ_-OeJp-do8H/view?usp=sharing).
Below is a brief description of each folder:
* The `states` folder contains EKF code for doing state estimation. Within the code itself, 
you can change how many/which states are being measured. There are comments within the code
that describes how to do this.
* The `one param` folder implements the EKF for parameter estimation for all four states and one parameter (a_1). 
Joint parameter estimation techniques are used and this code assumes that all states and parameters are measurable.
* The `four param` folder implements the EKF for all four states and four parameters (a_1,...,a_4). 
Joint parameter estimation techniques are used and this code assumes that all states and parameters are measurable.

### What is inside each folder

There are a number of files in each folder in addition to a main file that calls all of the files. 
Below is a general description of what you can expect to find in each.   

* `Meskin_true_XXX.csv` is the csv file generated from `Mekin_true.m` that contains the true values for all states of the system.  

* `Meskin_meas_XXX.csv` is the csv file generated from `Mekin_true.m` that contains measurements for all states of the system. 
If you only want to have measurements for certain states, you can change the code (NOT this file) to only take in the columns that represent the state that is measurable.    

* `Meskin_ODE_XX.m` is a file containing the ODE of the system, think about this file as the f function.  

* `MeskinMeasurementFcnX.m` determines which states are measurable, think of this as the h function. 

* `MeskinStateFcnX.m` is how the code uses the Euler method to discretize the system. 

* `parameter_values.m` contains all of the true parameter values of the system.    

* `EKF_XXX` **is the main function that calls these subfunction to implement the EKF**. To run the example, open and run this file 
to generate results

Within each of these files is also code that describes what is happening. Comments starting with `%CHANGE THIS` indicate that 
the code can be adjusted if so desired.

### Acknowledgements
The method of implementing the UKF was adapted from [Matlab's example of implementing the Van der Pol oscillator](https://www.mathworks.com/help/control/ug/nonlinear-state-estimation-using-unscented-kalman-filter.html)
