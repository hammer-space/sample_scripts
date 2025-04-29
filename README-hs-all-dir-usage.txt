|---------------------------------------|
|    Hammerspace hs-all-dir-usage       |
|                v1.0                   |
|---------------------------------------|

Script to generate directory usage reports in CSV format for Hammerspace shares.
This Script:
- Prompts for a Hammerspace share which can be a Windows drive or Linux mount point
- Walks from the specified directory and lists file count and size into a user defined CSV.
- File count and space used are from the listed directory down,

Using this script:
- When specifying where to scan, either:
- - Enter the drive letter if running from Windows; paths are not currently supported. 
- - On Linux specify the full path to where you want to start (exclude trailing slashes)



Requirements:
- The HSTK commands only work with Hammerspace shares
- The HSTK must be installed in order to use this script: https://github.com/hammer-space/hstk


