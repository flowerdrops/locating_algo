function [S,T]=newton_iter2(Toa,nodes,R,v_guess,real_node)
%     X=[real_node];
    X=[R/2,R/2,R/2,0];
%     real_node
    g=zeros(4,1);
    Jg=zeros(4,3);
    %%%%%%%%%%%%%% simulation parameters %%%%%%%%%%%%%%%
    Iter_num=20;    K=1;
    %%%%%%%%%%%% start the simulation %%%%%%%%%%%
    for IterInd=1:Iter_num 
%         X
        S=X(1:3);
        yita=nodes-S; 
        for i=1:4
        g(i)=sum((nodes(i,:)-S).^2)-v_guess^2*(Toa(i)-X(4))^2;
        Jg(i,4)=2*v_guess^2*(Toa(i)-X(4));
        end
        Jg(:,1:3)=-2*yita;
        tmp=pinv(Jg)*g;
        X=X-K*tmp';
%         hold on
%         plot(IterInd,sum((S-real_node).^2),'*')
%         plot(IterInd,g,'*')
    end
    
    
    S=X(1:3); T=X(4);
end