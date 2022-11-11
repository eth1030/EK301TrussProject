# EK301TrussProject
Model Based On:

[F22_project_manual_Part2_PreliminaryDesign.pdf](https://github.com/eth1030/EK301TrussProject/files/9974904/F22_project_manual_Part2_PreliminaryDesign.pdf)


How To Run Model:
1) Clone repo
2) Open `trussProject_snorlax_EK301.m` in Matlab
3) Load any of the .mat files to input the variables
4) Run `trussProject_snorlax_EK301.m`
5) Results will output in the command window




How To Create new Input Variable File:
1) Open `truss_variable_creator.m`
2) Change the variables as need be
3) Then, in the command window, input
```
save('file_name.mat', 'C', 'L', 'Sx', 'Sy', 'X', 'Y')
```
4) The variables will be saved in `file_name.mat`

## Navigation
`/Design Inputs`: directory including all of our truss inputs represented as variables to run with MATLAB scripts `trussProject_snorlax_EK301.m` and `maxload.m` 

`designs.txt`: results of whether a truss design is valid or not based on designs from `/Design Inputs` directory

`trussProject_snorlax_EK301.m`: calculates the internal forces of each member of the truss and reaction forces

`maxload.m`: determines the max load the truss design can handle

---
Check the wiki for additional information.
