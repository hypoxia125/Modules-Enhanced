#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

params ["_module", "_object", "_area"];

/* ----- Map Icon ----- */
private _display = findDisplay IDD_MISSION;
private _mapCtrl = _display displayCtrl IDC_MAP;

private _ctrlHandler = _mapCtrl ctrlAddEventHandler ["Draw", {

    params ["_mapCtrl"];

    // UI Stuff
    private _mapCenter = _mapCtrl ctrlMapScreenToWorld [0.5, 0.5];
    private _screenSize = 640 * safeZoneWAbs;
    private _alpha = player getVariable [QGVAR(mapIconAlpha), 0];

    // Texture + Icon
    private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
    _mapCtrl drawIcon [_texture, [0,0,0,_alpha], _mapCenter, _screenSize, _screenSize, 0, "", 0];
}];

/* ----- Calculate Alpha ------ */
[{
    params ["_args", "_handle"];
    _args params ["_module", "_object", "_area", "_mapCtrl", "_ctrlHandler"];

    // Early exits + destruction of handlers
    if (!alive _module || !alive _object) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        _mapCtrl ctrlRemoveEventHandler ["Draw", _ctrlHandler];
    };

    // See if player is in area
    private _playerInArea = player inArea _area;
    if !(_playerInArea) exitWith {};

    // See how close player is to the area center
    private _centerDistance = player distance (_area select 0);
    private _alpha = linearConversion [0, _maxRadius, _centerDistance, 0, 1, true] min 1;

    // Set varialbe containing alpha - select the darkest value - then max of 1
    private _currentAlpha = player getVariable [QGVAR(mapIconAlpha), 0];
    private _alpha = (_alpha max _currentAlpha) min 1;
    player setVariable [QGVAR(mapIconAlpha), _alpha];

}, 0, [_module, _object, _area, _mapCtrl, _ctrlHandler]] call CBA_fnc_addPerFrameHandler;
