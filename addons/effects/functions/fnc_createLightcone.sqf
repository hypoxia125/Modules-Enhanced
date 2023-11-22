#include "script_component.hpp"

params ["_pos", "_vector", "_color", "_ambientColor", "_intensity", "_pars"];

private _lightcone = "#lightreflector" createVehicleLocal _pos;
_lightcone setLightColor _color;
_lightcone setLightAmbient _ambientColor;
_lightcone setLightIntensity _intensity;
_lightcone setLightConePars _pars;

_lightcone setVectorDirAndUp _vector;

_lightcone;
