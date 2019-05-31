/************************ VTA v2.14 Ih.g *********************
*****Equations and Parameters for H-current*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

//Reference: Khaliq and Bean unpublished data, Migliore 2008 Tau

function make_Ih_channel
	str path = "Ih_channel" 
	
  	float Erev = -0.035 
	float xmin  = -0.15  /* minimum voltage we will see in the simulation */     // Volts
    	float xmax  = 0.05  /* maximum voltage we will see in the simulation */      // Volts
    	int xdivsFiner = 3000
    	int c = 0
	float increment = (xmax - xmin)*1e3/xdivsFiner  // mV
	
	//for Minf boltzmann
	
	float mhalf = -80 
	float mslope = 6.5
	float mrate = 1
	
	//for m_tau 1/a+b 
	
	float mA_rate = 2e-5
	float mA_slope = -10.2
	
	float mB_rate = 7.6
	float mB_vhalf = 10
	float mB_slope = -100
			 
    create tabchannel {path}
	
    call {path} TABCREATE X {xdivsFiner} {xmin} {xmax}  // activation   gate
  
	float x = -150.00             // mV

	echo "Make Ih channel"

	for(c = 0; c < {xdivsFiner} + 1; c = c + 1) 

        float minf = {Ih_inf {mrate} {mhalf} {mslope} {x}}
		
		float m_alpha = {exp_form {mA_rate} {mA_slope} {-x}}
		float m_beta = {sig_form {mB_rate} {mB_vhalf} {mB_slope} {x}}
		float m_tau = 1/{{m_alpha}+{m_beta}}
        	

	    setfield {path} X_A->table[{c}] {m_tau}
        setfield {path} X_B->table[{c}] {minf}

		x = x + increment
 	end	 	

	setfield {path} Ek {Erev} Xpower 1 
	tweaktau {path} X
end




