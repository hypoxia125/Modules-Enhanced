#include "script_component.hpp"

// Parameters
//------------------------------------------------------------------------------------------------
params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];
_input params [
    ["_module", objNull, [objNull]],
    ["_isActivated", false, [true]],
    ["_isCuratorPlaced", false, [true]]
];

// Pre-Execution Checks
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};
if !(_mode in ["init"]) exitWith {};

LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Initializing Capture Point module: %1",_module);

// Variables
//------------------------------------------------------------------------------------------------
private _captureArea = _module getVariable "ObjectArea";
_captureArea = [getPosASL _module] + _captureArea;

private _captureTime = _module getVariable "CaptureTime";

private _captureRateMultiplier = _module getVariable "CaptureRateMultiplier";

private _ownerOnStart = sideUnknown;
switch (_module getVariable "OwnerOnStart") do {
    case 0: { _ownerOnStart = east };
    case 1: { _ownerOnStart = west };
    case 2: { _ownerOnStart = independent };
    case 3: { _ownerOnStart = civilian };
    case 4: { _ownerOnStart = sideUnknown };
    default { _ownerOnStart = sideUnknown };
};

private _canCaptureData = createHashMapFromArray [
    [east, _module getVariable "CanEastCapture"],
    [west, _module getVariable "CanWestCapture"],
    [independent, _module getVariable "CanIndependentCapture"],
    [civilian, _module getVariable "CanCivilianCapture"]
];

private _markerLetter = _module getVariable "CapturePointLetter";

// Build Object
//------------------------------------------------------------------------------------------------
private _timeOut = 10;
while { _timeOut > 0 } do {
    if (!isNil QGVAR(CapturePointSystem)) exitWith {};
    _timeOut = _timeOut - 1;
    sleep 1;
};

if (isNil QGVAR(CapturePointSystem)) then {
    ERROR_1("MEH_Modules_fnc_moduleCreateCapturePoint:: CapturePointSystem not found after waiting 10 seconds! Timeout: %1",_timeOut);
} else {
    LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: CapturePointSystem found, creating module object");
};

private _moduleObject = createHashMapObject [[
    ["#type", QGVAR(CreateCapturePoint)],
    ["#str", {str _module}],
    ["_updateRate", GVAR(CapturePointSystem) get "_updateRate"],
    ["_captureArea", _captureArea],
    ["_captureTime", _captureTime],
    ["_captureRateMultiplier", _captureRateMultiplier],
    ["_owner", _ownerOnStart],
    ["_canCaptureData", _canCaptureData],
    ["_captureProgress", createHashMapFromArray [
        [east, 0],
        [west, 0],
        [independent, 0],
        [civilian, 0]
    ]],
    ["_mapMarkers", []],
    ["_module", _module],
    ["_markerColors", createHashMapFromArray [
        [east, "ColorEast"],
        [west, "ColorWest"],
        [independent, "ColorIndependent"],
        [civilian, "ColorCivilian"],
        [sideUnknown, "ColorBlack"]
    ]],
    ["_markerLetter", _markerLetter],
    ["_smokeEmitter", nil],

    ["#create", {
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Create method called for module: %1",_self get "_module");
        
        private _owner = _self get "_owner";
        if (_owner != sideUnknown) then {
            private _captureProgress = _self get "_captureProgress";
            _captureProgress set [_owner, 1];
            LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Initial capture progress set for owner: %1",_owner);
        };

        // Create the map markers
        (_self get "_captureArea") params ["_position", "_a", "_b", "_angle", "_isRectangle", "_c"];
        LOG_3("MEH_Modules_fnc_moduleCreateCapturePoint:: Creating markers at position: %1, dimensions: %2x%3",_position,_a,_b);

        // Inner marker
        private _markerName = format [QGVAR(CapturePoint_%1_Inner), (_self get "_module")];
        private _marker = createMarker [_markerName, _position];
        _marker setMarkerBrushLocal "FDiagonal";
        if (_isRectangle) then { _marker setMarkerShapeLocal "RECTANGLE" } else { _marker setMarkerShapeLocal "ELLIPSE" };
        _marker setMarkerSizeLocal [_a, _b];
        (_self get "_mapMarkers") pushBack _marker;
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Inner marker created: %1",_markerName);
        
        // Outer marker
        _markerName = format [QGVAR(CapturePoint_%1_Outer), (_self get "_module")];
        _marker = createMarker [_markerName, _position];
        _marker setMarkerBrushLocal "Border";
        if (_isRectangle) then { _marker setMarkerShapeLocal "RECTANGLE" } else { _marker setMarkerShapeLocal "ELLIPSE" };
        _marker setMarkerSizeLocal [_a, _b];
        (_self get "_mapMarkers") pushBack _marker;
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Outer marker created: %1",_markerName);

        // Point letter marker
        _markerName = format [QGVAR(CapturePoint_%1_Letter), (_self get "_module")];
        _marker = createMarker [_markerName, _position];
        _marker setMarkerShapeLocal "Icon";
        _marker setMarkerTypeLocal (_self call ["GetMarkerLetter", [_self get "_markerLetter"]]);
        (_self get "_mapMarkers") pushBack _marker;
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Letter marker created: %1",_markerName);

        {
            _x setMarkerColor ((_self get "_markerColors") get _owner);
        } forEach (_self get "_mapMarkers");
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Marker colors set for owner: %1",_owner);
    }],

    ["#delete", {
        private _mapMarkers = _self get "_mapMarkers";
        {
            deleteMarker _x;
        } forEach _mapMarkers;
    }],

    ["Update", {
        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Updating point...");

        // Change marker if its not active
        private _module = _self get "_module";

        private _markers = _self get "_mapMarkers";
        private _marker = _markers # 2;
        if !(_module getVariable [QGVAR(CapturePoint_Active), true]) exitWith {
            _marker setMarkerType "mil_objective";
        };

        if (getMarkerType _marker != (_self call ["GetMarkerLetter", [_self get "_markerLetter"]])) then {
            _marker setMarkerType (_self call ["GetMarkerLetter", [_self get "_markerLetter"]]);
        };            

        _self call ["UpdateCaptureOwner"];
        _self call ["UpdateCaptureNoOwner"];

        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Updating point completed.");
    }],

    ["GetMarkerLetter", {
        params ["_letter"];
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Getting marker letter for: %1",_letter);
        format ["loc_Letter%1", _letter];
    }],

    ["UpdateMarkerColors", {
        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Updating all marker colors...");

        private _owner = _self get "_owner";
        private _markers = _self get "_mapMarkers";
        LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Updating %1 markers for owner: %2",count _markers,_owner);
        {
            private _marker = _x;
            _x setMarkerColor (_self get "_markerColors" get _owner);
        } forEach _markers;
        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Marker colors update completed");
    }],

    ["GetSideUnitsInArea", {
        params ["_side"];
        private _captureArea = _self get "_captureArea";
        private _count = { alive _x && {_x inArea _captureArea}} count units _side;
        LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Side %1 has %2 units in area",_side,_count);
        _count;
    }],

    ["GetCaptureRateMultiplier", {
        params ["_side", "_captureUnits"];

        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Finding capture rate multiplier for side: %1",_side);
        
        private _sideCount = _captureUnits get _side;
        private _multiplierSetting = _self get "_captureRateMultiplier";
        
        // Base multiplier starts at 1.0
        private _result = 1.0;
        
        // If you have at least 1 unit, apply bonus based on unit count
        // 1 unit = no bonus (0 * multiplierSetting)
        // 2 units = 1 * multiplierSetting bonus
        // 3 units = 2 * multiplierSetting bonus, etc.
        if (_sideCount > 0) then {
            private _bonus = ((_sideCount - 1) * _multiplierSetting) min 1.0;
            _result = 1.0 + _bonus;
            LOG_3("MEH_Modules_fnc_moduleCreateCapturePoint:: Side %1 - Count: %2, Bonus: %3",_side,_sideCount,_bonus);
        };
        
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Final multiplier: %1",_result);
        _result;
    }],

    ["GetCaptureUnits", {
        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Getting all units from every side inside of point...");

        private _hash = createHashMapFromArray [
            [east, _self call ["GetSideUnitsInArea", [east]]],
            [west, _self call ["GetSideUnitsInArea", [west]]],
            [independent, _self call ["GetSideUnitsInArea", [independent]]],
            [civilian, _self call ["GetSideUnitsInArea", [civilian]]]
        ];

        LOG_4("MEH_Modules_fnc_moduleCreateCapturePoint:: Unit counts - East: %1, West: %2, Independent: %3, Civilian: %4",_hash get east,_hash get west,_hash get independent,_hash get civilian);
        
        // return
        _hash;
    }],

    ["FindLeadingSide", {
        params ["_captureUnits"];

        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Finding leader side...");
        
        private _sides = [east, west, independent, civilian];
        private _leadingSide = sideUnknown;
        private _highestCount = _captureUnits getOrDefault [_leadingSide, 0];
        
        {
            private _currentCount = _captureUnits get _x;
            if (_currentCount > _highestCount) then {
                _highestCount = _currentCount;
                _leadingSide = _x;
            };
        } forEach _sides;
        
        LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Leading side: %1 with %2 units",_leadingSide,_highestCount);
        [_leadingSide, _highestCount, _sides];
    }],

    ["IsTie", {
        params ["_captureUnits", "_leadingSide", "_highestCount", "_sides"];

        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Seeing if there is a tie...");
        
        private _isTie = false;
        {
            if (_x != _leadingSide && {(_captureUnits get _x) == _highestCount}) exitWith { 
                _isTie = true 
            };
        } forEach _sides;
        
        if (_isTie) then {
            LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Tie detected!");
        } else {
            LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: No tie, clear leader");
        };
        _isTie;
    }],

    ["DecayAllSides", {
        params ["_captureProgress", "_sides", "_progressPerTick"];

        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Decaying all sides by: %1",_progressPerTick);
        
        {
            private _oldValue = _captureProgress get _x;
            private _value = 0 max (_oldValue - _progressPerTick);
            _captureProgress set [_x, _value];
            LOG_3("MEH_Modules_fnc_moduleCreateCapturePoint:: Side %1 decayed from %2 to %3",_x,_oldValue,_value);
        } forEach _sides;
    }],

    ["IncrementLeaderAndDecayOthers", {
        params ["_captureProgress", "_sides", "_leadingSide", "_captureUnits", "_progressPerTick"];

        LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Incrementing leader (%1) and decaying other values by: %2",_leadingSide,_progressPerTick);
        
        // Increment leader
        private _multi = _self call ["GetCaptureRateMultiplier", [_leadingSide, _captureUnits]];
        private _oldLeaderValue = _captureProgress get _leadingSide;
        private _value = 1 min (_oldLeaderValue + (_progressPerTick * _multi));
        _captureProgress set [_leadingSide, _value];
        LOG_4("MEH_Modules_fnc_moduleCreateCapturePoint:: Leader %1 increased from %2 to %3 (multiplier: %4)",_leadingSide,_oldLeaderValue,_value,_multi);
        
        // Decay others
        {
            if (_x != _leadingSide) then {
                private _oldValue = _captureProgress get _x;
                private _decayValue = 0 max (_oldValue - _progressPerTick);
                _captureProgress set [_x, _decayValue];
                LOG_3("MEH_Modules_fnc_moduleCreateCapturePoint:: Side %1 decayed from %2 to %3",_x,_oldValue,_decayValue);
            };
        } forEach _sides;
    }],

    ["CheckAndUpdateOwnership", {
        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Updating point ownership...");

        private _captureProgress = _self get "_captureProgress";
        private _currentOwner = _self get "_owner";
        private _capturingSide = sideUnknown;
        private _highestProgress = 0;
        private _hasCaptureValue = false;
        
        // Find side with highest progress (capturing side)
        {
            private _progress = _captureProgress get _x;
            LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Side %1 progress: %2",_x,_progress);
            if (_progress > _highestProgress) then {
                _highestProgress = _progress;
                if (_progress > 0) then {
                    _capturingSide = _x;
                };
            };
            
            if (_progress > 0) then { _hasCaptureValue = true };
        } forEach [east, west, independent, civilian];
        
        // Check if any side has reached 100% (new actual owner)
        private _newOwner = sideUnknown;
        if (_highestProgress >= 1) then {
            _newOwner = _capturingSide;
        };
        
        // Transfer ownership if fully captured
        if (_newOwner != sideUnknown) then {
            if (_newOwner != _currentOwner) then {
                LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Ownership changing from %1 to %2",_currentOwner,_newOwner);
                _self set ["_owner", _newOwner];
                _self call ["UpdateMarkerColors"];
                
                // Reset progress after capture
                {
                    _captureProgress set [_x, 0];
                } forEach [east, west, independent, civilian];
                _captureProgress set [_newOwner, 1];
                
                // Fire events for full capture
                LOG_2("MEH_Modules_fnc_moduleCreateCapturePoint:: Firing owner changed events: %1 -> %2",_currentOwner,_newOwner);
                [missionNamespace, QGVAR(CapturePoint_OwnerChanged), [_self get "_module", _currentOwner, _newOwner]] call BIS_fnc_callScriptedEventHandler;
                [QGVAR(CapturePoint_OwnerChanged), [_self get "_module", _currentOwner, _newOwner]] call CBA_fnc_globalEvent;
            };
        } else {
            // No side has reached 100%
            // Reset to neutral if no capture value exists
            if (!_hasCaptureValue && {_currentOwner != sideUnknown}) then {
                LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Resetting to neutral (no capture value), previous owner: %1",_currentOwner);
                _self set ["_owner", sideUnknown];
                _self call ["UpdateMarkerColors"];
                
                // Fire events for neutral reset
                LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Firing owner changed events: %1 -> sideUnknown",_currentOwner);
                [missionNamespace, QGVAR(CapturePoint_OwnerChanged), [_self get "_module", _currentOwner, sideUnknown]] call BIS_fnc_callScriptedEventHandler;
                [QGVAR(CapturePoint_OwnerChanged), [_self get "_module", _currentOwner, sideUnknown]] call CBA_fnc_globalEvent;
            };
        };
    }],

    ["UpdateCaptureOwner", {
        private _owner = _self get "_owner";
        if (_owner == sideUnknown) exitWith {};

        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Point has an owner (%1). Updating based on that...",_owner);

        private _captureUnits = _self call ["GetCaptureUnits"];
        private _ownerUnitCount = _captureUnits get _owner;
        
        // Sum all enemy side counts and track strongest enemy
        private _enemyUnitCount = 0;
        private _strongestEnemySide = _owner;
        private _strongestEnemyCount = 0;
        {
            if (_x != _owner) then {
                private _count = _captureUnits get _x;
                _enemyUnitCount = _enemyUnitCount + _count;
                if (_count > _strongestEnemyCount) then {
                    _strongestEnemyCount = _count;
                    _strongestEnemySide = _x;
                };
            };
        } forEach [east, west, independent, civilian];
        
        private _captureProgress = _self get "_captureProgress";
        private _baseProgressPerTick = (_self get "_updateRate") / ((_self get "_captureTime") * 2);

        private _hasAdvantage = _ownerUnitCount > _enemyUnitCount;
        private _isStalemate = _ownerUnitCount == _enemyUnitCount;
        
        LOG_4("MEH_Modules_fnc_moduleCreateCapturePoint:: Owner: %1 units, Enemy: %2 units, Advantage: %3, Stalemate: %4",_ownerUnitCount,_enemyUnitCount,_hasAdvantage,_isStalemate);

        if (_hasAdvantage) then {
            // Owner has more units - gain progress
            private _multi = _self call ["GetCaptureRateMultiplier", [_owner, _captureUnits]];
            private _progressPerTick = _baseProgressPerTick * _multi;
            private _oldValue = _captureProgress get _owner;
            private _value = 1 min (_oldValue + _progressPerTick);
            _captureProgress set [_owner, _value];
            LOG_3("MEH_Modules_fnc_moduleCreateCapturePoint:: Progress increased: %1 -> %2 (multiplier: %3)",_oldValue,_value,_multi);
        } else {
            if (!_isStalemate && {_enemyUnitCount > 0}) then {
                // Owner has fewer units than enemies - lose progress based on strongest enemy's multiplier
                private _decayMulti = _self call ["GetCaptureRateMultiplier", [_strongestEnemySide, _captureUnits]];
                private _progressPerTick = _baseProgressPerTick * _decayMulti;
                private _oldValue = _captureProgress get _owner;
                private _value = 0 max (_oldValue - _progressPerTick);
                _captureProgress set [_owner, _value];
                LOG_4("MEH_Modules_fnc_moduleCreateCapturePoint:: Progress decreased: %1 -> %2 (decay multiplier: %3 from side %4)",_oldValue,_value,_decayMulti,_strongestEnemySide);
            } else {
                if (_isStalemate) then {
                    LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Stalemate - equal units, progress unchanged");
                } else {
                    LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: No enemies present, progress unchanged");
                };
            };
        };

        // Check for ownership changes after updating progress
        _self call ["CheckAndUpdateOwnership"];
    }],
    
    ["UpdateCaptureNoOwner", {
        private _owner = _self get "_owner";
        if (_owner != sideUnknown) exitWith {};

        LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Point has NO owner. Updating based on that...");

        private _progressPerTick = (_self get "_updateRate") / ((_self get "_captureTime") * 2);
        private _captureProgress = _self get "_captureProgress";
        private _captureUnits = _self call ["GetCaptureUnits"];
        
        private _totalUnits = (_captureUnits get east) + (_captureUnits get west) + (_captureUnits get independent) + (_captureUnits get civilian);
        LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Total units in area: %1",_totalUnits);

        // If no units, decay everything
        if (_totalUnits == 0) exitWith {
            LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: No units in area, decaying all sides");
            private _sides = [east, west, independent, civilian];
            _self call ["DecayAllSides", [_captureProgress, _sides, _progressPerTick]];
            _self call ["CheckAndUpdateOwnership"];
        };
        
        // Find leading side
        private _result = _self call ["FindLeadingSide", [_captureUnits]];
        _result params ["_leadingSide", "_highestCount", "_sides"];
        
        // Check for tie
        private _isTie = _self call ["IsTie", [_captureUnits, _leadingSide, _highestCount, _sides]];
        
        // If no tie, increment leader and decay others
        if (!_isTie) then {
            _self call ["IncrementLeaderAndDecayOthers", [_captureProgress, _sides, _leadingSide, _captureUnits, _progressPerTick]];
        } else {
            LOG("MEH_Modules_fnc_moduleCreateCapturePoint:: Tie detected - no side progresses");
        };
        // If tie, do nothing (no side progresses)

        // Check for ownership changes
        _self call ["CheckAndUpdateOwnership"];
    }]
]];
_module setVariable [QGVAR(CreateCapturePoint_ModuleObject), _moduleObject];

// Add to System
//------------------------------------------------------------------------------------------------
if (!isServer) exitWith {};

if (!isNil QGVAR(CapturePointSystem)) then {
    if (!_isActivated) exitWith {
        GVAR(CapturePointSystem) call ["Unregister", _module];
        _moduleObject call ["#delete"];
        _module setVariable [QGVAR(CreateCapturePoint_ModuleObject), nil];
    };

    LOG_1("MEH_Modules_fnc_moduleCreateCapturePoint:: Registering module %1 with CapturePointSystem",_module);

    GVAR(CapturePointSystem) call ["Register", _module];
} else {
    ERROR("MEH_Modules_fnc_moduleCreateCapturePoint:: CapturePointSystem not found, cannot register module!");
};