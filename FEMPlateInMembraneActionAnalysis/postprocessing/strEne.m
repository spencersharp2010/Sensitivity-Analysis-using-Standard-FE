function energy=strEne(strMsh,analysis,parameters,dHat)
%calculates the strain energy

%calculation of the element areas
vertexI = strMsh.nodes(strMsh.elements(:,1),:);
vertexJ = strMsh.nodes(strMsh.elements(:,2),:);
vertexK = strMsh.nodes(strMsh.elements(:,3),:);

l=length(vertexI);

area = 0.5 * p3Ddet( phorzcat( ones( l, 3, 1), pvertcat( ptranspose(vertexI(:, 1:2)), ...
                                                                ptranspose(vertexJ(:, 1:2)), ...
                                                                ptranspose(vertexK(:, 1:2))) ) );
                                                            


%calculation of the strains and stresses                                                            
[epsilon,sigma] = computePostprocFEMPlateInMembraneActionCSTLinear...
    (strMsh,analysis,parameters,dHat);

eps=[epsilon(:,:);epsilon(3,:)];
sig=[sigma(:,:);sigma(3,:)];

Energy=zeros(l,1);

%calculation of strain energy for each element
for i=1:l
    Energy(i)=0.5*transpose(eps(:,i))*sig(:,i)*area(i);
end 

%total strain energy
energy=sum(Energy);
end