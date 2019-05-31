/************************ VTA v2.14 GABA.g *********************
*****Equations and Parameters for GABA-A receptor*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

function make_GABA_channel
	
  	create facsynchan GABA

	echo "make GABA"

	float tau1 =0.25e-3   
    	float tau2 = 3.75e-3  

   	setfield GABA tau1 {tau1} tau2 {tau2} Ek -0.062
end
