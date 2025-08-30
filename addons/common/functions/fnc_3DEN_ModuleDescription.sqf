params ["_ctrlAttribute", "_config"];

private _ctrlText = (_ctrlAttribute controlsGroupCtrl 101) controlsGroupCtrl 100;

private _cfgHeirarchy = confighierarchy _config;
private _cfgVehicleBase = _cfgHeirarchy select (count _cfgHeirarchy - 3);
private _cfgModuleBase = _cfgVehicleBase >> "ModuleDescription";
private _cfgModuleCore = configFile >> "CfgVehicles" >> "Module_F" >> "ModuleDescription";
private _cfgVehicle = _cfgVehicleBase;
private _cfgModule = _cfgVehicle >> "ModuleDescription";

private _descriptionRaw = [_cfgModule >> "description"] call bis_fnc_returnConfigEntry;
if (isnil {_descriptionRaw}) then {
    _descriptionRaw = [_cfgVehicle >> "moduledescription" >> "description",nil,""] call bis_fnc_returnConfigEntry;
};
private _description = "";
switch (typename _descriptionRaw) do {
    case (typename []): {{_description = _description + _x + "<br />";} foreach _descriptionRaw;};
    case (typename ""): {_description = _descriptionRaw;};
    case (typename 00): {_description = "";};
};
if (_description != "") then {_description = _description + "<br />"};
_description = format [
    "<t size='1'>%1<br />%2</t>",
    _description,
    "Additional Irrelevant/Buggy Information Removed By Modules Enhanced"
];

_ctrlText ctrlsetstructuredtext parsetext _description;

//--- Resize text area
_controlPos = ctrlposition _ctrlText;
_controlPos set [3,(_controlPos select 3) max (ctrltextheight _ctrlText)];
_ctrlText ctrlsetposition _controlPos;
_ctrlText ctrlcommit 0;
