[h1]Current Version - v0.2.1[/h1]

[h1]Description[/h1]

Modules Enhanced is an editor extension that seeks to provide useful new modules to the 3DEN editor as well as potentially fix/recreate broken/inconsistent/outdated vanilla Arma 3 modules.

This is currently the beta version as there are many modules still in development.

[h2]Features[/h2]
- Many new modules ranging from ambient artillery and paradropping vehicles to trapping inventories and creating mine jammers.
- Utilizes CBA's event system and per frame handlers.
- All module functions have a public version that mission makers can execute mid mission, without a module, using scripting!

... for a full list, visit the [url=https://github.com/hypoxia125/Modules-Enhanced/wiki]Wiki[/url]

[h2]Under The Hood[/h2]
- Modules create dependency. All clients must have the mod.
- No scheduled scripts. All code is in unscheduled space using CBA's frame system. This makes sure that code is executed exactly when its needed.
- CBA's event system instead of remoteExec (which can be blocked by [url=https://community.bistudio.com/wiki/Arma_3:_CfgRemoteExec]CfgRemoteExec[/url]).
- CBA's system allows for easy hooks into this mod. Other mod makers have an easier time adding their mods on top of mine.

[h2]Have A Module You Want Added?[/h2]

Visit the [url=https://github.com/hypoxia125/Modules-Enhanced/issues]GitHub Issues Page[/url] and put in a request. I'm always looking for additional things to add.

[h2]Current Module List[/h2]

[table]
    [tr]
        [td]Ambient Artillery (Virtual)[/td]
        [td]Delete BI Respawn Position[/td]
        [td]Enable/Disable Gun Lights[/td]
    [/tr]
    [tr]
        [td]Effect - Fire[/td]
        [td]Effect - Lightpoint[/td]
        [td]Effect - Smoke[/td]
    [/tr]
    [tr]
        [td]Move On Combat[/td]
        [td]Paradrop Vehicle/Crate[/td]
        [td]Speed Limiter[/td]
    [/tr]
    [tr]
        [td]Trap Inventory[/td]
        [td]Vehicle Mine Jammer[/td]
        [td]Vehicle Rearm[/td]
    [/tr]
    [tr]
        [td]Vehicle Refuel[/td]
    [/tr]
[/table]

For an explaination on what these modules do and how to use them, visit the [url=https://github.com/hypoxia125/Modules-Enhanced/wiki/Modules-List]Wiki[/url]

[h3]Contact Me:[/h3]
Message Me On Discord: [b]hypoxic[/b]
For Scripting/Modding Help:
- Visit [url=https://discord.gg/arma]Official Arma Discord[/url]
- Ping Me [b]@hypoxic[/b] in the [b]#arma3_scripting[/b] channel