y_exact=S([4:2:n]);

y_matlab= c2(n).*[4:2:n].^2 +     c1(n).*[4:2:n]

y_mpt   = c2(n).*[4:2:n].^2 +(0.0278)*4.*[4:2:n]


plot([4:2:n],y_exact-c2(n).*[4:2:n].^2,'b.'); hold on

return

plot([4:2:n],y_mpt,'r.');   hold on
plot([4:2:n],y_exact,'b.'); hold on
plot([4:2:n],y_matlab,'m.');hold on



plot([4:2:n],y_mpt-y_exact,'k.');   hold on
plot([4:2:n],y_matlab-y_exact,'kx');hold on
