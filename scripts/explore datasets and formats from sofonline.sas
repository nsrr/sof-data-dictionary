libname sof "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_sofonline\extracts";
libname obf "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_ids";
options nofmterr fmtsearch=(sof);
%let version = 0.1.0.beta4;
*create combined race datasets;
data aa;
	merge sof.v8aaanthro sof.v8aacogfxn sof.v8aademogr sof.v8aadxhp sof.v8aaendpt sof.v8aaexambk sof.v8aafxfall sof.v8aalifestyle sof.v8aamedhx sof.v8aameds sof.v8aamorph sof.v8aaphysfunc sof.v8aaphysperf sof.v8aaqol sof.v8aasleep sof.v8aavision sof.v8aavital;
	by id;

  race = 2;

	if V8FOLALL ne .N;
run;

data cc;
	merge sof.v8anthro sof.v8cogfxn sof.v8demogr sof.v8dxhp sof.v8endpt sof.v8exambk sof.v8fxfall sof.v8lifestyle sof.v8medhx sof.v8meds sof.v8morph sof.v8physfunc sof.v8physperf sof.v8qol sof.v8sleep sof.v8vision sof.v8vital;
	by id;

  race = 1;

	if V8FOLALL ne .N;
run;

data sof_all_wo_nmiss;
  length obf_pptid 9.;
  merge aa cc obf.obfid;
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

  drop id;
run;

*export dataset;
proc export
	data = sof_all_wo_nmiss
	outfile="\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-dataset-&version..csv"
	dbms = csv
	replace;
run;
