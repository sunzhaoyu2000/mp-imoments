function ooR =  Contraction_BoBR( iMPS_B, oooMPO_o, oR )

      iMPS_B_ = conj(iMPS_B);

      tensors = { oR,        iMPS_B,  oooMPO_o,   iMPS_B_ };
      legs    = {[1:3],     [-1,4,1], [4,5,-2,2], [-3,5,3]};
      seq     = [1 2 4 3 5];%[3   2   5   1   4];%[1 2 4 3 5];
      finalOrder = [-1,-2,-3];
      
      ooR = ncon(tensors,legs,seq,finalOrder); 

end
