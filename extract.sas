/* Assign XLSX Library */

libname xl xlsx "/home/student/S23PETL/cdata.xlsx";

/* Assign Database Library*/

libname db oracle path='//server.demo.sas.com:1521/ORCL' schema=S23VETL
	user=student password='Metadata0';

/* create a caslib named casDB with the Oracle database as its data source */

cas con;

caslib casDB desc="Oracle caslib" 
             datasource=(
                srctype="oracle"
               /* UserIDs are passed to the DBMS as-is, and Oracle stores them in UPPER CASE */
               ,path="//server.demo.sas.com:1521/ORCL"
               /* Schema names are passed to the DBMS as-is, and Oracle stores them in UPPER CASE */
               ,username="STUDENT"
               ,pwd="Metadata0"
               ,schema="S23VETL"
                ) libref=casDB global
      ;