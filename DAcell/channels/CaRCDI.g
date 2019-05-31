/************************ VTA v2.14 CaRCDI.g *********************
*****Equations and Parameters for R type calcium channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/
//from Evans et al., 2013


function make_CaR_channel
	str chanName = "CaR_channel"
	str compPath = "/library"

	int c = 0	

	int xdivs = 3000
	float Ek = 0.140  //(nernst calculated for 35degrees, [Cain] 50nM [Caout]2mM)
			//Ek is overwritten the the GHK object if it is used. 
	float x = -0.1
	float xmin = -0.1
	float xmax = 0.05
        float increment ={{xmax}-{xmin}}/{xdivs}
	echo "make CaR channel"        
	//echo "CaR increment:" {increment} "V"
  	float mPower = 3.0  //Foerhing et al., 2000 p 2228
  	float hPower = 1.0
	if (calciuminact == 1)
		float zpower = 1.0
	else
		float zpower = 0
	end

	float mvHalfCaR = -29e-3  
	float mkCaR     = -9.6e-3
	float hvHalfCaR = -33.3e-3
	float hkCaR     = 17e-3

	float mTauCaR = 5.1e-003  //Foehring et al., 2000 pg 2230.
	float mInfCaR = 0.0
	float hTauCaR = 0.0
	float hInfCaR = 0.0
	float hA 
	float hB

	//parameters for calcium-dep inactivation (CDI) 
	
	float Ca = 0.0
	float CaMax = 0.005 //5uM
	float CaMin = 0 
	float CaDivs = 3000
	float CaIncrement ={{CaMax}-{CaMin}}/{CaDivs}
       // echo "CDIincrement:" {CaIncrement} 

	float qFactCaR = {qfactCa}

	float surf = 0.0
	float gMax = 0

	float theta = 0.0
	float theta_exp = 0.0

	float beta = 0.0
	float beta_exp = 0.0

	create tabchannel {chanName}
  	setfield {chanName} Ek {Ek} Xpower {mPower} Ypower {hPower} Zpower {zpower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}
   call {chanName} TABCREATE Y {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/************************ Begin CaR_mTau *********************/
		// mTauCaR 
		setfield {chanName} X_A->table[{c}] {{mTauCaR}/{qFactCaR}}
		/************************ End CaR_mTau ***********************/
		
		/************************ Begin CaR_mInf *********************/
		//mInfCaR   = 1./(1 + exp((vMemb - mvHalfCaR)/mkCaR));
		// parameters tuned to fit Foerhing et al., 2000 fig 6
		theta = {{x} - {mvHalfCaR}}/{mkCaR}
		theta_exp = {exp {theta}} + 1.0
		mInfCaR = 1.0/{theta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaR}
		/************************ End CaR_mInf ***********************/

	
		/************************ Begin CaR_hTau *********************/
		// hA = 10e6*(vMemb + 0.0945)./
		//                      (exp((vMemb + 0.0945)/0.00512)-1);
		// hB = 84.2*exp(vMemb/0.013);
		// hTauCaR = ((1/(hA + hB))+0.1) / qFactCaR;
		// parameters tuned to fit Brevi 2001 fig 10


		theta = {{10e6}*{ {x} + 0.0945}}
		beta = {{x}  + 0.0945}/0.00512
		beta_exp = {exp {beta}}
		beta_exp = beta_exp - 1.0
		hA = {{theta}/{beta_exp}}

		beta = {{x}/0.013}
		beta_exp = {exp {beta}} 
		hB = 84.2*{beta_exp}

		hTauCaR = {{1.0/{{hA} + {hB}}}+0.02}		
		setfield {chanName} Y_A->table[{c}] {hTauCaR}/{qFactCaR}
		/************************ End CaR_hTau ***********************/
		
		/************************ Begin CaR_hInf *********************/
		//hInfCaR   = 1./(1 + exp((vMemb - hvHalfCaR)/hkCaR));
		// parameters tuned to fit Foerhing et al., 2000 fig 7
		theta = {{x} - {hvHalfCaR}}/{hkCaR}
		theta_exp = {exp {theta}} + 1.0
		hInfCaR = 1.0/{theta_exp}
		setfield {chanName} Y_B->table[{c}] {hInfCaR}
		/************************ End CaR_hInf ***********************/
    	x = x + increment
	end

	tweaktau {chanName} X
	tweaktau {chanName} Y

	//fill in the Z table with CDI values
	
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


