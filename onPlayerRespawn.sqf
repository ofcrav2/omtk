["Terminate"] call BIS_fnc_EGSpectator;
loadout = player getVariable ["playerLoadout", 0];
player setUnitLoadout [loadout, true];