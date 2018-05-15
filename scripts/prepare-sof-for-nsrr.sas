*******************************************************************************;
* Program           : prepare-sof-for-nsrr.sas
* Project           : National Sleep Research Resource (sleepdata.org)
* Author            : Michelle Reid (MLR)
* Date Created      : 20180515
* Purpose           : Prepare Study of Osteoporotic Fractures data
*                       for deposition on sleepdata.org.
* Revision History  :
*   Date      Author    Revision
*   20180515  mr251     Clean up SAS program
*******************************************************************************;

*******************************************************************************;
* Establish SOF options and libraries
*******************************************************************************;

*set SOF libraries and options;
  libname sof "\\rfawin\bwh-sleepepi-sof\nsrr-prep\_sofonline\extracts";
  libname obf "\\rfawin\bwh-sleepepi-sof\nsrr-prep\_ids";
  libname sao2 "\\rfawin\bwh-sleepepi-sof\nsrr-prep\_sofonline\to-deidentify";
  options nofmterr fmtsearch=(sof);

  %let version = 0.5.0;

*create combined race datasets;
data sao2;
  set sao2.sof_sao2_returned;

  rename pdrid = id;

  rdix = input(rdi,8.);
  ndes2phx = input(ndes2ph,8.);
  ndes3phx = input(ndes3ph,8.);
  ndes4phx = input(ndes4ph,8.);
  ndes5phx = input(ndes5ph,8.);

  drop stdydt--ndes5ph ;
run;

data sao2;
  set sao2;

  rename rdix = rdi;
  rename ndes2phx = ndes2ph;
  rename ndes3phx = ndes3ph;
  rename ndes4phx = ndes4ph;
  rename ndes5phx = ndes5ph;
run;

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

proc sort data=sao2;
  by id;
run;

data sof_all_wo_nmiss;
  length id obf_pptid 8.;
  merge cc aa sao2 obf.obfid;
  by id;

  visit = 8;

  *create gender variable;
  gender = 1;

  *create categorical age variable;
  if 75 =< v8age =< 84 then age_category = 1;
  else if 85 =< v8age then age_category = 2;

  *recode missing ages and high ages;
  if v8age > 89 then v8age = 90;
  else if v8age < 0 then v8age = .;

  *recode id variable;
  sofid = id;

  attrib _all_ label="";
  format _all_;

  format lightoff sclonp stendp ststartp scslpon stloutp stonsetp time8.;

  *only keep subjects that had a V8 PSG;
  if stdydt > .;

  if v9sitdia <= 10 then v9sitdia = .;
  if v9sitsys <= 10 then v9sitsys = .;
  if v1lidias <= 10 then v1lidias = .;
  if v1stddia <= 10 then v1stddia = .;
  if v4hipg <= 10 then v4hipg = .;
  if v4wais <= 10 then v4wais = .;
  if v4wsthip <= 10 then v4wsthip = .;
  if v8bmi <= 10 then v8bmi = .;
  if v8hght <= 10 then v8hght = .;
  if v8wght <= 10 then v8wght = .;

  *create new AHI variables for ICSD3;
  ahi_a0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 + carbp + carop + canbp + canop + oarbp + oarop + oanbp + oanop ) / slpprdp;
  ahi_a0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 + carbp + carop + canbp + canop + oarbp + oarop + oanbp + oanop ) / slpprdp;
  ahi_a0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 + carba + caroa + canba + canoa + oarba + oaroa + oanba + oanoa ) / slpprdp;
  ahi_a0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 + carba + caroa + canba + canoa + oarba + oaroa + oanba + oanoa ) / slpprdp;

  ahi_o0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 + oarbp + oarop + oanbp + oanop ) / slpprdp;
  ahi_o0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 + oarbp + oarop + oanbp + oanop ) / slpprdp;
  ahi_o0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 + oarba + oaroa + oanba + oanoa ) / slpprdp;
  ahi_o0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 + oarba + oaroa + oanba + oanoa ) / slpprdp;

  ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 + carbp + carop + canbp + canop ) / slpprdp;
  ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 + carbp + carop + canbp + canop ) / slpprdp;
  ahi_c0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 + carba + caroa + canba + canoa ) / slpprdp;
  ahi_c0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 + carba + caroa + canba + canoa ) / slpprdp;

  cent_obs_ratio = (carbp + carop + canbp + canop) / (oarbp + oarop + oanbp + oanop);
  cent_obs_ratioa = (carba + caroa + canba + canoa) / (oarba + oaroa + oanba + oanoa);

  drop id obf_pptid scorerid stdatep scoredt StdyDt ScorDt ScorID CDLabel Comm EnterDt dateadd datechange notes pdb5slp prdb5slp nordb2 nordb3 nodb4slp nordb4 nodb5slp nordb5 nordball maxdbslp avgdbslp nobrslp nobrap nobrc nobro nobrh notca notcc notco notch minmaxhrou chinrdur quchinr;

run;

*export dataset;
proc export
  data = sof_all_wo_nmiss
  outfile="\\rfawin\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-dataset-&version..csv"
  dbms = csv
  replace;
run;
