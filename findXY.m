function [res_x,res_y]=findXY(A,B,C,R,Ta,Tb,Tc,h)
% the position of an unknown node S would be determined in the area R*R
% the depth of S which is h is determined by the pressure sensor
res_x=[];       res_y=[];
xb=B(1);    yb=B(2);                xc=C(1);    yc=C(2);
    k1=(Tb/Ta)^2; k2=(Tc/Ta)^2; k3=(Tc/Tb)^2;
    x1=xb/(1-k1);   y1=yb/(1-k1);   r1=sqrt(k1*(xb^2+yb^2)/(1-k1)^2-h^2);
    x2=xc/(1-k2);   y2=yc/(1-k2);   r2=sqrt(k2*(xc^2+yc^2)/(1-k2)^2-h^2);

    a=x2-x1;    b=y2-y1;
    m=0.5*(r1^2+(a)^2+(b)^2-r2^2)/r1;
    delta=sqrt(4*a*a*m*m-4*(m^2-b^2)*(a^2+b^2));
%     hold on; showrange([x1,y1],r1);     hold on; showrange([x2,y2],r2);
    if ~(isreal(delta) && isreal(r1) && isreal(r2))
        [res_x,res_y]=tritangle([A;B;C],[Ta,Tb,Tc],1520,h);
        return;
    end
    Sx1=x1+0.5*r1*(2*a*m+delta)/(a^2+b^2);  
    Sy11=y1+sqrt(r1^2-(Sx1-x1)^2);      Sy12=y1-sqrt(r1^2-(Sx1-x1)^2);
    Sx2=x1+0.5*r1*(2*a*m-delta)/(a^2+b^2);
    Sy21=y1+sqrt(r1^2-(Sx2-x1)^2);      Sy22=y1-sqrt(r1^2-(Sx2-x1)^2);
    X=[Sx1 Sx1 Sx2 Sx2];    Y=[Sy11 Sy12 Sy21 Sy22];
    [res_x,res_y]=primarytest(X,Y,B,C,k3,k2,h,R);
end















