#include "script_component.hpp"

#include "XEH_PREP.hpp"

// CreateRemoteTarget
//------------------------------------------------------------------------------------------------
[QGVAR(CreateRemoteTarget_ReportTarget), {
    params ["_vehicle", "_side", "_time"];

    _side reportRemoteTarget [_vehicle, _time];
}] call CBA_fnc_addEventHandler;

// Misc
//------------------------------------------------------------------------------------------------
[QGVAR(HideObjectServer), {
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

// RepairVehicle
//------------------------------------------------------------------------------------------------
[QGVAR(repairVehicle), {
    params ["_vehicle", "_repairPercent"];

    LOG_2("ModuleVehicleRepair:: Repairing vehicle: %1 by %2",_vehicle,_repairPercent);

    getAllHitPointsDamage _vehicle params ["_names", "_selections", "_damageVal"];
    
    {
        private _value = _x;
        _value = _value - _repairPercent;
        
        _vehicle setHitPointDamage [_names#_forEachIndex, _value max 0];
    } forEach _damageVal;
}] call CBA_fnc_addEventHandler;

// VehicleFuelCoef
//------------------------------------------------------------------------------------------------
[QGVAR(VehicleFuelCoef_SetCoef), {
    params ["_vehicle", "_coef"];

    _vehicle setFuelConsumptionCoef _coef;
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

    LOG_2("EnableDisableGunLights:: Unit [%1] - WeaponLightState [%2]",_unit,_lightState);
}] call CBA_fnc_addEventHandler;

[QGVAR(AddFlashlightAttachment), {
    params ["_unit", "_attachment"];

    if (_attachment isEqualTo "") exitWith {};

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
[QGVAR(AddTrapInventoryEHLocal), {
    params [
        ["_InventoryOpenedEHCode", {}, [{}]]
    ];

    LOG_1("ModuleTrapInventory: Attempting to add Inventory Opened EH to unit [%1]",player);

    // Check if handler already exists
    private _handle = player getVariable [QGVAR(TrapInventory_InventoryOpenedEHHandle), -1];
    if (_handle isNotEqualTo -1) exitWith {
        LOG_1("ModuleTrapInventory: %1 already has the inventory opened EH!",player);
    };

    _handle = player addEventHandler ["InventoryOpened", _InventoryOpenedEHCode];
    if (_handle isEqualTo -1) then {
        LOG_1("ModuleTrapInventory: Failed to create InventoryOpened EH on unit: %1",player);
    } else {
        LOG_1("ModuleTrapInventory: Successfully created InventoryOpened EH on unit: %1",player);
    };

    player setVariable [QGVAR(TrapInventory_InventoryOpenedEHHandle), _handle];
}] call CBA_fnc_addEventHandler;

[QGVAR(AddTrapDisableActionLocal), {
    params ["_objects"];

    {
        private _object = _x;

        private _trapData = _object getVariable QGVAR(TrapInventory_Data);
        if (isNil "_trapData") exitWith {
            ERROR_1("ModuleTrapInventory: %1: No data to add to disable action!",_object);
        };

        private _holdAction = [
            _object,
            LLSTRING(TrapInventory_Action_DisableTrap),
            "a3\ui_f\data\igui\cfg\holdactions\holdaction_search_ca.paa",
            "a3\ui_f\data\igui\cfg\holdactions\holdaction_search_ca.paa",
            toString {
                [_target, _this] call FUNC(trapInventoryActionShow)
            },
            "true",
            {},
            {},
            {
                params ["_target", "_caller", "_actionID", "_arguments"];

                private _trapData = _target getVariable QGVAR(TrapInventory_Data);
                if (isNil "_trapData") exitWith {
                    ERROR_1("ModuleTrapInventory: %1: No data to add to disable action!",_object);
                };

                _trapData set [4, false];
                _target setVariable [QGVAR(TrapInventory_Data), _trapData, true];

                hint LLSTRING(TrapInventory_TrapDisabled);
            },
            {},
            nil,
            8,
            1e6,
            true,
            false,
            true
        ] call BIS_fnc_holdActionAdd;
        _object setVariable [QGVAR(TrapInventory_HoldAction), _holdAction];

    } forEach _objects;
}] call CBA_fnc_addEventHandler;

[QGVAR(Say3DGlobal), {
    params ["_object", "_sound"];

    _object say3D _sound;
}] call CBA_fnc_addEventHandler;

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

// Antitroll
//------------------------------------------------------------------------------------------------
[QGVAR(throwUnit), {
    params ["_unit", "_force"];

    private _forceVector = _unit vectorModelToWorld [0,10000,3000];
    _unit addForce [_forceVector, [0,0,0], false];

    _player switchCamera "EXTERNAL";
}] call CBA_fnc_addEventHandler;

[QGVAR(startRagdoll), {
    params ["_unit"];

    _unit addForce [_unit vectorModelToWorld [0,10,0], [0,0,0], false];
}] call CBA_fnc_addEventHandler;

[QGVAR(setRocketAnimation), {
    params ["_unit"];

    if (local _unit) then { removeAllWeapons _unit };
    _unit switchMove "TransAnimBase";
}] call CBA_fnc_addEventHandler;

[QGVAR(attachPlayerToRocket), {
    params ["_player", "_missile"];

    _player attachTo [_missile, [0.5, 0, 0]];
    _player setVectorDirAndUp [[1, 0, 0], [0, 1, 0]];
    _player setPosWorld getPosWorld _player;

    _player switchCamera "EXTERNAL";
}] call CBA_fnc_addEventHandler;

[QGVAR(PunishServer), {
    params ["_instigator", "_punishType"];

    [_instigator, _punishType] call FUNC(punish);
}] call CBA_fnc_addEventHandler;

[QGVAR(punishmentMessage), {
    hint "You have been punished for teamdamage!";
}] call CBA_fnc_addEventHandler;

[QGVAR(addHitEventHandler), {
    params ["_unit"];

    diag_log format["Adding hit eventhandler for %1", _unit];

    private _hitHandler = _unit getVariable [QGVAR(HitHandlerIndex), -1];
    if (_hitHandler != -1) then {
        _unit removeEventHandler ["Hit", _hitHandler];
    };

    private _handle = _unit addEventHandler ["Hit", {
        params ["_unit", "_source", "_damage", "_instigator"];

        private _side = side group _instigator;
        if (side group _unit isNotEqualTo _side) exitWith {};

        private _teamDamageThreshold = missionNamespace getVariable format[QGVAR(TeamdamageThreshold_%1), _side];
        if (isNil "_teamDamageThreshold") exitWith { diag_log format["MEH::Antitroll: No team damage threshold given..."] };

        private _teamDamagePunishType = missionNamespace getVariable format[QGVAR(TeamdamagePunishType_%1), _side];
        if (isNil "_teamDamagePunishType") exitWith { diag_log format["MEH::Antitroll: No team damage punish type given..."] };

        private _hitCount = _instigator getVariable [QGVAR(HitCount), 0];
        _hitCount = _hitCount + 1;

        diag_log format["Player: %1 hit player %2, %3 times!", _instigator, _unit, _hitcount];

        if (_hitCount >= _teamDamageThreshold) then {
            [QGVAR(PunishServer), [_instigator, _teamDamagePunishType]] call CBA_fnc_serverEvent;
            _instigator setVariable [QGVAR(HitCount), 0, true];
        } else {
            _instigator setVariable [QGVAR(HitCount), _hitCount, true];
        };
    }];

    _unit setVariable [QGVAR(HitHandlerIndex), _handle, true];
}] call CBA_fnc_addEventHandler;