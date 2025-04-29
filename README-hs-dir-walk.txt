|---------------------------------------|
|    Hammerspace hs-dir-walk            |
|                v1.0                   |
|---------------------------------------|

This script gathers file count and size of a directory and can:
- Output the data in Hammerscript json format.
- Reformat that data replacing EMPTY directories with 0's for Prometheus
- Convert data to Prometheus format


Using this script:
- When specifying where to scan: 
- - Specify the full path to where you want to start (exclude trailing slashes)


Requirements:
- The HSTK commands only work with Hammerspace shares
- The HSTK must be installed in order to use this script: https://github.com/hammer-space/hstk
- This script has only been tested using a Linux client

