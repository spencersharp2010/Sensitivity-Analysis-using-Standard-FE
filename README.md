# Sensitivity Analysis using Standard Finite Elements
This program was developed in collaboration with three classmates. In summary, it computes a sensitivity analysis of a user-defined geometry, loading, and boundary conditions, using nodal displacement as an input. 

The user can choose from three different objective functions:
* strain energy
* displacement
* von Mises stress

Three different types of sensitivity analyses were implemented for each objective function:
* global
* semi-analytical (adjoint)
* analytical

Finally, a rudimentary optimization algorithm was implemented. It utilizes the results of the sensitivity analysis to perform a shape optimization of the given geometry.

In general the workflow looks as follows:
Define inputs in updated **GiD** interface → Perform calculations in **MATLAB** → Visualize `.vtk` files in **ParaView**
