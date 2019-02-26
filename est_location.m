function [x_b,y_b,x_c,y_c,R_est] = est_location(anchor,h_est,Toa,v_est,resolution,search_range)
% location estimation based on Toa
[anchorNum,b]=size(anchor);
%%%%%%%%%%%% coarsely estimate %%%%%%%%%%%%%
v_max=max(v_est);   
R_est=v_max*Toa;    R_est=sqrt(R_est.^2-h_est^2);
% set(groot,'CurrentFigure',1);
% hold on
% showrange(anchor,R_est)
% hold on
%%%%%% estimate the crosspoint to determine the range %%%%%%
[x1,y1]=crosspoint(anchor(1,:),anchor(2,:),R_est(1),R_est(2));
% plot(x1,y1,'*'); hold on
[x2,y2]=crosspoint(anchor(1,:),anchor(3,:),R_est(1),R_est(3));
% plot(x2,y2,'*'); hold on
[x3,y3]=crosspoint(anchor(3,:),anchor(2,:),R_est(3),R_est(2));
% plot(x3,y3,'*'); hold on
[x_b,y_b,x_c,y_c]=determine_area(x1,y1,x2,y2,x3,y3,resolution,search_range);
% for i=1:length(x_b)
%     plot(x_b(i)*ones(1,length(y_b)),y_b,'o')
%     hold on
% end

%%%%%%% find the precise point by searching %%%%%%

end

function [x,y]=crosspoint(node1,node2,r1,r2)
r_xy=sqrt(sum((node1-node2).^2));
theta1=atan((node2(2)-node1(2))/(node2(1)-node1(1)));%initial angle with n1 and n2
theta2=acos((r1^2+r_xy^2-r2^2)/(2*r1*r_xy));%changing angle with r1 and r2
te_res1=theta1+theta2;
te_res2=theta1-theta2;
x=[node1(1)+r1*cos(te_res1), node1(1)+r1*cos(te_res2)];
y=[node1(2)+r1*sin(te_res1), node1(2)+r1*sin(te_res2)];
end

function [x_b,y_b,x_center,y_center]=determine_area(x1,y1,x2,y2,x3,y3,resolution,search_range)
xMin=1e5;     yMin=1e5; 
rec=zeros(1,3);
%%%%%%%%%% determine the parameters of area %%%%%%%%%%%
for i=1:2
   for j=1:2
        for k=1:2
            xMin_com=max([x1(i),x2(j),x3(k)])-min([x1(i),x2(j),x3(k)]);
            yMin_com=max([y1(i),y2(j),y3(k)])-min([y1(i),y2(j),y3(k)]);
            if ((xMin_com+yMin_com)<(xMin+yMin))
                xMin=xMin_com;      yMin=yMin_com;
                rec=[i j k];
            end
        end
   end
end
%%% print the results %%%
x_center=(x1(rec(1))+x2(rec(2))+x3(rec(3)))/3;
y_center=(y1(rec(1))+y2(rec(2))+y3(rec(3)))/3;

x_b=[-search_range:resolution:search_range]+x_center;
y_b=[-search_range:resolution:search_range]+y_center;
end





