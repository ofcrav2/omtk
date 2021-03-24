if (hasInterface) then {
	["radio_lock start", "DEBUG", false] call omtk_log;

	omtk_rl_disable_radio_pickup_EH = {
		_unitName = name (_this select 0);
		_side = side (_this select 0);
		_item =  _this select 1;
				
		_forbiddenSRRadios = [];
		_forbiddenLRRadios = [];
		
		if (_side == east) then {
			_forbiddenSRRadios = ["TFAR_anprc152", "TFAR_rf7800str"];
			_forbiddenLRRadios = ["TFAR_rt1523g", "TFAR_rt1523g_big", "TFAR_rt1523g_black", "TFAR_rt1523g_fabric", "TFAR_rt1523g_green", "TFAR_rt1523g_rhs", "TFAR_rt1523g_sage","TFAR_rt1523g_big_bwmod","TFAR_mr3000_bwmod"];
		};
		
		if (_side == west) then {
			_forbiddenSRRadios = ["TFAR_fadak", "TFAR_pnr1000a"];
			_forbiddenLRRadios = ["TFAR_mr3000", "TFAR_mr3000_multicam", "TFAR_mr3000_rhs"];
		};
		
		if (_item in _forbiddenSRRadios) then {
			[("'" + _unitName + "' has stolen SR ennemy radio '" + _item + "'"), "CHEAT",true] call omtk_log;
			player removeItem _item;
		};
			
		if (_item in _forbiddenLRRadios) then {
			[("'" + _unitName + "' has stolen LR ennemy radio '" + _item + "'"), "CHEAT",true] call omtk_log;
			player action ["PutBag"];
		};		
	};		
	
	player addEventHandler ["Take",{[_this select 0,_this select 2] call omtk_rl_disable_radio_pickup_EH;}];

	["radio_lock end", "DEBUG", false] call omtk_log;
};
