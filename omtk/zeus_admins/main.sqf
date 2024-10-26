["zeus_admins start", "DEBUG", false] call omtk_log;

// When an admin runs the module, it asks the server to please set up the zeus for him, for he is unable to.
// This should work JIP/rejoin too but i've got no idea.

// Server sets up and assigns the corresponding curator to the admin client that requested it
omtk_set_up_zeus = {
	if (!isServer) exitWith {};
	// UID is the connected admin wanting zeus
	_uid = (_this select 0);
	// pos is the position that the admin's UID holds in the variable "admin_uids"
	// which is used to ensure different admins are assigned different curators 
	_pos = (_this select 1);
	
	(missionCurators select _pos) setvariable ["text","cur_" + str(_pos)];     
	(missionCurators select _pos) setvariable ["Addons",3,true];//3: allow all addons with proper use of CfgPatches
	(missionCurators select _pos) setvariable ["owner","objnull"];  
	(missionCurators select _pos) setvariable ["vehicleinit","_this setvariable ['Addons',3,true]; _this setvariable ['owner','objnull'];"]; 
	unassignCurator (missionCurators select _pos);
	objnull assignCurator (missionCurators select _pos);
	// I've read online that this is needed
	sleep 1;
	unassignCurator (missionCurators select _pos);
	_uid assignCurator (missionCurators select _pos);
};



// Creates all curators on the server and adds them to the array for future use
if (isServer) then {
	CuratorLogicGroup = creategroup sideLogic;  
	
	cur_0 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_1 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_2 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_3 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_4 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_5 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_6 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_7 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_8 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	cur_9 = CuratorLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];
	
	missionCurators = [cur_0, cur_1, cur_2, cur_3, cur_4, cur_5, cur_6, cur_7, cur_8, cur_9];
};


// Checks if the player is an admin. If he IS an admin, requests server to add him as zeus
if (hasInterface) then {
		
	private _uid = getplayerUID player;
	
	admin_uids = missionNamespace getVariable ["admin_uids", 0];
	_pos = admin_uids find _uid;
	
	// If player is not an admin, _pos = -1; otherwise we assign the corresponding variable from missionCurators to the player
	if (_pos >= 0 ) then {	
		[player, _pos] remoteExec ["omtk_set_up_zeus", 2];
	};		
};


["zeus_admins end", "DEBUG", false] call omtk_log;