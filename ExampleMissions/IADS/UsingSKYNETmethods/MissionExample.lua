SPECTRE.DebugEnabled = 1

---CONTINUED FROM `BasicZONEMGR`


--- ZONEMGR hotspot setup.
--

SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.


local zoneNames = {"Zone_ALPHA","Zone_BRAVO","Zone_CHARLIE","Zone_DELTA"}

--- The following sets configurations globally for all new ZONEMGRs. If you do not want global changes, you may use them after
-- creating a new ZONEMGR instance (ex. SPECTRE.ZONEMGR:New():enablePersistance():enableHotspots(), etc)
SPECTRE.ZONEMGR:enablePersistance()               -- Enables the ZONEMGR to save data, preventing the need to perform the same operations on subsequent mission starts.
  :setUpdateInterval(120, 0.15)                   -- Sets how often the ZONEMGR will analyze the managed zones and update itself.

zoneManager = SPECTRE.ZONEMGR:New():Setup(zoneNames):Init()

redIADS = SPECTRE.IADS:New(1,zoneManager):createSkynet("REDIADS"):setSkynetUpdateInterval(5):setUpdateInterval(25, 0.25):Init()
blueIADS = SPECTRE.IADS:New(2,zoneManager):createSkynet("BLUEIADS"):setSkynetUpdateInterval(5):setUpdateInterval(25, 0.25):Init()






--- Call Skynet methods via the `SPECTRE.IADS.SkynetIADS` attribute.
-- 
redIADS.SkynetIADS:addRadioMenu()  
redIADS.SkynetIADS:addCommandCenter("CommandCenterName")









-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Dynamically Genberating Units for the example. You may ignore the below information, or see `SPAWNER - AdvancedSpawner` example.
--
-------------------------------------------------------------------------------------------------------------------------------------------------


local REDspawner = SPECTRE.SPAWNER:New()
  :setCoalition(coalition.side.RED) --Set coalition for Spawns
  :setCountry(country.id.CJTF_RED) --Set Country for spawns
REDspawner:enablePersistence("AIRFIELDSPAWNERS_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")
REDspawner:AddExtraTypeToGroupsZONE_A(REDspawner.typeENUMS.GroundUnits, 1)
  :setZoneSizeMain(5000, 2000, 7000, 0.5)
  :setNumSubZones(4, 3, 6, 0.7)
  :setSpawnAmountsZONE_A(20, 10, 25, 0.5)
  :setNamePrefix("SPEC_")
  :setTypeAmounts(REDspawner.typeENUMS.GroundUnits         , 1, false)
  :setTypeAmounts(REDspawner.typeENUMS.Infantry            , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.MRsam               , 2, true)
  :setTypeAmounts(REDspawner.typeENUMS.MobileAAA           , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.SamElements         , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.IRGuidedSam         , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.SRsam               , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.MANPADS             , 1, true)


local BLUEspawner = SPECTRE.SPAWNER:New()
  :setCoalition(coalition.side.BLUE) --Set coalition for Spawns
  :setCountry(country.id.CJTF_BLUE) --Set Country for spawns
BLUEspawner:enablePersistence("AIRFIELDSPAWNERS_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")
BLUEspawner:AddExtraTypeToGroupsZONE_A(BLUEspawner.typeENUMS.GroundUnits, 1)
  :setZoneSizeMain(5000, 2000, 7000, 0.5)
  :setNumSubZones(4, 3, 6, 0.7)
  :setSpawnAmountsZONE_A(20, 10, 25, 0.5)
  :setNamePrefix("SPEC_")
  :setTypeAmounts(BLUEspawner.typeENUMS.GroundUnits         , 1, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.Infantry            , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.MRsam               , 2, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.SamElements         , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.IRGuidedSam         , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.SRsam               , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.MANPADS             , 1, true)


local Kob_ = AIRBASE:FindByName(AIRBASE.Caucasus.Kobuleti):GetVec2()
local Kob_name_ = "Kob_"

local Bat_ = AIRBASE:FindByName(AIRBASE.Caucasus.Batumi):GetVec2()
local Bat_name_ = "Bat_"

local Sen_ = AIRBASE:FindByName(AIRBASE.Caucasus.Senaki_Kolkhi):GetVec2()
local Sen_name_ = "Sen_"

local Kut_ = AIRBASE:FindByName(AIRBASE.Caucasus.Kutaisi):GetVec2()
local Kut_name_ = "Kut_"

--Spawn units with Dynamic ZONE method.
REDspawner:DynamicGenerationZONE(Bat_, Bat_name_)
REDspawner:DynamicGenerationZONE(Sen_, Sen_name_)

BLUEspawner:DynamicGenerationZONE(Kut_, Kut_name_)
BLUEspawner:DynamicGenerationZONE(Kob_, Kob_name_)



local _placeholder = ""
