function [disp_sens, ene_sens,stress_sens]=global_sensitivity_central(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest)

%calculates the displacement sensitivity,strain energy sensitivity and von Mises stress sensitivity by
%central finite differencing in one go

%initiation of outputs for the case they aren't actually requested
disp_sens=[];
ene_sens=[];
stress_sens=[];

%initiation of new meshes whose nodal coordinates get renewed in every step
new_mesh_forward = strMsh;
new_mesh_backward = strMsh;

%number of nodes in the mesh
noNodes=length(strMsh.nodes);

%check if diplacement sensitivity is needed
if dispSens.status
%number of nodes for which the displacement sensitivity has to be evaluated
n_disp_sens=length(dispSens.nodes);

%initiation of the different arrays needed
%for displacement sensitivity
disp_forward = zeros(2,2,noNodes,n_disp_sens);
disp_backward = zeros(2,2,noNodes,n_disp_sens);
disp_sens = zeros(2,2,noNodes,n_disp_sens);
end


%check if strain energy sensitivity is needed
if eneSens.status
%initiation of the different arrays needed
%for strain energy sensitivity
strain_energies_forward = zeros(noNodes,2);
strain_energies_backward = zeros(noNodes,2);
ene_sens = zeros(noNodes,2);
end



%check if von Mises stress sensitivity is needed
if vonMisesSens.status
%number of elements for which the von Mises stress sensitivity has to be evaluated
n_Mises_sens=length(vonMisesSens.elements);

%initiation of the different arrays needed
%for von Mises stress sensitivity
stresses_forward = zeros(noNodes,2,n_Mises_sens);
stresses_backward = zeros(noNodes,2,n_Mises_sens);
stress_sens = zeros(noNodes,2,n_Mises_sens);
end




%perturbations in x-direction
for i=1:noNodes
    
    %setting up the forward mesh for the current perturbation
    new_mesh_forward.nodes = strMsh.nodes;
    new_mesh_forward.nodes(i,1)= new_mesh_forward.nodes(i,1)+finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp_forward,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh_forward,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    %setting up the backward mesh for the current perturbation
    new_mesh_backward.nodes = strMsh.nodes;
    new_mesh_backward.nodes(i,1)= new_mesh_backward.nodes(i,1)-finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp_backward,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh_backward,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    if dispSens.status
    %calculation of the displacement sensitivities for the
    %different requested nodes
    for j=1:n_disp_sens
        
        %important displacements of current configurations
        disp_forward(:,1,i,j)=dHat_temp_forward(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        disp_backward(:,1,i,j)=dHat_temp_backward(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        
        
        %sensitivity as the finite difference of the
        %final system results
        disp_sens(:,1,i,j)= central_finite_difference(disp_forward(:,1,i,j),disp_backward(:,1,i,j),finiteDifference.perturbation);
        
    end
    end
    
    
    if eneSens.status
    %calculation of the strain energy in current configurations
    strain_energies_forward(i,1)=strEne(new_mesh_forward,analysis,parameters,dHat_temp_forward);
    strain_energies_backward(i,1)=strEne(new_mesh_backward,analysis,parameters,dHat_temp_backward);
    
    %sensitivity as the finite difference of the final
    %strain energy results
    ene_sens(i,1)= central_finite_difference(strain_energies_forward(i,1), strain_energies_backward(i,1),finiteDifference.perturbation);
    end
    
    
    if vonMisesSens.status
    %calculation of the von Mises stresses for the different elements in
    %current configuration
    stresses_forward(i,1,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp_forward,vonMisesSens.elements);
    s_temp_forward(1,:)=stresses_forward(i,1,:);
    stresses_backward(i,1,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp_backward,vonMisesSens.elements);
    s_temp_backward(1,:)=stresses_backward(i,1,:);
    
    %sensitivity as the finite difference of the final
    %von Mises stress results
    stress_sens(i,1,:)= central_finite_difference(s_temp_forward(1,:),s_temp_backward(1,:),finiteDifference.perturbation);
    end
     
end

%perturbations in y-direction
for i=1:noNodes
    
    %setting up the forward mesh for the current perturbation
    new_mesh_forward.nodes = strMsh.nodes;
    new_mesh_forward.nodes(i,2)= new_mesh_forward.nodes(i,2)+finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp_forward,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh_forward,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    %setting up the backward mesh for the current perturbation
    new_mesh_backward.nodes = strMsh.nodes;
    new_mesh_backward.nodes(i,2)= new_mesh_backward.nodes(i,2)-finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp_backward,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh_backward,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    if dispSens.status
    %calculation of the displacement sensitivities for the
    %different requested nodes
    for j=1:n_disp_sens
        
        %important displacements of current configurations
        disp_forward(:,2,i,j)=dHat_temp_forward(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        disp_backward(:,2,i,j)=dHat_temp_backward(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        
        
        %sensitivity as the finite difference of the
        %final system results
        disp_sens(:,2,i,j)= central_finite_difference(disp_forward(:,2,i,j),disp_backward(:,2,i,j),finiteDifference.perturbation);
        
    end
    end
    
    
    if eneSens.status
    %calculation of the strain energy in current configurations
    strain_energies_forward(i,2)=strEne(new_mesh_forward,analysis,parameters,dHat_temp_forward);
    strain_energies_backward(i,2)=strEne(new_mesh_backward,analysis,parameters,dHat_temp_backward);
    
    %sensitivity as the finite difference of the final
    %strain energy results
    ene_sens(i,2)= central_finite_difference(strain_energies_forward(i,2), strain_energies_backward(i,2),finiteDifference.perturbation);
    end
    
    
    if vonMisesSens.status
    %calculation of the von Mises stresses for the different elements in
    %current configuration
    stresses_forward(i,2,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp_forward,vonMisesSens.elements);
    s_temp_forward(1,:)=stresses_forward(i,2,:);
    stresses_backward(i,2,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp_backward,vonMisesSens.elements);
    s_temp_backward(1,:)=stresses_backward(i,2,:);
    
    %sensitivity as the finite difference of the final
    %von Mises stress results
    stress_sens(i,2,:)= central_finite_difference(s_temp_forward(1,:),s_temp_backward(1,:),finiteDifference.perturbation);
    end
     
end
end