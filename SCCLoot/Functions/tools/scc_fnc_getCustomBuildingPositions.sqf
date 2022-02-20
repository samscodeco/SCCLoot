// scc_fnc_getCustomBuildingPositions
//
// Parameters: 	
// Marker (String) - Class of the marker objects, e.g. "Sign_Arrow_Large_Green_F"
// Structure (Object) - Structure to apply the custom positions to
//
// Returns:
// Array of positions
//
// Gets positions of custom position markers

SCC_fnc_getCustomBuildingPositions = {
	
	// Get parameters
	_markerClass = _this select 0;
	_buildingObject = _this select 1;
	
	// Create array of positions
	_posArray = [];
	
	// Iterate through nearest objects
	{
		
		// If the object is a marker, add relative position to the array
		if (typeOf _x == _markerClass) then {
			
			_posArray pushBack (_buildingObject worldToModel ASLToAGL (getPosASL _x));
			
		};
		
	} forEach (nearestObjects [player, [], 500]);
	
	// Return list of custom building positions
	str _posArray;
	
};