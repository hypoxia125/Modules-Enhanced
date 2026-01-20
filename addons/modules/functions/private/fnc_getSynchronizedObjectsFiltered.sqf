#include "script_component.hpp"

params ["_object", ["_types", []]];

_types = _types apply { toUpperANSI _x };

private _syncTemp = synchronizedObjects _object;
private _sync = [];

if ("TRIGGER" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "EmptyDetector"}];
};
if ("AMMOBOX" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "ReammoBox_F"}];
};
if ("MAN" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "CAManBase"}];
};
if ("LANDVEHICLE" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "LandVehicle"}];
};
if ("PLANE" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "Plane"}];
};
if ("HELICOPTER" in _types) then {
    _sync insert [-1, _syncTemp select {_x isKindOf "Helicopter"}];
};

_sync
