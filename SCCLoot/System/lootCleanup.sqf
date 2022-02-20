while {true} do {
	
	if (scclootEnableCleanup) then {
	
		// Set cleanup flag to true and wait for spawning to finish
		scclootCleanupActive = true;
		waitUntil {!scclootSpawnerActive};
		
			_lootClearedThisPass = 0;
			_buildingsClearedThisPass = 0;

			_getNearestPlayer = {
				
				_structureObj = _this select 0;
				
				_nearestPlayer = objNull;
				_currentNearestDist = worldSize;
				
				{
					
					_currentPlayer = _x;
					
					// Only check alive players
					if (alive _currentPlayer) then {
						
						_currentDist = _currentPlayer distance _structureObj;
						
						if (_currentDist < _currentNearestDist) then {
							
							_currentNearestDist = _currentDist;
							
						};
						
					};
					
				} forEach allPlayers;
				
				_currentNearestDist;
				
			};

			// Clean up buildings
			_newCurrentBuildingArray = [];
			
			{
				
				_buildingObject = _x select 0;
				_buildingLootSpots = _x select 1;
				_nearestPlayerDist = [_buildingObject] call _getNearestPlayer;
				
				if (_nearestPlayerDist > scclootCleanupRange) then {
				
					{
					
						deleteVehicle _x;
						_lootClearedThisPass = _lootClearedThisPass + 1;
					
					} forEach _buildingLootSpots;
					
					_buildingsClearedThisPass = _buildingsClearedThisPass + 1;
					
				} else {
					
					_newCurrentBuildingArray pushBackUnique _x;
					
				};
				
			} forEach scclootCurrentBuildingsWithLoot;
			
			scclootCurrentBuildingsWithLoot = _newCurrentBuildingArray;

			// Write debug output for buildings
			if (scclootDebug) then {
				
				_debugMsg = "";
				
				if (_lootClearedThisPass > 0) then {
				
					_debugMsg = format ["[SCCLoot] Cleared %1 items from %2 buildings.", _lootClearedThisPass, _buildingsClearedThisPass];
					
				} else {
					
					_debugMsg = format ["[SCCLoot] No items were found to clean up this pass."];
					
				};
				
				systemChat _debugMsg;
				
			};
			
			// Clean up loot containers if any are defined
			_containersClearedThisPass = 0;

			if (count scclootContainers > 0) then {
				
				_newCurrentContainerArray = [];
				
				// Remove items from the container
				{
					
					_containerObj = _x;
					_nearestPlayerDist = [_containerObj] call _getNearestPlayer;
					
					if (_nearestPlayerDist > scclootCleanupRange) then {
						
						clearItemCargoGlobal _containerObj;
						clearWeaponCargoGlobal _containerObj;
						clearMagazineCargoGlobal _containerObj;
						clearBackpackCargoGlobal _containerObj;
						
						_containersClearedThisPass = _containersClearedThisPass + 1;
						
					} else {
						
						_newCurrentContainerArray pushBackUnique _containerObj;
						
					};
					
				} forEach scclootCurrentContainersWithLoot;
				
				scclootCurrentContainersWithLoot = _newCurrentContainerArray;
				
			};

			// Write debug output for containers
			if (scclootDebug) then {
				
				_debugMsg = "";
				
				if (_lootClearedThisPass > 0) then {
				
					_debugMsg = format ["[SCCLoot] Cleared %1 containers.", _containersClearedThisPass];
					
				} else {
					
					_debugMsg = format ["[SCCLoot] No containers were found to clean up this pass."];
					
				};
				
				systemChat _debugMsg;
				
			};
		
		scclootCleanupActive = false;
	
	} else {
		
		if (scclootDebug) then {
			
			systemChat "[SCCLoot] Loot cleanup did not run as it is disabled. What a mess!"
			
		};
		
	};
	
	sleep scclootCleanupWaitTime;
	
};