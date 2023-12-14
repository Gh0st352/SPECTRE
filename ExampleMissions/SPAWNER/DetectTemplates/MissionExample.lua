--- SPECTRE will automatically detect any group templates for valid spawns.
-- In `DetectTypeTemplates`, provide the string that all spawner eligible templates include. 


-- On detection, SPECTRE sorts and classifies all groups into the appropriate category based on DCS unit attributes.
-- SPECTRE.SPAWNER.typeENUMS contains all types that SPECTRE uses for spawning.

-- If enablePersistence is used, the spawner will save the detected types to use the next time the mission is run, avoiding need to perform detection.
-- enablePersistence takes a string you will use as an identifier for this spawner, and will be the folder name where the data is stored in the SPRECTRE mission folder.

--- SPECTRE works best with single unit groups, or minimum viable group sizes.
-- 
-- You will see in the example mission file, all template types groups have a single unit with the exception of SAMS. 
-- These contain all required units for viable SAM operation.
--
-- When groups are placed, they are dictated by the #1 unit in the group. This is the only unit position checked for validity. 
-- 
-- (Plans and frameworks are in place to handle larger groups in the future.)
--
-- This system allows SPECTRE the most freedom in generation and provides a realistic generation.
--
-- Additionally, it means you only need to place a single unit of each type that you wish to be in your mission.
--
-- No need to create templates for spawned groups, SPECTRE does it for you.
--
-- If you have built out multi-unit group templates, just keep in mind positioning is based on Unit #1

local newSpawner =  SPECTRE.SPAWNER:New():enablePersistence("MIZTypeTemplates_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")