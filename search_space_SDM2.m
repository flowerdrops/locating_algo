function [x_est,y_est]=search_space_SDM(x_c,y_c,anchor,h_est,Toa,v_est,H_sample)
global search_bound;
%%%%%%%%% steepest descent method %%%%%%%%%
    
%%%%%%%%%%%%%% special case %%%%%%%%%%%%%%%%%%%%%
    if h_est<search_bound
        return;
    end
    %%%%% initialize the basic parameters %%%%
    resolution=1; range=50;   x_cnt=0;y_cnt=0;
    step=resolution*[1 0;1 1;0 1;-1 1;-1 0;-1 -1;0 -1;1 -1];
    x_est=x_c;    y_est=y_c;    
    bias=makebias(x_est,y_est,anchor,h_est,Toa,v_est,H_sample);
    x_tmp=x_est; y_tmp=y_est;
    flag_x1=1; flag_x2=1;   flag_y1=1;      flag_y2=1;
    bias_t=1e5*ones(8,1);
    while (x_cnt<range && y_cnt<range)
        for i=1:8
            x_tmp=step(i,1)+x_est;      y_tmp=step(i,2)+y_est;
            bias_t(i)=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%% decide for x %%%%%%%%%%%%%%%%%%%%%
        if flag_x1
            x_tmp=x_est-resolution;
            bias_t=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample);
            if bias<bias_t
                flag_x1=0;
            end
            if bias>bias_t
                x_est=x_tmp;            bias=bias_t;       flag_x2=0;
            end
        end
        if flag_x2
            x_tmp=x_est+resolution;
            bias_t=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample);
            if bias<bias_t
                flag_x2=0;
            end
            if bias>bias_t
                x_est=x_tmp;            bias=bias_t;       flag_x1=0;
            end
        end
        x_cnt=x_cnt+1;
        %%%%%%%%%%%%%%%% decide for y %%%%%%%%%%%%%%%%%%%%%
        if flag_y1
            y_tmp=y_est-resolution;
            bias_t=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample);
            if bias<bias_t
                flag_y1=0;
            end
            if bias>bias_t
                y_est=y_tmp;            bias=bias_t;       flag_y2=0;
            end
        end
        if flag_y2
            y_tmp=y_est+resolution;
            bias_t=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample);
            if bias<bias_t
                flag_y2=0;
            end
            if bias>bias_t
                y_est=y_tmp;            bias=bias_t;       flag_y1=0;
            end
        end
        y_cnt=y_cnt+1;
    end
end

function bias=makebias(x_tmp,y_tmp,anchor,h_est,Toa,v_est,H_sample)
    a1=(anchor(:,1)-x_tmp).^2;  a2=(anchor(:,2)-y_tmp).^2;   dist_2D=sqrt(a1+a2);
    theta_est=atan(dist_2D./h_est); 
    bias=testlikely(dist_2D,theta_est,h_est,v_est,H_sample,Toa);
end
















