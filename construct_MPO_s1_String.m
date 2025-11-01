function oooMPO = construct_MPO_s1_String(s)

% s1  exp(i pi s2)  exp(i pi s3)  exp(i pi s4)  exp(i pi s5)  exp(i pi s6) sn
% s1  Omega2  Omega3  Omega4  Omega5  Omega6 sn
% in the form of ol-oi-oi-oi-or; 
% only ol,oi,or are stored.

l  = 1;
mid= 2;
r  = 3;

Omega = expm(1i*pi*s);

ol = zeros(3,3,1,1);
oi = zeros(3,3,1,1);
or = zeros(3,3,1,1);

ol(:,:,1,1) = s;
oi(:,:,1,1) = Omega;
or(:,:,1,1) = s;

oooMPO{ l } = ol;
oooMPO{mid} = oi;
oooMPO{ r } = or;

end