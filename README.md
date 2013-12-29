Procedural Dungeon Generator
============================

Generates random dungeons

Features several dungeon generation algorithms:
- Basic: This algorithm places random rooms in the grid, then connects them with corridors using A* pathfinding
- Cellular Automata: Based on algorithm by Jim Babcock
- BSP: Dungeon generation based on BSP algorithm from RogueBasin
- Build/Growth: Based on algorithm from RogueBasin by Mike Anderson

The dungeon generation code is organized such that it will be very easy to add new dungeon generation algorithms in the future. The code will create a grid in the form of a 2D array grid, and pass the array to the dungeon generation algorithm. Too add a new algorithm, just create a new file that contains the algorithm, and pass the 2D array to it.
 
Instruction
-----------

Press 'space' to generate new dungeon, play around with the parameters and see how they affect the dungeon. Click save to output the dungeon to a text file.

History
-------

Version 1.2 - 2013/12/29
- Updated to work with Processing 2

Version 1.1 - 2011/11/01
- Added option to output dungeon as a text file
- Improved Cellular Automata algorithm

Version 1.0 - 2011/10/31
- Updated controls to improve performance
- Cleaned up code

Version 0.9 - 2011/10/30
- Added Build dungeon generation algorithm
- Cleaned up code

Version 0.7 - 2011/10/29
- Added BSP dungeon generation algorithm
- Added Cellular Automata dungeon generation algorithm
- Cleaned up code

Version 0.5 - 2011/10/28
- Finished Basic dungeon generation algorithm
- Added A* pathfinding algorithm for corridor generation
- Refactored code for flexibility and clarity

Version 0.2 - 2011/10/26
- Finished world generation interface
- Finished map generator
- Added basic procedural map generation algorithm  
