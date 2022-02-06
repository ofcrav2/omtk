# UNIFORM_LOCK MODULE

## Data card

| FIELD                   | VALUE
|-------------------------|-------------
| folder name             | uniform_lock
| last modification date  | 2022-02-04
| Ojective                | prevents units from dropping their uniforms
| Default                 | enabled

## Description

This module prevents players from dropping their uniform and possibly being unable to pick it back up.
The uniform gets locked when inventory is open. Code adapted from Iceman77 and pierremgi on the bohemia forums

To remove it, just comment out the "execVM" line on load_modules.sqf (currently line 49):
	> execVM "omtk\uniform_lock\main.sqf";