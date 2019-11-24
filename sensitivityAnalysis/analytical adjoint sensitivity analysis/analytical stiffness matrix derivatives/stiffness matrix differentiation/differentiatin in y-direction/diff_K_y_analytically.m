function K_diff=diff_K_y_analytically(strMsh,n,noNodes,parameters)

%initiate differentiated stiffness matrix
K_diff = zeros(noNodes*2);

%finds elements of which the node we are looking for is part of
elements = find_elements(strMsh,n);
n_elements = size(elements,1);


for i=1:n_elements
    
    %nodal coordinates of current element
    nodes_temp = strMsh.elements(elements(i,2),:);
    nodes_coord_temp = [strMsh.nodes(nodes_temp(1),1:2); strMsh.nodes(nodes_temp(2),1:2); strMsh.nodes(nodes_temp(3),1:2)];
    DOFs_temp=[nodes_temp(1)*2-1,nodes_temp(1)*2,nodes_temp(2)*2-1,nodes_temp(2)*2,nodes_temp(3)*2-1,nodes_temp(3)*2];
    
    %differentiation of the single element stiffness matrix
    if elements(i,1)==1
        K_diff_temp = diff_K_y1_CST(nodes_coord_temp,parameters);
    elseif elements(i,1)==2
        K_diff_temp = diff_K_y2_CST(nodes_coord_temp,parameters);
    elseif elements(i,1)==3
        K_diff_temp = diff_K_y3_CST(nodes_coord_temp,parameters);
    end
        
    %assignment of the single element stiffness matrix entries derivatives
    %to the derived global stiffness matrix
    
    K_diff(DOFs_temp(1),DOFs_temp(1))= K_diff(DOFs_temp(1),DOFs_temp(1)) + K_diff_temp(1,1);
    K_diff(DOFs_temp(2),DOFs_temp(1))= K_diff(DOFs_temp(2),DOFs_temp(1)) + K_diff_temp(2,1);
    K_diff(DOFs_temp(3),DOFs_temp(1))= K_diff(DOFs_temp(3),DOFs_temp(1)) + K_diff_temp(3,1);
    K_diff(DOFs_temp(4),DOFs_temp(1))= K_diff(DOFs_temp(4),DOFs_temp(1)) + K_diff_temp(4,1);
    K_diff(DOFs_temp(5),DOFs_temp(1))= K_diff(DOFs_temp(5),DOFs_temp(1)) + K_diff_temp(5,1);
    K_diff(DOFs_temp(6),DOFs_temp(1))= K_diff(DOFs_temp(6),DOFs_temp(1)) + K_diff_temp(6,1);
    
    K_diff(DOFs_temp(1),DOFs_temp(2))= K_diff(DOFs_temp(1),DOFs_temp(2)) + K_diff_temp(1,2);
    K_diff(DOFs_temp(2),DOFs_temp(2))= K_diff(DOFs_temp(2),DOFs_temp(2)) + K_diff_temp(2,2);
    K_diff(DOFs_temp(3),DOFs_temp(2))= K_diff(DOFs_temp(3),DOFs_temp(2)) + K_diff_temp(3,2);
    K_diff(DOFs_temp(4),DOFs_temp(2))= K_diff(DOFs_temp(4),DOFs_temp(2)) + K_diff_temp(4,2);
    K_diff(DOFs_temp(5),DOFs_temp(2))= K_diff(DOFs_temp(5),DOFs_temp(2)) + K_diff_temp(5,2);
    K_diff(DOFs_temp(6),DOFs_temp(2))= K_diff(DOFs_temp(6),DOFs_temp(2)) + K_diff_temp(6,2);
    
    K_diff(DOFs_temp(1),DOFs_temp(3))= K_diff(DOFs_temp(1),DOFs_temp(3)) + K_diff_temp(1,3);
    K_diff(DOFs_temp(2),DOFs_temp(3))= K_diff(DOFs_temp(2),DOFs_temp(3)) + K_diff_temp(2,3);
    K_diff(DOFs_temp(3),DOFs_temp(3))= K_diff(DOFs_temp(3),DOFs_temp(3)) + K_diff_temp(3,3);
    K_diff(DOFs_temp(4),DOFs_temp(3))= K_diff(DOFs_temp(4),DOFs_temp(3)) + K_diff_temp(4,3);
    K_diff(DOFs_temp(5),DOFs_temp(3))= K_diff(DOFs_temp(5),DOFs_temp(3)) + K_diff_temp(5,3);
    K_diff(DOFs_temp(6),DOFs_temp(3))= K_diff(DOFs_temp(6),DOFs_temp(3)) + K_diff_temp(6,3);
    
    K_diff(DOFs_temp(1),DOFs_temp(4))= K_diff(DOFs_temp(1),DOFs_temp(4)) + K_diff_temp(1,4);
    K_diff(DOFs_temp(2),DOFs_temp(4))= K_diff(DOFs_temp(2),DOFs_temp(4)) + K_diff_temp(2,4);
    K_diff(DOFs_temp(3),DOFs_temp(4))= K_diff(DOFs_temp(3),DOFs_temp(4)) + K_diff_temp(3,4);
    K_diff(DOFs_temp(4),DOFs_temp(4))= K_diff(DOFs_temp(4),DOFs_temp(4)) + K_diff_temp(4,4);
    K_diff(DOFs_temp(5),DOFs_temp(4))= K_diff(DOFs_temp(5),DOFs_temp(4)) + K_diff_temp(5,4);
    K_diff(DOFs_temp(6),DOFs_temp(4))= K_diff(DOFs_temp(6),DOFs_temp(4)) + K_diff_temp(6,4);
    
    K_diff(DOFs_temp(1),DOFs_temp(5))= K_diff(DOFs_temp(1),DOFs_temp(5)) + K_diff_temp(1,5);
    K_diff(DOFs_temp(2),DOFs_temp(5))= K_diff(DOFs_temp(2),DOFs_temp(5)) + K_diff_temp(2,5);
    K_diff(DOFs_temp(3),DOFs_temp(5))= K_diff(DOFs_temp(3),DOFs_temp(5)) + K_diff_temp(3,5);
    K_diff(DOFs_temp(4),DOFs_temp(5))= K_diff(DOFs_temp(4),DOFs_temp(5)) + K_diff_temp(4,5);
    K_diff(DOFs_temp(5),DOFs_temp(5))= K_diff(DOFs_temp(5),DOFs_temp(5)) + K_diff_temp(5,5);
    K_diff(DOFs_temp(6),DOFs_temp(5))= K_diff(DOFs_temp(6),DOFs_temp(5)) + K_diff_temp(6,5);
    
    K_diff(DOFs_temp(1),DOFs_temp(6))= K_diff(DOFs_temp(1),DOFs_temp(6)) + K_diff_temp(1,6);
    K_diff(DOFs_temp(2),DOFs_temp(6))= K_diff(DOFs_temp(2),DOFs_temp(6)) + K_diff_temp(2,6);
    K_diff(DOFs_temp(3),DOFs_temp(6))= K_diff(DOFs_temp(3),DOFs_temp(6)) + K_diff_temp(3,6);
    K_diff(DOFs_temp(4),DOFs_temp(6))= K_diff(DOFs_temp(4),DOFs_temp(6)) + K_diff_temp(4,6);
    K_diff(DOFs_temp(5),DOFs_temp(6))= K_diff(DOFs_temp(5),DOFs_temp(6)) + K_diff_temp(5,6);
    K_diff(DOFs_temp(6),DOFs_temp(6))= K_diff(DOFs_temp(6),DOFs_temp(6)) + K_diff_temp(6,6);
    
end

K_diff = sparse(K_diff);

end