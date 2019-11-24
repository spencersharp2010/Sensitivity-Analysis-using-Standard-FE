function [disp_sens, ene_sens]=analytical_adjoint_sensitivity(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain)

%Computes the adjoint sensitivities of displacement and strain energy by
%taking the analytical derivative of the stiffness matrix and the force vector in one go

%initiation of outputs for the case they aren't actually requested
disp_sens=[];
ene_sens=[];

%Setting up system parameters which are needed to use the already given
%functions when computing the stiffness matrices and force vectors

%parameter t=0 for stationarity
t=0;

% Number of nodes in the mesh
noNodes = length(strMsh.nodes(:,1));

% Number of DOFs in the mesh
noDOFs = 2*noNodes;

% Global DOF numbering
DOFNumbering = 1:noDOFs;

%Find the prescribed and the free DOFs of the system

% Prescribed DOFs (DOFs on which either homogeneous or inhomogeneous 
% Dirichlet boundary conditions are prescribed)
prescribedDOFs = mergesorted(homDBC,inhomDBC);
prescribedDOFs = unique(prescribedDOFs);
no_prescribedDOFs = length(prescribedDOFs);

% Free DOFs of the system (actual DOFs over which the solution is computed)
freeDOFs = DOFNumbering;
freeDOFs(ismember(freeDOFs,prescribedDOFs)) = [];

% initial guess for displacement
u=zeros(noDOFs,1);

% Assign dummy variables
uSaved = 'undefined';
uDot = 'undefined';
uDotSaved = 'undefined';

outMsg='outputDisabled';
loadFactor='undefined';

%computation of the stiffness matrix and the force vector in the initial
%configuration

%initial force vector without body forces
F_initial_wbf = computeLoadVctFEMPlateInMembraneAction...
    (strMsh,analysis,NBC,t,intDomain,outMsg);

%complete stiffness matrix and force vector of the initial configuration
[K_initial,F_initial,~] = computeStiffMtxAndLoadVctFEMPlateInMembraneActionCST...
    (analysis,u,uSaved,uDot,uDotSaved,DOFNumbering,strMsh,F_initial_wbf,loadFactor,...
    bodyForces,propStrDynamics,parameters,intDomain);

%reduced stiffness matrix and force vector of the initial configuration by
%cancelling out the rows and columns of DOFs with given Dirichlet boundary
%conditions
K_in_red=K_initial(freeDOFs,freeDOFs);
F_in_red=F_initial(freeDOFs);

%computation of displacements in initial configuration without zero-displacements out of
%Dirichlet boundary conditions  
u_initial=K_in_red\F_in_red;


%check if displacement sensitivity is needed
if dispSens.status
%number of nodes for which the displacement sensitivity has to be evaluated
n_disp_sens=length(dispSens.nodes);

%computation of adjoint variables A (vector) for displacement sensitivities of the
%different requested nodes saved in 3-dimensional array
A_disp=zeros(n_disp_sens,2,noDOFs-no_prescribedDOFs);

for i=1:n_disp_sens
    %for displacement in x-direction
    v_temp_x=zeros(noDOFs,1);
    v_temp_x(2*dispSens.nodes(i)-1)=1;
    v_temp_x(prescribedDOFs)=[];
    A_temp_x=K_in_red\v_temp_x;
    A_disp(i,1,:)=A_temp_x;

    %for displacement in y-direction    
    v_temp_y=zeros(noDOFs,1);
    v_temp_y(2*dispSens.nodes(i))=1;
    v_temp_y(prescribedDOFs)=[];
    A_temp_y=K_in_red\v_temp_y;
    A_disp(i,2,:)=A_temp_y;
end

%initiation of the different arrays needed
%for displacement sensitivity
disp_sens = zeros(2,2,noNodes,n_disp_sens);
end


%check if energy sensitivity is needed
if eneSens.status
%adjoint variable for the strain energy sensitivity analysis
A_ene=0.5*u_initial;
%tranposed adjoint variable
A_ene_T=transpose(A_ene);

%initiation of the different arrays needed
%for strain energy sensitivity
ene_sens = zeros(noNodes,2);
end

%derivative in x-direction
for i=1:noNodes
    
    %computing the analytical derivative of the stiffness matrix 
    K_diff_temp = diff_K_x_analytically(strMsh,i,noNodes,parameters);
    F_diff_temp = diff_F_analytically_x(strMsh,NBC,i,noNodes);
    K_diff_temp_red=K_diff_temp(freeDOFs,freeDOFs);
    F_diff_temp_red=F_diff_temp(freeDOFs);
    
    %computation of term which appears in both adjoint sensitivity analysis
    C_term=transpose(F_diff_temp_red-K_diff_temp_red*u_initial);
    
    
    %check if displacement sensitivity is needed
    if dispSens.status
    %computation of displacement sensitivities for the different requested
    %nodes
    for j=1:n_disp_sens
        %restoring of the needed adjoint variables
        A_disp_x_temp(:,1)= A_disp(j,1,:);
        A_disp_y_temp(:,1)= A_disp(j,2,:);
        
        %actual sensitivity calculation
        disp_sens(1,1,i,j)= C_term*A_disp_x_temp;
        disp_sens(2,1,i,j)= C_term*A_disp_y_temp;
    end
    end
    
    %check if energy sensitivity is needed
    if eneSens.status
    %calculation of the strain energy in current configuration
    ene_sens(i,1)=A_ene_T*F_diff_temp_red+C_term*A_ene;
    end
end

%derivative in y-direction
for i=1:noNodes
    
    %computing the analytical derivative of the stiffness matrix
    K_diff_temp = diff_K_y_analytically(strMsh,i,noNodes,parameters);
    F_diff_temp = diff_F_analytically_y(strMsh,NBC,i,noNodes);
    K_diff_temp_red=K_diff_temp(freeDOFs,freeDOFs);
    F_diff_temp_red=F_diff_temp(freeDOFs);
    
    %computation of term which appears in both adjoint sensitivity analysis
    C_term=transpose(F_diff_temp_red-K_diff_temp_red*u_initial);
    
    
    %check if displacement sensitivity is needed
    if dispSens.status
    %computation of displacement sensitivities for the different requested
    %nodes
    for j=1:n_disp_sens
        %restoring of the needed adjoint variables
        A_disp_x_temp(:,1)= A_disp(j,1,:);
        A_disp_y_temp(:,1)= A_disp(j,2,:);
        
        %actual sensitivity calculation
        disp_sens(1,2,i,j)= C_term*A_disp_x_temp;
        disp_sens(2,2,i,j)= C_term*A_disp_y_temp;
    end
    end
    
    %check if energy sensitivity is needed
    if eneSens.status
    %calculation of the strain energy in current configuration
    ene_sens(i,2)=A_ene_T*F_diff_temp_red+C_term*A_ene;
    end
end
end