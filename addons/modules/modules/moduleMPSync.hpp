class MEH_ModuleMPSync: MEH_ModuleBase {
	scope = 2;
	displayName = CSTRING(ModuleMPSync_DisplayName);
	icon = "\a3\Modules_f\data\iconRespawn_ca.paa";
	category = "MEH";

	function = QFUNC(ModuleMPSync);
	functionPriority = 1;
	isGlobal = 2;
	isTriggerActivated = 0;
	isDisposable = 1;
	is3DEN = 1;

	class Attributes: AttributesBase
	{
		class MinPlayers: Edit {
			property = QGVAR(ModuleMPSync_MinPlayers);
			displayName = CSTRING(ModuleMPSync_MinPlayers_DisplayName);
			tooltip = CSTRING(ModuleMPSync_MinPlayers_Tooltip);
			defaultValue = 1;
			typeName = "NUMBER";
            validate = "NUMBER";
		};

		class Timeout: Edit {
			property = QGVAR(ModuleMPSync_Timeout);
			displayName = CSTRING(ModuleMPSync_Timeout_DisplayName);
			tooltip = CSTRING(ModuleMPSync_Timeout_Tooltip);
            defaultValue = 30;
			typeName = "NUMBER";
			validate = "NUMBER";
		};

        class VariableToPass: Edit {
            property = QGVAR(ModuleMPSync_VariableToPass);
            displayName = CSTRING(ModuleMPSync_VariableToPass_DisplayName);
            tooltip = CSTRING(ModuleMPSync_VariableToPass_Tooltip);
            defaultValue = """MEH_MPSync_SyncComplete""";
            typeName = "STRING";
            validate = "STRING";
        };

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] = {
            CSTRING(ModuleMPSync_ModuleDescription_Description),
            "",
            CSTRING(ModuleDescription_TriggerActivated_False)
        };
		position = 0;
        direction = 0;
	};
};
