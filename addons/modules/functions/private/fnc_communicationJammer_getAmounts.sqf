#include "script_component.hpp"

private _amounts = [0];
{
    _amounts pushBack (_x getVariable [QGVAR(CommunicationJammer_JamAmount), 0]);
} forEach entities "MEH_ModuleCommunicationJammer";
_amounts
