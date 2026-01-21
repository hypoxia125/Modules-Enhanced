/*
    For use with ModuleChangeFlag

    Author: Hypoxic
    Public: No
*/

#include "script_component.hpp"

params ["_module"];

private _synced = synchronizedObjects _module;
private _flags = _synced select { _x isKindOf "FlagCarrier" };

_flags