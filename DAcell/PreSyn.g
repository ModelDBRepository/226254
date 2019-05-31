/************************ VTA v2.14 PreSyn.g *********************
*****Functions to create presynaptic input to synaptic channels*****
Function is called by stimulation files in DAstim such as GABAstim.g

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

function make_presynaptic_terminals (number)
	int number
	int i=0
	for (i = 0; i < {number}; i = i + 1)
		create compartment presyn{i}
		create spikegen presyn{i}/spike
		setfield presyn{i}/spike thresh 1
		addmsg presyn{i} presyn{i}/spike INPUT Vm
	end
end


