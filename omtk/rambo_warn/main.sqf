if (hasInterface) then {
	////////////
	//======================Lone Wolf Script Start====================== 
	////////////
	//TODO:
	//	How to define Parameter?
	//	Detect active "Ramboing", Initiate firefight while Lonewolfing 
	//		Playing with eventHandlers "Fired", to Flag Rambo;
	//		Report Triggered at 200m + safety margin (e.g. 20%)  = 220m.
	//	Start on Mission start.
	//	How to put in own SQF
	//	To Check: What about drones?
	//  Multi Language...
	////////////
	
	// Assign the code to the scheduler
	[] spawn {
		// Make the script start only when the mission starts
		waitUntil {sleep 1; time > 0};
		////////////
		//Variables to Set
		////////////	
		_omtk_rw_distance = ("OMTK_MODULE_RAMBO_DIST" call BIS_fnc_getParamValue);
		_omtk_rw_warn = ("OMTK_MODULE_RAMBO_WARN" call BIS_fnc_getParamValue);
		_omtk_rw_interval = ("OMTK_MODULE_RAMBO_INTERVAL" call BIS_fnc_getParamValue);
		
		private _AllowedInfantryDistance = 200+(200*_omtk_rw_distance/100);		//Infantry Lonewolfing: 100, 200, 300, 400, 500
		private _AllowedVehicleDistance  = 600+(600*_omtk_rw_distance/200);		//Vehcicle Lonewolfing: 200, 400, 600, 800, 1000
		private _IgnoreDistance			 = 1500;		//Ignore Distances further than
		private _CheckingInterval		 = _omtk_rw_interval;		//Checking Period (from parameter)
		private _GiveWarning			 = true;	//Give Warning On/Off
		if ( _omtk_rw_warn == 0 ) then {
			private _GiveWarning = false;
		};
		private _ReportToServer			 = true;	//Snitches get Stiches?
		private _WriteLocalRPT			 = true;	//Write in local rpt... could be exploited for cheating (notepad++ tail -f)
		private _LoneWolfDebug			 = false;	//Lot of stupid stuff, can be removed later

		
		
		////////////
		//Need to figure out how to start in game... sleep 30 also does it for me.
		////////////
		if(_LoneWolfDebug) then { systemChat format ["[LoneWolf] LoneWolfSleeping"]; };
		//sleep(30);																			
		if(_LoneWolfDebug) then { systemChat format ["[LoneWolf] LoneWolfActive"]; };
		
		////////////
		//Main Task
		////////////
		while {alive player} do { 																				//while alive? 
			private _UnitsInMySquad = units group player;														//Array of Squads
			private _BuddiesToFar=0;																			//Numbers of Players too far away
			private _BuddiesAlive=-1;																			//Numbers of Players alive; -1 hack as list contains player as well.
			
			private _SelfAlive  	= player call ace_common_fnc_isAwake;										//get state if dead or incap; Alive = True; Dead/Incap=False
			private _SelfOnFoot 	= isNull objectParent player;												//Check if Player himself is in vehicle 
			private _SelfInAircraft = vehicle player isKindOf "Plane" || vehicle player isKindOf "Helicopter"; 	//Check if Player himself is in Aircraft
			private _SelfCaptured 	= player getVariable ["ace_captives_isHandcuffed", false];					//Check if Player himself is Captured
			private _ArrayBuddiesTooFar = [];																	//Array for proper reporting 
		
			
			//Go through all Units in squad aka Buddy
			{
				private _BuddyDistance   = round ( player distance2D _x );										//get Distance to Player in rounded meter
				private _BuddyAlive      = _x call ace_common_fnc_isAwake;										//get state if dead or incap; Alive = True; Dead/Incap=False
				private _BuddyOnFoot     = isNull objectParent _x;												//get onFoot state, for simple Vehicle rule OnFoot = True; Vehicle = False
				private _BuddyInAircraft = vehicle _x isKindOf "Plane" || vehicle _x isKindOf "Helicopter";		//Check if Buddy is in Aircraft
				private _BuddyCaptured   = _x getVariable ["ace_captives_isHandcuffed", false];					//Check if Buddy is Captured
				private _BuddyisPlayer   = isPlayer _x;															//Check if Buddy is Player
				
				//Rule in Logic.. pretty simple; hard to understand how not to to follow:
				//Maybe there are things to optimize here, but for readability of the rules I keep it this way
				if (	( _BuddyAlive && _SelfAlive) &&															//Lonewolfing applies to alive Players/Buddies
						(!_SelfInAircraft  && !_BuddyInAircraft) &&												//where player and buddy are not in Aircraft
						(!_SelfCaptured && !_BuddyCaptured) &&													//where player and buddy are not captured		
						(_BuddyisPlayer || (!_BuddyisPlayer && _LoneWolfDebug)) &&								//where buddy is a real player
						(																
							(_SelfOnFoot   && _BuddyOnFoot  && ( _BuddyDistance > _AllowedInfantryDistance &&  _BuddyDistance < _IgnoreDistance))  ||	//Infantry exceeding short range
							(!_SelfOnFoot  && _BuddyOnFoot  && (_BuddyDistance > _AllowedVehicleDistance   &&  _BuddyDistance < _IgnoreDistance))  ||	//or Player in Vehicle exceed long range
							(!_BuddyOnFoot && _BuddyDistance > _AllowedVehicleDistance &&  _BuddyDistance <_IgnoreDistance ) 							//or Buddy in Vehicle  exceed long range
						)  
				   ) then
				{   
					_BuddiesToFar= _BuddiesToFar + 1;	//Count up if Unit is too far away
					//Setup String put into a Array. Will be output later:
					private _message1ToServer = format ["[LoneWolf] Player:%1 Buddy:%2 isPlayer:%3 Alive:%4 Captive:%5 OnFoot:%6 InAir:%7 -> Dist:%8m " ,name player, name _x, _BuddyisPlayer,  _BuddyAlive, _BuddyCaptured, _BuddyOnFoot , _BuddyInAircraft , _BuddyDistance];
					_ArrayBuddiesTooFar append [_message1ToServer];
					if(_LoneWolfDebug) then {diag_log _message1ToServer + " <==";}; 		//Report to local RPT, 
				}
				else{
					if(_LoneWolfDebug) then										//Report to local RPT
					{
						diag_log format ["[LoneWolf] Player:%1 Buddy:%2 isPlayer:%3 Alive:%4 Captive:%5 OnFoot:%6 InAir:%7 -> Dist:%8m" ,name player, name _x, _BuddyisPlayer,  _BuddyAlive, _BuddyCaptured, _BuddyOnFoot , _BuddyInAircraft , _BuddyDistance];  		//Debug stuff
					};
				};
				if(_BuddyAlive) then
				{
					_BuddiesAlive=_BuddiesAlive+1;		//Count up is Unit is still alive
				};
			
				
			} forEach _UnitsInMySquad ;   
			
			////////////
			// Lets check if Rules are broken.
			////////////
			// 1: All Buddies Dead or Incap | 2: 2 Lads are too far away | 3: last buddy is too far away
			if (alive player && side player != sideLogic) then {
				
				if ( _BuddiesAlive == 0 || (_BuddiesToFar >= 2 ) ||	(_BuddiesToFar == 1 && _BuddiesAlive == 1 )	) then {
					//Inform Player
					if((_GiveWarning || _LoneWolfDebug) && _BuddiesAlive > 0) then { 
						systemChat format ["[LoneWolf] You lost your lads!"]; 
					};
					
					if((_GiveWarning || _LoneWolfDebug) && _BuddiesAlive == 0) then { 
						systemChat format ["[LoneWolf] You're alone, join another squad!"]; 
					};
					
					
					
					private _message2ToServer = format ["[LoneWolf] Player %1 got flagged for rambo infringment;				_BuddiesTooFar: %2  _BuddiesAlive: %3 ",  name player, _BuddiesToFar, _BuddiesAlive
														];	
					//Report to Server Part#1			
					if(_ReportToServer) then {
						[_message2ToServer, 'CHEAT', false] remoteExecCall ["omtk_log",2,false];
					};
					//Report to local RPT
					if(_WriteLocalRPT) then {diag_log _message2ToServer};
					
					{					
						//Report to Server Part#2
						//if(_ReportToServer) then {[_x, 'CHEAT', false] remoteExecCall ["omtk_log",2,false]};
						//Report to local RPT
						if(_WriteLocalRPT)  then {diag_log _x};										
					}forEach _ArrayBuddiesTooFar;
					
				} else { 
					if (_LoneWolfDebug) then { systemChat format ["[LoneWolf] All fine"];	};		//Debug Thingy; remove later
				};
			};
			sleep(_CheckingInterval); 																//Wait for next Check
		};
		//======================Lone Wolf Script End====================== 
	};

};
