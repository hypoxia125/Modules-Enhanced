# Modules-Enhanced
Modules Enhanced is a modification that introduces helpful modules for mission editors,
along with improvements to modules created by BI.

## Modules Added

### Delete Respawn Position
Deletes the respawn that is created by the vanilla "Respawn Position" module.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Yes | Yes | Module(s) |

### Fuel Consumption
Allows for custom fuel consumption amount at both max speed, and idle speed.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| No | Yes | Vehicle(s) |

### Move On Combat
Keeps units on position until they enter combat. Can add an optional delay to the movement after entering combat.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| No | Yes | Group Leaders |

### Paradrop Vehicle/Crate
Paradrops a vehicle or crate at customized height. If vehicle, crew can be customized
with additional parameters and/or code.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Optional (Suggest: Yes) | N/A | N/A |

### Speed Limiter
Limits the speed of a vehicle for players, AI, or both.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Optional | N/A | N/A |

### Vehicle Mine Jammer
Turns a vehicle into a mine jammer that disables mines based on distance.
Has the option to destroy mines when jammed.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Optional | N/A | N/A |

### Vehicle Rearm
Rearms a vehicle with a repeatable option. If repeating, choose a time delay before rearms.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) |

### Vehicle Refuel
Refuels a vehicle with a repeatable option. If repeating, choose a time delay before refuels.
| Trigger Activated | Sync Multiple Entities | Sync Entity Type |
| :-----: | :-----: | :-----: |
| Optional | Yes | Vehicle(s) |

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
