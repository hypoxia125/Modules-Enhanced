#include "script_component.hpp"

params ["_module", "_elapsed"];
if (!isServer) exitWith {};

private _area = _module getVariable QGVAR(CapturePoint_Area);
private _markers = _module getVariable QGVAR(CapturePoint_Markers);
private _letter = _module getVariable "CapturePointLetter";
private _letterMarker = _markers#2;
if !(_module getVariable [QGVAR(CapturePoint_Active), true]) exitWith {
    _letterMarker setMarkerType "mil_objective";
};
private _letterType = format ["loc_Letter%1", _letter];
if (getMarkerType _letterMarker != _letterType) then {_letterMarker setMarkerType _letterType};

private _owner = _module getVariable QGVAR(CapturePoint_Owner);
private _oldOwner = _owner;
private _progress = _module getVariable QGVAR(CapturePoint_Progress);
private _sides = [east, west, independent, civilian];
private _counts = createHashMap;
{
    private _side = _x;
    _counts set [_side, {alive _x && {_x inArea _area}} count units _side];
} forEach _sides;

private _rate = _elapsed / (_module getVariable "CaptureTime");
private _multiplierSetting = _module getVariable "CaptureRateMultiplier";
private _multiplier = {
    params ["_side", "_counts", "_setting"];
    private _count = _counts get _side;
    1 + (if (_count > 0) then {((_count - 1) * _setting) min 1} else {0})
};

if (_owner != sideUnknown) then {
    private _ownerCount = _counts get _owner;
    private _enemyCount = 0;
    private _strongestEnemy = _owner;
    private _strongestCount = 0;
    {
        if (_x != _owner) then {
            private _count = _counts get _x;
            _enemyCount = _enemyCount + _count;
            if (_count > _strongestCount) then {
                _strongestCount = _count;
                _strongestEnemy = _x;
            };
        };
    } forEach _sides;
    if (_ownerCount > _enemyCount) then {
        _progress set [_owner, 1 min ((_progress get _owner) + _rate * ([_owner, _counts, _multiplierSetting] call _multiplier))];
    } else {
        if (_ownerCount != _enemyCount && {_enemyCount > 0}) then {
            _progress set [_owner, 0 max ((_progress get _owner) - _rate * ([_strongestEnemy, _counts, _multiplierSetting] call _multiplier))];
        };
    };
};

// The original update processes both owner and neutral states in the same tick.
if (_owner == sideUnknown) then {
    private _total = 0;
    {_total = _total + (_counts get _x)} forEach _sides;
    if (_total == 0) then {
        {_progress set [_x, 0 max ((_progress get _x) - _rate)]} forEach _sides;
    } else {
        private _leader = sideUnknown;
        private _highest = 0;
        {
            if ((_counts get _x) > _highest) then {
                _highest = _counts get _x;
                _leader = _x;
            };
        } forEach _sides;
        private _tied = _sides findIf {_x != _leader && {(_counts get _x) == _highest}} != -1;
        if (!_tied) then {
            {
                if (_x == _leader) then {
                    _progress set [_x, 1 min ((_progress get _x) + _rate * ([_x, _counts, _multiplierSetting] call _multiplier))];
                } else {
                    _progress set [_x, 0 max ((_progress get _x) - _rate)];
                };
            } forEach _sides;
        };
    };
};

private _capturingSide = sideUnknown;
private _highestProgress = 0;
private _hasProgress = false;
{
    private _value = _progress get _x;
    if (_value > _highestProgress) then {
        _highestProgress = _value;
        if (_value > 0) then {_capturingSide = _x};
    };
    if (_value > 0) then {_hasProgress = true};
} forEach _sides;

private _newOwner = sideUnknown;
if (_highestProgress >= 1) then {_newOwner = _capturingSide};
if (_newOwner != sideUnknown && {_newOwner != _owner}) then {
    _owner = _newOwner;
    {_progress set [_x, 0]} forEach _sides;
    _progress set [_owner, 1];
} else {
    if (_newOwner == sideUnknown && {!_hasProgress}) then {_owner = sideUnknown};
};

if (_owner != _oldOwner) then {
    _module setVariable [QGVAR(CapturePoint_Owner), _owner];
    private _colors = createHashMapFromArray [
        [east, "ColorEast"], [west, "ColorWest"], [independent, "ColorIndependent"],
        [civilian, "ColorCivilian"], [sideUnknown, "ColorBlack"]
    ];
    {_x setMarkerColor (_colors get _owner)} forEach _markers;
    [missionNamespace, QGVAR(CapturePoint_OwnerChanged), [_module, _oldOwner, _owner, _letter]] call BIS_fnc_callScriptedEventHandler;
    [QGVAR(CapturePoint_OwnerChanged), [_module, _oldOwner, _owner, _letter]] call CBA_fnc_globalEvent;
};

private _data = [];
{_data pushBack [_x, _y]} forEach _progress;
[QGVAR(CapturePoint_ProgressTick), [_module, _area, _letter, _owner, _data]] call CBA_fnc_globalEvent;
