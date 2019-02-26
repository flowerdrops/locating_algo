function [res_x,res_y]=crosspoint(node1,node2,r1,r2)
x1=node1(1); x2=node2(1);   y1=node1(2);    y2=node2(2);
if (r1*r2==0)
    x=x1+r1*(x2-x1)/(r1+r2);   res_x=[x x];
    y=y1+r1*(y2-y1)/(r1+r2);   res_y=[y y];
    return;
end

k=x1-x2;    m=y1-y2;    res_ind=zeros(1,4);
a=0.5*((r2^2-r1^2-k^2-m^2)/r1);
delta=sqrt(a^2*k^2-(m^2+k^2)*(a^2-m^2));
if ~(isreal(delta))
    x=r1*(x1+x2)/(r1+r2);   res_x=[x x];
    y=r1*(y1+y2)/(r1+r2);   res_y=[y y];
    return;
end
ct1=(a*k+delta)/(m^2+k^2);    ct2=(a*k-delta)/(m^2+k^2);
x=[ct1*r1+x1,ct1*r1+x1,ct2*r1+x1,ct2*r1+x1];    
y=[y1+r1*sqrt(1-ct1^2),y1-r1*sqrt(1-ct1^2),y1+r1*sqrt(1-ct2^2),y1-r1*sqrt(1-ct2^2)];
for i=1:4
    res_ind(i)=test(x(i),y(i),x1,x2,y1,y2,r1,r2);
end
[~, ind1]=min(res_ind);
res_ind(ind1)=1e8;
[~, ind2]=min(res_ind);
res_x=x([ind1, ind2]);   res_y=y([ind1, ind2]);
end

function res=test(x,y,x1,x2,y1,y2,r1,r2)
    res1=(x-x1)^2+(y-y1)^2-r1^2;
    res2=(x-x2)^2+(y-y2)^2-r2^2;
    res=abs(res1)+abs(res2);
end



