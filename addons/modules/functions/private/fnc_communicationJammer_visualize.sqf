#include "script_component.hpp"

#define CLAMP(value,lower,upper) lower max (value min upper)

params ["_module", "_area", "_formula", "_k", "_visualizeRadius"];
private _previous = _module getVariable [QGVAR(CommunicationJammer_3DENMarkers), []];
{deleteVehicle _x} forEach _previous;
private _markers = [];

private _center = getPosASL _module;
private _maxRadius = (_area#0) max (_area#1);
private _levels = switch _visualizeRadius do {
    case 1: {[0, 0.25, 0.5, 0.75]};
    case 2;
    case 3: {[0, 0.5, 0.75]};
    default {[]};
};

{
    private _desiredJam = _x;
    private _normalizedDistance = 0;
    switch _formula do {
        case 0: {_normalizedDistance = 1 - _desiredJam};
        case 1: {
            _normalizedDistance = if (_k == 0) then {1 - _desiredJam} else {(1 - _desiredJam) ^ (1 / _k)};
        };
        case 2: {
            _normalizedDistance = if (_desiredJam > 0) then {- (log _desiredJam) / _k} else {_maxRadius};
        };
        case 3: {
            _normalizedDistance = if (_desiredJam >= 1) then {0} else {(10 ^ ((log (_k max 2)) * (1 - _desiredJam))) - 1};
        };
        case 4: {
            _normalizedDistance = if (_desiredJam >= 1) then {0} else {((1 - _desiredJam) - 1) ^ (1 / _k)};
        };
        case 5: {_normalizedDistance = acos (CLAMP(2 * _desiredJam - 1,-1,1)) / (_k * pi)};
        case 6: {
            _normalizedDistance = if (_desiredJam == 0 || {_desiredJam >= 1}) then {0.5} else {0.5 + (log ((1 / _desiredJam) - 1)) / _k};
        };
    };
    private _distance = CLAMP(_normalizedDistance * _maxRadius,0,_maxRadius);
    private _positions = [];
    switch _visualizeRadius do {
        case 1: {
            private _count = 2 * pi * _distance / 5;
            for "_i" from 0 to (_count - 1) do {
                private _angle = _i * 360 / _count;
                _positions pushBack [(_center#0) + _distance * cos _angle, (_center#1) + _distance * sin _angle, _center#2];
            };
        };
        case 2: {_positions pushBack _center};
        case 3: {
            private _phi = (1 + sqrt 5) / 2;
            for "_i" from 0 to 499 do {
                private _z = 1 - (2 * _i) / 499;
                private _radiusAtHeight = sqrt (1 - _z^2);
                private _theta = deg (2 * pi * _i / _phi);
                _positions pushBack [
                    (_center#0) + _radiusAtHeight * cos _theta * _distance,
                    (_center#1) + _radiusAtHeight * sin _theta * _distance,
                    (_center#2) + _z * _distance
                ];
            };
        };
    };
    {
        private _orb = createSimpleObject ["Sign_Sphere100cm_F", _x];
        if (_visualizeRadius == 2) then {
            _orb setObjectScale (_distance / CM_TO_M(100/2));
        };
        if (_visualizeRadius == 3) then {
            _orb setObjectScale (CM_TO_M(100/2) * (1 + 0.05 * _distance));
        };
        private _color = switch true do {
            case (_desiredJam >= 0.75): {"0.5,0,0"};
            case (_desiredJam >= 0.5): {"0.5,0.5,0"};
            default {"0,0.5,0"};
        };
        private _alpha = if (_visualizeRadius == 2) then {
            switch true do {
                case (_desiredJam >= 0.75): {0.03};
                case (_desiredJam >= 0.5): {0.02};
                default {0.01};
            }
        } else {1};
        _orb setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2)", _color, _alpha]];
        _markers pushBack _orb;
    } forEach _positions;
} forEach _levels;
_module setVariable [QGVAR(CommunicationJammer_3DENMarkers), _markers];
