function Toa_r = real_world_ToA( nodes,v_acou )
% 声波从上传到最后一个node位置

global theta_bound;
global threshold;
% real Toa in the world, from UL node to anchornodes
% for convinience, the direction is caculated up to down, which is not true in 2-way ranging
[nodeNum,b]=size(nodes);    anchorNum=nodeNum-1;
Toa_r=zeros(1,anchorNum);
k=v_acou/v_acou(1); % fraction rate of acoustic in different layers
%each ToA from anchor nodes to unlocated nodes
N=400; resolution=2e-4;tmp=1e5*ones(2,2*N+2);  
flag1=1;flag2=1;
for i=1:anchorNum 
    dist_anchor_UL_3D=sqrt(sum((nodes(i,:)-nodes(nodeNum,:)).^2));
    dist_anchor_UL_2D=sqrt(sum((nodes(i,1:2)-nodes(nodeNum,1:2)).^2));
    theta_rouph=acos(nodes(nodeNum,3)/dist_anchor_UL_3D);
    %%%%%%%%%% re-initialize %%%%%%%%%%%%%%%%%%%
    tmp=1e5*ones(2,2*N+2); 
    flag1=1;flag2=1;
    
    %%%%%% get rid of the too-big theta %%%%%%%%%%%%
    if theta_rouph>theta_bound
        Toa_r(i)=dist_anchor_UL_3D/mean(v_acou(1:(floor(nodes(nodeNum,3)+1))));
        continue;
    end
    %%%% initial judge %%%%%
%     [dist1,t_total1]=fraction_sim(v_acou,k,theta_rouph,nodes(nodeNum,3),1);
%     if abs(dist1-dist_anchor_UL_2D)<threshold 
%             Toa_r(i)=t_total1;
%             continue;
%     end
%     for j=0:0.001:0.2
    for j=1:N
        if flag1 %%%%%%%%% 左边滴 %%%%%%%%%%%%%
            [dist1,t_total1]=fraction_sim(v_acou,k,theta_rouph-j*resolution,nodes(nodeNum,3),1);
            tmp(1,N-j+1)=abs(dist1-dist_anchor_UL_2D);              tmp(2,N-j+1)=t_total1;
%         	plot(theta_rouph-j*resolution,abs(dist1-dist_anchor_UL_2D),'*'); hold on                
        end
        if flag2 %%%%%%%%% 右边滴 %%%%%%%%%%%%%
            if (theta_rouph+j*resolution)>theta_bound
                Toa_r(i)=dist_anchor_UL_3D/mean(v_acou(1:(floor(nodes(nodeNum,3)+1))));
                break;
            end
            [dist2,t_total2]=fraction_sim(v_acou,k,theta_rouph+j*resolution,nodes(nodeNum,3),1);
            tmp(1,N+j)=abs(dist2-dist_anchor_UL_2D);          tmp(2,N+j)=t_total2;
%             plot(theta_rouph+j*resolution,abs(dist2-dist_anchor_UL_2D),'*'); hold on           
        end
         
          
        %%%%%%%%%%%%%% if the lowest point %%%%%%%%%%%%%%%
        if j>2
            if (tmp(1,N+j-1)<tmp(1,N+j))&(tmp(1,N+j-1)<tmp(1,N+j-2))&flag1
                Toa_r(i)=tmp(2,N+j-1);
                break;             
            end
            if (tmp(1,N+2-j)<tmp(1,N+1-j))&(tmp(1,N+2-j)>tmp(1,N+3-j))
                    flag1=0;
            end
                
            if (tmp(1,N+2-j)<tmp(1,N+1-j))&(tmp(1,N+2-j)<tmp(1,N+3-j))&flag2
                Toa_r(i)=tmp(2,N+2-j);
                break;
            end
            if (tmp(1,N+j-1)<tmp(1,N+j))&(tmp(1,N+j-1)>tmp(1,N+j-2))
                flag2=0;
            end
        end
        %%%%%%%%%%%%%% if t_total1 %%%%%%%%%%%%%%%
        if abs(dist1-dist_anchor_UL_2D)<threshold 
            Toa_r(i)=t_total1;
            break;
        end
        %%%%%%%%%%%%%% if t_total2 %%%%%%%%%%%%%%%
        if abs(dist2-dist_anchor_UL_2D)<threshold
            Toa_r(i)=t_total2;
            break;
        end
    end
%     hold off
    if Toa_r(i)==0
        [~, b]=min(tmp(1,:));
        Toa_r(i)=tmp(2,b);
    end
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















