/************************ VTA v2.14 SK.g *********************
*****Equations and Parameters for small conductance calcium activated potassium channel*****
*****SK is calcium, but not voltage dependent*****

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

//Reference: Maylie,Bond,Herson,Lee,Adelman,2004
//implemented in Evans et al. 2013
	
function make_SK_channel
	str path = "SK_channel" 
  	float Erev = -0.090
	int nStep = 3000
  	float SKact = 0.0
  	float CaMax = 0.1 	// 100 uM
	float CaMax = 0.006 // 6 uM 
	float CaMin = 1e-6 	//1 nM
	float CaMin = 0 
  	float delta = (CaMax - CaMin)/nStep  
	float theta = 0.0
	float theta_pow = 0.0	
 	float Kd = 0.57e-3

	int i
   	float Ca = 0.0  	

  	create  tabchannel {path}
  	
	setfield {path} Ek {Erev} Zpower 1			

  	call {path} TABCREATE Z {nStep} {CaMin} {CaMax} // Creates nStep entries
	
	for (i = 0; i < {nStep}; i = i + 1)		 		
 		Ca=i*delta
   		theta = {Ca/Kd}
  		theta_pow = { pow {theta} 5.2}
  		SKact = theta_pow/{1 + theta_pow}
     		setfield {path} Z_A->table[{i}] {4.9e-3} // Fast component, tau=4.9ms from Hirschberg et al., 1998 figure 13.	
		setfield {path} Z_B->table[{i}] {SKact} //from Maylie et al., 2004 figure 2 
		
	end		   	  		 			 
  	
	tweaktau {path} Z
  
end


