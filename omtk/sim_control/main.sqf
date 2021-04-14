/*
	Simulation Control
	
	Adds the ace options to the logged admin
*/

if (call omtk_is_using_ACEmod && call BIS_fnc_admin == 2) then {
	_action = ["BaseControl","Simulation Control","",{},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	
	_action1 = ["DisableSim","Disable Simulation","", {
		[] remoteExec ["omtk_sim_disablePlayerSim", 0];
		[] remoteExec ["omtk_sim_disableVehicleSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action1] call ace_interact_menu_fnc_addActionToObject;
	
	_action2 = ["EnableSim","Enable Simulation ALL","", {
		["all"] remoteExec ["omtk_sim_enablePlayerSim", 0];
		[] remoteExec ["omtk_sim_enableVehicleSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action2] call ace_interact_menu_fnc_addActionToObject;
	
	_action3 = ["EnableSimBlue","Enable Simulation BLUEFOR","", {
		["blu",blufor] remoteExec ["omtk_sim_enablePlayerSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action3] call ace_interact_menu_fnc_addActionToObject;
	
	_action4 = ["EnableSimRed","Enable Simulation REDFOR","", {
		["red",opfor] remoteExec ["omtk_sim_enablePlayerSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action4] call ace_interact_menu_fnc_addActionToObject;
	
	_action5 = ["EnableSimGreen","Enable Simulation GREENFOR","", {
		["green",independent] remoteExec ["omtk_sim_enablePlayerSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action5] call ace_interact_menu_fnc_addActionToObject;
	
	_action6 = ["EnableSimVic","Enable Simulation VEHICLES","", {
		[] remoteExec ["omtk_sim_enableVehicleSim", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseControl"], _action6] call ace_interact_menu_fnc_addActionToObject;
	
	
	_viewaction = ["BaseView","View Distance Control","",{},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _viewaction] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction1 = ["ResetView","Reset View Distance","", {
		["reset",1] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction1] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction2 = ["ViewMin","Set View Distance: 200","", {
		["set",200] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction2] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction21 = ["ViewMidLow","Set View Distance: 600","", {
		["set",600] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction21] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction3 = ["ViewMid","Set View Distance: 1000","", {
		["set",1000] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction3] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction4 = ["ViewMidHigh","Set View Distance: 2000","", {
		["set",2000] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction4] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction5 = ["ViewHigh","Set View Distance: 3000","", {
		["set",3000] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction5] call ace_interact_menu_fnc_addActionToObject;
	
	_viewaction6 = ["ViewVeryHigh","Set View Distance: 4000","", {
		["set",4000] remoteExec ["omtk_viewdistance_change", 0];
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","BaseView"], _viewaction6] call ace_interact_menu_fnc_addActionToObject;
};
