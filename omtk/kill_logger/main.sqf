if (isServer) then {
	["kill_logger start", "INFO", false] call omtk_log;
	_index = 1;
	{
		_name = "bot_" + (str _index);
		
		_x setName _name;
		_x addMPEventHandler  ["MPkilled", { 
			params ["_victim" ,"_killer"]; 
			 _aceLastSourceOfDamage = _victim getVariable ["ace_medical_lastDamageSource", objNull];
			if (!isNull _aceLastSourceOfDamage) then {
				_killer = _aceLastSourceOfDamage;
			};
		   diag_log text format ["[OMTK] KILL: '%1' killed by '%2'",name (_victim),name (_killer)];
		}];		
		_x addMPEventHandler ["MPhit", {diag_log text format ["[OMTK] HIT: '%1' hit by '%2'",name (_this select 0),name (_this select 1)];}];
		_index = _index + 1;
	} forEach allUnits;

	["kill_logger end", "INFO", false] call omtk_log;
 };