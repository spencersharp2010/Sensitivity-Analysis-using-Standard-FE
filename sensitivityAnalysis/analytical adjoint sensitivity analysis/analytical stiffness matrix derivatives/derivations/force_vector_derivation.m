% script used for the definition of the functions 'edge_diff_x1', 'edge_diff_x2','edge_diff_y1','edge_diff_y2'
syms x1 x2 y1 y2
l=sqrt((x2-x1)^2+(y2-y1)^2);

F_x1=diff(l,x1)
F_x2=diff(l,x2)
F_y1=diff(l,y1)
F_y2=diff(l,y2)
