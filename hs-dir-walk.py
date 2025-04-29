#!/usr/bin/env python
#
# hs-dir-walk.py
# Python script to gather directory stats, specifically dir size and num of files
# then format the output for Prometheus metrics use.
#
# Ver 1.0
#   Initial Release, basic test run with minimal checking
#
# Ver 1.1 - 22/11/2024 -
#   Complete rewrite
#   - added input options for input and output files
#   - added function for generating the data file rather than needing that provided.
#   - added function to replace the #EMPYT result with {0,0}.
#       #EMPTY is the hs sum value returned for 0 files. {0,0} is the Prometheus metric format.


import subprocess

def run_directory_check():
    """Prompt the user for a directory, run the command, and save the output to the input file."""
    directory = input("Enter the full path of the directory to check: ").strip()
    input_file = input("Enter the path to the input file to save the command output: ").strip()

    try:
        # Command to run
        command = f"find {directory} -type d | xargs hs sum -e 'IS_FILE?{{1FILES/FILE,SPACE_USED/BYTES}}'"
        # Execute the command and capture its output
        result = subprocess.run(
            command, 
            shell=True, 
            universal_newlines=True,  # Ensures output is a string
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            check=True
        )
        
        # Write the command output to the input file
        with open(input_file, 'w') as f:
            f.write(result.stdout)
        
        print(f"Command output successfully written to {input_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error running the command: {e}")
        print(f"Command output: {e.output}")

def parse_directory_data(input_file, output_file):
    """Parse the input file and format the data for Prometheus metrics."""
    output_lines = []
    
    with open(input_file, 'r') as f:
        lines = f.readlines()
        for i in range(0, len(lines), 2):
            # Parse Line 1 (Directory)
            directory = lines[i].strip().lstrip('#').strip()
            # Parse Line 2 (File count and size)
            file_info = lines[i + 1].strip()
            file_count, size_bytes = map(int, file_info.strip("{}").split(","))
            
            # Format the output
            size_line = f'node_directory_size_bytes{{directory="{directory}"}} {size_bytes}'
            count_line = f'node_directory_file_count{{directory="{directory}"}} {file_count}'
            
            output_lines.append(size_line)
            output_lines.append(count_line)
    
    # Write to output file
    with open(output_file, 'w') as f:
        f.write("\n".join(output_lines))
    
    # Print to STDOUT
    print("\n".join(output_lines))

def replace_empty_lines(file_path):
    """Parse the output file and replace lines containing #EMPTY with {0,0}."""
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    updated_lines = [line.replace("#EMPTY", "{0,0}") if "#EMPTY" in line else line for line in lines]
    
    with open(file_path, 'w') as f:
        f.writelines(updated_lines)
    
    print(f"Replaced all occurrences of '#EMPTY' with '{{0,0}}' in {file_path}")

# Main script
if __name__ == "__main__":
    while True:
        print("\nOptions:")
        print("1. Run directory check and save to input file.")
        print("2. Parse input file and save output.")
        print("3. Replace #EMPTY with {0,0} in a file.")
        print("4. Exit.")
        choice = input("Choose an option (1/2/3/4): ").strip()
        
        if choice == "1":
            run_directory_check()
        elif choice == "2":
            input_file = input("Enter the path to the input file: ").strip()
            output_file = input("Enter the path to the output file: ").strip()
            parse_directory_data(input_file, output_file)
        elif choice == "3":
            file_path = input("Enter the path to the file: ").strip()
            replace_empty_lines(file_path)
        elif choice == "4":
            print("Exiting script.")
            break
        else:
            print("Invalid choice. Please try again.")
