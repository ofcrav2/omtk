["difficulty_check start", "DEBUG", false] call omtk_log;

if (difficulty < 3) then {
	["difficulty is not ELITE !", "WARNING", false] call omtk_log;
	if(hasInterface) then { hint "WARNING: difficulty is not ELITE !"; };
};

["difficulty_check end", "DEBUG", false] call omtk_log;
