%extend Edition
function [v,eta] = leftEigenVector_eigs_iMPS(iMPS)


        D = size(iMPS{1},1);
        n = D^2;

        opts.issym  = 0;
        opts.isreal = 0;
     
        [v,eta] = eigs(@leftEigenVector_eigs_func_1,n,1,'largestabs',opts);


                %% =============================================================
                function v1 = leftEigenVector_eigs_func_1( v0 )

                    v1  = reshape(v0,[D,D]);
                    
                    for i1 = 1 : length(iMPS)
                    
                        v1 = Contraction_LA( v1,  iMPS{i1} );
                    
                    end
                       
                    v1 = v1(:);
                    
                    %v1 = real(v1);

                end
                %% =============================================================

end