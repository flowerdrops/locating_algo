function [dist,t_total]=fraction_sim(v_acou,k,theta,H,H_sample)
global theta_bound;

%%%%%%%% exam the special case %%%%%%%%%%%%
if theta>theta_bound
    dist=H*tan(theta);
    t_total=H/(cos(theta)*mean(v_acou));
    return;
end

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










