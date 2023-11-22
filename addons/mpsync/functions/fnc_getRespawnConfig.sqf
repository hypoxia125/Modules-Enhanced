#include "script_component.hpp"

if (isServer && !hasInterface) exitWith {};

private _side = side group player;
private _respawnOnStart = getNumber (missionConfigFile >> "respawnOnStart");
private _templates = getArray (missionConfigFile >> "respawnTemplates");
if (isClass (missionConfigFile >> FORMAT_1("respawnTemplates%1", _side))) then {
    _templates = getArray (missionConfigFile >> FORMAT_1("respawnTemplates%1", _side));
};

// Return
[_respawnOnStart, _templates];
