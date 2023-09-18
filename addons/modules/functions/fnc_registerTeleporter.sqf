#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_object", [], [objNull]],
    ["_isActivated", false, [true]]
];

if (isNil {missionNamespace getVariable QGVAR(TeleporterSystem)}) exitWith {
    LOG_1("No %1 module found for %2", QGVAR(ModuleTeleporterSystem), QGVAR(ModuleRegisterTeleporter));
};

private _name = _modules getVariable [QUOTE(displayName), ""];
private _oneWay = parseNumber (_modules getVariable [QUOTE(bidirectional), 1]);
private _loc = getPosATL _object;

