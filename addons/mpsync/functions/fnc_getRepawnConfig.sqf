#include "script_component.hpp"

private _respawnOnStart = getNumber (missionConfigFile >> "respawnOnStart");
if (isNil QUOTE(_respawnOnStart)) then {_respawnOnStart = 0};

