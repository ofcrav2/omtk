/* 	[omtk] warm_up Module:
 *	- Initialises the chief classes for the "Side is ready" action, all the parameters and some variables used in multiple functions
 *	- Defines 7 functions, 3 are server-only, 3 are client-only and 1 is used by both
 *	- Begins warmup procedure on clients and server.
 *	******
 *	Warmup Procedure (Server):
 *	- Removes fuel from vehicles
 *	- Sets up several triggers, each using function "omtk_wu_scheduled_calls" to give hints to the players of remaining warmup time and change view distance.
 *	- Sets up one final trigger that runs "omtk_wu_end_warmup_remote" function, used to launch the actual "omtk_wu_end_warmup" function on all clients and itself
 *	******
 *	Warmup Procedure (Client):
 *	- Checks that the warmup is still ongoing using "omtk_wu_is_completed" variable 
 *	- Saves starting position and adds "Side is ready" action to chief classes
 *	- Runs "omtk_wu_start_warmup" function, which makes players immortal, sets the view distance to 500, creates the trigger that restricts movement area
 *	  creates a notification displaying warmup information to all players, and removes simulation to players for a short while at warmup start.
 *	- The restrict area trigger uses function "omtk_wu_move_player_at_spawn_if_required" that simply moves players to their original position after 5 seconds
 *	  of leaving the trigger, if they haven't returned back into it.
 *	******
 *	Warmup Procedure (Both):
 *	- "omtk_wu_end_warmup" function will then prepare both the server and the client for the actual game:
 *	- Client side, it makes players mortal, removes the "Side is ready" action and eventually disables safety
 * 	- Server side it sets the variable "omtk_wu_is_completed", restores fuel to vehicles, eventually removes unused AIs and proceeds to load modules such as score_board and ti
 *	******
 *	- Fnc "omtk_wu_fn_launch_game" ran on the server will delete all current notification and warmup end triggers replacing them with a couple that will  
 *	  achieve the same result but in 30 seconds' time (30 and 10 seconds warnings and end warmup remote)
 *	- Fnc "omtk_wu_set_ready", if launched by officers of both sides, will execute the above function, cutting warmup short. 
 *	  
 *
 */

["warm_up start", "DEBUG", false] call omtk_log;


// Retrieve parameters
omtk_wu_time = ("OMTK_MODULE_WARM_UP" call BIS_fnc_getParamValue);
omtk_wu_radius = ("OMTK_MODULE_WARM_UP_DISTANCE" call BIS_fnc_getParamValue);
omtk_disable_playable_ai = ("OMTK_MODULE_DISABLE_PLAYABLE_AI" call BIS_fnc_getParamValue);
omtk_view_distance = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);
omtk_wu_safety = ("OMTK_MODULE_WARM_UP_SAFETY" call BIS_fnc_getParamValue);

omtk_wu_restrict_area_trigger = nil;
omtk_wu_com_menu_item_id = 0;

// Function called by restrict_area_trigger on clients only
omtk_wu_move_player_at_spawn_if_required = {
	_distance = (position player) distance omtk_wu_spawn_location;
	if (_distance > omtk_wu_radius) then {
		["teleport player '" + name player + "' back to his initial position", 'CHEAT', true] call omtk_log;
		player setPos omtk_wu_spawn_location;
	};
};

// Creation of the "restrict_area_trigger" that'll call "move_player_at_spawn_if_required" fnc.
omtk_wu_restrict_area = {
	omtk_wu_restrict_area_trigger = createTrigger ["EmptyDetector", omtk_wu_spawn_location, false];
	omtk_wu_restrict_area_trigger setTriggerArea [omtk_wu_radius, omtk_wu_radius, 0, false];
	omtk_wu_restrict_area_trigger setTriggerActivation [format["%1", side player], "NOT PRESENT", true];	// probably useless
	_trg_out_action = "['Leaving spawn location', 'INFO'] call omtk_log;
	hint 'GO BACK TO YOUR POSITION!';
	[omtk_wu_move_player_at_spawn_if_required, [], 5] call KK_fnc_setTimeout;";
	// The trigger deactivates upon players (or the vehicle they're in) not being in the zone. Deactivation triggers the hint and the function to teleport the player back.
	// Upon reactivation, the hintSilent removes the warning.
	omtk_wu_restrict_area_trigger setTriggerStatements ["player in thisList || vehicle player in thisList", "hintSilent '';", _trg_out_action];
};

// Creating and displaying notification text with warmup length
omtk_wu_display_warmup_txt = {
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
};

// Fnc remotely executed by the server on every client and server at the end of warmup
omtk_wu_end_warmup = {
	["wu_end_warmup fnc called", "DEBUG", false] call omtk_log;
	// On clients, reverts the changes applied by "wu_start_warmup" and by the "main.sqf" itself
	if (hasInterface) then {
	
		// [] call omtk_sim_enableVehicleSim;	// VEHICLE LOCK & SIM
		player allowDamage true;				// DAMAGE
		if ( omtk_wu_safety == 1 ) then { 		// SAFETY OFF
			[] call omtk_disable_safety;
		};
		
		// Vehicle unfreeze, taken from ilbinek's IMF because i give up on life
		{			
			// Remove engine freeze
			_x removeEventHandler ["Engine", (_x getVariable ["engineFrz", 0])];
		} forEach vehicles;
		
		deleteVehicle omtk_wu_restrict_area_trigger;

	};
	// On server, sets variable to prevent warmup for JIP players, 
	// unlocks vehicles and deletes AIs according to the parameter
	if (isServer) then {
		missionNamespace setVariable ["omtk_wu_is_completed", true];
		publicVariable "omtk_wu_is_completed";
		
		if (omtk_disable_playable_ai == 1) then {
			call omtk_delete_playableAiUnits;
		}
		
	};
	
	// Continue to load modules...
	call omtk_load_post_warmup;
};

omtk_wu_fn_launch_game = {
	_omtk_wu_is_completed = missionNamespace getVariable ["omtk_wu_is_completed", false];
	if (isServer && !_omtk_wu_is_completed) then {
		_remainingTime = (o_wse select 1) - dayTime;
		if (_remainingTime > 0.008333) then {
			("[OMTK] warmup interrupted !") remoteExecCall ["systemChat"];
			o_wse set [1, (dayTime + 0.008333)];
			publicVariable "o_wse";
		};
	};
};


// Creates scheduled fnc calls for notifications and for wu_end_warmup_remote and
// makes them public for deletion by wu_launch_game. Vehicle lock moved to client side fnc
if (isServer) then {
		
	[] spawn {
		
		waitUntil { time > 0 };
		_startDate = o_wse select 0;
		// This way, _startTime is in the same format as "dayTime" (hours)
		_startTime = _startDate select 3 + (_startDate select 4)/60;
		// realDayTime used to manage when warmup crosses midnight
		_realDayTime = dayTime;
		
		_stopWarmup = false;
		
		while { sleep 2 ; !_stopWarmup} do {				
			// Means we went from 23.999 to 0
			if (dayTime < _realDayTime) then {
				//realDayTime continues the same way
				_realDayTime = dayTime + 24;
			} else {
				_realDayTime = dayTime;
			};
			_warmupEnd = o_wse select 1;
			
			if (_realDayTime > _warmupEnd) then {
				_stopWarmup = true;
			};
			
			hint format ["Start time: %1 , Warmup end: %2, DayTime: %3, Realdaytime: %4, _stopWarmup: %5", _startTime, _warmupEnd, dayTime, _realDayTime, _stopWarmup];
		};
		
		[] remoteExec ["omtk_wu_end_warmup", 0, true];
	};
};

if (hasInterface) then {
	_omtk_wu_is_completed = missionNamespace getVariable ["omtk_wu_is_completed", false];
	if (!_omtk_wu_is_completed) then {
		omtk_wu_spawn_location = getPos player;
		
		player enableSimulation false;			// PLAYER SIM
		player allowDamage false;				// DAMAGE
		setViewDistance 500;					// VIEW DISTANCE
		warmupOver = false;
		if ( omtk_wu_safety == 1 ) then { 		// SAFETY ON
			[] call omtk_enable_safety;
		};
		
		// Vehicle freeze, taken from ilbinek's IMF because i give up on life
		// Takes care of disabling the engine during the warmup
		{		
			// if vehicle changes engine state to on, turn it off
			_handler = _x addEventHandler ["Engine", {
				_car = _this select 0;
				_engineOn = _this select 1;
				if ((!warmupOver) and local _car and _engineOn) then {
					player action ["engineoff", _car];
					_car engineOn false;
				};
			}];
			_x setVariable ["engineFrz", _handler];
		} forEach vehicles;
		
		[] call omtk_wu_restrict_area;
		
		[] call omtk_wu_display_warmup_txt;
		
		
		[] spawn {
		
			waitUntil { time > 0 };
			_startDate = o_wse select 0;
			// This way, _startTime is in the same format as "dayTime" (hours)
			_startTime = _startDate select 3 + (_startDate select 4)/60;
			// realDayTime used to manage when warmup crosses midnight
			_realDayTime = dayTime;
			_vdCheck = false;
			_stopWarmup = false;
			
			disableSerialization; 
			19998 cutRsc ["timerClass","PLAIN"];  
			_timerGui = uiNamespace getVariable "timerDiag"; 
			_timerTxt = _timerGui displayCtrl 1322;
			
			while { sleep 0.5 ; !_stopWarmup} do {				
				// Means we went from 23.999 to 0 (day change happens during warmup)
				if (dayTime < _realDayTime) then {
					// realDayTime continues as 24.xxxx, just as _warmupEnd presumably will
					_realDayTime = dayTime + 24;
				} else {
					_realDayTime = dayTime;
				};
				_warmupEnd = o_wse select 1;
				
				if (_realDayTime > _warmupEnd) then {
					_stopWarmup = true;
				} else {
					// 15 seconds remaining in warmup - fixes view distance
					if (_warmupEnd - _realDayTime < 0.00416 && !_vdCheck) then { 
						setViewDistance(omtk_view_distance);
						systemChat("[OMTK] View distance raised to full view distance");
						_vdCheck = true;
					};
					
					// Displaying time remaining on screen
					_mins = floor( (_warmupEnd - dayTime) * 60);
					_secs = floor((((_warmupEnd - dayTime) * 60) - _mins) * 60);	
					if(_secs < 10) then {
					   _secs = format ["0%1", _secs];
					};
					if(_mins < 10) then {
					   _mins = format ["0%1", _mins];
					};
					_formatted_time = format ["%1:%2", _mins, _secs];
					_timerTxt ctrlSetText _formatted_time;
					
				};
			};
			
			19998 cutText["","PLAIN"];
		};
		
		// PLAYER SIM RE-ENABLE TIMER
		private _randRelease = (random 6) + 1;
			
		systemChat format ["[OMTK] Your simulation will be disabled for %1 seconds after launch",_randRelease];
		sleep 1;
		systemChat format ["[OMTK] Your simulation will be disabled for %1 seconds after launch",_randRelease];
		sleep (_randRelease - 1);
		
		player enableSimulation true;
	};
};

["warm_up end", "DEBUG", false] call omtk_log;