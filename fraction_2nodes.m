function [dist,t_total]=fraction_2nodes(v_acou,A,B,theta,H_sample)
threshold=1;
% ABdis_2D=sqrt(sum((A(1:2)-B(1:2)).^2));
% ABdis_3D=sqrt(sum((A-B).^2));
% theta=asin(ABdis_2D/ABdis_3D);
%%%%%%%% exam the special case %%%%%%%%%%%%
% if theta>1.5
%     dist=H*tan(theta);
%     t_total=H/(cos(theta)*mean(v_acou(floor(A(3)+1):floor(B(3)+1))));
%     return;
% end
%%%%%%%%%%%% intermediate parameters %%%%%%%%%%%%%%%%
H=abs(A(3)-B(3));
t1=min(floor(A(3)+1),floor(B(3)+1));
t2=max(floor(A(3)+1),floor(B(3)+1));
v_acou=v_acou(t1:t2);
k=v_acou/v_acou(1);
%%% results initialize %%%
dist=0;   t_total=0;

%%% simulation initialize %%%
depth_Num=floor(H/H_sample);     ct=cos(theta);  ct_tmp=ct;     tmp1=0;

for i=1:depth_Num
    tmp1=sqrt(k(i)^2+(1-k(i)^2)/ct^2);
    if isreal(tmp1)
        ct_tmp=ct*tmp1;
    end  
    t_total=t_total+H_sample/(v_acou(i)*ct_tmp);
    dist=dist+H_sample*sqrt(1-ct_tmp^2)/ct_tmp;    
end
if isempty(i)
    i=1;
end
t_total=t_total+(H-depth_Num*H_sample)/(v_acou(i)*ct_tmp);
dist=dist+(H-depth_Num*H_sample)*sqrt(1-ct_tmp^2)/ct_tmp;
end










