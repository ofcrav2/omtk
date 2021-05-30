/*
	Admin Ui
	
	Adds the ace options to the logged admin
*/


if (call omtk_is_using_ACEmod && call BIS_fnc_admin == 2) then {

	_adminMenu = ["AdmMenu","Open Admin Menu","", {
		_ok = createDialog "AdminMenuTest";
	},{true;}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _adminMenu] call ace_interact_menu_fnc_addActionToObject;
	
};
