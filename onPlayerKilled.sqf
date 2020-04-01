_specMode = ("OMTK_MODULE_SPECTATOR" call BIS_fnc_getParamValue);

// Re-enable input if player is dead (acebug workaround)
if (userInputDisabled) then
{
   disableUserInput false;
};

if (_specMode == 0) then {
	["Initialize", [player, [], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;
} else {
	 switch (playerSide) do {
		case WEST: {		["Initialize", [player, [WEST], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator; };
		case EAST: {		["Initialize", [player, [EAST], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator; };
		case RESISTANCE: {	["Initialize", [player, [RESISTANCE], true, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator; };
	};
};
