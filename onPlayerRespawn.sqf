["Terminate"] call BIS_fnc_EGSpectator;
if (("OMTK_MODULE_LIGHT_VERSION" call BIS_fnc_getParamValue) < 1) then {
	[player, [missionNamespace, "OMTK_LOADOUT"]] call BIS_fnc_loadInventory;
};

