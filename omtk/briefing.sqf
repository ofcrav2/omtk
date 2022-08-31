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

player createDiaryRecord ["Diary", ["Crédits", "Mission réalisée avec l'OMTK"]];

player createDiaryRecord ["Diary", ["Donations", "If you enjoy our missions and wish to support us, we welcome donations to help fund the server for the years to come!<br/>You can find more information on how to donate over in our website, at the page https://www.ofcrav2.org/en/the-association/donate"]];

player createDiaryRecord ["Diary", ["Mission Timings", "<font color='#7FFF00' size='30'>Mission Start Time: " + _sTimeString + "<br/>Mission End Time: " + _eTimeString + "</font>" ]];

if (("OMTK_MODULE_MEXICAN_STANDOFF" call BIS_fnc_getParamValue) < 1) then {
	// Mexican Standoff DISABLED
	player createDiaryRecord ["Diary", ["Uniforms","Bluefor Uniforms<br/>
	<img image='images\blue.jpg' width='200' height='333'/><br/>
	Redfor Uniforms<br/>
	<img image='images\red.jpg' width='200' height='333'/>"]];
} else {
	// Mexican Standoff ENABLED
	player createDiaryRecord ["Diary", ["UNIFORMS","Bluefor Uniforms<br/>
	<img image='images\blue.jpg' width='200' height='333'/><br/>
	Redfor Uniforms<br/>
	<img image='images\red.jpg' width='200' height='333'/><br/>
	Greenfor Uniforms<br/>
	<img image='images\green.jpg' width='200' height='333'/>"]];
};


player createDiaryRecord ["Diary", ["Rules", "<font size='15'>
General rules of our games:<br/>
 - No technical support will be provided after 21h00 on the mission evening<br/>
 - Stealing radios is prohibited<br/>
 - Stealing uniforms (hats, clothes, vest) is prohibited<br/>
 - You can only use TFAR to communicate ingame. Any other way of communicating is strictly forbidden (that includes steam messages)<br/>
 - The ingame chat is only allowed for technical issues.<br/>
 - Respect the hierarchy, orders from your superiors and the chain of command<br/>
 - NO AI units. Please close the unused slots<br/>
 - Stealing vehicles : it will be specified on each topic and mission rules specifically, what vehicles can be stolen.<br/>
 - Running over an enemy intentionally with your vehicle is not allowed. Similarly, using an aerial vehicle to kill players on the ground is strictly prohibited if it causes the vehicle to crash. The same goes for hoisted vehicles. For example, using a helicopter's minigun to kill a player is allowed. Crashing the helicopter in order to eliminate the player or his vehicle is strictly prohibited. Casting off a boat in order to achieve a similar result is also prohibited.<br/>
 - Markers on map are authorized<br/>
 - The mission maker is authorised to create more rules according to their desires.<br/>
 - You are not allowed to keep and AI at the start of the game in order to kill it and take its equipment<br/>
 - It is mandatory to use the vehicles allocated to your squad in the slot list by the editor. If the vehicles haven't been assigned by the editor, this responsibility lies in the hands of the side leader.<br/>
 - It is mandatory to at least have a squad leader to take the others slots in the squad, except for the rifleman (and potential other slots that you've been given permission to take by OFCRA staff)<br/>
 - Lonewolfing is strictly forbidden. We consider as lonewoling any person who is too far away from their squad. In precise terms, the space between the more distant members of the squad should not be more than 200 meters.<br/>
 - The rule above does not apply to side leaders when they are alone in their squad. If they have one or more squad mates, the rule then applies to him and his teamates.<br/>
 - When vehicles are attached to a squad, the maximum distance they can get away from is 600 meters. The calculation of the distance is the same way you would do it for infantery: between the two players which are further away from each other (in this case a vehicle and an infantry member. If the crew has to leave the vehicle for any reason, they have to regroup with their squad or any allied forces as soon as they can. They are not allowed to seek contact. 
</font>" ]];