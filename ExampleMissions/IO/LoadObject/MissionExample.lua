SPECTRE.DebugEnabled = 1



SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.


--- Enable Perisitence and set the folder name
SPECTRE:Persistence("ExampleMiz")

--- Loading the exported SPECTRE from the SaveObject Example
-- use the same path you used to save the file.

local ImportedSPECTRE = SPECTRE.IO.PersistenceFromFile("ExportedSPECTRE.lua")

local _placeholder = ""
