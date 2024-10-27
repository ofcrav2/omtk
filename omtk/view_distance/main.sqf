// Parts of this code have been inspired by Mallen's code on FNF Framework

["view_distance start", "DEBUG", false] call omtk_log;

if (hasInterface) then {
	
	_value = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);
	setViewDistance _value;

	player setVariable ["omtk_vd_master", _value];


	[] spawn {
		while { sleep 0.5 ; (alive player and (typeOf player isNotEqualTo "ace_spectator_virtual")) } do {
			
			_omtk_viewDist = player getVariable ["omtk_vd_master", 2000];
			
			if (viewDistance != _omtk_viewDist) then {
				setViewDistance _omtk_viewDist;
			};
			
		};
	};
};

["view_distance end", "DEBUG", false] call omtk_log;
