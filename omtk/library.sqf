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

// OMTK simulation control functions

// Disables simulation and inventory access to all vehicles with simulation enabled (client side).
// Variable is used to later reenable only the vehicles disabled by this function.
omtk_sim_disableVehicleSim = {
	{
		if (simulationEnabled _x) then {
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
		systemChat format ["[OMTK] Your simulation will return in %1 seconds",_randRelease];
		sleep _randRelease;
		player enableSimulation true;
		systemChat "[OMTK] Player simulation REENABLED";
	} else {
		// otherwise it will reenable simulation only to the players belonging to the passed side ( "blufor", "opfor", "independent" )
		if ( side player == _actualSide ) then {
			systemChat format ["[OMTK] Your simulation will return in %1 seconds",_randRelease];
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