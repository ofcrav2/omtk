OMTK_WU_CHIEF_CLASSES = ["B_officer_F", "B_Soldier_SL_F", "O_officer_F", "O_Soldier_SL_F"]; // CAN BE CUSTOMIZED

["warm_up start", "DEBUG", false] call omtk_log;

// Retrieve parameters
omtk_wu_time = ("OMTK_MODULE_WARM_UP" call BIS_fnc_getParamValue);
omtk_wu_radius = ("OMTK_MODULE_WARM_UP_DISTANCE" call BIS_fnc_getParamValue);
omtk_disable_playable_ai = ("OMTK_MODULE_DISABLE_PLAYABLE_AI" call BIS_fnc_getParamValue);
omtk_view_distance = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);

omtk_wu_restrict_area_trigger = nil;
omtk_wu_com_menu_item_id = 0;

// Function ran on clients only
omtk_wu_start_warmup = {
	["wu_start_warmup fnc called", "DEBUG", false] call omtk_log;
	
	[] call omtk_sim_disableVehicleSim;		// VEHICLE LOCK & SIM
	player enableSimulation false;			// PLAYER SIM
	player allowDamage false;				// DAMAGE
	setViewDistance 200;					// VIEW DISTANCE
	
	// Creation of the "restrict_area_trigger" that'll call "move_player_at_spawn_if_required" fnc.
	omtk_wu_restrict_area_trigger = createTrigger ["EmptyDetector", omtk_wu_spawn_location, false];
	omtk_wu_restrict_area_trigger setTriggerArea [omtk_wu_radius, omtk_wu_radius, 0, false];
	omtk_wu_restrict_area_trigger setTriggerActivation [format["%1", side player], "NOT PRESENT", true];
	_trg_out_action = "['Leaving spawn location', 'INFO'] call omtk_log;hint 'GO BACK TO YOUR POSITION !';
	[omtk_wu_move_player_at_spawn_if_required, [], 10] call KK_fnc_setTimeout;";
	omtk_wu_restrict_area_trigger setTriggerStatements ["player in thisList", "", _trg_out_action];

	// Creating and displaying notification text with warmup length
	_omtk_mission_warmup_minute = floor(omtk_wu_time/60);
	_omtk_mission_warmup_second = (omtk_wu_time - (60*_omtk_mission_warmup_minute));
	_omtk_mission_warmup_txt = "";
	if (_omtk_mission_warmup_minute > 0) then {
		_omtk_mission_warmup_txt = str(_omtk_mission_warmup_minute) + " min.";
	};
	if (_omtk_mission_warmup_second > 0) then {
		_omtk_mission_warmup_txt = _omtk_mission_warmup_txt + " " + str(_omtk_mission_warmup_second) + " sec.";
	};
	
	_omtk_notification_txt = format ["<t shadow='1' shadowColor='#00A6DD'>- - - WARMUP: " + _omtk_mission_warmup_txt + " - - -</t>"];
	_omtk_notification_txt = parseText _omtk_notification_txt;
	_omtk_notification_txt = composeText [_omtk_notification_txt];
	[_omtk_notification_txt,0,0,25,2] spawn BIS_fnc_dynamicText;
	
	// PLAYER SIM RE-ENABLE TIMER
	private _randRelease = (random 30) + 1;
	systemChat format ["[OMTK] Your simulation will be disabled for %1 seconds after launch",_randRelease];
    sleep _randRelease;

    player enableSimulation true;
};

// Function called by restrict_area_trigger on clients only
omtk_wu_move_player_at_spawn_if_required = {
	_distance = (position player) distance omtk_wu_spawn_location;
	if (_distance > omtk_wu_radius) then {
		["teleport player '" + name player + "' back to his initial position", 'CHEAT', true] call omtk_log;
		player setPos omtk_wu_spawn_location;
	};
};

// Fnc called by end_warmup_remote from the server 
omtk_wu_end_warmup = {
	["wu_end_warmup fnc called", "DEBUG", false] call omtk_log;
	// On clients, reverts the changes applied by "wu_start_warmup" and by the "main.sqf" itself
	if (hasInterface) then {
	
		player allowDamage true;				// DAMAGE
		[] call omtk_sim_enableVehicleSim;		// VEHICLE LOCK & SIM
		
		deleteVehicle omtk_wu_restrict_area_trigger;
		if ((typeOf player) in OMTK_WU_CHIEF_CLASSES) then {
			[player, omtk_wu_com_menu_item_id] call BIS_fnc_removeCommMenuItem;
			if (call omtk_is_using_ACEmod) then {
				[player, 1, ["ACE_SelfActions", "OMTK_END_WARMUP"]] call ace_interact_menu_fnc_removeActionFromObject;
			};
		};
	};
	// On server, sets variable to prevent warmup for JIP players, 
	// unlocks vehicles and deletes AIs according to the parameter
	if (isServer) then {
		missionNamespace setVariable ["omtk_wu_is_completed", true];
		publicVariable "omtk_wu_is_completed";
		
		call omtk_unlock_vehicles;
		
		if (omtk_disable_playable_ai == 1) then {
			call omtk_delete_playableAiUnits;
		}
		
	};
	
	// Continue to load modules...
	call omtk_load_post_warmup;
};

// Executed on the server by a scheduled fnc call, execs "wu_end_warmup" on both server and clients.
omtk_wu_end_warmup_remote = {
	[] remoteExec ["omtk_wu_end_warmup", 0, true];
};

// Executed on the server by several scheduled fnc calls, is responsible for the hints displaying remaining warmup time
// Now also performs view distance changes and enables sim for vehicles
omtk_wu_scheduled_calls = {
	_by = _this select 0;
	if (_by > -1) then {
		_minute = floor(_by/60);
		_second = _by - (_minute*60);
		_res = "";
		if (_minute > 0) then {_res = _res + (str _minute) + " min. "; };
		if (_second > 0) then {_res = _res + (str _second) + " sec."; };
		if (_by == 0) then { _res = "GO GO GO !!!"; };
		("START: " + _res) remoteExecCall ["hint"];
		
		// SET TO QUARTER VIEW DISTANCE 1 MIN BEFORE WARMUP END
		if (_by == 60) then { 
			[omtk_view_distance/4] remoteExecCall ["setViewDistance"];
			("[OMTK] View distance raised to a quarter of full view distance") remoteExecCall ["systemChat"];
			
			[] remoteExecCall ["omtk_sim_enableVehicleSim"];
		};
		// SET TO HALF VIEW DISTANCE 10 SECS BEFORE WARMUP END
		if (_by == 10) then { 
			[omtk_view_distance/2] remoteExecCall ["setViewDistance"];
			("[OMTK] View distance raised to a half of full view distance") remoteExecCall ["systemChat"];
			
			// When wu_time is 60 or less, this fnc is not called with _by==60 
			if (omtk_wu_time < 61) then {
				[] remoteExecCall ["omtk_sim_enableVehicleSim"];
			};	
		};
	};
	// LIGHT OMTK MESSAGE
	if (_by == -1) then {
		("WARMUP is running OK - ") remoteExecCall ["hint"];
	};
	// SET TO FULL VIEW DISTANCE (as triggered by its own trigger call) 4 MIN AFTER WARMUP END
	if (_by == -2) then {
		[omtk_view_distance] remoteExecCall ["setViewDistance"];
		("[OMTK] View distance raised to full view distance") remoteExecCall ["systemChat"];	
	};
};

// Can be executed via debug console by the admin. Deletes the scheduled fncs and
// schedules "wu_end_warmup_remote" and a couple of display notifications for a 30 seconds warmup.
omtk_wu_fn_launch_game = {
	
	if (isServer) then {
		("[OMTK] warmup interrupted !") remoteExecCall ["systemChat"];
		_omtk_wu_notification_triggers = missionNamespace getVariable "omtk_wu_triggers";
		{
			deleteVehicle _x;
		} forEach _omtk_wu_notification_triggers;
		[omtk_wu_end_warmup_remote, [], 30] call KK_fnc_setTimeout;
		[30] call omtk_wu_scheduled_calls;
		[omtk_wu_scheduled_calls, [10], 20] call KK_fnc_setTimeout;
		[omtk_wu_scheduled_calls, [0], 30] call KK_fnc_setTimeout;
		[omtk_wu_scheduled_calls, [-2], 210] call KK_fnc_setTimeout;
		["Start in 30 sec.", "WARMUP", true] call omtk_log;
	};
};

omtk_wu_set_ready = {
	_side = side player;

	("[OMTK] Side " + str(_side) + " is READY !") remoteExecCall ["systemChat"];
	_omtk_wu_ready_west = missionNamespace getVariable ["omtk_wu_ready_west", false];
	_omtk_wu_ready_east = missionNamespace getVariable ["omtk_wu_ready_east", false];
	
	switch (_side) do {
			case east: { _omtk_wu_ready_east = true; };
			case west: { _omtk_wu_ready_west = true; };
			default {
				["unknown side for omtk_wu_ready", "ERROR", true] call omtk_log;
			};
	};

	if (_omtk_wu_ready_west && _omtk_wu_ready_east) then { 
			[] remoteExec ["omtk_wu_fn_launch_game", 2];
	} else {
		missionNamespace setVariable ["omtk_wu_ready_west", _omtk_wu_ready_west];
		missionNamespace setVariable ["omtk_wu_ready_east", _omtk_wu_ready_east];
		publicVariable "omtk_wu_ready_west";
		publicVariable "omtk_wu_ready_east";
	};
};

// Creates scheduled fnc calls for notifications and for wu_end_warmup_remote and
// makes them public for deletion by wu_launch_game. Vehicle lock moved to client side fnc
if (isServer) then {
	["warmup scheduled triggers creation", "DEBUG", false] call omtk_log;

	call omtk_lock_vehicles;
	
	_omtk_wu_notification_triggers = [];
	
	// If Light version is disabled, add the notifications as usual
	if (("OMTK_MODULE_LIGHT_VERSION" call BIS_fnc_getParamValue) < 1) then {
		{
			if (_x < omtk_wu_time) then {
				_trg = [omtk_wu_scheduled_calls, [_x], (omtk_wu_time - _x)] call KK_fnc_setTimeout;
				[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
			};
		} forEach [0, 10, 30, 60, 120, 180, 300, 600, 900, 1200, 1800, 2700];
	} else {
		// NOTIFICATION 30 SECONDS AFTER WARMUP START
		_trg = [omtk_wu_scheduled_calls, [-1], (omtk_wu_time - (omtk_wu_time-30))] call KK_fnc_setTimeout;
		[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
		// NOTIFICATION 1 MIN BEFORE WARMUP END
		_trg = [omtk_wu_scheduled_calls, [60], (omtk_wu_time - 60)] call KK_fnc_setTimeout;
		[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
		// NOTIFICATION 10 SECONDS BEFORE WARMUP END
		_trg = [omtk_wu_scheduled_calls, [10], (omtk_wu_time - 10)] call KK_fnc_setTimeout;
		[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
	};
	// END WARMUP TRIGGER
	_trg = [omtk_wu_end_warmup_remote, [], omtk_wu_time] call KK_fnc_setTimeout;
	[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
	// VIEW DISTANCE SET AT FULL 4 MIN AFTER WARMUP END
	_trg = [omtk_wu_scheduled_calls, [-2], omtk_wu_time + 240] call KK_fnc_setTimeout;
	[_omtk_wu_notification_triggers, _trg] call BIS_fnc_arrayPush;
	
	missionNamespace setVariable ["omtk_wu_triggers", _omtk_wu_notification_triggers];
	publicVariableServer "omtk_wu_triggers";
};

if (hasInterface) then {
	_omtk_wu_is_completed = missionNamespace getVariable ["omtk_wu_is_completed", false];
	if (!_omtk_wu_is_completed) then {
		omtk_wu_spawn_location = getPos player;
		[] call omtk_wu_start_warmup;

		_class = typeOf player;
		if (_class in OMTK_WU_CHIEF_CLASSES) then {
			omtk_wu_com_menu_item_id = [player, "OMTK_END_WARMUP_COM_MENU", nil, nil, ""] call BIS_fnc_addCommMenuItem;
			if (call omtk_is_using_ACEmod) then {
				_action = ["OMTK_END_WARMUP","End Warm-up","omtk\warm_up\img\warm_up-end.paa",{[] call omtk_wu_set_ready;},{true;}] call ace_interact_menu_fnc_createAction;
				[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
			};
		};
	};
};

["warm_up end", "DEBUG", false] call omtk_log;
