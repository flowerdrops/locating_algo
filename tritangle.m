function [x_est,y_est,R_est] = tritangle(anchor, Toa,v_guess,h_est)
% location estimation based on Toa
%%%%%%%%%%%% coarsely estimate %%%%%%%%%%%%%
v_max=v_guess;   
R_est=v_max*Toa;    R_est=real(sqrt(R_est.^2-h_est^2));
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
[x_est,y_est]=determine_xy(x1,y1,x2,y2,x3,y3);
% for i=1:length(x_b)
%     plot(x_b(i)*ones(1,length(y_b)),y_b,'o')
%     hold on
% end

end



function [x_b,y_b]=determine_xy(x1,y1,x2,y2,x3,y3)
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
x_b=(x1(rec(1))+x2(rec(2))+x3(rec(3)))/3;
y_b=(y1(rec(1))+y2(rec(2))+y3(rec(3)))/3;
end

