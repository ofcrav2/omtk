["ia_skills start", "DEBUG", false] call omtk_log;

if (isServer && ("OMTK_MODULE_DISABLE_PLAYABLE_AI" call BIS_fnc_getParamValue) > 0) then {
	// Disable the AI behaviours here
	{
		_x disableAI "AUTOTARGET";
		_x disableAI "TARGET";
		_x disableAI "FSM";
		_x disableAI "MOVE";
		_x stop true;
		_x setBehaviour "CARELESS";
		_x allowFleeing 0;
		_x disableConversation true;
		_x setVariable ["BIS_noCoreConversations", false];
		_x setSpeaker "NoVoice";
		_x allowDamage false;
	} forEach playableUnits;
	
	addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        _unit disableAI "AUTOTARGET";
        _unit disableAI "TARGET";
        _unit disableAI "FSM";
        _unit disableAI "MOVE";
        _unit stop true;
        _unit setBehaviour "CARELESS";
        _unit allowFleeing 0;
        _unit disableConversation true;
        _unit setVariable ["BIS_noCoreConversations", false];
        _unit setSpeaker "NoVoice";
    }];
};

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
