libname sof "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_sofonline\extracts";
libname obf "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_ids";
options nofmterr fmtsearch=(sof);
%let version = 0.3.0.rc2;
*create combined race datasets;

data v9aavital;
	set sof.v9aavital;

	keep id v9sitsys v9sitdia;
run;

data v8aavital;
	set sof.v8aavital;

	keep id v8ppls;
run;

data v8aamedhx;
	set sof.v8aamedhx;

	keep id v8ecancr v8estrk v8eheart v8econg v8eohrt v8ehyper v8ediab v8ecopd v8edepr;
run;

data v8aalifestyle;
	set sof.v8aalifestyle;

	keep id v8dr30 v8drwk30;
run;

data v8aademogr;
	set sof.v8aademogr;

	keep id v8age;
run;

data v8aaanthro;
	set sof.v8aaanthro;

	keep id v8wght v8hght v8bmi;
run;

data v8aaendpt;
	set sof.v8aaendpt;

	keep id v8folall;
run;

data aa;
	merge v8aamedhx v9aavital v8aaanthro v8aademogr v8aalifestyle v8aavital v8aaendpt;
	by id;

  race = 2;

	if V8FOLALL ne .N;
run;

data v4anthro;
	set sof.v4anthro;

	keep id v4wais v4hipg v4wsthip;
run;

data v1lifestyle;
	set sof.v1lifestyle;

	keep id v1drwka v1drink;
run;

data v5medhx;
	set sof.v5medhx;

	keep id v5scancr;
run;

data v6medhx;
	set sof.v6medhx;

	keep id v6sstrk v6sheart v6sangin v6scong v6sohrt v6shyper v6sdiab v6scopd v6sdepr;
run;

data v4medhx;
	set sof.v4medhx;

	keep id v4ekg v4hrtdtx v4seiz;
run;

data v2medhx;
	set sof.v2medhx;

	keep id v2enghrt v2echf;
run;

data v1medhx;
	set sof.v1medhx;

	keep id v1hyten v1diabcl;
run;

data v9medhx;
	set sof.v9medhx;

	keep id v9eangio v9epervd;
run;

data v1vital;
	set sof.v1vital;

	keep id v1lbppls v1sbppls v1lisys v1stdsys v1lidias v1stddia;
run;

data v9vital;
	set sof.v9vital;

	keep id v9sitsys v9sitdia;
run;

data v8anthro;
	set sof.v8anthro;

	keep id v8wght v8hght v8bmi;
run;

data v8demogr;
	set sof.v8demogr;

	keep id v8age;
run;

data v8endpt;
	set sof.v8endpt;

	keep id v8brstca v8dthchd v8dthstk v8dthsud v8dthash v8folall;
run;

data v8lifestyle;
	set sof.v8lifestyle;

	keep id v8dr30 v8drwk30 v8smok;
run;

data v8medhx;
	set sof.v8medhx;

	keep id v8ecancr v8ecc v8estrk v8eheart v8econg v8eohrt v8ehyper v8ediab v8ecopd v8edepr;
run;

data v8vital;
	set sof.v8vital;

	keep id v8ppls;
run;

data v8psg;
	set sof.v8psg;

	rename pdrid=id;
run;

proc sort
	data=v8psg;

	by id;
run;

data cc;
	merge v4anthro v8medhx v8lifestyle v8endpt v1lifestyle v5medhx v6medhx v4medhx v2medhx v1medhx v9medhx v1vital v9vital v8anthro v8demogr v8psg v8vital;
	by id;

  race = 1;

	if V8FOLALL ne .N;
run;

data sof_all_wo_nmiss;
  length id obf_pptid 8.;
  merge cc aa obf.obfid;
	by id;

	visit = 8;

  sex = 1;

	if v8age < 1 then age_category = 0;
  else if 1 =< v8age =< 4 then age_category = 1;
  else if 5 =< v8age =< 14 then age_category = 2;
  else if 15 =< v8age =< 24 then age_category = 3;
  else if 25 =< v8age =< 34 then age_category = 4;
  else if 35 =< v8age =< 44 then age_category = 5;
  else if 45 =< v8age =< 54 then age_category = 6;
  else if 55 =< v8age =< 64 then age_category = 7;
  else if 65 =< v8age =< 74 then age_category = 8;
  else if 75 =< v8age =< 84 then age_category = 9;
  else if 85 =< v8age then age_category = 10;

  *strip out ages that were censored (but probably shouldn't have been);
  if age_category = 0 then age_category = .;

	attrib _all_ label="";
  format _all_;

  *only keep subjects that had a V8 PSG;
  if stdydt > .;

  drop scorerid stdatep scoredt StdyDt ScorDt ScorID CDLabel Comm EnterDt dateadd datechange notes pdb5slp prdb5slp nordb2 nordb3 nodb4slp nordb4 nodb5slp nordb5 nordball maxdbslp avgdbslp nobrslp nobrap nobrc nobro nobrh notca notcc notco notch minmaxhrou chinrdur quchinr;

run;

*export dataset;
proc export
	data = sof_all_wo_nmiss
	outfile="\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-dataset-&version..csv"
	dbms = csv
	replace;
run;
