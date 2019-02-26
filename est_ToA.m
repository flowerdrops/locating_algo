function Toa_e = est_ToA(Toa_r,Toa_est_error)
% estimated Toa by UAV
Toa_e=Toa_r+2*Toa_est_error*rand(size(Toa_r))-Toa_est_error;
end






