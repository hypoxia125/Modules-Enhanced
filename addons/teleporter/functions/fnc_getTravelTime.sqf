#include "script_component.hpp"

params ["_unit", "_destination"];

round (linearConversion [0, 1e4, _unit distance _destination, 0, 30, true]);
