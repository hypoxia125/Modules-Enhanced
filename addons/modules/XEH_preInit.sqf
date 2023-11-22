#include "script_component.hpp"

#include "XEH_PREP.hpp"

/* ----- Events - Replaces remoteExec ----- */

// Local Argument
[QGVAR(refuelVehicle), {
    params ["_vehicle"];

    _vehicle setFuel 1;
}] call CBA_fnc_addEventHandler;

// Local Argument
[QGVAR(rearmVehicle), {
    params ["_vehicle"];

    _vehicle setVehicleAmmo 1;
}] call CBA_fnc_addEventHandler;

// Server Only Argument
[QGVAR(enableMine), {
    params ["_mine", "_value"];

    _mine enableSimulationGlobal _value;
}] call CBA_fnc_addEventHandler;

// Local Argument - Local Effect
[QGVAR(vehicleCruiseControl), {
    params ["_vehicle", "_speed"];

    _vehicle setCruiseControl [_speed, false];
}] call CBA_fnc_addEventHandler;

// Local Argument
[QGVAR(EnableGunLights), {
    params ["_group", "_state"];

    _group enableGunLights _state;
}] call CBA_fnc_addEventHandler;

// Local Argument
[QGVAR(EnableGunLightsPlayer), {
    params ["_unit"];

    _unit action ["GunLightOn", _unit];
}] call CBA_fnc_addEventHandler;

// Local Argument
[QGVAR(AddFlashlightAttachment), {
    params ["_unit", "_attachment"];

    if (_attachment isEqualTo "") exitwith {};

    private _primary = primaryWeapon _unit;
    private _primaryItems = primaryWeaponItems _unit;

    private _pointer = _primaryItems select 1;
    if (_pointer isNotEqualTo "") then {
        _unit removePrimaryWeaponItem _pointer;
    };

    _unit addPrimaryWeaponItem _attachment
}] call CBA_fnc_addEventHandler;

// Server Execution
[QGVAR(HideObjectGlobal), {
    params ["_object", "_value"];

    _object hideObjectGlobal _value;
}] call CBA_fnc_addEventHandler;

// Global Execution
[QGVAR(RemoveTrapDisableAction), {
    params ["_object"];

    private _holdAction = _object getVariable [QGVAR(TrapInventory_HoldAction), -1];
    [_object, _holdAction] call BIS_fnc_holdActionRemove;
}];
