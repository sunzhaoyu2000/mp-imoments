function  fOf = Contraction_LooooR( Loo, ooR )

      tensors = { Loo, ooR };
      legs    = {[1:3],  [1:3]};
      seq     = [1:3];
      finalOrder = [ ];
      
      fOf = ncon(tensors,legs,seq,finalOrder); 
      
end