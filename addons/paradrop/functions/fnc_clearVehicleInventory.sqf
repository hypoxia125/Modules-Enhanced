params [
    ["_vehicle", objNull, [objNull]]
];

if (!isServer) exitWith {};

clearItemCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

// Return
true