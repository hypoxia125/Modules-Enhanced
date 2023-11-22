#include "script_component.hpp"

// Exit if correct version
private _missionVersion = "Scenario" get3DENMissionAttribute QGVAR(MissionVersion);
if (_missionVersion isEqualTo CURRENT_VERSION) exitWith {};

// Set mission version
"Scenario" set3DENMissionAttribute [QGVAR(MissionVersion), CURRENT_VERSION];

// Save scenario
do3DENAction "MissionSave";

INFO(FORMAT_1("Modules Enhanced: Version %1 saved to mission", CURRENT_VERSION));
