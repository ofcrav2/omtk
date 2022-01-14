if (isServer) then {
    ["kill_logger start", "DEBUG", false] call omtk_log;
    _index = 1;
    {
        _name = "bot_" + (str _index);
        
        _x setName _name;
        _x addMPEventHandler ["MPkilled", {
            params ["_victim", "_killer"];
            
            [_victim, _killer] spawn {
                params ["_victim", "_killer"];
                if (_killer == _victim) then {
                    private _time = diag_ticktime;
                    [_victim, {
                        _this setVariable ["ace_medical_lastdamageSource", (_this getVariable "ace_medical_lastdamageSource"), 2];
                    }] remoteExec ["call", _victim];
                    waitUntil {
                        diag_ticktime - _time > 10 || !(isnil {
                            _victim getVariable "ace_medical_lastdamageSource"
                        });
                    };
                    _killer = _victim getVariable ["ace_medical_lastdamageSource", _killer];
                } else {
                    _killer
                };
                
                diag_log text format ["[OMTK] KILL: '%1' killed by '%2'", name (_victim), name (_killer)];
            };
        }];
        _x addMPEventHandler ["MPhit", {
            diag_log text format ["[OMTK] HIT: '%1' hit by '%2'", name (_this select 0), name (_this select 1)];
        }];
        _index = _index + 1;
    } forEach allunits;
    
    ["kill_logger end", "DEBUG", false] call omtk_log;
};