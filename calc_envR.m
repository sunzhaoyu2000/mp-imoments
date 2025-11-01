function y = calc_envR( iMPS, sz, sigma_z, vr )

        y = vr;

        
    for i1 = 4:-1:1
                       
       y = Contraction_CRo( iMPS{i1}, y, sigma_z );
                    
   end         
        

end