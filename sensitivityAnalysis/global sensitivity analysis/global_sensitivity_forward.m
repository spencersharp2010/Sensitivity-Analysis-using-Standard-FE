function [disp_sens, ene_sens,stress_sens]=global_sensitivity_forward(finiteDifference,eneSens,dispSens,vonMisesSens,analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,parameters,computeStiffMtxLoadVct,solve_LinearSystem,propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,isUnitTest)

%calculates the displacement sensitivity,strain energy sensitivity and von Mises stress sensitivity by
%global forward finite differencing in one go

%initiation of outputs for the case they aren't actually requested
disp_sens=[];
ene_sens=[];
stress_sens=[];

%initiation of new mesh whose nodal coordinates gets renewed in every step
new_mesh = strMsh;

%number of nodes in the mesh
noNodes=length(strMsh.nodes);

%calculation of the displacements of the initial configuration
[dHat_init,~,~] = solve_FEMPlateInMembraneAction...
    (analysis,strMsh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
    parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
    propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
    isUnitTest,'outputDisabled');


%check if diplacement sensitivity is needed
if dispSens.status
%number of nodes for which the displacement sensitivity has to be evaluated
n_disp_sens=length(dispSens.nodes);

%storage of initial displacements
initial_displacements=zeros(n_disp_sens,2);
for i=1:n_disp_sens
    initial_displacements(i,:)= dHat_init(2*dispSens.nodes(i)-1:2*dispSens.nodes(i));
end

%initiation of the different arrays needed
%for displacement sensitivity
disp = zeros(2,2,noNodes,n_disp_sens);
disp_sens = zeros(2,2,noNodes,n_disp_sens);
end


%check if strain energy sensitivity is needed
if eneSens.status
%calculation of the initial strain energy
initial_strain_energy = strEne(strMsh,analysis,parameters,dHat_init);

%initiation of the different arrays needed
%for strain energy sensitivity
strain_energies = zeros(noNodes,2);
ene_sens = zeros(noNodes,2);
end



%check if von Mises stress sensitivity is needed
if vonMisesSens.status
%number of elements for which the von Mises stress sensitivity has to be evaluated
n_Mises_sens=length(vonMisesSens.elements);

%storage of initial von Mises stresses
initial_stresses=vonMisesStress(strMsh,analysis,parameters,dHat_init,vonMisesSens.elements);

%initiation of the different arrays needed
%for von Mises stress sensitivity
stresses = zeros(noNodes,2,n_Mises_sens);
stress_sens = zeros(noNodes,2,n_Mises_sens);
end




%perturbations in x-direction
for i=1:noNodes
    
    %setting up the mesh for the current perturbation
    new_mesh.nodes = strMsh.nodes;
    new_mesh.nodes(i,1)= new_mesh.nodes(i,1)+finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    if dispSens.status
    %calculation of the displacement sensitivities for the
    %different requested nodes
    for j=1:n_disp_sens
        
        %important displacements of current configuration
        disp(:,1,i,j)=dHat_temp(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        
        
        %sensitivity as the finite difference of the
        %final system results
        disp_sens(:,1,i,j)= forward_finite_difference(transpose(initial_displacements(j,:)),disp(:,1,i,j),finiteDifference.perturbation);
        
    end
    end
    
    
    if eneSens.status
    %calculation of the strain energy in current configuration
    strain_energies(i,1)=strEne(new_mesh,analysis,parameters,dHat_temp);
    
    %sensitivity as the finite difference of the final
    %strain energy results
    ene_sens(i,1)= forward_finite_difference(initial_strain_energy, strain_energies(i,1),finiteDifference.perturbation);
    end
    
    
    if vonMisesSens.status
    %calculation of the von Mises stresses for the different elements in
    %current configuration
    stresses(i,1,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp,vonMisesSens.elements);
    s_temp(1,:)=stresses(i,1,:);
    
    %sensitivity as the finite difference of the final
    %von Mises stress results
    stress_sens(i,1,:)= forward_finite_difference(initial_stresses,s_temp,finiteDifference.perturbation);
    end
     
end

%%perturbations in y-direction
for i=1:noNodes
    
    %setting up the mesh for the current perturbation
    new_mesh.nodes = strMsh.nodes;
    new_mesh.nodes(i,2)= new_mesh.nodes(i,2)+finiteDifference.perturbation;
    
    %calculation of the diplacement in the current configuration
    [dHat_temp,~,~] = solve_FEMPlateInMembraneAction...
        (analysis,new_mesh,homDBC,inhomDBC,valuesInhomDBC,NBC,bodyForces,...
        parameters,computeStiffMtxLoadVct,solve_LinearSystem,...
        propNLinearAnalysis,propStrDynamics,intDomain,caseName,pathToOutput,...
        isUnitTest,'outputDisabled');
    
    if dispSens.status
    %calculation of the displacement sensitivities for the
    %different requested nodes
    for j=1:n_disp_sens
        
        %important displacements of current configuration
        disp(:,2,i,j)=dHat_temp(2*dispSens.nodes(j)-1:2*dispSens.nodes(j));
        
        
        %sensitivity as the finite difference of the
        %final system results
        disp_sens(:,2,i,j)= forward_finite_difference(transpose(initial_displacements(j,:)),disp(:,2,i,j),finiteDifference.perturbation);
        
    end
    end
    
    
    if eneSens.status
    %calculation of the strain energy in current configuration
    strain_energies(i,2)=strEne(new_mesh,analysis,parameters,dHat_temp);
    
    %sensitivity as the finite difference of the final
    %strain energy results
    ene_sens(i,2)= forward_finite_difference(initial_strain_energy, strain_energies(i,2),finiteDifference.perturbation);
    end
    
    
    if vonMisesSens.status
    %calculation of the von Mises stresses for the different elements in
    %current configuration
    stresses(i,2,:)= vonMisesStress(strMsh,analysis,parameters,dHat_temp,vonMisesSens.elements);
    s_temp(1,:)=stresses(i,2,:);
    
    %sensitivity as the finite difference of the final
    %von Mises stress results
    stress_sens(i,2,:)= forward_finite_difference(initial_stresses,s_temp,finiteDifference.perturbation);
    end
     
end
end



    