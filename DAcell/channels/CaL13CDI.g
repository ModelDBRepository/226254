/************************ VTA v2.14 CaL13.g *********************
*****Equations and Parameters for low voltage activated cav 1.3 calcium channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/
//from Evans et al., 2013


function make_CaL13_channel
	str chanName = "CaL13_channel"
	str compPath = "/library"
	int c, a
	float Ek = 0.140  //(nernst calculated for 35degrees, [Cain] 50nM [Caout]2mM)
			//Ek is overwritten by the GHK object if it is used. 
	float xmin = -0.1
	float xmax = 0.05
	int 	xdivs = 3000
	float mPower = 1.0   //mh is an equally common form to m2h (tuckwell 2012)
	float hPower = 1.0
	if (calciuminact == 1)
		float zpower = 1.0
	else
		float zpower = 0
	end	
	
        float increment ={{xmax}-{xmin}}/{xdivs}
        echo "CaL13 increment:" {increment} "V"
	float x = -0.1
  	float surf = 0
 	float gMax = 0

	float hTauCaL13 	= 44.3e-3
	float mTauCaL13 	= 0.0
	float mvHalfCaL13 = -40.0e-3
	float mkCaL13     = -5e-3
	float hvHalfCaL13 = -37e-3
	float hkCaL13     = 5e-3
	float hInfCaL13	= 0.0
	float mInfCaL13	= 0.0

	//parameters for calcium-dep inactivation (CDI) 
	
	float Ca = 0.0
	float CaMax = 0.005 //5uM
	float CaMin = 0 
	float CaDivs = 3000
	float CaIncrement ={{CaMax}-{CaMin}}/{CaDivs}
        echo "CDIincrement:" {CaIncrement} 


	float theta	= 0.0
	float beta	= 0.0
	float beta_exp	= 0.0
	float mA = 0.0
	float mB = 0.0
	float qFactCaL13 = 0.5 //{qfactCa}
	
	
	create tabchannel {chanName}
  	setfield {chanName} Ek {Ek} Xpower {mPower} Ypower {hPower} Zpower {zpower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}
        call {chanName} TABCREATE Y {xdivs} {xmin} {xmax}
		
//fill in the voltage act and inact tables

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/************************ Begin CaL13_mTau *********************/
		//mA = 39800*(vMemb + 67.24e-3)./(exp((vMemb + 67.24e-3)/15.005e-3) - 1);
		//mB = 3500*exp(vMemb/31.4e-3);
		//mTauCaL13 = 1./(mA + mB) / qFactCaL13;
		//parameters tuned to fit Tuckwell 2012 figure 12

		theta = 39800*{ {x} + 67.24e-3}
		beta = {{x} + 67.24e-3}/15.005e-3
		beta_exp = {exp {beta}}
		beta_exp = beta_exp - 1.0
		mA = {{theta}/{beta_exp}}
		
		beta = {{x}/31.4e-3}
		beta_exp = {exp {beta}} 
		mB = 3500*{beta_exp}

		mTauCaL13 = {{1/{mA + mB}}/{qFactCaL13}}	
		setfield {chanName} X_A->table[{c}] {mTauCaL13}
		/************************ End CaL13_mTau ***********************/		

		/************************ Begin CaL13_mInf *********************/
		// mInfCaL13   = 1./(1 + exp((vMemb - mvHalfCaL13)/mkCaL13));
		//parameters tuned to fit Tuckwell 2012 figure 3
		beta = {{x} - {mvHalfCaL13}}/{mkCaL13}
		beta_exp = {exp {beta}} + 1.0
		mInfCaL13 = 1.0/{beta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaL13}
		/************************ End CaL12_mInf ***********************/	

		/************************ Begin CaL13_hTau *********************/
		// hTauCaL13 
		setfield {chanName} Y_A->table[{c}] {{hTauCaL13}/{qFactCaL13}}
		/************************ End CaL12_hTau ***********************/

		/************************ Begin CaL13_hInf *********************/
		// hInfCaL13   = 1./(1 + exp((vMemb - hvHalfCaL13)/hkCaL13));
		//parameters tuned to fit Tuckwell 2012 figure 12
		beta = {{x} - {hvHalfCaL13}}/{hkCaL13}
		beta_exp = {exp {beta}} + 1.0
		hInfCaL13 = 1.0/{beta_exp}
		setfield {chanName} Y_B->table[{c}] {hInfCaL13}
		/************************ End CaL13_hInf ***********************/	
   	x = x + increment
	end	

	tweaktau {chanName} X
	tweaktau {chanName} Y

//fill in the Z table with CDI values
//equation from Tuckwell review paper 2012 progress in neurobiology table A1.3 
	if (calciuminact == 1)
		
		call {chanName} TABCREATE Z {CaDivs} {CaMin} {CaMax}
	
		int a
		float CDI
		float q, k, b, n
		for(a = 0; a < {CaDivs} + 1; a = a + 1)
			//f= (0.001/(0.001+[Ca]))Poirazi CA1  2003
			//f= (0.0005/(0.0005+[Ca])) Rhodes and Llinas 2001 Cort Pyr
			Ca=a*{CaIncrement}
			k=0.001
			q = {{k}/({k}+{Ca})}
			CDI = {q}
			setfield {chanName} Z_B->table[{a}] {CDI}
			setfield {chanName} Z_A->table[{a}] {{142e-3}} //CaL1.2 in HEK cells Barrett and Tsien 2007 roomtemp
		end	
		tweaktau {chanName} Z 
	end	

	
end
