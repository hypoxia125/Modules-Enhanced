import re
import subprocess
from packaging import version

def get_version_from_file(branch):
    result = subprocess.run(
        ["git", "show", f"{branch}:addons/main/script_version.hpp"], 
        capture_output=True, text=True
    )
    content = result.stdout
    
    # Extract version using regex
    match = re.search(r'#define CURRENT_VERSION "([0-9]+\.[0-9]+\.[0-9]+)"', content)
    if match:
        return match.group(1)
    else:
        raise ValueError(f"Version not found in {branch} branch.")
    
def debug_git_show(branch, path):
    result = subprocess.run(
        ["git", "show", f"{branch}:{path}"], 
        capture_output=True, text=True
    )
    print(f"Contents of {path} in {branch}:")
    print(result.stdout)

debug_git_show('main', 'addons/main/script_version.hpp')
debug_git_show('HEAD', 'addons/main/script_version.hpp')

# Get versions from the main branch and the PR branch
main_version = get_version_from_file('main')
pr_version = get_version_from_file('HEAD')

# Compare versions
if version.parse(pr_version) <= version.parse(main_version):
    raise SystemExit(f'PR version ({pr_version}) must be greater than main branch version ({main_version}).')

print("Version check passed!")
