params [
    ["_crate", objNull, [objNull]],
    ["_height", 5, [-1]]
];

if (!isServer) exitWith {};

// Verify params
if (_height <= 0) then {_height = 0};

// Variables
private _parachuteClass = "B_Parachute_02_F";
private _attachPoint = [0,0,0];

// Create and attach parachute
private _pos = getPosASL _crate;
private _parachute = createVehicle [_parachuteClass, _pos, [], 0, "NONE"];
_crate attachTo [_parachute, _attachPoint];

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