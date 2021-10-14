class AdminMenuTest {
	idd = 3223 ;
	enableDisplay = 1;
	duration = 9999;
	fadein=1;
	fadeout=1;
	name="AdminMenu";
	class Controls {
		class MainContainer: omtk_BOX {
			idc = 1800;
			x = 0.276563 * safezoneW + safezoneX;
			y = 0.236103 * safezoneH + safezoneY;
			w = 0.446875 * safezoneW;
			h = 0.527794 * safezoneH;
		};
		
		// SIMULATION CONTROL
		
		class SimControlPic: omtk_RscPicture {
			idc = 1201;
			text = "omtk\admin_ui\img\sim_control.jpg";
			x = 0.295 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.10 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class ButtonSimulation_Disable: omtk_RscButton {
			text = "DISABLE ALL Sim"; //--- ToDo: Localize;
			colorBackground[] = {0.8,0.2,0.8,1};
			x = 0.295 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[]remoteExec['omtk_sim_disablePlayerSim', 0];[]remoteExec['omtk_sim_disableVehicleSim',0];"; 
		};
		class ButtonSimulation_EnableAll: omtk_RscButton {
			text = "Enable ALL Sim"; //--- ToDo: Localize;
			x = 0.365 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="['all']remoteExec['omtk_sim_enablePlayerSim',0];[]remoteExec['omtk_sim_enableVehicleSim',0];"; 
		};
		class ButtonSimulation_EnableBlue: omtk_RscButton {
			text = "Enable Blue Sim"; //--- ToDo: Localize;
			colorBackground[] = {0.2,0.2,0.8,1};
			x = 0.435 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="['blu',blufor] remoteExec ['omtk_sim_enablePlayerSim', 0];"; 
		};
		class ButtonSimulation_EnableRed: omtk_RscButton {
			text = "Enable Red Sim"; //--- ToDo: Localize;
			colorBackground[] = {0.8,0.2,0.2,1};
			x = 0.505 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="['red',opfor] remoteExec ['omtk_sim_enablePlayerSim', 0];"; 
		};
		class ButtonSimulation_EnableGreen: omtk_RscButton {
			text = "Enable Green Sim"; //--- ToDo: Localize;
			colorBackground[] = {0.2,0.8,0.2,1};
			x = 0.575 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="['green',independent] remoteExec ['omtk_sim_enablePlayerSim', 0];"; 
		};
		class ButtonSimulation_EnableVic: omtk_RscButton {
			text = "Enable Vics Sim"; //--- ToDo: Localize;
			x = 0.645 * safezoneW + safezoneX;
			y = 0.29 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_sim_enableVehicleSim', 0];"; 
		};
		
		// VIEW DISTANCE
		
		class VeiwDistPic: omtk_RscPicture {
			idc = 1202;
			text = "omtk\admin_ui\img\view_distance.jpg";
			x = 0.295 * safezoneW + safezoneX;
			y = 0.33 * safezoneH + safezoneY;
			w = 0.10 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class ButtonViewDistance_200: omtk_RscButton {
			text = "Set VD 200"; //--- ToDo: Localize;
			x = 0.295 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',200] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_600: omtk_RscButton {
			text = "Set VD 600"; //--- ToDo: Localize;
			x = 0.355 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',600] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_1000: omtk_RscButton {
			text = "Set VD 1000"; //--- ToDo: Localize;
			x = 0.415 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',1000] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_2000: omtk_RscButton {
			text = "Set VD 2000"; //--- ToDo: Localize;
			x = 0.475 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',2000] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_3000: omtk_RscButton {
			text = "Set VD 3000"; //--- ToDo: Localize;
			x = 0.535 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',3000] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_4000: omtk_RscButton {
			text = "Set VD 4000"; //--- ToDo: Localize;
			x = 0.595 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['set',4000] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		class ButtonViewDistance_Reset: omtk_RscButton {
			text = "Reset VD"; //--- ToDo: Localize;
			x = 0.655 * safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.03 * safezoneH;
			action="['reset',1] remoteExec ['omtk_viewdistance_change', 0];"; 
		};
		
		// OMTK BUTTONS
		
		class OmtkBtnsPic: omtk_RscPicture {
			idc = 1203;
			text = "omtk\admin_ui\img\omtk_btns.jpg";
			x = 0.295 * safezoneW + safezoneX;
			y = 0.41 * safezoneH + safezoneY;
			w = 0.10 * safezoneW;
			h = 0.03 * safezoneH;
		};
		class ButtonEndWarmup: omtk_RscButton {
			text = "End Warmup"; //--- ToDo: Localize;
			x = 0.295 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_wu_fn_launch_game', 2];"; 
		};
		class ButtonShowScore: omtk_RscButton {
			text = "Show Scoreboard"; //--- ToDo: Localize;
			x = 0.365 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_sb_compute_scoreboard', 2];[] remoteExec ['omtk_sb_start_mission_end', 2];"; 
		};
		class ButtonExportOcap: omtk_RscButton {
			text = "Export Ocap"; //--- ToDo: Localize;
			x = 0.435 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['ocap_fnc_exportData', 2];"; 
		};
		class ButtonDeleteAi: omtk_RscButton {
			text = "Remove AIs"; //--- ToDo: Localize;
			x = 0.505 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_delete_playableAiUnits', 0];"; 
		};
		class ButtonDisableAiBrains: omtk_RscButton {
			text = "Freeze AIs"; //--- ToDo: Localize;
			x = 0.575 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_disable_aiBehaviour', 2];"; 
		};
		class ButtonAllowDamage: omtk_RscButton {
			text = "Enable Dmg Players"; //--- ToDo: Localize;
			x = 0.645 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.03 * safezoneH;
			action="[] remoteExec ['omtk_enable_playerDamage', 0];"; 
		};
		
		class QuitButtonMenu: omtk_RscButton {
			idc = -1;
			x = 0.477080 * safezoneW + safezoneX;
			y = 0.741906 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			text = "CLOSE";
			action="closeDialog 0;";
		};
	};
};
