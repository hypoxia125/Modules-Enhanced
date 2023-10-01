#include "script_component.hpp"

params ["_target", "_caller"];

// If inventory is a man, only show if the man is dead
if (typeOf _target isKindOf "CAManBase" && alive _target) exitWith {false};

/*-----Distance Calcualation-----*/

private _boundingBox = boundingBoxReal _target;
_boundingBox params ["_min", "_max"];

// find bounding box center
private _boundingX = abs ((_min select 0) max (_max select 0));
private _boundingY = abs ((_min select 1) max (_max select 1));
private _boundingZ = abs ((_min select 2) max (_max select 2));

// create area around box for later use + make it slightly bigger
private _center = ASLToAGL (getPosASL _target);
private _area = [_center, _boundingX + 2, _boundingY + 2, getdir _target, true, _boundingZ + 2];

if (!(_caller inArea _area)) exitWith {false};

/*----- Execute -----*/

private _data = _target getVariable QGVAR(TrapInventory_Data);
if (isNil QUOTE(_data)) exitWith {false};

private _canDisable = _data select 2;
private _isActive = _data select 4;

if (!_isActive) exitWith {false};

private _isSpecialist = _caller getUnitTrait "explosiveSpecialist";
private _hasEquipment = (
    items _caller findIf {_x in ["ToolKit", "ACE_DefusalKit"]} != -1 &&
    items _caller findIf {_x in ["MineDetector"]} != -1
);

TRACE_4("Variables", _canDisable, _isActive, _isSpecialist, _hasEquipment);

private _return = switch _canDisable do {
    case 0: {false};
    case 1: {true};
    case 2: {_hasEquipment};
    case 3: {_isSpecialist && _hasEquipment};
};

_return;
