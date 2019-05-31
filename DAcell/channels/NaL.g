/************************ VTA 2.14 NaL.g *********************
*****Equations and Parameters for leak sodium channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

function make_NaP_channel
	float Erev      = 0      		// Volts
    	str path 	= "NaL_channel" 

    	float xmin  = -0.10  /* minimum voltage we will see in the simulation */     // Volts
    	float xmax  = 0.05  /* maximum voltage we will see in the simulation */      // Volts
    	int xdivsFiner = 3000
    	int c = 0
	float increment = (xmax - xmin)*1e3/xdivsFiner  // mV
			 
    	create tabchannel {path}
	
   	call {path} TABCREATE X {xdivsFiner} {xmin} {xmax}  // activation   gate
  
	float x = -100.00             // mV

	echo "Make NaL channel"

	for(c = 0; c < {xdivsFiner} + 1; c = c + 1) 

        	float minf = 1
        	float m_tau = 1 //second	

		setfield {path} X_A->table[{c}] {m_tau}
        	setfield {path} X_B->table[{c}] {minf}

		x = x + increment
    	end


	setfield {path} Ek {Erev} Xpower 1 

	tweaktau {path} X

end


