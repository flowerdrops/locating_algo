function [S,T]=newton_iter(Toa,nodes,R,v_guess,real_node)
%     X=[real_node];
    X=[R/2,R/2,R/2];
    real_node
    g=zeros(4,1);
    Jg=zeros(4,3);
    %%%%%%%%%%%%%% simulation parameters %%%%%%%%%%%%%%%
    Iter_num=10000;    K=1;
    %%%%%%%%%%%% start the simulation %%%%%%%%%%%
    for IterInd=1:Iter_num 
        X
        yita=nodes-X; 
        for i=1:4
        g(i)=sum((nodes(i,:)-X).^2)-v_guess^2*Toa(i)^2;
%         Jg(i,4)=2*v_guess^2*Toa(i);
        end
        Jg(:,1:3)=-2*yita;
        tmp=pinv(Jg)*g;
        X=X-K*tmp';
        hold on
        plot(IterInd,sum((X-real_node).^2),'*')
%         plot(IterInd,g,'*')
    end
    
    
    S=X(1:3); T=X(4);
end