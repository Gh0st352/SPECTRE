SPECTRE.DebugEnabled = 1

---CONTINUED FROM `ZONEMGR SSB`


--- ZONEMGR hotspot setup.
--

SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.

--- Set your machine learning tuning parameters do determine what is considered a hotspot.
SPECTRE.BRAIN.DBSCANNER.f = 2
SPECTRE.BRAIN.DBSCANNER.p = 0.1

--- Set the zone names to have the ZONEMGR monitor.
--
-- A basic ZONEMGR will:
--
-- Determine which zones border eachother closely
--
-- Determine Zone ownership and set the color of the zone on the F10 map based on ownership. (Zone ownership is determined by majority airfield ownership within the zone.)
--
-- If bordering zones are owned by different coalitions, the ZONEMGR will draw arrows for respective coalitions indicating the frontline of the battlefield.
--
local zoneNames = {"Zone_ALPHA","Zone_BRAVO","Zone_CHARLIE","Zone_DELTA"}

--- The following sets configurations globally for all new ZONEMGRs. If you do not want global changes, you may use them after
-- creating a new ZONEMGR instance (ex. SPECTRE.ZONEMGR:New():enablePersistance():enableHotspots(), etc)
SPECTRE.ZONEMGR:enablePersistance()               -- Enables the ZONEMGR to save data, preventing the need to perform the same operations on subsequent mission starts.
  :setUpdateInterval(120, 0.15)                   -- Sets how often the ZONEMGR will analyze the managed zones and update itself.
  :enableHotspots()                               -- Enables the ZONEMGR to analyze the world state contained in managed zones.
  -- It will draw circular hotspot activity indicators on the F10 Map for players.
  --- HOTSPOTS MUST BE ENABLED
  :enableHotspotIntel()                           -- Enables deeper world state analysis in managed zones.
  -- It will place a text marker in the center of hotspots with a brielf intel summary of units contained within.
  :enableSSB() -- This will automatically manage SSB functions for all client slots at airfields. Also adds ground spawns within 5000m of the airfield to the airfield SSB manager.
--    :addAdmin("7e522cbbdfe9863104f59de24a8347bc")

zoneManager = SPECTRE.ZONEMGR:New():Setup(zoneNames):Init()


--- Create your SPAWNERS
--
--
--
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
  :setTypeAmounts(REDspawner.typeENUMS.LightArmoredUnits   , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.IFV                 , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.APC                 , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.Artillery           , 2, false)
  :setTypeAmounts(REDspawner.typeENUMS.MLRS                , 1, false)
  :setTypeAmounts(REDspawner.typeENUMS.HeavyArmoredUnits   , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.ModernTanks         , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.OldTanks            , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.Tanks               , 5, false)
  :setTypeAmounts(REDspawner.typeENUMS.Buildings           , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.Fortifications      , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.AAA                 , 2, true)
  :setTypeAmounts(REDspawner.typeENUMS.AA_flak             , 1, true)
  :setTypeAmounts(REDspawner.typeENUMS.StaticAAA           , 1, true)
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
  :setTypeAmounts(BLUEspawner.typeENUMS.LightArmoredUnits   , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.IFV                 , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.APC                 , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.Artillery           , 2, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.MLRS                , 1, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.HeavyArmoredUnits   , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.ModernTanks         , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.OldTanks            , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.Tanks               , 5, false)
  :setTypeAmounts(BLUEspawner.typeENUMS.Buildings           , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.Fortifications      , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.AAA                 , 2, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.AA_flak             , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.StaticAAA           , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.MobileAAA           , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.SamElements         , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.IRGuidedSam         , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.SRsam               , 1, true)
  :setTypeAmounts(BLUEspawner.typeENUMS.MANPADS             , 1, true)

-- Create Templates from your Spawners

local template_REDspawner = SPECTRE.UTILS.templateFromObject(REDspawner)
local template_BLUEspawner = SPECTRE.UTILS.templateFromObject(BLUEspawner)

--Just getting a Vec2 for the Vec2 Spawner example
local Kob_ = AIRBASE:FindByName(AIRBASE.Caucasus.Kobuleti):GetVec2()


-- Easily spawn various things
zoneManager:spawnFillAtVec2(Kob_,5000,SPECTRE.Coalitions.Red,SPECTRE.Countries.Red,nil,nil,template_REDspawner)
zoneManager:spawnFillInZone("Zone_ALPHA",SPECTRE.Coalitions.Blue,SPECTRE.Countries.Blue,nil,template_BLUEspawner)
zoneManager:spawnAirbase(AIRBASE.Caucasus.Kutaisi,SPECTRE.Coalitions.Blue,SPECTRE.Countries.Blue, nil,nil,template_BLUEspawner)
zoneManager:spawnAirbasesInZone("Zone_DELTA",SPECTRE.Coalitions.Blue,SPECTRE.Countries.Blue,template_BLUEspawner)



local _placeholder = ""
