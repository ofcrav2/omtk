_omtk_sb_objectives = [];
_omtk_sb_scores = [0,0];
_omtk_sb_flags = [];

{
	_points = _x select 0;
	_side = _x select 1;
	_type = _x select 2;
	_texteObj = _x select 3;
	_values = _x select 4;
	
	switch(_side) do {
		case "BLUEFOR":	{
			if(playerSide == west) then{
				objTest = player createSimpleTask[ _texteObj];
				objTest setSimpleTaskDescription[str(_points)+" points",  _texteObj , "Texte 3"];						
			}
		};
		case "REDFOR":	{
			if(playerSide == east) then{
				objTest = player createSimpleTask[ _texteObj];
				objTest setSimpleTaskDescription[str(_points)+" points",  _texteObj , "Texte 3"];						
			}
		};
		case "BLUEFOR+REDFOR":	{
				objTest = player createSimpleTask[ _texteObj];
				objTest setSimpleTaskDescription[str(_points)+" points",  _texteObj , "Texte 3"];						
		};
		default	{
			//["unknown side for objective creation","ERROR",true] call omtk_log;
		};
	};
} foreach OMTK_SB_LIST_OBJECTIFS;

_startTime = dayTime;
_sTimeString = [_startTime, "HH:MM"] call BIS_fnc_timeToString;

_endHour = 0;
_endMinute = 0;
_endSecond = 0;
_omtk_mission_duration = 0;

_mission_duration_override = missionNamespace getVariable ["OMTK_SB_MISSION_DURATION_OVERRIDE", nil];
if (!isNil "_mission_duration_override") then {
	_endHour   = OMTK_SB_MISSION_DURATION_OVERRIDE select 0;
	_endMinute = OMTK_SB_MISSION_DURATION_OVERRIDE select 1;
	_endSecond = OMTK_SB_MISSION_DURATION_OVERRIDE select 2;
	_omtk_mission_duration = 3600*_endHour + 60*_endMinute + _endSecond - 1;
} else {
	_mission_duration = ("OMTK_MODULE_SCORE_BOARD" call BIS_fnc_getParamValue);
	_omtk_mission_duration = _mission_duration - 1;
	_endHour   = floor (_mission_duration/3600);
	_endMinute = floor ((_mission_duration - (3600*_endHour)) / 60);
	_endSecond = _mission_duration - (3600*_endHour) - (60*_endMinute);
};


_endTime = _startTime + (_endHour + (_endMinute / 60));
_eTimeString = [_endTime, "HH:MM"] call BIS_fnc_timeToString;

player createDiaryRecord ["Diary", ["MISSION TIMINGS", "<font color='#7FFF00' size='30'>Mission Start Time: " + _sTimeString + "<br/>Mission End Time: " + _eTimeString + "</font>" ]];

player createDiaryRecord ["Diary", ["Crédits", "Mission réalisée avec l'OMTK"]];
