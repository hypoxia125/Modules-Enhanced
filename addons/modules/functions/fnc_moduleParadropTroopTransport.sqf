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

// Variables
//------------------------------------------------------------------------------------------------
private _chuteOpenHeight = _module getVariable "ChuteOpenHeight";
private _chuteType = _module getVariable "ChuteType";
private _trailingSmoke = _module getVariable "TrailingSmoke";
private _vehicles = synchronizedObjects _module select {_x isKindOf "Air"};

_chuteType = ["NonSteerable_Parachute_F", "Steerable_Parachute_F"] select (_chuteType == 0);

// Functions
//------------------------------------------------------------------------------------------------
private _paradrop = {
    params ["_unit", "_chuteOpenHeight", "_chuteType", "_trailingSmoke"];

    _unit action ["getOut", vehicle _unit];

    // create trailing smoke
    private _smokeColor = switch (side group _unit) do {
        case west: {"SmokeShellBlue"};
        case east: {"SmokeShellRed"};
        case independent: {"SmokeShellGreen"};
    };

    private _smoke = objNull;
    switch _trailingSmoke do {
        case 0: {};
        case 1: {
            if (leader group _unit == _unit) then {
                _smoke = createVehicle [_smokeColor, getPosASL _unit, [], 0, "NONE"];
            };
        };
        case 2: {
            _smoke = createVehicle [_smokeColor, getPosASL _unit, [], 0, "NONE"];
        };
    };

    if (!isNull _smoke) then {
        _smoke attachTo [_unit, [0,0,0], "rightleg"];
    };

    [{
        params ["_unit", "_chuteOpenHeight"];

        ASLToAGL getPosASL _unit # 2 <= _chuteOpenHeight
    }, {
        params ["_unit", "_chuteOpenHeight", "_chuteType"];

        private _chute = createVehicle [_chuteType, getPosASL _unit, [], 0, "NONE"];
        _unit moveInAny _chute;
    }, [_unit, _chuteOpenHeight, _chuteType], 5*60, {}] call CBA_fnc_waitUntilAndExecute;
};

private _execute = {
    params ["_vehicles", "_chuteOpenHeight", "_chuteType", "_trailingSmoke", "_paradrop"];

    _vehicles apply {
        _x setVariable [QGVAR(ParadropTroopTransport_Enabled), true];
    };

    private _paradrop = {
        params ["_unit", "_chuteOpenHeight", "_chuteType", "_trailingSmoke"];

        _unit action ["getOut", vehicle _unit];

        // create trailing smoke
        private _smokeColor = switch (side group _unit) do {
            case west: {"SmokeShellBlue"};
            case east: {"SmokeShellRed"};
            case independent: {"SmokeShellGreen"};
        };

        private _smoke = objNull;
        switch _trailingSmoke do {
            case 0: {};
            case 1: {
                if (leader group _unit == _unit) then {
                    _smoke = createVehicle [_smokeColor, getPosASL _unit, [], 0, "NONE"];
                };
            };
            case 2: {
                _smoke = createVehicle [_smokeColor, getPosASL _unit, [], 0, "NONE"];
            };
        };
        if (_smoke isNotEqualTo objNull) then {
            _smoke attachTo [_unit, [0,0,0], "rightleg"];
        };

        [{
            params ["_unit", "_chuteOpenHeight"];

            ASLToAGL getPosASL _unit # 2 <= _chuteOpenHeight
        }, {
            params ["_unit", "_chuteOpenHeight", "_chuteType"];

            private _chute = createVehicle [_chuteType, getPosASL _unit, [], 0, "NONE"];
            _unit moveInAny _chute;
        }, [_unit, _chuteOpenHeight, _chuteType], 5*60, {}] call CBA_fnc_waitUntilAndExecute;
    };

    if (hasInterface) then {
        _vehicles apply {
            _x setVariable [QGVAR(ParadropTroopTransport_chuteOpenHeight), _chuteOpenHeight];
        };

        _vehicles apply {
            private _vehicle = _x;

            _vehicle addAction [
                "Paradrop",
                {
                    params ["_target", "_caller", "_actionID", "_args"];
                    _args params ["_chuteOpenHeight", "_chuteType", "_trailingSmoke", "_paradrop"];

                    private _leader = leader group _caller;

                    if (_leader == _caller) then {
                        units group _caller apply {
                            [_x, _chuteOpenHeight, _chuteType, _trailingSmoke] call _paradrop;
                            sleep 1;
                        };
                    };
                },
                [_chuteOpenHeight, _chuteType, _trailingSmoke, _paradrop],
                0,
                false,
                true,
                "",
                toString {
                    _this in _target &&
                    leader group _this == _this &&
                    ASLToAGL (getPosASL _this) # 2 >= _this getVariable [QGVAR(ParadropTroopTransport_chuteOpenHeight), 100]
                },
                -1,
                false,
                "",
                ""
            ];
        };
    };
};

// Code Start
//------------------------------------------------------------------------------------------------
switch _mode do {
    case "init": {
        if (is3DEN) exitWith {};

        if (_vehicles isEqualTo []) then {[typeOf _module] call EFUNC(Error,requiresSync)};
        [_vehicles, _chuteOpenHeight, _chuteType, _trailingSmoke] call _execute;
    };

    case "connectionChanged3DEN": {
        private _synced = get3DENConnections _module apply {_x select 1};
        private _invalid = _synced select {!(_x isKindOf "Air")};

        if (_invalid isNotEqualTo []) then {
            [typeOf _module] call EFUNC(Error,invalidSync);

            // remove connection=
            remove3DENConnection ["Sync", _invalid, _module];
        };
    }
}