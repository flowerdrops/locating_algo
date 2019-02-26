function [res_x,res_y]=primarytest(X,Y,B,C,k3,k2,h,R)
likely=zeros(1,4);
for i=1:4
    x=X(i);y=Y(i);  est_S=[x,y,h];
    tmp1=abs(sum((est_S-C).^2)-k3*sum((est_S-B).^2));
    tmp2=abs(sum((est_S-C).^2)-k2*sum((est_S).^2));
    likely(i)=abs(x-R)*(x<0|x>R)+abs(y-R)*(y<0|y>R)+tmp1+tmp2;
end
[a ind]=min(likely);
res_x=X(ind);   res_y=Y(ind);
end