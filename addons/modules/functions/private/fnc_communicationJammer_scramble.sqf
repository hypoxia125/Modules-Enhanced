#include "script_component.hpp"

params ["_text", "_jamAmount"];
private _characters = [];
for "_i" from 65 to 90 do {_characters pushBack toString [_i]};
for "_i" from 97 to 122 do {_characters pushBack toString [_i]};
for "_i" from 48 to 57 do {_characters pushBack toString [_i]};

_text = _text splitString "";
private _numBlocked = linearConversion [0, 1, _jamAmount, 0, count _text, true];
private _used = [];
if (_numBlocked > 0) then {
    for "_i" from 1 to _numBlocked do {
        private _index = round random count _text;
        if (_index in _used || {_text select _index isEqualTo " "}) then {continue};
        _text set [_index, selectRandom _characters];
        _used pushBack _index;
    };
};
_text joinString ""
