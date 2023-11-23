#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineResincl.inc"

params ["_module", "_object", "_area"];

/* ----- Create Variable To Modify ----- */
if (isNil {player getVariable QGVAR(mapIconAlphas)}) then {
    player setVariable [QGVAR(mapIconAlphas), []];
};

/* ----- Map Icon ----- */
private _display = findDisplay IDD_MAIN_MAP;
private _mapCtrl = _display displayCtrl IDC_MAP;

private _ctrlHandler = _mapCtrl ctrlAddEventHandler ["Draw", {

    params ["_mapCtrl"];
    TRACE_1("Map Control",_mapCtrl);

    // UI Stuff
    private _mapCenter = _mapCtrl ctrlMapScreenToWorld [0.5, 0.5];
    private _screenSize = 640 * safeZoneWAbs;
    private _alphas = (player getVariable [QGVAR(mapIconAlphas), []]) apply {_x select 1};
    if (_alphas isEqualTo []) exitWith {};
    _alpha = selectMax _alphas;

    TRACE_3("UI Vars",_mapCenter,_screenSize,_alpha);

    // Texture + Icon
    private _texture = "#(rgb,8,8,3)color(0,0,0,1)";
    _mapCtrl drawIcon [_texture, [1,1,1,_alpha], _mapCenter, _screenSize, _screenSize, 0, "", 0];
}];

/* ----- GPS Icon ----- */
private _display = uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull];

/* ----- Calculate Alpha ------ */
[{
    params ["_args", "_handle"];
    _args params ["_module", "_object", "_area", "_mapCtrl", "_ctrlHandler"];

    // Early exits + destruction of handlers
    if (!alive _module || !alive _object) exitWith {
        INFO_1("%1 | Module or Object Deleted - Destroying Handlers",QFUNC(initCommJammer));
        _handle call CBA_fnc_removePerFrameHandler;
        _mapCtrl ctrlRemoveEventHandler ["Draw", _ctrlHandler];

        private _data = player getVariable [QGVAR(mapIconAlphas), []];
        private _index = _data findIf {_object isEqualTo (_x select 0)};
        if (_index == -1) exitWith {};
        _data deleteAt _index;
        player setVariable [QGVAR(mapIconAlphas), _data];
    };

    // Update area + location of object
    _area set [0, getPosATL _object];
    TRACE_1("Current Area",_area);

    // See if player is in area
    private _playerInArea = player inArea _area;
    if !(_playerInArea) exitWith {};

    // See how close player is to the area center
    private _centerDistance = player distance (_area select 0);
    private _maxRadius = (_area select 1) max (_area select 2);
    private _alpha = linearConversion [_maxRadius, 0, _centerDistance, 0, 1, true] min 1;
    TRACE_1("Pre Alpha",_alpha);

    // Create data in variable or change value based on object
    private _data = player getVariable [QGVAR(mapIconAlphas), []];
    private _index = _data findIf {_object isEqualTo (_x select 0)};
    private _currentAlpha = 0;

    if (_index == -1) then {
        _data pushBackUnique [_object, _alpha];
    } else {
        (_data select _index) set [1, _alpha];
    };
    player setVariable [QGVAR(mapIconAlphas), _data];

}, 0, [_module, _object, _area, _mapCtrl, _ctrlHandler]] call CBA_fnc_addPerFrameHandler;
