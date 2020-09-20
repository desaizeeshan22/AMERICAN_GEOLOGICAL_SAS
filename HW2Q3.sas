data temp3.VITE;
	set "/folders/myshortcuts/myfolder/vite.sas7bdat";
	run;

proc contents data = temp3.VITE; 
run;
proc transpose data=temp3.VITE out=temp3.wide_VITE prefix=VISIT_;
by id Treatment;
var Plaque;
id visit;
run;
data temp3.wide_no_placebo ;
 set temp3.wide_VITE;
 where Treatment=1;  
run;
proc ttest data=temp3.wide_no_placebo alpha= 0.05;
paired VISIT_0*VISIT_2; /* before treatment and after second visit interaction term */
run;

data temp3.wide_VITE_control ;
set temp3.wide_VITE ;
plaque_diff = (VISIT_2-VISIT_0);
run;
proc ttest data=temp3.wide_VITE_control alpha= 0.05;
class treatment;
var plaque_diff;
run;

title1 'Ho: Zero difference in alcohol consumption between treatment and control ';
proc ttest data=temp3.VITE;
 class Treatment; 
 var Alcohol; 
 run;

 title1 'Ho: Zero difference in cigarette consumption between treatment and control ';
proc ttest data=temp3.VITE;
 class Treatment; 
 var Smoke; 
 run;