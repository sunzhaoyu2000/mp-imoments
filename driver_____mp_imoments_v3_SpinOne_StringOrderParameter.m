close all
clear
restoredefaultpath

format long

path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/')
path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/Tool_LandR_iMPS');
path(path,'~/2024_QFI_spinOne_BLBQ/mp-imoments/Tool_LandR_iMPS/lambda_transfermatrix');


%% step(1) load MPS and prepare environments


load_iMPS



clear iMPS RHO ans

for i1 = 1 : length(MPS)
    iMPS{i1}=permute(MPS{i1},[1 3 2]); % DxDxd => DxdxD
end

clear MPS

tic

[ left_maxE, etaL_E] =  leftEigenVector_eigs_iMPS(iMPS); 

[right_maxE, etaR_E] = rightEigenVector_eigs_iMPS(iMPS);

toc

norm_wf = normalization_leftrighteigenvector_of_T(left_maxE, right_maxE); % [ norm ~=1 ] generally.


D = size(iMPS{1},1);

left_maxE  = reshape(  left_maxE, D,1,D );
right_maxE = reshape( right_maxE, D,1,D );





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


 

%% （4） calculate polynomial coefficents.
opt.tol      = 1e-12;
opt.min_step = 1000;
opt.max_step = 20000;

Res_stringx=0;
Res_stringy=0;
Res_stringz=0;

Res_kink_Ox=0;
Res_kink_Oy=0;
Res_kink_Oz=0;

Res_stringx_power2=0;
Res_stringy_power2=0;
Res_stringz_power2=0;

Res_kink_Ox_power2=0;
Res_kink_Oy_power2=0;
Res_kink_Oz_power2=0;



%       Res_stringz = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_Stringz,        opt );
%       Res_stringx = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_Stringx,        opt );
%       Res_kink_Ox = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_kink_Ox,        opt )
%       Res_kink_Oz = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_kink_Oz,        opt );

%Res_stringx_power2 = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_Stringx_power2, opt );
%Res_stringz_power2 = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_Stringz_power2, opt );

Res_kink_Ox_power2 = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_kink_Ox_power2, opt )
%Res_kink_Oy_power2 = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_kink_Oy_power2, opt )
Res_kink_Oz_power2 = mp_imoments_2order_oooMPO_func( iMPS, norm_wf, left_maxE, right_maxE, oooMPO_kink_Oz_power2, opt )



%% save dat
save('imoments.mat', 'Res_stringx', ...
                     'Res_stringz', ...
                     'Res_kink_Ox', ...
                     'Res_kink_Oz', ...
                     'Res_stringx_power2', ...
                     'Res_stringz_power2', ...
                     'Res_kink_Ox_power2', ...
                     'Res_kink_Oz_power2'      )                     


%clc

%plot(real(Sx(1:400:end)),'o'); hold on
%plot(real(Sy(1:400:end)),'x'); hold on
%plot(real(Sz(1:400:end)),'v'); hold on
