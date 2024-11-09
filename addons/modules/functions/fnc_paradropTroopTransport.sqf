#include "script_component.hpp"

params [
    ["_vehicles", [], [[]]],
    ["_chuteOpenHeight", 100, [-1]],
    ["_chuteType", "Steerable_Parachute_F", [""]],
    ["_trailingSmoke", 0, [-1]]
];

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
    [{
        alive player
    }, {
        params ["_chuteOpenHeight", "_chuteType", "_trailingSmoke", "_paradrop"];

        private _handle = player addAction [
            "Paradrop",
            {
                params ["_target", "_caller", "_actionID", "_args"];
                _args params ["_chuteOpenHeight", "_chuteType", "_trailingSmoke", "_paradrop"];

                private _leader = leader group _caller;

                if (_leader == _caller) then {
                    units group _caller apply {
                        [_x, _chuteOpenHeight, _chuteType, _trailingSmoke] call _paradrop;
                    };

                };
            },
            [_chuteOpenHeight, _chuteType, _trailingSmoke, _paradrop],
            0,
            false,
            true,
            "",
            toString {_target getVariable ["meh_modules_paradropTroopTransport_Enabled", false] && _this in _target && leader group _this == _this},
            -1,
            false,
            "",
            ""
        ];
    }, [_chuteOpenHeight, _chuteType, _trailingSmoke, _paradrop], 60, {}] call CBA_fnc_waitUntilAndExecute;
};
