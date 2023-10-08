#include "script_component.hpp"

params [
    ["_area", [], [[]], 6],
    ["_placedBy", west, [sideUnknown]],
    ["_mineClasses", [], [[]]],
    ["_mineDensity", 10, [-1]],
    ["_markMap", [], [[]]]
];

// Verify variables
if (_mineClasses isEqualTo []) exitWith {};
if (_mineDensity <= 0) exitWith {};
_area params ["_center", "_a", "_b", "_angle", "_isRectangle", "_z"];

// Calculate total mines needed
private ["_totalMines"];
if (_isRectangle) then {
    _totalMines = (_mineDensity * _a * _b) / 100;
} else {
    _totalMines = (_mineDensity * pi * (_a/2) * (_b/2)) / 100;
};

// Create mines
private _createdMines = [];
for "_i" from 0 to _totalMines - 1 do {
    private _pos = [[_area]] call BIS_fnc_randomPos;
    _pos set [2, 0];

    private _mine = createMine [selectRandom _mineClasses, _pos, [], 0];
    _mine setVectorUp (surfaceNormal _pos);
    _createdMines pushBackUnique _mine;
};

// Reveal Mines
if (_markMap isNotEqualTo []) then {
    private _marker = createMarkerLocal [FORMAT_1("Minefield_%1",_area), _center];
    _marker setMarkerSizeLocal [_a, _b];
    _marker setMarkerDirLocal _angle;
    _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select _isRectangle);
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerColorLocal "ColorRED";
    _marker setMarkerAlpha 1;

    private _marker = createMarkerLocal [FORMAT_1("MinefieldBrush_%1",_area), _center];
    _marker setMarkerSizeLocal [_a, _b];
    _marker setMarkerDirLocal _angle;
    _marker setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select _isRectangle);
    _marker setMarkerBrushLocal "Grid";
    _marker setMarkerColorLocal "ColorRED";
    _marker setMarkerAlpha 1;

    private _marker = createMarkerLocal [FORMAT_1("MinefieldIcon_%1",_area), _center];
    _marker setMarkerShapeLocal "Icon";
    _marker setMarkerTypeLocal "mil_warning";
    _marker setMarkerColorLocal "ColorRED";
    _marker setMarkerAlpha 1;
};

// Broadcast Event
[QGVAR(createMinefield_MinefieldCreated), [_area, _createdMines]] call CBA_fnc_globalEvent;
