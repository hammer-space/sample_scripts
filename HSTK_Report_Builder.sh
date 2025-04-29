#!/bin/bash
#
# HSTK_Report_Builder.sh
# - This script executes HSTK eval or sum commands and then reformats the output into a csv format
#
# This script can generate three different reports:
# - File count and capacity used per folder, the folder depth can be specified
# - File count and space used per cluster volume
# - Total File Count and Space Used Plus Top 10 Files
#
# Rev 1.0:
# - Initial release by Hammerspace Professional Services
# - Feedback can be provided to dl-pstools@hammerspace.com
#
# Requirements:
# - The HSTK commands only work with Hammerspace shares
# - The HSTK must be installed in order to use this script: https://github.com/hammer-space/hstk
# - This script has only been tested using a Linux client
#
# Disclaimers:
# - This script is provided "as is" without warranty of any kind, express or implied.
# - Use at your own risk; the author is not liable for any damages or issues arising from its use.


# Define some colors, these aren't used yet

WHITE='\033[1;37m'
YELLOW='\033[1;33m'

clear

# Define variables

OUTPUT_FILE=$reportvar-hstk.csv

echo ""
echo "|---------------------------------------|"
echo "|    Hammerspace HSTK Report Builder    |"
echo "|                v1.0                   |"
echo "|---------------------------------------|"
echo ""
echo "This script can generate three different reports:"
echo "- File count and capacity used per folder, the folder depth can be specified"
echo "- File count and space used per cluster volume"
echo "- Total File Count and Space Used Plus Top 10 Files"
echo ""
echo "Using this script:"
echo "- When specifying where to scan, either:"
echo "- - Enter . to start from your current folder OR"
echo "- - Specify the full path to where you want to start (exclude leading and training slashes)"
echo ""
echo "Note: Not all reports work if executed against the cluster root, this will be noted for applicable reports"
echo ""
echo "Requirements:"
echo "- The HSTK commands only work with Hammerspace shares"
echo "- The HSTK must be installed in order to use this script"
echo "- This script has only been tested on a Linux client (for now)"
echo ""
echo "--------------------------------------------------------------------------------------"

# Report menu

echo ""
echo -e "|-----------------------------------------------|"
echo -e "|                                               |"
echo -e "|         Hammerspace Report Selection          |"
echo -e "| Please choose a report from the menu provided |"
echo -e "|                                               |"
echo -e "|-----------------------------------------------|"

PS3='Which test to perform (enter the number): '
echo
choices=("Folder File Count and Capacity Used" "File Count and Space Used per Cluster Volume" "Total File Count and Space Used Plus Top 10 Files")
echo
select fav in "${choices[@]}"; do
    case $fav in
    
        "Folder File Count and Capacity Used")

        ## Folder File Count and Capacity Used

        echo ""
        echo -e "-------------------------------------------------------------------------------"
        echo -e "This report will provide the per-folder File Count and Capacity Used"
        echo ""
        echo -e "The report is recursive, though you control the target depth"
        echo -e "-------------------------------------------------------------------------------"

        # Prompt for the needed variables
        echo ""
        echo -e "-------------------------------------------------------"
        read -p 'Provide a name your report (no spaces please): ' reportvar
        echo ""
        read -p 'Enter the path you which to report on (use a period to start from the current location): ' pathvar
        echo ""
        read -p 'Enter how many directories deep to scan (a number, 1 = current directory): ' depthvar
        echo -e "-------------------------------------------------------------------------------"

        # Execute the HSTK command
        echo ""
        echo "-------------------------------------------------------"
        echo "Executing the HSTK command to gather the report data..."
        echo "-------------------------------------------------------"
        # Adding report headers in csv format
        echo 'Folder,File Count,Capacity Used in Bytes' >> $reportvar.csv
        # Execute the HSTK command
        find . -maxdepth $depthvar  -type d | xargs hs sum -e 'IS_FILE?{,1FILE/FILE,SPACE_USED/BYTES}' . >> $reportvar.csv

        # Convert the test output into csv
        echo ""
        echo "--------------------------------------"
        echo "Converting the report to csv format..."
        echo "--------------------------------------"
        sed -i -e ':a;N;$!ba;s/\n//g' -e 's/#####//g;s/#EMPTY/{, 0, 0}/g;s/{//g;s/}/\n/g' -e 's/Bytes/Bytes\n/g' $reportvar.csv

        # Display the results file location
        echo ""
        echo "----------------------------------------------------------------------------------"
        echo "The following report was created: $reportvar.csv"
        echo "----------------------------------------------------------------------------------"

        break
        ;;

        "File Count and Space Used per Cluster Volume")

        ## File Count and Space Used per Cluster Volume

        echo ""
        echo -e "-------------------------------------------------------------------------------"
        echo -e "This report will provide the per-cluster volume file count and capacity used"
        echo ""
        echo -e "The report is recursive, but WILL NOT work if executed at the cluster root"
        echo ""
        echo -e "This report must be run against a single share, or from some folder within the share"
        echo -e "-------------------------------------------------------------------------------"

        # Prompt for the needed variables
        echo ""
        echo -e "-------------------------------------------------------"
        read -p 'Provide a name your report (no spaces please): ' reportvar
        echo ""
        read -p 'Enter the path you which to report on (use a period to start from the current location): ' pathvar
        echo -e "-------------------------------------------------------------------------------"

        # Execute the HSTK command
        echo ""
        echo "-------------------------------------------------------"
        echo "Executing the HSTK command to gather the report data..."
        echo "-------------------------------------------------------"
        # Adding report headers in csv format
        echo 'Volume Name,File Count,Capacity Used in Bytes' >> $reportvar.csv
        # Execute the HSTK command
        hs sum -e 'IS_FILE?ROWS(INSTANCES)?SUMS_TABLE{|::KEY=INSTANCES[ROW].VOLUME,|::VALUE={1FILE/FILE,SPACE_USED/BYTES}}[ROWS(INSTANCES)]' $pathvar >> $reportvar.csv

        # Convert the test output into csv
        # Technical note: s/    //g - the blank area needs to be entered as space-space-tab
        echo ""
        echo "--------------------------------------"
        echo "Converting the report to csv format..."
        echo "--------------------------------------"
        sed -i -e ':a;$!{N;s/\n/ /;ba;}'  -e 's/|KEY = //g;s/SUMS_TABLE//g;s/|KEY =//g;s/{1 FILE}//g;s/|VALUE = //g;s/;//g;s/{//g;s/}}/\n/g;s/}/\n/g' -e 's/    //g;s/Bytes/Bytes\n/g' $reportvar.csv      

        # Display the results file location
        echo ""
        echo "----------------------------------------------------------------------------------"
        echo "The following report was created: $reportvar.csv"
        echo "----------------------------------------------------------------------------------"

        break
        ;;

        "Total File Count and Space Used Plus Top 10 Files")

        ## Total File Count and Space Used Plus Top 10 Files

        echo ""
        echo -e "-------------------------------------------------------------------------------"
        echo -e "This report will provide the total file count and capacity used, as well as the top 10 largest files (with path) for the specified folder tree"
        echo ""
        echo -e "? The report is recursive, but WILL NOT work if executed at the cluster root"
        echo ""
        echo -e "? This report must be run against a single share, or from some folder within the share"
        echo -e "-------------------------------------------------------------------------------"

        # Prompt for the needed variables
        echo ""
        echo -e "-------------------------------------------------------"
        read -p 'Provide a name your report (no spaces please): ' reportvar
        echo ""
        read -p 'Enter the path you which to report on (use a period to start from the current location): ' pathvar
        echo -e "-------------------------------------------------------------------------------"

        # Execute the HSTK command
        echo ""
        echo "-------------------------------------------------------"
        echo "Executing the HSTK command to gather the report data..."
        echo "-------------------------------------------------------"
        # Adding report headers in csv format
        echo 'Total File Count, Total Capacity Used in Bytes, File Size, File' >> $reportvar.csv
        # Execute the HSTK command
        hs sum -e 'IS_FILE?{1FILE/FILE,SPACE_USED/BYTES, ,TOP10_TABLE{{ , ,SPACE_USED/BYTES,PATH}}}' $pathvar >> $reportvar.csv
        
        # Convert the test output into csv
        # Technical note: s/    //g - the blank area needs to be entered as tab-tab
        echo ""
        echo "--------------------------------------"
        echo "Converting the report to csv format..."
        echo "--------------------------------------"
        sed -i -e ':a;$!{N;s/\n/ /;ba;}'  -e 's/|KEY = //g;s/SUMS_TABLE//g;s/|KEY =//g;s/{1 FILE}//g;s/|VALUE = //g;s/;//g;s/{//g;s/}}/\n/g;s/}/\n/g' -e 's/TOP10_TABLE/\n/g;s/"//g;s/          //g;s/File Path/File Path\n/g' $reportvar.csv      

        # Display the results file location
        echo ""
        echo "----------------------------------------------------------------------------------"
        echo "The following report was created: $reportvar.csv"
        echo "----------------------------------------------------------------------------------"

        break
        ;;

        # Default code if an invalid menu option was selected.
        
        *) echo "Invalid option $REPLY"
        ;;

    esac

done
