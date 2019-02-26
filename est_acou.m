function [v_est,H_est_layer]  = est_acou( H,v_acou,H_sample,acoustic_est_error )
% estimated acoustic speed achieved by AUV
H_est_layer=1:H_sample:H;
SamNum=length(H_est_layer);
v_est=zeros(size(H_est_layer));
for i=1:SamNum
    v_est(i)=v_acou(round(H_est_layer(i)))+2*acoustic_est_error*rand()-acoustic_est_error;
end
if SamNum==0
    v_est=v_acou(1);    H_est_layer=1;
end
end

