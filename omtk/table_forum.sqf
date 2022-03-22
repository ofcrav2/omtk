/*
	Author: Manchot
	Description:
	Export to clipboard the teams composition for Forum topic
	Command on debug console: _handle = execVM "omtk\table_forum.sqf"; -> SERVER EXEC

*/

params [["_includeAI",false],["_rank",true],["_role",true]];
private["_strRank","_strRole","_strGrp","_strColorGrp","_strFinal","_oldGrp","_newGrp","_unitsArr","_nbr"];

_strRank 		= "";//will contain unit's rank
_strRole 		= "";//will contain unit's role
_strGrp 		= "";//will contain unit's group name
_strColorGrp 	= "";//will contain unit's group color
_strFinal 		= "";//will contain final string to be displayed
_oldGrp 		= grpNull;//group of last checked unit
_newGrp 		= grpNull;//group of current unit
_unitsArr 		= [];//will contain all units that have to be processed
_strBlue		= "";
_strRed 		= "";

if (_includeAI) then {
	_unitsArr = allUnits;
} else {
	if(isMultiplayer) then {
		_unitsArr = playableUnits;
	} else {
		_unitsArr = switchableUnits;
	};
};



{//forEach
	_newGrp = group _x;
	_strGrp = "";
	

	if (_role) then {
		_strRole = " - " + getText(configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName");
		if((roleDescription _x) != "") then {
			_nbr = (roleDescription _x) find "@";
			if (_nbr < 0) then {
				_strRole = " - " + (roleDescription _x);
			} else {
				_strRole = " - " + ((roleDescription _x) select [0,_nbr]);
			};
		};
	};	

	if(_newGrp != _oldGrp) then {
		_nbr = (roleDescription _x) find "@";
		if (_nbr < 0) then {
			_strGrp = "
[b]" + (groupID(group _x)) + "[/b]
";
		} else {
			_strGrp = "
[b]" + ((roleDescription _x) select [_nbr + 1]) + "[/b]
";
		};
		
	};
	_strBlue =  _strBlue +_strGrp +  _strRole + "
";
	_oldGrp = group _x;
}forEach (_unitsArr select {side _x == WEST});



_strRank 		= "";//will contain unit's rank
_strRole 		= "";//will contain unit's role
_strGrp 		= "";//will contain unit's group name
_strColorGrp 	= "";//will contain unit's group color
_oldGrp 		= grpNull;//group of last checked unit
_newGrp 		= grpNull;//group of current unit
_unitsArr 		= [];//will contain all units that have to be processed

if (_includeAI) then {
	_unitsArr = allUnits;
} else {
	if(isMultiplayer) then {
		_unitsArr = playableUnits;
	} else {
		_unitsArr = switchableUnits;
	};
};



{//forEach
	_newGrp = group _x;
	_strGrp = "";
	

	if (_role) then {
		_strRole = " - " + getText(configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName");
		if((roleDescription _x) != "") then {
			_nbr = (roleDescription _x) find "@";
			if (_nbr < 0) then {
				_strRole = " - " + (roleDescription _x);
			} else {
				_strRole = " - " + ((roleDescription _x) select [0,_nbr]);
			};
		};
	};	

	if(_newGrp != _oldGrp) then {
		_nbr = (roleDescription _x) find "@";
		if (_nbr < 0) then {
			_strGrp = "
[b]" + (groupID(group _x)) + "[/b]
";
		} else {
			_strGrp = "
[b]" + ((roleDescription _x) select [_nbr + 1]) + "[/b]
";
		};
		
	};
	_strRed =  _strRed +_strGrp +  _strRole + "
";
	_oldGrp = group _x;
}forEach (_unitsArr select {side _x == EAST});


_strFinal = "[table][tr][td]";
_strFinal = _strFinal + _strBlue;
_strFinal = _strFinal + "[/td]      [td]";
_strFinal = _strFinal + _strRed;
_strFinal = _strFinal + "[/td][/tr][/table]";


//player createDiarySubject ["roster","Team Roster"];
//player createDiaryRecord ["diary",["Team Roster2",_strFinal]];
forceUnicode 1;
copyToClipboard _strFinal;