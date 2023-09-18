#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    "",
    "_isActivated", false, [true]
];

// Grab synchronized "MEH_ModuleRegisterTeleporter" modules
private _teleporters = [_module] call BIS_fnc_moduleModules;
if (_teleporters isEqualTo []) exitWith {
    LOG("No teleporters synchronized to system");
};

// Teleporter data
EGVAR(meh,teleporterData) = [];
_teleporters apply {
    private _teleporter = _x;

    private _name = _teleporter getVariable [QUOTE(displayName), ""];
    private _bidirectional = parseNumber (_teleporter getVariable [QUOTE(bidirectional), 1]);
    private _loc = getPosATL _object;

    EGVAR(meh,teleporterData) pushBackUnique [_name, _bidirectional, _loc];
};