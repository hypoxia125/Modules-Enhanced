#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _area = _module getVariable [QUOTE(ObjectArea), [100, 100, 0, false, -1]];
private _shell = _module getVariable [QUOTE(Shell), "Sh_82mm_AMOS"];
private _salvoSize = _module getVariable [QUOTE(SalvoSize), 6];
private _salvoInterval = _module getVariable [QUOTE(SalvoInterval), 10];
private _salvoTimeVariation = _module getVariable [QUOTE(SalvoTimeVariation), 5];
private _shotInterval = _module getVariable [QUOTE(ShotInterval), 1];
private _shotTimeVariation = _module getVariable [QUOTE(ShotTimeVariation), 1];

if (!isClass (configFile >> "CfgAmmo" >> _shell)) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ([_salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] findIf {_x < 0} != -1) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        
        if (_isActivated) then {
            private _handle = [_module, _area, _shell, _salvoSize, _salvoInterval, _salvoTimeVariation, _shotInterval, _shotTimeVariation] call FUNC(ambientArtilleryVirtual);
            _module setVariable [QGVAR(ambientArtilleryVirtual_Handle), _handle];
        } else {
            private _handle = _module getVariable [QGVAR(ambientArtilleryVirtual_Handle), nil];
            if (!isNil "_handle") then {
                _handle call CBA_fnc_removePerFrameHandler;
                _module setVariable [QGVAR(ambientArtilleryVirtual_Handle), nil];
            };
        };
    };
    
    default {};
};
