/************************ VTA 2.14 IV.g *********************
*****Runs a current-voltage input output curve*****

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

	str stimtype = "-80pA"
	str diskpath={diskpath1}@(stimtype)@".txt"
	echo {diskpath}

	add_output	

	setfield /output/plot_out filename output/{diskpath}

	include DAstims/header.g

	int i = 0
	float inj = -80.0e-12
             
	float start_current = 0
	float predelay = 0.5	
	float postdelay = 1.5
	float current_duration = 1 
reset

	setfield /data/soma overlay 1

for (i=0; i<1; i=i+1)
		
    echo {inj} = "I inject"
	setfield {cellpath}/soma inject {start_current}
	step {predelay} -time
	setfield {cellpath}/soma inject {inj}
	step {current_duration}  -time
	setfield {cellpath}/soma inject {start_current}
	step {postdelay} -time
	reset
	inj= {inj}-20.0e-12
end


