/************************ VTA v2.14 CaNCDI.g *********************
*****Equations and Parameters for N type calcium channel*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/
//from Evans et al., 2013


function make_CaN_channel
	str chanName = "CaN_channel"
	str compPath = "/library"

	int c	
	float Ek = 0.140 //(nernst calculated for 35degrees, [Cain] 50nM [Caout]2mM)
			//Ek is overwritten the the GHK object if it is used. 
	float x = -0.1
	int xdivs = 3000
	float xmin = -0.1
	float xmax = 0.05
        float increment ={{xmax}-{xmin}}/{xdivs}
	echo "Make CaN channel"
       // echo "CaN increment:" {increment} "V"
  	float mPower = 2.0  // Kasai 1992 p169
  	float hPower = 1.0
	if (calciuminact == 1)
		float zpower = 1.0
	else
		float zpower = 0
	end	

	float mvHalfCaN = -3e-3
	float mkCaN = -8e-3
	float hvHalfCaN = -74.8e-3
	float hkCaN = 6.5e-3
	float mTauCaN = 0.0
	float mInfCaN = 0.0
	float hTauCaN = 70e-3
	float hInfCaN = 0.0
	//parameters for calcium-dep inactivation (CDI) 
	
	float Ca = 0.0
	float CaMax = 0.005 //5uM
	float CaMin = 0 
	float CaDivs = 3000
	float CaIncrement ={{CaMax}-{CaMin}}/{CaDivs}
       // echo "CDIincrement:" {CaIncrement} 

	float theta	= 0.0
	float theta_1 = 0.0
	float beta	= 0.0
	float beta_exp	= 0.0
	float mA	= 0.0
	float mB	= 0.0
	float surf = 0.0
 	float gMax = 0
	float qFactCaN = {qfactCa}

	create tabchannel {chanName}
  	setfield {chanName} Ek {Ek} Xpower {mPower} Ypower {hPower} Zpower {zpower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}
        call {chanName} TABCREATE Y {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs}; c = c + 1)
		/************************ Begin CaN_mTau *********************/
		// mA = 39800*(vMemb + 17.19e-3)./
		//                      (exp((vMemb + 17.19e-3)/15.22e-3)-1);
		// mB = 384.2*exp(vMemb/23.82e-3);
		// mTauCaN = (1./(mA + mB)) / qFactCaN;
		// parameters tuned to fit Kasai 1992


		theta = 39800*{ {x} + 17.19e-3}
		beta = {{x}  + 17.19e-3}/15.22e-3
		beta_exp = {exp {beta}}
		beta_exp = beta_exp - 1.0
		mA = {{theta}/{beta_exp}}

		beta = {{x}/23.82e-3}
		beta_exp = {exp {beta}} 
		mB = 384.2*{beta_exp}

		mTauCaN = {{1.0/{mA + mB}}/{qFactCaN}}		
		setfield {chanName} X_A->table[{c}] {mTauCaN}
		/************************ End CaN_mTau ***********************/
	
		/************************ Begin CaN_mInf *********************/
		// mInfCaN   = 1./(1 + exp((vMemb - mvHalfCaN)/mkCaN));
		// parameters tuned so m2 fits Bargas and Surmeier 1994 boltzmann curve
		beta = {{x} - {mvHalfCaN}}/{mkCaN}
		beta_exp = {exp {beta}} + 1.0
		mInfCaN = 1.0/{beta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaN}
		/************************ End CaN_mInf ***********************/

		/************************ Begin CaN_hTau *********************/ 
		// hTauCaN  Mcnaughton et al., 1997 table 2 tau 1 for calcium
		setfield {chanName} Y_A->table[{c}] {{hTauCaN}/{qFactCaN}}
		/************************ End CaN_hTau ***********************/

		/************************ Begin CaN_hInf *********************/
		// hInfCaN   = 1./(1 + exp((vMemb - hvHalfCaN)/hkCaN));
		// Mcnaughton et al., 1997 table 2
		beta = {{x} - {hvHalfCaN}}/{hkCaN}
		beta_exp = {exp {beta}} + 1
                //0.21 has vdep inactivation, 0.79 does not inactivate
                hInfCaN = 0.21 * {1/{beta_exp}} + 0.79
 		setfield {chanName} Y_B->table[{c}] {hInfCaN}
		/************************ End CaN_hInf ***********************/
	
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



