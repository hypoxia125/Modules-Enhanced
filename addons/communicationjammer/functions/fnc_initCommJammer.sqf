#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

params ["_module", "_object", "_area"];

/* ----- Event Hook For Mods ----- */
[QGVAR(jammerCreated), _this] call CBA_fnc_localEvent;

/* ----- Create Variable To Modify ----- */
if (isNil {player getVariable QGVAR(signal_jamAmounts)}) then {
    player setVariable [QGVAR(signal_jamAmounts), []];
};

/* ----- Map Icon ----- */
private _display = findDisplay IDD_MAIN_MAP;
private _mapCtrl = _display displayCtrl IDC_MAP;

private _mapCtrlHandler = _mapCtrl ctrlAddEventHandler ["Draw", {

    params ["_mapCtrl"];

    // UI Stuff
    private _mapCenter = _mapCtrl ctrlMapScreenToWorld [0.5, 0.5];
    private _screenSize = 640 * safeZoneWAbs;
    private _alphas = (player getVariable [QGVAR(signal_jamAmounts), []]) apply {_x select 1};
    if (_alphas isEqualTo []) exitWith {};
    _alpha = selectMax _alphas;

    // Texture + Icon
    private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
    _mapCtrl drawIcon [_texture, [1,1,1,_alpha], _mapCenter, _screenSize, _screenSize, 0, "", 0];
}];

/* ----- GPS Icon ----- */
private _display = uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull];
private _miniMapControlGroup = _display displayCtrl 13301;
private _gpsCtrl = _miniMapControlGroup controlsGroupCtrl 101;

private _gpsCtrlHandler = _gpsCtrl ctrlAddEventHandler ["Draw", {

    params ["_ctrl"];

    // UI stuff
    private _center = _ctrl ctrlMapScreenToWorld (ctrlPosition _ctrl select [0,2]);
    private _size = 512;
    private _alphas = (player getVariable [QGVAR(signal_jamAmounts), []]) apply {_x select 1};
    if (_alphas isEqualTo []) exitWith {};
    _alpha = selectMax _alphas;

    // Texture + Icon
    private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
    _ctrl drawIcon [_texture, [1,1,1,_alpha], _center, _size, _size, 0, "", 0];
}];

/* ----- Calculate Alpha / Depth ------ */
[{
    params ["_args", "_handle"];
    _args params ["_module", "_object", "_area", "_mapCtrl", "_mapCtrlHandler", "_gpsCtrl", "_gpsCtrlHandler"];

    // Early exits + destruction of handlers
    if (!alive _module || !alive _object) exitWith {
        INFO_1("%1 | Module or Object Deleted - Destroying Handlers",QFUNC(initCommJammer));
        _handle call CBA_fnc_removePerFrameHandler;
        _mapCtrl ctrlRemoveEventHandler ["Draw", _mapCtrlHandler];
        _gpsCtrl ctrlRemoveEventHandler ["Draw", _gpsCtrlHandler];

        private _data = player getVariable [QGVAR(signal_jamAmounts), []];
        private _index = _data findIf {_object isEqualTo (_x select 0)};
        if (_index == -1) exitWith {};
        _data deleteAt _index;
        player setVariable [QGVAR(signal_jamAmounts), _data];
    };

    // Update area + location of object
    _area set [0, getPosATL _object];

    // See if player is in area
    private _playerInArea = player inArea _area;
    if !(_playerInArea) exitWith {
        private _data = player getVariable [QGVAR(signal_jamAmounts), []];
        private _index = _data findIf {_object isEqualTo (_x select 0)};
        if (_index == -1) exitWith {};
        _data deleteAt _index;
        player setVariable [QGVAR(signal_jamAmounts), _data];
    };

    // See how close player is to the area center
    private _centerDistance = player distance (_area select 0);
    private _maxRadius = (_area select 1) max (_area select 2);
    private _signalJam = linearConversion [_maxRadius, 0, _centerDistance, 0, 1, true] min 1;

    // Create data in variable or change value based on object
    private _data = player getVariable [QGVAR(signal_jamAmounts), []];
    private _index = _data findIf {_object isEqualTo (_x select 0)};

    if (_index == -1) then {
        _data pushBackUnique [_object, _signalJam];
    } else {
        (_data select _index) set [1, _signalJam];
    };
    player setVariable [QGVAR(signal_jamAmounts), _data];

}, 0, [_module, _object, _area, _mapCtrl, _mapCtrlHandler, _gpsCtrl, _gpsCtrlHandler]] call CBA_fnc_addPerFrameHandler;