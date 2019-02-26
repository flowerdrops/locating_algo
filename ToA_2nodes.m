function Toa_r = ToA_2nodes( A,B,v_acou )
% Éù²¨´ÓA´«µ½B
global threshold;
Toa_r=0;

% real Toa in the world, from UL node to anchornodes
% for convinience, the direction is caculated up to down, which is not true in 2-way ranging

%each ToA from anchor nodes to unlocated nodes
    tmp=1e5*ones(2,402);
    dist_anchor_UL_3D=sqrt(sum((A-B).^2));
    dist_anchor_UL_2D=sqrt(sum((A(1:2)-B(1:2)).^2));
    theta_rouph=asin(dist_anchor_UL_2D/dist_anchor_UL_3D);
    %%%%%% get rid of the too-big theta %%%%%%%%%%%%
    if abs(A(3)-B(3))<20
        t1=min(floor(A(3)+1),floor(B(3)+1));
        t2=max(floor(A(3)+1),floor(B(3)+1));
        Toa_r=dist_anchor_UL_2D/mean(v_acou(t1:t2));
        return;
    end
    
    if theta_rouph>1.5
        t1=min(floor(A(3)+1),floor(B(3)+1));
        t2=max(floor(A(3)+1),floor(B(3)+1));
        Toa_r=dist_anchor_UL_2D/mean(v_acou(t1:t2));
        return;
    end
%     for j=0:0.001:0.2
      for j=1:200
        [dist1,t_total1]=fraction_2nodes(v_acou,A,B,theta_rouph-j*1e-3,1);
                        tmp(1,j)=abs(dist1-dist_anchor_UL_2D);              tmp(2,j)=t_total1;
        [dist2,t_total2]=fraction_2nodes(v_acou,A,B,theta_rouph+j*1e-3,1);
                        tmp(1,200+j)=abs(dist2-dist_anchor_UL_2D);          tmp(2,200+j)=t_total2;
%          plot(theta_rouph-j,abs(dist1-dist_anchor_UL_2D),'*'); hold on
%          plot(theta_rouph+j,abs(dist2-dist_anchor_UL_2D),'*'); hold on
        if abs(dist1-dist_anchor_UL_2D)<threshold
            Toa_r=t_total1;
            break;
        end
        if abs(dist2-dist_anchor_UL_2D)<threshold
            Toa_r=t_total2;
            break;
        end
    end
%     hold off
    if Toa_r==0
        [~,b]=min(tmp(1,:));
        Toa_r=tmp(2,b);
    end
end



% function [dist,t_total]=locate(v_acou,k,theta,H)
% %%% results initialize %%%
% dist=0;   t_total=0;
% ct=cos(theta);
% %%% simulation initialize %%%
% depth_Num=round(H);     ct_tmp=ct;
% for i=1:depth_Num
%     t_total=t_total+1/(v_acou(i)*ct_tmp);
%     dist=dist+sqrt(1-ct_tmp^2)/ct_tmp;
%     ct_tmp=ct*sqrt(k(i)^2+(1-k(i)^2)/ct^2);
% end
% 
% end















