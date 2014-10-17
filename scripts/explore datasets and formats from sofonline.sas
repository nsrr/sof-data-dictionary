libname sof "\\rfa01\bwh-sleepepi-sof\nsrr-prep\_sofonline\extracts";
options nofmterr fmtsearch=(sof);
%let version = 0.1.0.beta2;
*create combined race datasets;
data aa;
	merge sof.v8aaanthro sof.v8aacogfxn sof.v8aademogr sof.v8aadxhp sof.v8aaendpt sof.v8aaexambk sof.v8aafxfall sof.v8aalifestyle sof.v8aamedhx sof.v8aameds sof.v8aamorph sof.v8aaphysfunc sof.v8aaphysperf sof.v8aaqol sof.v8aasleep sof.v8aavision sof.v8aavital;
	by id;

	if V8FOLALL ne .N;
run;

data cc;
	merge sof.v8anthro sof.v8cogfxn sof.v8demogr sof.v8dxhp sof.v8endpt sof.v8exambk sof.v8fxfall sof.v8lifestyle sof.v8medhx sof.v8meds sof.v8morph sof.v8physfunc sof.v8physperf sof.v8qol sof.v8sleep sof.v8vision sof.v8vital;
	by id;

	if V8FOLALL ne .N;
run;

data sof_all_wo_nmiss;
	merge aa cc;
	by id;

	attrib _all_ label="";
  format _all_;
run;

*export dataset;
proc export
	data = sof_all_wo_nmiss
	outfile="\\rfa01\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-dataset-&version..csv"
	dbms = csv
	replace;
run;
