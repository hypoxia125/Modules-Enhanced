class ctrlMenuStrip;
class Display3DEN
{
    class Controls
    {
        class MenuStrip: ctrlMenuStrip {
            class Items {
                items [] += {"MEH_About"};
                class MEH_About {
                    text = CSTRING(About);
                    items[] += {
                        "MEH_About_Changelog",
                        "MEH_About_Steam",
                        "MEH_About_Contributing",
                        "MEH_About_Documentation",
                        "MEH_About_Credits",
                        "MEH_About_BugReport"
                    };
                };
                class MEH_About_Changelog {
                    text = CSTRING(About_Changelog);
                    picture = "\a3\3DEN\Data\Controls\ctrlMenu\link_ca.paa";
                    weblink = "https://github.com/hypoxia125/Modules-Enhanced/releases";
                    opensNewWindow = 1;
                };
                class MEH_About_Steam: MEH_About_Changelog {
                    text = CSTRING(About_Steam);
                    weblink = "https://steamcommunity.com/sharedfiles/filedetails/?id=3043987264";
                };
                class MEH_About_Contributing: MEH_About_Changelog {
                    text = CSTRING(About_Contributing);
                    weblink = "https://github.com/hypoxia125/Modules-Enhanced/wiki/Contribution";
                };
                class MEH_About_Documentation: MEH_About_Changelog {
                    text = CSTRING(About_Documentation);
                    weblink = "https://github.com/hypoxia125/Modules-Enhanced/wiki";
                };
                class MEH_About_Credits: MEH_About_Changelog {
                    text = CSTRING(About_Credits);
                    weblink = "https://github.com/hypoxia125/Modules-Enhanced/blob/main/CONTRIBUTORS.md";
                };
                class MEH_About_BugReport: MEH_About_Changelog {
                    text = CSTRING(About_BugReport);
                    weblink = "https://github.com/hypoxia125/Modules-Enhanced/issues";
                };
            };
        };
    };
};
