#include "script_component.hpp"

params ["_pos", "_dir" ,"_class"];

if (!hasInterface) exitWith {};

// create dummy
private _dummy = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
_dummy setPosATL _pos;

// visual lightning object
private _lightning = _class createVehicleLocal [100,100,100];
_lightning setDir (random 360);

// lightpoint
private _light = "#lightpoint" createVehicleLocal _pos;
_light setPosATL [_pos select 0, _pos select 1, (_pos select 2) + 10];
_light setLightDayLight true;
_light setLightBrightness 300;
_light setLightAmbient [0.05, 0.05, 0.1];
_light setLightColor [1, 1, 2];

// attach lightning to dummy
_lightning setPos position _dummy;

// Flicker lightning
[{
    params ["_args", "_handle"];

    _args params ["_lightning", "_light"];

    if (!alive _lightning) exitWith {
        _lightning setVariable [QGVAR(lightningStrike_delete), true];
        _handle call CBA_fnc_removePerFrameHandler;
    };

    private _flickers = _lightning getVariable [QGVAR(lightningStrike_flickers), 0];
    if (_flickers >= 3) exitWith {};

    if (isObjectHidden _lightning) then {
        _lightning hideObject false;
        _light setLightBrightness 300;
    } else {
        _lightning hideObject true;
        _light setLightBrightness 0;
        
        _flickers = _flickers + 1;
        _lightning setVariable [QGVAR(lightningStrike_flickers), _flickers];
    };
}, 0.025, [_lightning, _light]] call CBA_fnc_addPerFrameHandler;

// Delete lightning + dummy
[{
    params ["_args", "_handle"];

    _args params ["_dummy", "_lightning", "_light", "_tickTime"];

    if (
        _lightning getVariable [QGVAR(lightningStrike_delete), false] ||
        // failsafe
        {diag_tickTime >= _tickTime + 5}
    ) then {
        deleteVehicle _dummy;
        deleteVehicle _lightning;
        deleteVehicle _light;
        
        _handle call CBA_fnc_removePerFrameHandler;
    };
}, 0, [_dummy, _lightning, _light, diag_tickTime]] call CBA_fnc_addPerFrameHandler;
