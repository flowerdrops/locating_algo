function shownodes( nodes,pos,s,node_type )
% plot the nodes in 2D graph
[nodesNum,b]=size(nodes);
node_radius=1;
ang=0:0.1:2*pi;
ang_x=cos(ang);     ang_y=sin(ang);
for i=1:nodesNum
    x=nodes(i,1)+node_radius*ang_x;
    y=nodes(i,2)+node_radius*ang_y;
    plot(x,y)
    fill(x,y,s)
    text(nodes(i,1)+30,nodes(i,2),node_type)
    hold on
end
axis(pos)
end

