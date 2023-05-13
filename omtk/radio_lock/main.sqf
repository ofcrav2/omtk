if (hasinterface) then {
    ["radio_lock start", "DEBUG", false] call omtk_log;
    
    player addEventHandler ["Take", {
        params ["_unit", "_container", "_item"];
        
        private _cfgPath = "";
        switch (true) do {
            case (isClass (configFile / "Cfgweapons" / _item)) : {
                _cfgPath = "Cfgweapons";
            };
            case (isClass (configFile / "Cfgmagazines" / _item)) : {
                _cfgPath = "Cfgmagazines";
            };
            case (isClass (configFile / "Cfgvehicles" / _item)) : {
                _cfgPath = "Cfgvehicles";
            };
            case (isClass (configFile / "CfgGlasses" / _item)) : {
                _cfgPath = "CfgGlasses";
            };
        };
        
        private _encoding = gettext (configFile / _cfgPath / _item / "tf_encryptionCode");
        if (_encoding != "") then {
            private _stolen = false;
            // took radio - check code to side
            switch (side _unit) do {
                case west: {
                    if (_encoding != "tf_west_radio_code") then {
                        // Stolen
                        _stolen = true;
                    };
                };
                
                case east: {
                    if (_encoding != "tf_east_radio_code") then {
                        // Stolen
                        _stolen = true;
                    };
                };
                
                case independent: {
                    if (_encoding != "tf_independent_radio_code") then {
                        // Stolen
                        _stolen = true;
                    };
                };
            };
            if (_stolen) then {
                [("'" + name _unit + "' has stolen SR enemy radio '" + _item + "'"), "CHEAT", true] call omtk_log;
                _unit removeItem _item;
            };
        };
    }];
    
    ["radio_lock end", "DEBUG", false] call omtk_log;
};
