#include "script_component.hpp"

params ["_unit", "_mode"];

switch _mode do {
    case "disable": {
        _unit setVariable [QGVAR(playerCurrentAmmo), _unit ammo currentWeapon _unit];
        _unit setAmmo [currentWeapon _unit, 0];
    };
    case "enable": {
        private _savedAmmo = _unit getVariable [QGVAR(playerCurrentAmmo), 1e6];
        _unit setAmmo [currentWeapon _unit, _savedAmmo];
        _unit setVariable [QGVAR(playerCurrentAmmo), nil];
    };
};
