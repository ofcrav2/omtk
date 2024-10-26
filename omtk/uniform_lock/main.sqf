if ("OMTK_MODULE_UNIFORM" call BIS_fnc_getParamValue == 0) then {
	if (!(isDedicated)) then {
		waitUntil {!(isNull player)};
		player addEventHandler ["inventoryOpened"," _nul = execVM 'omtk\uniform_lock\lock.sqf' "];
	};
} else {
	[] execVM 'omtk\uniform_lock\wwyw.sqf'
};

