function F_diff=diff_F_analytically_x(strMsh,NBC,node,noNodes)
 
%initiate differentiated force vector
F_diff = zeros(noNodes*2,1);

%find edges which contain the perturbated node
edges=find_lines(NBC,node);

%number of edges which contain the perturbated node
n_edges=size(edges,1);

%loop over all edges
for i=1:n_edges
        
    %nodal coordinates and DOFs of current edge
    nodes_temp = NBC.lines(edges(i,2),:);
    nodes_coord_temp = [strMsh.nodes(nodes_temp(1),1:2); strMsh.nodes(nodes_temp(2),1:2)];
    DOFs_temp=[nodes_temp(1)*2-1,nodes_temp(1)*2,nodes_temp(2)*2-1,nodes_temp(2)*2];
    
    %analytical differentiation of the length of the edge according to the node number on the current edge   
    if edges(i,1)==1
        edge_diff=edge_diff_x1(nodes_coord_temp);
    elseif edges(i,1)==2
        edge_diff=edge_diff_x2(nodes_coord_temp);
    end
    
    %evaluation of force on current edge
    loadFctHandle = str2func(NBC.fctHandle(edges(i,2),:));
    tractionOnLine = loadFctHandle(0,0,0,0);
    tractionOnLine2D = tractionOnLine(1:2,1);
    
    %adding up derived force vector
    F_diff(DOFs_temp(1:2),1)=F_diff(DOFs_temp(1:2),1)+tractionOnLine2D*edge_diff*0.5;
    F_diff(DOFs_temp(3:4),1)=F_diff(DOFs_temp(3:4),1)+tractionOnLine2D*edge_diff*0.5;     
    
end
end
    
    


