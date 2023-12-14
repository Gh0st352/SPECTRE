--- Continued from "DetectTemplates" Example.

SPECTRE.DebugEnabled = 1
--- Full basic spawner setup.

-- Basic manual SPAWNERs require you to provide some details. Advanced and ZONEMGR spawners generate spawn zones for you intelligently.

--- Zone Names:
--
-- Main: A Circle Zone that all sub zones are contained within.
-- SubZones: The circle zones that all spawns occur in.
-- Restricted (No-Go): Quad point zones that the SPAWNER is not allowed to spawn in.
--
-- Ex:

local ZoneNames = {}
ZoneNames.Main = "MainZone"
ZoneNames.SubZones = {"SubZone-1", "SubZone-2", "SubZone-3", "SubZone-4"}
ZoneNames.Restricted = {"NoGo-1", "NoGo-2"}



--- Manual dynamic SPAWNER setup.
-- 
--    Setup:
--    
--      newSpawner =  SPECTRE.SPAWNER:New()
--            :setCoalition()
--            :setCountry()
--            :enablePersistence(), OPTIONAL
--            :DetectTypeTemplates()
--            :SetZones()
--            :AddExtraTypeToGroups(), OPTIONAL
--            :setGroupSizePrio(), OPTIONAL
--            :setGroupSpacing(), OPTIONAL
--            :setSpawnAmounts()
--            :setNamePrefix(), OPTIONAL
--            :setTypeAmounts()
-- 
-- Choose Automatic or Manual Spawn Method:
--            
--    Automatic Generation:
--    
--            :RollSpawnGroupSizes()
--            :Generate()
--            
--    Manual Generation:
--    
--            :RollSpawnGroupSizes()
--            :RollSpawnGroupTypes()
--            :RollPlacement()
--            :SetupSpawnGroups()
--            :Spawn()
--            
-- After your SPAWNER has spawned units:
-- You may spawn more dynamic units using the same user configurations, but new dynamically generated units 
-- by repeating the Automatic or Manual Spawn Methods above.
local newSpawner =  SPECTRE.SPAWNER:New()

--Set coalition for Spawns
newSpawner:setCoalition(coalition.side.RED)
--Set Country for spawns
newSpawner:setCountry(country.id.CJTF_RED)

--Detect Type Templates for spawner use
newSpawner:DetectTypeTemplates("SPECTRESPAWNERTemplate")

  -- Give the SPAWNER your zone names.
  :SetZones(ZoneNames.Main,ZoneNames.SubZones,ZoneNames.Restricted)

  -- This gives you the ability to force add units to all generated groups.
  -- Here, I am telling the spawner to add one supply vehicle to every group. (DCS classifies them as "Ground Units")
  :AddExtraTypeToGroups(newSpawner.typeENUMS.GroundUnits, 1)

  -- This is setting the total desired number of generated TypeTemplates to spawn.
  -- Keep in mind, and force added ExtraTypesToGroups are added on top on these limits.
  -- Set nominal, min, max, and a NudgeFactor.
  --
  -- The numdge factor determines how far from the nominal the spawner is allowed to deviate.
  -- 1 =  min or max is chosen, 0 = no deviation
  --
  -- There is a lot of math that derives from this nudgeFactor, so in essence:
  --
  -- If you want possible spawn amounts to range from the min to max, set Nudge to 0.99
  -- If you want possible spawn amounts to average around your nominal, set nudge to 0.5
  -- If you want possible spawn amounts to value your nominal above all, set nudge to 0.01
  --
  -- Experiment to see what suits your use case :)
  --
  --
  -- NOTE: You may regenerate the Dynamic Amounts derived from your :setSpawnAmounts() configuration by using :Jiggle()
  --
  --      newSpawner:Jiggle()
  --
  -- This MUST ONLY be done after :setSpawnAmounts() has been used.
  -- If you Jiggle a SPAWNER that has already been Rolled, you need to reuse the Roll, Setup, and Spawn methods to apply the changes.
  :setSpawnAmounts(40, 20, 60, 0.5)

  -- This sets the (optional) prefix applied to all spawned group names.
  :setNamePrefix("SPEC_")
  
  -- Here we set the amount of each type the spawner is allowed to use from the detected Type Templates
  -- Simply call the typeENUM from your SPAWNER, add the maximum amount allowed, and a bool flag for hard limits.
  -- If the flag is true, if the maximum is reached, the SPAWNER will remove them from the pool of overflow spawns. (to prevent overpopulation of units such as SAMS/AAA/MANPADS/etc)
  -- If the flag is set to false, if the maximum for each unit is reached before the spawn generation completes, it will select templates from the "false" pool to make up for your math not adding up.
  -- Having a single dedicated "fill" unit set to false such as Infantry or GroundUnits will cause the spawner to only use those types if the hard limit for all other types is reached.
  --
  -- Since I am already using AddExtraTypesToGroups to add supply vehicles, I will set the type amount for the typeENUMS.GroundUnits below to `1, false`.
  
  -- This means: The spawner is allowed to use, but limited to spawning 1 supply vehicle somewhere in the Zone. Prevents overpopulation of supply when AddExtraTypesToGroups is used.
  
  -- False means: The spawner is allowed to spawn more than 1 Supply vehicle if it still needs to reach the desired spawn amount (when all other type limits have been reached)
  --
  -- If "nil" is provided, there is no maximum for this unit type.
  --
  -- Things to note: 
  -- SPAAA such as ZSU Gun Dish are classified under "SamElements".
  -- Supply vehicles are classified under "GroundUnits".
    :setTypeAmounts(newSpawner.typeENUMS.GroundUnits         , 1, false)
    :setTypeAmounts(newSpawner.typeENUMS.Infantry            , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.LightArmoredUnits   , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.IFV                 , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.APC                 , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.Artillery           , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.MLRS                , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.HeavyArmoredUnits   , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.ModernTanks         , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.OldTanks            , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.Tanks               , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.Fortifications      , 5, false)
    :setTypeAmounts(newSpawner.typeENUMS.EWR                 , 1, true)
    :setTypeAmounts(newSpawner.typeENUMS.ArmedGroundUnits    , nil, false)
    :setTypeAmounts(newSpawner.typeENUMS.AAA                 , 5, true)
    :setTypeAmounts(newSpawner.typeENUMS.AA_flak             , 5, true)
    :setTypeAmounts(newSpawner.typeENUMS.StaticAAA           , 5, true)
    :setTypeAmounts(newSpawner.typeENUMS.MobileAAA           , 5, true)
    :setTypeAmounts(newSpawner.typeENUMS.SamElements         , 2, true)
    :setTypeAmounts(newSpawner.typeENUMS.IRGuidedSam         , 3, true)
    :setTypeAmounts(newSpawner.typeENUMS.SRsam               , 2, true)
    :setTypeAmounts(newSpawner.typeENUMS.MANPADS             , 2 , true)
    
    -- Here we tell the SPAWNER to determine what size groups it will create
    --
    -- If you read the results and dont like them, just run the method again to Roll new GroupSizes.
    --
    -- Roll commands can be applied repeatedly until desired results are achieved.
    :RollSpawnGroupSizes()

    -- The magic happens and units are dynamically spawned when :Generate() is called.
    --
    -- If you want to roll GroupTypes, Placement, Setup, and Spawn the SPAWNER manually, do NOT use :Generate()
    -- See OPTIONAL 2
    --
    :Generate()
    
    
    
  -- ---- OPTIONAL 1 --------------------------------------------------------------------------------------------------------------------------------
  -- 
  -- You may customize group sizes generated and the spacing of those groups with the following methods:
  --
  --      SPECTRE.SPAWNER:setGroupSizePrio(groupSizePrio)
  --      SPECTRE.SPAWNER:setGroupSpacing(groupSize, groupMinSep, groupMaxSep, unitMinSep, unitMaxSep , distFromBuildings)
  --
  -- Where
  --
  --      local groupSizePrio = {
  --                        [1] = 6,
  --                        [2] = 5,
  --                        [3] = 4,
  --                        [4] = 3,
  --                        [5] = 2,
  --                        [6] = 1,
  --                      }
  --
  --      newSpawner:setGroupSizePrio(groupSizePrio)
  --      newSpawner:setGroupSpacing(5, 40, nil, 20, 50 , 35)
  --      newSpawner:setGroupSpacing(6, 35, nil, 15, 50 , 35)
  --
  --
  --  By Default SPECTRE uses group size Priority order: {[1] = 4, [2] = 3, [3] = 2, [4] = 1}   
  --   
  --  This means it will divide the total amount of units to be spawned by each GroupSize Value in order, filtering to the next tier using remaining units.
  -- 
  --  GroupSizes[KEY] = value
  --
  --  value = SPECTRE will try to spawn all groups as this size. If the amount leftover to spawn is less than this, it will move to the next KEY's value.
  --
  -- IMPORTANT: 
  --
  --  If you modify the GroupSizes, ALWAYS include an entry for 1. If you dont account for remaining units after division, unpredictable results may occur.
  --  
  --  If you add group sizes to the Prio list and do not add corresponding setGroupSpacing amounts for that group size, it will use internal default settings.
  -- 
  -- Unless you only want small groups, keep values 3, 2, 1 at the end of the list. (If they have high prio, it will never spawn lower prio groups)
  --
  --
  -- Do this VERY early in SPAWNER setup. Ideally after SetZones & AddExtraTypeToGroups. Zones MUST be set.
  -- 
  -- ---- END OPTIONAL 1 --------------------------------------------------------------------------------------------------------------------------------
  
  -- ---- OPTIONAL 2 --------------------------------------------------------------------------------------------------------------------------------
  -- 
  -- If you want to roll GroupTypes, Placement, Setup, and Run the SPAWNER manually, do NOT use :Generate()
  -- 
  -- Instead use, IN ORDER:
  --
  --    newSpawner:RollSpawnGroupSizes()
  --    newSpawner:RollSpawnGroupTypes()
  --    newSpawner:RollPlacement()
  --    newSpawner:SetupSpawnGroups()
  --    newSpawner:Spawn()
  --
  --  :Setup() and :Spawn() MUST be used ONLY AFTER all Rolls are complete.
  -- 
  -- ---- END OPTIONAL 2 --------------------------------------------------------------------------------------------------------------------------------
  
  local _placeholder = ""