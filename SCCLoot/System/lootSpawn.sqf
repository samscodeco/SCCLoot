while {true} do {
	
	if (scclootEnableSpawn) then {
	
		// Set spawning flag to true and wait for cleanup to finish
		scclootSpawnerActive = true;
		waitUntil {!scclootCleanupActive};
		
		// Variables for debug
		_spawnedBuildings = 0;
		_spawnedContainers = 0;

		// Iterate through players
		{
			
			_currentPlayer = _x;
			_currentPlayerPos = getPos _x;
			
			// Only try to spawn loot if the player is alive
			if (alive _currentPlayer) then {
			
				// Get array of all valid buildings within range of the player
				_validBuildings = [_currentPlayerPos, scclootSpawnRange] call scc_fnc_findValidBuildings;

				// Iterate through all valid buildings
				{
					
					_currentBuilding = _x;
					
					// Get type of loot to spawn
					_currentBuildingLootType = [_currentBuilding] call scc_fnc_getLootType;
					
					// Get building positions
					_currentBuildingPositions = [_currentBuilding] call scc_fnc_getBuildingPositions;
					
					// Get correct loot table
					_currentBuildingLootTable = [_currentBuildingLootType] call scc_fnc_getLootTable;
					
					// Create array for keeping track of spawned item boxes
					_currentBuildingItemBoxes = [];
					
					// Iterate through building positions
					{
						
						_currentBuildingPos = _x;
						
						// Get item to spawn
						_currentItemBox = [_currentBuildingLootTable, _currentBuildingPos] call scc_fnc_spawnItem;
						
						// Add the item box to the list of item box objects for this building
						_currentBuildingItemBoxes pushBack _currentItemBox;
						_spawnedBuildings = _spawnedBuildings + 1;
						
					} forEach _currentBuildingPositions;
					
					// Add to the list of buildings with loot
					_withLootArrayEntry = [_currentBuilding, _currentBuildingItemBoxes];
					scclootCurrentBuildingsWithLoot pushBack _withLootArrayEntry;
					
				} forEach _validBuildings;
					
				// Check for nearby containers
				_nearbyContainers = [_currentPlayerPos, scclootSpawnRange] call scc_fnc_findValidContainers;
				
				if ((count _nearbyContainers) > 0) then {
					
					{
						
						_currentContainerObj = _x select 0;
						_currentContainerLootType = _x select 1;
						
						// Get loot table
						_currentContainerLootTable = [_currentContainerLootType] call scc_fnc_getLootTable; 
						
						// Spawn item(s) in container
						_numItemsToSpawn = [scclootMinContainerLoot,scclootMaxContainerLoot] call BIS_fnc_randomInt;
						
						for [{_lcCount = 0},{_lcCount < _numItemsToSpawn},{_lcCount = _lcCount + 1}] do {
						
							[_currentContainerLootTable,_currentContainerObj] call scc_fnc_spawnItem;
							_spawnedContainers = _spawnedContainers + 1;
						
						};
						
						// Add to the list of containers with loot
						scclootCurrentContainersWithLoot pushBack _currentContainerObj;
						
					} forEach _nearbyContainers;
					
				};
				
			};
		
		} forEach allPlayers;
	
		if (scclootDebug) then {
	
			_debugMsg = format ["[SCCLoot] Spawned %1 items in buildings, %2 in containers.", _spawnedBuildings, _spawnedContainers];
			systemChat _debugMsg;
	
		};
		
	};
	
	// Set spawner as inactive and sleep for time specified in config file
	scclootSpawnerActive = false;
	sleep scclootSpawnWaitTime;
	
};