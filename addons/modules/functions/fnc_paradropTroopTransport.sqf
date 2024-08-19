#include "script_component.hpp"

params [
    ["_vehicles", [], [[]]],
    ["_chuteOpenHeight", 100, [-1]],
    ["_chuteType", "Steerable_Parachute_F", [""]]
];

_vehicles apply {
    _x setVariable [QGVAR(ParadropTroopTransport_Enabled), true];
};

private _paradrop = {
    params ["_unit", "_chuteOpenHeight", "_chuteType"];

    _unit action ["getOut", vehicle _unit];

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
    player addAction [
        "Paradrop",
        {
            params ["_target", "_caller", "_actionID", "_args"];
            _args params ["_chuteOpenHeight", "_chuteType", "_paradrop"];

            private _leader = leader group _caller;

            if (_leader == _caller) then {
                units group _caller apply {
                    [_x, _chuteOpenHeight, _chuteType] call _paradrop;
                };
            } else {
                [_caller, _chuteOpenHeight, _chuteType] call _paradrop;
            };
        },
        [_chuteOpenHeight, _chuteType, _paradrop],
        0,
        false,
        true,
        "",
        toString {_target getVariable ["meh_modules_paradropTroopTransport_Enabled", false] && _this in _target},
        -1,
        false,
        "",
        ""
    ];
};
