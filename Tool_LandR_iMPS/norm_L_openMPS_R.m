function norm = norm_L_openMPS_R( Left, openMPS, Right )
% For instance, impo in the form of ... - ABC - ABC - ABC - ...

% LengthUnitCell_iMPOp = 3;

% ChainLength=6 ===> L---A-B-C-A-B-C---R

% ChainLength=5 ===> L---A-B-C-A-B-C---R
%               ===> L---A-B-C-A-B-----CR  // Prepare_RightEnd.m


%% The max elements on every single-site tensor should be equal.
%Left  = Left ./  max(abs( Left(:)  ));
%Right = Right ./ max(abs( Right(:) ));

%for i1 = 1 : length(openMPS)

%    Y = openMPS{i1};
%    openMPS{i1} = Y ./ max( abs(Y(:)) );
    
%end


ChainLength = length(openMPS);









%% left to right contraction.

     LeftBlock = Left;
    RightBlock = Right;

for i1 = 1 : ChainLength
      
      A         = openMPS{ i1 };
      LeftBlock = Contraction_LA(LeftBlock, A);     
        
end

% LeftBlock + RightBlock
    tensors = { LeftBlock, RightBlock };
    legs    = { [1,2],    [1,2] };
    seq     =   [1,2];
    finalOrder =[ ];
	
    norm = ncon(tensors,legs,seq,finalOrder);

    
    %norm = real(norm)

% %% normalization 
% 
% norm_perTensor =   ( abs(norm) ) ^ (1/(2*ChainLength))  ;
% 
% normed_openMPS = cell(length(openMPS));
% 
% for i1 = 1 : length(openMPS)    
%     normed_openMPS{i1} = openMPS{i1} ./ norm_perTensor;    
% end
% 
% if norm < 0        
%     normed_openMPS{1} = -1 .* normed_openMPS{1};       
% end    
    
   

end