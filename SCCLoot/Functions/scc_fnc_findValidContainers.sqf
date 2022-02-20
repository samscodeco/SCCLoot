scc_fnc_findValidContainers = {
	
	// Get function parameters
	_paramPos = _this select 0;
	_paramRadius = _this select 1;
	
	_validContainers = [];
	
	{
		
		_containerName = _x select 0;
		_containerLootType = _x select 1;
		_currentContainer = missionNamespace getVariable [_containerName, objNull];
		
		if !(isNull _currentContainer) then {
		
			if (_currentContainer distance2D _paramPos < _paramRadius && !(_currentContainer in scclootCurrentContainersWithLoot)) then {
				
				_validContainers pushBack [_currentContainer, _containerLootType];
				
			};
		
		};
		
	} forEach scclootContainers;

	_validContainers;
	
};