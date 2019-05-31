
/************************ VTA v2.14 MakeCell.g *********************
*****Functions for making compartments, making channels, and making cell*****
Functions in this file:

make_compartment: called by function make_cell (makes prototype compartment and channels)
set_position: called by make_cell
add_pool: called by make_cell
add_channel: called by function add_intrinsic_channels
add_synaptic_channel: called by function add_shaft_synapses
add_intrinsic_channels: called by function make_cell
add_shaft_synapses: called by function make_cell
make_cell: called by RunCell.g

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

include DAcell/globals.g
include DAcell/tabchanforms.g
include DAcell/ConnectCalcium.g

//includes for making each channel
include DAcell/channels/Naf.g
include DAcell/channels/NaL.g
include DAcell/channels/Kaf.g
include DAcell/channels/Kv2.g
include DAcell/channels/Ih.g
include DAcell/channels/CaL12CDI.g
include DAcell/channels/CaL13CDI.g
include DAcell/channels/CaRCDI.g
include DAcell/channels/CaNCDI.g
include DAcell/channels/CaT.g
include DAcell/channels/SK.g
include DAcell/channels/BK.g
include DAcell/channels/NMDA.g
include DAcell/channels/AMPA.g
include DAcell/channels/GABA.g



	function make_compartment 
	
		create neutral /library
		disable /library

		pushe /library
	
		if (!{exists compartment})
			create	compartment compartment
		end
	
		addfield compartment position   //add a new field "postion" to store distance to soma
		setfield compartment 		\ 
			Em         {ELEAK} 	\
			initVm     {EREST_ACT} 	\
			inject		0.0 	\
			position    0.0
		
		//makes voltage gated channels in library
		make_Na_channel	
		make_NaP_channel
		make_Ka_channel
		make_Kdr_channel
		make_Ih_channel
		
		//voltage gated calcium channels in library
		make_CaL12_channel		
		make_CaL13_channel
		make_CaR_channel
		make_CaN_channel
		make_CaT_channel		
		
		//calcium activated potassium channels in library
		make_SK_channel
		make_BK_channel

		//synaptic channels in library
		make_NMDA_channel
		make_AMPA_channel
		make_GABA_channel
			
		//make spines in library		
		make_spine

		pope
	end
	
	
	
	function set_position (cellpath)
		str compt, cellpath
		float dist2soma,x,y,z
 		echo "running set_position"
		
		foreach compt ({el {cellpath}/##[TYPE=compartment]})
			x={getfield {compt} x}
			y={getfield {compt} y}
			z={getfield {compt} z}
			dist2soma={sqrt {({pow {x} 2 }) + ({pow {y} 2}) + ({pow {z} 2})} }  
			setfield {compt} position {dist2soma}
		end
	end
	
	function add_pool (cellpath, poolname)
		str cellpath, poolname, compt
		float len, dia, kb   		
		float shell_thick = 0.1e-6 	//meters
		float Ca_base = 50e-6   	//mM
		float Ca_tau = 25e-3 		//seconds
		
		foreach compt ({el {cellpath}/##[TYPE=compartment]})
			if (!{{compt} == {{cellpath}@"/axIS"} || {compt} == {{cellpath}@"/ax"}}) 
				dia = {getfield {compt} dia}
				len = {getfield {compt} len}
				
				if ({{getpath {compt} -tail} == "soma"})
					len = dia
					kb = 200
				else 
					kb = 96
				end
				
				float  shell_dia = dia - shell_thick*2
				float  shell_vol= {PI}*(dia*dia/4-shell_dia*shell_dia/4)*len
								
				create Ca_concen  {compt}/{poolname}  // create Ca_pool here!
							
				setfield {compt}/{poolname} \
					B          {1.0/(2.0*96494*shell_vol*(1+kb))} 	\
					tau        {Ca_tau}                        		\
					Ca_base    {Ca_base}   							\
					thick      {shell_thick}  
			end
   		end
  	end
	
	
	
	function add_channel(obj, a, b, Gchan, cellpath, chantype)
		echo "adding channel" {obj}
		str obj, compt, cellpath, chantype
		float dia, len, surf, a, b, position, Gchan
		
		if (!{exists /library/{obj}} )
			echo the object {obj} has not been made  
			return
		end

		foreach compt ({el {cellpath}/##[TYPE=compartment]})
			dia = {getfield {compt} dia}
			position = {getfield {compt} position} 

			if ({({dia} > 0.11e-6) && {position > a} && {position <= b} }) 
			//checks that compartment is not a spine, and that position is between [a,b]

				len = {getfield {compt} len}
				if ({{getpath {compt} -tail} == "soma"})
					len = dia
				end
				surf = dia*{PI}*len 						
				//calculates surface area 
			
				copy /library/{obj} {compt}					
				addmsg {compt} {compt}/{obj} VOLTAGE Vm
				setfield {compt}/{obj} Gbar {Gchan*surf} 	//sets maximal conductance
				
				if ({chantype} == "V")
					addmsg {compt}/{obj} {compt} CHANNEL Gk Ek
				elif ({chantype} == "KC")
					connect_potassium {obj} {compt} {ca_pool} //in ConnectCalcium.g
				elif ({chantype}=="C")
					connect_calcium {obj} {compt} {ca_pool}  //in ConnectCalcium.g
				end			
				
					
			end
		end
	end

	function add_synaptic_channel (obj, a, b, gchan, cellpath, ca_pool)
		str obj, cellpath, compt, ca_pool
		float gchan, a, b, position
		echo "adding synaptic channel" {obj}

		if (!{exists /library/{obj}} )
			echo the object {obj} has not been made  
			return
		end

		foreach compt ({el {cellpath}/##[TYPE=compartment]})
			position = {getfield {compt} position} 
			if ({position > a} && {position <= b}) 
			//checks that position is between [a,b]
						
				copy /library/{obj} {compt}
				setfield {compt}/{obj} gmax {gchan}
				
				if ({obj} == "NMDA")
					addmsg {compt} {compt}/{obj}/block VOLTAGE Vm
					addmsg {compt} {compt}/{obj} VOLTAGE Vm	
					addmsg {compt}/{obj}/block {compt} CHANNEL Gk Ek
					connect_NMDA {obj} {compt} {ca_pool} 0 //in ConnectCalcium.g sets GHK to 0 for off or 1 for on					
				elif ({obj} == "AMPA" || {obj} == "GABA")
					addmsg {compt} {compt}/{obj} VOLTAGE Vm	
					addmsg {compt}/{obj} {compt} CHANNEL Gk Ek
				end
				
				
			end
		end
	end


	
	function add_intrinsic_channels (cellpath)
		str cellpath
		
		add_channel "Na_channel" 0 {TheEnd} {GNa} {cellpath} "V"

		add_channel "NaL_channel" 0 {TheEnd} {GNaL} {cellpath} "V"
		
		add_channel "Ka_channel" 0 {prox} {GKa} {cellpath} "V"
		
		add_channel "Kdr_channel" 0 {TheEnd} {GKdr} {cellpath} "V"
		
		add_channel "Ih_channel" 0 {TheEnd} {GIh} {cellpath} "V"
		
		add_channel "CaL12_channel" 0 {TheEnd} {GCaL12} {cellpath} "C"

		add_channel "CaL13_channel" 0 {TheEnd} {GCaL13} {cellpath} "C"

		add_channel "CaR_channel" 0 {TheEnd} {GCaR} {cellpath} "C"
		
		add_channel "CaN_channel" 0 {TheEnd} {GCaN} {cellpath} "C"
		
		add_channel "CaT_channel" {soma} {TheEnd} {GCaT} {cellpath} "C"
		
		add_channel "SK_channel" 0 {TheEnd} {GSK} {cellpath} "KC"
		
		add_channel "BK_channel" 0 {TheEnd} {GBK} {cellpath} "KC"
		
		echo "intrinsic channels added"
		
	end
	
	function add_shaft_synapses (cellpath)
		add_synaptic_channel "NMDA" 0 {TheEnd} {gNMDA} {cellpath} {ca_pool}
		
		add_synaptic_channel "AMPA" 0 {TheEnd} {gAMPA} {cellpath} {ca_pool}

		add_synaptic_channel "GABA" 0 {TheEnd} {gGABA} {cellpath} {ca_pool}
				
		echo "synaptic channels added"
	end

	
	function make_cell(cellpath, pfile)
	
		str cellpath, pfile
		
		make_compartment
		
		readcell {pfile} {cellpath}
		
		set_position {cellpath}
		
		add_pool {cellpath} {ca_pool}
		
		add_intrinsic_channels {cellpath}

		add_shaft_synapses {cellpath}
		
	end	
	

	
