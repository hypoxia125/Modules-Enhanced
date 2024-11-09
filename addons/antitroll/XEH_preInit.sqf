#include "script_component.hpp"

#include "XEH_PREP.hpp"

/* ----- Events - Replaces remoteExec ----- */

[QGVAR(throwUnit), {
    params ["_unit", "_force"];

    private _forceVector = _unit vectorModelToWorld [0,10000,3000];
    _unit addForce [_forceVector, [0,0,0], false];
}] call CBA_fnc_addEventHandler;

[QGVAR(startRagdoll), {
    params ["_unit"];

    _unit addForce [_unit vectorModelToWorld [0,10,0], [0,0,0], false];
}] call CBA_fnc_addEventHandler;

[QGVAR(setRocketAnimation), {
    params ["_unit"];

    if (local _unit) then { removeAllWeapons _unit };
    _unit switchMove "TransAnimBase";
}] call CBA_fnc_addEventHandler;

[QGVAR(attachPlayerToRocket), {
    params ["_player", "_missile"];

    _player attachTo [_missile, [0.5, 0, 0]];
    _player setVectorDirAndUp [[1, 0, 0], [0, 1, 0]];
    _player setPosWorld getPosWorld _player;
}] call CBA_fnc_addEventHandler;

[QGVAR(PunishServer), {
    params ["_instigator", "_punishType"];

    [_instigator, _punishType] call FUNC(punish);
}] call CBA_fnc_addEventHandler;

[QGVAR(punishmentMessage), {
    hint "You have been punished for teamdamage!";
}] call CBA_fnc_addEventHandler;

[QGVAR(addHitEventHandler), {
    params ["_unit"];

    diag_log format["Adding hit eventhandler for %1", _unit];

    private _hitHandler = _unit getVariable [QGVAR(HitHandlerIndex), -1];
    if (_hitHandler != -1) then {
        _unit removeEventHandler ["Hit", _hitHandler];
    };

    private _handle = _unit addEventHandler ["Hit", {
        params ["_unit", "_source", "_damage", "_instigator"];

        private _side = side group _instigator;
        if (side group _unit isNotEqualTo _side) exitWith {};

        private _teamDamageThreshold = missionNamespace getVariable format[QGVAR(TeamdamageThreshold_%1), _side];
        if (isNil "_teamDamageThreshold") exitWith { diag_log format["MEH::Antitroll: No team damage threshold given..."] };

        private _teamDamagePunishType = missionNamespace getVariable format[QGVAR(TeamdamagePunishType_%1), _side];
        if (isNil "_teamDamagePunishType") exitWith { diag_log format["MEH::Antitroll: No team damage punish type given..."] };

        private _hitCount = _instigator getVariable [QGVAR(HitCount), 0];
        _hitCount = _hitCount + 1;

        diag_log format["Player: %1 hit player %2, %3 times!", _instigator, _unit, _hitcount];

        if (_hitCount >= _teamDamageThreshold) then {
            [QGVAR(PunishServer), [_instigator, _teamDamagePunishType]] call CBA_fnc_serverEvent;
            _instigator setVariable [QGVAR(HitCount), 0, true];
        } else {
            _instigator setVariable [QGVAR(HitCount), _hitCount, true];
        };
    }];

    _unit setVariable [QGVAR(HitHandlerIndex), _handle, true];
}] call CBA_fnc_addEventHandler;