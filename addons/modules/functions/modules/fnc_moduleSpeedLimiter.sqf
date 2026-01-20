#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if (!is3DEN && {!_isActivated}) exitWith {};
if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _speed = _module getVariable [QUOTE(Speed), 0];
private _affectPlayer = _module getVariable [QUOTE(AffectPlayer), true];
private _affectAI = _module getVariable [QUOTE(AffectAI), true];

private _vehicles = synchronizedObjects _module select {_x isKindOf "Tank" || _x isKindOf "Ship" || _x isKindOf "Air" || _x isKindOf "Car"};
if (_speed < 0) exitWith {[typeOf _module] call EFUNC(Error,invalidArgs)};
if ((!_affectPlayer) && (!_affectAI)) exitWith {};

// Functions
//------------------------------------------------------------------------------------------------
private _limitSpeed = {
    params [
        ["_vehicles", [], [[], objNull]],
        ["_speed", 0, [-1]],
        ["_affectPlayer", true, [true]],
        ["_affectAI", true, [true]]
    ];

    if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
    if (_speed < 0) then {_speed = abs _speed};
    if ((!_affectPlayer) && (!_affectAI)) exitWith {};

    _vehicles apply {
        private _vehicle = _x;

        if (_affectPlayer) then {
            [QGVAR(vehicleCruiseControl), [_vehicle, _speed], format[QGVAR(SpeedLimiter_%1), _vehicle]] call CBA_fnc_globalEventJIP;
        };

        if (_affectAI) then {
            _vehicle limitSpeed _speed;
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _speed, _affectPlayer, _affectAI] call _limitSpeed;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "Tank" || _x isKindOf "Ship" || _x isKindOf "Air" || _x isKindOf "Car" || _x isKindOf "EmptyDetector")};
        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection
            remove3DENConnection ["Sync", _invalid, _module];
        };
    };

    default {};
};
