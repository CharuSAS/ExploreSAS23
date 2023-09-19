/* Which shows are still running & which are retired */
data xl.status;
	length status $7;
	set xl.shows;

	if find(Resident, 'since') > 0 then Status='Active';
	else  Status='Retired';
run;

/* How many active vs. retired shows;*/
title "Active vs. Retired Shows";

proc freq;
	tables status;
run;

/* Which city has the most number of special event shows */
proc sql;
	create table db.spleventcoun as
		select *
			from db.splevents
				inner join
					db.countrycity
					on upcase(location)=upcase(city)
				order by countryname
	;
quit;

/*Which rows have the text million -parse out the string containing millions*/

data millions;
	length MillionText $45;
	set db.spleventcoun;

    *nbsp hex specification is C2A0, tranwrd uses 20, so replace C2A0 with 20;
	Notes=tranwrd(Notes,'C2A0'x,'20'x);

    *prxchange extracts a pattern of currency+number+million iwhere present;
	MillionText = prxchange('s/(.*)([$|€]\s*\d*\.*\d*\s+million)(.*)/$2/i',-1,Notes);

	if MillionText not =: Notes then output;
run;

proc print data=millions;
run;

/* Date transformations for final report */
data db.most (keep= RunDays eventname  city countryname  origdate startc endc startn endn nyear);
	set db.spleventcoun(rename=(date1=origdate));

	*strip out start & end date strings;
	startc=scan(origdate,1,'–');
	endc=scan(origdate,2,'–');

	if endc='present' then 	endc=put(today(),date9.);

    *to suppress error messages prefix the informat with 2 question marks;
	if length(startc)>5 then do;
	   startn=input(startc, anydtdte60.);
	   endn=input(endc,?? anydtdte60.);
	end;

  	if endn = . then do;
       *SAS_date = Excel_date - 21916;
	   startn=input(startc, 8.) - 21916;
	   format start date9.;
	   endn = startn;
	   RunDays = 1;
	end;
	else do;
	   RunDays = endn - startn;
	end;

	/*	The SAS function N calculates the number of non-blank numeric values across
        multiple columns.*/
	if n(startn,endn)=2 then nyear=intck('year',startn, endn);
	format  startn endn date9.;

	if startn = . or startn < '01JAN1980'd then delete;
run;

proc print data=db.most;
run;