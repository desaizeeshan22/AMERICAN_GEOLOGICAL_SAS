data temp3.Study_GPA;
	set "/folders/myshortcuts/myfolder/study_gpa.sas7bdat";
	run;
	
proc sgplot data = temp3.Study_GPA;
histogram AveTime / binstart = 0 binwidth = 5;
density AveTime;
density AveTime / type = kernel;
title 'Study hours';
run;
data temp3.study_section02;
set temp3.Study_GPA;
where Section= "02";
run;
proc sort data=temp3.study_section02;
 by Units GPA;
run;

proc corr data = temp3.study_section02;
var Units AveTime GPA;
run;