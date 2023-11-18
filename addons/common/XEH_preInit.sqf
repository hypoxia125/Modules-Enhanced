#include "script_component.hpp"

#include "XEH_PREP.sqf"

// On load version check
add3DENEventHandler ["OnMissionLoad", {
    private _missionVersion = "Scenario" get3DENMissionAttribute QGVAR(MissionVersion);
    
    systemChat FORMAT_2(LELSTRING(Error,MismatchedVersions),_missionVersion, CURRENT_VERSION);
}];

// Save Current MEH Version to SQM EH
add3DENEventHandler ["OnMissionSave", {
    "Scenario" set3DENMissionAttribute [QGVAR(MissionVersion), CURRENT_VERSION];
}];