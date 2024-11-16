#include "script_component.hpp"

#include "XEH_PREP.hpp"

// Misc
//------------------------------------------------------------------------------------------------
[QGVAR(HideObjectGlobal), {
    params ["_object", "_value"];

    _object hideObjectGlobal _value;
}] call CBA_fnc_addEventHandler;

// RefuelVehicle
//------------------------------------------------------------------------------------------------
[QGVAR(refuelVehicle), {
    params ["_vehicle"];

    _vehicle setFuel 1;
}] call CBA_fnc_addEventHandler;

// RearmVehicle
//------------------------------------------------------------------------------------------------
[QGVAR(rearmVehicle), {
    params ["_vehicle"];

    _vehicle setVehicleAmmo 1;
}] call CBA_fnc_addEventHandler;

// VehicleMineJammer
//------------------------------------------------------------------------------------------------
[QGVAR(enableMine), {
    params ["_mine", "_value"];

    _mine enableSimulationGlobal _value;
}] call CBA_fnc_addEventHandler;

// SpeedLimiter
//------------------------------------------------------------------------------------------------
[QGVAR(vehicleCruiseControl), {
    params ["_vehicle", "_speed"];

    _vehicle setCruiseControl [_speed, false];
}] call CBA_fnc_addEventHandler;

// EnableDisableGunLights
//------------------------------------------------------------------------------------------------
[QGVAR(EnableGunLightsAI), {
    params ["_group", "_state"];

    _group enableGunLights _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(EnableGunLightsPlayer), {
    params ["_unit", "_lightState"];

    switch _lightState do {
        case "ForceOn": {
            _unit action ["GunLightOn", _unit];
            [QGVAR(WeaponLightState), [_unit, true], _unit] call CBA_fnc_globalEvent;
        };
        case "ForceOff": {
            _unit action ["GunLightOff", _unit];
            [QGVAR(WeaponLightState), [_unit, false], _unit] call CBA_fnc_globalEvent;
        };
    };

    LOG_2("EnableDisableGunLights:: Unit [%1] - WeaponLightState [%2]", _unit, _lightState);
}] call CBA_fnc_addEventHandler;

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

// TrapInventory
//------------------------------------------------------------------------------------------------
[QGVAR(RemoveTrapDisableAction), {
    params ["_object"];

    private _holdAction = _object getVariable [QGVAR(TrapInventory_HoldAction), -1];
    [_object, _holdAction] call BIS_fnc_holdActionRemove;
}];

// HealingArea
//------------------------------------------------------------------------------------------------
[QGVAR(HealingArea_HealUnit), {
    params ["_unit", "_hitPoint", "_value"];
    
    _unit setHitPointDamage [_hitPoint, _value];

    private _soundPlaying = _unit getVariable [QGVAR(HealingArea_SoundPlaying), objNull];
    if (isNull (_unit getVariable [QGVAR(HealingArea_SoundPlaying), objNull])) then {
        _unit setVariable [QGVAR(HealingArea_SoundPlaying), playSound "meh_heal"];
    };
}] call CBA_fnc_addEventHandler;