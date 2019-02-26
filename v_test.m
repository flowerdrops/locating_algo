clear all
close all
clc
%basic parameters
% theta=pi*0.2;
% ct=cos(theta);
% h=1; %depth of every layer
% H=100; %depth of node
% N=H/h;
% k=linspace(1,1.05,N);
% v0=1500;
% t_total=0; L_total=0; L_horizon=0;
% 
% % tmp parameter
% ct_tmp=ct;  v_tmp=v0;
% %recording parameter
% x=[]; v_rec=[];
% for i=1:N
%     ct_tmp=ct*sqrt(k(i)^2+(1-k(i)^2)/ct^2);
%     v_tmp=v0*k(i);      v_rec=[v_rec,v_tmp];
%     t_total=t_total+h/(v_tmp*ct_tmp);
%     L_total=L_total+h/ct_tmp;
%     L_horizon=L_horizon+h*sqrt(1-ct_tmp^2)/ct_tmp;
%     x=[x,L_horizon];
%     
% end
% v=L_total/t_total;
% v_h=L_horizon/t_total
% L_straight=L_horizon/sin(theta);
% plot(x,h*(1:N))
% hold on
% plot(h*tan(theta)*(1:N),h*(1:N),'--')
% grid


%% N 为积分部数，h 为积分步长，其值视计算精度而定
%% x0 为初始值，可任意给定
%% Equfun(x)为非线性方程组表达式（列向量），
%% Jacobfun(x)为雅可比矩阵
N=100;
h=1/N;
x0=[0 0 0]';
x=x0;
%format long
f=Equfun(x);
b=-h*f;
for i=1:N
    A=Jacobfun(x);
    k1=inv(A)*b;
    A=Jacobfun(x+0.5*k1);
    k2=inv(A)*b;a
    A=Jacobfun(x+0.5*k2);
    k3=inv(A)*b;
    A=Jacobfun(x+0.5*k3);
    k4=inv(A)*b;
    x=x+(k1+2*k2+2*k3+k4)/6;
end
disp('The Solution is:')
disp('x=');disp(x);
 
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%下面是非线性方程组及其雅可比行列式
%%%%%%%%%%%%%%%%%%%%%%%%%
function y=Equfun(x)
%nonliner functions
y=[3*x(1)-cos(x(2)*x(3))-1/2;
   x(1)^2-81*(x(2)+0.1)^2+sin(x(3))+1.06;
   exp(-x(1)*x(2))+20*x(3)+(10*pi-3)/3];
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function y=Jacobfun(x)
%Jacobi function
%J=zeros(length(x));
y(1,1)=3;
y(1,2)=x(3)*sin(x(2)*x(3));
y(1,3)=x(2)*sin(x(2)*x(3));
y(2,1)=2*x(1);
y(2,2)=-162*(x(2)+0.1);
y(2,3)=cos(x(3));
y(3,1)=-x(2)*exp(-x(1)*x(2));
y(3,2)=-x(1)*exp(-x(1)*x(2));
y(3,3)=20;
end


























