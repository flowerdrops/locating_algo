clear all
close all
clc
%basic parameters
h=0.1; %depth of every layer
H=100; %depth of node
N=H/h;
% k=linspace(1,1.05,N);
k=linspace(1,0.95,N);
v0=1500;

% parameters need to be change
step_num=100;
theta=linspace(pi*0.1,pi*0.45,step_num);
v_average=[];
v_horizon=[];
v_straight=[];
for ii=1:step_num
    ct=cos(theta(ii));
    t_total=0; L_total=0; L_horizon=0;

    % tmp parameter
    ct_tmp=ct;  v_tmp=v0;
    %recording parameter
    x=[]; v_rec=[];
    for i=1:N
        ct_tmp=ct*sqrt(k(i)^2+(1-k(i)^2)/ct^2);
        v_tmp=v0*k(i);      v_rec=[v_rec,v_tmp];
        t_total=t_total+h/(v_tmp*ct_tmp);
        L_total=L_total+h/ct_tmp;
        L_horizon=L_horizon+h*sqrt(1-ct_tmp^2)/ct_tmp;
        x=[x,L_horizon];

    end
    v=L_total/t_total;
    v_h=L_horizon/t_total;
    v_average=[v_average v];        v_horizon=[v_horizon,v_h];
    v_straight=[v_straight,sqrt(H^2+L_horizon^2)/t_total];
    % plot(x,h*(1:N))
    % hold on
    % plot(h*(1:N)/tan(theta),h*(1:N),'--')
end

plot(theta*180/pi,v_average,'r--')
hold on
plot(theta*180/pi,v_straight)
axis([0,90,1450 1480])
% axis([0,90,1530 1550])
xlabel('theta')
ylabel('velocity')
title(['k=',num2str(k(end))])


% plot(theta*180/pi,v_average/v0)
% xlabel('theta')
% ylabel('velocity(ratio)')
% title(['k=',num2str(k(end))])
% axis([0 90 0.96 1.04])
% hold on
% plot(1:90,ones(1,90),'-.')

% plot(theta*180/pi,v_horizon/v0)
% xlabel('theta')
% ylabel('horizon velocity(ratio)')
% title(['k=',num2str(k(end))])
% axis([0 90 0.2 1.04])
% hold on
% plot(1:90,ones(1,90),'-.')

% plot(theta*180/pi,v_horizon./sin(theta)/v0)
% xlabel('theta')
% ylabel('straight velocity(ratio)')
% title(['k=',num2str(k(end))])
% axis([0 90 0.9 1.07])
% hold on
% plot(1:90,ones(1,90),'-.')






