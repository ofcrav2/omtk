if (!(isDedicated)) then {
	waitUntil {!(isNull player)};
	player addEventHandler ["inventoryOpened"," _nul = execVM 'omtk\uniform_lock\lock.sqf' "];
};