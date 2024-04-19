omtk_sb_mission_end = {
	if (hasInterface) then {
		waitUntil { (missionNamespace getVariable "sb_r4r") == 1};
		if (("OMTK_MODULE_MEXICAN_STANDOFF" call BIS_fnc_getParamValue) < 1) then {
			// Mexican Standoff DISABLED
			createDialog "ScoreBoard";
		} else {
			// Mexican Standoff ENABLED
			createDialog "ScoreBoard_MS";
		};
	};
};


omtk_sb_start_mission_end = {
  remoteExec ["omtk_sb_mission_end"]; 
};


omtk_sb_computing_display = {
	if (hasInterface) then {
		_computing_txt = format ["<t shadow='1' shadowColor='#CC0000'>- MISSION FINISHED -<br />Scores computing in progress...</t>"];
		_computing_txt = parseText _computing_txt;
		_computing_txt = composeText [_computing_txt];
		[_computing_txt,0,0,15,0] spawn BIS_fnc_dynamicText;
	};
};


omtk_sb_compute_scoreboard = {
	remoteExec ["omtk_sb_computing_display"];
	
	// Calculates survivors for each team
	omtk_sb_bluefor_survivors = [];
	omtk_sb_redfor_survivors = [];
	omtk_sb_greenfor_survivors = [];
	{
		_name = name _x; // test if name is OK TODO
		_side = side _x;
		_class = typeOf _x;
		_dmg = damage _x;

		if(_side==east) then {
			if ((damage player) < 0.975) then { [omtk_sb_redfor_survivors, _name] call BIS_fnc_arrayPush; };
		} else {
			if(_side==west) then { 
				if ((damage player) < 0.975) then { [omtk_sb_bluefor_survivors, _name] call BIS_fnc_arrayPush; };
			} else {
				if(_side==resistance) then { 
					if ((damage player) < 0.975) then { [omtk_sb_greenfor_survivors, _name] call BIS_fnc_arrayPush; };
				};
			};
		};
	} forEach allPlayers;
	
	missionNamespace setVariable ["omtk_sb_bluefor_survivors", omtk_sb_bluefor_survivors];
	missionNamespace setVariable ["omtk_sb_redfor_survivors", omtk_sb_redfor_survivors];
	missionNamespace setVariable ["omtk_sb_greenfor_survivors", omtk_sb_greenfor_survivors];
	publicVariable "omtk_sb_redfor_survivors";
	publicVariable "omtk_sb_bluefor_survivors";
	publicVariable "omtk_sb_greenfor_survivors";
	
	// Calculates scores for each team (getObjectiveResult on each objective to get result (boolean)) 
	// _x select 0 -> how many points to assign 
	// _x select 1 -> what faction to assign the points to. 
	//_idx is the index position of "sb_scores" of each faction (0=west, 1=east, 2=resistance)
	sb_s = missionNamespace getVariable "sb_s";
	sb_o = missionNamespace getVariable "sb_o";
	sb_f = missionNamespace getVariable "sb_f";

	_index = 2;
	{
		_index = _index + 1;
		_res = [_x, _index] call omtk_sb_getObjectiveResult;
		sb_s set [_index, _res];
		if (_res) then {
			_idx = 0;
			if ((_x select 1) == east) then { _idx = 1;};
			if ((_x select 1) == resistance) then { _idx = 2;};
			_val = (_x select 0) + (sb_s select _idx);
			sb_s set [_idx, _val];
		};
	} foreach sb_o;
			
	missionNamespace setVariable ["sb_o", sb_o];
	missionNamespace setVariable ["sb_s", sb_s];
	
	publicVariable "sb_o";
	publicVariable "sb_s";
	["scores computed","[INFO]",true] call omtk_log;
	_omtk_sb_ready4result = 1;
	missionNamespace setVariable ["sb_r4r", _omtk_sb_ready4result];
	publicVariable "sb_r4r";

	// Stats plugin, using publicVariable to make sure this still works without the Stats Plugin working - will probably change later to a nicer implementation
	_winner = "NA";
	if (("OMTK_MODULE_MEXICAN_STANDOFF" call BIS_fnc_getParamValue) < 1) then {
			_west = sb_s select 0;
			_opf = sb_s select 1;

			if (_west == _opf) then {
				_winner = "DRAW";
			} else {
				if (_west > _opf) then {
					_winner = "WEST";
				} else {
					_winner = "EAST";
				};
			};
		} else {
			_west = sb_s select 0;
			_opf = sb_s select 1;
			_green = sb_s select 2;

			if (_west == _opf && _west == _green) then {
				_winner = "DRAW";
			} else {
				if (_west > _opf && _west > _green) then {
				_winner = "WEST";
				} else {
					if (_opf > _west && _opf > _green) then {
						_winner = "EAST";
					} else {
						if (_green > _opf && _green > _west) then {
							_winner = "GREEN";
						} else {
							// Too lazy to implement the else, let's hope it won't happen
						}
					};
				};
			};
		};

	if (isClass(configFile >> "CfgPatches" >> "STATSLOGGER")) then {
		[_winner, sb_s select 0, sb_s select 1] remoteExec ["statslogger_fnc_mission_end", 2];
		[] call statslogger_fnc_export;
	};
};


omtk_sb_getObjectiveResult = {
	private["_obj","_index","_side", "_type","_res"];
	
	_obj = _this select 0;
	_index = _this select 1;
	_side = _obj select 1;
	_type = _obj select 2;
	_res = false;
	
	switch(_type) do {
		case "SURVIVAL":	{ 
			_res = [_obj select 4, _side, 1] call omtk_isAlive;
		};
		case "DESTRUCTION":	{
			_res = [_obj select 4, _side, 0] call omtk_isAlive;
			//["objectif BLUEFOR","INFO",false] call omtk_log;
		};
		case "INSIDE":	{
			//["objectif " + (str (_obj select 3)) + " for SIDE=" + (str _side),"INFO",false] call omtk_log;
			_res = [_obj select 5, _side, 1, _obj select 4] call omtk_isInArea;
		};
		case "OUTSIDE":	{
			_res = [_obj select 5, _side, 0, _obj select 4] call omtk_isInArea;
			//["objectif BLUEFOR","INFO",false] call omtk_log;
		};
		case "ACTION":	{
			_sb_s = missionNamespace getVariable "sb_s";			
			_res = (_sb_s select _index);
			//["objectif BLUEFOR","INFO",false] call omtk_log;
		};
		case "TRIGGER":	{
			//["objectif BLUEFOR","INFO",false] call omtk_log;
		};
		case "FLAG":	{
			_res = true;
			_omtk_sb_flags = missionNamespace getVariable "sb_f";
			{
				_x = _x select 0;
				_log = "Get " + str _x + " / " + str (count _omtk_sb_flags) + " : " + str (_omtk_sb_flags select _x);
				//[ _log, "INFO",false] call omtk_log;
				if (!(_omtk_sb_flags select _x)) then { _res = false; };
			} forEach (_obj select 4);		
			//["objectif BLUEFOR","INFO",false] call omtk_log;
		};
		
		case "T_DESTRUCTION";
		case "T_SURVIVAL";
		case "T_OUTSIDE";
		case "T_INSIDE": {
			_res = true;
			_omtk_sb_flags = missionNamespace getVariable "sb_f";
			
			_flagNum = (_obj select 4) select 0;
			if (!(_omtk_sb_flags select _flagNum)) then { _res = false; };	
		};
		
		default	{
			["unkown objective type","ERROR",true] call omtk_log;
		};
	};
	
	_res;
};


omtk_side_in_area = {
	private["_blue","_red","_r","_green"];
	_blue = 0;
	_red = 0;
	_green = 0;
	_areaName = _this select 0;
	/*
	_areaType = typeName _areaName;	
	_areaI = nil;
	
	if (_areaType == "STRING") then {
		_areaI = missionNamespace getVariable [_areaName, nil];
	} else {
		_areaI = _areaName;
		_areaName = _areaI getVariable "name";
	};
	
	if (isNil("_areaI")) then {
		["Zone '" + _areaName + "' not found !" ,"ERROR",true] call omtk_log;
	}
	*/
	{
		_r = (position _x) inArea _areaName;
		if (_r and alive _x) then {
			//["Unit: " +  (name _x) + " est vivant et dans la zone: " + _areaName,"OBJECTIVE",false] call omtk_log;
			_side = side _x;
			switch(_side) do {
				case West:	{ _blue = _blue + 1; };
				case East:	{ _red = _red + 1; };
				case Resistance: { _green = _green + 1; };
				default { ["Unit: non comptabilisee pour camp inconnu: " + (str _side),"ERROR",false] call omtk_log; };
			};
		};
	} foreach allUnits;
	["Zone: " +  _areaName + " BLUE=" + (str _blue) + " - RED=" + (str _red) + " - GREEN=" + (str _green), "OBJECTIVE", false] call omtk_log;
	[_blue, _red, _green];
};


/* PARAMS:
 * 0 -> subject and value related to the objective
 * 1 -> side of the obj
 * 2 -> subtype of obj (IN or OUT)
 * 3 -> zone of the obj 
 */
omtk_isInArea = {
	private["_subArr","_subject","_value","_Sside","_mode","_count","_res","_type"];
		
	_subject = _this select 0 select 0;	
	_value = _this select 0 select 1;
	_Sside = _this select 1;
	_mode = _this select 2;
	_area = _this select 3;
	_res = false;
	
	switch(_subject) do {
		case "BLUEFOR":	{ 
			_eff = [_area] call omtk_side_in_area;
			_res = ((_eff select 0) >= _value);
		};
		case "REDFOR":	{ 
			_eff = [_area] call omtk_side_in_area;
			_res = ((_eff select 1) >= _value);
		};
		case "GREENFOR":	{ 
			_eff = [_area] call omtk_side_in_area;
			_res = ((_eff select 2) >= _value);
		};
		
		case "DIFF": { 
			_eff = [_area] call omtk_side_in_area;
			
			// _eff select 0 -> bluefor in area, _eff select 1 -> redfor in area, _eff select 2 -> greenfor in area
			// to "win" the capzone, the faction MUST have more people in the zone than BOTH of the other factions
			
			
			if (_Sside == West) then { 
				_res = (((_eff select 0) - (_eff select 1)) >= _value) && (((_eff select 0) - (_eff select 2)) >= _value);
			} else {
				if (_Sside == East) then {
					_res = (((_eff select 1) - (_eff select 0)) >= _value) && (((_eff select 1) - (_eff select 2)) >= _value);
				} else {
					_res = (((_eff select 2) - (_eff select 0)) >= _value) && (((_eff select 2) - (_eff select 1)) >= _value);
				};
			};
			
			if (_mode < 1) then { _res = !_res; };
		};
		
		case "LIST": {
			_resArr = [];
			_res = true; 
			{
				_target = missionNamespace getVariable [_x , objNull];
				_areaObj = missionNamespace getVariable [_area , objNull];	
				// _r = [_areaObj, (position _target)] call BIS_fnc_inTrigger;
				_r = (position _target) inArea _area;
				if (_mode < 1) then { _r = !_r; };
				if (!alive _target) then { _r = false; };
				_resArr pushBack _r;
			} foreach _value;
			
			// They ALL have to be true for the obj to be completed
			{
				// If one is FALSE, _res becomes permanently false
				if (!_x) then {
					_res = false;
				};
			} foreach _resArr;
			
			/*
			{
				_target = missionNamespace getVariable [_x , objNull];
				_areaObj = missionNamespace getVariable [_area , objNull];	
				_r = [_areaObj, (position _target)] call BIS_fnc_inTrigger;
				if (_mode < 1) then { _r = !_r; };
				_res = _r;
			} foreach _value;    
			OLD, RESULT IS LAST VALUE*/ 
		};
		case "MT_ID": {
			_items_found = [];
			{
				_id = _x getVariable ["mt_id", ""];
				if (_id in _value) then {
					["Found MT_ID " + (str _id),"INFO",false] call omtk_log;
					_items_found pushBack _id;
					_target = _x;
					_areaObj = missionNamespace getVariable [_area , objNull];	
					_r = (position _target) inArea _areaObj;
					if (_mode < 1) then { _r = !_r; };
					_res = _r;
				};
			} foreach allUnits;
			_missing = _value - _items_found;
			if (count _missing > 0) then {
				_res = false;
				["missing MT_ID","INFO",false] call omtk_log;
			};
		};
		default	{
			_res = false;
			["Sujet de l'objectif inconnu: %1", _subject] call BIS_fnc_error;		
		};		
	};
	_res;
};

/* Function called by a KK_setTimeout created in score_board\main.sqf on the server for every T_INSIDE or T_OUTSIDE
 * PARAMS:
 * 0 -> subject and value related to the objective
 * 1 -> side of the obj
 * 2 -> subtype of obj (IN or OUT)
 * 3 -> zone of the obj 
 * 4 -> flag number
 * 5 -> obj label 
 * 6 -> side (string) of obj
 */
omtk_timedArea = {
	_sideStr = _this select 6;
	_label = _this select 5;
	
	_res = [_this select 0, _this select 1, _this select 2, _this select 3] call omtk_isInArea;
	
	if (_res) then {
		("[OMTK] OBJ " + _label + " COMPLETED BY " + _sideStr + ".") remoteExecCall ["systemChat"];
		[_this select 4, true] call omtk_setFlagResult;
	} else {
		("[OMTK] OBJ " + _label + " FAILED BY " + _sideStr + ".") remoteExecCall ["systemChat"];
	};
};


/* PARAMS:
 * 0 -> subject and value related to the objective
 * 1 -> side of the obj
 * 2 -> subtype of obj (SURV or DESTR)
 */
omtk_isAlive = {
	private["_subArr","_subject","_value","_side","_mode","_count","_res","_type"];
	
	_subArr = _this select 0;
	_subject = _subArr select 0;	
	_value = _subArr select 1;
	_side = _this select 1;
	_mode = _this select 2;
	_res = false;
	
	switch(_subject) do {
		// For supremacy: counts side survivors
		case "BLUEFOR":	{ 
			_count = 0;
			_bEff = count omtk_sb_bluefor_survivors;
			_res = (_bEff >= _value);
			if (_mode < 1) then { _res = !_res; };
		};
		case "REDFOR":	{ 
			_count = 0;
			_rEff = count omtk_sb_redfor_survivors;
			_res = (_rEff >= _value);
			if (_mode < 1) then { _res = !_res; };
		};
		case "GREENFOR":	{ 
			_count = 0;
			_gEff = count omtk_sb_greenfor_survivors;
			_res = (_gEff >= _value);
			if (_mode < 1) then { _res = !_res; };
		};
		case "DIFF": { 
			_bEff = count omtk_sb_bluefor_survivors;
			_rEff = count omtk_sb_redfor_survivors;
			if (_side == West) then { _res = (_bEff - _rEff) >= _value; }
			else {_res = (_rEff - _bEff) >= _value; };
		};
		case "LIST": {
			_resArr = [];
			_res = true; 
			{
				_target = nil;
			
				_type = typeName _x;
				if (_type == "STRING") then { _target = missionNamespace getVariable [_x , objNull]; };
				if (_type == "SCALAR") then { _target = [0,0,0] nearestObject _x; };
				
				_r = alive _target;
				if (_mode < 1) then { _r = !_r; };
				_resArr pushBack _r;
			} foreach _value;
			
			// They ALL have to be true for the obj to be completed
			{
				// If one is FALSE, _res becomes permanently false
				if (!_x) then {
					_res = false;
				};
			} foreach _resArr;
		};
		case "OMTK_ID": {
			_items_found = [];
			_res = true;
			{
				_id = _x getVariable ["mt_id", ""];
				if (_id in _value) then {
					["Found MT_ID " + (str _id),"INFO",false] call omtk_log;
					_items_found pushBack _id;
					_target = _x;
					_r = alive _target;
					//if (_mode < 1) then { _r = !_r; };
					if (_r) then {_res = false;};
				};
			} foreach allUnits;
			_missing = _value - _items_found;
			if (count _missing > 0) then {
				if (_mode == 1) then { _res = false; };
				["missing MT_ID","INFO",false] call omtk_log;
			};
		};
		
		default	{
			_res = false;
			["Objective target is not found: %1", _subject] call BIS_fnc_error;		
		};		
	};
	_res;
};

/* Function called by a KK_setTimeout created in score_board\main.sqf on the server for every T_SURVIVAL or T_DESTRUCTION
 * PARAMS:
 * 0 -> subject and value related to the objective
 * 1 -> side of the obj
 * 2 -> subtype of obj (SURV or DESTR)
 * 3 -> flag number
 * 4 -> obj label 
 * 5 -> side (string) of obj
 */
omtk_timedAlive = {
	_side = _this select 5;
	_label = _this select 4;
	
	_res = [_this select 0, _this select 1, _this  select 2] call omtk_isAlive;
	
	if (_res) then {
		("[OMTK] OBJ '" + _label + "' COMPLETED BY " + _side + ".") remoteExecCall ["systemChat"];
		[_this select 3, true] call omtk_setFlagResult;
	} else {
		("[OMTK] OBJ '" + _label + "' FAILED BY " + _side + ".") remoteExecCall ["systemChat"];
	};
};

omtk_setObjectiveResult = {
	sb_s = missionNamespace getVariable "sb_s";
	sb_s set [_this select 0, _this select 1];
	//["action " + str(_this select 0) + " = " + str(_this select 1), "OBJECTIVE", false] call omtk_log;
	missionNamespace setVariable ["sb_s", sb_s];
	publicVariableServer "sb_s";
};


omtk_setFlagResult = {
	_omtk_sb_flags = missionNamespace getVariable "sb_f";
	_omtk_sb_flags set [_this select 0, _this select 1];
	//["flag " + str(_this select 0) + " = " + str(_this select 1), "OBJECTIVE", false] call omtk_log;

	//push out flag variable to all clients so that the "sb_f" variable stays in sync if another flag is called
	missionNamespace setVariable ["sb_f", _omtk_sb_flags, true];
	publicVariableServer "sb_f";
};


omtk_closeAction = {
	private["_obj", "_id", "_caller", "_proc", "_index", "_dur", "_sb_s","_num"];
	
	_obj = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	
	_dur = _this select 3 select 0;
	_proc = _this select 3 select 1;
	_index = _this select 3 select 2;
	
	if (_dur > 0) then {
		createDialog "ActionProgress";
		
		_delay = 10;
		for "_i" from 0 to _delay do {
			sleep 1;
			((uiNamespace getVariable "InteractiveStartUp") displayCtrl 1999) progressSetPosition (_i / _delay);
			((uiNamespace getVariable "InteractiveStartUp") displayCtrl 1999) progressSetPosition (_i / _delay);
		};
		closeDialog 0;	
	};// TODO Display progress bar using _dur, then..
	
	["action: " + str(_id) + " is done", "OBJECTIVE", false] call omtk_log;
	
	_obj removeAction _id;
	_index = _index + 2;
	
	[_index, true] call omtk_setObjectiveResult;
	
	_bool = isNil _proc;
	if (!_bool) then { [_obj,_caller] call _proc; };
};

