close all
clear
restoredefaultpath

format long

path(path,'./Tool_LandR_iMPS');
path(path,'./Tool_LandR_iMPS/lambda_transfermatrix');


%% step(1) load MPS and prepare environments


%! mv iMPS.m load_iMPS.m
%load_iMPS

! mv load_iMPS_TI_noS_3.m load_iMPS.m
load_iMPS






% Size_check
if length(MPS) > 2
%判断原胞的大小    
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

%计算基态波函数iMPS的特征左矢以及最大特征
[ left_maxE, etaL_E] =  leftEigenVector_eigs_iMPS(iMPS);
%计算基态波函数iMPS的特征右矢以及最大特征值
[right_maxE, etaR_E] = rightEigenVector_eigs_iMPS(iMPS);

%归一化基态波函数
norm_wf = normalization_leftrighteigenvector_of_T(left_maxE, right_maxE); % [ norm ~=1 ] generally.

%输出iMPS的行数
D = size(iMPS{1},1);

%将left_maxE、right_maxE转换为D x 1 x D
left_maxE  = reshape(  left_maxE, D,1,D );
right_maxE = reshape( right_maxE, D,1,D );





%% (2) define MPO1 and MPO2
paulixyz_sun;

%构建sigma_x、sigma_y、sigma_z
oooMPO_x = construct_oooMPO(sigma_x); % that is, in the form of ol oi oi oi or; only ol,oi,or are stored.
oooMPO_y = construct_oooMPO(sigma_y);
oooMPO_z = construct_oooMPO(sigma_z);

%% (3) define final MPO for <psi|oooMPO|psi>
% For first moment: -->
%计算线性系数——>q
% oooMPO = oooMPO_z; 
%
%计算平方相系数——>p
% For second moment: --> 
 oooMPO = oooMPO_times_oooMPO(oooMPO_x,oooMPO_x); % second moment;







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
	%left_maxE--->vl  iMPS{A}--->A  oooMPO{l}--->ol
    	%iMPS{B}--->B     oooMPO{mid}--->oi
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
    	% right_maxE--->vr oooMPO{r}--->or iMPS{B}--->B  最右边的vr与转移矩阵B先进行运算得到oR
	% iMPS{A}--->A     oooMPO{mid}--->oi            再将oR与转移矩阵A进行运算
	 oR =  Contraction_BoBR( iMPS{B}, oooMPO{r},   right_maxE );
         ooR =  Contraction_BoBR( iMPS{A}, oooMPO{mid}, oR         );


%% (5) main loop to identify the parameters in Sn = pn^2+qn;

%计算的最大次数、计算误差
Control_maxLength = 500000;
Control_tol       = -1e-10;

%S为1 x Control_maxLength的向量，且第二个值为1.23，其它值为0
S=zeros(1,Control_maxLength); 
S(2)=1.23;

%d c2 c1是1 x Control_maxLength全为0的向量，c2--->P,c1--->Q
d=S;
c2=S;
c1=S;


for n = 4 : 2 : Control_maxLength
    %S(n)= P* n**2 + Q * n  
    S(n) = Contraction_LooooR( Loo,ooR ) / norm_wf;
    
    % update data
    d(n) =   S(n) - S(n-2)      ;
    c2(n) =( d(n) - d(n-2) ) / 8;
    c1(n) = (d(n) - 4*c2(n)*n - 4*c2(n)) / 2;
    
    % Tol check
    %将P、Q的误差
    converge_p = abs(c2(n)-c2(n-2));
    converge_q = abs(c1(n)-c1(n-2));
    
    if( converge_p < Control_tol &&  converge_q < Control_tol )
        break
    end
    
    % increase the Total length
	Lotmp  =  Contraction_LAoA(	Loo,	iMPS{A},	oooMPO{mid}	);
        Loo    =  Contraction_LAoA(	Lotmp,	iMPS{B},	oooMPO{mid}	);
    
    
    plot(n, (c2(n)),'.');hold on
    plot(n, (c1(n)),'o');hold on
    %xlim([20 Control_maxLength])
drawnow
    
end


%plot([2:2:n], c2([2:2:n]),'s-');hold on
%plot([2:2:n], c1([2:2:n]),'s-');hold on







