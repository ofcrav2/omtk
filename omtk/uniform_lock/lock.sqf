waitUntil {!(isNull (findDisplay 602))};

_inv = uniformItems player;
_unif = uniform player;
ctrlEnable [6331, false]; 

while { !(isNull (findDisplay 602)) } do {
	// Keep the "uniform slot" control on lockdown. Else there are loop holes.
	ctrlEnable [6331, false]; 
	
	if ( !(uniform player isEqualTo _unif)) then { 
		sleep 0.1;
		removeUniform player;
		ctrlEnable [6331, false];
		sleep 0.05;
		player forceAddUniform _unif;
		{player addItemToUniform _x} forEach _inv;
	} else {
		_inv = uniformItems player;
	};
	
};

/*	Other display elements are:
	6331, // uniform
	6381, // vest
	6191, // backpack
	6240, // headgear
	610, // Primary Weapon
	620, // PW Muzzle
	621, // PW Optics
	622, // PW Flashlight
	611, // secondary weapon
	612, // hand Gun
	630, // HG Flashlight
	628, // HG Muzzle
	629 // HG Optics
*/