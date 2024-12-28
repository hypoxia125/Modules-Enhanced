#include "script_component.hpp"

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
if (is3DEN) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _affectedSide = _module getVariable "AffectedSide";
private _teamkillThreshold = _module getVariable "TeamkillThreshold";
private _teamkillPunishType = _module getVariable "TeamkillPunishType";
private _teamDamageThreshold = _module getVariable "TeamDamageThreshold";
private _teamDamagePunishType = _module getVariable "TeamDamagePunishType";

_teamkillThreshold = ceil (abs _teamkillThreshold);
_teamDamageThreshold = ceil (abs _teamDamageThreshold);

// Functions
//------------------------------------------------------------------------------------------------
private _init = {
    params [
        ["_module", objNull],
        "_affectedSide",
        "_teamkillThreshold",
        "_teamkillPunishType",
        "_teamDamageThreshold",
        "_teamDamagePunishType"
    ];

    if (!isServer) exitWith {};
    if (is3DEN) exitWith {};

    private _synchedSoldiers = [];
    private _syncedSides = [];
    if (!isNull _module) then {
        _syncedSoldiers = synchronizedObjects _module select {_x isKindOf "CAManBase"};
        _syncedSoldiers apply {
            _syncedSides pushBackUnique side group _x;
        };
    };
    diag_log format["MEH:: Antitroll Module: Synced Sides: %1", _syncedSides];

    private _affectedSides = switch _affectedSide do {
        case 0: {[east]};
        case 1: {[west]};
        case 2: {[independent]};
        case 3: {[civilian]};
        case 4: {[east, west, independent, civilian]};
        case 5: {_syncedSides};
    };

    private _totalAffectedSides = missionNamespace getVariable [QGVAR(TotalAffectedSides), []];
    {
        if (_x in _totalAffectedSides) then {
            diag_log format["MEH::AntiTroll - Side %1 is already registered in the system!", _x];
            _affectedSides deleteAt _forEachIndex;
            continue;
        };

        _totalAffectedSides pushBackUnique _x;
    } forEachReversed _affectedSides;
    missionNamespace setVariable [QGVAR(TotalAffectedSides), _totalAffectedSides, true];

    diag_log format["MEH:: Antitroll Module: Affected Sides: %1", _affectedSides];
    if (_affectedSides isEqualTo []) exitWith {};

    _affectedSides apply {
        diag_log format["MEH::Antitroll: Building vars for side - %1", _x];
        missionNamespace setVariable [format[QGVAR(TeamkillThreshold_%1), _x], _teamkillThreshold, true];
        missionNamespace setVariable [format[QGVAR(TeamkillPunishType_%1), _x], _teamkillPunishType, true];
        missionNamespace setVariable [format[QGVAR(TeamdamageThreshold_%1), _x], _teamDamageThreshold, true];
        missionNamespace setVariable [format[QGVAR(TeamdamagePunishType_%1), _x], _teamDamagePunishType, true];
    };

    // Global tk event
    addMissionEventHandler ["EntityKilled", {
        params ["_unit", "_killer", "_instigator", "_useEffects"];
        _thisArgs params ["_TKThreshold", "_TKPunishType"];

        if (side group _instigator isNotEqualTo side group _unit) exitWith {};
        if !(side group _instigator in _affectedSides) exitWith {};

        private _tkCount = _instigator getVariable [QGVAR(TKCount), 0];
        _tkCount = _tkCount + 1;

        if (_tkCount >= _TKThreshold) then {
            [_instigator, _TKPunishType] call FUNC(punish);
            _instigator setVariable [QGVAR(TKCount), 0, true];
        } else {
            _instigator setVariable [QGVAR(TKCount), _tkCount, true];
        };
    }, [_teamkillThreshold, _teamkillPunishType, _affectedSides]];

    // Add event to all applicable units
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
};

FUNC(punish) = compileFinal {
    params ["_player", "_type"];

    if (isNil "_player" || {isNull _player}) exitWith {};

    switch _type do {
        // suicide
        case 0: {
            _player setDamage 1;
        };
        // prison
        case 1: {

        };
        // lightning
        case 2: {
            private _bolt = createVehicle ["MEH_LightningBolt", [100,100,100], [], 0, "CAN_COLLIDE"];
            private _pos = getPosATL _player;
            _bolt setPosATL _pos;
            _bolt setDamage 1;

            [QEGVAR(effects,lightningStrike_Local), [getPosATL _player, random 360, selectRandom ["Lightning1_F", "Lightning2_F"]]] call CBA_fnc_globalEvent;
            _player setDamage 1;
        };
        // throw
        case 3: {
            [QGVAR(throwUnit), [_player, 100], _player] call CBA_fnc_targetEvent;
        };
        // launch
        case 4: {
            private _missile = createVehicle ["ammo_Missile_Cruise_01", getPosATL _player vectorAdd [0,0,3], [], 0, "NONE"];
            _missile setVectorDirAndUp [[0, 0, 1], [1, 0, 0]];

            [QGVAR(setRocketAnimation), [_player]] call CBA_fnc_globalEvent;
            [QGVAR(attachPlayerToRocket), [_player, _missile], _player] call CBA_fnc_targetEvent;

            [{
                params ["_missile", "_player"];

                detach _player;
                [QGVAR(startRagdoll), [_player], _player] call CBA_fnc_targetEvent;
                triggerAmmo _missile;

            }, [_missile, _player], 5] call CBA_fnc_waitAndExecute;
        };
    };

    [QGVAR(punishmentMessage), [], _player] call CBA_fnc_targetEvent;
};

// Code Start
//------------------------------------------------------------------------------------------------
[
    _module,
    _affectedSide,
    _teamkillThreshold,
    _teamkillPunishType,
    _teamDamageThreshold,
    _teamDamagePunishType
] call _init;