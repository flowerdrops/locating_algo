function res=toa_straight(A,B,v_acou)
    dis=sqrt(sum((A-B).^2));
    t1=min(abs(A(3))+1,abs(B(3))+1);
    t2=max(abs(A(3))+1,abs(B(3))+1);
    velo=est_velocity_ba(v_acou(t1:t2));
% velo=1550;
    res=dis/velo;
end
