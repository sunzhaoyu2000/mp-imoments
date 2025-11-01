function L_ = Contraction_LAo(L, A, o)
%      
%   ---A---
%   |  .
%   L  o
%   |  .
%   ---A_--
%.     

A_ = conj(A);

      tensors = { L, A, A_, o };
      legs    = {[1,2],  [1,3,-1],[2,4,-2], [3,4]};
      seq     = [1,2,3,4];
      finalOrder = [-1,-2];

  
      
      
      L_ = ncon(tensors,legs,seq,finalOrder);   
      
end