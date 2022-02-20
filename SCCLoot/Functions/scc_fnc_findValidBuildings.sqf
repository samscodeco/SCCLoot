// scc_fnc_findValidBuildings
//
// Parameters: Position, Radius
// Returns: Array of building objects
//
// Takes a position and radius, returns list of valid buildings for loot spawning.

scc_fnc_findValidBuildings = {
	
	// Checks if type of building is blacklisted
	_checkBlacklisted = {
		
		_currentBuildingType = typeOf (_this select 0);
		_buildingNotBlacklisted = true;

		if (_currentBuildingType in scclootBlacklistBuildings) then {
			
			_buildingNotBlacklisted = false;
			
		};

		_buildingNotBlacklisted;
	
	};
	
	// Checks if type of building has positions
	_checkPositions = {
		
		_buildingObject = _this select 0;
		_buildingHasPositions = false;
		_numBuildingPositions = count ([_buildingObject] call BIS_fnc_buildingPositions);
		
		if (_numBuildingPositions > 0) then {
		
			_buildingHasPositions = true;
		
		} else {
		
			// Check for custom positions defined in config file
			{
				
				if ((typeOf _buildingObject) in _x) then {
					
					_buildingHasPositions = true;
					
				};
				
			} forEach scclootCustomPosBuildings;
			
		};
		
		_buildingHasPositions;
		
	};
	
	// Checks if building object already has loot spawned
	_checkLoot = {
		
		_buildingObject = _this select 0;
		_buildingNoLoot = true;
		
		{
			
			if (_buildingObject == _x select 0) then {
				
				_buildingNoLoot = false;
				
			};
			
		} forEach scclootCurrentBuildingsWithLoot;
		
		_buildingNoLoot;
		
	};
	
	// Get function parameters
	_paramPos = _this select 0;
	_paramRadius = _this select 1;
	
	// List of valid building objects to return
	_validBuildingList = [];
	
	// Get array of all buildings within range
	_buildings = nearestObjects [_paramPos,["building"],_paramRadius];

	// For each building within range
	{
	
		// Set building variables
		_buildingObject = _x;
		_buildingAlreadyHasLoot = false;
		_currentBuildingClass = typeOf _buildingObject;
		
		// Only continue spawning if building is not blacklisted, has valid positions and has not spawned loot already
		if ([_buildingObject] call _checkBlacklisted && [_buildingObject] call _checkPositions && [_buildingObject] call _checkLoot) then {
			
			_validBuildingList pushBack _buildingObject;
			
		};
	
	} forEach _buildings;
	
	_validBuildingList;
	
};