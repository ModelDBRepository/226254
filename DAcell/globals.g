/************************ VTA 2.14 Globals.g *********************
*****Set global variables for the model*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

	float ELEAK = -0.060		//Volts
    	float PI = 3.1415926
    	float RA = 4.0			//ohm*m
    	float RM = 5 			//ohm*m^2
    	float CM = 0.01			//farad/m^2
  	float EREST_ACT = -0.06		//Volts
 	float TEMPERATURE = 35		//C
	float Ca_OUT = 2 		//external calcium concentration in mM
	
	/*****Calcium info*****/
	str ca_pool = "ca_pool"
	int calciuminact = 0 //1 for CDI 0 for no CDI
	int qfactCa = 1
	
	/*****distances of dendrites*****/
	float soma = 26e-6
	float prox = 51e-6
	float mid = 101e-6
	float dist = 250e-6
	float TheEnd = 500e-6

	
	/*****channel maximal conductances (Siemans per meter squared) *****/
	float GNa = 250  
	float GNaL = 135e-3 
	float GKa = 24.5 //25 //27.5 //32

	float GKdr = 20 
	float GIh = 0.5 //1 //3
	float GSK = 3    
	float GBK = 500

	/*****channel maximal permeabilities for VGCCs *****/ 
	float GCaL12 = 1e-7 
	float GCaL13 = 5e-9  
	float GCaR = 5e-7  
	float GCaN = 12e-7 
	float GCaT = 1e-7 //10e-7 

	/*****synaptic channel maximal conductances*****/
	float gNMDA = 0.4e-9
	float gAMPA = 0.2e-9
	float gGABA = 100e-9
	
	float NMDAperCa = 0.1 //percent calcium influx 
	float NMDAfactGHK = 35e-9 	//adjustment factor for GHK to calcium pool (block sends Gk, but GHK takes permeability)
	float NMDACaGHK = {{NMDAperCa}*{NMDAfactGHK}}
	
	
	
	
