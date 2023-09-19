#include "script_component.hpp"

params [
    ["_vehicle", objNull, [objNull]],
    ["_toCopy", objNull, [objNull, ""]]
];

if (!isServer) exitWith {};

// Verify params
if (isNull _toCopy || _toCopy isEqualTo "") exitWith {};
if ([_vehicle, _toCopy] findIf {_x isEqualTo "CAManBase"} != -1) exitWith {
    ERROR_MSG_1("%1\nYou cannot copy the inventory to/from a Man entity.\nPlease use a vehicle like the function name states.",QFUNC(copyVehicleInventory));
};

switch true do {
    case (_toCopy isEqualType objNull): {
        itemCargo _toCopy apply {
            _vehicle addItemCargoGlobal [_x, 1];
        };
        magazineCargo _toCopy apply {
            _vehicle addMagazineCargoGlobal [_x, 1];
        };
        weaponCargo _toCopy apply {
            _vehicle addWeaponCargoGlobal [_x, 1];
        };
        backpackCargo _toCopy apply {
            _vehicle addBackpackCargoGlobal [_x, 1];
        };
    };

    case (_toCopy isEqualType ""): {
        // Items
        private _config = (configFile >> "CfgVehicles" >> _x >> "TransportItems");
        if (isClass _config) then {
            private _properties = configProperties [_config];
            _properties apply {
                private _itemCount = getNumber (configOf _x >> "count");
                private _className = getText (configOf _x >> "name");

                _vehicle addItemCargoGlobal [_className, _itemCount];
            };
        };

        // Magazines
        private _config = (configFile >> "CfgVehicles" >> _x >> "TransportMagazines");
        if (isClass _config) then {
            private _properties = configProperties [_config];
            _properties apply {
                private _itemCount = getNumber (configOf _x >> "count");
                private _className = getText (configOf _x >> "name");

                _vehicle addMagazineCargoGlobal [_className, _itemCount];
            };
        };

        // Weapons
        private _config = (configFile >> "CfgVehicles" >> _x >> "TransportWeapons");
        if (isClass _config) then {
            private _properties = configProperties [_config];
            _properties apply {
                private _itemCount = getNumber (configOf _x >> "count");
                private _className = getText (configOf _x >> "name");

                _vehicle addWeaponCargoGlobal [_className, _itemCount];
            };
        };

        // Backpacks
        private _config = (configFile >> "CfgVehicles" >> _x >> "TransportBackpacks");
        if (isClass _config) then {
            private _properties = configProperties [_config];
            _properties apply {
                private _itemCount = getNumber (configOf _x >> "count");
                private _className = getText (configOf _x >> "name");

                _vehicle addBackpackCargoGlobal [_className, _itemCount];
            };
        };
    };
};

// Return
[itemCargo _vehicle, magazineCargo _vehicle, weaponCargo _vehicle, backpackCargo _vehicle];