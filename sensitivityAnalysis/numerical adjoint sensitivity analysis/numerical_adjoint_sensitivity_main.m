function [displacement_sensitivity, strain_energy_sensitivity]=numerical_adjoint_sensitivity_main(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain)

%differentiation between the different finite differencing methods
if strcmp(finiteDifference.method,'forward')
    [displacement_sensitivity, strain_energy_sensitivity]=numerical_adjoint_sensitivity_forward(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain);
    
elseif strcmp(finiteDifference.method,'backward')
    [displacement_sensitivity, strain_energy_sensitivity]=numerical_adjoint_sensitivity_backward(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain);
    
elseif strcmp(finiteDifference.method,'central')
    [displacement_sensitivity, strain_energy_sensitivity]=numerical_adjoint_sensitivity_central(finiteDifference,eneSens, dispSens,analysis,strMsh,homDBC,inhomDBC,NBC,bodyForces,parameters,propStrDynamics,intDomain);
    
end
end