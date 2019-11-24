function [displacement_sensitivity, strain_energy_sensitivity,von_mises_stress_sensitivity]=global_sensitivity_main(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest)

%differentiation between the different finite differencing methods
if strcmp(finiteDifference.method,'forward')
    [displacement_sensitivity, strain_energy_sensitivity,von_mises_stress_sensitivity]=global_sensitivity_forward(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest);
    
elseif strcmp(finiteDifference.method,'backward')
    [displacement_sensitivity, strain_energy_sensitivity,von_mises_stress_sensitivity]=global_sensitivity_backward(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest);
    
elseif strcmp(finiteDifference.method,'central')
    [displacement_sensitivity, strain_energy_sensitivity,von_mises_stress_sensitivity]=global_sensitivity_central(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest);
    
end
end