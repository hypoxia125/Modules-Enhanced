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
if !(_mode in ["init"]) exitWith {};

// Variables
//------------------------------------------------------------------------------------------------
private _applyTo = _module getVariable "ApplyTo";
private _newSideNum = _module getVariable "NewSide";
private _includePlayers = _module getVariable "IncludePlayers";

private ["_newSide"];
switch (_newSideNum) do {
    case 0: { _newSide = east };
    case 1: { _newSide = west };
    case 2: { _newSide = independent };
    case 3; { _newSide = civilian };
};

// Functions
//------------------------------------------------------------------------------------------------
private _fnc_moveUnitToNewGroup = {
    params ["_unit", "_side"];
    
    if (!_includePlayers && isPlayer _unit) exitWith {};

    private _oldGroup = group _unit;
    private _newGroup = createGroup [_side, true];
    _newGroup copyWaypoints _oldGroup;

    [_unit] joinSilent _newGroup;
    
    _newGroup
};

private _fnc_processUnits = {
    params ["_units", "_side"];
    
    {
        [_x, _side] call _fnc_moveUnitToNewGroup;
    } forEach _units;
};

private _fnc_copyAllGroupVariables = {
    params ["_oldGroup", "_newGroup"];

    {
        private _name = _x;
        private _value = _oldGroup getVariable _name;
        if (isNil "_value") then { continue };

        _newGroup setVariable [_name, _value, true];
    } forEach (allVariables _oldGroup);
};

private _fnc_getUniqueGroups = {
    params ["_units"];
    
    private _groups = [];
    {
        _groups pushBackUnique group _x;
    } forEach _units;
    
    _groups
};

private _fnc_moveGroupToNewSide = {
    params ["_group", "_side"];
    
    private _newGroup = createGroup [_side, true];
    _newGroup copyWaypoints _group;
    
    [_group, _newGroup] call _fnc_copyAllGroupVariables;

    private _units = units _group;
    if (!_includePlayers) then {
        _units = _units select { !isPlayer _x };
    };
    _units joinSilent _newGroup;
    
    _newGroup
};

private _init = {
    switch (_applyTo) do {
        case 0: { // Unit groups
            private _units = [_module, ["MAN"]] call FUNC(getSynchronizedObjectsFiltered);
            private _groups = [_units] call _fnc_getUniqueGroups;
            
            {
                [_x, _newSide] call _fnc_moveGroupToNewSide;
            } forEach _groups;
        };
        
        case 1: { // Units only
            private _units = [_module, ["MAN"]] call FUNC(getSynchronizedObjectsFiltered);
            [_units, _newSide] call _fnc_processUnits;
        };
        
        case 2: { // Everyone in trigger area
            private _triggers = [_module, ["TRIGGER"]] call FUNC(getSynchronizedObjectsFiltered);

            private _units = [];
            {
                _units = allUnits inAreaArray _x;
            } forEach _triggers;

            private _groups = [_units] call _fnc_getUniqueGroups;

            {
                [_x, _newSide] call _fnc_moveGroupToNewSide;
            } forEach _groups;
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};
        if (!_isActivated) exitWith {};

        call _init;
    };
};
