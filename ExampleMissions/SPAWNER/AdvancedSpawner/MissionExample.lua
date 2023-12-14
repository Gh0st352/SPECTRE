--- Continued from "BasicSpawner" Example.

SPECTRE.DebugEnabled = 1


--- Full advanced spawner setup.

-- Advanced and ZONEMGR spawners generate spawn zones for you intelligently.
--
-- Set up the spawner utilizing the special "ZONE_A" methods.

local ZoneNamesRestricted = {"NoGo-1", "NoGo-2"}

local spawner = SPECTRE.SPAWNER:New()
  :setCoalition(coalition.side.RED) --Set coalition for Spawns
  :setCountry(country.id.CJTF_RED) --Set Country for spawns
spawner:enablePersistence("AIRFIELDSPAWNERS_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")
spawner:AddExtraTypeToGroupsZONE_A(spawner.typeENUMS.GroundUnits, 1)
  :setZoneRestricted(ZoneNamesRestricted) -- (OPTIONAL) step to set areas spawns are not allowed in. Standard quad point zone.
  
  --Set the nominal, min, and max sizes, nudge factor for the main spawn zone.
  -- All units are in METERS
  :setZoneSizeMain(5000, 2000, 7000, 0.5)
  
  :setNumSubZones(4, 3, 6, 0.7) -- Sets the number of dynamically generated subzones for the spawner.
  :setSpawnAmountsZONE_A(20, 10, 25, 0.5) -- Sets the number of units to spawn, specific to advanced/ZONEMGR use
  
  :setNamePrefix("SPEC_")
  :setTypeAmounts(spawner.typeENUMS.GroundUnits         , 1, false)
  :setTypeAmounts(spawner.typeENUMS.Infantry            , 5, false)
  :setTypeAmounts(spawner.typeENUMS.LightArmoredUnits   , 5, false)
  :setTypeAmounts(spawner.typeENUMS.IFV                 , 5, false)
  :setTypeAmounts(spawner.typeENUMS.APC                 , 5, false)
  :setTypeAmounts(spawner.typeENUMS.Artillery           , 2, false)
  :setTypeAmounts(spawner.typeENUMS.MLRS                , 1, false)
  :setTypeAmounts(spawner.typeENUMS.HeavyArmoredUnits   , 5, false)
  :setTypeAmounts(spawner.typeENUMS.ModernTanks         , 5, false)
  :setTypeAmounts(spawner.typeENUMS.OldTanks            , 5, false)
  :setTypeAmounts(spawner.typeENUMS.Tanks               , 5, false)
  :setTypeAmounts(spawner.typeENUMS.Buildings           , 1, true)
  :setTypeAmounts(spawner.typeENUMS.Fortifications      , 1, true)
  :setTypeAmounts(spawner.typeENUMS.AAA                 , 2, true)
  :setTypeAmounts(spawner.typeENUMS.AA_flak             , 1, true)
  :setTypeAmounts(spawner.typeENUMS.StaticAAA           , 1, true)
  :setTypeAmounts(spawner.typeENUMS.MobileAAA           , 1, true)
  :setTypeAmounts(spawner.typeENUMS.SamElements         , 1, true)
  :setTypeAmounts(spawner.typeENUMS.IRGuidedSam         , 1, true)
  :setTypeAmounts(spawner.typeENUMS.SRsam               , 1, true)
  :setTypeAmounts(spawner.typeENUMS.MANPADS             , 1, true)

--Set the vec2 and name for spawning.
local vec2_ = AIRBASE:FindByName(AIRBASE.Caucasus.Senaki_Kolkhi):GetVec2()
local name_ = "AdvancedSpawnerZone"

--Spawn units with Dynamic ZONE method.
spawner:DynamicGenerationZONE(vec2_, name_)


local _placeholder = ""
