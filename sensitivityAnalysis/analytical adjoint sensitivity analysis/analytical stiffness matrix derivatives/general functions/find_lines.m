function line_info = find_lines(NBC,searched_node)

%finds lines and position on them (beginning or end) on which a force is applied who contain the node we are
%looking for
[r, c] = find(NBC.lines(:,1:2).' == searched_node);
line_info=[r,c];

end