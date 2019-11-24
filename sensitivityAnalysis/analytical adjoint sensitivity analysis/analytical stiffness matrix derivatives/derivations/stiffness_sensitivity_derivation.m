% script used for the definition of the functions 'diff_x1_CST','diff_x2_CST','diff_x3_CST','diff_y1_CST','diff_y2_CST','diff_y3_CST'
syms x1 y1 x2 y2 x3 y3 E nu

D=E/(1-nu^2)*[1, nu, 0; nu, 1, 0; 0, 0, (1-nu)/2];

A=0.5*(x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2));
B=(1/(2*A)).*[y2-y3, 0, y3-y1, 0, y1-y2, 0; 0, x3-x2, 0, x1-x3, 0, x2-x1; x3-x2, y2-y3, x1-x3, y3-y1, x2-x1, y1-y2];

K=A*transpose(B)*D*B;

K_diff_x1=diff(K,x1);
K_diff_y1=diff(K,y1);
K_diff_x2=diff(K,x2);
K_diff_y2=diff(K,y2);
K_diff_x3=diff(K,x3);
K_diff_y3=diff(K,y3);
