function elements = find_elements(strMsh,searched_node)

%finds elements of which the node we are looking for is part of and the
%index of the node in the element
[r, c] = find(strMsh.elements.' == searched_node);
elements=[r,c];

end

