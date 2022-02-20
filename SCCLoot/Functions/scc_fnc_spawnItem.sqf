// scc_fnc_spawnItem
//
// Parameters: Loot table (array), Container (object) OR Coordinates (posAGL)
// Returns: Container (object)
//
// Picks an item from the loot table and spawns it in a container.
// If an object is provided, will try to spawn the item inside.
// If coordinates are provided, creates a WeaponHolderSimulated and spawns the item inside.

scc_fnc_spawnItem = {
	
	_getLowestChance = {
		
		// Read item list
		_itemList = _this select 0;
		
		// Set variables
		_currentLowestChance = 101;
		_currentWithLowestChance = [];
		
		// Iterate through list of items
		{
			
			_entryToCheck = _x;
			_chanceToCheck = _x select 1;
			
			// If the chance is lower than the current lowest chance
			if (_chanceToCheck < _currentLowestChance) then {
				
				// Create a new array and add the item
				_currentLowestChance = _chanceToCheck;
				_currentWithLowestChance = [];
				_currentWithLowestChance pushBack _entryToCheck;
				
			} else {
				
				// If the chance is equal to the current lowest chance
				if (_chanceToCheck == _currentLowestChance) then {
					
					// Add to the array to be selected from at random
					_currentWithLowestChance pushBack _entryToCheck;
					
				};
				
			};
			
			
		} forEach _itemList;
		
		// Return a random item from those with the lowest chance
		(selectRandom _currentWithLowestChance) select 0;
		
	};
	
	// Get params
	_lootTable = _this select 0;
	_itemLoc = _this select 1;
	
	_itemBox = objNull;
	
	// Select potential loot
	_randomNumber = [1,100] call BIS_fnc_randomInt;

	// Array for potential items to spawn
	_possibleItemsToSpawn = [];

	{

		if (_x select 1 >= _randomNumber) then {
		
			_possibleItemsToSpawn pushBack _x;
			
		};
		
	} forEach _lootTable;
	
	if (count _possibleItemsToSpawn > 0) then {
	
		// Pick item with the lowest chance out of potential items
		_itemToSpawn = [_possibleItemsToSpawn] call _getLowestChance;

		// If item box object not provided, create one at coords provided
		if (typeName _itemLoc == "OBJECT") then {
			
			_itemBox = _itemLoc;
		
		} else {
			
			_itemBox = createVehicle ["WeaponHolderSimulated", _itemLoc, [], 0, "CAN_COLLIDE"];
			_itemBox enableSimulation false;
			
			_itemLoc set [2,(_itemLoc select 2) + 1];			
			_itemBox setVehiclePosition [_itemLoc, [], 0, "CAN_COLLIDE"]
		
		};
	
		// If item is a backpack, use addBackpackCargoGlobal instead of addItemCargoGlobal
		if (_itemToSpawn isKindOf "bag_base") then {
			
			_itemBox addBackpackCargoGlobal [_itemToSpawn,1];
			
		} else {
			
			_itemBox addItemCargoGlobal [_itemToSpawn,1];
			
		};
		
		// Get magazines from config
		_itemToSpawnIsWeapon = 0;
		_itemMags = getArray (configFile >> "CfgWeapons" >> _itemToSpawn >> "magazines");
		
		// If item has associated magazines, spawn some
		if (count _itemMags > 0) then {
		
			_mag = _itemMags select (floor (random (count _itemMags)));
			_numberOfMagsToSpawn = [scclootMinMagazinesToSpawn,scclootMaxMagazinesToSpawn] call BIS_fnc_randomInt;
			_itemBox addMagazineCargoGlobal [_mag,_numberOfMagsToSpawn];
			
		};

	};
	
	_itemBox;
	
};