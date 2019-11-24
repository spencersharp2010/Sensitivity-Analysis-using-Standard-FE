function writeOutputSensitivity...
    (strMsh,dispSens,eneSens,vonMisesSens,parameters,sensAnalysisType,displacement_sensitivity,strain_energy_sensitivity,von_mises_stress_sensitivity,caseName,pathToOutput,timeStepNo)

% Read input

%create new case name for sensitivity analysis output
caseName=strcat(caseName,'_Sensitivity_Analysis');


% Make directory to write out the results of the analysis
isExistent = exist(strcat(pathToOutput,caseName),'dir');
if ~isExistent
    mkdir(strcat(pathToOutput,caseName));
end

%  Number of nodes in the mesh
[noNodes,~] = size(strMsh.nodes);

% Number of elements in the mesh
[noElements,elementOrder] = size(strMsh.elements);

output = fopen(strcat(pathToOutput,caseName,'/',caseName,'_',...
    num2str(timeStepNo),'.vtk'),'w');

% Transpose the nodal coordinates array
XYZ = strMsh.nodes(1:noNodes,:)';

% Re-arrange the element numbering to start from zero
elements = zeros(elementOrder,noElements);
elements(1:elementOrder,1:noElements) = strMsh.elements(1:noElements,1:elementOrder)' - 1;

% Write out the preamble
fprintf(output, '# vtk DataFile Version 2.0\n');
fprintf(output, 'SensitivityAnalysis\n');
fprintf(output, 'ASCII\n');
fprintf(output, '\n');
fprintf(output, 'DATASET UNSTRUCTURED_GRID\n');
fprintf(output, 'POINTS %d double\n', noNodes);

% Write out the nodal coordinates
for nodeID = 1:noNodes
    fprintf(output,'  %f  %f  %f\n', XYZ(:,nodeID));
end

% Note that CELL_SIZE uses ELEMENT_ORDER + 1 because the order of each 
% element is included as a data item.
cellSize = 0;
for elementID = 1:noElements
    check = isnan(elements(:,elementID));
    if check(4) == 1
    cellSize = cellSize + 4;
    else
    cellSize = cellSize + 5;
    end
end

% Output the element connectivities to the nodes
fprintf(output,'\n' );
fprintf(output,'CELLS  %d  %d\n',noElements,cellSize);

% Loop over all the elements in the mesh
for elementID = 1:noElements
    check = isnan(elements(:,elementID));
    if check(4) == 1
        elementOrder = 3;
        % Write out the element order
        fprintf (output,'  %d',elementOrder);
        
        % Loop over all the polynomial orders
        for order = 1:elementOrder
            % Write out the polynomial order
            fprintf(output,'  %d',elements(order,elementID));
        end
        
        % Change line
        fprintf (output,'\n' );
    else
        % Write out the element order
        fprintf (output,'  %d',elementOrder);
        
        % Loop over all the polynomial orders
        for order = 1:elementOrder
            % Write out the polynomial order
            fprintf(output,'  %d',elements(order,elementID));
        end
        
        % Change line
        fprintf (output,'\n' );
    end
end

% VTK has a cell type 22 for quadratic triangles.  However, we
% are going to strip the data down to linear triangles for now,
% which is cell type 5.

fprintf (output,'\n' );
fprintf (output,'CELL_TYPES %d\n',noElements);

% Loop over all the elements and write out the nodal coordinates and the
% element connectivities according to the element order
for elementID = 1:noElements
    check = isnan(elements(:,elementID));
    if check(4) == 1
        fprintf (output,'5\n');
    else
        fprintf (output,'9\n');
    end
end



% Write out sensitivity analysis results
fprintf(output,'POINT_DATA %d\n',noNodes);

if dispSens.status
    n_disp_sens=length(dispSens.nodes);
    
for i=1:n_disp_sens
    fprintf(output,'VECTORS disp_sens_pert_x_%d double\n',dispSens.nodes(i));
    for nodeID = 1:noNodes
        fprintf(output,'  %f  %f  0\n',displacement_sensitivity(1,1,nodeID,i),displacement_sensitivity(2,1,nodeID,i));
    end
end

for i=1:n_disp_sens
    fprintf(output,'VECTORS disp_sens_pert_y_%d double\n',dispSens.nodes(i));
    for nodeID = 1:noNodes
        fprintf(output,'  %f  %f  0\n',displacement_sensitivity(1,2,nodeID,i),displacement_sensitivity(2,2,nodeID,i));
    end
end
end

if eneSens.status
    fprintf(output,'VECTORS strain_energy_sensitivity double\n');
    for nodeID = 1:noNodes
        fprintf(output,'  %f  %f  0\n',strain_energy_sensitivity(nodeID,1),strain_energy_sensitivity(nodeID,2));
    end
end

if vonMisesSens.status && strcmp(sensAnalysisType,'global')
    n_stress_sens=length(vonMisesSens.elements);
    
for i=1:n_stress_sens
    fprintf(output,'VECTORS stress_sens_%d double\n',vonMisesSens.elements(i));
    for nodeID = 1:noNodes
        fprintf(output,'  %f  %f  0\n',von_mises_stress_sensitivity(nodeID,1,i),von_mises_stress_sensitivity(nodeID,2,i));
    end
end

end


    



% Close files
fclose(output);

return;

end