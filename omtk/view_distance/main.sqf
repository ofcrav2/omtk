["view_distance start", "DEBUG", false] call omtk_log;

_value = ("OMTK_MODULE_VIEW_DISTANCE" call BIS_fnc_getParamValue);

setViewDistance _value;

["view_distance end", "DEBUG", false] call omtk_log;
