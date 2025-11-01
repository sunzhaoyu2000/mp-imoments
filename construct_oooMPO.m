function oooMPO = construct_oooMPO(s)


paulixyz_sun; % sigma_I  sigma_x  sigma_y  sigma_z


% in the form of ol-oi-oi-oi-or; 
% only ol,oi,or are stored.

l=1
mid=2
r=3
A=1
B=2

ol=zeros(2,2,1,2);
or=zeros(2,2,2,1);
oi=zeros(2,2,2,2);

ol(:,:,1,1)=s;
ol(:,:,1,2)=sigma_I;

or(:,:,1,1)=sigma_I;
or(:,:,2,1)=s;

oi(:,:,1,1)=sigma_I;
oi(:,:,2,2)=sigma_I;
oi(:,:,2,1)=s;

oooMPO{l  } = ol;
oooMPO{mid} = oi;
oooMPO{r  } = or;


end