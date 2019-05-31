/************************ VTA v2.14 Ka.g *********************
*****Equations and Parameters for Ka channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

//data from Rahilla Tarfa 

function make_Ka_channel
	float Erev = -0.09   			 //Volts
	str path = "Ka_channel" 
		
	float xmin  = -0.10  /* minimum voltage we will see in the simulation */     // Volts
    	float xmax  = 0.05  /* maximum voltage we will see in the simulation */      // Volts
    	int xdivsFiner = 3000
    	int c = 0
	float increment = (xmax - xmin)*1e3/xdivsFiner  // mV
	
	float mhalf = -29.4172
	float mslope = 8.43839
	float mrate = 1
	
	float hhalf = -61.1714
	float hslope = -4.57317
	float hrate = 1     
		 
    create tabchannel {path} 
    call {path} TABCREATE X {xdivsFiner} {xmin} {xmax}  // activation   gate
    call {path} TABCREATE Y {xdivsFiner} {xmin} {xmax}  // inactivation gate

	float x = -100.00             // mV

	echo "Make Ka channel"

	for(c = 0; c < {xdivsFiner} + 1; c = c + 1) 

        	float minfa = {boltz {mrate} {mhalf} {mslope} {x}}
		float minf = {pow {minfa} 0.3333333333}  //takes cubed root so mpower of 3 makes correct activation curve
        	float m_tau = {Ka_tau {1} {50} {550} {x}}  //from kusnetsova 2010
		float hinf = {boltz {hrate} {hhalf} {hslope} {x}}
        	float h_tau = 200 //150 //100 //50 //25
		
		/* 1e-3 converts from ms to sec for taus*/		
		setfield {path} X_A->table[{c}] {1e-3*{m_tau}}
        	setfield {path} X_B->table[{c}] {minf}
		setfield {path} Y_A->table[{c}] {1e-3*{h_tau}}
        	setfield {path} Y_B->table[{c}] {hinf}

		x = x + increment
    	end

    setfield {path} Ek {Erev} Xpower 3 Ypower 1

	tweaktau {path} X
	tweaktau {path} Y   


end













