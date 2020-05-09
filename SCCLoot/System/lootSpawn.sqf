// Vars for debug messages
_lootSpawnedThisPass = 0;
_buildingsWithoutLootThisPass = 0;
_buildingsBlacklistedThisPass = 0;

_getLowestChance = {
	
	_itemList = _this select 0;
	
	_currentLowestChance = 101;
	_currentWithLowestChance = [];
	
	{
		
		_entryToCheck = _x;
		_classToCheck = _x select 0;
		_chanceToCheck = _x select 1;
		
		if (_chanceToCheck < _currentLowestChance) then {
			
			_currentLowestChance = _chanceToCheck;
			_currentWithLowestChance = [];
			_currentWithLowestChance pushBack _entryToCheck;
			
		} else {
			
			if (_chanceToCheck == _currentLowestChance) then {
				
				_currentWithLowestChance pushBack _entryToCheck;
				
			};
			
		};
		
		
	} forEach _itemList;
	
	_currentWithLowestChance;
	
};

_getLootTable = {
	
	_lootType = _this select 0;
	
	// Loot Categories
	// Get correct array to spawn items from
	_lootArray = [];
	
	switch (_lootType) do {
		
		case 1: {
			_lootArray = scclootCivil;
		};
		
		case 2: {
			_lootArray = scclootIndustrial;
		};
		
		case 3: {
			_lootArray = scclootMilitary;
		};
		
		case 4: {
			_lootArray = scclootMedical;
		};
		
		case 5: {
			_lootArray = scclootSupermarket;
		};
		
		default {
			_lootArray = scclootDefault;
		};
		
	};
	
	_lootArray;
	
};

{
	
	_currentPlayer = _x;
	
	// Only try to spawn loot if the player is alive
	if (alive _currentPlayer) then {
	
		// Get array of all buildings within range of the player
		_buildings = nearestObjects [getPos _currentPlayer,["building"],scclootSpawnRange];

		// For every building within range of the player
		{
			_buildingObject = _x;
			_buildingAlreadyHasLoot = false;
			_buildingIsOnBlacklist = false;
			_currentBuildingClass = typeOf _buildingObject;
			
			// Check if building is blacklisted from spawning loot
			if (count scclootBlacklistBuildings > 0) then {
			
				{
					
					_currentBlacklistBuilding = _x;
					
					if ((toLowerANSI _currentBuildingClass) == _currentBlacklistBuilding) then {
						
						_buildingIsOnBlacklist = true;
						_buildingsBlacklistedThisPass = _buildingsBlacklistedThisPass + 1;
						
					};
					
				} forEach scclootBlacklistBuildings;
			
			};
			
			if (!_buildingIsOnBlacklist) then {
				
				// Check if building has custom positions
				_isBuildingCustom = false;
				
				if ((toLowerANSI _currentBuildingClass) in scclootCustomPosClassnames) then {
					
					_isBuildingCustom = true;
					
				};
				
				// Only try to spawn if the building has positions
				_numBuildingPositions = count ([_buildingObject] call BIS_fnc_buildingPositions);
				if (_numBuildingPositions > 0 || _isBuildingCustom) then {
					
					if (count scclootCurrentBuildingsWithLoot > 0) then {
					
						// Check if building already has loot spawned
						{
							
							if (_x select 0 == _buildingObject) then {
							
								_buildingAlreadyHasLoot = true;
								
							};
							
						} forEach scclootCurrentBuildingsWithLoot;
						
					};
					
					// If building does not have any loot spawned
					if (!_buildingAlreadyHasLoot) then {
						
						_currentBuildingLootSpots = [];
						
						// Convert the object to a building classname
						_currentBuildingType = 0;

						// Search for current building in the loot config to get its loot spawn type
						{
							
							if ((toLowerANSI _currentBuildingClass) == (toLowerANSI (_x select 0))) then {
							
								_currentBuildingType = _x select 1;
								
							};
							
						} forEach scclootListBuildings;
						
						_currentBuildingLootArray = [_currentBuildingType] call _getLootTable;
						
						// Get array of all building positions
						_buildingPositions = [];
						
						if (_isBuildingCustom) then {
							
							_customPositionsRelative = [];
							
							{
								
								_entryName = _x select 0;
								_entryPos = _x select 1;
								
								if (_entryName == (toLowerANSI _currentBuildingClass)) then {
									
									_customPositionsRelative = _entryPos;
									
								};
								
							} forEach scclootCustomPosBuildings;
							
							{
								
								_buildingPositions pushBack (_buildingObject modelToWorld _x);
								
							} forEach _customPositionsRelative;
							
						} else {
						
							_buildingPositions = [_x] call BIS_fnc_buildingPositions;
							
						};
						
						// Iterate through usable building positions
						{
							
							// Select which items can spawn at the current position
							_randomNumber = [1,100] call BIS_fnc_randomInt;
							_possibleItemsToSpawn = [];
							{
							
								if (_x select 1 >= _randomNumber) then {
								
									_possibleItemsToSpawn pushBack _x;
									
								};
								
							} forEach _currentBuildingLootArray;
							
							// Only try to spawn items if there are items to spawn
							if ((count _possibleItemsToSpawn) > 0) then {
								
								// Give rarest loot that can spawn priority		
								_itemsToSpawnFinal = [_possibleItemsToSpawn] call _getLowestChance;
								
								_itemToSpawn = selectRandom _itemsToSpawnFinal;
								
								// Spawn the item
								_itemToSpawnClass = _itemToSpawn select 0;
								_itemBox = createVehicle ["WeaponHolderSimulated", [0,0,0], [], 0, "CAN_COLLIDE"];
								_itemSpawned = _itemBox addItemCargoGlobal [_itemToSpawnClass,1];
								
								// Get magazines from config
								_itemToSpawnIsWeapon = 0;
								_itemMags = getArray (configFile >> "CfgWeapons" >> _itemToSpawnClass >> "magazines");
								
								// If item has associated magazines, spawn some
								if (count _itemMags > 0) then {
								
									_mag = _itemMags select (floor (random (count _itemMags)));
									_numberOfMagsToSpawn = [scclootMinMagazinesToSpawn,scclootMaxMagazinesToSpawn] call BIS_fnc_randomInt;
									_itemBox addMagazineCargoGlobal [_mag,_numberOfMagsToSpawn];
									
								};
								
								_posToSpawnLoot = _x;
								
								// Try to move loot using setVehiclePosition to avoid floor clipping. If this is not possible, use setPos with a Y offset instead.
								if (!(_itemBox setVehiclePosition [_posToSpawnLoot, [], 0, "CAN_COLLIDE"])) then {
								
									_lootSpawnPositionOffset = 1;
									_posToSpawnLoot set [2,(_posToSpawnLoot select 2) + _lootSpawnPositionOffset];
									_itemBox setPos _posToSpawnLoot;
									
								};
								
								// Add the item box to the list of item boxes for the current building
								_currentBuildingLootSpots pushBack _itemBox;
								
							}
							
						} forEach _buildingPositions;
						
						// Add building and all associated item boxes to array
						_arrayEntry = [_buildingObject, _currentBuildingLootSpots];
						scclootCurrentBuildingsWithLoot pushBack _arrayEntry;
						
						_buildingsWithoutLootThisPass = _buildingsWithoutLootThisPass + 1;
						
					};
				
				};
				
			};
			
		} forEach _buildings;
		
		// Get nearby containers
		if (count scclootContainers > 0) then {
			
			// Iterate through containers
			{
				_containerName = _x select 0;
				_containerType = _x select 1;
				_containerObj = missionNamespace getVariable [_containerName, objNull];
				_containerLootArray = [_containerType] call _getLootTable;
				
				// If player is within range
				if (_currentPlayer distance _containerObj < scclootSpawnRange) then {
					
					if (!(_containerObj in scclootCurrentContainersWithLoot)) then {
					
						// Select which items can spawn at the current position
						_randomNumber = [1,100] call BIS_fnc_randomInt;
						_possibleItemsToSpawn = [];
						{
						
							if (_x select 1 >= _randomNumber) then {
							
								_possibleItemsToSpawn pushBack _x;
								
							};
							
						} forEach _containerLootArray;
						
						_itemToSpawnClass = "";
						
						// Only try to spawn items if there are items to spawn
						if ((count _possibleItemsToSpawn) > 0) then {
							
							// Give rarest loot that can spawn priority		
							_itemsToSpawnFinal = [_possibleItemsToSpawn] call _getLowestChance;
							
							_itemToSpawn = selectRandom _itemsToSpawnFinal;
							
							// Spawn the item
							_itemToSpawnClass = _itemToSpawn select 0;
							
							_itemSpawned = _containerObj addItemCargoGlobal [_itemToSpawnClass,1];
							
						};
						
						// Get magazines from config
						_itemToSpawnIsWeapon = 0;
						_itemMags = getArray (configFile >> "CfgWeapons" >> _itemToSpawnClass >> "magazines");
						
						// If item has associated magazines, spawn some
						if (count _itemMags > 0) then {
						
							_mag = _itemMags select (floor (random (count _itemMags)));
							_numberOfMagsToSpawn = [scclootMinMagazinesToSpawn,scclootMaxMagazinesToSpawn] call BIS_fnc_randomInt;
							_containerObj addMagazineCargoGlobal [_mag,_numberOfMagsToSpawn];
							
						};
						
						scclootCurrentContainersWithLoot pushBack _containerObj;
						
					};
					
				};
				
			} forEach scclootContainers;
			
		};
		
	};
	
} forEach allPlayers;



// Write debug output
if (scclootDebugMessages) then {
	
	_debugMsg = "";
	
	if (_lootSpawnedThisPass > 0) then {
	
		_debugMsg = format ["[SCCLoot] Successfully created %1 items in %2 buildings (%3 blacklisted)", _lootSpawnedThisPass, _buildingsWithoutLootThisPass, _buildingsBlacklistedThisPass];
		
	} else {
		
		_debugMsg = format ["[SCCLoot] No more loot was spawned this pass (%1 buildings blacklisted)", _buildingsBlacklistedThisPass];
		
	};
	
	systemChat _debugMsg;
	
};