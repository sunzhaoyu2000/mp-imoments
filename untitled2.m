load imoments.mat

yy=Res_kink_Ox_power2.S;

yy=real(yy);



for n = 3 : length(yy)
    c2(n) = (yy(n) - 2*yy(n-1) + yy(n-2))/2;
end

%plot([3 : length(S)], c2(3 : length(S)),'x')


NN = 3 : length(yy);
Y2 = real(Res_kink_Ox_power2.c2) .* NN.^2 + real(Res_kink_Ox_power2.c1) .* NN + real(Res_kink_Ox_power2.c0);

plot(Y2,'x');hold on
plot(real(yy),'o')