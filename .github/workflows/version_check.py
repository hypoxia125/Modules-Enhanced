import re
import subprocess
from packaging import version

def get_version_details(branch, path, use_working_dir=False):
    if use_working_dir:
        # Read from the working directory
        with open(path, 'r') as file:
            content = file.read()
    else:
        # Use git to fetch the file content from the specified branch
        result = subprocess.run(
            ["git", "show", f"{branch}:{path}"],
            capture_output=True, text=True
        )
        content = result.stdout

    # Extract version details using regex
    major = int(re.search(r'#define MAJOR (\d+)', content).group(1))
    minor = int(re.search(r'#define MINOR (\d+)', content).group(1))
    patch = int(re.search(r'#define PATCH (\d+)', content).group(1))
    current_version = re.search(r'#define CURRENT_VERSION "([0-9]+\.[0-9]+\.[0-9]+)"', content)
    
    if not current_version:
        raise ValueError("CURRENT_VERSION not found in file content.")
    current_version = current_version.group(1)
    
    return major, minor, patch, current_version

def debug_git_show(branch, path):
    # Print the contents of the file in the specified branch
    result = subprocess.run(
        ["git", "show", f"{branch}:{path}"], 
        capture_output=True, text=True
    )
    print(f"Contents of {path} in {branch}:")
    print(result.stdout)
    
# --------------------------------------------------------------------------------------------------------------

file_path = 'addons/main/script_version.hpp'

debug_git_show('main', file_path)
debug_git_show('HEAD', file_path)

# Get version details from both main and PR branches
main_major, main_minor, main_patch, main_version = get_version_details('main', file_path)
pr_major, pr_minor, pr_patch, pr_version = get_version_details('HEAD', file_path, use_working_dir=True)

# Compare semantic versions (CURRENT_VERSION)
if version.parse(pr_version) <= version.parse(main_version):
    raise SystemExit(f'PR version ({pr_version}) must be greater than main branch version ({main_version}).')

# Compare individual MAJOR, MINOR, and PATCH numbers
if (pr_major, pr_minor, pr_patch) <= (main_major, main_minor, main_patch):
    raise SystemExit(
        f'PR version {pr_major}.{pr_minor}.{pr_patch} must be greater than '
        f'main version {main_major}.{main_minor}.{main_patch}.'
    )

print("Version check passed!")
