#include "script_component.hpp"

params [["_state", false, [true]]];

// Set ACE hearing state
if (isClass (configFile >> "CfgPatches" >> "ace_hearing")) then {
    ACE_Hearing_DisableVolumeUpdate = _state;
};

if (_state) then {
    0 fadeSound 0;
    0 fadeEnvironment 0;

    [QGVAR(ClientMuted), [true]] call CBA_fnc_localEvent;
} else {
    3 fadeSound 1;
    3 fadeEnvironment 1;

    [QGVAR(ClientMuted), [false]] call CBA_fnc_localEvent;
};
