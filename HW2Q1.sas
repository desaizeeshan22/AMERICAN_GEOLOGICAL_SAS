LIBNAME temp3 "/folders/myshortcuts/myfolder/EPG194/data";
data temp3.earthquakes;
	set "/folders/myshortcuts/myfolder/earthquakes.sas7bdat";
	run;

data temp3.earthquake_agg;
	set temp3.earthquakes;

	if state="California" or state="Alaska";
run;

proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) mean 
		median stddev min max p25 p75;
	class year state;
	var magnitude;
run;

proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) mean 
		median stddev min max p25 p75;
	class state;
	by year notsorted;
	var magnitude;
run;

proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) mean 
		median stddev min max p25 p75;
	class year;
	by state notsorted;
	var magnitude;
run;

proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) MEAN;
	class year state;
	VAR magnitude;
	OUTPUT OUT=temp3.earthquake_mean;
run;

data temp3.earthquake_mean_fin;
	set temp3.earthquake_mean;

	if _stat_="MEAN";

	if year=" " or state="." or state=" " THEN
		DELETE;
	DROP _TYPE_ _FREQ_ _STAT_;
run;

proc sgpanel data=temp3.earthquake_mean_fin;
	panelby State;
	series x=year y=Magnitude;
	title 'Average magnitude Over Time';
run;

PROC TTEST DATA=temp3.earthquake_agg ALPHA=.05;
	VAR magnitude;
	CLASS state;
RUN;