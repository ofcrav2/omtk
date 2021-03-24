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


player createDiaryRecord ["Diary", ["Crédits", "Mission réalisée avec l'OMTK"]];
