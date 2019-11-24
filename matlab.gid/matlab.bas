%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _______________________________________________________               %
%   _______________________________________________________               %
%                                                                         %
%   Technische Universität München                                        %
%   Lehrstuhl für Statik, Prof. Dr.-Ing. Kai-Uwe Bletzinger               %
%   _______________________________________________________               %
%   _______________________________________________________               %
%                                                                         %
%                                                                         %
%   Authors                                                               %
%   _______________________________________________________________       %
%                                                                         %
%   Dipl.-Math. Andreas Apostolatos    (andreas.apostolatos@tum.de)       %
%   MSc.-Ing. Aditya Ghantasala        (aditya.ghantasala@tum.de)         %
%   Dr.-Ing. Roland Wüchner            (wuechner@tum.de)                  %
%   Prof. Dr.-Ing. Kai-Uwe Bletzinger  (kub@tum.de)                       %
%   _______________________________________________________________       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   Matlab Input File                                                     %
%   _________________                                                     %
%                                                                         %
%   FiniteElementAnalysisProgramStructuralAnalysisInstituteTUM            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   Structural Boundary Value Problem                                     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

STRUCTURE_ANALYSIS
 ANALYSIS_TYPE,*GenData(STR_ANA-TYPE)

STRUCTURE_MATERIAL_PROPERTIES
*Loop materials
*if(strcmp(MatProp(0),"Structure")==0)
  DENSITY,*MatProp(Density)
  YOUNGS_MODULUS,*MatProp(Young_Modulus)
  POISSON_RATIO,*MatProp(Poisson_Ratio)
*endif
*end loop

STRUCTURE_NLINEAR_SCHEME
 NLINEAR_SCHEME,*GenData(STR_NL_SOLVER-TYPE)

STRUCTURE_TRANSIENT_ANALYSIS
 SOLVER *GenData(STR_TIME_ANA-TYPE)
 TIME_INTEGRATION *GenData(STR_TIME_INTEGRATION-SCHEME)
 START_TIME *GenData(STR_START_TIME)
 END_TIME *GenData(STR_END_TIME)
 NUMBER_OF_TIME_STEPS *GenData(STR_NUMBER_OF_TIME_STEPS)

STRUCTURE_INTEGRATION
 DOMAIN *GenData(DOMAIN)
 domainNoGP *GenData(domainNoGP)
 boundaryNoGP *GenData(boundaryNoGP)

SENSITIVITY_ANALYSIS
 ANALYSIS_TYPE *GenData(TYPE_OF_SENSITIVITY_ANALYSIS)
 STRAIN_ENERGY_STATUS *GenData(strain_energy)
 DISPLACEMENT_STATUS *GenData(displacement)
 VMISES_STATUS *GenData(von_Mises_stress)
 FINITE_DIFFERENCING_METHOD *GenData(FINITE_DIFFERENCING_METHOD)
 PERTURBATION *GenData(PERTURBATION)

STRUCTURAL_OPTIMIZATION
 ANALYSIS_TYPE *GenData(TYPE_OF_SENSITIVITY_ANALYSIS_OPTIMIZATION)
 OBJECTIVE_FUNCTION *GenData(OBJECTIVE_FUNCTION)
 DIRECTION_DISPLACEMENT_OPTIMIZATION *GenData(DIRECTION_OF_DISPLACEMENT_OPTIMIZATION)
 FINITE_DIFFERENCING_METHOD *GenData(FINITE_DIFFERENCING_METHOD_OPTIMIZATION)
 PERTURBATION *GenData(PERTURBATION_OPTIMIZATION)
 ITERATIONS *GenData(ITERATIONS_OF_OPTIMIZATION)
 FACTOR_OF_CHANGE *GenData(FACTOR_OF_CHANGE)

NODES_FOR_DISPLACEMENT_SENSITIVITY*\
*set Cond Structure_Nodes_for_Displacement_Sensitivity *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *\
*end loop

ELEMENTS_FOR_VON_MISES_STRESS_SENSITIVITY*\
*set Cond Structure_Elements_for_von_Mises_Stress_Sensitivity *elems
*loop elems OnlyInCond
*format "%8i%6i%6i%8i%8i%8i%8i%8i%8i%8i%8i"

*ElemsNum *ElemsConec*\
*end loop

CONSTRAINTS_SHAPE_OPTIMIZATION*\
*set Cond Displacement_Constraints_for_Shape_Optimization *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *\
*if(cond(X-Constraint,int)==1)
*cond(1)  *\
*else
0  *\
*endif
*if(cond(Y-Constraint,int)==1)
*cond(1)  *\
*else
0  *\
*endif
*if(cond(Z-Constraint,int)==1)
*cond(1)  *\
*else
0 *\
*endif
*end loop

STRUCTURE_NODES*\
*set Cond Structure-Nodes *nodes
*loop nodes OnlyInCond
*format "%8i%10.5f%10.5f%10.5f"

*NodesNum *NodesCoord(1,real) *NodesCoord(2,real) *NodesCoord(3,real) *\
*end loop

STRUCTURE_ELEMENTS*\
*set Cond Structure-Elements *elems
*loop elems OnlyInCond
*format "%8i%6i%6i%8i%8i%8i%8i%8i%8i%8i%8i"

*ElemsNum *ElemsConec*\
*end loop

STRUCTURE_DIRICHLET_NODES*\
*set Cond Structure-Dirichlet *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *\
*if(cond(X-Constraint,int)==1)
*cond(X-Value)  *\
*else
NaN  *\
*endif
*if(cond(Y-Constraint,int)==1)
*cond(Y-Value)  *\
*else
NaN  *\
*endif
*if(cond(Z-Constraint,int)==1)
*cond(Z-Value)  *\
*else
NaN  *\
*endif
*end loop

STRUCTURE_FORCE_NODES*\
*set Cond Structure-Force *nodes
*loop nodes OnlyInCond
*format "%8i"

*if(strcmp(cond(ForceType),"boundaryLoad")==0)
*NodesNum *cond(ForceType) *cond(FunctionHandleToForceComputation)*\
*endif
*end loop
*set Cond Structure-Point-Force *nodes
*loop nodes OnlyInCond
*format "%8i"

*if(strcmp(cond(ForceType),"pointLoad")==0)
*NodesNum *cond(ForceType) *cond(FunctionHandleToForceComputation)*\
*endif
*end loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   Fluid Boundary Value Problem                                          %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FLUID_ANALYSIS
 ANALYSIS_TYPE,*GenData(STR_ANA-TYPE)

FLUID_MATERIAL_PROPERTIES
*Loop materials
*if(strcmp(MatProp(0),"Fluid")==0)
  DENSITY,*MatProp(Density)
  DYNAMIC_VISCOSITY,*MatProp(Dynamic_Viscosity)
*endif
*end loop

FLUID_NLINEAR_SCHEME
 NLINEAR_SCHEME,*GenData(CFD_NL_SOLVER-TYPE)
 TOLERANCE,*GenData(CFD_TOL)
 MAX_ITERATIONS,*GenData(CFD_MAX_IT)

FLUID_TRANSIENT_ANALYSIS
 SOLVER *GenData(CFD_TIME_ANA-TYPE)
 TIME_INTEGRATION *GenData(CFD_TIME_INTEGRATION-SCHEME)
 START_TIME *GenData(CFD_START_TIME)
 END_TIME *GenData(CFD_END_TIME)
 NUMBER_OF_TIME_STEPS *GenData(CFD_NUMBER_OF_TIME_STEPS)
	
FLUID_ELEMENTS
*set Cond Fluid-Elements-Over-Surfaces *elems
*loop elems OnlyInCond
*format "%8i%6i%6i%8i%8i%8i%8i%8i%8i%8i%8i"
*ElemsNum *ElemsConec
*end loop

*set Cond Fluid-Elements-Over-Volumes *elems
*loop elems OnlyInCond
*format "%8i%6i%6i%8i%8i%8i%8i%8i%8i%8i%8i"
*ElemsNum *ElemsConec
*end loop

FLUID_DIRICHLET_NODES*\
*set Cond Fluid-Dirichlet-Over-Lines *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *\
*if(cond(X-Constraint,int)==1)
*cond(X-Value)  *\
*else
NaN  *\
*endif
*if(cond(Y-Constraint,int)==1)
*cond(Y-Value)  *\
*else
NaN  *\
*endif
*if(cond(Z-Constraint,int)==1)
*cond(Z-Value)  *\
*else
NaN  *\
*endif
*if(cond(P-Constraint,int)==1)
*cond(P-Value)  *\
*else
NaN  *\
*endif
*end loop

*set Cond Fluid-Dirichlet-Over-Surfaces *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *\
*if(cond(X-Constraint,int)==1)
*cond(X-Value)  *\
*else
NaN  *\
*endif
*if(cond(Y-Constraint,int)==1)
*cond(Y-Value)  *\
*else
NaN  *\
*endif
*if(cond(Z-Constraint,int)==1)
*cond(Z-Value)  *\
*else
NaN  *\
*endif
*if(cond(P-Constraint,int)==1)
*cond(P-Value)  *\
*else
NaN  *\
*endif
*end loop

FLUID_DIRICHLET_ALE_NODES*\
*set Cond Fluid-Dirichlet-ALE *nodes
*loop nodes OnlyInCond
*format "%8i"

*NodesNum *cond(FunctionHandleToALEMotion)*\
*end loop

FLUID_NODES
*set Cond Fluid-Nodes-Over-Surfaces *nodes
*loop nodes OnlyInCond
*format "%8i%10.5f%10.5f%10.5f"

*NodesNum *NodesCoord(1,real) *NodesCoord(2,real) *NodesCoord(3,real) *\
*end loop

*set Cond Fluid-Nodes-Over-Volumes *nodes
*loop nodes OnlyInCond
*format "%8i%10.5f%10.5f%10.5f"

*NodesNum *NodesCoord(1,real) *NodesCoord(2,real) *NodesCoord(3,real) *\
*end loop
