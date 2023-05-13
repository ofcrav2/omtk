params ["_display"];

// Show uniform fix
buttonuniform_Bug = _display ctrlCreate ["omtk_RscButton", 1201];
buttonuniform_Bug ctrlsetPosition [
    0.9 * safeZoneW + safeZoneX,
    0.8 * safeZoneH + safeZoneY,
    0.07 * safeZoneW,
    0.03 * safeZoneH
];
buttonuniform_Bug ctrlCommit 0;
buttonuniform_Bug ctrlsettext "Fix uniform Bug";
buttonuniform_Bug ctrlsetBackgroundColor [1.0, 0.2, 0.2, 1];
buttonuniform_Bug ctrlAddEventHandler ["Buttondown", {
    if not (isNull (vestContainer player)) then
    {
        private ["_vest", "_vestItems", "_vestmagaiznes"];
        _vest = vest player;
        _vestItems = vestItems player;
        _vestmagaiznes = magazinesAmmoCargo (vestContainer player);
        removevest player;
        
        player addvest _vest;
        {
            if not (isClass (configFile >> "cfgmagazines" >> _x)) then
            {
                player addItemtovest _x;
            };
        } forEach _vestItems;
        {
            (vestContainer player) addMagazineammoCargo [_x select 0, 1, _x select 1];
        } forEach _vestmagaiznes;
    };
    
    // ===========================
    
    if not (isNull (uniformContainer player)) then
    {
        private ["_uniform", "_uniformItems", "_uniformmagaiznes"];
        _uniform = uniform player;
        _uniformItems = uniformItems player;
        _uniformmagaiznes = magazinesAmmoCargo (uniformContainer player);
        removeuniform player;
        
        player forceAdduniform _uniform;
        {
            if not (isClass (configFile >> "cfgmagazines" >> _x)) then
            {
                player addItemtouniform _x;
            };
        } forEach _uniformItems;
        
        {
            (uniformContainer player) addMagazineammoCargo [_x select 0, 1, _x select 1];
        } forEach _uniformmagaiznes;
    };
}];

buttonViewDist1 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonViewDist1 ctrlsetPosition [
    0.9 * safeZoneW + safeZoneX,
    0.7 * safeZoneH + safeZoneY,
    0.07 * safeZoneW,
    0.03 * safeZoneH
];
buttonViewDist1 ctrlCommit 0;
buttonViewDist1 ctrlsettext "Short View distance";
buttonViewDist1 ctrlsetBackgroundColor [0.7, 0.7, 0.7, 1];
buttonViewDist1 ctrlAddEventHandler ["Buttondown", {
    [3] call omtk_set_viewDistance;
}];

buttonViewDist2 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonViewDist2 ctrlsetPosition [
    0.8 * safeZoneW + safeZoneX,
    0.7 * safeZoneH + safeZoneY,
    0.07 * safeZoneW,
    0.03 * safeZoneH
];
buttonViewDist2 ctrlCommit 0;
buttonViewDist2 ctrlsettext "Medium View distance";
buttonViewDist2 ctrlsetBackgroundColor [0.7, 0.7, 0.7, 1];
buttonViewDist2 ctrlAddEventHandler ["Buttondown", {
    [2] call omtk_set_viewDistance;
}];

buttonViewDist3 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonViewDist3 ctrlsetPosition [
    0.7 * safeZoneW + safeZoneX,
    0.7 * safeZoneH + safeZoneY,
    0.07 * safeZoneW,
    0.03 * safeZoneH
];
buttonViewDist3 ctrlCommit 0;
buttonViewDist3 ctrlsettext "Long View distance";
buttonViewDist3 ctrlsetBackgroundColor [0.7, 0.7, 0.7, 1];
buttonViewDist3 ctrlAddEventHandler ["Buttondown", {
    [1] call omtk_set_viewDistance;
}];

private _uid = getplayerUID player;

/*
76561198004582151 - Manchot
76561197968544972 - Flip4flap
76561198089279362 - PHK4900
76561198106536334 - Nasa
76561197969410208 - Daedalus
76561198059014268 - MrWhite350
*/
// if not admin, exit
if !(serverCommandAvailable "#kick" or _uid == "76561198004582151" or	_uid == "76561197968544972" or _uid == "76561198089279362" or _uid == "76561198106536334" or _uid == "76561197969410208" or	_uid == "76561198059014268") exitwith {};

_name = _display ctrlCreate["ctrlEdit", 10002];
_name ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.01 * safeZoneH + safeZoneY,
    0.16 * safeZoneW,
    0.04 * safeZoneH
];
_name ctrlsetBackgroundColor [0, 0, 0, 0.8];
_name ctrlCommit 0;

_name2 = _display ctrlCreate["ctrlEdit", 10003];
_name2 ctrlsetPosition [
    0.655 * safeZoneW + safeZoneX,
    0.01 * safeZoneH + safeZoneY,
    0.16 * safeZoneW,
    0.04 * safeZoneH
];
_name2 ctrlsetBackgroundColor [0, 0, 0, 0.8];
_name2 ctrlCommit 0;

_playerlist = _display ctrlCreate[ "ctrllistbox", 10000 ];
_playerlist ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.05 * safeZoneH + safeZoneY,
    0.16 * safeZoneW,
    0.15 * safeZoneH
];
_playerlist ctrlCommit 0;

_playerlist lbAdd "===WHO===";
_playerlist lbAdd "===blufor===";
{
    _playerlist lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == west
});

_playerlist lbAdd "===opfor===";
{
    _playerlist lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == east
});

_playerlist lbAdd "===independent===";
{
    _playerlist lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == independent
});

_playerlist lbsetCurSel 0;

_playerlist2 = _display ctrlCreate[ "ctrllistbox", 10001 ];
_playerlist2 ctrlsetPosition [
    0.655 * safeZoneW + safeZoneX,
    0.05 * safeZoneH + safeZoneY,
    0.16 * safeZoneW,
    0.15 * safeZoneH
];
_playerlist2 ctrlCommit 0;

_playerlist2 lbAdd "===WHERE===";
_playerlist2 lbAdd "===blufor===";
{
    _playerlist2 lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == west
});

_playerlist2 lbAdd "===opfor===";
{
    _playerlist2 lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == east
});

_playerlist2 lbAdd "===independent===";
{
    _playerlist2 lbAdd name _x;
} forEach (allplayers select {
    side (group _x) == independent
});

_playerlist2 lbsetCurSel 0;

_kickButton = _display ctrlCreate ["omtk_RscButton", 1201];
_kickButton ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.20 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
_kickButton ctrlCommit 0;
_kickButton ctrlsettext "Teleport player";
_kickButton ctrlsetBackgroundColor [0.2, 0.2, 0.8, 1];
_kickButton ctrlAddEventHandler ["Buttondown", {
    params[ "_kickButton" ];
    
    _playerlist = ctrlParent _kickButton displayCtrl 10000;
    _selectedindex = lbCurSel _playerlist;
    _selected = _playerlist lbtext _selectedindex;
    
    _playerlist2 = ctrlParent _kickButton displayCtrl 10001;
    _selectedindex = lbCurSel _playerlist2;
    _selected2 = _playerlist2 lbtext _selectedindex;
    
    [_selected, _selected2] remoteExec ['omtk_teleport_unit', 0];
}];

_warnButton = _display ctrlCreate ["omtk_RscButton", 1201];
_warnButton ctrlsetPosition [
    0.558 * safeZoneW + safeZoneX,
    0.20 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
_warnButton ctrlCommit 0;
_warnButton ctrlsettext "Warn lonewolf";
_warnButton ctrlsetBackgroundColor [0.2, 0.2, 0.8, 1];
_warnButton ctrlAddEventHandler ["Buttondown", {
    params[ "_warnButton" ];
    
    _playerlist = ctrlParent _warnButton displayCtrl 10000;
    _selectedindex = lbCurSel _playerlist;
    _selected = _playerlist lbtext _selectedindex;
    
    [_selected] remoteExec ['omtk_warn_unit', 0];
}];

_respawnButton = _display ctrlCreate ["omtk_RscButton", 1201];
_respawnButton ctrlsetPosition [
    0.621 * safeZoneW + safeZoneX,
    0.20 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
_respawnButton ctrlCommit 0;
_respawnButton ctrlsettext "Respawn";
_respawnButton ctrlsetBackgroundColor [0.2, 0.2, 0.8, 1];
_respawnButton ctrlAddEventHandler ["Buttondown", {
    params[ "_respawnButton" ];
    
    _playerlist = ctrlParent _respawnButton displayCtrl 10000;
    _selectedindex = lbCurSel _playerlist;
    _selected = _playerlist lbtext _selectedindex;
    
    [_selected] remoteExec ['omtk_respawn_unit', 0];
}];

// * SIMULATION CONTROL */

// picture of Simulation Control
simControlpic = _display ctrlCreate ["omtk_Rscpicture", 1201];
simControlpic ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.25 * safeZoneH + safeZoneY,
    0.10 * safeZoneW,
    0.03 * safeZoneH
];
simControlpic ctrlCommit 0;
simControlpic ctrlsettext "omtk\ui\img\sim_control.jpg";

// Disable all sim
buttonSimulation_Disable = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_Disable ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_Disable ctrlCommit 0;
buttonSimulation_Disable ctrlsettext "DISABLE ALL Sim";
buttonSimulation_Disable ctrlsetBackgroundColor [0.8, 0.2, 0.8, 1];
buttonSimulation_Disable ctrlAddEventHandler ["Buttondown", {
    [] remoteExec['omtk_sim_disableplayerSim', 0, true];
    [] remoteExec['omtk_sim_disablevehiclesim', 0];
}];

// Enable all sim
buttonSimulation_EnableAll = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_EnableAll ctrlsetPosition [
    0.565 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_EnableAll ctrlCommit 0;
buttonSimulation_EnableAll ctrlsettext "Enable ALL Sim";
buttonSimulation_EnableAll ctrlAddEventHandler ["Buttondown", {
    ['all'] remoteExec['omtk_sim_enableplayerSim', 0];
    [] remoteExec['omtk_sim_enablevehiclesim', 0];
}];

/*

// Enable Blue sim
buttonSimulation_EnableBlue = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_EnableBlue ctrlsetPosition [
    0.635 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_EnableBlue ctrlCommit 0;
buttonSimulation_EnableBlue ctrlsettext "Enable Blue Sim";
buttonSimulation_EnableBlue ctrlsetBackgroundColor [0.2, 0.2, 0.8, 1];
buttonSimulation_EnableBlue ctrlAddEventHandler ["Buttondown", {
    ['blu', blufor] remoteExec ['omtk_sim_enableplayerSim', 0];
}];

// Enable Red sim
buttonSimulation_EnableRed = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_EnableRed ctrlsetPosition [
    0.705 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_EnableRed ctrlCommit 0;
buttonSimulation_EnableRed ctrlsettext "Enable Red Sim";
buttonSimulation_EnableRed ctrlsetBackgroundColor [0.8, 0.2, 0.2, 1];
buttonSimulation_EnableRed ctrlAddEventHandler ["Buttondown", {
    ['red', opfor] remoteExec ['omtk_sim_enableplayerSim', 0];
}];

// Enable Green sim
buttonSimulation_EnableGreen = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_EnableGreen ctrlsetPosition [
    0.775 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_EnableGreen ctrlCommit 0;
buttonSimulation_EnableGreen ctrlsettext "Enable Green Sim";
buttonSimulation_EnableGreen ctrlsetBackgroundColor [0.2, 0.8, 0.2, 1];
buttonSimulation_EnableGreen ctrlAddEventHandler ["Buttondown", {
    ['green', independent] remoteExec ['omtk_sim_enableplayerSim', 0];
}];

// Enable Vic sim
buttonSimulation_EnableVic = _display ctrlCreate ["omtk_RscButton", 1201];
buttonSimulation_EnableVic ctrlsetPosition [
    0.845 * safeZoneW + safeZoneX,
    0.29 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
buttonSimulation_EnableVic ctrlCommit 0;
buttonSimulation_EnableVic ctrlsettext "Enable Vics Sim";
buttonSimulation_EnableVic ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_sim_enablevehiclesim', 0];
}];

*/
// * VIEW distance CONTROL*/
vdControlpic = _display ctrlCreate ["omtk_Rscpicture", 1202];
vdControlpic ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.33 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
vdControlpic ctrlCommit 0;
vdControlpic ctrlsettext "omtk\ui\img\view_distance.jpg";

// set VD 200
buttonVD_200 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_200 ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_200 ctrlCommit 0;
buttonVD_200 ctrlsettext "set VD 200";
buttonVD_200 ctrlAddEventHandler ["Buttondown", {
    ['set', 200] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD 600
buttonVD_600 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_600 ctrlsetPosition [
    0.555 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_600 ctrlCommit 0;
buttonVD_600 ctrlsettext "set VD 600";
buttonVD_600 ctrlAddEventHandler ["Buttondown", {
    ['set', 600] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD 1000
buttonVD_1000 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_1000 ctrlsetPosition [
    0.615 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_1000 ctrlCommit 0;
buttonVD_1000 ctrlsettext "set VD 1000";
buttonVD_1000 ctrlAddEventHandler ["Buttondown", {
    ['set', 1000] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD 2000
buttonVD_2000 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_2000 ctrlsetPosition [
    0.675 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_2000 ctrlCommit 0;
buttonVD_2000 ctrlsettext "set VD 2000";
buttonVD_2000 ctrlAddEventHandler ["Buttondown", {
    ['set', 2000] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD 3000
buttonVD_3000 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_3000 ctrlsetPosition [
    0.735 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_3000 ctrlCommit 0;
buttonVD_3000 ctrlsettext "set VD 3000";
buttonVD_3000 ctrlAddEventHandler ["Buttondown", {
    ['set', 3000] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD 4000
buttonVD_4000 = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_4000 ctrlsetPosition [
    0.795 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_4000 ctrlCommit 0;
buttonVD_4000 ctrlsettext "set VD 4000";
buttonVD_4000 ctrlAddEventHandler ["Buttondown", {
    ['set', 4000] remoteExec ['omtk_viewDistance_change', 0];
}];

// set VD reset
buttonVD_reset = _display ctrlCreate ["omtk_RscButton", 1201];
buttonVD_reset ctrlsetPosition [
    0.855 * safeZoneW + safeZoneX,
    0.37 * safeZoneH + safeZoneY,
    0.05 * safeZoneW,
    0.03 * safeZoneH
];
buttonVD_reset ctrlCommit 0;
buttonVD_reset ctrlsettext "Reset VD";
buttonVD_reset ctrlAddEventHandler ["Buttondown", {
    ['reset', 1] remoteExec ['omtk_viewDistance_change', 0];
}];

// * OMT CONTROL*/

// picture of OMTK control
simControlpic = _display ctrlCreate ["omtk_Rscpicture", 1201];
simControlpic ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.41 * safeZoneH + safeZoneY,
    0.10 * safeZoneW,
    0.03 * safeZoneH
];
simControlpic ctrlCommit 0;
simControlpic ctrlsettext "omtk\ui\img\omtk_btns.jpg";

// End warmup
button_endWarmup = _display ctrlCreate ["omtk_RscButton", 1201];
button_endWarmup ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_endWarmup ctrlCommit 0;
button_endWarmup ctrlsettext "End warmup";
button_endWarmup ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_wu_fn_launch_game', 2];
}];

// Show scoreboard
button_showscoreboard = _display ctrlCreate ["omtk_RscButton", 1201];
button_showscoreboard ctrlsetPosition [
    0.565 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_showscoreboard ctrlCommit 0;
button_showscoreboard ctrlsettext "Show scoreboard";
button_showscoreboard ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_sb_compute_scoreboard', 2];
    [] remoteExec ['omtk_sb_start_mission_end', 2];
}];

// export Ocap
button_exportocap = _display ctrlCreate ["omtk_RscButton", 1201];
button_exportocap ctrlsetPosition [
    0.635 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_exportocap ctrlCommit 0;
button_exportocap ctrlsettext "export Ocap";
button_exportocap ctrlAddEventHandler ["Buttondown", {
    ["ocap_exportData", ["Mission is OVER"]] remoteExec ['CBA_fnc_serverEvent', 2];
}];

// Remove AIs
button_removeAI = _display ctrlCreate ["omtk_RscButton", 1201];
button_removeAI ctrlsetPosition [
    0.705 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_removeAI ctrlCommit 0;
button_removeAI ctrlsettext "Remove AIs";
button_removeAI ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_delete_playableAiunits', 0];
}];

// Freeze AIs
button_freezeAI = _display ctrlCreate ["omtk_RscButton", 1201];
button_freezeAI ctrlsetPosition [
    0.775 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_freezeAI ctrlCommit 0;
button_freezeAI ctrlsettext "Freeze AIs";
button_freezeAI ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_disable_aibehaviour', 2];
}];

// Enable Dmg Playres
button_freezeAI = _display ctrlCreate ["omtk_RscButton", 1201];
button_freezeAI ctrlsetPosition [
    0.845 * safeZoneW + safeZoneX,
    0.45 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_freezeAI ctrlCommit 0;
button_freezeAI ctrlsettext "Enable Dmg players";
button_freezeAI ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_enable_playerdamage', 0];
}];

// New Line //////

// Enable Safety
button_enabsafety = _display ctrlCreate ["omtk_RscButton", 1201];
button_enabsafety ctrlsetPosition [
    0.495 * safeZoneW + safeZoneX,
    0.49 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_enabsafety ctrlCommit 0;
button_enabsafety ctrlsettext "Enable Safety";
button_enabsafety ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_enable_safety', 0];
}];

// Disable Safety
button_disSafety = _display ctrlCreate ["omtk_RscButton", 1201];
button_disSafety ctrlsetPosition [
    0.565 * safeZoneW + safeZoneX,
    0.49 * safeZoneH + safeZoneY,
    0.06 * safeZoneW,
    0.03 * safeZoneH
];
button_disSafety ctrlCommit 0;
button_disSafety ctrlsettext "Disable Safety";
button_disSafety ctrlAddEventHandler ["Buttondown", {
    [] remoteExec ['omtk_disable_safety', 0];
}];

// export forum list
button_export = _display ctrlCreate ["omtk_RscButton", 1201];
button_export ctrlsetPosition [
    0.8 * safeZoneW + safeZoneX,
    0.8 * safeZoneH + safeZoneY,
    0.07 * safeZoneW,
    0.03 * safeZoneH
];
button_export ctrlsetBackgroundColor [0.2, 1.0, 0.2, 1];
button_export ctrlCommit 0;
button_export ctrlsettext "export list";
button_export ctrlAddEventHandler ["Buttondown", {
    _handle = execVM "omtk\table_forum.sqf";
}];

// Loop that will handle list of players
[_playerlist, _playerlist2, _name, _name2] spawn {
    params ["_list1", "_list2", "_name1", "_name2"];
    
    private _saved1 = ctrltext _name1;
    private _saved2 = ctrltext _name2;
    
    while {!isNull findDisplay 49} do {
        if (ctrltext _name1 != _saved1) then {
            lbClear _list1;
            _saved1 = ctrltext _name1;
            _list1 lbAdd "==WHO==";
            _list1 lbAdd "==BLUEFOR==";
            {
                if ([_saved1, name _x] call BIS_fnc_instring) then {
                    _list1 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == west
            });
            
            _list1 lbAdd "==OPFOR==";
            {
                if ([_saved1, name _x] call BIS_fnc_instring) then {
                    _list1 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == east
            });
            
            _list1 lbAdd "==INDEPENDENT==";
            {
                if ([_saved1, name _x] call BIS_fnc_instring) then {
                    _list1 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == resistance
            });
            
            _list1 lbAdd "==civilian==";
            {
                if ([_saved1, name _x] call BIS_fnc_instring) then {
                    _list1 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == civilian
            });
        };

		if (ctrltext _name2 != _saved2) then {
            lbClear _list2;
            _saved2 = ctrltext _name2;
            _list2 lbAdd "==WHERE==";
            _list2 lbAdd "==BLUEFOR==";
            {
                if ([_saved2, name _x] call BIS_fnc_instring) then {
                    _list2 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == west
            });
            
            _list2 lbAdd "==OPFOR==";
            {
                if ([_saved2, name _x] call BIS_fnc_instring) then {
                    _list2 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == east
            });
            
            _list2 lbAdd "==INDEPENDENT==";
            {
                if ([_saved2, name _x] call BIS_fnc_instring) then {
                    _list2 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == resistance
            });
            
            _list2 lbAdd "==civilian==";
            {
                if ([_saved2, name _x] call BIS_fnc_instring) then {
                    _list2 lbAdd name _x;
                };
            } forEach (allplayers select {
                side (group _x) == civilian
            });
        };
        
        sleep 0.2;
    };
};
