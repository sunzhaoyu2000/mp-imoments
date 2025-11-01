close all
clear
restoredefaultpath

format long

path(path,'./Tool_LandR_iMPS');
path(path,'./Tool_LandR_iMPS/lambda_transfermatrix');


%% step(1) load MPS and prepare environments


%! mv iMPS.m load_iMPS.m
%load_iMPS

! mv load_iMPS_TI_noS_1.m load_iMPS.m
load_iMPS






% Size_check
if length(MPS) > 2
    
    disp('error. SizeCell<=2 is required!')
    disp(['current SizeCell is : ',num2str(length(MPS))])
    pause
    pause
    pause
    return
    
elseif length(MPS) == 2  % iMPS: -A-B-A-B-A-B-
    % ==>  [43x2x30 double]  [30x2x43 double]
    iMPS{1}=permute(MPS{1},[1 3 2]);
    iMPS{2}=permute(MPS{2},[1 3 2]);
    
else                     % iMPS: -A-A-A-A-A-A-
    
    iMPS{1}=permute(MPS{1},[1 3 2]);
    iMPS{2}=iMPS{1};  
    
end


clear MPS


[ left_maxE, etaL_E] =  leftEigenVector_eigs_iMPS(iMPS);

[right_maxE, etaR_E] = rightEigenVector_eigs_iMPS(iMPS);


norm_wf = normalization_leftrighteigenvector_of_T(left_maxE, right_maxE); % [ norm ~=1 ] generally.

D = size(iMPS{1},1);

left_maxE  = reshape(  left_maxE, D,1,D );
right_maxE = reshape( right_maxE, D,1,D );





%% (2) define MPO1 and MPO2
paulixyz_sun;

oooMPO_x = construct_oooMPO(sigma_x); % that is, in the form of ol oi oi oi or; only ol,oi,or are stored.
oooMPO_y = construct_oooMPO(sigma_y);
oooMPO_z = construct_oooMPO(sigma_z);

%% (3) define final MPO for <psi|oooMPO|psi>
% For first moment: --> 
% oooMPO = oooMPO_z; 
%
% For second moment: --> 
 oooMPO = oooMPO_times_oooMPO(oooMPO_z,oooMPO_z); % second moment;







%% (4.a) Initialize Loo : < maxE | * oooMPO

% ----- A  --- B  ---
% |     |      | 
% vl -- ol --- oi ---
% |     |      |
% ----- A_ --- B_ ---
 
l=1;
mid=2;
r=3;
A=1;
B=2;
    
	Lo  =  Contraction_LAoA( left_maxE, iMPS{A}, oooMPO{l} );
    Loo =  Contraction_LAoA( Lo,        iMPS{B}, oooMPO{mid} );



%% (4.b) Initialize ooR : oooMPO * | maxE >

%   --- A --- B  -----
%       |     |      | 
%    -- oi ---or --- vr
%       |     |      |
%   --- A_--- B_ -----
 
l=1;mid=2;r=3;
A=1;B=2;
    
	 oR =  Contraction_BoBR( iMPS{B}, oooMPO{r},   right_maxE );
    ooR =  Contraction_BoBR( iMPS{A}, oooMPO{mid}, oR         );


%% (5) main loop to identify the parameters in Sn = pn^2+qn;

Control_maxLength = 500000;
Control_tol       = 1e-8;

S=zeros(1,Control_maxLength); 
S(2)=1.23;

d=S;
c2=S;
c1=S;


for n = 4 : 2 : Control_maxLength
    
    S(n) = Contraction_LooooR( Loo,ooR ) / norm_wf;
    
    % update data
    d(n) =   S(n) - S(n-2)      ;
    c2(n) =( d(n) - d(n-2) ) / 8;
    %c1(n) = (d(n) - 4*c2(n)*n - 4*c2(n)) / 2;
    
    % Tol check
    converge_p = abs(c2(n)-c2(n-2));
    %
    
    if( converge_p < Control_tol && n>50)
        break
    end
    
    % increase the Total length
	Lotmp  =  Contraction_LAoA(	Loo,	iMPS{A},	oooMPO{mid}	);
    Loo    =  Contraction_LAoA(	Lotmp,	iMPS{B},	oooMPO{mid}	);
    
    
    plot(n, (c2(n)),'.');hold on
    %plot(n, (c1(n)),'o');hold on
    %xlim([20 Control_maxLength])
drawnow
    
end

c2_converge = c2(n);

S2([4:2:n]) = S([4:2:n]) - c2_converge .* [4:2:n].^2;



for n = 4 : 2 : Control_maxLength
    
    
    c1(n) =   (S2(n) - S2(n-2))/2;
    
    
    % Tol check
    
    converge_q = abs(c1(n)-c1(n-2));
    
    if( converge_q < Control_tol  && n>50)
        break
    end
    
    % increase the Total length
	Lotmp  =  Contraction_LAoA(	Loo,	iMPS{A},	oooMPO{mid}	);
    Loo    =  Contraction_LAoA(	Lotmp,	iMPS{B},	oooMPO{mid}	);
    
    
    %plot(n, (c2(n)),'.');hold on
    plot(n, (c1(n)),'o');hold on
    %xlim([20 Control_maxLength])
drawnow
    
end


%plot([2:2:n], c2([2:2:n]),'s-');hold on
%plot([2:2:n], c1([2:2:n]),'s-');hold on


c2_converge / 4
c1(n)/4




