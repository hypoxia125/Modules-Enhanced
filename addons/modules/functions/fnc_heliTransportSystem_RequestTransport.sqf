params ["_playerID", "_positionClicked"];

private _player = getUserInfo _playerID param [10, objNull];
if (isNull _player) exitWith {};

// Find nearest landing zone
private _nearest = GVAR(HeliTransportSystem_LandingZones) param [0, createHashMap];
if (count _nearest == 0) exitWith {};

{
    private _lz = _x;
    private _positionCandidate = _lz get "position";

    private _distanceNearest = _player distance2D (_nearest get "position");
    private _distanceCandidate = _player distance2D _positionCandidate;

    if (_distanceCandidate <= _distanceNearest) then {
        _nearest = _lz;
    };
} forEach GVAR(HeliTransportSystem_LandingZones);