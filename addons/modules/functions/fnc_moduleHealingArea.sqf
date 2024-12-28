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

// Variables
//------------------------------------------------------------------------------------------------
private _area = _module getVariable "ObjectArea";
private _affected = _module getVariable "Affected";
private _rate = _module getVariable "Rate";
private _showAreaMarker = _module getVariable "ShowAreaMarker";
private _showArea3D = _module getVariable "ShowArea3D";

// Functions
//------------------------------------------------------------------------------------------------
private _buildHealingArea = {
    params ["_module", "_area", "_affected", "_rate", "_showAreaMarker", "_showArea3D"];

    _area = [ASLToAGL getPosASL _module] + _area;

    if (_showAreaMarker) then {
        // map marker
        private _marker = createMarkerLocal [format[QGVAR(HealingArea_Marker_%1_Area), _module], _area#0];
        _marker setMarkerBrushLocal "FDiagonal";
        _marker setMarkerDirLocal _area#3;
        _marker setMarkerSizeLocal [_area#1, _area#2];
        _marker setMarkerShapeLocal "ELLIPSE";
        _marker setMarkerText "Healing Area";

        private _marker = createMarkerLocal [format[QGVAR(HealingArea_Marker_%1_Border), _module], _area#0];
        _marker setMarkerBrushLocal "Border";
        _marker setMarkerDirLocal _area#3;
        _marker setMarkerShapeLocal "ELLIPSE";
        _marker setMarkerSize [_area#1, _area#2];
    };

    if (_showArea3D) then {
        // 3d objects
        private _height = _area#5;
        if (_height == -1) then {_height = 20};
        private _layerheight = 10;
        private _a = _area#1;
        private _b = _area#2;
        private _spacing = 5;

        // Calculate circumference of the ellipse
        private _h = ((_a - _b)^2 / (_a + _b)^2);
        private _circumference = pi * (_a + _b) * (1 + (3 * _h) / (10 + sqrt(4 - 3 * _h)));

        private _numObjects = _circumference / _spacing;
        private _angleIncrement = 2 * pi / _numObjects;

        private _positions = [];
        private _orbs = [];
        for "_zz" from 0 to _height step _layerheight do {
            for "_j" from 0 to (_numObjects - 1) do {
                private _angleRadians = _j * _angleIncrement;
                private _angleDegrees = _angleRadians * (180 / pi);
                private _xx = _a * cos(_angleDegrees);
                private _yy = _b * sin(_angleDegrees);
                _positions pushBack [_xx + _area#0#0, _yy + _area#0#1, _zz + _area#0#2];
            };
        };

        {
            private _position = _x;
            private _orb = createVehicle ["Sign_Sphere25cm_F", _position, [], 0, "CAN_COLLIDE"];
            _orbs pushBack _orb;
        } forEach _positions;

        _module setVariable [QGVAR(HealingArea_Orbs), _orbs];
    };

    [{
        params ["_args", "_handle"];
        _args params ["_module", "_area", "_rate"];

        // Early exits
        if (!alive _module) exitWith {
            _handle call CBA_fnc_removePerFrameHandler;
        };

        private _affectedUnits = entities [["CAManBase"], [], false, true] select {_x inArea _area};
        LOG_1("Healing Area - Affected Units:: %1",_affectedUnits);

        if (_affectedUnits isEqualTo []) exitWith {};
        _affectedUnits apply {
            private _unit = _x;
            getAllHitPointsDamage _unit params ["_hitpoints", "_selections", "_values"];

            for "_i" from 0 to (count _hitpoints - 1) do {
                if (_values#_i < 1) then {
                    [QGVAR(HealingArea_HealUnit), [_unit, _hitpoints # _i, (_values # _i - _rate) max 0], owner _unit] call CBA_fnc_ownerEvent;
                };
            };
            if ({_x > 0} count _values == 1) then {
                _unit setDamage 0;
            };
        };
    }, 1, [_module, _area, _rate]] call CBA_fnc_addPerFrameHandler;
};

// Code Start
//------------------------------------------------------------------------------------------------
LOG_1("ModuleHealingArea:: Mode: %1",_mode);
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        [_module, _area, _affected, _rate, _showAreaMarker, _showArea3D] call _buildHealingArea;
    };

    case "attributesChanged3DEN": {
        if (
            fileExists "\z\ace\addons\medical\script_component.hpp" &&
            !(missionNamespace getVariable [QGVAR(ModuleHealingArea_ACEWarning), false])
        ) then {
            [
                "ACE Medical has been detected. The healing area module is not currently implimenting ACE medical. It only heals based on Vanilla Arma 3.",
                "Modules Enhanced - ACE Medical Detected",
                [
                    "Ok",
                    { missionNamespace setVariable [QGVAR(ModuleHealingArea_ACEWarning), true] }
                ],
                false,
                "",
                findDisplay 313
            ] call BIS_fnc_3DENShowMessage;
        };
    };

    default {};
};
