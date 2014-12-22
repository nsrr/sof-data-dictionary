libname sof "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_sofonline\extracts";
libname obf "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_ids";
options nofmterr fmtsearch=(sof);

*set version macro variable;
%let version = 0.1.0.rc;

*import dataset sent by SOF Coordinating Center;
data sof_psg;
  length pdrid visit 8.;
  set sof.v8psg;

  visit = 8;

  *drop unncessary / identifying variables;
  drop scorerid stdatep scoredt StdyDt ScorDt ScorID CDLabel Comm EnterDt dateadd datechange notes nobrslp nobrap nobrc nobro nobrh notca notco notch minmaxhrou;
run;

*export dataset;
proc export
	data = sof_psg
	outfile="\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-psg-visit-8-dataset-&version..csv"
	dbms = csv
	replace;
run;
