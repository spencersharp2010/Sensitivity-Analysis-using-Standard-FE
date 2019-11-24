function length_diff=edge_diff_x2(nodes)

%evaluation of nodal coordinates
x1=nodes(1,1);
y1=nodes(1,2);
x2=nodes(2,1);
y2=nodes(2,2);

%computation of differentiated edge length
length_diff=-(2*x1 - 2*x2)/(2*((x1 - x2)^2 + (y1 - y2)^2)^(1/2));
end