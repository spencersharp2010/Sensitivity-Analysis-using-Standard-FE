function optimization(optAnalysis,optFiniteDifference,optParam, dispOpt,stressOpt,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest)

%reorganization of the parameters needed for the analysis
sensAnalysisType=optAnalysis.Type;
finiteDifference=optFiniteDifference;
if strcmp(optAnalysis.Objective,'displacement')
    dispSens.status=1;
    dispSens.nodes=dispOpt.node;
else
    dispSens.status=0;
end

if strcmp(optAnalysis.Objective,'strain_energy')
    eneSens.status=1;
else
    eneSens.status=0;
end

if strcmp(optAnalysis.Objective,'von_Mises_stress')
    vonMisesSens.status=1;
    vonMisesSens.elements=stressOpt.element;
else
    vonMisesSens.status=0;
end

%generating new mesh which gets new nodal coordinates in each iteration
strMshnew=strMsh;

%computation of the solution for the initial configuration
[dHat_init,~,~] = solve_FEMPlateInMembraneAction...
    (analysis,strMshnew,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
    parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
    propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
    isUnitTest,'outputDisabled');

%computation of initial values for comparison and evaluation of
%optimization direction
d_init=dHat_init((dispOpt.node-1)*2+dispOpt.direction)
energy_init=strEne(strMsh,analysis,parameters,dHat_init)

%change of sign og optParam.factor in case considered displacement is positive at
%the moment
if dispSens.status && d_init>0
    optParam.factor=-optParam.factor;
end


%loop for optimization process
for i=1:optParam.iterations
    
    %computation of senitivities for the considered objective function
    [displacement_sensitivity,strain_energy_sensitivity,~]=sensitivity_main(sensAnalysisType,finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMshnew,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest);
    
    %update of the nodal coordinates in case the objective function is strain energy 
    if eneSens.status
        strMshnew.nodes(:,1)=strMshnew.nodes(:,1)-strain_energy_sensitivity(:,1)*finiteDifference.perturbation*optParam.factor;
        strMshnew.nodes(:,2)=strMshnew.nodes(:,2)-strain_energy_sensitivity(:,2)*finiteDifference.perturbation*optParam.factor;
    end
    
    %update of the nodal coordinates in case the objective function is strain energy 
    if dispSens.status
        
        disp_sens_1(:,1)=displacement_sensitivity(dispOpt.direction,1,:,1);
        disp_sens_2(:,1)=displacement_sensitivity(dispOpt.direction,2,:,1);
        
        strMshnew.nodes(:,1)=strMshnew.nodes(:,1)+disp_sens_1.*finiteDifference.perturbation*optParam.factor;
        strMshnew.nodes(:,2)=strMshnew.nodes(:,2)+disp_sens_2.*finiteDifference.perturbation*optParam.factor;
        
    end
    
    %bring the nodal coordinates of the constrained DOFs back to original
    %fixed position
    strMshnew.nodes(optAnalysis.fixX,1)=strMsh.nodes(optAnalysis.fixX,1);
    strMshnew.nodes(optAnalysis.fixY,2)=strMsh.nodes(optAnalysis.fixY,2);

end

%computation of solution for final configuration
caseName=strcat(caseName,'_Optimized_Analysis');
[dHat,~,~] = solve_FEMPlateInMembraneAction...
    (analysis,strMshnew,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
    parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
    propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
    isUnitTest,'outputDisabled');

%final values of objective functions for comparison
d_end=dHat((dispOpt.node-1)*2+dispOpt.direction)
energy_end=strEne(strMshnew,analysis,parameters,dHat)

intLoad.type = 'default';
intDomain.type = 'default';
intLoad.noGP = 1;
intDomain.noGP = 1;
graph.index = 1;

%Compute the load vector
t = 0;
F = computeLoadVctFEMPlateInMembraneAction(strMshnew,analysis,NBC,t,intLoad,'outputDisabled');

%Visualization of the final configuration
graph.index = plot_referenceConfigurationFEMPlateInMembraneAction...
    (strMshnew,analysis,F,homDBC,graph,'outputDisabled');
end

    
    
    