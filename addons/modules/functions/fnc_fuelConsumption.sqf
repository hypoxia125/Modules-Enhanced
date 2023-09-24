#include "script_component.hpp"

params [
    ["_vehicles", [], [[], objNull]],
    ["_tickRate", 1, [-1]],
    ["_idleTime", 60, [-1]]
];

// Verify variables
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (_tickRate < 1) then {_tickRate = 1};
if (_tickRate > 5) then {_tickRate = 5};
if (_idleTime < 1) then {_idleTime = 1};
if (_maxTime < 1) then {_maxTime = 1};
if (_maxTime > _idleTime) then {_maxTime = _idleTime};

_vehicles apply {
    private _vehicle = _x;
    private _maxSpeed = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "maxSpeed");
    
    if (_maxTime == -1) exitWith {};
    if (!(isNil {_vehicle getVariable QGVAR(FuelConsumptionActive)})) exitWith {
        LOG_1("Fuel consumption already active on %1", _vehicle);
    };
    
    private _handle = [{
        params ["_args", "_handle"];
        _args params ["_vehicle", "_maxSpeed", "_idleTime", "_maxTime", "_tickRate"];

        if (!alive _vehicle) exitWith {_handle call CBA_fnc_removePerFrameHandler};
        if (!isEngineOn _vehicle) exitWith {};

        private _speed = speed _vehicle;
        private _currFuel = fuel _vehicle;

        private _speedRatio = (_speed / _maxSpeed) min 1;
        private _fuelConsumed = ((1 / MIN_TO_SEC(_maxTime) * _speedRatio) * _tickRate) max (1 / MIN_TO_SEC(_idleTime) * _tickRate);
        private _newFuel = (_currFuel - _fuelConsumed) max 0;

        [QGVAR(setFuel), [_vehicle, _newFuel], driver _vehicle] call CBA_fnc_targetEvent;
    }, _tickRate, [_vehicle, _maxSpeed, _idleTime, _maxTime, _tickRate]] call CBA_fnc_addPerFrameHandler;

    _vehicle setVariable [QGVAR(FuelConsumptionActive), true];
};
