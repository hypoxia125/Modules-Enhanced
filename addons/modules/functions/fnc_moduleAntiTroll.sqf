#include "script_component.hpp"

params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

if (!isServer) exitWith {};
if (is3DEN) exitWith {};

// Variables
private _affectedSide = _module getVariable "AffectedSide";
private _teamkillThreshold = _module getVariable "TeamkillThreshold";
private _teamkillPunishType = _module getVariable "TeamkillPunishType";
private _teamDamageThreshold = _module getVariable "TeamDamageThreshold";
private _teamDamagePunishType = _module getVariable "TeamDamagePunishType";

// Checks
_teamkillThreshold = ceil (abs _teamkillThreshold);
_teamDamageThreshold = ceil (abs _teamDamageThreshold);

[
    _module,
    _affectedSide,
    _teamkillThreshold,
    _teamkillPunishType,
    _teamDamageThreshold,
    _teamDamagePunishType
] call EFUNC(antitroll,init);