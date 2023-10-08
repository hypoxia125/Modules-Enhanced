#include "script_component.hpp"

params [
    ["_module", objNull, [objNull]],
    ["_object", objNull, [objNull]],
    ["_isActivated", false, [true]]
];

// Variables
private _name = _module getVariable [QUOTE(Name), ""];
private _side = _module getVariable [QUOTE(Side), west];
private _bidirectional = _module getVariable [QUOTE(Bidirectional), true];
private _travelTime = _module getVariable [QUOTE(TravelTime), -1];

// Verify variables
if (isNull _object) then {_object = _module};
private _pos = getPosASL _object;

// Teleporter naming
if (_name isEqualTo "") then {
    _name = mapGridPosition _object
};

// Merge data with transporterData
if (isNil QEGVAR(teleporter,teleporterData)) then {
    EGVAR(teleporter,teleporterData) = [];
};

EGVAR(teleporter, teleporterData) pushBackUnique [_name, _pos, _side, _bidirectional, _travelTime];
publicVariable QEGVAR(teleporter, teleporterData);

// Execute the teleporter system
call EFUNC(teleporter, teleporterInit);