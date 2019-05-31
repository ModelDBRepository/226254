/************************ VTA 2.14 RunCell.g *********************
*****Set clocks and graphics, call make_cell function and run simulation files*****

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

	str cellpath = "/cell"
	str pfile = "DAcell/morphtest1.31.p"  //cell parameter file
	str diskpath1 = "VTA2.14" //name of output file
	
	include Graphics.g
	include DAstims/add_outputVm.g
	include DAcell/MakeCell.g
	

	float outputclock=2e-5
		setclock 0 5e-6   // Simulation time step (Seconds)       
		setclock 1 {outputclock}
	reset

	make_cell {cellpath} {pfile}
	make_graph {cellpath}

	reset
	
/*****start running simulations*****/

//include DAstims/GABAstim.g

include DAstims/IV.g

setfield /data/soma overlay 1


