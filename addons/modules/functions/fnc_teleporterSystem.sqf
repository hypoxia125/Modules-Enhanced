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

// Add teleporter actions
_teleporters apply {
    private _teleporter = _x;
    
    _teleporter addAction [
        LSTRING(TeleporterSystem_ActionName), {
            
        }
    ]
}