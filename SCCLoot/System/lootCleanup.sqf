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
	
		scclootCurrentBuildingsWithLoot deleteAt _forEachIndex;
		_buildingsClearedThisPass = _buildingsClearedThisPass + 1;
		
	};

} forEach scclootCurrentBuildingsWithLoot;

// Clean up loot containers if any are defined
if (count scclootContainers > 0) then {
	
	{
		
		_containerObj = _x;
		
		_nearestPlayerDist = [_containerObj] call _getNearestPlayer;
		
		if (_nearestPlayerDist > scclootCleanupRange) then {
			
			clearItemCargoGlobal _containerObj;
			clearWeaponCargoGlobal _containerObj;
			clearMagazineCargoGlobal _containerObj;
			clearBackpackCargoGlobal _containerObj;
			scclootCurrentContainersWithLoot deleteAt _forEachIndex;
			
		};
		
	} forEach scclootCurrentContainersWithLoot;
	
};

// Write debug output
if (scclootDebugMessages) then {
	
	_debugMsg = "";
	
	if (_lootClearedThisPass > 0) then {
	
		_debugMsg = format ["[SCCLoot] Cleared %1 items from %2 buildings", _lootClearedThisPass, _buildingsClearedThisPass];
		
	} else {
		
		_debugMsg = format ["[SCCLoot] No items were found to clean up this pass."];
		
	};
	
	systemChat _debugMsg;
	
};