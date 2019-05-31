/************************ VTA 2.14 Kv2.g *********************
*****Equations and Parameters for Kdr (Kv2) channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

//Khaliq and Bean unpublished observations for minf for DA neurons
//Liu and Bean 2014 SCG for tau


function make_Kdr_channel
	float Erev      = -0.09      		// Volts
    	str path 		= "Kdr_channel" 

    	float xmin  = -0.10  /* minimum voltage we will see in the simulation */     // Volts
    	float xmax  = 0.05  /* maximum voltage we will see in the simulation */      // Volts
    	int xdivsFiner = 3000
    	int c = 0
	float increment = (xmax - xmin)*1e3/xdivsFiner  // mV
	
	float mhalf = -5.8
	float mslope = 8
	float mrate = 1
			 
    create tabchannel {path}
	
    call {path} TABCREATE X {xdivsFiner} {xmin} {xmax}  // activation   gate
  
	float x = -100.00             // mV

	echo "Make Kdr channel"

	for(c = 0; c < {xdivsFiner} + 1; c = c + 1) 

        	float minf = {boltz {mrate} {mhalf} {mslope} {x}}
        	float m_tau = {gaussian {x} {20} {17} {22} {2}}
      		/* 1e-3 converts from ms to sec for taus*/		

		setfield {path} X_A->table[{c}] {1e-3*{m_tau}}
        	setfield {path} X_B->table[{c}] {minf}

		x = x + increment
    	end


	setfield {path} Ek {Erev} Xpower 1 

	tweaktau {path} X

end


