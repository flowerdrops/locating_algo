warning off all
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the system parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% node position info %%%%%%%%%%%
nodes=zeros(4,3);
R=30;  pos=[-R,1.5*R,-R,1.5*R];
A=[0,0,0];
B=[R 0 0];  xb=B(1);    yb=B(2);    nodes(2,:)=B;
C=[0 R 0];  xc=C(1);    yc=C(2);    nodes(3,:)=C;
D=[0 0 -R]; xd=D(1);    yd=D(2);    nodes(4,:)=D;
dtb=0.1;    dtc=0.1;    dtd=0.1;% delta t of anchor node B,C,D

%%%%%%%%%%% acoustic info %%%%%%%%%%
v_acou=make_acou(1.2*R,1);   %make layered acoustic based on others work

%%%%%%%%%%% UAV info %%%%%%%%%%
Toa_est_error=8e-3;       % half error


% v_guess=1510:1530;  
% v_guess=1520;
%%%%%%%%%%% ToA estimation info %%%%%%%%%%
yanchiMax=0;    t_rec=1;    t_multi=0.5; 
T_B=0.15;       B_noise=0.6;%gusty noise distribution

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% determine the simulation flag %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
whetherPlot=0;
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
error=zeros(simnum,1);
    for simInd=1:simnum        
        simInd
        I=1; % number of iteration
        S=R*rand(1,3);  %S(3)=-S(3);   
        S(3)=20*rand();
        v_guess=mean(v_acou(1:floor(S(3)+1)));
%         v_guess=1550;
%         S=[500,200,-800];
        %%%%%%%%%%%%%% determine the distance %%%%%%%%%%%%%%%%%%%%%
        d_ab=sqrt(sum((A-B).^2));     d_ac=sqrt(sum((A-C).^2));     d_ad=sqrt(sum((A-D).^2));
        d_bc=sqrt(sum((B-C).^2));     d_cd=sqrt(sum((C-D).^2)); 
        d_sa=sqrt(sum((S-A).^2));     d_sb=sqrt(sum((S-B).^2));     d_sc=sqrt(sum((S-C).^2));     d_sd=sqrt(sum((S-D).^2));
        %%%%%%%%%% initialize the TDoA process %%%%%%%%%%%%%%%%%%
        tB=zeros(I);    tC=zeros(I);    tD=zeros(I);    
        tBb=zeros(I);    tCc=zeros(I);    tDd=zeros(I); 
        t1=zeros(I);    t2=zeros(I);    t3=zeros(I);    t4=zeros(I);
        kk=zeros(I,3);
        %%%%%%%%%% visualize the locations of all nodes %%%%%%%%%%%%%%%%%%
        if whetherPlot
        set(groot,'CurrentFigure',1);
        shownodes(nodes(1:4,:),pos,'b','anchor nodes')
        hold on
        shownodes(S,pos,'r','UL node')
        hold on
        end

        %%%%%%%%%%%%%%%% start the show %%%%%%%%%%%%%%%%%%%%
        for i=1:I
            %%%%%%%%%%%%%% A beacon %%%%%%%%%%%%%%             
            tB(i)=toa_straight( A,B,v_acou );
            %tB(i)=d_ab/v_guess(num_v_guess); 
            tD(i)=toa_straight( A,-D,v_acou );
            %tD(i)=d_ad/v_guess(num_v_guess);
            t1(i)=toa_straight( A,[S(1),S(2),-S(3)],v_acou );
            %t1(i)=d_sa/v_guess(num_v_guess);
            tC(i)=toa_straight( A,C,v_acou );
            %tC(i)=d_ac/v_guess(num_v_guess);
            
            %%%%%%%%%%%%%% B beacon %%%%%%%%%%%%%% 
            tBb(i)=tB(i)+dtb;   
            t2(i)=tBb(i)+toa_straight( B,[S(1),S(2),-S(3)],v_acou );%tBb(i)+d_sb/v_guess(num_v_guess);
            
            %%%%%%%%%%%%%% C beacon %%%%%%%%%%%%%% 
            tCc(i)=tBb(i)+toa_straight( C,B,v_acou );%tBb(i)+d_bc/v_guess(num_v_guess)+dtc;               
            t3(i)=tCc(i)+toa_straight( C,[S(1),S(2),-S(3)],v_acou );%d_sc/v_guess(num_v_guess);
            
            %%%%%%%%%%%%%% D beacon %%%%%%%%%%%%%% 
            tDd(i)=tCc(i)+toa_straight( -D,C,v_acou );
%             tDd(i)=tCc(i)+d_cd/v_guess(num_v_guess)+dtd;   
            t4(i)=tDd(i)+toa_straight( -D,[S(1),S(2),-S(3)],v_acou );
%             t4(i)=tDd(i)+d_sd/v_guess(num_v_guess);

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            t1(i)=est_ToA(t1(i),Toa_est_error);
            t2(i)=est_ToA(t2(i),Toa_est_error);
            t3(i)=est_ToA(t3(i),Toa_est_error);
            t4(i)=est_ToA(t4(i),Toa_est_error);
            
            
            t=[t1(i),t2(i),t3(i),t4(i)];
            dt1=t2(i)-t1(i);    dt2=t3(i)-t1(i);    dt3=t4(i)-t1(i);
            delta_tB=tBb(i)-tB(i);      delta_tC=tCc(i)-tC(i);      delta_tD=tDd(i)-tD(i);
            kk(i,1)=v_guess*dt1-v_guess*delta_tB-d_ab;  
            kk(i,2)=v_guess*dt2-v_guess*delta_tC-d_ac;  
            kk(i,3)=v_guess*dt3-v_guess*delta_tD-d_ad;
        end
        %%%%%%%%%%%%%%% determine the k1 k2 k3 and give the result %%%%%%%%%%%%%%%
        k1=sum(kk(:,1))/I; 
        k2=sum(kk(:,2))/I;  
        k3=sum(kk(:,3))/I; 
        [S_est(1),S_est(2),S_est(3),dsa]=deter_dis(k1,k2,k3,A,B,C,D);
%         S
%         S_est
        %%%%%%%%%% plot the estimated results %%%%%%%%%%%%%%%%%%
        if whetherPlot
            hold on;       shownodes(S_est,pos,'g',' ');
            axis(pos);  hold off
        end
        %%%%%%%%%%%%%%%%%%%%%%% record the simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        sjj_tmp=sum((S-S_est).^2)
        error(simInd)=sjj_tmp;
         %%%%%%%%%%%%%%%%%%%%%%% for debug %%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if (isnan(sjj_tmp) & error_detection)
              shenmeguia
         end

    end
%%%%%%%%%%%%%%%%%% deal with simulation results %%%%%%%%%%%%%%%%%%%%%%%%%%
error=sqrt(error);      
% visualize the results (plots)
















