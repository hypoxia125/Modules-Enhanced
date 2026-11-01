/* Internal helper: find locations of selected types inside an Arma area. */
#include "script_component.hpp"

params ["_area", "_types"];
_area params ["_center", "_a", "_b"];

nearestLocations [_center, _types, _a max _b] select {(locationPosition _x) inArea _area}
