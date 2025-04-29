|---------------------------------------|
|    Hammerspace HSTK Report Builder    |
|                v1.0                   |
|---------------------------------------|

This script can generate three different reports:
- File count and capacity used per folder, the folder depth can be specified
- File count and space used per cluster volume
- Total File Count and Space Used Plus Top 10 Files

Using this script:
- When specifying where to scan, either:
- - Enter . to start from your current folder OR
- - Specify the full path to where you want to start (exclude leading and training slashes)

Note: Not all reports work if executed against the cluster root, this will be noted for applicable reports

Requirements:
- The HSTK commands only work with Hammerspace shares
- The HSTK must be installed in order to use this script: https://github.com/hammer-space/hstk
- This script has only been tested using a Linux client

The following examples show the operation of and output generated for each of the three report types.

***Example Operation - File count and capacity used per folder***

-------------------------------------------------------------------------------
This report will provide the per-folder File Count and Capacity Used

The report is recursive, though you control the target depth
-------------------------------------------------------------------------------
Provide a name your report (no spaces please): report1

Enter the path you which to report on (use a period to start from the current location): .

Enter how many directories deep to scan (a number, 1 = current directory): 1
-------------------------------------------------------------------------------

-------------------------------------------------------
Executing the HSTK command to gather the report data...
-------------------------------------------------------

--------------------------------------
Converting the report to csv format...
--------------------------------------

----------------------------------------------------------------------------------
The following report was created: report1.csv
----------------------------------------------------------------------------------

linux-1 /hsroot # cat report1.csv
Folder,File Count,Capacity Used in Bytes
 ., 4, 20480
 .Lost+Found, 0, 0
 gfstest, 10224, 98082995
 OnlineDelay, 40, 192233472
 s3-root, 400, 12988416
 av_test, 19, 98304
 s3-root-2, 22, 6783442
 merl-peter1, 12402, 110608384
 
***Example Operation - File count and space used per cluster volume***
 
-------------------------------------------------------------------------------
This report will provide the per-cluster volume file count and capacity used

The report is recursive, but WILL NOT work if executed at the cluster root

This report must be run against a single share, or from some folder within the share
-------------------------------------------------------------------------------
Provide a name your report (no spaces please): report2

Enter the path you which to report on (use a period to start from the current location): .
-------------------------------------------------------------------------------

-------------------------------------------------------
Executing the HSTK command to gather the report data...
-------------------------------------------------------

--------------------------------------
Converting the report to csv format...
--------------------------------------

----------------------------------------------------------------------------------
The following report was created: report2.csv
----------------------------------------------------------------------------------

linux-1 /hsroot # cat report2.csv
Volume Name,File Count,Capacity Used in Bytes
  	STORAGE_VOLUME('dsx-1.asgard.local::/hsvol0'),  	1, 4096
  	STORAGE_VOLUME('dsx-1.asgard.local::/hsvol1'),  	1, 4096
  	STORAGE_VOLUME('dsx-2.asgard.local::/hsvol0'),  	2, 12288
  	STORAGE_VOLUME('dsx-2.asgard.local::/hsvol1'),  	1, 4096
  	
 ***Example Operation - Total File Count and Space Used Plus Top 10 Files***
 
-------------------------------------------------------------------------------
This report will provide the total file count and capacity used, as well as the top 10 largest files (with path) for the specified folder tree

The report is recursive, but WILL NOT work if executed at the cluster root

This report must be run against a single share, or from some folder within the share
-------------------------------------------------------------------------------
Provide a name your report (no spaces please): report3

Enter the path you which to report on (use a period to start from the current location): gfstest
-------------------------------------------------------------------------------

-------------------------------------------------------
Executing the HSTK command to gather the report data...
-------------------------------------------------------

--------------------------------------
Converting the report to csv format...
--------------------------------------

----------------------------------------------------------------------------------
The following report was created: report3.csv
----------------------------------------------------------------------------------

linux-1 /hsroot # cat report3.csv
Total File Count, Total Capacity Used in Bytes, File Size, File 10224, 98082995, ,
 		, , 13783920, ./telemetry_dump3/archive/librocksdbjni568385507767029494.so
 		, , 13783920, ./telemetry_dump3/archive/librocksdbjni1540166046508206384.so
 		, , 13762560, ./telemetry_dump3/archive/librocksdbjni8354332257291138511.so
 		, , 13762560, ./telemetry_dump3/archive/librocksdbjni7424396042295213658.so
 		, , 592339, ./s3user2/tier.txt
 		, , 528384, ./s3user1/tier.txt
 		, , 16384, ./reports2/HSTK_Report_Builder.sh
 		, , 16384, ./reports/HSTK_Report_Builder.sh
 		, , 16384, ./HSTK_Report_Builder.sh
 		, , 12288, ./.DS_Store
