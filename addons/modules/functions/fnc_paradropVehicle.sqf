#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_vehicles", [], [objNull, []]],
    ["_isActivated", false, [true]]
];

if (!isServer) exitWith {};

// Variables
private _paraHeight = _module getVariable [QUOTE(ParadropHeight), 500];
private _parachuteHeight = _module getVariable [QUOTE(ParachuteHeight), 5];
private _position = _module getVariable [QUOTE(Position), 0];
private _expression = _module getVariable [QUOTE(Expression), ""];
private _modulePos = getPosATL _module;

// Verify variables
if (_paraHeight <= 0) then {_paraHeight = 500};
if (_parachuteHeight <= 0) {_parachuteHeight = 0};
if (_vehicles isEqualType objNull) then {_vehicles = [_vehicles]};
if (count _vehicles > 0) exitWith {
    ERROR_MSG_1("%1\nToo many vehicles synchronized to the module when using module position parameter.\nEither change the module to vehicle position or synchronize only one unit.", QFUNC(paradropVehicle));
};

// Hide and unsimulate objects
_vehicles apply {
    private _vehicle = _x;

    _vehicle hideObjectGlobal true;
    _vehicle enableSimulationGlobal false;
};

// Move vehicles to their drop position
_vehicles apply {
    private _vehicle = _x;
    // Which position - module or vehicle?
    private _pos = [_modulePos, getPosATL _vehicle] select {_position == 0 || count _vehicles > 1};
    if (_pos select 2 < 0) then {_pos set [2,0]};

    _pos = _pos vectorAdd [0,0,_paraHeight];
};

// Add parachute
private _parachuteClass = "B_Parachute_02_F";
private _attachPoint = [0,0,0];

_vehicles apply {
    private _vehicle = _x;
    private _pos = getPosASL _vehicle;
    private _parachute = createVehicle [_parachuteClass, _pos, [], 0, "NONE"];

    // Attach parachute
    _vehicle attachTo [_parachute, _attachpoint];

    // Upon reaching ground, disconnection parachute
    // Exit condition: if crate is null from being deleted by zeus or something
    [{
        params ["_crate", "", "_height"];

        private _valid = !isNull _crate;
        private _activate = (getPosATL _crate select 2) <= _height || {(getPosASL _crate select 2) <= 0};

        !_valid || {_activate};
    }, {
        params ["_crate", "_parachute"];

        private _valid = (!isNull _crate) || {(!isNil "_crate")};
        if (!_valid) exitWith {deleteVehicle _parachute};
        
        detach (_crate);
    }, [_crate, _parachute, _height]] call CBA_fnc_waitUntilAndExecute;
} // todo