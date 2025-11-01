function oooMPO = construct_MPO_s1_kinkOx( )

%define spin-1 operators: I, x,y,z, Omega, with size 3x3

s1_x = [0, 1, 0;  1, 0, 1;  0, 1, 0] ./ sqrt(2);
%s1_y = [0, 1, 0; -1, 0, 1;  0,-1, 0] ./ sqrt(2) ./ 1i;
%s1_z = [1, 0, 0;  0, 0, 0;  0, 0,-1];
s1_I = [1, 0, 0;  0, 1, 0;  0, 0, 1]; % identity matrix

s1_x_132 =[0, 0, 1; 0, 0, 1; 1, 1, 0] ./ sqrt(2);
s1_x_231 =[0, 1, 1; 1, 0, 0; 1, 0, 0] ./ sqrt(2);


%s1_x = s1_x_231;%

Omega = expm(1i*pi*s1_x);

% in the form of ol-oi-oi-oi-or; 
% only ol,oi,or are stored.

l  = 1;
mid= 2;
r  = 3;

ol=zeros(3,3,1,2);
oi=zeros(3,3,2,2);
or=zeros(3,3,2,1);


ol(:,:,1,1) = s1_x;
ol(:,:,1,2) = Omega;
 
or(:,:,1,1) = s1_I;
or(:,:,2,1) = s1_x;

oi(:,:,1,1) = s1_I;
oi(:,:,2,2) = Omega;
oi(:,:,2,1) = s1_x;

oooMPO{ l } = ol;
oooMPO{mid} = oi;
oooMPO{ r } = or;


end
