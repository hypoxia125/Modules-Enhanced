#include "script_component.hpp"

params ["_pos", "_color", "_ambientColor", "_intensity", "_showDaytime", "_useFlare", "_flareSize", "_flareMaxDistance"];

private _lightpoint = "#lightpoint" createVehicle _pos;
_lightpoint setLightColor _color;
_lightpoint setLightAmbient _ambientColor;
_lightpoint setLightIntensity _intensity;
_lightpoint setLightUseFlare _useFlare;
_lightpoint setLightFlareSize _flareSize;
_lightpoint setLightFlareMaxDistance _flareMaxDistance;

_lightpoint;
