%extend Edition
function [v,eta] = rightEigenVector_eigs_iMPS(iMPS)  

        
        D = size(iMPS{end},3);
        n = D^2;

        opts.issym  = 0;
        opts.isreal = 0;
     
        [v,eta] = eigs(@rightEigenVector_eigs_func_2,n,1,'largestabs',opts); %Largest magnitude (default).
        

                %% =============================================================
                function v1 = rightEigenVector_eigs_func_2( v0 )

                    v1  = reshape(v0,[D,D]);
                    
                    for i1 = length(iMPS) : -1 : 1
                       
                        v1 = Contraction_CR( iMPS{i1}, v1 );
                    
                    end                                       
                       
                    v1 = v1(:);
                    
                    %v1 = real(v1);
                                     
                end
                %% =============================================================

end