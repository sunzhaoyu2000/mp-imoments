function oooMPO_updn = oooMPO_times_oooMPO(oooMPO_up,oooMPO_dn)



% up-up-up-up-up
% dn-dn-dn-dn-dn

for i1 = 1 : 3 % ol,oi,or
   
      % oooMPO_updn{i1} = oooMPO_up{i1}*oooMPO_dn{i1} %
	  %一个MPO_up、一个MPO_dn进行张量收缩       
      tensors = { oooMPO_up{i1}, oooMPO_dn{i1} };
      legs    = {[-1,1,-3,-5],  [1,-2,-4,-6]};
      seq     = [1];
      finalOrder = [-1:-1:-6];
      %tensors表示两个张量，legs表示每个张量对应的索引值，seq表示收缩的leg,finalOrder表示留下的leg
      tmp = ncon(tensors,legs,seq,finalOrder);      
      %tmp表示一个临时张量
      D_up3 = size(oooMPO_up{i1},3);
      D_dn3 = size(oooMPO_dn{i1},3);
      D_up4 = size(oooMPO_up{i1},4);
      D_dn4 = size(oooMPO_dn{i1},4);
      d     = size(oooMPO_up{i1},1);
      %D_up3为-3,D_dn3为-4,D_up4为-5.D_dn4为-6
      
      oooMPO_updn{i1} = reshape(tmp,d,d,D_up3*D_dn3,D_up4*D_dn4);
     
end




end
