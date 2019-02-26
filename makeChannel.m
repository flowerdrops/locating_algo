function channel = makeChannel( nodes,Toa_r,fs )
% make a human-made channel of real underwater world
chanel1=makeOneChannel(Toa_r(1),fs);
chanel2=makeOneChannel(Toa_r(2),fs);
chanel3=makeOneChannel(Toa_r(3),fs);
chanel_Len=max([length(chanel1),length(chanel2),length(chanel3)]);
channel=zeros(3,chanel_Len);
channel(1,1:length(chanel1))=chanel1;
channel(1,1:length(chanel2))=chanel2;
channel(1,1:length(chanel3))=chanel3;
end

