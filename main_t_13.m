warning off all
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the system parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% node position info %%%%%%%%%%%
nodes=zeros(5,3);
R=1000;  pos=[-R,1.5*R,-R,1.5*R];
A=[0,0,0];
B=[R+R*rand()*0.2,R*rand()*0.2,0];  xb=B(1);    yb=B(2);    nodes(2,:)=B;
C=[R*rand()*0.2,R+R*rand()*0.2,0];  xc=C(1);    yc=C(2);    nodes(3,:)=C;
D=[R*rand()*0.2,R*rand()*0.2,R+R*rand()*0.2];  xd=D(1);    yd=D(2);    nodes(4,:)=D;

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
% Toa_est_error=0e-3;
% Toa_est_error=1e-4*(0:5:100);
h_error=0;             % half error 
Tt=0;
locat_resolution=1;     % precision of location
v_guess=1517;           


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the simulation flag %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
whetherPlot=0;
error_detection=1;      % 1 means open the big error detection protocol

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the intermediate variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_est=zeros(1,3); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  simulation setup  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simnum=1000;
%%%%%%%% plot initialize %%%%%%%%%%%
if whetherPlot
figure(1); %% show the physical location of all nodes
figure(2);  %% show the search result
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the record parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error=zeros(simnum,length(Toa_est_error));
tim_rec=zeros(simnum,length(Toa_est_error));

for t_ind=1:length(Toa_est_error)
    for simInd=1:simnum
        [t_ind,simInd]
        tic
        %%%%%%%%%% initialize the unlocated node %%%%%%%%%%%%%%%%%%
        S=R*rand(1,3);  %S(3)=0.6*R+0.4*R*rand();
        S(3)=20*rand();
        dsa=sqrt(sum((S-A).^2));    dsb=sqrt(sum((S-B).^2));    dsc=sqrt(sum((S-C).^2));   dsd=sqrt(sum((S-D).^2)); 
        h=S(3); S_est(3)=h+2*h_error*rand()-h_error;  nodes(5,:)=S;   
        [v_est,H_layer]=est_acou(S_est(3),v_acou,H_sample,acoustic_est_error); % estimated velocity distribution by AUV
        %%%%%%%%%% visualize the locations of all nodes %%%%%%%%%%%%%%%%%%
        if whetherPlot
        set(groot,'CurrentFigure',1);
        shownodes(nodes(1:3,:),pos,'b','anchor nodes')
        hold on
        shownodes(nodes(4,:),pos,'g','UL node')
        hold on
        end

        %%%%%%%%%% real ToA and corresponding channel in the world %%%%%%%%%%%%%%%%%%
%         Toa_r=real_world_ToA(nodes,v_acou);
        Toa_r=[dsa,dsb,dsc,dsd]/mean(v_est)+Tt;
%         Toa_r=[ToA_2nodes(A,S,v_acou),ToA_2nodes(B,S,v_acou),ToA_2nodes(C,S,v_acou),ToA_2nodes(D,S,v_acou)]+Tt;
%         sjj_tmp2=(S(1)-x_c)^2+(S(2)-y_c)^2;

        %%%%%%%%%% estimated ToA %%%%%%%%%%%%%%%%%%
        Toa_e=est_ToA(Toa_r,Toa_est_error(t_ind));
        
        %%%%%%%%%% localization %%%%%%%%%%%%%%%%%%
%         S_est=newton_iter(Toa_e,nodes(1:4,:),R,v_guess,nodes(5,:));
        %%%%%%%%%%%%%%% newton_iter2 is a advanced function %%%%%%%%%%%%%%%%%%%%
        S_est=newton_iter2(Toa_e,nodes(1:4,:),R,mean(v_est),nodes(5,:));
        sjj_tmp=sum((S-S_est).^2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot the temperal results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if whetherPlot
            set(groot,'CurrentFigure',1);
            hold on;       plot(x_c,y_c,'*');%         showrange(nodes(1:3,:),R_est)    
        end

        %%%%%%%%%% plot the estimated results %%%%%%%%%%%%%%%%%%
        if whetherPlot
            set(groot,'CurrentFigure',1);
            hold on;       plot(S_est(1),S_est(2),'o');
            axis(pos);  hold off
        end
        %%%%%%%%%%%%%%%%%%%%%%% record the simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
        error(simInd,t_ind)=sjj_tmp;
        tim_rec(simInd,t_ind)=toc;
         %%%%%%%%%%%%%%%%%%%%%%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if (~isreal(sjj_tmp) && error_detection)
              shenmeguia
         end
    %     S
    %     S_est

    end
%%%%%%%%%%%%%%%%%% deal with simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%
end
error=sqrt(error);      
















