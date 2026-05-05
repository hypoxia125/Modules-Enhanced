class MEH_ModuleCapturePointSystem: MEH_ModuleBase {
    scope = 2;
    displayName = "Capture Point System";
    icon = "a3\modules_f_curator\data\portraitobjectivesector_ca.paa";
    category = "MEH_GamemodeHelpers";

    function = QFUNC(ModuleCapturePointSystem);
    functionPriority = 1;
    isGlobal = 2;
    isTriggerActivated = 0;
    isDisposable = 0;
    is3DEN = 1;

    class Attributes: AttributesBase {
        class Debug: Checkbox {
            property = QGVAR(ModuleCapturePointSystem_Debug);
            displayName = "SystemChat Debug";
            tooltip = "Enables systemchat messages on all clients.";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class UpdateRate: Edit {
            property = QGVAR(ModuleCapturePointSystem_UpdateRate);
            displayName = "Update Rate";
            tooltip = "Rate at which the system updates all capture points (ms)";
            defaultValue = 1000;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class ScriptedEventHandlerSample {
            control = "EditCodeMulti5";
            property = QGVAR(ModuleCapturePointSystem_ScriptedEventHandlerSample);
            displayName = "Scripted Event Handler (Vanilla) Sample";
            tooltip = "Use this as a template on setting up your event. Just think of it like a normal Arma 3 event handler. Copypasta this into your code editor.";
            defaultValue = """[missionNameSpace, 'MEH_Modules_CapturePoint_OwnerChanged', {
    params ['_module', '_oldOwner', '_newOwner', '_pointLetter'];

    comment """"This example, lets kill all enemy units in the capture point that don't belong to the capturing side"""";
    comment """"Say the variable of the CreateCapturePoint module is 'CapturePoint_A'"""";

    if (_module == CapturePoint_A) then { 
        private _captureArea = _module getVariable 'ObjectArea'; 
        _captureArea = [getPosASL _module] + _captureArea; 

        { 
            private _unit = _x; 
            if (side group _unit != _newOwner) then { _unit setDamage 1 }; 
        } forEach (allUnits inAreaArray _captureArea); 
    }; 
}] call BIS_fnc_addScriptedEventHandler;""";
        };

        class CBAEventHandlerSample {
            control = "EditCodeMulti5";
            property = QGVAR(ModuleCapturePointSystem_CBAEventHandlerSample);
            displayName = "CBA Event Handler Sample";
            tooltip = "Use this as a template on setting up your event. Just think of it like a normal Arma 3 event handler. Copypasta this into your code editor.";
            defaultValue = """['MEH_Modules_CapturePoint_OwnerChanged', { 
    params ['_module', '_oldOwner', '_newOwner', '_pointLetter']; 

    comment """"This example, lets kill all enemy units in the capture point that don't belong to the capturing side"""";
    comment """"Say the variable of the CreateCapturePoint module is 'CapturePoint_A'"""";

    if (_module == CapturePoint_A) then { 
        private _captureArea = _module getVariable 'ObjectArea'; 
        _captureArea = [getPosASL _module] + _captureArea; 

        { 
            private _unit = _x; 
            if (side group _unit != _newOwner) then { _unit setDamage 1 }; 
        } forEach (allUnits inAreaArray _captureArea); 
    }; 
}] call CBA_fnc_addEventHandler;""";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Enables the capture point system. The following event will be called when the capture point changes:",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};
