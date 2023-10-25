# Want To Contribute?

## File Formatting:

### General

- Indent: 4 Spaces
- Style: [K&R Style](https://en.wikipedia.org/wiki/Indentation_style#K&R_style)
- Leave one empty line at the end of files
- Use [CBA Macros](https://github.com/CBATeam/CBA_A3/blob/master/addons/main/script_macros_common.hpp)
- Use CBA event system with CBA preInit to issue local/server/global commands - do not use remoteExec
- Try and stay in the [unscheduled environment](https://community.bistudio.com/wiki/Scheduler#Unscheduled_Environment)

### cpp \| hpp \| inc \| arma header

- PascalCase + snake_case: MyClassNameHere_01

### SQF

- camelCase + snake_case: myVariableNameHere_01

### Pull Requests

Pull Requests must be used with the `develop` branch. Any attempts to PR to `main` will be denied.