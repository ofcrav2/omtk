## Changelog


\+ feature added  
\- feature deleted  
~ feature modified  
@ bug fix  
!! security patch

### V2.9.4 - 2022-01-10
~ [ui] Admin Menu Screen reworked and features added

### V2.9.0 - 2021-05-30
\+ [admin_ui] Added an admin menu that includes simulation and view distance control, plus other useful things
\+ [score_board] Mexican Standoff sub-module added (new UI, all functions adapted and separated files to load info into the ui)
\- [omtk] moved all functions from simulation control into the admin ui
~ [warm_up] slight tweak with the simulation random timer for short-warmup missions, and with view distance changes.
~ [ia_skills] Changes now apply only to playable AIs.

### V2.8.1 - 2021-04-14
\+ [omtk] Simulation (and view distance) control, with both a script and ace actions for the admin
\+ [library] Added functions for simulation and view distance control
~ [library] lock & unlock vehicles now locks them entirely, and disables damage
~ [warm_up] players now spawn with disabled simulation, reenabling it on a random timer btween 0 and 30s
~ [warm_up] vehicles have their simulation and inv. access disabled, reenabling it 1min (or 10s) before wup end
~ [ia_skills] AI behaviours now get removed and their damage disabled when "disable playable AI" is enabled

### V2.8.0 - 2021-03-22
\+ [omtk] add Light OMTK parameter for use in big missions
~ [omtk] roster and inventory briefing are not executed in light OMTK
~ [omtk] kill_logger module not executed in light OMTK
~ [omtk] radio_lock module not executed in light OMTK
~ [omtk] ia_skill module partly executed in light OMTK
~ [omtk] warmup notifications are not scheduled in light OMTK
~ [omtk] added two variables for using the redefined unlock_helis from init
~ [omtk] briefings will now execute only on clients
~ [omtk] dynamic startup markers doc will no longer execute out of order
~ [omtk] moved thermalimaging module execution to post warmup 
~ [omtk] added loads of log entries
@ [omtk] moved score_board library to description.ext
@ [omtk] changed version.sqf execution to a preprocessFile call, resolving warmup bug
@ [omtk] removed duplicate execution of difficulty check

### V2.7.3 - 2020-02-25
@ [omtk] correction on picking gear / weapons bug
@ [omtk] correction on MR3000_radio pickup restriction
\+ [omtk] description.ext: increase of corpse and wreck limit

### V2.7.2 - 2019-11-19
@ [omtk] correction on picking gear / weapons bug

### V2.7.1 - 2019-08-21
~ [omtk] Update radio-lock with TFAR beta

### V2.7.0 - 2019-07-01
\+ [omtk] add removing playable AI after warm-up end

### V2.6.0 - 2019-05-08
\@ [omtk] debug spectator selector (side / all)
\+ [omtk] add disconnection logging
\~ [omtk] vehicle are no more completly locked. Only driver is (so you can take stuff and board)
\+ [omtk] add group composition on briefing (with gear)
\+ [omtk] add side squad list on briefing
\+ [omtk] add logging to force end warm-up

### V2.5.1 - 2019-02-18
\+ [Spectator] Add spectator selector (side / all)
\+ [omtk] add disconnection logging

### V2.5.0 - 2019-01-30
\+ [view_distance] add maximum view distance selector
\+ [omtk] add connection logging
\+ [OCAP] add OCAP capture at the end of mission, if available


### V2.4.0 - 2016-12-14
\+ [tactical_paradrop] add timeslot delay parameter in init.sqf
\+ [dynamic_startup] a dedicated panel is now available to choose both spawn location and vehicles
\+ [score_board] FLAG objectives can now be set at mission start in the objectives table (init.sqf)
~ [tactical_paradrop] no more paradrop generated aside the unit on the paradrop ACE menu action (still for map exploration though)
~ [score_board] survivors in objectives are now restricted to players (no IA) whose life is below 0.975 (unconscious are not survivors anymore)

### V2.3.3 - 2016-09-28
~ [omtk-loadouts] upgrade omtk-loadouts.exe to v1.0.1
~ [omtk-loadouts] add all RHS vehicles in vehicle cargos definition
\+ [omtk-loadouts] add M-88 camo for REDFOR
\+ [omtk-loadouts] add yellow gorka camo for REDFOR
\+ [omtk-loadouts] add UCP camo for BLUEFOR
~ [omtk-loadouts] rename default BLUEFOR loadouts file to bluefor-loadouts-ocp.yml
~ [omtk-loadouts] rename default REDFOR loadouts file to redfor-loadouts-gorka-green.yml
~ [omtk-loadouts] change recon vanilla class to Recon Marksman for BLUEFOR and REDFOR
~ [omtk-loadouts] change tripod_turret_carrier vanilla class to Recon Scout for BLUEFOR and REDFOR
@ [omtk-loadouts] commented path to units in BLUEFOR and REDFOR infantry class files

### v2.3.2 - 2016-09-18
\+ add code snippets in customScripts.sqf
@ [dynamic_startup] fix helper text for markers

### v2.3.1 - 2016-09-13
\+ additional warm-up durations: 45 min and 1 h
~ improve README files
~ change default loadscreen.jpg
@ respawning units without their inital loadout fixed

### v2.3.0 - 2016-09-12
\+ [map_exploration] new module, formely _briefing_ mode in *launch_mode* module  
\+ [respawn_mode] new module to handle separately respawn configuration  
\+ [tactical_paradrop] zones restrictions implemented  
\- [vehicles_configuration] module removed, no more cargo scripting available  
\+ [vehicles_thermalimaging] module to enable/disable TI equipment  
\+ [dynamic_markers] new commandMenu to process markers ()
~ Switch to English  
~ Missions parameters: full refactoring  
~ Refactoring and cleaning of omtk-loadouts configuration folders and files  
~ [launch_mode] renamed to dynamic_startup, enlightened to support markers and interactive modes only.  
~ [score_board] default duration is provided by mission parameter, and can be overrided by *OMTK_SB_MISSION_DURATION_OVERRIDE* parameter in init.sqf  
~ custom_scripts.sqf cleaned  
@ [dynamic_startup] interactive mode loosing flag during teleport is fixed  

### v2.2.0 - 2016-08-07
\+ ajout du changelog  
\+ [tactical_paradrop] nouveau module de parachutage permettant de rendre possible pour chaque camp un saut en chute libre via action dans le menu ACE, avec limitation dans le temps et dans l'espace  
\+ EG Spectator: lancement du script vanilla https://community.bistudio.com/wiki/EG_Spectator_Mode pendant que les joueurs sont morts (avant respawn si respawn il y a comme pendant pour le mode training)  
\+ [vehicle_configuration] TIEquipements disabling is now a mission parameter  
\+ [vehicle_configuration] clearing cargo of unidentified vehicles is now a mission parameter  
~ [score_board] le bouton *quitter* devient *fermer* et ferme seulement le tableau des scores  
~ [launch_mode] le mode *test* rend tous les véhicules égalements invincibles  
~ [launch_mode] parachutage au lieu de téléportaion lors de clic gauche sur map en mode *briefing*  
~ [launch_mode] rename 'teleport' to 'campaign'  
~ [vehicle_configuration] former vehicle_cargos module has been renamed vehicle_configuration  
