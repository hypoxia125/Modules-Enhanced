#include "script_component.hpp"

if (!is3DEN) exitWith {};

addMissionEventHandler ["Draw3D", {
    if (!is3DEN) exitWith {
        removeMissionEventHandler [_thisEvent, _thisEventHandler];
    };
    if ([QGVAR(ModuleMarkerHide), "priority"] call CBA_settings_fnc_get) exitWith {};

    private _modules = (all3DENEntities#3) select {_x isKindOf "Module_F"};

    {
        private _module = _x;
        private _pos = ASLToAGL getPosASL _module;

        private _distance = _pos distance get3DENCamera;
        if (_distance >= [QGVAR(ModuleMarkerDistanceLimit), "priority"] call CBA_settings_fnc_get) then { continue };

        private _text = getText (configFile >> "CfgVehicles" >> typeOf _module >> "displayName");
        if (_text == "") then {
            _text = typeOf _module;
        };
        // Add text if it is a spawner waypoint
        if (typeOf _module == "MEH_ModuleSpawnerWaypoint") then {
            private _index = _module getVariable ["WaypointIndex", 0];
            if (_index < 0) then { _index = "ERROR" };
            _text = format["%1 - Index: %2", _text, _index];
        };

        private _textSize = (1 * (50 / _distance) max 0.2) min 0.03;
        private _color = [QGVAR(ModuleMarkerColor), "priority"] call CBA_settings_fnc_get;

        drawIcon3D [
            "",
            _color,
            _pos,
            1 * (50 / _distance) max 0.5,
            1 * (50 / _distance) max 0.5,
            0,
            _text,
            0,
            _textSize
        ];
    } forEach _modules;
}];
