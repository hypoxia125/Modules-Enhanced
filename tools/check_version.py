import sys

def parse_version(version_str):
    return [int(part) for part in version_str.split('.')]

def check_version(pr_version, master_version):
    pr_version_parts = parse_version(pr_version)
    master_version_parts = parse_version(master_version)
    
    return pr_version_parts > master_version_parts

def get_version_from_file(filepath):
    try:
        with open(filepath, 'r') as file:
            lines = file.readlines()
            for line in lines:
                if '#define CURRENT_VERSION' in line:
                    return line.split('"')[1]
    except FileNotFoundError:
        print(f"File not found: {filepath}")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

def main():
    # Paths to the version files
    master_filepath = 'master_version.hpp'
    pr_filepath = 'addons/main/script_version.hpp'

    # Extract version numbers from both files
    master_version = get_version_from_file(master_filepath)
    pr_version = get_version_from_file(pr_filepath)

    # Compare the versions
    if check_version(pr_version, master_version):
        print(f"New version {pr_version} is greater than current version {master_version}.")
        sys.exit(0)  # Success
    else:
        print(f"New version {pr_version} is not greater than current version {master_version}.")
        sys.exit(1)  # Failure

if __name__ == "__main__":
    main()
