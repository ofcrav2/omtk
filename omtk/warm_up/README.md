# WARM_UP MODULE

## Data card

| FIELD                   | VALUE
|-------------------------|-------------
| folder name             | warm_up
| last modification date  | 2022-09-05
| Ojective                | make a warmup before mission start  
| Default                 | enabled: 5 min
| Extra Parameters        | yes

## Description

This create a warm-up before starting the mission. Sides can make a briefing all together, with some space to move around. Here below are all the features of this warm-up:

* A big message is displayed on the center of the screen:
       - - - WARMUP: XX min. - - -
* Vehicles have their fuel removed at the beginning of warmup
* All human players are immortal (avoid incidents)
* The view distance is set to 1000 to improve performance, and raised near warmup end.
* Many *hint* reminders about the time to mission start (= end of warmup) appears to all clients
      START: XX min.
* players cannot run away from their initial position (means their location when the warm-up began), they are contained inside a restriction area (size can be configured)
* If they try to go further, a warning *hint* message is displayed: 
      GO BACK TO YOUR POSITION ! 
* If they don't obey, they will be teleported to their initial position 5s later.
* When it happens, ther is a log in the *.RPT*:
      HH:MM:SS [OMTK] CHEAT teleport player 'galevsky' back to his initial position
* Sides Officiers can declare their side as ready. Once both are, the warmup is canceled, and another small one (30s) is started. This is useful for long warmups used for briefings, the mission can start as soon as both sides are ready, no need to wait until the end of the warmup
* At the end, there is a *hint* message:
      GO GO GO !!!
* All vehicles have their fuel given back.
* All human players are now vulnerable

      
Note: this mode is compatible with the *launch_mode* one. The warmup prevents from leaving the area where the players are when it starts, so there are no troubles with previous teleports.

## Mission Parameters

#### warm_up module

* disabled
* 30 s
* 1 min
* 1 min 30 s
* 2 min
* 3 min
* 5 min (default)
* 8 min
* 10 min
* 15 min

When enabled, it defines the duration of the warm-up.


#### warm_up zone restriction

* 10 m
* 30 m
* 50 m
* 100 m
* 150 m (default)
* 200 m
* 300 m
* 400 m
* 500 m
* 800 m
* 1000 m
* 2000 m

This defines the distance that players can walk from their spawning location before being teleported back to the initial position.


#### warm_up safety

* off (default)
* on

Defines wether people will be able to shoot during warmup.

### Extra Parameters

#### File *omtk\\warm_up\\main.sqf*

At the top of the file, you can specify which unit classes can declare the side as ready to stop prematurely  the warmup.

      OMTK_WU_CHIEF_CLASSES = ["B_officer_F", "B_Soldier_SL_F", "O_officer_F", "O_Soldier_SL_F"]; // CAN BE CUSTOMIZED
