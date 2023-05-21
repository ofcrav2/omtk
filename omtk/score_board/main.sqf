["score_boards start", "DEBUG", false] call omtk_log;

call omtk_rollback_to_start_time;

if (isServer) then {
	_omtk_mission_duration = 0;
	if (!isNil "_mission_duration_override") then {
		_endHour   = OMTK_SB_MISSION_DURATION_OVERRIDE select 0;
		_endMinute = OMTK_SB_MISSION_DURATION_OVERRIDE select 1;
		_endSecond = OMTK_SB_MISSION_DURATION_OVERRIDE select 2;
		_omtk_mission_duration = 3600*_endHour + 60*_endMinute + _endSecond - 1;
	} else {
		_omtk_mission_duration = ("OMTK_MODULE_SCORE_BOARD" call BIS_fnc_getParamValue);
	};
	
	// If the variables for unlocking helicopters have been set, the spawned code waits until the time is reached
	// and unlocks all the helicopters in the variables set in the init.
	_unlock_heli_var = missionNamespace getVariable ["OMTK_SB_UNLOCK_HELI_VARS", nil];
	_unlock_heli_time = missionNamespace getVariable ["OMTK_SB_UNLOCK_HELI_TIME", nil];
	if (!isNil "_unlock_heli_var" && !isNil "_unlock_heli_time") then {
		
		[_unlock_heli_time] spawn {
		
			_unlock_heli_time = _this select 0;
			_unlockTime = dayTime + _unlock_heli_time/3600;
			
			waitUntil { sleep 2; dayTime > _unlockTime };
			
			("Locked Vehicles have been Unlocked (if any)") remoteExecCall ["systemChat"];
			{
				_heli = missionNamespace getVariable [_x, objNull];
				if (!isnil("_heli")) then { _heli lock 0; };
			} forEach OMTK_SB_UNLOCK_HELI_VARS;
		};
	};
	
	// Manages the end of the game and the 20 minutes warning.
	[_omtk_mission_duration] spawn {
		
		_omtk_mission_duration = _this select 0;
		_gameEnd = dayTime + _omtk_mission_duration/3600;
		
		if (_gameEnd < 24) then {
			waitUntil { sleep 20; dayTime > (_gameEnd - 0.33333) };
			("20 Minutes Left") remoteExecCall ["hint"];
			
			waitUntil { sleep 2; dayTime > _gameEnd };
		} else {
			
				
			waitUntil { sleep 20; 
				dayTime > (_gameEnd - 0.33333) || 
				( dayTime > (_gameEnd - 0.33333)-24 && dayTime < (_gameEnd - 0.33333)-23 )
			};
			("20 Minutes Left") remoteExecCall ["hint"];
				
			waitUntil { sleep 2; dayTime > _gameEnd-24 && dayTime < _gameEnd-23 };
				
		};
		[] call omtk_sb_compute_scoreboard;
		sleep 2;
		[] call omtk_sb_start_mission_end;
		sleep 10;
		if (isClass(configFile >> "CfgPatches" >> "ocap")) then {
			[] call ocap_fnc_exportData;
		};
	};
	
	// OBJ
	_omtk_sb_objectives = [];
	_omtk_sb_scores = [0,0,0];
	_omtk_sb_flags = [];
	_omtk_sb_timed_objectives = [];
	
	{
		_side = _x select 1;
		_type = _x select 2;
		_values = _x select 4;
		_newFlag = 0;
		
		switch(_side) do {
			case "BLUEFOR":	{
				_x set [1, West];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			case "REDFOR":	{
				_x set [1, East];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			case "GREENFOR":	{
				_x set [1, Resistance];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			// Duplicates the objective for both factions
			case "BLUEFOR+REDFOR":	{
				_x set [1, West];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
				_x2 = + _x;
				_x2 set [1, East];
				// To accomodate timed capzones, the flag used by the duplicated objective is the original + 10
				if (_type == "T_INSIDE") then {
					_newFlag = (_values select 0) + 10;
					_x2 set [4, [_newFlag,0]];
				};
				[_omtk_sb_objectives, _x2] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			case "BLUEFOR+GREENFOR":	{
				_x set [1, West];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
				_x2 = + _x;
				_x2 set [1, Resistance];
				[_omtk_sb_objectives, _x2] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			case "REDFOR+GREENFOR":	{
				_x set [1, East];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
				_x2 = + _x;
				_x2 set [1, Resistance];
				[_omtk_sb_objectives, _x2] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			case "BLUEFOR+REDFOR+GREENFOR":	{
				_x set [1, West];
				[_omtk_sb_objectives, _x] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
				_x2 = + _x;
				_x2 set [1, East];
				[_omtk_sb_objectives, _x2] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
				_x3 = + _x;
				_x3 set [1, Resistance];
				[_omtk_sb_objectives, _x3] call BIS_fnc_arrayPush;
				[_omtk_sb_scores, false]  call BIS_fnc_arrayPush;
			};
			default	{
				["unknown side for objective creation","ERROR",true] call omtk_log;
			};
		};
		
		if (_type == "FLAG") then {
			{
				_omtk_sb_flags set [_x select 0, _x select 1];
			} forEach _values;
		};
		
		// Timed objectives are created here. They consist of a mix of the regular objectives and a flag objective.
		// The execution of the check is handled by the while loop just below. The execution then saves the result on the flag.
		// The flag is then used when computing the scoreboard to assess the completion of the objective.
		if (_type in ["T_INSIDE","T_OUTSIDE","T_SURVIVAL","T_DESTRUCTION"]) then {
			// Initialization of the flag
			_omtk_sb_flags set [_values select 0, false];
			if (_side == "BLUEFOR+REDFOR") then {
				// Initialization of the duplicated flag
				_omtk_sb_flags set [_newFlag, false];
				_x2 = + _x;		
				_x2 set [1, East];		
				if (_type == "T_INSIDE") then {
					_newFlag = (_values select 0) + 10;
					_x2 set [4, [_newFlag,((_x select 4) select 1)]];
				};
				[_omtk_sb_timed_objectives, _x2] call BIS_fnc_arrayPush;
			};
			
			[_omtk_sb_timed_objectives, _x] call BIS_fnc_arrayPush;
		};
		
	} foreach OMTK_SB_LIST_OBJECTIFS;
	
	missionNamespace setVariable ["sb_s", _omtk_sb_scores];
	missionNamespace setVariable ["sb_o", _omtk_sb_objectives];
	missionNamespace setVariable ["sb_f", _omtk_sb_flags];
	
	publicVariable "sb_s";
	publicVariable "sb_o";
	publicVariable "sb_f";
	
	[_omtk_sb_timed_objectives] spawn {
		
		_omtk_sb_timed_objectives = _this select 0;
		_gameStartTime = dayTime;
		sleep 5;
		while {sleep 5 ; (count _omtk_sb_timed_objectives) > 0} do {
			_currentTime = dayTime;
			
			// Change to forEachReversed when available
			for [{private _i = 0},{_i<(count _omtk_sb_timed_objectives)},{_i=_i+1}] do {
				_obj = _omtk_sb_timed_objectives select _i;
				
				_side = str(_obj select 1);
				_type = _obj select 2;
				_values = _obj select 4;
				_newFlag = 0;
				
				// hint format ["1: %1, 2: %2, 4.0: %3, 4.1: %4", (_obj select 1), (_obj select 2), ((_obj select 4) select 0), ((_obj select 4) select 1)];
				
				_objTime = _gameStartTime + ((_values select 1)/60);
				
				if (_currentTime >= _objTime ) then {
					
					hint format ["gameStart: %1, currentTime: %2, objTime: %3", _gameStartTime, _currentTime, _objTime];
					switch(_type) do {
						case "T_INSIDE": {
							[_obj select 6, _obj select 1, 1, _obj select 5, _values select 0, _obj select 3, _side] call omtk_timedArea;
						};
						case "T_OUTSIDE": {
							[_obj select 6, _obj select 1, 0, _obj select 5, _values select 0, _obj select 3, _side] call omtk_timedArea
						};
						case "T_SURVIVAL": {
							[_obj select 5, _obj select 1, 1, _values select 0, _obj select 3, _side] call omtk_timedAlive;							
						};
						case "T_DESTRUCTION": {
							[_obj select 5, _obj select 1, 0, _values select 0, _obj select 3, _side] call omtk_timedAlive;							
						};
					};
					_omtk_sb_timed_objectives deleteAt _i;
					_i = _i - 1;
				};
			};	
		};
	};
	
	
	missionNamespace setVariable ["sb_r4r", 0];
	publicVariable "sb_r4r";
};



if (hasInterface) then {
	// Display end mission time to client	
	
	_endHour = 0;
	_endMinute = 0;
	_endSecond = 0;
	
	_initHour = (o_wse select 0) select 3;
	_initMinute = (o_wse select 0) select 4;

	_mission_duration_override = missionNamespace getVariable ["OMTK_SB_MISSION_DURATION_OVERRIDE", nil];
	if (!isNil "_mission_duration_override") then {
		_endHour   = OMTK_SB_MISSION_DURATION_OVERRIDE select 0;
		_endMinute = OMTK_SB_MISSION_DURATION_OVERRIDE select 1;
		_endSecond = OMTK_SB_MISSION_DURATION_OVERRIDE select 2;
	} else {
		_mission_duration = ("OMTK_MODULE_SCORE_BOARD" call BIS_fnc_getParamValue);
		_endHour   = floor (_mission_duration/3600);
		_endMinute = floor ((_mission_duration - (3600*_endHour)) / 60);
	};

	_omtk_mission_endTime_hour = _initHour + _endHour;
	_omtk_mission_endTime_minute = _initMinute + _endMinute;

	
	if (_omtk_mission_endTime_hour > 24) then {
		_omtk_mission_endTime_hour = _omtk_mission_endTime_hour - 24;
	};
	if (_omtk_mission_endTime_minute > 60) then {
		_omtk_mission_endTime_minute = _omtk_mission_endTime_minute - 60;
	};
	
	_txtFormat = "%1h%2m";
	if (_omtk_mission_endTime_minute < 10) then {_txtFormat = "%1h0%2m"; };
	_end_time_txt = format [_txtFormat,_omtk_mission_endTime_hour,_omtk_mission_endTime_minute];
	_end_time_txt = format ["<t shadow='1' shadowColor='#CC0000'>End of mission : %1</t>", _end_time_txt];
	_end_time_txt = parseText _end_time_txt;
	
	_omtk_mission_end_time_txt = composeText [_end_time_txt];
	
	if (!isNil "_omtk_mission_end_time_txt") then {
		[_omtk_mission_end_time_txt,0,0,10,2] spawn BIS_fnc_dynamicText;
	};
	
	sleep 10;

	_omtk_sb_objectives = missionNamespace getVariable "sb_o";

	_index = -1;
	{
		_index = _index + 1;
		_side = _x select 1;
		_type = _x select 2;
	
		if (side player == _side) then {
			switch(_type) do {
				case "ACTION":	{
					_tgt = _x select 4;
					_tgtType = typeName _tgt;
					if (_tgtType == "STRING") then {
						_tgt = missionNamespace getVariable [_tgt, nil];
					};
					_txt = "<t color='#0000FF'>" + (_x select 3) + "</t>";
					_dur = _x select 5;
					_ext = _x select 6;	
					_action = _tgt addAction[_txt, { call omtk_closeAction;}, [_dur, _ext, _index]];
				};
	
				case "ACTION_DISPUTEE":	{
				
				};
			};
		};
	} foreach _omtk_sb_objectives;

};

["score_boards end", "DEBUG", false] call omtk_log;
