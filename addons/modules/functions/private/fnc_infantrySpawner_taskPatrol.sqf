#include "script_component.hpp"

params ["_group", "_position", "_area"];
[_group] call CBA_fnc_clearWaypoints;
_area = [_position] + _area;

for "_i" from 1 to 4 do {
    private _pos = [[_area]] call BIS_fnc_randomPos;
    private _wp = _group addWaypoint [_pos, -1];
    _wp setWaypointBehaviour "SAFE";
    if (_i == 4) then {
        _wp setWaypointStatements [
            toString {true},
            toString {
                if !(local this) exitWith {};
                private _group = group this;
                private _module = _group getVariable [QGVAR(InfantrySpawner_Module), objNull];
                if (isNull _module) exitWith {};
                [_group, getPosATL _module, _module getVariable "ObjectArea"] call FUNC(infantrySpawner_taskPatrol);
            }
        ];
    };
};
waypoints _group
