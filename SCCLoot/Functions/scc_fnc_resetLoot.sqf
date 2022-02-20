scc_fnc_resetLoot = {
	
	_numLootSpawned = 0;
	_numContainersSpawned = 0;
	
	// Clean up existing loot
	{
		
		deleteVehicle _x;
		
	} forEach scclootStaticSpots;
	
	{
		
		clearItemCargoGlobal _x;
		clearWeaponCargoGlobal _x;
		clearMagazineCargoGlobal _x;
		clearBackpackCargoGlobal _x;
		
	} forEach scclootStaticContainers;
	
	scclootStaticSpots = [];
	scclootStaticContainers = [];
	
	// Get an array of all buildings
	_allBuildings = [scclootWorldCentre, worldSize] call scc_fnc_findValidBuildings;
	
	// Iterate through buildings		
	{
		
		_currentBuilding = _x;
		
		// Get type of loot to spawn in building
		_currentBuildingLootType = [_currentBuilding] call scc_fnc_getLootType;
		
		// Get loot table for building
		_cbLootTable = [_currentBuildingLootType] call scc_fnc_getLootTable;
		
		// Get positions for building
		_cbPositions = [_currentBuilding] call scc_fnc_getBuildingPositions;
		
		// Iterate through building positions
		{
			
			_cbCurrentPos = _x;
			
			// Spawn loot
			_itemBox = [_cbLootTable, _cbCurrentPos] call scc_fnc_spawnItem;
			
			if (!isNull _itemBox) then {
			
				scclootStaticSpots pushBackUnique _itemBox;	
				_numLootSpawned = _numLootSpawned + 1;
			
			};
			
		} forEach _cbPositions;
		
	} forEach _allBuildings;
	
	if (count scclootContainers > 0) then {
	
		{
			
			_containerName = _x select 0;
			_containerLootType = _x select 1;
			_currentContainer = missionNamespace getVariable [_containerName, objNull];
			
			if !(isNull _currentContainer) then {
			
				// Get loot table
				_currentContainerLootTable = [_containerLootType] call scc_fnc_getLootTable; 
				
				// Spawn item in container
				_numItemsToSpawn = [scclootMinContainerLoot,scclootMaxContainerLoot] call BIS_fnc_randomInt;
				
				for [{_lcCount = 0},{_lcCount < _numItemsToSpawn},{_lcCount = _lcCount + 1}] do {
					
					[_currentContainerLootTable,_currentContainer] call scc_fnc_spawnItem;
					_numContainersSpawned = _numContainersSpawned + 1;
					
				};
				
				scclootStaticContainers pushBackUnique _currentContainer;
				
			};
			
		} forEach scclootContainers;
	
	};
	
	// Write debug output
	if (scclootDebug) then {
	
		_debugMsg = format ["[SCCLoot] Reset all loot in the world (%1 in buildings, %2 in containers)", _numLootSpawned, _numContainersSpawned];
		systemChat _debugMsg;
		
	};
	
};