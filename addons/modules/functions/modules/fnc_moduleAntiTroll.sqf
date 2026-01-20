#include "script_component.hpp"
#include "module_defaults.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if !(_mode in ["init", "attributesChanged3DEN"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _affectedSide = _module getVariable ["AffectedSide", AFFECTEDSIDE];
private _teamkillThreshold = ceil abs (_module getVariable ["TeamkillThreshold", TEAMKILLTHRESHOLD]);
private _teamkillPunishType = _module getVariable ["TeamkillPunishType", TEAMKILLPUNISHTYPE];
private _teamDamageThreshold = ceil abs (_module getVariable ["TeamDamageThreshold", TEAMDAMAGETHRESHOLD]);
private _teamDamagePunishType = _module getVariable ["TeamDamagePunishType", TEAMDAMAGEPUNISHTYPE];

// Code Start
//------------------------------------------------------------------------------------------------
if (is3DEN) exitWith {};

// Build all synced sides
private _syncedSoldiers = [];
private _syncedSides = [];
_syncedSoldiers = synchronizedObjects _module select { _x isKindOf "CAManBase" };
_syncedSoldiers apply {
    _syncedSides pushBackUnique side group _x;
};

private _affectedSides = switch _affectedSide do {
    case 0: {[east]};
    case 1: {[west]};
    case 2: {[independent]};
    case 3: {[civilian]};
    case 4: {[east, west, independent, civilian]};
    case 5: {_syncedSides};
};

private _totalAffectedSides = [];
{
    if (_x in _totalAffectedSides) then {
        _affectedSides deleteAt _forEachIndex;
        continue;
    };
    _totalAffectedSides pushBackUnique _x;
} forEachReversed _affectedSides;

if (_affectedSides isEqualTo []) exitWith {
    [typeOf _module, "No affected sides"] call EFUNC(error,InvalidArgs);
};

// Build vars for sides
{
    missionNamespace setVariable [format[QGVAR(TeamkillThreshold_%1), _x], _teamkillThreshold, true];
    missionNamespace setVariable [format[QGVAR(TeamkillPunishType_%1), _x], _teamkillPunishType, true];
    missionNamespace setVariable [format[QGVAR(TeamdamageThreshold_%1), _x], _teamDamageThreshold, true];
    missionNamespace setVariable [format[QGVAR(TeamdamagePunishType_%1), _x], _teamDamagePunishType, true];
} forEach _affectedSides;

// Global tk event
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    _thisArgs params ["_TKThreshold", "_TKPunishType", "_affectedSides"];

    if (side group _instigator isNotEqualTo side group _unit) exitWith {};
    if !(side group _instigator in _affectedSides) exitWith {};

    private _tkCount = _instigator getVariable [QGVAR(TKCount), 0];
    _tkCount = _tkCount + 1;

    if (_tkCount >= _TKThreshold) then {
        [_instigator, _TKPunishType] call FUNC(punishPlayer);
        _instigator setVariable [QGVAR(TKCount), 0, true];
    } else {
        _instigator setVariable [QGVAR(TKCount), _tkCount, true];
    };
}, [_teamkillThreshold, _teamkillPunishType, _affectedSides]];

_affectedSides apply {
    private _side = _x;
    units _side apply {
        [QGVAR(addHitEventHandler), [_x], _x] call CBA_fnc_targetEvent;
    };
};

// Global respawn adding the hit event handler
addMissionEventHandler ["EntityRespawned", {
    params ["_newEntity", "_oldEntity"];
    _thisArgs params ["_affectedSides"];

    if !(side group _newEntity in _affectedSides) exitWith {};

    [QGVAR(addHitEventHandler), [_newEntity], _newEntity] call CBA_fnc_targetEvent;
}];
