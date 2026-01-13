/*
    Author: Manchot
    Description:
    Génère un JSON des squads et rôles (tous côtés, tous types d'unités)
*/

params [['_includeAI', false], ['_role', true]];

// On récupère toutes les unités du jeu
private _unitsArr = playableUnits;

// On va déterminer l'ordre d'apparition des sides et des groupes
private _sideOrder = [];
private _groupOrder = [];

// Analyse des unités et enregistrement des sides et groupes dans l'ordre
{
    private _u = _x;
    private _g = group _u;
    private _s = side _u;

    if ((_sideOrder find _s) == -1) then {
        _sideOrder pushBack _s;
    };

    if ((_groupOrder find _g) == -1) then {
        _groupOrder pushBack _g;
    };
} forEach _unitsArr;

// Construction du JSON
private _json = "[";
private _firstSide = true;

{
    private _side = _x;

    // Nom lisible du side
    private _sideName = switch (_side) do {
        case west: { "BLUFOR" };
        case east: { "OPFOR" };
        case resistance: { "INDEPENDENT" };
        case civilian: { "CIVILIAN" };
        default { str _side };
    };

    // Groupes de ce side dans l'ordre global
    private _groupsForSide = [];
    {
        private _g = _x;
        if ((count (units _g select { side _x == _side })) > 0) then {
            _groupsForSide pushBack _g;
        };
    } forEach _groupOrder;

    // Skip sides vides
    if ((count _groupsForSide) == 0) exitWith {};

    if (!_firstSide) then { _json = _json + ","; };
    _json = _json + format ["{""side"":""%1"",""squads"":[", _sideName];

    private _firstGroup = true;

    {
        private _g = _x;
        private _members = _unitsArr select { group _x == _g && side _x == _side };

        if ((count _members) > 0) then {
            if (!_firstGroup) then { _json = _json + ","; };

            private _grpName = groupID _g;
            if (_grpName isEqualTo "") then {
                _grpName = format ["Group_%1", _forEachIndex];
            };

            _json = _json + format ["{""squadName"":""%1"",""roles"":[", _grpName];

            private _firstMember = true;
            {
                private _m = _x;
                private _mRole = "";

                if (_role) then {
                    _mRole = roleDescription _m;
                    private _pos = _mRole find "@";
                    if (_pos > -1) then {
                        _mRole = (_mRole select [0, _pos]);
                    };
                    if (_mRole == "") then {
                        _mRole = getText(configFile >> "CfgVehicles" >> typeOf _m >> "displayName");
                    };
                };

                if (!_firstMember) then { _json = _json + ","; };
                _json = _json + format ["{""role"":""%1""}", _mRole];
                _firstMember = false;
            } forEach _members;

            _json = _json + "]}";
            _firstGroup = false;
        };
    } forEach _groupsForSide;

    _json = _json + "]}";
    _firstSide = false;
} forEach _sideOrder;

_json = _json + "]";

// Copie dans le presse-papiers
forceUnicode 1;
copyToClipboard _json;
hint "JSON généré et copié dans le presse-papiers.";
