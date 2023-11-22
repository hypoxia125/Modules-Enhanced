#include "script_component.hpp"

#include "XEH_PREP.hpp"

// Events

[QGVAR(hideObjectGlobal), {
    params ["_unit", "_value"];

    _unit hideObjectGlobal _value;
    _unit enableSimulationGlobal (!_value);
}] call CBA_fnc_addEventHandler;

[QGVAR(hideObjectForTeleport), {
    params ["_unit", "_value"];

    _unit allowDamage (!_value);
    [QGVAR(hideObjectGlobal), [_unit, _value]] call CBA_fnc_serverEvent;
}] call CBA_fnc_addEventHandler;

[QGVAR(updatelbColor), {
    params [["_object", objNull], ["_color", ""]];

    if (isNull findDisplay IDD_TELEPORTMENU) exitWith {};
    private _index = (GVAR(teleporterData) apply {_x select 1} find _object);
    if (_index == -1) exitWith {};

    private _control = findDisplay IDD_TELEPORTMENU displayCtrl IDC_LOCLIST;
    
    private _colorRGBA = switch _color do {
        case "green": {[0,0.8,0,1]};
        case "red": {[0.9,0,0,1]};
    };

    _control lbSetColor [_index, _colorRGBA];
}] call CBA_fnc_addEventHandler;
