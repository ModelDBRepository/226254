/************************ VTA v2.14 tabchanforms.g *********************
*****functions for tab channel equations*****


Rebekah Evans rebekah.evans@nih.gov

**************************************************************************/


function exp_form (rate, slope, V)
	float rate,slope,V
	//equation is ({rate} *(exp ({-V}/{slope}) ))
	float numx ={{-V}/{slope}}
	float expx = {exp {numx}}
	float entry = ({rate}*{expx})
	return {entry}
end

function sig_form (rate, vhalf, slope, V)
	float rate, vhalf, slope, V
	//equation is ({rate}/(exp ({{V}-{vhalf}}/{slope})+1))
	//rate/(EXP((v-vhalf)/slope)+1)
	float numx = {{{V}-{vhalf}}/{slope}}
	float expx = {exp {numx}}
	float entry = ({rate}/{{expx}+1})
	return {entry}
end

function lin_form (rate, vhalf, slope, V)

	float rate, vhalf, slope, V
	//equation is (({rate}*({V}-{vhalf}))/{exp ({v}-{vhalf}/{slope})-1)})
	float expx = {exp {{{V}-{vhalf}}/{slope}}} -1
	float numerator = {{rate}*{{V}-{vhalf}}}
	float entry = {{numerator}/{expx}}
	return {entry}
	
end

//from Kustnetsova 2010

function boltz (rate, vhalf, slope, V)
	float rate, vhalf, slope, V
	//equation is (1/1+exp(-(V-vhalf)/slope))
	float numx = {-{{V}-{vhalf}}/{slope}}
	float expx = {exp {numx}}
	float entry = {1/{1+{expx}}}
	return {entry}
end


function Ka_tau (rate, vhalf, slope, V)
	float rate, vhalf, slope, V
	//equation is (2*exp(-(V+vhalf)*(V+vhalf)/slope)+1.1)
	float numx = {({V}+{vhalf})*({V}+{vhalf})/{slope}}
	float negx = {-{numx}}
	float expx = {exp {negx}}
	float entry = 2*{expx}+1.1
	return {entry}
end

function Kdr_tau (V)
	float V
	//equation is {19/{1+exp {{x+39}/8}}-0/{1+exp {{{x}+59}/20}}+1}
	float num1 = {{{V}+39}/8}
	float num2 = {{{V}+59}/20}
	float exp1 = {exp {num1}}
	float exp2 = {exp {num2}}
	float S1 = {19/{1+{exp1}}}
	float S2 = {0/{1+{exp2}}}
	float entry = {{S1}-{S2}+1}
	return {entry}
end
	
function gaussian (v,a,b,c,d)
	float v,a,b,c,d
	//equation is (a*exp(-(c+v)*(c+v)/(b*b))+d)
	float CV = {{c}+{v}}*{{c}+{v}}
	float b2 = {b}*{b}
	float exp1 = {exp {-{CV}/{b2}}}
	float entry = {{a}*{exp1}+{d}}
	return {entry}
end


function Ih_inf (rate, vhalf, slope, V)
	float rate, vhalf, slope, V
	//equation is (1/1+exp((V-vhalf)/slope))
	float numx = {{{V}-{vhalf}}/{slope}}
	float expx = {exp {numx}}
	float entry = {1/{1+{expx}}}
	return {entry}
end

//BK from Jaffe et al. 2011

function BK_inf (v, ca)
	//equation is 1/(1+exp(({-56.449+104.52*exp(-0.22964*{y}*1000)+295.68*exp(-2.1571*{y}*1000)}-{x})/(25/1.6)))
	float v, ca
	
	float exp1a = (-0.22964*{ca}*1000)
	float exp1b = {exp {exp1a}}
	float exp2a = (-2.1571*{ca}*1000)
	float exp2b = {exp {exp2a}}
	
	float preinf = {-56.449 + 104.52 * {exp1b} + 295.68 * {exp2b}}
	float inf = (({preinf}-{v})/(25/1.6))
	float exp3 = {exp {inf}}	
	float entry = {1/(1 + {exp3})}
	return {entry}
end

function BK_tau (v, ca)
	float v, ca 

	float exp1a = {-0.28*{ca}*1000}
	float exp1b = {exp {exp1a}}
	float exp2a = {-0.72*{ca}*1000}
	float exp2b = {exp {exp2a}}

	float shift = {25-55.7+136.9*{exp1b}}
	float peak = {13.7 + {234*{exp2b}}}

	float vv = {{v} + 100 - {shift}}
	float range = {{peak}-1}

	float exp3a = {-{vv}/63.6}
	float exp3b = {exp {exp3a}}

	float exp4a = {-(150-{vv})/63.6}
	float exp4b = {exp {exp4a}}
	
	float pretau = {1/(10*({exp3b}+{exp4b})-5.2)}

	if ({pretau}<=0.2)
		pretau = 0.2
	end

	float entryX = {({range}*(({pretau}-0.2)/0.8)) + 1}
	//convert to seconds
	float entry = {1e-3*{entryX}}	
	return {entry}
end

//all from Tucker et al. 2012 table 1

function Namalpha (v)
	float v
	float num = {15.6504+0.4043*{v}}
	float exp1 = {-19.565-0.50542*{v}}
	float expa = {exp {exp1}}
	float den = {expa}-1
	float entry = -{num}/{den}
	return {entry}
end

function Nambeta (v)
	float v
	float exp1 = {-7.4630e-3*{v}}
	float expa = {exp {exp1}}
	float entry = {3.0212*{expa}}
	return {entry}
end

function Nahalpha (v)
	float v
	float exp1 = {-6.3213e-2*{v}}
	float expa = {exp {exp1}}
	float entry = {5.0754e-4*{expa}}
	return {entry}
end

function Nahbeta (v)
	float v
	float exp1 = {0.13442*{v}}
	float expa = {exp {exp1}}
	float entry = {9.7529*{expa}}
	return {entry}
end




	
