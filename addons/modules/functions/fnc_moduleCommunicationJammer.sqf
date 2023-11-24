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

if (_mode in ["dragged3DEN", "unregisteredFromWorld3DEN"]) exitWith {};

// Variables
private _area = _module getVariable ["ObjectArea", [100, 100, 0, false, 100]];

switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!hasInterface) exitWith {};

        private _objects = synchronizedObjects _module select {!(_x isKindOf "EmptyDetector")};
        if (count _objects > 1) exitWith {};

        private _object = _objects select 0;

        // Use module if object doesn't exist
        if (isNil "_object") then {_object = _module};

        _area = [getPosATL _object] + _area;

        [_module, _object, _area] call EFUNC(communicationjammer,initCommJammer);
    };

    case "registeredToWorld3DEN": {
        // ----- Locked Object ----- //
        private _lockedObject = _module getVariable [QGVAR(communicationjammer_lockedObject), objNull];
        private _handle = _lockedObject getVariable [QGVAR(communicationjammer_lockedObject_EH), -1];

        // Reapply handler
        if !(isNull _lockedObject) then {
            private _handle = _object addEventHandler ["AttributesChanged3DEN", {
                params ["_object"];

                private _module = _object getVariable [QGVAR(communicationjammer_lockedObject), objNull];
                _module set3DENAttribute ["position", (_object get3DENAttribute "position") select 0];
            }];

            _object setvariable [QGVAR(communicationjammer_lockedObject_EH), _handle];

            TRACE_2("Reapplied locked event handler",_object,_handle);
        };
    };

    case "attributesChanged3DEN": {
        // ----- Move to Locked Object ----- //
        private _lockedObject = _module getVariable [QGVAR(communicationjammer_lockedObject), objNull];
        private _handle = _lockedObject getVariable [QGVAR(communicationjammer_lockedObject_EH), -1];

        if !(isNull _lockedObject) then {
            _module set3DENAttribute ["position", (_lockedObject get3DENAttribute "position") select 0];

            TRACE_2("Moved module position back to object",_module,_lockedObject);
        };
    };

    case "connectionChanged3DEN": {

        private _synced = get3DENConnections _module apply {_x select 1};

        // Triggers
        private _syncedTriggers = _synced select {_x isKindOf "EmptyDetector"};
        if (count _syncedTriggers > 0) then {
            [typeOf _module] call EFUNC(Error,invalidSync);
            remove3DENConnection ["Sync", [_syncedTriggers select (count _syncedTriggers - 1)], _module];
        };

        // Objects
        private _syncedObjects = _synced select {!(_x isKindOf "EmptyDetector")};
        if (count _syncedObjects > 1) then {
            [typeOf _module] call EFUNC(Error,invalidSync);
            remove3DENConnection ["Sync", [_syncedObjects select (count _syncedObjects - 1)], _module];
        };

        // ----- Lock object ----- //
        private _lockedObject = _module getVariable [QGVAR(communicationjammer_lockedObject), objNull];
        private _handle = _lockedObject getVariable [QGVAR(communicationjammer_lockedObject_EH), -1];
        
        // Remove locked object eventhandler
        if !(isNull _lockedObject) then {
            _lockedObject removeEventHandler ["AttributesChanged3DEN", _handle];
            _lockedObject setVariable [QGVAR(communicationjammer_lockedObject_EH), nil];
            _lockedObject setvariable [QGVAR(communicationjammer_lockedObject), nil];
            _module setVariable [QGVAR(communicationjammer_lockedObject), nil];

            TRACE_2("Removed locked object handler",_lockedObject,_handle);
        };

        // Add locked object eventhandler
        private _object = _syncedObjects select 0;
        if (isNil "_object") exitWith {};

        private _handle = _object addEventHandler ["AttributesChanged3DEN", {
            params ["_object"];

            private _module = _object getVariable [QGVAR(communicationjammer_lockedObject), objNull];
            _module set3DENAttribute ["position", (_object get3DENAttribute "position") select 0];
        }];
        _object setVariable [QGVAR(communicationjammer_lockedObject_EH), _handle];
        _object setVariable [QGVAR(communicationjammer_lockedObject), _module];
        _module setVariable [QGVAR(communicationjammer_lockedObject), _object];

        TRACE_2("Created locked object handler",_object,_handle);

        // Move module to object
        _module set3DENAttribute ["position", (_object get3DENAttribute "position") select 0];
    };
};