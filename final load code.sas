/* Efficient load directly to CAS */
proc casutil;
   *drop table so that we get the most up to date data;
	droptable casdata="MOST" incaslib="casdb" quiet;
	load casdata="MOST" incaslib="casdb"  /*input file like the SET statement*/
         outcaslib="casdb" casout="most" promote /*output file*/;
run;

proc casutil;
	list files;
	list tables;
quit;
