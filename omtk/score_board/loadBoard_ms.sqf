// SET SCORES
sb_s = missionNamespace getVariable "sb_s";
sb_o = missionNamespace getVariable "sb_o";


_text = format["          %1 pts                                                                                %3 pts        OBJECTIVES                                                            %2 pts                                          ", sb_s select 0, sb_s select 1, sb_s select 2];
ctrlSetText [1510, _text];

_index = 2;
{ 
	if ((_x select 0) != 0) then {
		_index = _index + 1;
		_res = 0;
		if (sb_s select _index) then {
			_res = _x select 0;
		};
		_line = format ["%1  (%3/%2 pts)", _x select 3, _x select 0, _res];
		_sideIdx = 1511;
		if (_x select 1 == east) then { _sideIdx = 1512; };
		if (_x select 1 == resistance) then { _sideIdx = 1513; };
		lbAdd [_sideIdx, _line];
	};
} foreach sb_o;


// SET SURVIVORS
_bluefor_survivors = missionNamespace getVariable "omtk_sb_bluefor_survivors";
_redfor_survivors  = missionNamespace getVariable "omtk_sb_redfor_survivors";
_greenfor_survivors  = missionNamespace getVariable "omtk_sb_greenfor_survivors";

_text = format["          %1                                                                                          %3        SURVIVORS                                                                      %2                                          ", count _bluefor_survivors, count _redfor_survivors, count _greenfor_survivors];
ctrlSetText [1520, _text];

{ lbAdd [1521, _x]; } foreach (_bluefor_survivors call BIS_fnc_sortAlphabetically);
{ lbAdd [1522, _x]; } foreach (_redfor_survivors  call BIS_fnc_sortAlphabetically);
{ lbAdd [1523, _x]; } foreach (_greenfor_survivors  call BIS_fnc_sortAlphabetically);
