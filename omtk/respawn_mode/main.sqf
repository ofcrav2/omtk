["respawn_mode start", "DEBUG", false] call omtk_log;

_value = ("OMTK_MODULE_RESPAWN_MODE" call BIS_fnc_getParamValue);

if (_value > 0) then { 
  setPlayerRespawnTime (_value);
} else {
  { _x allowDamage false; } forEach allUnits;
  { _x allowDamage false; } foreach vehicles;
};

["respawn_mode end", "DEBUG", false] call omtk_log;
