# Visual Cues

On-screen notifications for **Warhammer: Vermintide 2** events that the game otherwise signals only through sound.

Requires [Vermintide Mod Framework][vmf], loaded above this mod.

## Features

| Feature | Default | Description |
| --- | --- | --- |
| Screen notifications | On | Colour-coded text, visible only to you |
| Chat announcements | Off | The same text in your own chat log |
| Monsters | On | Rat Ogre, Stormfiend, Spawn of Chaos, Bile Troll, Minotaur |
| Specials | On | Leech, Gutter Runner, Packmaster, Ratling Gunner, Warpfire Thrower, Globadier, Blightstormer, Standard Bearer |
| Hordes | On | Announced on the game's horde stinger |
| Incoming attack marker | On | Red `!` alongside the game's backstab warning sound |

Level-specific Lords (Bodvarr, Halescourge, Rasknitt, etc.) are intentionally not announced.

## What it does and does not report

Nothing is ever sent to other players. Every notification is local to your client.

Monsters are announced when their spawn queue sounds. Specials are announced only once they are within the game's 
own "earshot" distance (`DialogueSettings.special_proximity_distance_heard`, read at runtime). Hordes are announced 
on the game's horde stinger. The attack marker mirrors the backstab warning sound and never appears for an attack 
the game did not already warn you about.

## Notification categories

| Category | Color | Chat tag |
| --- | --- | --- |
| Monsters | Yellow | `[BOSS]` |
| Specials | Purple | `[SPECIAL]` |
| Hordes | Red | `[HORDE]` |

Notifications scale with the game's HUD scale, stack up to four at once, and are hidden in menus, cutscenes and while the HUD is disabled.

## Test commands

```text
/vc_test                 monster, defaults to Rat Ogre
/vc_test stormfiend      any monster by name
/vc_test leech           any special by name
/vc_test horde
/vc_test warning         the incoming attack marker
```

Shorthand works: `mino`, `assassin`, `hookrat`, `gasrat`, `stormer`, and others.

## Building

Build this mod with [Vermintide Mod Builder][vmb] — see its [wiki][vmb-wiki] for setup and commands.

```text
vmb build visual_cues --source
```

Notes:

- The mod folder must be named `visual_cues`, matching the `.mod` and `.package` files.
- Requires the Vermintide 2 SDK (Steam > Library > Tools).

[vmf]: https://steamcommunity.com/workshop/filedetails/?id=1369573612
[vmb]: https://github.com/Vermintide-Mod-Framework/Vermintide-Mod-Builder
[vmb-wiki]: https://github.com/Vermintide-Mod-Framework/Vermintide-Mod-Builder/wiki
