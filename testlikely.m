function [toa_bias]=testlikely(dist_2D,theta_est,h_est,v_est,H_sample,Toa)
%%%%%%%%%% basic parameters %%%%%%%%%%%%%%%%
global theta_bound;
global threshold;
k=v_est/v_est(1);   
toa_bias=0;
N=400; resolution=2e-4;
%%%%%%%%%%%%% intermediate parameters %%%%%%%%%%%%%%
flag1=1;flag2=1;
dist_3D=sqrt(dist_2D.^2+h_est^2);
%%%%%%%%%%%%%%% recording data %%%%%%%%%%%%%%%%
tmp=1e5*ones(2,N+N+2);%第一行是距离，第二行是时间


%%%%%%%%%%%%%%% searching %%%%%%%%%%%%%%%%
for i=1:3
    %%%%%%%%%%%%%% re_initialize the parameters %%%%%%%%%%%%%%%%%%
    T_one_dir=0;
    tmp=1e5*ones(2,N+N+2);%第一行是距离，第二行是时间
    flag1=1;flag2=1;
    for j=1:N
        if flag1 %%%%%%%%% 左边滴 %%%%%%%%%%%%%
            [dist1,t_total1]=fraction_sim(v_est,k,theta_est(i)-j*resolution,h_est,H_sample);
            tmp(1,N-j+1)=abs(dist1-dist_2D(i));              tmp(2,N-j+1)=t_total1;
%         	plot(theta_est(i)-j*resolution,abs(dist1-dist_2D(i)),'*'); hold on                
        end
        if flag2 %%%%%%%%% 右边滴 %%%%%%%%%%%%%
            if (theta_est(i)+j*resolution)>theta_bound
                tmp(1,N+j)=0;
                tmp(2,N+j)=dist_3D(i)/mean(v_est);
                T_one_dir=tmp(2,N+j);
                break;
            end
            [dist2,t_total2]=fraction_sim(v_est,k,theta_est(i)+j*resolution,h_est,H_sample);
            tmp(1,N+j)=abs(dist2-dist_2D(i));          tmp(2,N+j)=t_total2;
%             plot(theta_est(i)+j*resolution,abs(dist2-dist_2D(i)),'*'); hold on           
        end
        %%%%%%%%%%%%%% if the lowest point %%%%%%%%%%%%%%%
        if j>2
            if (tmp(1,N+j-1)<tmp(1,N+j))&&(tmp(1,N+j-1)<tmp(1,N+j-2))&&flag1
                T_one_dir=tmp(2,N+j-1);
                break;             
            end
            if (tmp(1,N+2-j)<tmp(1,N+1-j))&&(tmp(1,N+2-j)>tmp(1,N+3-j))
                    flag1=0;
            end
                
            if (tmp(1,N+2-j)<tmp(1,N+1-j))&&(tmp(1,N+2-j)<tmp(1,N+3-j))&&flag2
                T_one_dir=tmp(2,N+2-j);
                break;
            end
            if (tmp(1,N+j-1)<tmp(1,N+j))&&(tmp(1,N+j-1)>tmp(1,N+j-2))
                flag2=0;
            end
        end
        %%%%%%%%%%%%%% if t_total1 %%%%%%%%%%%%%%%
        if abs(dist1-dist_2D(i))<threshold 
            T_one_dir=t_total1;
            break;
        end
        %%%%%%%%%%%%%% if t_total2 %%%%%%%%%%%%%%%
        if abs(dist2-dist_2D(i))<threshold
            T_one_dir=t_total2;
            break;
        end
        if flag1==0 && flag2 ==0
            [~, b]=min(tmp(1,:));
            T_one_dir=tmp(2,b);
            break;
        end
    end
    if T_one_dir==0
        [~, b]=min(tmp(1,:));
        T_one_dir=tmp(2,b);
    end
    toa_bias=toa_bias+abs(Toa(i)-T_one_dir);
end

end













