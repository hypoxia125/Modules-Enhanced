#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_objects", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (isNil {missionNamespace getVariable QGVAR(TeleporterSystem)}) exitWith {
    LOG_1("No %1 module found for %2", QGVAR(ModuleTeleporterSystem), QGVAR(ModuleRegisterTeleporter));
};

if (_objects isEqualType objNull) then {_objects = [_objects]};