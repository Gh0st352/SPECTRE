SPECTRE.DebugEnabled = 1

---CONTINUED FROM USERSTORAGE EXAMPLE
--
--


SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.


--- Enable Perisitence and set the folder name
SPECTRE:Persistence("ExampleMiz")

--- USERSTORAGE is a place to store your data and have it loaded on subsquent mission starts.
-- this prevents the need to redetermine data, allowing faster missions.
local _dB = SPECTRE.USERSTORAGE




--Being able to stroe your data is great, but how do we let the mission know if it needs to execute
--the first run only code?
--
--Easy! Use SPECTRE._firstrun
--Using this strategy, the code enclosed in the "IF" block below is only run the first time a mission is ran.
--
if SPECTRE._firstRun == true then
  _dB.zoneNames = {"Zone_ALPHA","Zone_BRAVO","Zone_CHARLIE","Zone_DELTA"}
  _dB.zoneNamesRestricted = {}
  _dB._coalRed = coalition.side.RED
  _dB._coalBlue = coalition.side.BLUE
  _dB._countryRed = country.id.CJTF_RED
  _dB._countryBlue = country.id.CJTF_BLUE

  SPECTRE.MENU.Settings.CAP.TemplateName                     = {Blue = "CUSTOM_CAP"                 , Red = "CUSTOM_CAP"}
  SPECTRE.MENU.Settings.TOMAHAWK.TemplateName                = {Blue = "FireGroup_Tomahawk"         , Red = "FireGroup_Tomahawk"}
  SPECTRE.MENU.Settings.BOMBER.TemplateName                  = {Blue = "CUSTOM_B52"                 , Red = "CUSTOM_B52"}

  SPECTRE.MENU.Settings.STRIKE.Transport.TemplateName        = {Blue = "CUSTOM_StrikeTransport"     , Red = "CUSTOM_StrikeTransport"}
  SPECTRE.MENU.Settings.STRIKE.Units.TemplateName            = {Blue = "TEMPLATE_Strike"            , Red = "TEMPLATE_Strike"}

  SPECTRE.MENU.Settings.AIRDROP.TemplateName                 = {Blue = "AIRDROP_TRANSPORT"          , Red = "AIRDROP_TRANSPORT"}
  SPECTRE.MENU.Settings.AIRDROP.Types.TANK.TemplateName      = {Blue = "TEMPLATE_TankCompany"       , Red = "TEMPLATE_TankCompany"}
  SPECTRE.MENU.Settings.AIRDROP.Types.IFV.TemplateName       = {Blue = "TEMPLATE_IFV_Company"       , Red = "TEMPLATE_IFV_Company"}
  SPECTRE.MENU.Settings.AIRDROP.Types.ARTILLERY.TemplateName = {Blue = "TEMPLATE_Artillery_Company" , Red = "TEMPLATE_Artillery_Company"}
  SPECTRE.MENU.Settings.AIRDROP.Types.AAA.TemplateName       = {Blue = "TEMPLATE_AAA"               , Red = "TEMPLATE_AAA"}
  SPECTRE.MENU.Settings.AIRDROP.Types.IRSAM.TemplateName     = {Blue = "TEMPLATE_SAM_IR"            , Red = "TEMPLATE_SAM_IR"}
  SPECTRE.MENU.Settings.AIRDROP.Types.RDRSAM.TemplateName    = {Blue = "TEMPLATE_SAM_RDR"           , Red = "TEMPLATE_SAM_RDR"}
  SPECTRE.MENU.Settings.AIRDROP.Types.EWR.TemplateName       = {Blue = "TEMPLATE_EWR"               , Red = "TEMPLATE_EWR"}
  SPECTRE.MENU.Settings.AIRDROP.Types.SUPPLY.TemplateName    = {Blue = "TEMPLATE_Supply"            , Red = "TEMPLATE_Supply"}

  SPECTRE.SPAWNER:enablePersistence("MIZTypeTemplates_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")

  _dB.REDspawner = SPECTRE.SPAWNER:New()
    :setCoalition(coalition.side.RED) --Set coalition for Spawns
    :setCountry(country.id.CJTF_RED) --Set Country for spawns
  _dB.REDspawner:enablePersistence("AIRFIELDSPAWNERS_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")
  _dB.REDspawner:AddExtraTypeToGroupsZONE_A(_dB.REDspawner.typeENUMS.GroundUnits, 1)
    :setZoneSizeMain(5000, 2000, 7000, 0.5)
    :setNumSubZones(4, 3, 6, 0.7)
    :setSpawnAmountsZONE_A(20, 10, 25, 0.5)
    :setNamePrefix("SPEC_")
    :setTypeAmounts(_dB.REDspawner.typeENUMS.GroundUnits         , 1, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.Infantry            , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.LightArmoredUnits   , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.IFV                 , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.APC                 , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.Artillery           , 2, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.MLRS                , 1, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.HeavyArmoredUnits   , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.ModernTanks         , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.OldTanks            , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.Tanks               , 5, false)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.Buildings           , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.Fortifications      , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.AAA                 , 2, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.AA_flak             , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.StaticAAA           , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.MobileAAA           , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.SamElements         , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.IRGuidedSam         , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.SRsam               , 1, true)
    :setTypeAmounts(_dB.REDspawner.typeENUMS.MANPADS             , 1, true)

  _dB.BLUEspawner = SPECTRE.SPAWNER:New()
    :setCoalition(coalition.side.BLUE) --Set coalition for Spawns
    :setCountry(country.id.CJTF_BLUE) --Set Country for spawns
  _dB.BLUEspawner:enablePersistence("AIRFIELDSPAWNERS_"):DetectTypeTemplates("SPECTRESPAWNERTemplate")
  _dB.BLUEspawner:AddExtraTypeToGroupsZONE_A(_dB.BLUEspawner.typeENUMS.GroundUnits, 1)
    :setZoneSizeMain(5000, 2000, 7000, 0.5)
    :setNumSubZones(4, 3, 6, 0.7)
    :setSpawnAmountsZONE_A(20, 10, 25, 0.5)
    :setNamePrefix("SPEC_")
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.GroundUnits         , 1, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.Infantry            , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.LightArmoredUnits   , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.IFV                 , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.APC                 , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.Artillery           , 2, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.MLRS                , 1, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.HeavyArmoredUnits   , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.ModernTanks         , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.OldTanks            , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.Tanks               , 5, false)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.Buildings           , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.Fortifications      , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.AAA                 , 2, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.AA_flak             , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.StaticAAA           , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.MobileAAA           , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.SamElements         , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.IRGuidedSam         , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.SRsam               , 1, true)
    :setTypeAmounts(_dB.BLUEspawner.typeENUMS.MANPADS             , 1, true)

  -- Create Templates from your Spawners

  _dB.template_REDspawner = SPECTRE.UTILS.templateFromObject(_dB.REDspawner)
  _dB.template_BLUEspawner = SPECTRE.UTILS.templateFromObject(_dB.BLUEspawner)


  SPECTRE.ZONEMGR:enablePersistance()               -- Enables the ZONEMGR to save data, preventing the need to perform the same operations on subsequent mission starts.
    :setUpdateInterval(120, 0.15)                   -- Sets how often the ZONEMGR will analyze the managed zones and update itself.
    :enableHotspots()                               -- Enables the ZONEMGR to analyze the world state contained in managed zones.
    :enableHotspotIntel()                           -- Enables deeper world state analysis in managed zones.
    :enableSSB() -- This will automatically manage SSB functions for all client slots at airfields. Also adds ground spawns within 5000m of the airfield to the airfield SSB manager.
end



zoneManager = SPECTRE.ZONEMGR:New():Setup(_dB.zoneNames):Init()

zoneManager:spawnAirbasesInZone("Zone_DELTA",_dB._coalBlue,_dB._countryBlue,_dB.template_BLUEspawner)

local _SpawnTimer1 = TIMER:New(function()
  zoneManager:spawnFillInZoneSmart("Zone_DELTA",_dB._coalRed,_dB._countryRed,nil,_dB._coalBlue,_dB.template_REDspawner)
end)
_SpawnTimer1:Start(10)

local _SpawnTimer2 = TIMER:New(function()
  zoneManager:spawnFillInZoneSmart("Zone_DELTA",_dB._coalBlue,_dB._countryBlue,nil,_dB._coalRed,_dB.template_BLUEspawner)
end)
_SpawnTimer2:Start(15)


local _placeholder = ""
