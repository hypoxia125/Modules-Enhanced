[img]https://i.imgur.com/NrstAKw.gif[/img]

[h1]Current Version - v1.0.0[/h1]

[h2]With the v1.0.0 Release, this means that all previous versions are now incompatible with this version. Update your mods and missions ASAP! Check all your modules and make sure they have the settings you want.[/h2]

[url=https://github.com/hypoxia125/Modules-Enhanced/wiki]Module Documentation[/url]

[h1]Description[/h1]

Modules Enhanced is an editor extension that seeks to provide useful new modules to the 3DEN editor as well as potentially fix/recreate broken/inconsistent/outdated vanilla Arma 3 modules.

[h2]Features[/h2]
- Many new modules ranging from ambient artillery and paradropping vehicles to trapping inventories and creating mine jammers.
- Utilizes CBA's event system and per frame handlers.
- All module functions have a public version that mission makers can execute mid mission, without a module, using scripting!

... for a full list, visit the [url=https://github.com/hypoxia125/Modules-Enhanced/wiki]Wiki[/url]

[h2]Under The Hood[/h2]
- Modules create dependency. All clients must have the mod.
- No scheduled scripts. All code is in unscheduled space using CBA's frame system. This makes sure that code is executed exactly when its needed.
- CBA's event system instead of remoteExec.
- CBA's system allows for easy hooks into this mod. Other mod makers have an easier time adding their mods on top of mine.

[h2]Have A Module You Want Added? Want To Help Contribute?[/h2]

Visit the [url=https://github.com/hypoxia125/Modules-Enhanced/issues]GitHub Issues Page[/url] and put in a request. I'm always looking for additional things to add.

[h2]Current Module List[/h2]

[table]  
    [tr]  
        [td]Ambient Artillery (Virtual)[/td]  
        [td]Anti-Troll[/td]  
        [td]Change Flag[/td]  
    [/tr]  
    [tr]  
        [td]Create Minefield[/td]  
        [td]Create Paradrop Troop Transport[/td]  
        [td]Delete BI Respawn Position[/td]  
    [/tr]  
    [tr]  
        [td]Effect - Fire[/td]  
        [td]Effect - Flare Launcher[/td]  
        [td]Effect - Lightpoint[/td]  
    [/tr]  
    [tr]  
        [td]Effect - Smoke[/td]  
        [td]Enable/Disable Gun Lights[/td]  
        [td]Healing Area[/td]  
    [/tr]  
    [tr]  
        [td]Lightning Storm[/td]  
        [td]Move On Combat[/td]  
        [td]Multiplayer Sync[/td]  
    [/tr]  
    [tr]  
        [td]Paradrop Vehicle/Crate[/td]  
        [td]Register Teleporter[/td]  
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

For an explaination on what these modules do and how to use them, visit the [url=https://github.com/hypoxia125/Modules-Enhanced/wiki]Wiki[/url]

[h3]Other Mods[/h3]
Want these flares for your weapons? Check out [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3364788586]Colorful Flares[/url]

[h3]Contact Me:[/h3]
Message Me On Discord: [b]hypoxic[/b]
For Scripting/Modding Help:
- Visit [url=https://discord.gg/arma]Official Arma Discord[/url]
- Ping Me [b]@hypoxic[/b] in the [b]#arma3_scripting[/b] channel

[h3]Want Help Organizing Your Group Roles During An OP?[/h3]
Check out [url=https://hypoxia125.github.io/ArmaSquadGenerator/]Arma Squad Generator[/url]

[h3]In Development[/h3]
Communication Jammer
- Due to its complexity at the time of original write, I am rewriting this module. It has been disabled until then.