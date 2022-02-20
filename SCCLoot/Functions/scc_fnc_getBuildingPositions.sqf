// scc_fnc_getBuildingPositions
//
// Parameters: Building (object)
// Returns: List of positions (array of coordinates)
//
// Gets the coordinates of all positions for a type of building.

scc_fnc_getBuildingPositions = {
	
	_buildingObj = _this select 0;
	_buildingType = typeOf _buildingObj;
	_buildingPositions = [];
	_buildingIsCustom = false;
	_buildingPosNum = 0;

	// Test if building has custom positions defined in config
	{
		
		_currentEntry = _x;
		_currentEntryType = _x select 0;
		
		if (_currentEntryType == _buildingType) then {
			
			_buildingIsCustom = true;
			
		};
		
	} forEach scclootCustomPosBuildings;

	if (_buildingIsCustom) then {
		
		_customPositionsRelative = [];
		
		{
			
			_entryName = _x select 0;
			_entryPos = _x select 1;
			
			if (_entryName == _buildingType) then {
				
				_customPositionsRelative = _entryPos;
				
			};
			
		} forEach scclootCustomPosBuildings;
		
		{
			
			_buildingPositions pushBack (_buildingObj modelToWorld _x);
			
		} forEach _customPositionsRelative;
		
	} else {

		_buildingPositions = [_x] call BIS_fnc_buildingPositions;
		
	};
	
	_buildingPositions;
	
};