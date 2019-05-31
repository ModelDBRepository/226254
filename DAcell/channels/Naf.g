/************************ VTA v2.14 Naf.g *********************
*****Equations and Parameters for Na channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

//slight change from Tucker Canavier Levitan 2012 


function make_Na_channel
	float Erev       = 0.05      // Volts
   	str path = "Na_channel" 

    	float xmin  = -0.10  /* minimum voltage we will see in the simulation */     // Volts
    	float xmax  = 0.05  /* maximum voltage we will see in the simulation */      // Volts
    	int xdivsFiner = 3000
    	int c = 0
	float increment = (xmax - xmin)*1e3/xdivsFiner  // mV
	
	//activation variables match Tucker 2012
	float mhalf = -20.907  
	//shifted from -30.907 in Tucker et al., 2012 so spike threshold more closely matches our experiments
	float mslope = 9.7264
	float mrate = 1
	
	//fast inactivation variables match Tucker 2012
	float hhalf = -54.0289
	float hslope = -10.7665
	float hrate = 1     
		 
	//slow inactivation variables to match Ogata et al. 1990 
	//slow inactivation is OFF by default in this model
	float iA_rate = 40
	float iA_vhalf = -150
        float iA_slope = 9

        float iB_rate = 31
        float iB_vhalf = 60
        float iB_slope = -12
	

    	create tabchannel {path} 
   	call {path} TABCREATE X {xdivsFiner} {xmin} {xmax}  // activation   gate
    	call {path} TABCREATE Y {xdivsFiner} {xmin} {xmax}  // fast inactivation gate
	call {path} TABCREATE Z {xdivsFiner} {xmin} {xmax}  // slow inactivation gate
	
	setfield {path} Z_conc 0

	float x = -100.00             // mV

	echo "Make Na channel"

	for(c = 0; c < {xdivsFiner} + 1; c = c + 1) 

        	float minf = {boltz {mrate} {mhalf} {mslope} {x}}
	       	float malpha = {Namalpha {x}}
		float mbeta = {Nambeta {x}}
		float m_tau = 0.01+1/({malpha}+{mbeta})
        	float hinf = {boltz {hrate} {hhalf} {hslope} {x}}
		float halpha = {Nahalpha {x}}
		float hbeta = {Nahbeta {x}}
        	float h_tau = 0.4+1/({halpha} + {hbeta})

		float i_alpha = {sig_form {iA_rate} {iA_vhalf} {iA_slope} {x}}
		float i_beta = {sig_form {iB_rate} {iB_vhalf} {iB_slope} {x}}
		float zinf = {{i_alpha/(i_alpha+i_beta)}}

		/* 1e-3 converts from ms to sec for taus*/		

		setfield {path} X_A->table[{c}] {1e-3*{m_tau}}
        	setfield {path} X_B->table[{c}] {minf}
		setfield {path} Y_A->table[{c}] {1e-3*{h_tau}}
        	setfield {path} Y_B->table[{c}] {hinf}
		setfield {path} Z_A->table[{c}] 80e-3 
		setfield {path} Z_B->table[{c}] {zinf}

		x = x + increment
	end

   	setfield {path} Ek {Erev} Xpower 3 Ypower 1 Zpower 0

	tweaktau {path} X
	tweaktau {path} Y   
	tweaktau {path} Z


end


