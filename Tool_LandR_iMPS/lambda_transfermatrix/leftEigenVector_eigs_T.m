%extend Edition
function [v,eta] = leftEigenVector_eigs_T(iMPS,o)

        D = size(iMPS{1},1);
        n = D^2;

        %opts.issym = 0;
        %opts.isreal = 1;
     
        [v,eta] = eigs(@leftEigenVector_eigs_func_3,n,1,'largestabs','IsFunctionSymmetric',0);%,opts);


                %% =============================================================
                function v1 = leftEigenVector_eigs_func_3(v0)

                    v1  = reshape(v0,[D,D]);
                    
                    for i1 = 1 : length(iMPS)
                    
                        v1 = Contraction_LAo(v1, iMPS{i1},o);
                    
                    end
                       
                    v1 = v1(:);
                    
                    %v1 = real(v1);

                end
                %% =============================================================

end