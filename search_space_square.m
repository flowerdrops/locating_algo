function [x_est,y_est,bias_est]=search_space_square(x_c,y_c,anchor,h_est,Toa,v_est,H_sample)
global search_bound;
%%%%%%%%% enumeration method %%%%%%%%%
    %%%%% initialize the basic parameters %%%%
    resolution=2; range=50;
    x_est=x_c;    y_est=y_c;    bias_est=1e5;
%%%%%%%%%%%%%% special case %%%%%%%%%%%%%%%%%%%%%
    if h_est<search_bound
        return;
    end
    %%%%%%%%%% recording data %%%%%%%%%%%
	toa_bias_total=1e5*ones(range+range+1,range+range+1);
%     tic
    for i=-range:range
        for j=-range:range
%             [i j]
            x_tmp=x_c+i*resolution;     y_tmp=y_c+j*resolution;
            a1=(anchor(:,1)-x_tmp).^2;  a2=(anchor(:,2)-y_tmp).^2;   dist_2D=sqrt(a1+a2);
            theta_est=atan(dist_2D./h_est); 
            toa_bias_total(i+range+1,j+range+1)=testlikely(dist_2D,theta_est,h_est,v_est,H_sample,Toa);
        end
    end
%     toc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% manage simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%
%     set(groot,'CurrentFigure',2);
    mesh(toa_bias_total)
     for i=-range:range
        for j=-range:range
            if toa_bias_total(i+range+1,j+range+1)<bias_est
                bias_est=toa_bias_total(i+range+1,j+range+1);
                x_est=x_c+i*resolution;     y_est=y_c+j*resolution;
            end
        end
    end
end


















