function v_acou = make_acou(H,dh)
% simulate the real underwater acoustic speed distribution
% H always choose to be larger than 1000
N=round(H/dh);
v_acou=zeros(1,N);
for i=1:700
    v_acou(i)=1550-0.1*i;
end
for i=701:N
    v_acou(i)=1480+0.014*(i-700);
end
end

