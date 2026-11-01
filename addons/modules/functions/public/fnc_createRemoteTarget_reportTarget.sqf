/*
    Function: meh_modules_fnc_createRemoteTarget_reportTarget
    Report an object as a remote target to a side, including join-in-progress clients.
    Arguments: [target, side, durationSeconds] (default: 900)
    Call on the server; returns nothing.
*/
#include "script_component.hpp"

params [
    ["_target", objNull, [objNull]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_time", 900, [0]]
];

if (!isServer || {isNull _target} || {_side isEqualTo sideUnknown} || {_time < 0}) exitWith {};
[QGVAR(CreateRemoteTarget_ReportTarget), [_target, _side, _time]] call CBA_fnc_globalEventJIP;
