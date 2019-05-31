/************************ VTA v2.14 GABAstim.g *********************
*****GABAergic stimulation*****

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/
	
	include DAcell/PreSyn.g //function make_presynaptic_terminals

	str stimtype = "GABAstim50Hz300ms"
	float num_synapses = 1
	float ISI = 0.02
	str loc = "soma"

	str diskpath={diskpath1}@(stimtype)@{loc}@".txt"
	echo {diskpath}


	add_output	

	setfield /output/plot_out filename output/{diskpath}

	include DAstims/header.g

	make_presynaptic_terminals {num_synapses}
	
	int i
	for (i = 0; i < {num_synapses}; i = i + 1) 
		addmsg presyn{i}/spike {cellpath}/{loc}/GABA SPIKE
	end

	reset

	
	step 1.5 -time
	
	int c=0
	for (c=0; c<16; c=c+1)
		setfield presyn{0} Vm 10
		step 1 
		setfield presyn{0} Vm 0

		step {ISI} -t

	end

	step 1.5 -time
	
	




