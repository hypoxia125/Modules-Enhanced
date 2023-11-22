#include "script_component.hpp"

// Check mission version
private _missionVersion = "Scenario" get3DENMissionAttribute QGVAR(MissionVersion);

systemChat str [_missionVersion, CURRENT_VERSION];

if (_missionVersion isEqualTo "") exitWith {
    INFO("No mission version found: creating on next save...");
};
if (_missionVersion isEqualTo CURRENT_VERSION) exitWith {
    INFO("Mission version and current version match");
};

systemChat FORMAT_2(LELSTRING(Error,MismatchedVersions),_missionVersion,CURRENT_VERSION);
