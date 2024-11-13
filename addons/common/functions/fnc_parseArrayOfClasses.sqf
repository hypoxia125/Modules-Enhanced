params ["_string"];

private _array = call compile (str (_string splitString "[]""'',"));

if (_array isEqualTypeAll "") then { _array } else { [] };