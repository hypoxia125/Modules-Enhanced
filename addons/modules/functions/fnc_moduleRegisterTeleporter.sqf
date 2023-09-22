#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_obj", [], [objNull]],
    ["_isActivated", false, [true]]
];

if (isNil {missionNamespace getVariable QGVAR(TeleporterSystem)}) exitWith {
    LOG_1("No %1 module found for %2", QGVAR(ModuleTeleporterSystem), QGVAR(ModuleRegisterTeleporter));
};

// Merge data with transporterData
if (isNil QEGVAR(teleporter,teleporterData)) then {
    EGVAR(teleporter,teleporterData) = [];
};

private _pos = getPosATL _obj;
private _grid = mapGridPosition _obj;
private _name = _module getVariable [QUOTE(displayName), _grid];
private _bidirectional = parseNumber (_module getVariable [QUOTE(bidirectional), 1]);

EGVAR(meh,teleporterData) pushBackUnique [_name, _pos, _bidirectional];

