if (isServer) then {
	["vehicles_thermalimaging start", "DEBUG", false] call omtk_log;

	{
		_x disableTIEquipment true;
	} foreach vehicles;

	["vehicles_thermalimaging end", "DEBUG", false] call omtk_log;
};
