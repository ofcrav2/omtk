omtk_log = {
	private ["_msg", "_tag", "_chat"];
	_msg  = _this select 0;
	_tag = _this select 1;
	_chat = _this select 2;
	
	if (_chat) then { systemChat ('[OMTK] ' + _msg)};
	diag_log(text ('[OMTK] ' + _tag + ': ' + _msg));
};

omtk_fnc_addItem = {
	private ["_quantity", "_unit", "_item"];
	_unit = _this select 0;
	_quantity = _this select 1;
	_item = _this select 2;
			
	for "_i" from 1 to _quantity do {
		if (_unit canAdd _item) then {
			_unit addItem _item;
		} else {
			_class = typeOf _unit;
			["enable to add item '" + _item + "' to class '" + _class + "'","ERROR",true] call omtk_log;
		};	
	};
};

KK_fnc_setTimeout = {
	private "_tr";
	_tr = createTrigger [
		"EmptyDetector",
       	[0,0,0]
   	];
   	_tr setTriggerTimeout [
        _this select 2,
       	_this select 2,
       	_this select 2,
       	false
   	];
   	_tr setTriggerStatements [
        "true",
       	format [
            "deleteVehicle thisTrigger; %2 call %1", 
           	_this select 0,
           	_this select 1
       	],
       	""
   	];
   	_tr
};


//// teleport object to new location at ground level
// [_object, _location, _distance, _direction] call omtk_teleport;
// _object: the object to move
// _location: the new location to go
// _distance: the offset from the position in meter
// _direction: angle in degree to turn around the location
//
omtk_teleport = {
  _object = _this select 0;
  _location = _this select 1;
  _distance = _this select 2;
  _direction = _this select 3;
 
  _object SetPos [(_location select 0) - _distance * sin(_direction),(_location select 1) - _distance * cos(_direction)];
};


//// teleport an array of objects to a marker position
// [_objects, _markerName] call omtk_mkd_mass_teleport;
// _objects: array of objects
// _markerName: name of marker where to teleport
//
omtk_mkd_mass_teleport = {
    
  _distance = 2;
  _angle = 0;
  _round_limit = 360;
  {
    if (_angle >= _round_limit) then {
      _distance = _distance + 2;
      _angle = 0;
    };
    [_x, _this select 1, _distance, _angle] call omtk_teleport;
    _angle = _angle + 45;
   
  } forEach (_this select 0);
};

//// teleport an array of objects to a marker position
// [_objects, position, distance] call omtk_mass_teleport;
// _objects: array of objects
// position:  position array to teleport to
// distance: distance in-between objects new locations
//
omtk_mass_teleport = {

	_distance = _this select 2;
	_angle = 0;
  _round_limit = 360;
  {
    if (_angle >= _round_limit) then {
      _distance = _distance + (_this select 2);
      _angle = 0;
    };
    [_x, _this select 1, _distance, _angle] call omtk_teleport;
    _angle = _angle + 45;
  } forEach (_this select 0);
};

omtk_rollback_to_start_time = {
	_omtk_wu_start_time = missionNamespace getVariable ["omtk_wu_start_time", missionStart select [0,5]];
	setDate (_omtk_wu_start_time);
};

omtk_get_side = {
	_side = "";
	switch(_this select 0) do {
	    	case east: { _side = "redfor"; };
   			case west: { _side = "bluefor"; };
			default    { ["unknown side '" + str(side player) + "'", "ERROR", false] call omtk_log; };
	};
	_side;
};


omtk_is_using_ACEmod = {
	isClass(configFile >> "CfgPatches" >> "ace_main");
};

// Unlocks vehicles server side and enables damage
omtk_unlock_vehicles = {
	{
		_locked_by_omtk = _x getVariable ["omtk_lock", 0];
		if (_locked_by_omtk > 0) then {
			_x lock 0;
			_x lockCargo false;
			_x allowDamage true;
		};
	} foreach vehicles;
};

// Locks vehicles server side and disables damage. 
// Variable is used to later unlock only the vehicles locked by this function.
omtk_lock_vehicles = {
	{
		if ( (locked _x) < 2) then {
			_x lock 2;
			_x lockCargo true;
			_x allowDamage false;
			_x setVariable ['omtk_lock', 1];
		};
	} foreach vehicles;
};

omtk_delete_playableAiUnits = { 
	{
		if (!isPlayer _x) then { 
			deleteVehicle _x; 
		}; 
	} forEach playableUnits;
};

omtk_disable_aiBehaviour = {
	if (isServer) then {
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
		} forEach playableUnits;
	};
};

omtk_enable_playerDamage = {
	if (hasInterface) then {
		player allowDamage true;
	};
};

// OMTK simulation control functions

// Disables simulation and inventory access to all vehicles with simulation enabled (client side).
// Variable is used to later reenable only the vehicles disabled by this function.
omtk_sim_disableVehicleSim = {
	{
		_crewNum = count fullCrew[_x,"",true];	// Number of crew of vehicle (including empty seats)
		if (simulationEnabled _x && _crewNum > 0) then {
			_x enableSimulation false;
			_x lockInventory true;
			_x setVariable ['omtk_disabled_sim', 1];
		};

	} forEach vehicles;
	systemChat "[OMTK] Vehicle simulation DISABLED";
	if (vehicle player != player) then {
		systemChat " ** You'll be stuck until the vehicle simulation is reenabled **";
	};
};

// Enables vehicles' sim and inventory client side
omtk_sim_enableVehicleSim = {
	{
		_sim_dis_by_omtk = _x getVariable ["omtk_disabled_sim", 0];
		
		if (_sim_dis_by_omtk > 0) then {
			_x enableSimulation true;
			_x lockInventory false;
		};

	} forEach vehicles;
	systemChat "[OMTK] Vehicles simulation and inventory REENABLED";
};

// Disables simulation to all players except for the server admin (logged in)
omtk_sim_disablePlayerSim = {
	if (call BIS_fnc_admin != 2) then {
		player enableSimulation false;
	};
	systemChat "[OMTK] Player simulation DISABLED";
	_omtk_sim_txt = format ["<t shadow='1' shadowColor='#A6051A'>- PLAYER SIM DISABLED and WEAPON SAFETY ENABLED -</t><br/>Please hold until weapon safety is removed<br/>while the server takes a breather"];
	[_omtk_sim_txt,0,0,15,2] spawn BIS_fnc_dynamicText;
	setViewDistance 200;
	[] call omtk_enable_safety;
	sleep 90;
	[] call omtk_disable_safety;
	
	
};

// Enables simulation to players depending on the parameters
// Parameters:
//  _sideMode  : "all" will enable simulation to all players and vehicles, otherwise it will check
//  _actualSide: enabling simulation for all players of that particular side.  
omtk_sim_enablePlayerSim = {
	_sideMode = _this select 0;
	_actualSide = _this select 1;
	private _randRelease = (random 15) + 1;
    
	// parameter being "all" will reenable simulation to all the players at once
	if (_sideMode == "all") then {
		systemChat format ["[OMTK] YOUR SIMULATION WILL RETURN IN %1 seconds",_randRelease];
		sleep _randRelease;
		player enableSimulation true;
		systemChat "[OMTK] Player simulation REENABLED";
	} else {
		// otherwise it will reenable simulation only to the players belonging to the passed side ( "blufor", "opfor", "independent" )
		if ( side player == _actualSide ) then {
			systemChat format ["[OMTK] YOUR SIMULATION WILL RETURN IN %1 seconds",_randRelease];
			sleep _randRelease;
			player enableSimulation true;
			systemChat "[OMTK] Player simulation REENABLED (for your side)";
		};
	};
	
};

// Has to be remotely called on clients from server
// Parameters:
//  _viewDistMode: "reset" will set the view dist back to the parameter value. Otherwise
//  _newViewDist : a value between 200 and 10000 -> changes the view distance to said value
omtk_viewdistance_change = {
	_viewDistMode = _this select 0;
	_newViewDist = _this select 1;
	if (_viewDistMode == "reset") then {
		_newViewDist = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);
	};

	if (_newViewDist >= 200 && _newViewDist <= 10000) then {
		setViewDistance _newViewDist;
		systemChat format ["[OMTK] View Distance changed to %1",_newViewDist];
	};
};

omtk_teleport_unit = {
	_name = _this select 0;
	_name2 = _this select 1;

	if (_name == name player) then {
		_playerObject = allPlayers select ( allPlayers findIf {(name _x) isEqualTo _name2;} );
		player setPos (_playerObject modelToWorld [0,0,1]);
	};
};

omtk_warn_unit = {
	_name = _this select 0;

	if (_name == name player) then {
		titleText ["<t color='#ff0000' size='5'>YOU ARE LONEWOLFING! RETURN TO YOUR SQUAD LEADER!</t><br/>", "PLAIN", 1, true, true];
		_omtk_wpnSafety = player getVariable ["omtk_weaponsafety", 0];
		_omtk_wpnSafety = player addAction ["Weapon safety on", {hintSilent "Safety On";}, [], 0, false, false, "DefaultAction", ""];
		player setVariable ["omtk_weaponsafety", _omtk_wpnSafety];
		sleep 11;
		player removeAction _omtk_wpnSafety;
		player setVariable ["omtk_weaponsafety", 0];
	};
};

omtk_respawn_unit = {
	_name = _this select 0;

	if (_name == name player) then {
		setPlayerRespawnTime 2;
		sleep 3;
		setPlayerRespawnTime 9999;

		loadout = player getVariable ["playerLoadout", 0];
		player setUnitLoadout [loadout, true];
	};
};

omtk_disable_ti = {
	if (isServer) then {
		{
			_x disableTIEquipment true;
		} foreach vehicles;
	};
};

omtk_enable_safety = {
	_omtk_wpnSafety = 0;
	_omtk_wpnSafety = missionNamespace getVariable ["omtk_weaponsafety", 0];
	if ( _omtk_wpnSafety == 0 ) then {
		_omtk_wpnSafety = player addAction ["Weapon safety on", {hintSilent "Safety On";}, [], 0, false, false, "DefaultAction", ""];	
		systemChat "[OMTK] Weapon Safety Enabled";
		
		missionNamespace setVariable ["omtk_weaponsafety", _omtk_wpnSafety];
	};
};

omtk_disable_safety = {
	_omtk_wpnSafety = 0;
	_omtk_wpnSafety = missionNamespace getVariable ["omtk_weaponsafety", 0];
	if ( _omtk_wpnSafety != 0 ) then {
		player removeAction _omtk_wpnSafety;	
		systemChat "[OMTK] Weapon Safety Disabled";
		missionNamespace setVariable ["omtk_weaponsafety", 0];
		_omtk_sim_txt = format ["<t shadow='1' shadowColor='#A6051A'>- WEAPON SAFETY DISABLED -</t><br/>Continue the fight!"];
		[_omtk_sim_txt,0,0.2,10,3] spawn BIS_fnc_dynamicText;
		
	};
};

omtk_set_viewdistance = {
	params ["_settings"];
	_max = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);
	_newViewDist = _max;
	if (_settings == 1) then {
		_newViewDist = _max;
	};

	if (_settings == 2) then {
		_newViewDist = (_max / 2)
	};

	if (_settings == 3) then {
		_newViewDist = (_max / 4) min 500;
	};

	setViewDistance _newViewDist;
};
