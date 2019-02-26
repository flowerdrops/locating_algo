warning off all
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the system parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% node position info %%%%%%%%%%%
nodes=zeros(4,3);
R=200;  pos=[-R,1.5*R,-R,1.5*R];
A=[0,0,0];
B=[R+R*rand()*0.2,R*rand()*0.2,0];  xb=B(1);    yb=B(2);    nodes(2,:)=B;
C=[R*rand()*0.2,R+R*rand()*0.2,0];  xc=C(1);    yc=C(2);    nodes(3,:)=C;

%%%%%%%%%%% acoustic info %%%%%%%%%%
v_acou=make_acou(1200,1);   %make layered acoustic based on others work
fs=8000; %acoustic sample/transmit  rate  

%%%%%%%%%%%% fraction simulation info %%%%%%%%%%%%%%%
global threshold;
threshold=1;
global theta_bound;
theta_bound=1.5;
global theta_bound_sim;
theta_bound_sim=1.5;
global search_bound;
search_bound=80;
global w_t;     global w_v;
w_t=1;      w_v=1e-3;
%%%%%%%%%%% UAV info %%%%%%%%%%
H_sample=2; % distrance between every sample
acoustic_est_error=0;  % half error
Toa_est_error=[0,1e-3,2e-3,4e-3,8e-3,16e-3];       % half error
% Toa_est_error=160e-4;
% Toa_est_error=1e-3*(0:2:36);
h_error=0;             % half error 
search_range=50;        % search range during the location time
locat_resolution=1;     % precision of location
v_guess=1517;           
%%%%%%%%%%% ToA estimation info %%%%%%%%%%
yanchiMax=0;    t_rec=1;    t_multi=0.5; 
T_B=0.15;       B_noise=0.6;%gusty noise distribution

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the simulation flag %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
whetherPlot=0;
ifTR_based_ToA=0;
whetherSearch=3;    %1 means square %%%%%%%  2 means DE   %%%%%%%%%%%% 3 means SDM
WhetherDivide=1;
error_detection=1;      % 1 means open the big error detection protocol

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the intermediate variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_est=zeros(1,3); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  simulation setup  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simnum=2000;
%%%%%%%% plot initialize %%%%%%%%%%%
if whetherPlot
figure(1); %% show the physical location of all nodes
figure(2);  %% show the search result
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the record parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error=zeros(simnum,length(Toa_est_error));
tim_rec=zeros(simnum,length(Toa_est_error));
if whetherSearch~=0
    error_origin=zeros(simnum,length(Toa_est_error));
end
for t_ind=1:length(Toa_est_error)
    for simInd=1:simnum
        [t_ind,simInd]
        
        tic
        %%%%%%%%%% initialize the unlocated node %%%%%%%%%%%%%%%%%%
        S=R*rand(1,3);  %S(3)=0.6*R+0.4*R*rand();
        S(3)=20*rand();
%         S=  [227.1,  914.6,  603.8];
        dsa=sqrt(sum((S-A).^2));    dsb=sqrt(sum((S-B).^2));    dsc=sqrt(sum((S-C).^2));    
        h=S(3); S_est(3)=h+2*h_error*rand()-h_error;  nodes(4,:)=S;   
        [v_est,H_layer]=est_acou(S_est(3),v_acou,H_sample,acoustic_est_error); % estimated velocity distribution by AUV
    %     v_guess=v_est(end);
        %%%%%%%%%% visualize the locations of all nodes %%%%%%%%%%%%%%%%%%
        if whetherPlot
        set(groot,'CurrentFigure',1);
        shownodes(nodes(1:3,:),pos,'b','anchor nodes')
        hold on
        shownodes(nodes(4,:),pos,'g','UL node')
        hold on
        end

        %%%%%%%%%% real ToA and corresponding channel in the world %%%%%%%%%%%%%%%%%%
        Toa_r=[dsa,dsb,dsc]/est_velocity_ba(v_est);
    %     chanel=makeChannel(nodes,Toa_r,fs); % 3 channels of SA,SB,SC

        %%%%%%%%%% estimated ToA %%%%%%%%%%%%%%%%%%
        if ifTR_based_ToA
    %         Toa_e=TR_ToA();
        else
            Toa_e=est_ToA(Toa_r,Toa_est_error(t_ind));
        end

        %%%%%%%%%% localization %%%%%%%%%%%%%%%%%%
        %%%%%%%%%%% divide based coarsely estimation %%%%%%%%%%%%%%%%%
        if WhetherDivide
            [x_c,y_c]=findXY(nodes(1,:),nodes(2,:),nodes(3,:),R,Toa_e(1),Toa_e(2),Toa_e(3),h);
        else
            [x_c,y_c,R_est]=tritangle(nodes(1:3,:),Toa_e,mean(v_est),S_est(3));
        end
%          sjj_tmp2=(S(1)-x_c)^2+(S(2)-y_c)^2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot the temperal results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if whetherPlot
            set(groot,'CurrentFigure',1);
            hold on;       plot(x_c,y_c,'*');%         showrange(nodes(1:3,:),R_est)    
        end
        if whetherSearch==0
            S_est(1)=x_c;   S_est(2)=y_c;
        end
        if whetherSearch==1
            [S_est(1),S_est(2)]=search_space_square(x_c,y_c,nodes(1:3,:),S_est(3),Toa_e,v_est,H_sample);
        else if whetherSearch==2
            [S_est(1),S_est(2)]=search_space_DE(x_c,y_c,nodes(1:3,:),S_est(3),Toa_e,v_est,H_sample);
            else if whetherSearch==3
                    [S_est(1),S_est(2)]=search_space_SDM(x_c,y_c,nodes(1:3,:),S_est(3),Toa_e,v_est,H_sample);
                end
            end
        end
        sjj_tmp=sum((S-S_est).^2);
        %%%%%%%%%% plot the estimated results %%%%%%%%%%%%%%%%%%
        if whetherPlot
            set(groot,'CurrentFigure',1);
            hold on;       plot(S_est(1),S_est(2),'o');
            axis(pos);  hold off
        end
        %%%%%%%%%%%%%%%%%%%%%%% record the simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
%         [sjj_tmp,sjj_tmp2]
        error(simInd,t_ind)=sjj_tmp;
        tim_rec(simInd,t_ind)=toc;
%         error_origin(simInd,t_ind)=sjj_tmp2;
         %%%%%%%%%%%%%%%%%%%%%%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if (sjj_tmp>400000 && error_detection)
              shenmeguia
         end
    %     S
    %     S_est

    end
%%%%%%%%%%%%%%%%%% deal with simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%
end
error=sqrt(error);      
error_origin=sqrt(error_origin);
save('exhaustion_t')
% system('shutdown -s')
% visualize the results (plots)
















