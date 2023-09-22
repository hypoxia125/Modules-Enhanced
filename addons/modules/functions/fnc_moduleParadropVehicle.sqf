#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]]
];

if (!isServer) exitWith {};

// Variables
private _vehicleClass = call compile (_module getVariable [QUOTE(VehicleClass), ""]);
private _createCrew = _module getVariable [QUOTE(CreateCrew), true];
private _crewSide = _module getVariable [QUOTE(CrewSide), 1];
private _paraHeight = _module getVariable [QUOTE(ParadropHeight), 500];
private _parachuteHeight = _module getVariable [QUOTE(ParachuteHeight), 100];
private _code = compile (_module getVariable [QUOTE(Expression), "true"]);

// Verify variables
if (_vehicleClass isEqualTo "") exitWith {};
if (_paraHeight <= 0 && _paraHeight != -1) then {_paraHeight = 500};
if (_parachuteHeight <= 0) then {_parachuteHeight = 0};

_crewSide = switch _crewSide do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    case 3: {civilian};
};

private _pos = getPosATL _module;
if !(_paraHeight == -1) then {
    _pos set [2, 0];
    _pos = _pos vectorAdd [0,0,_paraHeight];
};

[_vehicleClass, _createCrew, _crewSide, _pos, _parachuteHeight, _code] call FUNC(paradropVehicle);
