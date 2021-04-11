SCCLoot for Arma 3 (Version 0.5 - 2021-04-11)
by samscodeco <sam@samscode.co>

This script adds simple, configurable loot spawning to any Arma 3 mission.

If you have a question, suggestions or feedback, I can be contacted by email or on the BIS forums.

Making a mission using this script? Let me know! I'd love to check it out.

-----------------------------------
1. INSTALLATION
-----------------------------------

1. Place the 'SCCLoot' folder inside the root mission directory.
2. Add the following line to your mission's init.sqf: 

[] execVM "SCCLoot\lootInit.sqf";

-----------------------------------
2. CONFIGURATION
-----------------------------------

SCCLoot is designed to be highly configurable, containing several different modules, each with their own config file.

-----------------------------------
2.1 Quick Configuration Guide
-----------------------------------

In order to set up and configure the loot system for your mission, edit the following files, found in 'SCCLoot\Config':

lootConfig.sqf - Contains basic settings for the loot system. These include things such as the distance players must be from a building for loot to spawn, the time between running the loot system or enabling/disabling debug messages.

lootBuildings.sqf - Lists all buildings and the types of loot they spawn. You can also add buildings to the blacklist so that they are ignored by the loot system. By default, this contains all buildings from Arma 3 and CUP terrains.

lootTables.sqf - This is probably the only config file you'll need to make major changes to. It contains a list of items and their chances to spawn for each category of loot.

Example loot table:

scclootIndustrial = [

	["H_Hat_blue",100],
	["H_Hat_tan",75],
	["H_StrawHat",50]

];

If you recieve error messages after making changes to the config files, check carefully for missing semicolons (;), quotes (") or square brackets ([]).

-----------------------------------
2.2 Adding New Loot Categories
-----------------------------------

By default, there are 5 categories of loot: Civilian, Industrial, Military, Medical and Supermarket. There is also a sixth category (default/undefined) which will spawn in any building that is not assigned to one of those five. However you can easily add more categories by making a slight edit to the main script.

Step 1 - Create the loot table - You'll need to add the new loot table in 'Config\lootTables.sqf'. You can name this anything, however it's a good idea to prefix it with 'sccloot' so it does not interfere with any other global variables being used in the mission.

Step 2 - Add it the loot spawner - open up 'System\lootSpawn.sqf'. Scroll down until you find the section 'Loot Categories'. Add a new entry to the switch statement. In the following example, we're adding a sixth loot category named "exampleLootTable".

  case 6: {
    _currentBuildingLootArray = exampleLootTable;
  };

Step 3 - Get some buildings to use your new category - Find the list of buildings in 'Config\lootBuildings.sqf'. Add new entries to the array 'scclootListBuildings' with each building classname and the number of the new loot category. For example:
  
  ["Land_Metal_Shed_F", 6],

Make sure that there are no duplicate building names in the array, otherwise they may not spawn loot from the correct category.

-----------------------------------
2.3 Custom Building Positions
-----------------------------------

Most buildings in the Arma series have a bunch of pre-defined positions associated with them, which the script uses as the locations to spawn loot. However, some buildings (despite being accessible) don't have any - or maybe you just don't like the defaults and want to make your own. This can be done using 'Config\lootAddedBuildings.sqf'.

Step 1 - Mark the new positions - Open up your mission and place the building you wish to add/modify the positions for. Then, add some markers wherever you'd like loot to spawn (these can be any object).

Step 2 - Get the relative positions - Press ESC to bring up the debug console and run: 
	
	["marker", building] call SCC_fnc_getCustomBuildingPositions;
	
Where 'marker' is the classname of the marker objects you have placed and 'building' is the building you're getting custom positions for. This will output an array containing the coordinates of every marker in relation to the model. Select and copy the entire output.

Step 3 - Add the new positions to the config file - Open up 'Config\lootAddedBuildings.sqf' and create a new entry with the format [Building Classname, Positions] where Positions is the output of the script run in step 2.

Step 4 - Specify the type of loot to spawn - Create a new entry in 'Config\lootBuildings.sqf' with the building classname and the number corresponding to the correct category.

-----------------------------------
2.4 Custom Loot Containers/Boxes
-----------------------------------

The loot system also allows you to place your own boxes, crates or containers and have them spawn and clean up items automatically.

Step 1 - Place the containers - Open your mission and place the containers you wish to spawn loot. Give them unique variable names.

Step 2 - Add containers to the config file - Open 'SCCLoot\Config\lootContainers.sqf" and add your container to the array in the format ["containerName", loot type].

-----------------------------------
3. FAQ
-----------------------------------

Q: Can I edit/use/reupload this?
A: You are free to use or modify this script in any way, as long as the original copyright notice is retained.

Q: How do I modify the script to do x/y?
A: Make sure to read through this Readme carefully for help with configuring the script. If you're still stuck, get in touch!

-----------------------------------
4. LICENSE
-----------------------------------

This script released under the BSD License. You are free to modify or distribute it, provided that the original copyright notice is retained. For more information, see the license file in the source directory.

-----------------------------------
5. SPECIAL THANKS
-----------------------------------

- BIS Forums/Wiki contributors for answering all my dumb questions.
- The r/armadev and r/arma communities for help and inspiration respectively.
