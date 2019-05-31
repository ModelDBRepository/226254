/************************ VTA v2.14 add_outputVm.g *********************
*****Function to output data to asc_files*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/

function add_output
	create asc_file /output/plot_out
	setfield /output/plot_out   flush 1  leave_open 1 append 1 \
        float_format %0.6g
    	useclock /output/plot_out 1

	addmsg /cell/soma /output/plot_out  SAVE Vm
		
end

/* copy into header.g file:
call /output/plot_out OUT_OPEN
call /output/plot_out OUT_WRITE "time SomaVm" 
*/

