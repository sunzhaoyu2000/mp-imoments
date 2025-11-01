function Loo = Contraction_LAoA( Lo,        iMPS_A, oooMPO_o )

iMPS_A_ = conj(iMPS_A);

      tensors = { Lo,        iMPS_A,  oooMPO_o,   iMPS_A_ };
      legs    = {[1:3],     [1,4,-1], [4,5,2,-2], [3,5,-3]};
      seq     = [1 2 4 3 5];%[3   2   5   1   4];%[1 2 4 3 5];
      finalOrder = [-1,-2,-3];
      
      Loo = ncon(tensors,legs,seq,finalOrder); 

end
