# SCORE_BOARD MODULE

## Data card

| FIELD                   | VALUE
|-------------------------|-------------
| folder name             | score_board
| last modification date  | 2022-01-12
| Ojective                | compute scores & display scoreboard at the end of the time-boxed game
| Default                 | enabled
| Extra Parameters        | yes

## Description

This module is complex and provides a lot of functionalities:

* define missions objectives for each side
* provides custom scripts code execution
* define the duration of the mission
* display the end time
* compute scores on the server, dispatch them and display them on a scoreboard at the end of the mission
	
## Complete Example List: 
```
// 2 Factions only
OMTK_SB_LIST_OBJECTIFS = [  
    [4, "BLUEFOR+REDFOR", "INSIDE", "Capture zone", "zone", ["DIFF", 1]], 
    [1, "REDFOR", "SURVIVAL", "Protect the bridge", ["LIST", ["bridge"]] ], 
    [1, "REDFOR", "SURVIVAL", "Protect both bridges", ["LIST", ["bridge1","bridge2"]] ], 
    [1, "BLUEFOR", "DESTRUCTION", "Kill a VIP", ["LIST", ["vip1"]] ], 
    [1, "BLUEFOR", "DESTRUCTION", "Kill both VIPs", ["LIST", ["vip1","vip2"]] ], 
    [1, "BLUEFOR", "INSIDE", "Bring VIP1 to the meeting point", "zone", ["LIST", ["vip1"]] ], 
    [1, "REDFOR", "OUTSIDE", "Do NOT let them exfil both VIPs", "extraction_zone", ["LIST", ["vip1","vip2"]] ], 
    [1, "REDFOR", "FLAG", "Objective starts uncompleted and needs to be completed (similar to DESTRUCTION)", [[1,false]] ],  
    [1, "BLUEFOR", "FLAG", "Objective starts completed and needs to be prevented from being UNcompleted (similar to SURVIVAL)", [[2,true]] ], 
    [5, "BLUEFOR", "DESTRUCTION", "Domination bonus", ["REDFOR",5] ],  
    [5, "REDFOR", "DESTRUCTION", "Domination bonus", ["BLUEFOR",5] ]  
];  
// Timed Objectives (2 factions only). Read the related section below for more information
OMTK_SB_LIST_OBJECTIFS = [  
	[1, "BLUEFOR+REDFOR", "T_INSIDE", "Cap Zone after 40mins", [1, 40], "zone", ["DIFF", 1] ], 
	[1, "BLUEFOR", "T_INSIDE", "VIP inside zone after 30mins", [2, 30], "zone", ["LIST", ["vip"]]	], 
	[1, "REDFOR", "T_OUTSIDE", "VIP outside zone after 20mins", [3, 20], "zone", ["LIST", ["vip"]]	],
	[1, "BLUEFOR", "T_DESTRUCTION", "Kill vip within 1h", [4, 60], ["LIST", ["vip"]] ], 
	[1, "REDFOR", "T_SURVIVAL", "Save vip for 1h", [5, 60], ["LIST", ["vip"]] ]
];
// 3 Factions
OMTK_SB_LIST_OBJECTIFS = [
    [3, "REDFOR+GREENFOR", "INSIDE", "2 way capzone red/green", "zone", ["DIFF", 1] ],
    [3, "BLUEFOR+REDFOR+GREENFOR", "INSIDE", "3 way capzone", "zone", ["DIFF", 1] ],
    [2, "BLUEFOR", "DESTRUCTION", "Bluefor kill civ1", ["LIST", ["civ1"]]  ],
    [2, "GREENFOR", "SURVIVAL", "Greenfor save civ1", ["LIST", ["civ1"]] ],
    [2, "REDFOR", "DESTRUCTION", "Supremacy against blue", ["BLUEFOR", 5] ],
    [2, "GREENFOR", "DESTRUCTION", "Supremacy against blue", ["BLUEFOR", 5] ],
    [2, "BLUEFOR",  "DESTRUCTION",  "Supremacy against red", ["REDFOR", 5] ],
    [2, "BLUEFOR",  "DESTRUCTION",  "Supremacy against green", ["GREENFOR", 5] ],
    [2, "GREENFOR", "SURVIVAL", "Supremacy of itself", ["GREENFOR", 5] ]
];
```


## How it works:

At the start of the mission, a message provide the local time (in-game clock) when the scores will be computed by the server (and clients will display another message ""):

    End of Mission: HH:MM
	
### Mission Objectives

First, you need to describe the objectives for both sides. This is done inside file *init.sqf* inside the OMTK_SB_LIST_OBJECTIFS array. 

    OMTK_SB_LIST_OBJECTIFS = [  
	    objective1,  
	    objective2,  
	    ...,  
	    last_objective
    ];  

REMEMBER: no spaces between the lines and commas at the end of every line EXCEPT the last one.
	
Each single objective is an array itself:

    [points, side, objective_type, objective_label, specific_parameters]  

With:

* points: number of points (natural number, can be negative to behave like a penalty)
* side: the side to which the objective is assigned, value among {"BLUEFOR"|"REDFOR"|"GREENFOR"|"BLUEFOR+REDFOR"|"BLUEFOR+GREENFOR"|"REDFOR+GREENFOR"|"BLUEFOR+REDFOR+GREENFOR"}
* objective_type: value among {"SURVIVAL"|"DESTRUCTION"|"INSIDE"|"OUTSIDE"|"ACTION"|"FLAG"}
* objective_label: the text displayed into the scoreboard
* specific_parameters: additional parameter(s) related to the chosen objective type

#### SURVIVAL/DESTRUCTION

SURVIVAL objective means "the subject" has to be alive/not destroyed at the end of the game. On the opposite, DESTRUCTION means that the subject has to be killed/destroyed at the end.  
One specific parameter defines the subject. It is an array again:  

      [MODE, VALUES]

MODE can be one of {"BLUEFOR"|"REDFOR"|"GREENFOR"|"DIFF"|"LIST"|"OMTK_ID"} :

* **BLUEFOR/REDFOR/GREENFOR:** specify the lower number of survivors for the side.  
VALUES is a simple number corresponding to the minimum amount of units that should survive
ex: ["BLUEFOR", 4] => objective is completed if -at least- 4 units are alived in the end.

* **DIFF:** specify the difference of units in-between both sides. In case of 3 factions, you need to have more players than BOTH other factions at the same time.
ex: ["DIFF", 2] => objective is completed if there are -at least- 2 more alived units in the given side than in the ennemy side(s).

* **LIST:** an array which specify some units via their name (value of *Variable Name* field in the editor) or their objectId (for map objects). If there are several items, *all* of the items must be alived to complete the objective. (there is no OR condition)  
ex: ["LIST", ["nameOfAVehicle", "nameOfOneIAunit", 875643]] => objective is completed if all of these units/map objects are still alived at the end.

* **OMTK_ID:** this is similar to LIST, but using OMTK_ID. If the unit will be human, the *Variable Name* given in the editor will be replaced by the pseudo of the player. You cannot identify your unit (hostage, or whatever). To identify it at the end, we have to add this code:  
      this setVariable['OMTK_ID',12345]; // 12345 can be any number
inside the *init* field of the unit. Then, you can used this OMTK_ID in the objective.  
ex: ["OMTK_ID", [12345, 13246]]

#### INSIDE/OUTSIDE

INSIDE objective means "the subject" has to be inside the designated zone at the end of the game. OUTSIDE means the opposite.
Two specific parameters define the zone and the subject:

"zone" AND [MODE, VALUES]

zone has to be the name of the trigger you want the subject to be inside (or outside) at the end of the game. Has to be between quotation marks.

MODE and VALUES work exactly like for SUR/DES but instead of checking wether they survived or not, it checks their presence in the zone

#### TIMED OBJECTIVES

Timed objectives work exactly like the previous objectives if not for the addition of a parameter
ex: [1, "REDFOR", "T_SURVIVAL", "Save vip for 1h", [1, 60], ["LIST", ["vip"]] ]
In this example, the additional parameter is **[1,60]**.
The first number indicates the number of the flag, and has to be UNIQUE from all other timed objectives or flag objectives. Use numbers from 1 to 10.
The second number indicates after how many minutes the objective will be checked. In this example, the VIP has to stay alive until 1 hour of game time. 
If he dies after this time has elapsed, the objective will still be considered completed (VIP saved).

NOTE REGARDING "FLAG" OBJECTIVE: 
To set a FLAG objective to completed (or to failed, as per the second line shown below), you just have to run this single line of code in a script or a trigger:
```
[1, true] call omtk_setFlagResult; // set flag 1 to true
[2, false] call omtk_setFlagResult; // set flag 2 to false
```
The opposite can also be done, to set an objective to failed. They can be switched however many times you want.
This works on timed objectives too, but why would you do it, if their entire point is so that you don't have to do it??????

#### THREE FACTIONS OBJECTIVES:

* CapZones:
	- The capzone can now be a two-way capzone by using one of the three combination "BLUEFOR+REDFOR" | "BLUEFOR+GREENFOR" | "REDFOR+GREENFOR". The order MUST be the one shown here. Inverting green with red or blue would break it.
	
	- The result (completed or not) will be calculated against BOTH factions, no matter if its a two way or three way. To "win" the capzone, you MUST have the player advantage (["DIFF", 1] means at least 1 player more) on BOTH factions (so for BLUEFOR to win it, they must have 1 player more than REDFOR and 1 player more than GREENFOR.
	
	Example code and results:
```
[3, "BLUEFOR+REDFOR+GREENFOR", "INSIDE", "3 way capzone", "zone", ["DIFF", 1] ]
	3 Blue, 2 Red, 2 Green in area: BLUE WINS
	3 Blue, 1 Red, 3 Green in area: NOBODY WINS
	0 Blue, 5 Red, 3 Green in area: RED WINS
		
[3, "BLUEFOR+REDFOR", "INSIDE", "2 way capzone blue/red", "zone", ["DIFF", 1] ]
	3 Blue, 2 Red, 2 Green in area: BLUE WINS
	3 Blue, 1 Red, 3 Green in area: NOBODY WINS
	0 Blue, 5 Red, 3 Green in area: RED WINS
		
[3, "REDFOR+GREENFOR", "INSIDE", "2 way capzone red/green", "zone", ["DIFF", 1] ]
	3 Blue, 2 Red, 2 Green in area: NOBODY WINS
	3 Blue, 1 Red, 3 Green in area: NOBODY WINS (even though technically green should win)
	0 Blue, 5 Red, 3 Green in area: RED WINS
```
* Survival/Destruction of a "target":
  - It works exactly the same as with the two-way fights, you just need to assign the objective to GREENFOR.
	
ex: [2, "GREENFOR", "SURVIVAL", "Greenfor save civ1", ["LIST", ["civ1"]] ]
	
* Supremacy:
 Regular supremacy (blue faction gets points if LESS than 5 reds survive) could be used if split up. I suggest using "reverse supremacy":

   positive reverse supremacy means assigning points to green if MORE than 4 greens survive 

   ex: [2, "GREENFOR", "SURVIVAL", "Supremacy of itself", ["GREENFOR", 5] ]
	
   negative reverse supremacy means deducting points to green if LESS than 5 greens survive

   ex: [-2, "GREENFOR", "DESTRUCTION", "Supremacy of itself", ["GREENFOR", 5] ]

#### Scoreboard

The scoreboard pops up at the mission's end. It displays the computed scores based on missions objectives, and the list of survivors.

Here is a screenshot corresponding to the objectives described by the full example in the previous section:

![GitHub Logo](../wiki/img/scoreboard.png)

The coalitions flags in the upper corners can be customized: files *omtk\\score_board\\img\\bluefor.jpg*, *omtk\\score_board\\img\\redfor.jpg* and *omtk\\score_board\\img\\greenfor.jpg*can be replaced by any .jpg images with identical size (145px x 103px)

## Parameters

### Mission Parameters

#### radio_lock module:
* enabled (default)
* disabled

#### three way fight:
* no (default)
* yes

### Extra Parameters

-
