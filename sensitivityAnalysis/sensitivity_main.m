function [displacement_sensitivity,strain_energy_sensitivity,von_mises_stress_sensitivity]=sensitivity_main(sensAnalysisType,finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest)

%create new caseName which gets overwritten in each calculation step
caseName=strcat(caseName,'_CalculationHelp');

%selection of the analysis type
if strcmp(sensAnalysisType,'global')
    [displacement_sensitivity, strain_energy_sensitivity,von_mises_stress_sensitivity]=global_sensitivity_main(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest);
elseif strcmp(sensAnalysisType,'numerical_adjoint')
    [displacement_sensitivity, strain_energy_sensitivity]=numerical_adjoint_sensitivity_main(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain);
    von_mises_stress_sensitivity=[];
elseif strcmp(sensAnalysisType,'analytical_adjoint')
    [displacement_sensitivity, strain_energy_sensitivity]=analytical_adjoint_sensitivity(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain);
    von_mises_stress_sensitivity=[];
end

end