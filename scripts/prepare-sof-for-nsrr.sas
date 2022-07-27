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

  %let version = 0.7.0.pre;

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

data v8sleep;
  set sof.v8sleep;
  keep id V8LBPSYS V8LBPDIA;
run;

data v8psg;
  set sof.v8psg;

  rename pdrid=id;
run;

proc sort data=v8psg;

  by id;
run;

/*

proc means data=v8psg;
  var pctstapn pctsthyp pcstah3d pcstahda pslp_ca0 pslp_oa0 pslp_ap0 pslp_ap3 pslp_hp0 pslp_hp3 pslp_hp3a pslp_ap0hp3 pslp_ap0hp3a;
run;

*/

data cc;
  merge v4anthro v8medhx v8lifestyle v8endpt v1lifestyle v5medhx v6medhx v4medhx v2medhx v1medhx v9medhx v1vital v9vital v8anthro v8demogr v8psg v8vital v8sleep;
  by id;

  race = 1;

  if V8FOLALL ne .N;
run;

proc sort data=sao2;
  by id;
run;

*import cyclic alternating pattern variables;
proc import datafile="\\rfawin\bwh-sleepepi-sof\nsrr-prep\cyclic-alternating-pattern\SOFEvaluation_19-Jul-2019.xlsx"
  out=sof_cap_in
  dbms=xlsx
  replace;
  sheet="CAP";
run;

data sof_cap;
  set sof_cap_in;
run;

proc sort data=sof_cap nodupkey;
  by id;
run;

*combine sub-datasets;
data sof_all_wo_nmiss;
  length id obf_pptid 8.;
  merge 
    cc 
    aa 
    sao2 
    sof_cap 
    obf.obfid
    ;
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

  format sclonp stendp ststartp scloutp stloutp stonsetp time8.;

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
  if v8lbpsys <= 10 then v8lbpsys = .;
  if v8lbpdia <= 10 then v8lbpdia = .;

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

 *compute % sleep time in respiratory event types;
  *time in central apneas;
  pslp_ca0 = 
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in obstructive apneas;
  pslp_oa0 = 
    100 * (
    ((((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all apneas (central + obstructive);
  pslp_ap0 = 
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all apneas (central + obstructive) with >=3% desaturation;
  pslp_ap3 = 
    100 * (
    ((((CARBP3 * AVCARBP3) + (CAROP3 * AVCAROP3) + (CANBP3 * AVCANBP3) + (CANOP3 * AVCANOP3))/ 60) + (((OARBP3 * AVOARBP3) + (OAROP3 * AVOAROP3) + (OANBP3 * AVOANBP3) + (OANOP3 * AVOANOP3)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all hypopneas;
  pslp_hp0 = 
    100 * (
    (((HREMBP*AVHRBP) + (HROP*AVHROP) + (HNRBP*AVHNBP) + (HNROP*AVHNOP)) / 60)
    /
    (SLPPRDP)
    )
    ;

  *time in all hypopneas with >=3% desaturation;
  pslp_hp3 = 
    100 * (
    (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60)
    /
    (SLPPRDP)
    )
    ;

  *time in all hypopneas with >=3% desaturation or arousal;
  pslp_hp3a = 
    100 * (
    (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60)
    /
    (SLPPRDP)
    )
    ;

  *time in all apneas + hypopneas w/ >=3% desaturation;
  pslp_ap0hp3 = 
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBP3*AVHRBP3) + (HROP3*AVHROP3) + (HNRBP3*AVHNBP3) + (HNROP3*AVHNOP3)) / 60))
    /
    (SLPPRDP)
    )
    ;

  *time in all apneas + hypopneas w/ >=3% desaturation or arousal;
  pslp_ap0hp3a = 
    100 * (
    ((((CARBP * AVCARBP) + (CAROP * AVCAROP) + (CANBP * AVCANBP) + (CANOP * AVCANOP)) / 60) + (((OARBP * AVOARBP) + (OAROP * AVOAROP) + (OANBP * AVOANBP) + (OANOP * AVOANOP)) / 60) + (((HREMBA3*AVHRBA3) + (HROA3*AVHROA3) + (HNRBA3*AVHNBA3) + (HNROA3*AVHNOA3)) / 60))
    /
    (SLPPRDP)
    )
    ;

  drop  id
        obf_pptid
        scorerid 
        stdatep
        scoredt
        StdyDt
        ScorDt
        ScorID
        CDLabel
        Comm
        EnterDt
        dateadd
        datechange
        notes
        pdb5slp
        prdb5slp
        nordb2
        nordb3
        nodb4slp
        nordb4
        nodb5slp
        nordb5
        nordball
        maxdbslp
        avgdbslp
        nobrslp
        nobrap
        nobrc
        nobro
        nobrh
        notca
        notcc
        notco
        notch
        minmaxhrou
        chinrdur
        quchinr
        losao2nr  /* duplicate of mnsao2nh */
        losao2r   /* duplicate of mnsao2rh */
        sao2nrem  /* duplicate of avsao2nh */
        sao2rem   /* duplicate of avsap2rh */
        timerem   /* duplicate of minremp */
        timeremp  /* duplicate of tmremp */
        times34p  /* duplicate of tmstg34p */
        timest1   /* duplicate of minstg1p */
        timest1p  /* duplicate of tmstg1p */
        timest2   /* duplicate of minstg2p */
        timest2p  /* duplicate of tmstg2p */
        timest34  /* duplicate of mnstg34p */
        slp_rdi   /* duplicate of slpprdp */
        artifact /* studies contain little artifact, variable not useful */
        ecgou /* all the same value, never indicated on qs form */
        pcstah3d /* use pslp_* variables for % sleep time in respiratory events */
        pcstahar /* use pslp_* variables for % sleep time in respiratory events */
        pcstahda /* use pslp_* variables for % sleep time in respiratory events */
        pctstapn /* use pslp_* variables for % sleep time in respiratory events */
        pctsthyp /* use pslp_* variables for % sleep time in respiratory events */
        ;

run;

*******************************************************************************;
* create harmonized datasets ;
*******************************************************************************;

data sof_harmonized;
set sof_all_wo_nmiss;

  nsrrid = sofid;

*demographics
*age;
*use v8age;
  format nsrr_age 8.2;
  if v8age gt 89 then nsrr_age=90;
  else if v8age le 89 then nsrr_age = v8age;

*age_gt89;
*use v8age;
  format nsrr_age_gt89 $10.; 
  if v8age gt 89 then nsrr_age_gt89='yes';
  else if v8age le 89 then nsrr_age_gt89='no';

*sex;
*use gender;
  format nsrr_sex $10.;
  if gender = 1 then nsrr_sex = 'female';
  else if gender = 0 then nsrr_sex = 'male';
  else if gender = . then nsrr_sex = 'not reported';

*race;
*use race;
    format nsrr_race $100.;
  if race = '1' then nsrr_race = 'white';
    else if race = '2' then nsrr_race = 'black or african american';
    else if race = '.' then nsrr_race = 'not reported';

*ethnicity;
*not outputting ethnicity variable;

*anthropometry
*bmi;
*use v8bmi;
  format nsrr_bmi 10.9;
  nsrr_bmi = v8bmi;

*clinical data/vital signs
*bp_systolic;
*use v8lbpsys;
  format nsrr_bp_systolic 8.2;
  nsrr_bp_systolic = v8lbpsys;

*bp_diastolic;
*use v8lbpdia;
  format nsrr_bp_diastolic 8.2;
  nsrr_bp_diastolic = v8lbpdia;
  
*lifestyle and behavioral health
*current_smoker;
*use v8smok;
  format nsrr_current_smoker $100.;
  if v8smok = '0' then nsrr_current_smoker = 'no';
  else if v8smok = '1' then nsrr_current_smoker = 'yes';
  else if v8smok = . then nsrr_current_smoker = 'not reported';

*polysomnography;
*nsrr_ahi_hp3u;
*use ahi_a0h3;
  format nsrr_ahi_hp3u 8.2;
  nsrr_ahi_hp3u = ahi_a0h3;

*nsrr_ahi_hp3r_aasm15;
*use ahi_a0h3a;
  format nsrr_ahi_hp3r_aasm15 8.2;
  nsrr_ahi_hp3r_aasm15 = ahi_a0h3a;
 
*nsrr_ahi_hp4u_aasm15;
*use ahi_a0h4;
  format nsrr_ahi_hp4u_aasm15 8.2;
  nsrr_ahi_hp4u_aasm15 = ahi_a0h4;
  
*nsrr_ahi_hp4r;
*use ahi_a0h4a;
  format nsrr_ahi_hp4r 8.2;
  nsrr_ahi_hp4r = ahi_a0h4a;
 
*nsrr_ttldursp_f1;
*use slpprdp;
  format nsrr_ttldursp_f1 8.2;
  nsrr_ttldursp_f1 = slpprdp;
  
*nsrr_phrnumar_f1;
*use ai_all;
  format nsrr_phrnumar_f1 8.2;
  nsrr_phrnumar_f1 = ai_all;  

*nsrr_flag_spsw;
*use slewake;
  format nsrr_flag_spsw $100.;
    if slewake = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if slewake = 0 then nsrr_flag_spsw = 'full scoring';
    else if slewake = 8 then nsrr_flag_spsw = 'unknown';
  else if slewake = . then nsrr_flag_spsw = 'unknown';  
  
  
  keep 
    nsrrid
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_current_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_ttldursp_f1
    nsrr_phrnumar_f1
    nsrr_flag_spsw
    ;
run;

*******************************************************************************;
* checking harmonized datasets ;
*******************************************************************************;
/* Checking for extreme values for continuous variables */
proc means data=mesa_harmonized;
VAR   nsrr_age
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_ttldursp_f1
    nsrr_phrnumar_f1
      ;
run;

/* Checking categorical variables */
proc freq data=mesa_harmonized;
table   nsrr_age_gt89
      nsrr_sex
      nsrr_race
    nsrr_flag_spsw
    nsrr_current_smoker;
run;


*******************************************************************************;
* make all variable names lowercase ;
*******************************************************************************;
  options mprint;
  %macro lowcase(dsn);
       %let dsid=%sysfunc(open(&dsn));
       %let num=%sysfunc(attrn(&dsid,nvars));
       %put &num;
       data &dsn;
             set &dsn(rename=(
          %do i = 1 %to &num;
          %let var&i=%sysfunc(varname(&dsid,&i));    /*function of varname returns the name of a SAS data set variable*/
          &&var&i=%sysfunc(lowcase(&&var&i))         /*rename all variables*/
          %end;));
          %let close=%sysfunc(close(&dsid));
    run;
  %mend lowcase;

  %lowcase(sof_all_wo_nmiss);
  %lowcase(sof_harmonized);
  
*******************************************************************************;
* export CSV dataset ;
*******************************************************************************;
  proc export
    data = sof_all_wo_nmiss
    outfile="\\rfawin\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-dataset-&version..csv"
    dbms = csv
    replace;
  run;

  proc export
    data = sof_harmonized
    outfile="\\rfawin\bwh-sleepepi-sof\nsrr-prep\_releases\&version.\sof-visit-8-harmonized-dataset-&version..csv"
    dbms = csv
    replace;
  run;
