function R_ = Contraction_CR(C, R)
%      
%   ---C----
%      .   |
%      .   R
%      .   |
%   ---C----
C_ = conj(C);

		tensors = { R, C, C_ };
		legs    = {[1,2],  [-1,3,1],[-2,3,2]};
		seq     = [2,1,3];
		finalOrder = [-1,-2];

		R_ = ncon(tensors,legs,seq,finalOrder);
        
        %R_ = real(R_);
   
end
