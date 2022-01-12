////// OMTK CONFIGURATION

// Debug logs introduce to highlight execution order
["Init start" , "DEBUG", false] call omtk_log;

// tactical_paradrop: area restriction (optional)
OMTK_TP_BLUEFOR_RESTRICTIONS = [
  //[x_coordinate, y_coordinate, radius_in_m],
];

OMTK_TP_REDFOR_RESTRICTIONS = [
  //[x_coordinate, y_coordinate, radius_in_m],
];

// tactical_paradrop: delay before enabling paradrop feature (optional)
OMTK_TP_BLUEFOR_DELAY = 0; // delay in seconds
OMTK_TP_REDFOR_DELAY = 0; // delay in seconds

// score_board: objectives, mission duration and helilock
// OMTK_SB_MISSION_DURATION_OVERRIDE = [0, 0, 0]; // [hours, minutes, seconds]

// unlock_helis: to unlock the helicopters after a certain amount of time AFTER warmup ends.
// for it to work, lock the helicopters from editor and make sure their variable name is in the list below.
// the time is the # of seconds AFTER warmup ends
OMTK_SB_UNLOCK_HELI_VARS = ["heli01","heli02","heli03","heli04"];
OMTK_SB_UNLOCK_HELI_TIME = 600;

execVM "customScripts.sqf";

["Init before list objectifs" , "DEBUG", false] call omtk_log;

// Complete example list can be found here: https://github.com/ofcrav2/omtk/tree/master/omtk/score_board
OMTK_SB_LIST_OBJECTIFS = [

];

OMTK_LM_BLUEFOR_OB = [
];

OMTK_LM_REDFOR_OB = [
];

["Init before special configuration" , "DEBUG", false] call omtk_log;

////// SPECIAL CONFIGURATION
setTerrainGrid 3.125;

OMTK_WARMUP_MENU = [
	["OMTK MENU", true],
	["Warmup: side is ready", [2], "", -5, [["expression", "[] call omtk_wu_set_ready;"]], "1", "1"]
];

OMTK_MARKERS_MENU = [
	["OMTK MENU", true],
	["Process markers", [2], "", -5, [["expression", "[] call omtk_ds_process_markers_mode;"]], "1", "1"]
];

// EXTERNAL ADDONS
RscSpectator_allowFreeCam = true;
//cutrsc ['RscSpectator','plain'];
if (("OMTK_MODULE_LIGHT_VERSION" call BIS_fnc_getParamValue) < 1) then {
	[player, [missionNamespace, "OMTK_LOADOUT"]] call BIS_fnc_saveInventory;
};
["Init before omtk execution" , "DEBUG", false] call omtk_log;

//// OMTK EXECUTION
execVM "omtk\load_modules.sqf";
// Création briefing
if (hasInterface) then {

	execVM "omtk\briefing.sqf";
	execVM "omtk\fn_inventoryBriefing.sqf";
	execVM "omtk\fn_rosterBriefing.sqf";
};

// Logging des joueurs sur le serveur
onPlayerConnected {[ _name + " - " + _uid, "CONNECT", false] call omtk_log};
onPlayerDisconnected {[ _name + " - " + _uid, "DISCONNECT", false] call omtk_log};

["Init end" , "DEBUG", false] call omtk_log;
