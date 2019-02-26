function [new_CIR]=makeOneChannel(toa1,fs)

toa1=D/v;       t_all=toa1*(3+6*rand());        t_step=toa1/10;
new_CIR=zeros(1,floor(t_all*fs));
new_CIR(floor(toa1*fs))=1;

%big Poission  determine the macro-multipath
t_mac=toa1;    ind_mac=t_mac;
lemda1=25;    gama1=0.5+0.07*rand();
while t_mac<t_all
    interval=t_step*poissrnd(lemda1);
    t_mac=t_mac+interval;
    ind_mac=[ind_mac,t_mac];
end
mac_num=length(ind_mac);

% small Poission-----micropath
lemda2=2;   gama2=1+rand();
for i=1:mac_num
    %random micropath number 4~6
    mic_num=4+floor(3*rand());      gama2=0.1;
    t_mic=0;  
    for j=1:mic_num            
        new_CIR(floor((t_mic+ind_mac(i))*fs))=exp(-(ind_mac(i)-toa1)/gama1)*exp(-t_mic/gama2);
        interval=rand()*t_step*poissrnd(lemda1);
        t_mic=t_mic+interval;                
    end
end
new_CIR=0.5*new_CIR;
new_CIR=new_CIR(1:floor(fs*t_all));
% plot((1:length(new_CIR))/fs,new_CIR)
end















