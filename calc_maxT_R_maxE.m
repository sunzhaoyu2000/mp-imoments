function y = calc_envR( iMPS, sz, oT, right_maxE)
sigma_I= [1 0 ;  0  1];

% (1) -----------------------------------------------

v1 = left_maxT;
     
for i1 = 1 : length(iMPS)-2
                       
	v1 = Contraction_LAo( v1, iMPS{i1}, oT );
                    
end  



% (2) o12 ---------------------------------------------

o12=zeros(2,2,2,2);



for i1 = 1 :2
for i2 = 1 :2
for j1 = 1 :2
for j2 = 1 :2
    
    o12(i1,i2,j1,j2) = sz(i1,j1)*sigma_I(i2,j2) + sigma_I(i1,j1)*sz(i2,j2); 
    
end
end
end
end

%o12 = permute(o12, [4,3,2,1]);


% (3) -------------------------------------------

A = iMPS{1};A_ = conj(A);
B = iMPS{2};B_ = conj(B);

		tensors = { v1,    A,       A_,      o12,       B,      B_,      right_maxE     };
		legs    = { [1,4], [1,7,2], [4,9,5], [7,8,9,10],[2,8,3],[5,10,6],[3,6] };
		seq     = [1:10];
		finalOrder = [ ];

		y = ncon(tensors,legs,seq,finalOrder);
        
        %y = real(y);

end