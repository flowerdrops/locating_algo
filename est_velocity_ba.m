function v_ba = est_velocity_ba(v_est)
%EST_VELOCITY_BA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
a=length(v_est);
res=0;
for i=1:a
    res=res+1/v_est(i);
end
v_ba=1/(res/a);
end

