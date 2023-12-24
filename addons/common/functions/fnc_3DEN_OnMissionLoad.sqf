#include "script_component.hpp"

// Check mission version
private _missionVersion = "Scenario" get3DENMissionAttribute QGVAR(MissionVersion);

if (_missionVersion isEqualTo "") exitWith {
    INFO("No mission version found: creating on next save...");
};
if (_missionVersion isEqualTo CURRENT_VERSION) exitWith {
    INFO("Mission version and current version match");
};
if (count (allMissionObjects "Logic" select {_x isKindOf "MEH_ModuleBase"}) == 0) exitWith {
    INFO("Mission has no MEH Modules. Aborting warning...");
};

[FORMAT_2(LELSTRING(Error,MismatchedVersions),_missionVersion,CURRENT_VERSION), 1, 15, true] call BIS_fnc_3DENNotification;
