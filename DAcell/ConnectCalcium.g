
/************************ VTA v2.14 ConnectCalcium.g *********************
*****Functions for connecting calcium GHK, pools, and SK channels*****
Functions in this file:

connect_calcium: called by add_channel in MakeCell.g
connect_potassium: called by add_channel in MakeCell.g
connect_NMDA: called by add_synaptic_channel in MakeCell.g

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/



	function connect_calcium (channel, path, pool)
		str channel, path, pool
		
		create ghk {path}/{channel}GHK
		
		setfield {path}/{channel}GHK Cout {Ca_OUT}
		setfield {path}/{channel}GHK valency 2.0
		setfield {path}/{channel}GHK T {TEMPERATURE}
		
		addmsg {path}/{channel}GHK {path}/{pool} I_Ca Ik 
		addmsg {path}/{pool} {path}/{channel}GHK CIN Ca  
		addmsg {path}/{pool} {path}/{channel} CONCEN C 
		addmsg {path} {path}/{channel}GHK VOLTAGE Vm
		addmsg {path}/{channel}GHK {path} CHANNEL Gk Ek
		addmsg {path}/{channel} {path}/{channel}GHK PERMEABILITY Gk
	
	end
  
	function connect_potassium (channel, path, pool)
		str channel, path, pool
		
		addmsg {path}/{channel} {path} CHANNEL Gk Ek
		addmsg {path}/{pool} {path}/{channel} CONCEN Ca
		
	end
 
	function connect_NMDA (channel, path, pool, ghk)
		str channel, path, pool
		int ghk

		if (ghk==0)
			addmsg {path}/{channel}/block {path}/{pool} fI_Ca Ik {NMDAperCa}		elif (ghk==1)
			create ghk {path}/{channel}/GHK

     			setfield {path}/{channel}/GHK Cout {Ca_OUT}
     			setfield {path}/{channel}/GHK valency 2.0
     			setfield {path}/{channel}/GHK T {TEMPERATURE}

     			addmsg {path}/{channel}/block {path}/{channel}/GHK PERMEABILITY Gk 				
			addmsg {path}/{channel}/GHK {path}/{pool} fI_Ca Ik {NMDACaGHK}  
			addmsg {path}/{pool} {path}/{channel}/GHK CIN Ca		end

	end
 

