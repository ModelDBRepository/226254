/************************ VTA v2.14 BK.g *********************
*****Equations and Parameters for Big conductance calcium activated potassium channel*****
*****BK is both voltage and calcium dependent

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/
//reference: Jaffe et al. 2011, neuroscience
//using ab4 parameters as the beta4 subunit is strongly expressed in SNc neurons (piwonska et al., 2008 neuroscience)


function make_BK_channel
	str path = "BK_channel"
	float Erev=-0.090  
 	int xdivs = 100
    	int ydivs = {xdivs}
    	float xmin, xmax, ymin, ymax
    	xmin = -0.1; xmax = 0.05; ymin = 0.0; ymax = 0.005 // x = Vm, Volts; y = [Ca],mM
  
	create tab2Dchannel {path}

	setfield {path} Ek {Erev} Xindex {VOLT_C1_INDEX} Xpower 1 Ypower 0 Zpower 0

	call {path} TABCREATE X {xdivs} {xmin} {xmax} {ydivs} {ymin} {ymax}

    	int i, j
    	
    	float xincrement = (xmax - xmin)*1e3/{xdivs}
   	float yincrement = (ymax - ymin)/{ydivs}
   	float x = -100.00
	echo "Make BK channel"
	
    for (i = 0; i <= xdivs; i = i + 1)
        float y = ymin
	//float y = 0.0034
        for (j = 0; j <= ydivs; j = j + 1)
		
		float minf = {BK_inf {x} {y}}		

		float mtau = {BK_tau {x} {y}}
		
		//tab2Dchannels have no tweaktau option, so must convert inf and tau to alpha and beta. 
		//X_A field takes alphas, and X_B field takes alpha+beta (which is 1/tau)

		float alphabeta = {1/{mtau}}
		float alpha = {{minf}/{mtau}}

          	setfield BK_channel X_A->table[{i}][{j}] {alpha}
         	setfield BK_channel X_B->table[{i}][{j}] {alphabeta}

            	y = y + yincrement
        end
        x = x + xincrement
    end
    setfield BK_channel X_A->calc_mode {LIN_INTERP}
    setfield BK_channel X_B->calc_mode {LIN_INTERP}
		
end



