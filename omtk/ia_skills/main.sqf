["ia_skills start", "DEBUG", false] call omtk_log;

if (isServer && ("OMTK_MODULE_LIGHT_VERSION" call BIS_fnc_getParamValue) < 1) then {
	{
		_x setskill ["aimingAccuracy",0.1];
		_x setskill ["aimingShake",0.1];
		_x setskill ["aimingSpeed",0.1];
		_x setskill ["endurance",0.2];
		_x setskill ["spotDistance",0.3];
		_x setskill ["spotTime",0.4]; 
		_x setskill ["courage",0.4];
		_x setskill ["reloadSpeed",0.4];
		_x setskill ["commanding",0.2];
		_x setskill ["general",0.2];
	} forEach allUnits;
};

if (hasInterface) then {
	player addRating 1000000;
};

["ia_skills end.", "DEBUG", false] call omtk_log;
