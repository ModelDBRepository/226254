

*relative
*cartesian
*asymmetric
*lambda_warn


*set_global ELEAK {ELEAK}
*set_global RM {RM}
*set_global RA {RA}
*set_global CM {CM}
*set_global EREST_ACT {EREST_ACT}


*start_cell
	
*spherical

soma none 25 0 0 25

*cylindrical

primdend1_1 soma 20 0 0 2.5
primdend1_2 . 20 0 0 2.5
primdend1_3 . 20 0 0 2
primdend1_4 . 20 0 0 2

primdend2_1 soma 20 0 0 2.5
primdend2_2 . 20 0 0 2.5
primdend2_3 . 20 0 0 2
primdend2_4 . 20 0 0 2
	
secdend11 primdend1_4 20 0 0 1
secdend12 primdend1_4 20 0 0 1
secdend21 primdend2_4 -20 0 0 1
secdend22 primdend2_4 -20 0 0 1

tertdend1_1 secdend11 20  0  0  0.8
tertdend1_2 . 20 0 0 0.8 
tertdend1_3 . 20 0 0 0.8
tertdend1_4 . 20 0 0 0.8
tertdend1_5 . 20 0 0 0.8
tertdend1_6 . 20 0 0 0.8
tertdend1_7 . 20 0 0 0.8

tertdend2_1 secdend11 20  -10  0  0.8
tertdend2_2 . 20 0 0 0.8
tertdend2_3 . 20 0 0 0.8
tertdend2_4 . 20 0 0 0.8
tertdend2_5 . 20 0 0 0.8
tertdend2_6 . 20 0 0 0.8
tertdend2_7 . 20 0 0 0.8

tertdend3_1 secdend12 20  10  0  0.8
tertdend3_2 . 20 0 0 0.8 
tertdend3_3 . 20 0 0 0.8
tertdend3_4 . 20 0 0 0.8
tertdend3_5 . 20 0 0 0.8
tertdend3_6 . 20 0 0 0.8
tertdend3_7 . 20 0 0 0.8 
   
tertdend4_1 secdend12 20  -10  0  0.8
tertdend4_2 . 20 0 0 0.8 
tertdend4_3 . 20 0 0 0.8
tertdend4_4 . 20 0 0 0.8
tertdend4_5 . 20 0 0 0.8
tertdend4_6 . 20 0 0 0.8
tertdend4_7 . 20 0 0 0.8 
   
tertdend5_1 secdend21 -20  10  0  0.8
tertdend5_2 . 20 0 0 0.8 
tertdend5_3 . 20 0 0 0.8
tertdend5_4 . 20 0 0 0.8
tertdend5_5 . 20 0 0 0.8
tertdend5_6 . 20 0 0 0.8
tertdend5_7 . 20 0 0 0.8 
   
tertdend6_1 secdend21 -20  -10  0  0.8
tertdend6_2 . 20 0 0 0.8 
tertdend6_3 . 20 0 0 0.8
tertdend6_4 . 20 0 0 0.8
tertdend6_5 . 20 0 0 0.8
tertdend6_6 . 20 0 0 0.8
tertdend6_7 . 20 0 0 0.8 
   
tertdend7_1 secdend22 -20  10  0  0.8
tertdend7_2 . 20 0 0 0.8 
tertdend7_3 . 20 0 0 0.8
tertdend7_4 . 20 0 0 0.8
tertdend7_5 . 20 0 0 0.8
tertdend7_6 . 20 0 0 0.8
tertdend7_7 . 20 0 0 0.8
   
tertdend8_1 secdend22 -20  -10  0  0.8
tertdend8_2 . 20 0 0 0.8 
tertdend8_3 . 20 0 0 0.8
tertdend8_4 . 20 0 0 0.8
tertdend8_5 . 20 0 0 0.8
tertdend8_6 . 20 0 0 0.8
tertdend8_7 . 20 0 0 0.8


