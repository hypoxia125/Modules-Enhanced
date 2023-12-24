#include "script_component.hpp"

params [
    ["_unit", objNull, [objNull]],
    ["_object", objNull, [objNull]],
    ["_travelTime", -1, [-1]]
];

if (!(local _unit)) exitWith {};

if (_travelTime == -1) then {
    _travelTime = [_unit, _object] call FUNC(getTravelTime);
};

// Fade screen
private _layer = QGVAR(blankScreen) call BIS_fnc_rscLayer;
uiNamespace setVariable [QGVAR(blankScreen), _layer];
_layer cutText [
    (FORMAT_1(LLSTRING(teleportingNotification), _travelTime)),
    "BLACK OUT", 3, true, true
];

[{
    params ["_unit", "_object", "_travelTime"];

    [QGVAR(hideObjectForTeleport), [_unit, true]] call CBA_fnc_localEvent;

    if (_object isKindOf "AllVehicles") then {
        // Set vehicle to have a traveler
        private _travelers = _object getVariable [QGVAR(currentTravelers), []];
        _travelers pushBackUnique player;
        _object setVariable [QGVAR(currentTravelers), _travelers, true];

        // Update all open teleport menus
        if (([_object, ""] call FUNC(findOpenVehiclePosition)) - count _travelers <= 0) then {
            [QGVAR(updatelbColor), [_object, "red"]] call CBA_fnc_globalEvent;
        };
    };

    [{
        params ["_unit", "_object", "_travelTime"];

        private _openCargo = [_object, "cargo"] call FUNC(findOpenVehiclePosition) > 0;
        private _openCommander = [_object, "commander"] call FUNC(findOpenVehiclePosition) > 0;
        private _openGunner = [_object, "gunner"] call FUNC(findOpenVehiclePosition) > 0;
        private _openDriver = [_object, "driver"] call FUNC(findOpenVehiclePosition) > 0;
        private _openAny = [_object, ""] call FUNC(findOpenVehiclePosition) > 0;

        if (vehicle _unit isNotEqualTo _unit) then {
            moveOut _unit;
            _unit setVelocity [0,0,0];
        };

        if (alive _object && _object isKindOf "AllVehicles" && _openAny) then {            
            switch true do {
                case _openCargo: {_unit moveInCargo _object};
                case _openCommander: {_unit moveInCommander _object};
                case _openGunner: {_unit moveInGunner _object};
                case _openDriver: {_unit moveInDriver _object};
                case _openAny: {_unit moveInAny _object};
            };
        } else {
            private _pos = getPosASL _object;
            private _height = _pos select 2;

            private _posRadius = 5;
            for "_i" from 0 to 1000 do {
                private _candidate = getPosASL _object getPos [_posRadius * sqrt random 1, random 360];
                _candidate set [2, _height];

                // Find if standable surface
				private _onSurface = count (lineIntersectsSurfaces [_candidate vectorAdd [0,0,1], _candidate vectorAdd [0,0,-2], _unit, _object, true, 1, "GEOM", "NONE"]) > 0;

                // Find if in building
                private _inBuilding = count ((lineIntersectsSurfaces [_candidate vectorAdd [0,0,1], _candidate vectorAdd [0,0,50], _unit, _object, true, 1, "GEOM", "NONE"] apply {_x select 3}) select {_x isKindOf "House"}) > 0;

                // Find if near an object
                private _nearToTerrainObjects = count (nearestTerrainObjects [_candidate, [], 3, false, false]) > 0;
                private _nearToObjects = count (_candidate nearObjects 3) > 0;

                if !(_onSurface) then {continue};

                switch true do {
                    case (_inBuilding): {
                        private _nearWallsX = count (lineIntersectsSurfaces [_candidate vectorAdd [-5,0,1], _candidate vectorAdd [5,0,1], _unit, _object, true, 1, "GEOM", "NONE"]) > 0;
                        private _nearWallsY = count (lineIntersectsSurfaces [_candidate vectorAdd [0,-5,1], _candidate vectorAdd [0,5,1], _unit, _object, true, 1, "GEOM", "NONE"]) > 0;

                        if (_nearWallsX || _nearWallsY) then {
                            TRACE_1("MEH_Teleporter:: Position In Building Too Close To Walls: %1", _candidate);
                            continue;
                        } else {
                            TRACE_1("MEH_Teleporter:: Position In Building Found: %1", _candidate);
                            _pos = _candidate; break
                        };
                    };
                    case (!_nearToTerrainObjects && !_nearToObjects): {
                        TRACE_1("MEH_Teleporter:: Position Outside Found: %1", _candidate);
                        _pos = _candidate; break
                    };
                };
            };

            _unit setPosASL _pos;
            _unit setDir (getDir _unit + (_unit getRelDir _object));

            [QGVAR(teleportedUnit), [_unit, _pos]] call CBA_fnc_globalEvent;
        };

        if (_object isKindOf "AllVehicles") then {
            // Remove a traveler
            private _travelers = _object getVariable [QGVAR(currentTravelers), []];
            _travelers = _travelers - [player];
            _object setVariable [QGVAR(currentTravelers), _travelers, true];

            // Update all open teleport menus
            if (([_object, ""] call FUNC(findOpenVehiclePosition)) - count _travelers > 0) then {
                [QGVAR(updatelbColor), [_object, "green"]] call CBA_fnc_globalEvent;
            };
        };
        
        [QGVAR(hideObjectForTeleport), [_unit, false]] call CBA_fnc_localEvent;

        // Fade screen in
        private _layer = uiNamespace getVariable QGVAR(blankScreen);
        _layer cutText [
            LLSTRING(teleportedNotification),
            "BLACK IN", 3, true, true
        ];
    }, [_unit, _object, _travelTime], _travelTime] call CBA_fnc_waitAndExecute;
}, [_unit, _object, _travelTime], 4] call CBA_fnc_waitAndExecute;
