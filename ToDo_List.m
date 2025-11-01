construct_oooMPO_For_sx()                                   [ok]
oooMPO_final = oooMPO_times_oooMPO(oooMPO_sx,oooMPO_sz)     [ok]


Loo = Contraction_LAoA( Lo,        iMPS{2}, oooMPO{2} );    [ok]
ooR = Contraction_BoBR( iMPS{B}, oooMPO{mid}, oR     );     [ok]


S = Contraction_LooooR( Loo,ooR )                           [ok]