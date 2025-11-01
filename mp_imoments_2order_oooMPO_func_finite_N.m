function Res = mp_imoments_2order_oooMPO_func_finite_N( iMPS, norm_wf, left_maxE, right_maxE, oooMPO, opt )

%
% 1. S = <oooMPO> = L^2 * c2 + L * c1.
%
% 2. if the MPO has a higher order than 2, the algorithm cannot converge.
% 
% 3. MPS can have multi-site unit-cell.
%

%figure

% ol, omid, or 
l   = 1;
mid = 2;
r   = 3;

N = 30000;

%% (4.a) Initialize Loo : < maxE | * oooMPO 

%   ----- A1 --- A2 --- An ---
%   |     |      | 
%   vl--- ol --- oi --- oi ---
%   |     |      |
%   ----- A1 --- A2 --- An ---
    
	Loo = Contraction_LAoA( left_maxE,  iMPS{ 1}, oooMPO{l}   );
        
    for i1 = 2 : length(iMPS)
    Loo =  Contraction_LAoA( Loo,       iMPS{i1}, oooMPO{mid} );
    end

%% (4.b) Initialize ooR : oooMPO * | maxE >

%   --- A1 --- A2 --- An ------
%       |      |      |       |
%   --- oi --- oi --- or --- vr
%       |      |      |       |
%   --- A1 --- A2 ----An ------
   
	ooR = Contraction_BoBR( iMPS{end},  oooMPO{  r},    right_maxE );
    
    for i1 = length(iMPS)-1 : -1 : 1
    ooR = Contraction_BoBR( iMPS{ i1},  oooMPO{mid},    ooR        );
    end
    

%% (5) main loop to identify the parameters in Sn = p n^2+q n;

%    ---- A1 --- A2 --- An -----
%    |     |      |      |     |
%  Loo -- oi --- oi --- oi --- ooR
%    |     |      |      |     |
%    ---- A1 --- A2 --- An -----






% S(n  ) = c2 *  n^2 + c1 * n;
% C2 = ddS(m)/ddm 
%    = S(m+1) - 2S(m)   + S(m-1);
%    = S(n  ) - 2S(n-1) + S(n-2);



%% c2
 S(1) = 2*rand(1);
 S(2) = Contraction_LooooR( Loo,ooR ) / norm_wf;
 
        for i1 = 1 : length(iMPS)
            Loo =  Contraction_LAoA( Loo, iMPS{i1}, oooMPO{mid} );
        end
 


%subplot(1,3,1)
%title('c2')
for n = 3 : N

    
    S(n) = Contraction_LooooR( Loo,ooR ) / norm_wf; % n = 3,4,5...
        
        % increase the Total length : always cover a complete unit cell %
        for i1 = 1 : length(iMPS)
            Loo =  Contraction_LAoA( Loo, iMPS{i1}, oooMPO{mid} );
        end    
        
    
end



Res = S;


end % function
