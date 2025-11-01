function R_ = Contraction_CRo(C, R, o)
%      
%   ---C----
%      .   |
%      o   R
%      .   |
%   ---C----

C_ = conj(C);

		tensors = { R,     C,       C_,      o     };
		legs    = {[1,2],  [-1,3,1],[-2,4,2],[3,4] };
		seq     = [1,3,2,4];
		finalOrder = [-1,-2];

		R_ = ncon(tensors,legs,seq,finalOrder);
        
end