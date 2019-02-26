function [x,y,z,dsa]=deter_dis(k1,k2,k3,Na,Nb,Nc,Nd)
% estimate the localization of S by k1,k2,k3 and known node A B C D
xa=Na(1);  ya=Na(2); za=Na(3); 
xb=Nb(1);  yb=Nb(2); zb=Nb(3); 
xc=Nc(1);  yc=Nc(2); zc=Nc(3); 
xd=Nd(1);  yd=Nd(2); zd=Nd(3); 
Ax=-k1/xb;  Bx=(xb^2-k1^2)/(2*xb);
Ay=k1*xc/(xb*yc)-k2/yc;
By=(xc^2+yc^2-xb*xc+xc*k1^2/xb-k2^2)/(2*yc);
Az=(k1*xd)/(xb*zd)-k3/zd-yd*(k1*xc/xb-k2)/(yc*zd);
Bz=(xd^2+yd^2+zd^2-xb*xd+xd*k1^2/xb-k3^2-yd*xc^2/yc-yc*yd+xb*xc*yd/yc-k1^2*xc*yd/(xb*yc)+k2^2*yd/yc)/(2*zd);

alpha=Ax^2+Ay^2+Az^2-1;
beta=2*(Ax*Bx+Ay*By+Az*Bz);
gama=Bx^2+By^2+Bz^2;



dsa=(-beta-sqrt(beta^2-4*alpha*gama))/(2*alpha);
% dsa=(-beta+sqrt(beta^2-4*alpha*gama))/(2*alpha);
x=Ax*dsa+Bx;
y=Ay*dsa+By;
z=Az*dsa+Bz;





end










