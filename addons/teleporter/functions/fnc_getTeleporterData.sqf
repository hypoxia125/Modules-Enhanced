#include "script_component.hpp"

params ["_target", "_value"];

_searchIndex = switch toLowerANSI _target do {
    case "name": {0};
    case "object": {1};
    case "side": {2};
    case "bidirectional": {3};
    case "traveltime": {4};
    case "active": {5};
    default {-1};
};
if (_searchIndex == -1) exitWith {};

private _index = (GVAR(teleporterData) apply {_x select _searchIndex}) find _value;
if (_index == -1) exitWith {};

GVAR(teleporterData) select _index;
