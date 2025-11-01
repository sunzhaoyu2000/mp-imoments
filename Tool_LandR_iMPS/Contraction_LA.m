function L_ = Contraction_LA(L, A)
%      
%   ---A---
%   |  .
%   L  .
%   |  .
%   ---A---
%.     

A_ = conj(A);


%       tensors = { A, A_ };
%       legs    = {[-3,3,-1],[-4,3,-2]};
%       seq     = [3];
%       finalOrder = [-3,-4,-1,-2];
% 
%       test = ncon(tensors,legs,seq,finalOrder);



      tensors = { L, A, A_ };
      legs    = {[1,2],  [1,3,-1],[2,3,-2]};
      seq     = [2,1,3];
      finalOrder = [-1,-2];

      L_ = ncon(tensors,legs,seq,finalOrder);   

%       max(max(imag(test)))
%       1
      
end
