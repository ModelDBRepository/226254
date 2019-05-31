/************************ VTA v2.14 AMPA.g *********************
*****Equations and Parameters for AMPA receptor*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

function make_AMPA_channel
	
  	create facsynchan AMPA

	echo "make AMPA"

	float tau1 = 1.1e-3   //Evans et al. 2012
        float tau2 = 5.75e-3  

   	setfield AMPA tau1 {tau1} tau2 {tau2} Ek 0
end
