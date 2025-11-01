function y = calc_envL( vl, iMPS, sz, sigma_z  )

sigma_I= [1 0 ;  0  1];




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

		tensors = { vl,    A,       A_,      o12,       B,         B_ };
		legs      = {[1,3],[1,5,2],[3,7,4],[5,6,7,8],[2,6,-1],[4,8,-2] };
		seq       = [1:8];
		finalOrder = [-1,-2];

		y = ncon(tensors,legs,seq,finalOrder);
        
        %y = real(y);


        
% (1) -----------------------------------------------
   
for i1 = 3:4    
    
	y =  Contraction_LAo( y, iMPS{i1}, sigma_z );
                    
end  
        
        
end
                    

                    
