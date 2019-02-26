warning off all
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the system parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% node position info %%%%%%%%%%%
nodes=zeros(4,3);
R=1000;  pos=[-R,1.5*R,-R,1.5*R];
A=[0,0,0];
B=[R+R*rand()*0.2,R*rand()*0.2,0];  xb=B(1);    yb=B(2);    nodes(2,:)=B;
C=[R*rand()*0.2,R+R*rand()*0.2,0];  xc=C(1);    yc=C(2);    nodes(3,:)=C;

%%%%%%%%%%% acoustic info %%%%%%%%%%
v_acou=make_acou(1500,1000,1);   %make layered acoustic based on others work
fs=8000; %acoustic sample/transmit  rate  

%%%%%%%%%%% UAV info %%%%%%%%%%
H_sample=4; % distrance between every sample
acoustic_est_error=0;  % half error
Toa_est_error=35e-3;       % half error
h_error=0;             % half error 
search_range=50;        % search range during the location time
locat_resolution=1;     % precision of location
search_method=1;          % 1:numberation method    2: average method  
v_guess=1510:1530;           
%%%%%%%%%%% ToA estimation info %%%%%%%%%%
yanchiMax=0;    t_rec=1;    t_multi=0.5; 
T_B=0.15;       B_noise=0.6;%gusty noise distribution

%%%%%%%%%%%% fraction simulation info %%%%%%%%%%%%%%%
global threshold;
threshold=1;
global theta_bound;
theta_bound=1.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the simulation flag %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
whetherPlot=0;
ifTR_based_ToA=0;
whetherSearch=0;    %1 means square %%%%%%%  2 means DE
WhetherDivide=0;
error_detection=true;      % 1 means open the big error detection protocol

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the intermediate variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_est=zeros(1,3); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  simulation setup  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simnum=2000;
%%%%%%%% plot initialize %%%%%%%%%%%
if whetherPlot
figure(1); %% show the physical location of all nodes
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the record parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error=zeros(simnum,length(v_guess));
for num_v_guess=1:length(v_guess)
    for simInd=1:simnum
        simInd
        %%%%%%%%%% initialize the unlocated node %%%%%%%%%%%%%%%%%%
        S=R*rand(1,3); h=S(3); S_est(3)=h+2*h_error*rand()-h_error;  nodes(4,:)=S;   
        [v_est,H_layer]=est_acou(S_est(3),v_acou,H_sample,acoustic_est_error); % estimated velocity distribution by AUV
    %     v_guess=v_est(end);
        %%%%%%%%%% visualize the locations of all nodes %%%%%%%%%%%%%%%%%%
        if whetherPlot
        set(groot,'CurrentFigure',1);
        shownodes(nodes(1:3,:),pos,'b','anchor nodes')
        hold on
        shownodes(nodes(4,:),pos,'r','UL node')
        hold on
        end

        %%%%%%%%%% real ToA and corresponding channel in the world %%%%%%%%%%%%%%%%%%
        Toa_r=real_world_ToA(nodes,v_acou);
    %     chanel=makeChannel(nodes,Toa_r,fs); % 3 channels of SA,SB,SC

        %%%%%%%%%% estimated ToA %%%%%%%%%%%%%%%%%%
        if ifTR_based_ToA
    %         Toa_e=TR_ToA();
        else
            Toa_e=est_ToA(Toa_r,Toa_est_error);
        end

        %%%%%%%%%% localization %%%%%%%%%%%%%%%%%%
        %%%%%%%%%%% divide based coarsely estimation %%%%%%%%%%%%%%%%%
        if WhetherDivide
            [x_c,y_c]=findXY(nodes(1,:),nodes(2,:),nodes(3,:),R,Toa_e(1),Toa_e(2),Toa_e(3),h);
        else
            [x_c,y_c,R_est]=tritangle(nodes(1:3,:),Toa_e,v_guess(num_v_guess),S_est(3));
        end
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
            end
        end

        %%%%%%%%%% plot the estimated results %%%%%%%%%%%%%%%%%%
        if whetherPlot
            hold on;       shownodes(S_est,pos,'g',' ');
            axis(pos);  hold off
        end
        %%%%%%%%%%%%%%%%%%%%%%% record the simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        sjj_tmp=sum((S-S_est).^2);
        error(simInd,num_v_guess)=sjj_tmp;

         %%%%%%%%%%%%%%%%%%%%%%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if (isnan(sjj_tmp) & error_detection)
              shenmeguia
         end
    %     S
    %     S_est

    end
end
%%%%%%%%%%%%%%%%%% deal with simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%
error=sqrt(error);      
% visualize the results (plots)
















