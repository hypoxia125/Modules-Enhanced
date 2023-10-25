# Ambient Artillery (Virtual)

## Description:
Creates ambient artillery at the given location without the use of entities. Can be enabled or disabled by a single repeatable trigger, or by deletion of the module.

## Module Parameters:
#### Shell Type
The classname of a CfgAmmo shell class.

Accepts: CfgAmmo Classname (Without "")

Default: Sh_82mm_AMOS

#### Salvo Size
The number of shots per salvo.

Accepts: Whole Positive Integers > 0

Default: 6

#### Salvo Interval
The interval (seconds) between salvos.

Accepts: Positive Integers >= 0

Default: 10

#### Salvo Time Variation
The random amount (0 to value) to add to the salvo interval.

Accepts: Positive Float >= 0

Default: 5

#### Shot Interval
The time between salvos.

Accepts: Positive Float >= 0

Default: 1

#### Shot Time Variation
The random amount (0 to value) to add to the shot interval.

Accepts: Positive Float >= 0

Default: 1

## Sync
#### Accepted Objects
- Trigger

[Example](img\AmbientArtillery-Sync.png)

## Trigger Effects
#### Activation
Activation of the synced trigger (or lack of one) activates the module. Artillery will begin bombarding the area continuously according to provided settings until the trigger is deactivated, or module object is deleted.

#### Deactivation
Deactivation of the synced trigger deactivates the module. Artillery will cease to fire after the current salvo is completed.