Q1 
a)	Filtering the American Geological dataset into the two states of Alaska and California using the code:
data temp3.earthquake_agg;
	set temp3.earthquakes;

	if state="California" or state="Alaska";
run;

b)Using the following code to create a summary of statistics as listed : proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) mean 
		median stddev min max p25 p75;
	class year state;
	var magnitude;
	
run;
Output:  
c)	Modifying the summary stats so that each year has it’s own table using the following code: 
proc means data=temp3.earthquake_agg(WHERE=(year>=2002 and year<=2011)) mean 
		median stddev min max p25 p75;
	class state;
	by year notsorted;
	var magnitude;
run; 
Output:  
d)Modifiyng the tables to form a time series data using the following code: 
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
Output:  
Using proc sgpanel to plot the time series data and panel by state using the following code:
 proc sgpanel data=temp3.earthquake_mean_fin;
	panelby State;
	series x=year y=Magnitude;
	title 'Average magnitude Over Time';
run;
Output:  
d)	H0(null hypothesis): “the average magnitude of earthquakes in California is equal to that of Alaska”.
H1(alternative hypothesis): “the average magnitude of earthquakes in California is not equal to that of Alaska”.
95% Confidence level Alpha= 5%(significance)
Using the following code to conduct a t-test:
PROC TTEST DATA=temp3.earthquake_agg ALPHA=.05;
	VAR magnitude;
	CLASS state;
RUN;
Output:  
Since the distribution of the two means have unequal variances using the  Satterthwaite t-test's p-value (p < .0001) against our chosen significance level alpha (.05). Since the p-value is smaller than alpha, we reject the null hypothesis. t test results:  
Conclusion:The null hypothesis that the average magnitude of earthquakes in California is equal to that of Alaska can be rejected.

Q2)
a)Plotting the histogram using the following code:
proc sgplot data = temp3.Study_GPA;
histogram AveTime / binstart = 0 binwidth = 5;
density AveTime;
density AveTime / type = kernel;
title 'Study hours';
run;
Output:  
Looking at the graph,the distribution is approximately normal.

b)Subsetting and sorting the values for section 02:
data temp3.study_section02;
set temp3.Study_GPA;
where Section= "02";
run;
proc sort data=temp3.study_section02;
 by Units GPA;
run; 
Output:  
Conducting a correlation test:
proc corr data = temp3.study_section02;
var Units AveTime GPA;
run;

OUTPUT:  
The number of units enrolled show a slightly negative correlation with the GPA with a value of -0.01170 and even though correlation does not equal causation a higher number of units equals to a higher workload for a student leading to a decline in GPA as hinted by the negative value of the Pearson’s coefficient.

The number of average study hours show a slightly positive correlation with the GPA with a value of 0.10981. A higher number of avg study hours may lead to better understanding of the materials and a higher GPA.

The number of  average study hours show a medium positive correlation with the number of units enrolled with a value of 0.3877. A higher number of units enrolled might cause the students torequire to study more to cover the course materials in entirety .

Q3)
a)Loading the SAS set and  displaying the contents using:
data temp3.VITE;
	set "/folders/myshortcuts/myfolder/vite.sas7bdat";
	run;

proc contents data = temp3.VITE; 
run;

OUTPUT:  
b)Converting the long format to wide using:
proc transpose data=temp3.VITE out=temp3.wide_VITE prefix=VISIT_;
by id Treatment;
var Plaque;
id visit;
run; 
OUTPUT:  

c)Subsetting the data with no control or placebo group using :
data temp3.wide_no_placebo ;
 set temp3.wide_VITE;
 where Treatment=1;  
run;

OUTPUT:  

Conducting a t- test with:
H0:The difference in plaque level before treatment and after the second visit is 0
H1: The difference in plaque level before treatment and after the second visit is not equal to 0.

95% confidence APLHA=0.05 
Code:
proc ttest data=temp3.wide_no_placebo alpha= 0.05;
paired VISIT_0*VISIT_2; /* before treatment and after second visit interaction term */
run;

OUTPUT:  

Since p value is less than .05 aka p-value (p < .0001) ,we can reject the null hypothesis that the difference in plaque level before treatment and after the second visit is 0

d)Now conducting a t test with the presence of a control group the following is tested:
H0:plaque difference between visit 2 and before treatment is the same for both control and experiment group

H1: plaque difference between visit 2 and before treatment is the significantly different for both control and experiment group

95% confidence APLHA=0.05 
Code: 
data temp3.wide_VITE_control ;
set temp3.wide_VITE ;
plaque_diff = (VISIT_2-VISIT_0);
run;
proc ttest data=temp3.wide_VITE_control alpha= 0.05;
class treatment;
var plaque_diff;
run;
OUTPUT:
 
The t-test consists of p-value (p =.0855) which is higher than 0.05 due to which we fail to reject the null hypothesis and there is no difference in plaque reduction due to the presence or absence of the Vitamin E aka between the control and experiment group.

e)	The t-test in d) is more reliable as we are testing for  differences in plaque reduction between the control and experiment groups and not the overall plaque reduction before treatment and after the second visit.
f)	Conducting the t-test as follows:
Ho: Zero difference in alcohol consumption between treatment and control 
H1: Non-zero difference in alcohol consumption between treatment and control 
Code:
title1 'Ho: Zero difference in alcohol consumption between treatment and control ';
proc ttest data=temp3.VITE;
 class Treatment; 
 var Alcohol; 
 run;
OUTPUT:
 
Since p value is less than .05 aka p-value (p=0.0122) ,we can reject the null hypothesis that there is zero difference in alcohol consumption between treatment and control.
Ho: Zero difference in cigarette consumption between treatment and control 
H1: Non-zero difference in cigarette consumption between treatment and control 
Code:
title1 'Ho: Zero difference in cigarette consumption between treatment and control ';
proc ttest data=temp3.VITE;
 class Treatment; 
 var Smoke; 
 run;
OUTPUT:  
Since p value is less than .05 aka p-value (p<0.0001) ,we can reject the null hypothesis that there is zero difference in cigarette consumption between treatment and control.

