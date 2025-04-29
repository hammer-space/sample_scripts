# sample_scripts
Various examples and scripts  
Some of these scripts were written for a specific customer use case, then adapted for more general use.  Some were written to illustrate concepts in documentation.  Some are from Hands-on-Labs.

Disclaimer: These scripts are provided "as is" without warranty of any kind, express or implied.
Use at your own risk. The author is not liable for any damages or issues arising from their use.


## exif2hs

"exiftool to Hammerspace"

This script uses `Exiftool` (which must be installed and in the command search path) to extract metadata from many common file types then inserts key-value pairs as Hammerspace tags in the filesystem associated with the file.  `Exiftool` supports dozens of file type incliuding images and other media types and even DICOM (medical imaging which is why I wrote it in the first place).  These tags may be viewed using HSTK via the hs tag list <filename> command and/or the Hammerspace plugin for Microsoft Windows File Explorer.  The tags may be used in objectives, collections, and queries.

This version of exif2hs is written in bash and requires one parameter, the name or path of a file in a Hammerspace share.

This script has been tested with Hammerspace 4.6.6, 5.0 and 5.1 from a Centos 8 client but should support any Linux version that supports exiftool and HSTK.

### Prerequisites

This script requires exiftool (https://exiftool.org/)

## rek2hs

"Rekognition to Hammerspace"

Script to get AWS Recognition result for a file with an instance on an Object Storage Volume (OSV - a bucket in AWS added as a Hammerspace volume) set up for Rekognition, and insert top level Rekognition "labels" (item found and confidence value) as tags into Hammerspace metadata.  Tags can be viewed with the hs tag list <filename> command and/or the Hammerspace plugin for Microsoft Windows File Explorer.  The tags may be used in objectives, collections, and queries.  
This script is used in the Hero's Journey hands-on-lab.

### Prerequisites

- AWS CLI installed on system running the script  
    `aws configure` run to set up creds or access+secret keys, and default region 
- AWS S3 bucket with Rekognition configured and that bucket added as a "Native" volume (OSV) on Hammerspace  
    Add the bucket to Hammerspace using the admin CLI and the `--native` option  
      `admin@my_hammerspace> object-volume-add --native --no-encryption` (and other required options)  
    User may need permissions to use Rekognition  
- HSTK installed on system running the script
- Hammerspace share mounted and files to be processed are in this share
- Place-on or other objective used to place an instance in the bucket with Rekognition configured

You must edit the script and change the following two parameters to match your setup:

`hsosv='rekbucket'` # Hammerspace Object Storage Volume - The name of the OSV in Hammerspace.  You can get it from the GUI: Infrastructure > Volumes or `object-volume-list`
`bucket=$rekognitionbucket` # Bucket name in AWS.  In the Hero's Journey lab this parameter is passed from a parent script, hence the variable.  You can replace `$rekognitionbucket` with the name of your bucket.

This script has been tested with Hammerspace 5.0 and 5.1 from a Centos 8 client but should support any Linux version that supports AWS CLI and HSTK.

## top10_by_vol.py

This Python script runs a Hammerspace HSTK metadata query to generate a report of the top 10 files by size not accessed in the last 2 days on each volume used by the share, and converts the output into an Excel workbook with headings and filters.

The HSTK command the script runs is as follows:

`hs -j sum -e 'IS_FILE&&ACCESS_AGE>=2DAYS?ROWS(INSTANCES)?SUMS_TABLE{|::KEY=INSTANCES[ROW].VOLUME,|::VALUE={1FILE/files,SPACE_USED/bytes,TOP10_TABLE{{DPA,space_used/bytes}}}}[ROWS(INSTANCES)]' <path>`

You can try the above command on any path in a Hammerspace share and see the direct HSTK output.

The script requires a filename for the Excel report, with or without .xlsx extension.  The script accepts a path to start from, and if not provided assumes the current working directory.  The path or pwd must be on a mounted Hammerspace share.

### Prerequisites

This script requires openpyxl, argparse, and hstk.  You can install with
  * `pip3 install openpyxl`
  * `pip3 install argparse`
  * `pip3 install hstk`

This script has been tested with Hammerspace 5.0 and 5.1 from a Centos 8 client but should support any Linux version that supports HSTK.

## user_vol_usage.py

This Python script runs a Hammerspace HSTK metadata query to generate a report of user usage on each volume used by the share (similar to a quota report), and converts the output into an Excel workbook with headings and filters.  
The HSTK command the script runs is as follows:  
`hs --json sum -e "IS_FILE?SUMS_TABLE{|::KEY={OWNER, OWNER_GROUP,INSTANCES[PARENT.ROW].VOLUME},|::VALUE={1FILE/files,SPACE_USED/bytes}}[ROWS(INSTANCES)]" <path>`

You can try the above command on any path in a Hammerspace share and see the direct HSTK output.

The script requires a filename for the Excel report, with or without .xlsx extension.  The script accepts a path to start from, and if not provided assumes the current working directory.  The path or pwd must be on a mounted Hammerspace share.

### Prerequisites
This script requires openpyxl, argparse, and hstk.  You can install with
  * `pip3 install openpyxl`
  * `pip3 install argparse`
  * `pip3 install hstk`

This script has been tested with Hammerspace 5.0 and 5.1 from a Centos 8 client but should support any Linux version that supports HSTK.
