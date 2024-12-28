#include "script_component.hpp"

params ["_array"];

private _maxNum = _array#0;

{
    if (_x > _maxNum) then {
        _maxNum = _x;
    };
} forEach _array;

// Return
_maxNum;