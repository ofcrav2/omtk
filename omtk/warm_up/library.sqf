// Function called by restrict_area_trigger on clients only
omtk_wu_move_player_at_spawn_if_required = {
	_distance = (position player) distance omtk_wu_spawn_location;
	if (_distance > omtk_wu_radius) then {
		["teleport player '" + name player + "' back to his initial position", 'CHEAT', true] call omtk_log;
		player setPos omtk_wu_spawn_location;
	};
};

// Creation of the spawn marker. Marker gets deleted inside omtk_wu_end_warmup
omtk_wu_fn_show_zone = {
	_marker = createMarkerLocal ["SpawnZone", position player];
	"SpawnZone" setMarkerShapeLocal "ELLIPSE";
	"SpawnZone" setMarkerSizeLocal [omtk_wu_radius, omtk_wu_radius];
	"SpawnZone" setMarkerColorLocal "ColorOrange";
	"SpawnZone" setMarkerBrushLocal "Border";
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

	if (omtk_wu_marker == 1) then {
		[] call omtk_wu_fn_show_zone;
	};
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
	// Set flag used on engine handlers
	warmupOver = true;
	["wu_end_warmup fnc called", "DEBUG", false] call omtk_log;

	// On clients, reverts the changes applied by "wu_start_warmup" and by the "main.sqf" itself
	if (hasInterface) then {
	
		// [] call omtk_sim_enableVehicleSim;	// VEHICLE LOCK & SIM
		player allowDamage true;				// DAMAGE
		if ( omtk_wu_safety == 1 ) then {		// SAFETY OFF
			[] call omtk_disable_safety;
		};
		
		// Vehicle unfreeze, taken from ilbinek's IMF because i give up on life
		{
			// Remove engine freeze
			_x removeEventHandler ["Engine", (_x getVariable ["engineFrz", 0])];
		} forEach vehicles;
		
		deleteVehicle omtk_wu_restrict_area_trigger;
		
		// Deletion of marker created by omtk_wu_fn_show_zone
		if (omtk_wu_marker == 1) then {
			deleteMarkerLocal "SpawnZone";
		};

	};
	// On server, sets variable to prevent warmup for JIP players, 
	// unlocks vehicles and deletes AIs according to the parameter
	if (isServer) then {
		missionNamespace setVariable ["omtk_wu_is_completed", true];
		publicVariable "omtk_wu_is_completed";
		
		{
			_x allowDamage true;
		} forEach vehicles;
		
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
		if (_remainingTime > 0.002777) then {
			("[OMTK] warmup interrupted !") remoteExecCall ["systemChat"];
			o_wse set [1, (dayTime + 0.002777)];
			publicVariable "o_wse";
		};
	};
};
