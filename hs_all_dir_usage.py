#!/usr/bin/env python
# hs_all_dir_usage.py
#  
# Windows based script tp generate directory usage reports in CSV format for Hammerspace shares.
#This Script:
# - Walks from the specified directory and lists file count and size into a user defined CSV.
#- File count and space used are from the listed directory down,

#Using this script:
#- When specifying where to scan, either:
#- - Enter the drive letter if running from Windows; paths are not currently supported. 
#- - On Linux specify the full path to where you want to start (exclude trailing slashes)
# Ver 1.0
# - Initial release by Hammerspace Professional Services
# - Feedback can be provided to dl-pstools@hammerspace.com
#
# Requirements:
# - The HSTK commands only work with Hammerspace shares
# - The HSTK must be installed in order to use this script: https://github.com/hammer-space/hstk
#
# Disclaimers:
# - This script is provided "as is" without warranty of any kind, express or implied.
# - Use at your own risk; the author is not liable for any damages or issues arising from its use.

import os
import csv
import subprocess


def check_and_convert_path(path):
  """
  Checks if path exists and converts path separators for portability.
  """
  if not os.path.exists(path):
    print(f"The path {path} does not exist.")
    exit(1)
  # Convert path separators based on OS
  return path.replace("\\", "/") if os.name == "nt" else path  # Windows uses \

# Prompt user for the mount point (or directory for Linux)
mount_point = input("Enter the Hammerspace share path (e.g., 'Z:' or '/mnt/hammerspace'): ").strip()
mount_point = check_and_convert_path(mount_point)

# Prepare CSV file
output_file = "directory_analysis.csv"
with open(output_file, mode='w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(["Directory", "HS Output"])

    # Walk the directory tree
    for root, dirs, _ in os.walk(mount_point):
        for directory in dirs:
            selected_directory = os.path.join(root, directory)
            print(f"Processing: {selected_directory}")

            # Run the "hs sum" command on the selected directory
            try:
                result = subprocess.check_output(
                    ["hs", "sum", "-e", "IS_FILE?{FILE,SPACE_USED}", selected_directory],
                    stderr=subprocess.STDOUT,
                    text=True
                ).strip()
            except subprocess.CalledProcessError as e:
                result = f"Error: {e.output.strip()}"
                print(result)

            # Write the result to the CSV
            csv_writer.writerow([selected_directory, result])

print(f"Analysis complete. Results saved to {output_file}.")
