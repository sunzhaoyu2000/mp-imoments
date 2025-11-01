close all
clear
restoredefaultpath

format long

path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/')
path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/Tool_LandR_iMPS');
path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/Tool_LandR_iMPS/lambda_transfermatrix');


%% step(1) load MPS and prepare environments







%% (2a) define MPO1 and MPO2

paulixyz_Spin_1; % s1_x, s1_y, s1_z, s1_I.




% oooMPO: in the form of ol-oi-oi-oi-or; 
%         only ol,oi,or are stored.
%         ol: dxdx1xD 
%         oi: dxdxDxD 
%         or: dxdxDx1

oooMPO_kink_Ox = construct_MPO_s1_kinkOx( ); % O, Eq. (17)
oooMPO_kink_Oz = construct_MPO_s1_kinkOz( ); 
oooMPO_kink_Oy = construct_MPO_s1_kinkOy( ); % O, Eq. (17)

oooMPO_Stringx = construct_MPO_s1_String(s1_x); % C, Eq. (15)
oooMPO_Stringz = construct_MPO_s1_String(s1_z);


ol=oooMPO_kink_Oz{1}; ol_FM = ol(1,1,:,:); ol_FM = reshape(ol_FM,[1 2]);
oi=oooMPO_kink_Oz{2}; oi_FM = oi(1,1,:,:); oi_FM = reshape(oi_FM,[2 2]);
or=oooMPO_kink_Oz{3}; or_FM = or(1,1,:,:); or_FM = reshape(or_FM,[2 1]);

format short

disp(['Oz'])

ol_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * oi_FM * oi_FM * or_FM




%% (3) define final MPO for <psi|oooMPO|psi>
% For first moment: --> 
% oooMPO = oooMPO_z; 
%
% For second moment: --> 
% oooMPO_Stringx_power2 = oooMPO_times_oooMPO(oooMPO_Stringx,oooMPO_Stringx); % second moment;
% oooMPO_Stringz_power2 = oooMPO_times_oooMPO(oooMPO_Stringz,oooMPO_Stringz); % second moment;
 
 oooMPO_kink_Ox_power2 = oooMPO_times_oooMPO(oooMPO_kink_Ox,oooMPO_kink_Ox); % second moment;
 oooMPO_kink_Oy_power2 = oooMPO_times_oooMPO(oooMPO_kink_Oy,oooMPO_kink_Oy); % second moment;
 oooMPO_kink_Oz_power2 = oooMPO_times_oooMPO(oooMPO_kink_Oz,oooMPO_kink_Oz); % second moment;



 
 
ol=oooMPO_kink_Oz_power2{1}; ol_FM = ol(1,1,:,:); ol_FM = reshape(ol_FM,[1 4]);
oi=oooMPO_kink_Oz_power2{2}; oi_FM = oi(1,1,:,:); oi_FM = reshape(oi_FM,[4 4]);
or=oooMPO_kink_Oz_power2{3}; or_FM = or(1,1,:,:); or_FM = reshape(or_FM,[4 1]);

format short

disp(['Oz^2'])

ol_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * oi_FM * or_FM
ol_FM * oi_FM * oi_FM * oi_FM * oi_FM * or_FM



 
 
