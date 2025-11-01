function Res = mp_imoments_2order_oooMPO_func__test( iMPS, norm_wf, left_maxE, right_maxE, oooMPO, opt )

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
 
n = 3;
    

c2(1) = 2; %rand
c2(2) = 4; %rand

err_c2 = 999;
%subplot(1,3,1)
%title('c2')
%while err_c2 > opt.tol || n < opt.min_step
while  n < opt.max_step
    n
    disp(['1'])
    S(n) = Contraction_LooooR( Loo,ooR ) / norm_wf; % n = 3,4,5...
    %plot(n,S(n),'x');hold on
    %drawnow
    % update data
    c2(n) = (S(n) - 2*S(n-1) + S(n-2))/2;
    %c2(n)
    
    % Tol check
    err_c2 = abs( c2(n) - c2(n-1) );% / abs (c2(n-1));    
    
        % increase the Total length : always cover a complete unit cell %
        for i1 = 1 : length(iMPS)
            Loo =  Contraction_LAoA( Loo, iMPS{i1}, oooMPO{mid} );
        end
    
    %
    %plot(n, c2(n),'s'); hold on; drawnow
    
    n=n+1;
end




%% c1

c2_converge = c2(end);
S1  = S - c2_converge .* [1:length(S)].^2;
%减掉二次项部分

c1(1) = 1;
    n = 2;
    
err_c1= 999; 
%   subplot(1,3,2)
%title('c1') 
while ( err_c1 > opt.tol || n < opt.min_step ) && n<length(S1)-1
    n
    disp(['2'])
    c1(n) =   S1(n) - S1(n-1);
    
    err_c1 = abs( c1(n) - c1(n-1) );% / abs (c1(n-1))
    
    %plot(n, c1(n),'o'); hold on; drawnow
    
    n = n + 1;
    
end % while






%% c0

c1_converge = c1(end);
%S1  = S - c2_converge .* [1:length(S)].^2;
S0  = S1 - c1_converge .* [1:length(S1)];

c0(1) = 1;
    n = 2;
    
err_c0= 999; 
%subplot(1,3,3)
%title('c0')    
while (err_c0 > opt.tol || n < opt.min_step) && n<length(S0)-1 
    n
    disp(['3'])
    c0(n) =   S0(n);
    
    err_c0 = abs( c0(n) - c0(n-1) );% / abs (c1(n-1))
    
%    plot(n, c0(n),'v'); hold on; drawnow
    
    n = n + 1;
    
end % while


%print(gcf, '-dpdf', 'converge.pdf')

%close all


Res.S = S;
Res.c2 = c2(end);
Res.c1 = c1(end);
Res.c0 = c0(end);
Res.err_c2 = err_c2;
Res.err_c1 = err_c1;
Res.err_c0 = err_c0;

if abs(err_c0) > opt.tol || abs(err_c1) > opt.tol || abs(err_c2) > opt.tol
    Res.converged = 0;
else
    Res.converged = 1;
end

end % function
