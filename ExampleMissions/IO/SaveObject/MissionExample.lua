SPECTRE.DebugEnabled = 1



SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.


--- Enable Perisitence and set the folder name
SPECTRE:Persistence("ExampleMiz")

--Saves an object to a specified file within the SPECTRE directory. 
-- We are going to export SPECTRE itself to "ExportedSPECTRE.lua" inside the DCS Saved Games Mission folder.
-- you can provide a path such as "ExportedStuff/ExportedSPECTRE.lua"
-- the optional boolean flag, when set to true, skips exporting functions associated with the object.
SPECTRE.IO.PersistenceToFile("ExportedSPECTRE.lua", SPECTRE, true)

local _placeholder = ""
