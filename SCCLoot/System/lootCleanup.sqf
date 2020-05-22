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
_buildingsToDelete = [];

{
	
	
	
	_buildingObject = _x select 0;
	_buildingLootSpots = _x select 1;
	_buildingDistance = player distance _buildingObject;

	_nearestPlayerDist = [_buildingObject] call _getNearestPlayer;
	
	if (_nearestPlayerDist > scclootCleanupRange) then {
	
		{
		
			deleteVehicle _x;
			_lootClearedThisPass = _lootClearedThisPass + 1;
		
		} forEach _buildingLootSpots;

		_buildingsClearedThisPass = _buildingsClearedThisPass + 1;
		
	};

} forEach scclootCurrentBuildingsWithLoot;

// Remove buildings from the array
{

	scclootCurrentBuildingsWithLoot deleteAt (scclootCurrentBuildingsWithLoot find _x);

} forEach _buildingsToDelete;

// Write debug output for buildings
if (scclootDebugMessages) then {
	
	_debugMsg = "";
	
	if (_lootClearedThisPass > 0) then {
	
		_debugMsg = format ["[SCCLoot] Cleared %1 items from %2 buildings.", _lootClearedThisPass, _buildingsClearedThisPass];
		
	} else {
		
		_debugMsg = format ["[SCCLoot] No items were found to clean up this pass."];
		
	};
	
	systemChat _debugMsg;
	
};

// Clean up loot containers if any are defined
if (count scclootContainers > 0) then {
	
	_containersClearedThisPass = 0;
	_lootContainersToDelete = [];
	
	// Remove items from the container
	{
		
		_containerObj = _x;
		
		_nearestPlayerDist = [_containerObj] call _getNearestPlayer;
		
		if (_nearestPlayerDist > scclootCleanupRange) then {
			
			clearItemCargoGlobal _containerObj;
			clearWeaponCargoGlobal _containerObj;
			clearMagazineCargoGlobal _containerObj;
			clearBackpackCargoGlobal _containerObj;
			_lootContainersToDelete pushBack _x;
			_containersClearedThisPass = _containersClearedThisPass + 1;
			
		};
		
	} forEach scclootCurrentContainersWithLoot;
	
	// Remove container from the array
	{
	
		scclootCurrentContainersWithLoot deleteAt (scclootCurrentContainersWithLoot find _x);
	
	} forEach _lootContainersToDelete;
	
};

// Write debug output for containers
if (scclootDebugMessages) then {
	
	_debugMsg = "";
	
	if (_lootClearedThisPass > 0) then {
	
		_debugMsg = format ["[SCCLoot] Cleared %1 containers.", _containersClearedThisPass];
		
	} else {
		
		_debugMsg = format ["[SCCLoot] No containers were found to clean up this pass."];
		
	};
	
	systemChat _debugMsg;
	
};