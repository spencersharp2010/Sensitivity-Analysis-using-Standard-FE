function vonMisesStress=vonMisesStress(strMsh,analysis,parameters,dHat,elements)
%calculates the von Mises stress for the requested elements out of the
%normal and shear stresses

%calculation of the strains and stresses (only stresses are actually needed)                                                            
[~,Sigma] = computePostprocFEMPlateInMembraneActionCSTLinear...
    (strMsh,analysis,parameters,dHat);

%reduce the stress array to the values of the elements which are actually
%needed
sigma_red=Sigma(:,elements);

noElements=length(elements);

vonMisesStress=zeros(1,noElements);

%calculation of von Mises stress for each element
for i=1:noElements
vonMisesStress(i) = sqrt(sigma_red(1,i).^2 + (sigma_red(2,i)).^2 -sigma_red(1,i).*sigma_red(2,i) + 3*(sigma_red(3,i)).^2);
end 

end
