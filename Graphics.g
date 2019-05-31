/************************ VTA v2.14 graphics.g *********************
*****sets up graphics for simulations*****
*****is included and functions are called in RunCell.g*****

Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/


	function make_graph (cellname)
		str cellname
		str xcell = "/data"	
		float tmax = 0.6
		float xmin = 0.01
					
		create xform  /data [0,0,1000,1000]
		
				
		create xlabel /data/label [10,0,95%,25] \
			-label "DA Cell" \
			-fg    red

		create xgraph /data/soma [10,10:label.bottom, 50%, 45%] \
			-title "Membrane potential in the soma" \
			-bg    white

		create xgraph /data/dend [10,10:soma.bottom,50%,45%] \
			-title "calcium concentration" \
			-bg    white 
	
		create xdraw /data/draw [10:soma.right,10:label.bottom,50%,45%]
		
		//create xcell /data/draw/cell 
		
		setfield /data/draw/cell colmin -0.1 colmax 0.1 		\
			path {cellname}/##[TYPE=compartment] field Vm		\				
			script "echo widget clicked on = <w> value = <v>"	
			xcolorscale hot
		
		create xgraph /data/int [10:dend.right,10:draw.bottom,48%,45%] \
			-title "Intrinsic currents" \
			-bg    white

		setfield /data/soma xmin {xmin} xmax {tmax+0.01} ymin -0.1 ymax 0.05
		setfield /data/dend xmin {xmin} xmax {tmax+0.01} ymin -0.1 ymax 0.05
		setfield /data/draw xmin -0.0004 xmax 0.0004 ymin -0.5e-3 ymax 0.5e-3 zmin -1e-3 zmax 1e-3
		setfield /data/int xmax {tmax+0.01}  ymin -1.2e-12 ymax 1.0e-13

  		useclock /data/soma 1
  		useclock /data/dend 1 
  		useclock /data/draw/cell 1
		useclock /data/int 1
		
		xshow /data
	
		reset
		
		/*****add messages to determine what is plotted*****/
		addmsg {cellname}/soma /data/soma PLOT Vm *Vm *black
		
	end
	
	
	
