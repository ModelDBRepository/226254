/************************ VTA v2.14 NMDA.g *********************
*****Equations and Parameters for NMDA receptor*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/


function make_NMDA_channel 
	
	create facsynchan NMDA

	echo "make NMDA"

  	float tau1 = (4.4624e-3)/2 //Evans et al. 2012
	float tau2 = (300e-3)/2    //Evans et al. 2012 GluN2B
  	float CMg = 1  		   //[Mg] in mM
	float KMg = 3.57  	   //Evans et al. 2012 GluN2B
  	float gamma = 62  	   //per Volt

	setfield NMDA Ek 0 tau1 {tau1} tau2 {tau2}
   
  	create Mg_block NMDA/block

  	setfield NMDA/block CMg {CMg} 
  	setfield NMDA/block KMg_B {1.0/{gamma}}
  	setfield NMDA/block KMg_A {KMg}

	addmsg NMDA NMDA/block CHANNEL Gk Ek
end



