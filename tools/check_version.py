import sys

def parse_version(version_str):
    return [int(part) for part in version_str.split('.')]

def check_version(new_version, current_version):
    new_version_parts = parse_version(new_version)
    current_version_parts = parse_version(current_version)
    
    return new_version_parts > current_version_parts

def main():
    filepath = 'addons/main/script_version.hpp'
    new_version = sys.argv[1]

    try:
        with open(filepath, 'r') as file:
            lines = file.readlines()

        for line in lines:
            if '#define CURRENT_VERSION' in line:
                current_version = line.split('"')[1]
                break
        else:
            print("CURRENT_VERSION not found in the file.")
            sys.exit(1)

        if check_version(new_version, current_version):
            print(f"New version {new_version} is greater than current version {current_version}.")
            sys.exit(0)  # Success
        else:
            print(f"New version {new_version} is not greater than current version {current_version}.")
            sys.exit(1)  # Failure

    except FileNotFoundError:
        print(f"File not found: {filepath}")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python check_version.py <new_version>")
        sys.exit(1)
    main()
