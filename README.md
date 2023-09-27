# Modules-Enhanced
Modules Enhanced is a modification that introduces helpful modules for mission editors,
along with improvements to modules created by BI.

## Modules Added

### Delete Respawn Position
Deletes the respawn that is created by the vanilla "Respawn Position" module.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Yes | Yes | Module(s) | Multiplayer |

### Enable/Disable Gun Lights
Changes/forces synchronized groups' flashlights. Can force add a flashlight classname if desired.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional | Yes | Module(s) | Modules Enhanced |

### Move On Combat
Keeps units on position until they enter combat. Can add an optional delay to the movement after entering combat.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| No | Yes | Group Leaders | Modules Enhanced |

### Paradrop Vehicle/Crate
Paradrops a vehicle or crate at customized height. If vehicle, crew can be customized
with additional parameters and/or code.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional (Suggest: Yes) | N/A | N/A | Modules Enhanced |

### Speed Limiter
Limits the speed of a vehicle for players, AI, or both.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) | Modules Enhanced |

### Vehicle Mine Jammer
Turns a vehicle into a mine jammer that disables mines based on distance.
Has the option to destroy mines when jammed.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) | Modules Enhanced |

### Vehicle Rearm
Rearms a vehicle with a repeatable option. If repeating, choose a time delay before rearms.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) | Modules Enhanced |

### Vehicle Refuel
Refuels a vehicle with a repeatable option. If repeating, choose a time delay before refuels.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type | Editor Tab |
| :-----: | :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) | Modules Enhanced |

## Contributing
### Contribution Guidelines
#### File Formatting:

##### General

- Indent: 4 Spaces
- Style: [K&R Style](https://en.wikipedia.org/wiki/Indentation_style#K&R_style)
- Leave one empty line at the end of files
- Use [CBA Macros](https://github.com/CBATeam/CBA_A3/blob/master/addons/main/script_macros_common.hpp)
- Use CBA event system with CBA preInit to issue local/server/global commands - do not use remoteExec

##### cpp \| hpp \| inc \| arma header

- PascalCase + snake_case: MyClassNameHere_01

##### SQF

- camelCase + snake_case: myVariableNameHere_01
