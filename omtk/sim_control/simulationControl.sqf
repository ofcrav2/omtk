/*
	Simulation Control
	
	The functions are defined in omtk\library.sqf
	This script has to be executed on server with the proper parameter
	
	Parameter:
		"dis" will disable simulation of both players and vehicles
		"enBlu", "enRed" and "enGreen" will enable simulation of the corresponding side's player
		"enAll" will enable simulation of all players
		"enVic" will enable simulation of all vehicles
*/
_mode = _this select 0;

if (isServer) then {
	// execute fncs disableSim on clients (but not server)
	if (_mode == "dis") then {
		[] remoteExec ["omtk_sim_disablePlayerSim", 0];
		[] remoteExec ["omtk_sim_disableVehicleSim", 0];
	};
	// execute fnc enablePlayerSim for blue side only on clients (gotta check if "" are needed for blufor)
	if (_mode == "enBlu") then {
		["blu",blufor] remoteExec ["omtk_sim_enablePlayerSim", 0];
	};
	// execute fnc enablePlayerSim for red side
	if (_mode == "enRed") then {
		["red",opfor] remoteExec ["omtk_sim_enablePlayerSim", 0];
	};
	// execute fnc enablePlayerSim for green side
	if (_mode == "enGreen") then {
		["green",independent] remoteExec ["omtk_sim_enablePlayerSim", 0];
	};
	// execute fnc enablePlayerSim for all clients
	if (_mode == "enAll") then {
		["all"] remoteExec ["omtk_sim_enablePlayerSim", 0];
		[] remoteExec ["omtk_sim_enableVehicleSim", 0];
	};
	// execute fnc enableVehicleSim
	if (_mode == "enVic") then {
		[] remoteExec ["omtk_sim_enableVehicleSim", 0];
	};
};