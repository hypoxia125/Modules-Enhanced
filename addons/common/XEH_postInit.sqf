#include "script_component.hpp"

// Check current version vs mission version
private _missionVersion = "Scenario" get3DENMissionAttribute QGVAR(MissionVersion);
if (_missionVersion isNotEqualTo CURRENT_VERSION) then {
    systemChat "MisMatched Versions"
};

// Save Current MEH Version to SQM EH
add3DENEventHandler ["OnMissionSave", {
    "Scenario" set3DENMissionAttribute [QGVAR(MissionVersion), CURRENT_VERSION];
}];