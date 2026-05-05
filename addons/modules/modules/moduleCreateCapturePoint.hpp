#define LETTER_CLASS(letter) \
    class Option_##letter { \
        name = #letter##; \
        value = #letter##; \
    };

#define ALL_LETTERS \
    LETTER_CLASS(A) \
    LETTER_CLASS(B) \
    LETTER_CLASS(C) \
    LETTER_CLASS(D) \
    LETTER_CLASS(E) \
    LETTER_CLASS(F) \
    LETTER_CLASS(G) \
    LETTER_CLASS(H) \
    LETTER_CLASS(I) \
    LETTER_CLASS(J) \
    LETTER_CLASS(K) \
    LETTER_CLASS(L) \
    LETTER_CLASS(M) \
    LETTER_CLASS(N) \
    LETTER_CLASS(O) \
    LETTER_CLASS(P) \
    LETTER_CLASS(Q) \
    LETTER_CLASS(R) \
    LETTER_CLASS(S) \
    LETTER_CLASS(T) \
    LETTER_CLASS(U) \
    LETTER_CLASS(V) \
    LETTER_CLASS(W) \
    LETTER_CLASS(X) \
    LETTER_CLASS(Y) \
    LETTER_CLASS(Z)

class MEH_ModuleCreateCapturePoint: MEH_ModuleBase {
    scope = 2;
    displayName = "Create Capture Point";
    icon = "a3\modules_f\data\portraitsector_ca.paa";
    category = "MEH_GamemodeHelpers";

    function = QFUNC(ModuleCreateCapturePoint);
    functionPriority = 1;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;
    is3DEN = 1;

    canSetArea = 1;
    canSetAreaShape = 1;
    class AttributeValues {
        size3[] = {100, 100, 100};
        isRectangle = 0;
    };

    class Attributes: AttributesBase {
        class ActiveOnStart: Checkbox {
            property = QGVAR(ModuleCreateCapturePoint_ActiveOnStart);
            displayName = "Active On Start";
            tooltip = "Capturable upon game start. You can toggle capturability by setting on the server: \n_module setVariable [MEH_Modules_CapturePoint_Active, true];\nor\n_module setVariable [MEH_Modules_CapturePoint_Active, false];";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class CaptureTime: Edit {
            property = QGVAR(ModuleCreateCapturePoint_CaptureTime);
            displayName = "Capture Time";
            tooltip = "Time (s) until point is fully captured.";
            defaultValue = 60;
            typeName = "NUMBER";
            validate = "NUMBER";
        };

        class CaptureRateMultiplier {
            control = "MEH_ModuleCreateCapturePoint_CaptureRateMultiplier";
            property = QGVAR(ModuleCreateCapturePoint_CaptureRateMultiplier);
            displayName = "Capture Rate Multiplier";
            tooltip = "Percent (0-1) to increase capture rate for every unit over one advantage.";
            expression = "_this setVariable ['%s', _value, true]";
            defaultValue = 0.10;
            typeName = "NUMBER";
        };

        class CapturePointLetter: Combo {
            property = QGVAR(ModuleCreateCapturePoint_CapturePointLetter);
            displayName = "Capture Point Letter";
            tooltip = "Letter for the capture point icon.";
            defaultValue = "'A'";
            typeName = "STRING";
            class Values {
                ALL_LETTERS
            };
        };

        class OwnerOnStart: Combo {
            property = QGVAR(ModuleCreateCapturePoint_OwnerOnStart);
            displayName = "Owner On Start";
            tooltip = "What side owns this point at mission start?";
            defaultValue = 4;
            typeName = "NUMBER";
            class Values {
                class None {
                    name = "None";
                    value = 4;
                };
                class East {
                    name = "OPFOR";
                    value = 0;
                };
                class West {
                    name = "BLUFOR";
                    value = 1;
                };
                class Indepenedent {
                    name = "GUER";
                    value = 2;
                };
                class Civilian {
                    name = "CIV";
                    value = 3;
                };
            };
        };

        class CanEastCapture: Checkbox {
            property = QGVAR(ModuleCreateCapturePoint_CanEastCapture);
            displayName = "OPFOR Can Capture";
            tooltip = "Can OPFOR forces capture this point?";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class CanWestCapture: Checkbox {
            property = QGVAR(ModuleCreateCapturePoint_CanWestCapture);
            displayName = "BLUFOR Can Capture";
            tooltip = "Can BLUFOR forces capture this point?";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class CanIndependentCapture: Checkbox {
            property = QGVAR(ModuleCreateCapturePoint_CanIndependentCapture);
            displayName = "GUER Can Capture";
            tooltip = "Can GUER forces capture this point?";
            defaultValue = "true";
            typeName = "BOOL";
        };

        class CanCivilianCapture: Checkbox {
            property = QGVAR(ModuleCreateCapturePoint_CanCivilianCapture);
            displayName = "Civilians Can Capture";
            tooltip = "Can Civilian forces capture this point?";
            defaultValue = "false";
            typeName = "BOOL";
        };

        class ModuleDescription: ModuleDescription {};
    };

    class ModuleDescription: ModuleDescription {
        description[] = {
            "Creates a capture point for the capture point system.",
            "",
            CSTRING(ModuleDescription_TriggerActivated_False),
            CSTRING(ModuleDescription_Repeatable_False)
        };
        position = 1;
        direction = 1;
    };
};