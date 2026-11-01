#include "script_component.hpp"

// Warn players of mismatched version on mission start - non editor
private _hasModules = entities "" select {_x isKindOf "MEH_ModuleBase"} isNotEqualTo [];
if (_hasModules) then {
    [] spawn {
        private _deadline = time + 20;
        waitUntil {sleep 0.1; (!is3DEN && {alive player}) || {time >= _deadline}};
        if (is3DEN || {!alive player}) exitWith {};
        private _missionVersion = getMissionConfigValue [QGVAR(MissionVersion), ""];

        if (_missionVersion isEqualTo "") exitWith {};
        if (_missionVersion isEqualTo CURRENT_VERSION) exitWith {};

        systemChat FORMAT_2(LELSTRING(Error,MismatchedVersions_Player),_missionVersion,CURRENT_VERSION);
    };
};
