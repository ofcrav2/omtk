["vehicles_thermalimaging start", "DEBUG", false] call omtk_log;

if (isServer) then {
	[] call omtk_disable_ti;
};

if (hasInterface) then {
	player addEventHandler ["WeaponAssembled", {
		[] remoteExec ["omtk_disable_ti", 2, true];
	}];
};

["vehicles_thermalimaging end", "DEBUG", false] call omtk_log;