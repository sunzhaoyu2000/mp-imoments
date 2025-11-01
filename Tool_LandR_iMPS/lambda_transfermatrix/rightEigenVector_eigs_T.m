%extend Edition
function [v,eta] = rightEigenVector_eigs_T(iMPS,o)  
        
        D = size(iMPS{end},3);
        n = D^2;

        %opts.issym = 0;
        %opts.isreal = 1;
     
        [v,eta] = eigs(@rightEigenVector_eigs_func_4,n,1,'largestabs','IsFunctionSymmetric',0);%,opts); %Largest magnitude (default).
        

                %% =============================================================
                function v1 = rightEigenVector_eigs_func_4(v0)

                    v1  = reshape(v0,[D,D]);
                    
                    for i1 = length(iMPS) : -1 : 1
                       
                        v1 = Contraction_CRo( iMPS{i1}, v1, o );
                    
                    end                                       
                       
                    v1 = v1(:);
                    
                    %v1 = real(v1);
                    
                    
                end
                %% =============================================================

end