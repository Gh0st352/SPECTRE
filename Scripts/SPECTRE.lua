--- S.P.E.C.T.R.E. (Special Purpose Extension for Creating Truly Reactive Environments)
-- ------------------------------------------------------------------------------------------
-- Requires MOOSE, MIST, SSB to be loaded before SPECTRE.lua for certain functions to work.
-- Functions with external dependencies will be clearly marked.
-- ------------------------------------------------------------------------------------------
-- 
-- S. - Special         |
-- P. - Purpose         | CompileTime : Thursday, June 15, 2023 1:10:10 PM
-- E. - Extension for   |      Commit : 6adc313af566c4a566e5aefe11b85fc2bd03d026
-- C. - Creating        |
-- T. - Truly           |      Github : https://github.com/Gh0st352
-- R. - Reactive        |      Author : Gh0st
-- E. - Environments    |     Discord : Gh0st#5623
-- 
-- ------------------------------------------------------------------------------------------
-- 
-- This is free software, and you are welcome to redistribute it with certain conditions.
-- 
-- --------------------- GNU General Public License v3.0 ------------------------------------
-- 
-- This program is free software: you can redistribute it and/or modify it under the terms 
-- of the GNU General Public License as published by the Free Software Foundation, 
-- Version 3 of the License.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
-- without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-- See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License in the downloaded 
-- program folder.  If not, see https://www.gnu.org/licenses/.
--
-- Copyright (C) 2023 Gh0st - This program comes with ABSOLUTELY NO WARRANTY
-- ------------------------------------------------------------------------------------------


--- **S.P.E.C.T.R.E.** 
--
-- The extension and all items associated.
--
-- ===
-- ***Special Purpose Extension for Creating Truly Reactive Environments***
--
--
--
--   * The base class of the extension.
--
--   * All aspects of SPECTRE are accessed via this class.
--   
--   * **FULLY IntelliSense and IntelliJ compatible.**
--
-- ===
-- .
--
--      @{SPECTRE}:  --->
--      ===
--      SPECTRE.@{AI}
--      SPECTRE.@{FileIO}
--      SPECTRE.@{DYNAMIC_SPAWNER}
--      SPECTRE.@{OBJECT}
--      SPECTRE.@{PLAYER_MANAGER}
--      SPECTRE.@{POINT_MANAGER}
--      SPECTRE.@{POLY}
--      SPECTRE.@{Utils}
--      SPECTRE.@{WORLD}
--      
--      Version: 0.8.0
-- .
--
-- ===
-- @module SPECTRE
env.info(" *** LOAD S.P.E.C.T.R.E. *** ")

---S.P.E.C.T.R.E..
-- ===
-- 
-- *Special Purpose Extension for Creating Truly Reactive Environments.*
--
-- ===
-- @section S.P.E.C.T.R.E.

--- ###Extension Table
--
--      Special Purpose Extension for Creating Truly Reactive Environments.
-- 
-- * Houses EVERYTHING.
--
-- * Requires MOOSE, MIST, SSB to be loaded before SPECTRE.lua
-- 
-- @field #SPECTRE
-- @field ClassName "SPECTRE".
-- @field ClassID The ID number of the class.
-- @field AI @{AI}
-- @field FileIO @{FileIO}
-- @field DYNAMIC_SPAWNER @{DYNAMIC_SPAWNER}
-- @field OBJECTS @{OBJECT}
-- @field PLAYER_MANAGER @{PLAYER_MANAGER}
-- @field POINT_MANAGER @{POINT_MANAGER}
-- @field POLY @{POLY}
-- @field UTILS @{Utils}
-- @field WORLD @{WORLD}
SPECTRE = {
  ClassName = "SPECTRE", 
  ClassID = 0,
}

---_framework.
-- ===
-- All framework associated with the class.
-- 
--      You probably shouldn't use these.
-- 
-- ===
-- @section _framework

--- SPECTRE constructor.
-- @param self
-- @return #SPECTRE
-- @usage
-- local example = SPECTRE:New()
function SPECTRE:New()
  local self=BASE:Inherit(self, BASE:New())
  return self
end



--- **SPECTRE.AI** 
--
-- The base AI management class.
-- 
-- ===
--      @{SPECTRE} ---> @{SPECTRE.AI}
-- ===
--
--  ***A.I. for SPECTRE.***
--
--   * The A.I. Class.
--
--   * All aspects of the A.I. are accessed via this class.
--
--     -- lorem ipsum
--
-- ===
-- 
-- @module AI
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - A.I. *** ")

---A.I..
--
-- ===
-- 
-- *Houses all aspects dealing with AI management.*
--
-- ===
-- @section A.I.

---###AI
-- ===
--
--     AI unit operations for tracking game data and state.
--     
-- * Houses all aspects dealing with AI management.
-- 
-- @field #AI
-- @field ClassName SPECTRE.OBJECT.AI
-- @field ClassID The ID number of the class.
SPECTRE.AI = {
  ClassName = "AI",
  ClassID = 0, 
}

---Functions.
-- ===
-- 
-- *All Functions associated with the class.*
--
-- ===
-- @section Functions

--- Defines a menu slot to let the escort Join and Follow you at a certain distance.
-- This menu will appear under **Navigation**.
-- @param EscortGroup ESCORT group Object
-- @param Distance The distance in NM that the escort needs to follow the client.
-- @return self
function SPECTRE.AI.MenuFollowAtNM( EscortGroup, Distance )
  local DistanceM = UTILS.NMToMeters(Distance)
  local self = EscortGroup
  self:F(Distance)
  if self.EscortGroup:IsAir() then
    if not self.EscortMenuReportNavigation then
      self.EscortMenuReportNavigation = MENU_GROUP:New( self.EscortClient:GetGroup(), "Navigation", self.EscortMenu )
    end
    if not self.EscortMenuJoinUpAndFollow then
      self.EscortMenuJoinUpAndFollow = {}
    end
    self.EscortMenuJoinUpAndFollow[#self.EscortMenuJoinUpAndFollow+1] = MENU_GROUP_COMMAND:New( self.EscortClient:GetGroup(), "Join-Up and Follow at " .. Distance .. "NM", self.EscortMenuReportNavigation, ESCORT._JoinUpAndFollow, self, DistanceM )
    self.EscortMode = ESCORT.MODE.FOLLOW
  end
  return self
end



-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.DYNAMIC_SPAWNER**
--
-- Automated Spawning.
--
--  ***Dynamic Spawner for SPECTRE.***
--
--   * The DYNAMIC_SPAWNER Class.
--
--   * All aspects of the DYNAMIC_SPAWNER are accessed via this class.
--
--     -- Dynamic Spawning of DCS Units.
--     -- Accounts for existing ground & sea buildings, units, objects, scenery
--     -- Works utilizing (tunable) coroutines (multithreading)
--     -- Prevents the extension from interferring with/stalling the main game thread.
--     -- Provide generation parameters via a config table.
--
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.DYNAMIC_SPAWNER}
-- ===
--
-- @module DYNAMIC_SPAWNER
-- @extends SPECTRE


env.info(" *** LOAD S.P.E.C.T.R.E. - DYNAMIC_SPAWNER *** ")

---DYNAMIC_SPAWNER.
-- ===
--
-- All Functions associated with the DYNAMIC_SPAWNER class.
--
-- ===
--
--  ***Dynamic Spawner for SPECTRE.***
--
--   * The DYNAMIC_SPAWNER Class.
--
--   * All aspects of the DYNAMIC_SPAWNER are accessed via this class.
--
--          -- Dynamic Spawning of DCS Units.
--          -- Accounts for existing ground & sea buildings, units, objects, scenery
--          -- Works utilizing (tunable) coroutines (multithreading)
--          -- Prevents the extension from interferring with/stalling the main game thread.
--          -- Provide generation parameters via a config table.
--
-- ===
-- @section DYNAMIC_SPAWNER

--- ###DYNAMIC_SPAWNER
-- ===
--
--      Dynamic Generation, Placement, and Spawning of Units.
--
-- * Dynamic Spawner for SPECTRE
--
-- * Utilizes coroutines for async generation, preventing interruption of main game thread.
--
-- * Houses all aspects dealing with dynamic unit spawning.
--
-- @field #DYNAMIC_SPAWNER
-- @field ClassName SPECTRE.OBJECT.DYNAMIC_SPAWNER
-- @field ClassID The ID number of the class.
SPECTRE.DYNAMIC_SPAWNER = {
  ClassName = "DYNAMIC_SPAWNER",
  ClassID = 0,
  COUNTER = 1,
}

--- Creates new DYNAMIC_SPAWNER Object.
--
-- Everything is called from the DYNAMIC_SPAWNER Object.
--
-- @param self
-- @return #DYNAMIC_SPAWNER
-- @usage
-- local self = SPECTRE.DYNAMIC_SPAWNER:New()
-- -- self is DYNAMIC_SPAWNER Object with defaults configured
-- -- self is now set as below
-- self = {
--           OBJECT = SPECTRE.OBJECT.DYNAMIC_SPAWNER,
--           DebugEnabled                  = 0,
--           DebugMessages                 = 0,
--           DebugLog = {},
--           Config = {
--                       UnitsMin          = 30,
--                       UnitsMax          = 50,
--                       operationLimit    = 200,
--                       operationInterval = 3,
--                       NumGroupsMin      = 9,  --non functional
--                       NumGroupsMax      = 12, -- non functional
--                       numExtraTypes     = 0,
--                       numExtraUnits     = 0,
--                       LimitedSpawnStrings = {},
--                       Types = {},
--                       GroupSpacingSettings = {
--                         General = {
--                                    minSeparation_Groups  = 30, --meters, minimum distance between groups
--                                    minSeperation         = 15, --meters, min distance between units in group
--                                    maxSeperation         = 30, --meters, max distance between units in group
--                                    DistanceFromBuildings = 20,
--                         },
--                         [1] = {
--                                    minSeparation_Groups  = 5, --meters, distance space between groups
--                                    minSeperation         = 2, --meters, min distance between units in group
--                                    maxSeperation         = 3, --meters, max distance between units in group
--                         },
--                         [2] = {
--                                    minSeparation_Groups  = 25, --meters, distance space between groups
--                                    minSeperation         = 10, --meters, min distance between units in group
--                                    maxSeperation         = 35, --meters, max distance between units in group
--                         },
--                         [3] = {
--                                    minSeparation_Groups  = 30, --meters, distance space between groups
--                                    minSeperation         = 15, --meters, min distance between units in group
--                                    maxSeperation         = 35, --meters, max distance between units in group
--                         },
--                         [4] = {
--                                    minSeparation_Groups  = 35, --meters, distance space between groups
--                                    minSeperation         = 15, --meters, min distance between units in group
--                                    maxSeperation         = 40, --meters, max distance between units in group
--                         },
--
--                       },
--                       GroupSizes = { --Priority of group sizes made
--                                      [1] = 4,
--                                      [2] = 3,
--                                      [3] = 2,
--                                      [4] = 1,
--                       }, --Priority of group sizes made
--                       GroupSizesMainZone = { --Priority of group sizes made
--                                               [1] = 3,
--                                               [2] = 2,
--                                               [3] = 1,
--                                            }, --Priority of group sizes made
--                     },
--        Zones = {
--                   Main = {},
--                   Sub = {},
--                   Restricted = {},
--                },
--        GenerationComplete = false,
--        GenerationInProgress = false
--        }
function SPECTRE.DYNAMIC_SPAWNER:New()
  local self=BASE:Inherit(self, BASE:New())
  self.OBJECT = SPECTRE.OBJECT.DYNAMIC_SPAWNER
  self.DebugEnabled = 0
  self.DebugMessages = 0
  self.DebugMenuPlayer = 0
  self.DebugLog = {}
  self.NoGoSurface = {
    --   "LAND",--1,--
    --   "SHALLOW_WATER",--2,
    "WATER",--3,
    --   "ROAD",--4,
    "RUNWAY",--5,
    "nil",
  }
  self.AllTypes = {}
  self.Co_Counter = 0
  self.Config = {
    UnitsMin          = 30,
    UnitsMax          = 50,
    operationLimit = 200,
    operationInterval = 3,
    NumGroupsMin = 9,  --non functional
    NumGroupsMax = 12, -- non functional
    numExtraTypes = 0,
    numExtraUnits = 0,
    LimitedSpawnStrings = {},
    Types = {},
    GroupSpacingSettings = {
      General = {
        minSeparation_Groups = 30, --meters, minimum space between groups
        minSeperation = 15, --meters, minimum space between units in group
        maxSeperation = 30, --meters, maximum space between units in group
        DistanceFromBuildings = 20,
      },
      [1] = {
        minSeparation_Groups = 5, --meters, minimum space between groups
        minSeperation = 2, --meters, minimum space between units in group
        maxSeperation = 3, --meters, maximum space between units in group
      },
      [2] = {
        minSeparation_Groups = 25, --meters, minimum space between groups
        minSeperation = 10, --meters, minimum space between units in group
        maxSeperation = 35, --meters, maximum space between units in group
      },
      [3] = {
        minSeparation_Groups = 30, --meters, minimum space between groups
        minSeperation = 15, --meters, minimum space between units in group
        maxSeperation = 35, --meters, maximum space between units in group
      },
      [4] = {
        minSeparation_Groups = 35, --meters, minimum space between groups
        minSeperation = 15, --meters, minimum space between units in group
        maxSeperation = 40, --meters, maximum space between units in group
      },

    },
    GroupSizes = { --Priority of group sizes made
      [1] = 4,
      [2] = 3,
      [3] = 2,
      [4] = 1,
    }, --Priority of group sizes made
    GroupSizesMainZone = { --Priority of group sizes made
      [1] = 3,
      [2] = 2,
      [3] = 1,
    }, --Priority of group sizes made
  }
  self.Zones = {
    Main = {},
    Sub = {},
    Restricted = {},
  }
  self.GenerationComplete = false
  self.GenerationInProgress = false
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - New() - self")
    BASE:E(self)
  end
  return self
end

---Basic Use.
-- ===
--
-- *All Functions associated with basic use of the DYNAMIC_SPAWNER class.*
--
-- ===
--
-- **Basic Use**
--
--     Use with 4 steps:
--     1 --- Create your configuration parameters for the Dynamic Spawner.
--     2 --- Create a new SPECTRE.DYNAMIC_SPAWNER Object
--     3 --- Import your config to the Dynamic Spawner.
--     4 --- Spawn your units!
-- .
--     --- Process:
--
--     1 --- Create your configuration parameters for the Dynamic Spawner.
--     --
--     --    See "Configuration" section below for more information.
--     --             At the bottom is a full example spawnerConfig.
--
--           local spawnerConfig = {
--                                    MissionEditorZoneNames = {...},
--                                    Config                 = {...},
--                                    TypeTemplates          = {...},
--                                    ExtraTypes             = {...},
--                                 }
--
--     2 --- Create a new SPECTRE.DYNAMIC_SPAWNER Object
--
--           local spawnerObject = SPECTRE.DYNAMIC_SPAWNER:New()
--
--     3 --- Import your config to the Dynamic Spawner.
--     --
--     --    @see SPECTRE.DYNAMIC_SPAWNER:ConfigImport()
--
--           spawnerObject:ConfigImport(
--                                        spawnerConfig.MissionEditorZoneNames,
--                                        spawnerConfig.Config,
--                                        spawnerConfig.TypeTemplates,
--                                        spawnerConfig.ExtraTypes
--                                      )
--
--     4 --- Spawn your units!
--     --
--     --    @see SPECTRE.DYNAMIC_SPAWNER:Generate()
--
--           spawnerObject:Generate()
--
--     --- All Done! Ezpz.
--     ---------------------------------------------------------------------------------
--
--     ---Bonus: You can chain functions.
--
--     local spawnerConfig = {...}
--     local spawnerObject =SPECTRE.DYNAMIC_SPAWNER:New()
--           :ConfigImport(
--                          spawnerConfig.MissionEditorZoneNames,
--                          spawnerConfig.Config,
--                          spawnerConfig.TypeTemplates,
--                          spawnerConfig.ExtraTypes
--                        )
--           :Generate()
--
--     or
--
--     local spawnerConfig = {...}
--     local spawnerObject = SPECTRE.DYNAMIC_SPAWNER:New():ConfigImport(spawnerConfig.MissionEditorZoneNames, spawnerConfig.Config, spawnerConfig.TypeTemplates, spawnerConfig.ExtraTypes):Generate()
--  ===
--
-- ===
-- @section Basic Use

--- Imports Pre-made config tables for the SPECTRE.DYNAMIC_SPAWNER.
--
-- Shortcut to limit code length in main scripts.
--
-- ===
--
--
-- **The function takes 4 arguments, each a table.**
--
--     ZoneNames = {...},
--     Config = {...},
--     TypeTemplates  = {...},
--     ExtraTypes   = {...},
--
-- *where*
--
-- **ZoneNames**
--
--   *Contains all zone names for the spawner to work with (Main, Sub, and Restricted).*
--
--      --- Restricted.Main = #string
--      --            *The main zone of the dynamic spawner.
--      --            *All other zones are contained within it.
--                      ex. Main = "Zone_Main",
--
--      --- Restricted.Sub = #table
--      --            *All sub zones of the dynamic spawner
--      --            *Used for weighting location probability of type group clusters.
--                      ex. Sub = {"Zone_Sub-1",
--                                 "Zone_Sub-2",
--                                 "Zone_Sub-3",},
--
--      --- Restricted.Restricted = #table
--      --            *All restricted zones of the dynamic spawner.
--      --            *Prevents spawning of any Type within any restricted zone.
--                      ex. Restricted = {"Zone_Restricted-1",
--                                        "Zone_Restricted-2",
--                                        "Zone_Restricted-3",},
--      --         Can be = {} or nil
--                      ex. Restricted = {}
--                      ex. Restricted = nil
--     ---------------------------------------------------------------------------------
--      ZoneNames = {
--                    Main = "Zone_Main",
--                    Sub = {"Zone_Sub-1", "Zone_Sub-2", "Zone_Sub-3",},
--                    Restricted = {
--                                   "Zone_Restricted-1",
--                                   "Zone_Restricted-2",
--                                   "Zone_Restricted-3",
--                                 },
--                  }
--
-- **TypeTemplates**
--
--   *Contains the Types the dynamic spawner will have access to, and their corresponding Mission Editor Template Group Names.*
--
--          --- Type: The defined term for the 'type' of unit you are spawning.
--          --      In these examples, Types are grouped by the 'type' of object.
--                      eg. Type = APC, IFV, MBT, Supply
--          --          These can be anything you want.
--                      eg. Type = Type1, Yellow, Train, Cow
--          --      In TypeTemplates below, Type can be seen as:
--                          TypeTemmplates.Type   = {...}
--
--                          TypeTemmplates.APC    = {...}
--                          TypeTemmplates.IFV    = {...}
--                          TypeTemmplates.MBT    = {...}
--                          TypeTemmplates.Supply = {...}
--
--          --- Templates: The defined group name for the 'template' of type you are spawning.
--          --       These must match a group name in the mission editor, late activated.
--          --       The groups can be any number of units, but will only count as 1 'Type'.
--
--          --          eg. 2 groups in the mission editor with:
--                                 groupname1 = "exGroupName1"
--                                 1 Unit in group
--                                 groupname2 = "exGroupName2"
--                                 3 Units in group
--
--          --       Even though each group has a different number of units,
--          --       each group only counts as 1 'Type' to the Dynamic Spawner.
--          --
--          --       So if UnitsMin = 5, that means the spawner will spawn 5 types minimum.
--          --
--          --       Because the above example 'groupname1' is 1 units per 'Type'
--          --       the spawner would place 5 units minimum.
--          --       While because the above example 'groupname2' is 3 units per 'Type'
--          --       the spawner would place 15 units minimum.
--          --
--          --  In these examples:
--          --     Templates are 1 placed unit per group in the Mission editor.
--          --     The Template ME group name matches below 'Templates'.
--          --
--          --     Templates are grouped by the 'type' of object.
--                   eg. Type = Template
--                   eg. TypeTemmplates.IFV = {"Template_IFV_Bradley","Template_IFV_Warrior",}
--
--          --     In TypeTemplates below, Templates can be seen as:
--                       TypeTemmplates.Type  = Templates
--                       TypeTemmplates.IFV    = {
--                                                 "Template_IFV_Bradley",
--                                                  "Template_IFV_Warrior",
--                                               }
--     ---------------------------------------------------------------------------------
--          TypeTemplates = {
--                            APC  = {
--                                     "Template_APC_BTR80",
--                                     "Template_APC_MTLB",
--                                     "Template_APC_BTRRD",
--                                   },
--                            IFV  = {
--                                     "Template_IFV_Bradley",
--                                     "Template_IFV_Warrior",
--                                   },
--                            MBT  = {
--                                     "Template_MBT_T72B",
--                                     "Template_MBT_T72B3",
--                                   },
--                            Supply  = {
--                                     "Template_Supply_Kamaz",
--                                     "Template_Supply_KrAZ",
--                                     "Template_Supply_ZIL135",
--                                   },
--                          }
--
-- **Config**
--
--   *Contains general spawn configuration information for the dynamic spawner.*
--
--                   --- Config.UnitsMin = #integer,
--                   --       *The minimum amount of Types the Dynamic Spawner is allowed to place.
--                              ex. UnitsMin          = 30,
--
--                   --- Config.UnitsMax = #integer,
--                   --       *The maximum amount of Types the Dynamic Spawner is allowed to place.
--                              ex. UnitsMax          = 50,
--
--                   --- Config.LimitedSpawnStrings = #table
--                   --       *These strings are searched for within the Type names of the Spawner.
--                   --       *If a Type name contains any of these strings:
--                   --           -The Dynamic Spawner will NEVER spawn more than the min specified
--                   --           -@see SPECTRE.DYNAMIC_SPAWNER:AddLimitedSpawn()
--                   --           -Useful for Types that can *drastically* change gameplay,
--                   --                  *Eg. SAMS, AAA, MANPADS, SPAAA, etc.
--                             ex. LimitedSpawnStrings = {"SAM_","AAA","MBT",},
--
--                   --- Config.TypeAmounts = #table
--                   --       *The min and max of each Type allowed to be spawned.
--                            ex. TypeAmounts.Type = {min = 5, max = 0}
--                            ex. TypeAmounts.APC = {min = 5, max = 0}
--     ---------------------------------------------------------------------------------
--                   Config = {
--                            UnitsMin          = 30,
--                            UnitsMax          = 50,
--                            LimitedSpawnStrings = {"SAM_","AAA","MBT",},
--                            TypeAmounts = {
--                                             APC             = {min = 5, max = 0},
--                                             IFV             = {min = 3, max = 0},
--                                             MBT             = {min = 3, max = 7},
--                                             Supply          = {min = 3, max = 0},
--                                           },
--                         }
--
-- **ExtraTypes**
--
--   *Contains extra Types that the spawner must add to every generated group, and the amount of each type.*
--
--             --- Config.ExtraTypes = #table
--             --       *The extra types and amount of each that the spawner adds to each group.
--                           ex. ExtraTypes = {
--                                              [1] = {
--                                                      type = "Supply",
--                                                      numtype = 2,
--                                                    },
--                                              [...] = {...},
--                                              [n] = {
--                                                      type = Type,
--                                                      numtype = 1,
--                                                    },
--                                            }
--
--             --         Can be = {} or nil
--                           ex. ExtraTypes = {}
--                           ex. ExtraTypes = nil
--
--     ---------------------------------------------------------------------------------
--                   ExtraTypes = {
--                                  [1] = {
--                                          type = "Supply",
--                                          numtype = 2
--                                        },
--                                 }
--
--
-- **Example spawnerConfig**
--
--   *An example that adds together all aspects shown above.*
--
--     spawnerConfig = {
--                       ZoneNames = {
--                                    Main = "Zone_Main",
--                                    Sub = {"Zone_Sub-1", "Zone_Sub-2", "Zone_Sub-3",},
--                                    Restricted = {
--                                                   "Zone_Restricted-1",
--                                                   "Zone_Restricted-2",
--                                                   "Zone_Restricted-3",
--                                                  },
--                                    },
--                       Config    = {
--                                      UnitsMin                = 30,
--                                      UnitsMax                = 50,
--                                      LimitedSpawnStrings     = {"SAM_","AAA","MBT",},
--                                      TypeAmounts = {
--                                                      APC     = {min = 5, max = 0},
--                                                      IFV     = {min = 3, max = 0},
--                                                      MBT     = {min = 3, max = 7},
--                                                      Supply  = {min = 3, max = 0},
--                                                    },
--                                    },
--                       TypeTemplates = {
--                                          APC     = {
--                                                      "Template_APC_BTR80",
--                                                      "Template_APC_MTLB",
--                                                      "Template_APC_BTRRD",
--                                                    },
--                                          IFV     = {
--                                                      "Template_IFV_Bradley",
--                                                      "Template_IFV_Warrior",
--                                                    },
--                                          MBT     = {
--                                                      "Template_MBT_T72B",
--                                                      "Template_MBT_T72B3",
--                                                    },
--                                          Supply  = {
--                                                      "Template_Supply_Kamaz",
--                                                      "Template_Supply_KrAZ",
--                                                      "Template_Supply_ZIL135",
--                                                    },
--                                      },
--                       ExtraTypes   = {
--                                         [1] = {
--                                                 type = "Supply",
--                                                 numtype = 2
--                                               },
--                                      },
--                      }
--
--
--  ===
--
-- @param #DYNAMIC_SPAWNER self
-- @param ZoneNames : Table of Zone Names; for Main, Sub, and Restricted Zones. ex:
--
--     ZoneNames = {
--                   Main = "Zone_Sukhumi",
--                   Sub = {"Sukhumi-1", "Sukhumi-2", .., n,},
--                   Restricted = { "Sukhumi_NG-1", "Sukhumi_NG-2", .., n,},
--                 }
--
--       Main =      #string | Name of main ZONE_RADIUS containing all other zones.
--       Sub =        #table | Table of strings. Names of all sub-ZONE_RADIUS used for spawn weighting.
--       Restricted = #table | Table of strings. Names of all zones where units should NOT be spawned.
--               ---> "Restricted" REQUIRES A QUAD POINT ZONE DEFINED IN THE MISSION EDITOR
--
-- @param Config : Pre-Made Config Table. ex:
--
--     Config = {
--               UnitsMin          = 30,
--               UnitsMax          = 50,
--               LimitedSpawnStrings = {"SAM_","AAA","MANPAD",},
--               TypeAmounts = {
--                               APC                = {min = 5, max = 0},
--                               IFV                = {min = 3, max = 0},
--                               Supply             = {min = 3, max = 0},
--                               AAA                = {min = 2, max = 0},
--                               SPAAA              = {min = 0, max = 0},
--                               MANPAD             = {min = 0, max = 0},
--                               SAM_Radar_Singles  = {min = 0, max = 0},
--                             },
--              }
--
--      UnitsMin = minimum number of types generated by the spawner
--      UnitsMax = maximum number of types generated by the spawner
--      LimitedSpawnStrings = table of strings to check if types contain. See function SPECTRE.DYNAMIC_SPAWNER:AddLimitedSpawn(string).
--      TypeAmounts = Table of Min and Max amounts of each possible Type. Type name must match those provided in "Types" variable of this function. ex:
--      TypeAmounts = {
--                      ["TYPENAME"] = {min = 5, max = 0},
--                       ..,
--                       n,
--                    }
-- @param TypeTemplates : Table of Types to be used for the spawner. where the key is the Type Name. Ex:
--
--     TypeTemplates = {
--               APC  = {"Template_APC_BTR80","Template_APC_MTLB",},
--               IFV  = {"Template_IFV_BMD1",},
--             }
-- @param ExtraTypes :
--
--   *Contains extra Types that the spawner must add to every generated group, and the amount of each type.*
--
--             --- Config.ExtraTypes = #table
--             --       *The extra types and amount of each that the spawner adds to each group.
--                           ex. ExtraTypes = {
--                                              [1] = {
--                                                      type = "Supply",
--                                                      numtype = 2,
--                                                    },
--                                              [...] = {...},
--                                              [n] = {
--                                                      type = Type,
--                                                      numtype = 1,
--                                                    },
--                                            }
--
--             --         Can be = {} or nil
--                           ex. ExtraTypes = {}
--                           ex. ExtraTypes = nil
--
--     ---------------------------------------------------------------------------------
--                   ExtraTypes = {
--                                  [1] = {
--                                          type = "Supply",
--                                          numtype = 2
--                                        },
--                                 }
--
-- @return #DYNAMIC_SPAWNER self : self with config tables added from
--
--     self:ZoneAdd()
--     self:AddType()
--     self:SetTypeAmount()
--     self:SetUnitAmounts()
--     self:AddLimitedSpawn()
function SPECTRE.DYNAMIC_SPAWNER:ConfigImport(ZoneNames, Config, TypeTemplates, ExtraTypes)
  --local self=BASE:Inherit(self, BASE:New())
 -- local DEBUG = false or self.DebugEnabled
  for _i = 1, #ZoneNames.Main, 1 do
    self:ZoneAdd(ZoneNames.Main, "main")
  end
  for _i = 1, #ZoneNames.Sub, 1 do
    self:ZoneAdd(ZoneNames.Sub[_i], "sub")
  end
  for _i = 1, #ZoneNames.Restricted, 1 do
    self:ZoneAdd(ZoneNames.Restricted[_i], "restricted")
  end
  for _k, _v in pairs(TypeTemplates) do
    self:AddType(_k, TypeTemplates[_k])
  end
  for _k, _v in pairs(Config.TypeAmounts) do
    self:SetTypeAmount(_k, Config.TypeAmounts[_k].min, Config.TypeAmounts[_k].max)
  end
  self:SetUnitAmounts(Config.UnitsMin, Config.UnitsMax)
  for _i = 1, #Config.LimitedSpawnStrings, 1 do
    self:AddLimitedSpawn(Config.LimitedSpawnStrings[_i])
  end
  self:AddExtraTypesToGroups(ExtraTypes)
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigImport() - self")
    BASE:E(self)
  end
  return self
end

--- Triggers the Generation of the Dynamic Spawner.
--
--      Sets up "multithreading" (co-routines) for operation,
--      schedulers related to the coroutine,
--      then starts the SPECTRE.DYNAMIC_SPAWNER.GenerationProcess
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : if generation completes, returns self with:
--
--      self.Co_MultiGenerate = nil
--      self.GenerationComplete = true
-- Otherwise,
--
--      self.Co_MultiGenerate = the coroutine
--      self.GenerationComplete = false
function SPECTRE.DYNAMIC_SPAWNER:Generate()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.Generate = {
      Time = {},
    }
    self.DebugLog.Generate.Time.start = os.clock()
  end
  self.GenerationComplete = false
  self.GenerationInProgress = true
  self:GenerationProcess()
  self.GenerationComplete = true
  self.GenerationInProgress = false
  --  if self.Co_MultiGenerate == nil then
  --    self.Co_MultiGenerate = coroutine.create(self.GenerationProcess)--SPECTRE.DYNAMIC_SPAWNER.GenerationProcess)
  --  elseif coroutine.status(self.Co_MultiGenerate) == "dead" then
  --    self.GenerationComplete = true
  --  end
  --  self.Co_MultiGenerate_Scheduler = SCHEDULER:New(nil, function(self)
  --    if self.DebugEnabled == 1 then
  --      BASE:E("SPECTRE|DYNAMIC_SPAWNER - Generate() - self.Co_MultiGenerate_Scheduler")
  --      BASE:E(self.Co_MultiGenerate_Scheduler)
  --    end
  --    if coroutine.status(self.Co_MultiGenerate) == "suspended" then
  --      coroutine.resume(self.Co_MultiGenerate, self)
  --    end
  --    if coroutine.status(self.Co_MultiGenerate) == "dead" then
  --      self.GenerationComplete = true
  --      self.Co_MultiGenerate_Scheduler:Stop()
  --      self.Co_MultiGenerate_Scheduler = nil
  --    end
  --    if self.GenerationComplete == true then
  --      if self.DebugEnabled == 1 then
  --        self.DebugLog.Generate.Time.stop = os.clock()
  --        BASE:E("SPECTRE|DYNAMIC_SPAWNER - Generate Complete - Time: ".. self.DebugLog.Generate.Time.stop - self.DebugLog.Generate.Time.start)
  --      end
  --      self.Co_MultiGenerate = nil
  --      self.GenerationComplete = true
  --      self.GenerationInProgress = false
  --      return self
  --    end
  --  end, {self}, 1, self.Config.operationInterval)
  return self
end
--function SPECTRE.DYNAMIC_SPAWNER:Generate()
-- -- local DEBUG = false or self.DebugEnabled
--  if self.DebugEnabled == 1 then
--    self.DebugLog.Generate = {
--      Time = {},
--    }
--    self.DebugLog.Generate.Time.start = os.clock()
--  end
--  self.GenerationComplete = false
--  self.GenerationInProgress = true
--  if self.Co_MultiGenerate == nil then
--    self.Co_MultiGenerate = coroutine.create(self.GenerationProcess)--SPECTRE.DYNAMIC_SPAWNER.GenerationProcess)
--  elseif coroutine.status(self.Co_MultiGenerate) == "dead" then
--    self.GenerationComplete = true
--  end
--  self.Co_MultiGenerate_Scheduler = SCHEDULER:New(nil, function(self)
--    if self.DebugEnabled == 1 then
--      BASE:E("SPECTRE|DYNAMIC_SPAWNER - Generate() - self.Co_MultiGenerate_Scheduler")
--      BASE:E(self.Co_MultiGenerate_Scheduler)
--    end
--    if coroutine.status(self.Co_MultiGenerate) == "suspended" then
--      coroutine.resume(self.Co_MultiGenerate, self)
--    end
--    if coroutine.status(self.Co_MultiGenerate) == "dead" then
--      self.GenerationComplete = true
--      self.Co_MultiGenerate_Scheduler:Stop()
--      self.Co_MultiGenerate_Scheduler = nil
--    end
--    if self.GenerationComplete == true then
--      if self.DebugEnabled == 1 then
--        self.DebugLog.Generate.Time.stop = os.clock()
--        BASE:E("SPECTRE|DYNAMIC_SPAWNER - Generate Complete - Time: ".. self.DebugLog.Generate.Time.stop - self.DebugLog.Generate.Time.start)
--      end
--      self.Co_MultiGenerate = nil
--      self.GenerationComplete = true
--      self.GenerationInProgress = false
--      return self
--    end
--  end, {self}, 1, self.Config.operationInterval)
--  return self
--end

---Configuration.
-- ===
--
-- *All Functions associated with configuration of the DYNAMIC_SPAWNER class.*
--
-- ===
--
--  **DYNAMIC_SPAWNER Configuration Template**
--
--  As seen in the above "*Basic Use*" example, the DYNAMIC_SPAWNER Config was the table ***spawnerConfig***,
--
--     local spawnerConfig = {
--                             ZoneNames     = {...},
--                             Config        = {...},
--                             TypeTemplates = {...},
--                             ExtraTypes    = {...},
--                            }
-- ===
--
-- **The table 'spawnerConfig' has 4 sub-tables:**
--
--     ZoneNames     = {...},
--     Config        = {...},
--     TypeTemplates = {...},
--     ExtraTypes    = {...},
--
-- *where*
--
-- **ZoneNames**
--
--   *Contains all zone names for the spawner to work with (Main, Sub, and Restricted).*
--
--      --- Restricted.Main = #string
--      --            *The main zone of the dynamic spawner.
--      --            *All other zones are contained within it.
--                      ex. Main = "Zone_Main",
--
--      --- Restricted.Sub = #table
--      --            *All sub zones of the dynamic spawner
--      --            *Used for weighting location probability of type group clusters.
--                      ex. Sub = {"Zone_Sub-1",
--                                 "Zone_Sub-2",
--                                 "Zone_Sub-3",},
--
--      --- Restricted.Restricted = #table
--      --            *All restricted zones of the dynamic spawner.
--      --            *Prevents spawning of any Type within any restricted zone.
--                      ex. Restricted = {"Zone_Restricted-1",
--                                        "Zone_Restricted-2",
--                                        "Zone_Restricted-3",},
--      --         Can be = {} or nil
--                      ex. Restricted = {}
--                      ex. Restricted = nil
--     ---------------------------------------------------------------------------------
--      ZoneNames = {
--                    Main = "Zone_Main",
--                    Sub = {"Zone_Sub-1", "Zone_Sub-2", "Zone_Sub-3",},
--                    Restricted = {
--                                   "Zone_Restricted-1",
--                                   "Zone_Restricted-2",
--                                   "Zone_Restricted-3",
--                                 },
--                  }
--
-- **TypeTemplates**
--
--   *Contains the Types the dynamic spawner will have access to, and their corresponding Mission Editor Template Group Names.*
--
--      --- Type: The defined term for the 'type' of unit you are spawning.
--      --      In these examples, Types are grouped by the 'type' of object.
--                  eg. Type = APC, IFV, MBT, Supply
--      --      These can be anything you want.
--                  eg. Type = Type1, Yellow, Train, Cow
--      --      In TypeTemplates below, Type can be seen as:
--                      TypeTemmplates.Type   = {...}
--
--                      TypeTemmplates.APC    = {...}
--                      TypeTemmplates.IFV    = {...}
--                      TypeTemmplates.MBT    = {...}
--                      TypeTemmplates.Supply = {...}
--
--      --- Templates: The defined group name for the 'template' of type you are spawning.
--      --       These must match a group name in the mission editor, late activated.
--      --       The groups can be any number of units, but will only count as 1 'Type'.
--
--      --      eg. 2 groups in the mission editor with:
--                             groupname1 = "exGroupName1"
--                             1 Unit in group
--                             groupname2 = "exGroupName2"
--                             3 Units in group
--
--      --       Even though each group has a different number of units,
--      --       each group only counts as 1 'Type' to the Dynamic Spawner.
--      --
--      --       So if UnitsMin = 5, that means the spawner will spawn 5 types minimum.
--      --
--      --       Because the above example 'groupname1' is 1 units per 'Type'
--      --       the spawner would place 5 units minimum.
--      --       While because the above example 'groupname2' is 3 units per 'Type'
--      --       the spawner would place 15 units minimum.
--      --
--      --  In these examples:
--      --     Templates are 1 placed unit per group in the Mission editor.
--      --     The Template ME group name matches below 'Templates'.
--      --
--      --     Templates are grouped by the 'type' of object.
--               eg. Type = Template
--               eg. TypeTemmplates.IFV = {"Template_IFV_Bradley","Template_IFV_Warrior",}
--
--      --     In TypeTemplates below, Templates can be seen as:
--                   TypeTemmplates.Type  = Templates
--                   TypeTemmplates.IFV    = {
--                                             "Template_IFV_Bradley",
--                                              "Template_IFV_Warrior",
--                                           }
--     ---------------------------------------------------------------------------------
--      TypeTemplates = {
--                        APC  = {
--                                 "Template_APC_BTR80",
--                                 "Template_APC_MTLB",
--                                 "Template_APC_BTRRD",
--                               },
--                        IFV  = {
--                                 "Template_IFV_Bradley",
--                                 "Template_IFV_Warrior",
--                               },
--                        MBT  = {
--                                 "Template_MBT_T72B",
--                                 "Template_MBT_T72B3",
--                               },
--                        Supply  = {
--                                 "Template_Supply_Kamaz",
--                                 "Template_Supply_KrAZ",
--                                 "Template_Supply_ZIL135",
--                               },
--                      }
--
-- **Config**
--
--   *Contains general spawn configuration information for the dynamic spawner.*
--
--      --- Config.UnitsMin = #integer,
--      --       *The minimum amount of Types the Dynamic Spawner is allowed to place.
--                 ex. UnitsMin          = 30,
--
--      --- Config.UnitsMax = #integer,
--      --       *The maximum amount of Types the Dynamic Spawner is allowed to place.
--                 ex. UnitsMax          = 50,
--
--      --- Config.LimitedSpawnStrings = #table
--      --       *These strings are searched for within the Type names of the Spawner.
--      --       *If a Type name contains any of these strings:
--      --       -The Dynamic Spawner will NEVER spawn more than the min specified
--      --       -@see SPECTRE.DYNAMIC_SPAWNER:AddLimitedSpawn()
--      --       -Useful for Types that can *drastically* change gameplay,
--      --              *Eg. SAMS, AAA, MANPADS, SPAAA, etc.
--                ex. LimitedSpawnStrings = {"SAM_","AAA","MBT",},
--
--      --- Config.TypeAmounts = #table
--      --       *The min and max of each Type allowed to be spawned.
--               ex. TypeAmounts.Type = {min = 5, max = 0}
--               ex. TypeAmounts.APC  = {min = 5, max = 0}
--     ---------------------------------------------------------------------------------
--      Config = {
--               UnitsMin            = 30,
--               UnitsMax            = 50,
--               LimitedSpawnStrings = {"SAM_","AAA","MBT",},
--               TypeAmounts = {
--                                APC             = {min = 5, max = 0},
--                                IFV             = {min = 3, max = 0},
--                                MBT             = {min = 3, max = 7},
--                                Supply          = {min = 3, max = 0},
--                              },
--            }
--
-- **ExtraTypes**
--
--   *Contains extra Types that the spawner must add to every generated group, and the amount of each type.*
--
--         --- Config.ExtraTypes = #table
--         --       *The extra types and amount of each that the spawner adds to each group.
--                       ex. ExtraTypes = {
--                                          [1] = {
--                                                  type = "Supply",
--                                                  numtype = 2,
--                                                },
--                                          [...] = {...},
--                                          [n] = {
--                                                  type = Type,
--                                                  numtype = 1,
--                                                },
--                                        }
--
--         --         Can be = {} or nil
--                       ex. ExtraTypes = {}
--                       ex. ExtraTypes = nil
--
--     ---------------------------------------------------------------------------------
--               ExtraTypes = {
--                              [1] = {
--                                      type = "Supply",
--                                      numtype = 2
--                                    },
--                             }
--
--
-- **Example spawnerConfig**
--
--   *An example that adds together all aspects shown above.*
--
--     spawnerConfig = {
--                       ZoneNames = {
--                                    Main = "Zone_Main",
--                                    Sub = {"Zone_Sub-1", "Zone_Sub-2", "Zone_Sub-3",},
--                                    Restricted = {
--                                                   "Zone_Restricted-1",
--                                                   "Zone_Restricted-2",
--                                                   "Zone_Restricted-3",
--                                                  },
--                                    },
--                       Config    = {
--                                      UnitsMin                = 30,
--                                      UnitsMax                = 50,
--                                      LimitedSpawnStrings     = {"SAM_","AAA","MBT",},
--                                      TypeAmounts = {
--                                                      APC     = {min = 5, max = 0},
--                                                      IFV     = {min = 3, max = 0},
--                                                      MBT     = {min = 3, max = 7},
--                                                      Supply  = {min = 3, max = 0},
--                                                    },
--                                    },
--                       TypeTemplates = {
--                                          APC     = {
--                                                      "Template_APC_BTR80",
--                                                      "Template_APC_MTLB",
--                                                      "Template_APC_BTRRD",
--                                                    },
--                                          IFV     = {
--                                                      "Template_IFV_Bradley",
--                                                      "Template_IFV_Warrior",
--                                                    },
--                                          MBT     = {
--                                                      "Template_MBT_T72B",
--                                                      "Template_MBT_T72B3",
--                                                    },
--                                          Supply  = {
--                                                      "Template_Supply_Kamaz",
--                                                      "Template_Supply_KrAZ",
--                                                      "Template_Supply_ZIL135",
--                                                    },
--                                      },
--                       ExtraTypes   = {
--                                         [1] = {
--                                                 type = "Supply",
--                                                 numtype = 2
--                                               },
--                                      },
--                      }
--
-- ===
-- @section Configuration

--- Parses imported configs for the SPECTRE.DYNAMIC_SPAWNER.
--
-- Allows config to be used by the spawner.
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self
--
--     self with added tables:
--
--     self.ParsedTypes = Usable final step. Contains relevant LimitedTypes & UnLimitedTypes in a single entry.
--          not passed to self -->    LimitedTypes = Types that have a limit associated with amount spawned
--          not passed to self -->    UnLimitedTypes = Types that DO NOT have a limit associated with amount spawned
--     self.ParsedTypes.limited = 0 or 1
--     All above types have a ".limited" value associated with them.
--     0 = unlimited spawn
--     1 = has a limit associated with the amount spawned
function SPECTRE.DYNAMIC_SPAWNER:ConfigParse()
  if self.DebugEnabled == 1 then
    self.DebugLog.ConfigParse = {Time = {}}
    self.DebugLog.ConfigParse.Time.start = os.clock()
  end
  local configParsedTypes = {}
  local configTypes = self.Config.Types
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigParse - configTypes")
    BASE:E(configTypes)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigParse - self")
    BASE:E(self)
  end
  for typeName, typeData in pairs(configTypes) do
    if typeData.amounts.min ~= 0 then
      local isLimited = false
      for i = 1, #self.Config.LimitedSpawnStrings do
        if string.find(typeName, self.Config.LimitedSpawnStrings[i]) then
          isLimited = true
          break
        end
      end
      typeData.limited = isLimited and 1 or 0
      configParsedTypes[typeName] = typeData
    end
  end

  self.ParsedTypes = configParsedTypes

  if self.DebugEnabled == 1 then
    self.DebugLog.ConfigParse.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER: ConfigParse - Time: " .. self.DebugLog.ConfigParse.Time.stop - self.DebugLog.ConfigParse.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigParse - self.LimitedTypes")
    BASE:E(self.LimitedTypes)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigParse - self.UnLimitedTypes")
    BASE:E(self.UnLimitedTypes)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ConfigParse - self.ParsedTypes")
    BASE:E(self.ParsedTypes)
  end

  return self
end

--- Adds a Type to the SPECTRE.DYNAMIC_SPAWNER Object.
--
-- Also adds a namesList for all Type related Templates.
--
-- @param #DYNAMIC_SPAWNER self
-- @param typeName The name of the spawner Type to be added. Ex:
--
--      typeName = "LBT"
-- @param namesList List of all groupnames defined in Mission Editor for the specified Type. Ex:
--
--      namesList = { "Template_LBT_PT76","Template_LBT_Sherman","Template_LBT_Pz4",}
-- @return #DYNAMIC_SPAWNER self
--
-- DYNAMIC_SPAWNER Object with new table:
--
--     self.Config.Types[typeName]
-- @usage
-- local typeName = "LBT"
-- local namesList = { "Template_LBT_PT76","Template_LBT_Sherman","Template_LBT_Pz4",}
-- local spawnerObject = SPECTRE.DYNAMIC_SPAWNER:New()
-- spawnerObject:AddType(typeName, namesList)
-- -- results in:
-- spawnerObject.Config.Types[typeName] = {
--                                           names = namesList,
--                                           amounts = {min = 0, max = 0},
--                                         }
function SPECTRE.DYNAMIC_SPAWNER:AddType(typeName, namesList)
  if self.DebugEnabled == 1 then
    self.DebugLog.AddType = {Time = {}}
    self.DebugLog.AddType.Time.start = os.clock()
  end
  self.Config.Types[typeName] = {
    names = namesList,
    amounts = { min = 0, max = 0 }
  }
  if self.DebugEnabled == 1 then
    self.DebugLog.AddType.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - AddType - Time: " .. self.DebugLog.AddType.Time.stop - self.DebugLog.AddType.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - AddType - self.Config.Types[typeName]")
    BASE:E(self.Config.Types[typeName])
  end
  return self
end

--- Force adds the specified extra types to  all spawned groups.
--
-- Keep in mind that this in ADDED to normal generation totals.
--
-- @param #DYNAMIC_SPAWNER self
-- @param nTypes : Config Table for types that are going to be force added to each group.
-- @return #DYNAMIC_SPAWNER self
--
-- DYNAMIC_SPAWNER Object with new tables:
--
--     self.ExtraTypesToGroups = nTypes
--     self.Config.numExtraTypes =  total number of extra spawner type categories to force add to groups
--     self.Config.numExtraUnits = Total number of individual types to be added summed from all types categories.
-- @usage
-- nTypes = {
--            [1] = {
--                     type = "Supply",
--                     numtype = 2
--                   },
--                .. = ..,
--            [n] = {
--                     type = "TypeName",
--                     numtype = number
--                  },
--           }
--    where
-- type = "TypeName" : #string : name of the spawner type.
-- numtype = number : #integer : How many of the type to force add to each generated group.
--
-- DYNAMIC_SPAWNER_OBJECT:AddExtraTypesToGroups(nTypes)
-- returns self
--     DYNAMIC_SPAWNER_OBJECT.ExtraTypesToGroups = nTypes
--     DYNAMIC_SPAWNER_OBJECT.Config.numExtraTypes =  total number of extra spawner type categories to force add to groups
--     DYNAMIC_SPAWNER_OBJECT.Config.numExtraUnits = Total number of individual types to be added summed from all types categories.
function SPECTRE.DYNAMIC_SPAWNER:AddExtraTypesToGroups(nTypes)
  self.ExtraTypesToGroups = nTypes
  if self.ExtraTypesToGroups ~= nil then
    self.Config.numExtraTypes = #self.ExtraTypesToGroups
    self.Config.numExtraUnits = 0
    for i = 1, self.Config.numExtraTypes do
      self.Config.numExtraUnits = self.Config.numExtraUnits + self.ExtraTypesToGroups[i].numtype
    end
  end
  return self
end

--- Adds the given string to the list of limited spawn types.
--
-- Limited Spawn Type = a spawner Type that is not allowed to be used for blanket fill.
--
-- When the desired min number of the type spawned is reached, it will remove the type from any future chosen type.
--
-- @param #DYNAMIC_SPAWNER self
-- @param string : string to be added to the limited types.
--
-- CAUTION : GOOD NAMING CONVENTION
--
-- All type names will be searched for the given string. eg:
--
--     if string == "AAA" and there are 3 types:
--     {"AAA", "SPAAA", "Supply"}, then,
--     because types 1 & 2 contain string "AAA",
--     they will be limited to the minimum specified amount
--
-- @return DYNAMIC_SPAWNER self, new tables added:
--
--     self.Config.LimitedSpawnStrings[#self.Config.LimitedSpawnStrings + 1] = string
function SPECTRE.DYNAMIC_SPAWNER:AddLimitedSpawn(str)
  table.insert(self.Config.LimitedSpawnStrings, str)
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - AddLimitedSpawn - self.Config.LimitedSpawnStrings")
    BASE:E(self.Config.LimitedSpawnStrings)
  end
  return self
end

--- Adds a zone to the Dynamic Spawner.
--
-- Main, Sub, or Restricted.
--
--@param #DYNAMIC_SPAWNER self
--@param ZoneName : #string, name of the zone
--@param Type : #string, type of zone. Options are:
--
--      "main" -------- overall encompassing zone
--                    - ZONE_RADIUS
--      "sub"  -------- sub-zones within the main zone.
--                    - ZONE_RADIUS
--      "restricted" -- zones where Types are not allowed to be spawned
--                    - QUAD POINT ZONE
--                    - Defined in Mission Editor
--
--@return #DYNAMIC_SPAWNER self : self with tables added for
--
--         self.Zones.Main
--         self.Zones.Sub[#]
--         self.Zones.Restricted[#]
-- where for .Main and .Sub[#]
--
--         self.Zones.Main   = {
--           or
--         self.Zones.Sub[#] = {
--                                name = ZoneName
--                                DistanceFromBuildings = self.Config.GroupSpacingSettings.General.DistanceFromBuildings
--                              }
-- and
--
--        self.Zones.Restricted[#] = ZoneName
function SPECTRE.DYNAMIC_SPAWNER:ZoneAdd(ZoneName, Type)
  if Type == "main" then
    self.Zones.Main = {
      name = ZoneName,
      DistanceFromBuildings = self.Config.GroupSpacingSettings.General.DistanceFromBuildings,
    }
  elseif Type == "sub" then
    table.insert(self.Zones.Sub, {
      name = ZoneName,
      DistanceFromBuildings = self.Config.GroupSpacingSettings.General.DistanceFromBuildings,
    })
  elseif Type == "restricted" then
    table.insert(self.Zones.Restricted, ZoneName)
  end
  return self
end

---Sets the limits for amounts of units (Template Types).
--
-- Totals, Max and Min for possible spawned types.
--
--@param #DYNAMIC_SPAWNER self
--@param min : minimum amount of Template Types (units)
--@param max : maximum amount of Template Types (units)
--@return #DYNAMIC_SPAWNER self : self with tables added for .UnitsMin, .UnitsMax
--
--        self.Config.UnitsMin = min
--        self.Config.UnitsMax = max
function SPECTRE.DYNAMIC_SPAWNER:SetUnitAmounts(min, max)
  max = max or 0
  self.Config.UnitsMin = min
  self.Config.UnitsMax = max
  return self
end

---Sets the amounts for each type.
--
-- Sets min and max for specific type.
--
-- @param #DYNAMIC_SPAWNER self
-- @param typeName : Name of the Type to set amounts for:
--
--       typeName = "Supply"
-- @param min : Minimum amount of the Type allowed:
-- @param max : Maximum amount of the Type allowed:
-- @return #DYNAMIC_SPAWNER self : self with added tables for
--
--        self.Config.Types[typeName].amounts.min = min
--        self.Config.Types[typeName].amounts.max = max
--        self.Config.Types[typeName].amounts.numUsed = 0
function SPECTRE.DYNAMIC_SPAWNER:SetTypeAmount(typeName, min, max)
  max = max or 0
  self.Config.Types[typeName].amounts.min = min
  self.Config.Types[typeName].amounts.max = max
  self.Config.Types[typeName].amounts.numUsed = 0
  return self
end

---Advanced Use.
-- ===
--
-- *All Functions associated with advanced use of the DYNAMIC_SPAWNER class.*
--
-- ===
-- @section Advanced Use

---Enables outputting Debug information for all functions to the DCS.log.
--
--      Simply calling :EnableDebugLog() enables the debug log.
--      To disable, call :EnableDebugLog(false)
--
-- @param #DYNAMIC_SPAWNER self
-- @param value : argument: nil, true, false
--
--      If provided with false, disables Debug log.
--            ex: :EnableDebugLog(false)
--      If provided with true or ommitted, enables Debug log.
--            ex: :EnableDebugLog(true)
--            ex: :EnableDebugLog()
-- @return #DYNAMIC_SPAWNER self : self with self.DebugEnabled = 0 or 1
function SPECTRE.DYNAMIC_SPAWNER:EnableDebugLog(value)
  value = value or true
  if value == true then
    self.DebugEnabled = 1
  elseif value == false then
    self.DebugEnabled = 0
  end
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - EnableDebugLog - " .. self.DebugEnabled)
  end
  return self
end

---Enables outputting Debug information for key functions to the game messages.
--
--         Simply calling :EnableDebugMessages() enables the debug messages.
--
--         To disable, call :EnableDebugMessages(false)
--
-- @param #DYNAMIC_SPAWNER self
-- @param value : argument: nil, true, false
--
--      If provided with false, disables Debug log.
--            ex: :EnableDebugMessages(false)
--      If provided with true or ommitted, enables Debug log.
--             ex: :EnableDebugMessages(true)
--             ex: :EnableDebugMessages()
-- @param summaryOnly : argument: nil, true, false
--
--      If provided with false or ommitted, full Debug Message is sent.
--             ex: :EnableDebugMessages(true,false)
--             ex: :EnableDebugMessages(true)
--      If provided with true, only a shorter summary Debug Message is sent.
--             ex: :EnableDebugMessages(true,true)
-- @return #DYNAMIC_SPAWNER self : self with self.DebugMessages = 0 or 1
function SPECTRE.DYNAMIC_SPAWNER:EnableDebugMessages(value, summaryOnly)
  if value == true then
    self.DebugMessages = 1
  elseif value == false then
    self.DebugMessages = 0
  end
  if summaryOnly == true then
    self.DebugSummaryOnly = 1
  elseif summaryOnly == false then
    self.DebugSummaryOnly = 0
  end
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - EnableDebugMessages - " .. self.DebugMessages )
  end
  return self
end

---Toggles current Debug Messages state.
--
--         Simply calling :ToggleDebugMessages() toggles the debug message state.
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : self with self.DebugMessages toggled = 0 or 1
function SPECTRE.DYNAMIC_SPAWNER:ToggleDebugMessages()
  if self.DebugMessages == 0 then
    self.DebugMessages = 1
    trigger.action.outText("Debug Messages Started",5, false)
  elseif self.DebugMessages == 1 then
    self.DebugMessages = 0
    trigger.action.outText("Debug Messages Stopped",5, false)
  end
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - ToggleDebugMessages - State: " .. self.DebugMessages )
  end
  return self
end

--- Dumps up to 3 levels of the self table (Keys+values, Parent+Children) to the DCS log.
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self
function SPECTRE.DYNAMIC_SPAWNER:DEBUG_PRINT_self()
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - DEBUG_PRINT_self()")
    self:PrintTable(self, 0, 3)
  end
  return self
end

function SPECTRE.DYNAMIC_SPAWNER:PrintTable(tbl, level, maxLevel)
  if level > maxLevel then
    return
  end
  for key, value in pairs(tbl) do
    BASE:E(string.rep("  ", level) .. key)
    if type(value) == "table" then
      self:PrintTable(value, level + 1, maxLevel)
    else
      BASE:E(string.rep("  ", level + 1) .. value)
    end
  end
end


--- Sets the limiter for coroutine ("multithreading") operations.
--
--      The coroutine will execute "limit" number of operations
--      before yielding back to main thread.
--
-- ***CAUTION:***
--
--        Increasing this value too high can result in server hangs
--        Decreasing this value too low can result in long generation times
--
-- @param #DYNAMIC_SPAWNER self
-- @param limit : The Operational Limit, integer.
--
--        self.Config.operationLimit = limit
--        Default limit value = 200
-- @return #DYNAMIC_SPAWNER self
function SPECTRE.DYNAMIC_SPAWNER:SetCoRoutineLimit(limit)
  limit = limit or self.Config.operationLimit
  self.Config.operationLimit = limit
  return self
end

--- Sets the interval for coroutine ("multithreading") operations.
--
--      The coroutine will yield for the interval number (in seconds)
--      before resuming the operation when the operationLimit is hit.
--
-- ***CAUTION:***
--
--        Increasing this value too high can result in long generation times
--
-- @param #DYNAMIC_SPAWNER self
-- @param interval : The Operational interval, integer.
--
--        self.Config.operationInterval = interval
--        Default interval value = 3
-- @return #DYNAMIC_SPAWNER self
function SPECTRE.DYNAMIC_SPAWNER:SetCoRoutineInterval(interval)
  interval = interval or self.Config.operationInterval
  self.Config.operationInterval = interval
  return self
end

---Internal Functions.
-- ===
--
-- *All Functions associated with the Internal Functions of the DYNAMIC_SPAWNER class.*
--
-- ===
--      Automatically used by the extension as needed.
--
--      Use these at your own risk during Dynamic Spawner operations.
--
-- ===
-- @section Internal Functions

---Weights and analyzes all zones for spawner generation process.
--@param #DYNAMIC_SPAWNER self
--@return #DYNAMIC_SPAWNER self : self with tables added for
--
--        .zone
--        .radius
--        .area
--        .weight
-- where
--
--         self.Zones.Main.zone = ZONE:FindByName(self.Zones.Main.name)
--         self.Zones.Main.radius = self.Zones.Main.zone:GetRadius()
--         self.Zones.Main.area = math.pi * (self.Zones.Main.radius)^2
--         self.Zones.Main.weight = 1 - sum of all sub zone weights
--         and
--         self.Zones.Sub[_i].zone = ZONE:FindByName(self.Zones.Sub[_i].name)
--         self.Zones.Sub[_i].radius = self.Zones.Sub[_i].zone:GetRadius()
--         self.Zones.Sub[_i].area = math.pi * (self.Zones.Sub[_i].radius)^2
--         self.Zones.Sub[_i].weight = self.Zones.Sub[_i].area / self.Zones.Main.area
-- where
--
--         _i = Number of the self.Zone.Sub table
function SPECTRE.DYNAMIC_SPAWNER:WeightZones()
  if self.DebugEnabled == 1 then
    self.DebugLog.WeightZones = {Time = {},}
    self.DebugLog.WeightZones.Time.start = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - WeightZones()")
  end
  self:CalculateZone(self.Zones.Main)
  local totalWeight = 0
  for i = 1, #self.Zones.Sub do
    self:CalculateZone(self.Zones.Sub[i])
    totalWeight = totalWeight + self.Zones.Sub[i].weight
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - WeightZones() - self.Zones.Sub[" .. i .. "]")
      BASE:E(self.Zones.Sub[i])
    end
  end
  self.Zones.Main.weight = 1 - totalWeight
  self.Zones.Main.weight = math.max(0, math.min(1, self.Zones.Main.weight))
  if self.DebugEnabled == 1 then
    self.DebugLog.WeightZones.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - WeightZones() - Time: " .. self.DebugLog.WeightZones.Time.stop - self.DebugLog.WeightZones.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - WeightZones() - self.Zones.Main")
    BASE:E(self.Zones.Main)
  end
  return self
end

function SPECTRE.DYNAMIC_SPAWNER:CalculateZone(zone)
  zone.zone = ZONE:FindByName(zone.name)
  zone.radius = zone.zone:GetRadius()
  zone.area = math.pi * (zone.radius)^2
  zone.weight = zone.area / self.Zones.Main.area
end

--- Determines the number of Types to be assigned to each zone.
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : Returns self with an added .numUnits value for each zone:
--
--       self.Zones.Main.numUnits
--       self.Zones.Sub[_i].numUnits
-- where
--       _i = Number of the self.Zone.Sub table
--       .numUnits = the number of Types to be assigned to the zone
function SPECTRE.DYNAMIC_SPAWNER:SetNumTypesPerZone()
  if self.DebugEnabled == 1 then
    self.DebugLog.SetNumTypesPerZone = {Time = {},}
    self.DebugLog.SetNumTypesPerZone.Time.start = os.clock()
  end
  local unitsMax  = self.Config.UnitsMax
  local unitsMin  = self.Config.UnitsMin
  local ActualUnits  = math.random(unitsMin, unitsMax)
  local tally = 0
  self.Zones.Main.numUnits = math.ceil(self.Zones.Main.weight * ActualUnits)
  for _i = 1, #self.Zones.Sub, 1 do
    self.Zones.Sub[_i].numUnits = math.ceil(self.Zones.Sub[_i].weight * ActualUnits)
    tally = tally + self.Zones.Sub[_i].numUnits
  end
  if tally > ActualUnits then
    self.Zones.Main.numUnits = self.Zones.Main.numUnits - (tally - ActualUnits)
  end
  if (tally + self.Zones.Main.numUnits) > ActualUnits then
    self.Zones.Main.numUnits = self.Zones.Main.numUnits - ((tally + self.Zones.Main.numUnits) - ActualUnits  )
  end
  if self.Zones.Main.numUnits < 0 then
    self.Zones.Main.numUnits = 0
  end
  repeat
    if self.Zones.Main.numUnits >= #self.Zones.Sub then
      self.Zones.Main.numUnits = self.Zones.Main.numUnits - #self.Zones.Sub
      for _i = 1, #self.Zones.Sub, 1 do
        self.Zones.Sub[_i].numUnits = self.Zones.Sub[_i].numUnits + 1
      end
    end
  until(self.Zones.Main.numUnits <= #self.Zones.Sub)
  if self.DebugEnabled == 1 then
    self.DebugLog.SetNumTypesPerZone.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - Time: " .. self.DebugLog.SetNumTypesPerZone.Time.stop - self.DebugLog.SetNumTypesPerZone.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone()")
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - ActualUnits")
    BASE:E(ActualUnits)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - self.Zones.Main.name")
    BASE:E(self.Zones.Main.name)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - self.Zones.Main.numUnits")
    BASE:E(self.Zones.Main.numUnits)
    for _i = 1, #self.Zones.Sub, 1 do
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - self.Zones.Sub[_i].name")
      BASE:E(self.Zones.Sub[_i].name)
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetNumTypesPerZone() - self.Zones.Sub[_i].numUnits")
      BASE:E(self.Zones.Sub[_i].numUnits)
    end
  end
  return self
end

---Sets up the groups per zone based on provided configs, settings, and generation.
--@param #DYNAMIC_SPAWNER self
--@return #DYNAMIC_SPAWNER self : self with added tables for .GroupSettings :
--
--      self.Zones.Main.GroupSettings
--      self.Zones.Sub[_j].GroupSettings
-- where
--
--      _j = Number of the self.Zone.Sub table
--      .GroupSettings[#] = {
--                           GroupSize = GroupSizesMainZone[_i],
--                           NumberGroups = numGroupSize,
--                           minSeparation_Groups = _GroupSpacingSettings[GroupSizesMainZone[_i]].minSeparation_Groups or _GroupSpacingSettings.General.minSeparation_Groups,
--                           minSeperation = _GroupSpacingSettings[GroupSizesMainZone[_i]].minSeperation or _GroupSpacingSettings.General.minSeperation,
--                           maxSeperation = _GroupSpacingSettings[GroupSizesMainZone[_i]].maxSeperation or _GroupSpacingSettings.General.maxSeperation,
--                         }
-- where
--
--      _i = Number of the #self.Config.GroupSizesMainZone or #self.Config.GroupSizes table
function SPECTRE.DYNAMIC_SPAWNER:SetGroupsPerZone()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupsPerZone = {Time = {},}
    self.DebugLog.SetGroupsPerZone.Time.start = os.clock()
  end
  local GroupSizesSubZone = self.Config.GroupSizes
  local GroupSizesMainZone = self.Config.GroupSizesMainZone
  local _GroupSpacingSettings = self.Config.GroupSpacingSettings

  self.Zones.Main.GroupSettings = {}
  local Units_MainZone = self.Zones.Main.numUnits

  for i = 1, #GroupSizesMainZone do
    local numGroupSize = math.floor(Units_MainZone / GroupSizesMainZone[i])
    if numGroupSize ~= 0 then
      Units_MainZone = Units_MainZone - (numGroupSize * GroupSizesMainZone[i])
      self.Zones.Main.GroupSettings[#self.Zones.Main.GroupSettings + 1] = self:CreateGroupSettings(GroupSizesMainZone[i], numGroupSize)
    end
  end

  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupsPerZone() - self.Zones.Main")
    BASE:E(self.Zones.Main)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupsPerZone() - self.Zones.Main.GroupSettings")
    BASE:E(self.Zones.Main.GroupSettings)
  end

  for j = 1, #self.Zones.Sub do
    self.Zones.Sub[j].GroupSettings = {}
    local Units_SubZone = self.Zones.Sub[j].numUnits

    for i = 1, #GroupSizesSubZone do
      local numGroupSize = math.floor(Units_SubZone / GroupSizesSubZone[i])
      if numGroupSize ~= 0 then
        Units_SubZone = Units_SubZone - (numGroupSize * GroupSizesSubZone[i])
        self.Zones.Sub[j].GroupSettings[#self.Zones.Sub[j].GroupSettings + 1] = self:CreateGroupSettings(GroupSizesSubZone[i], numGroupSize)
      end
    end

    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupsPerZone() - self.Zones.Sub[" .. j .. "]")
      BASE:E(self.Zones.Sub[j])
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupsPerZone() - self.Zones.Sub[" .. j .. "].GroupSettings")
      BASE:E(self.Zones.Sub[j].GroupSettings)
    end
  end

  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupsPerZone.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER: SetGroupsPerZone - Time: " .. self.DebugLog.SetGroupsPerZone.Time.stop - self.DebugLog.SetGroupsPerZone.Time.start)
  end

  return self
end

function SPECTRE.DYNAMIC_SPAWNER:CreateGroupSettings(groupSize, numGroups)
  local _GroupSpacingSettings = self.Config.GroupSpacingSettings
  return {
    GroupSize = groupSize,
    NumberGroups = numGroups,
    minSeparation_Groups = _GroupSpacingSettings[groupSize].minSeparation_Groups or _GroupSpacingSettings.General.minSeparation_Groups,
    minSeperation = _GroupSpacingSettings[groupSize].minSeperation or _GroupSpacingSettings.General.minSeperation,
    maxSeperation = _GroupSpacingSettings[groupSize].maxSeperation or _GroupSpacingSettings.General.maxSeperation,
  }
end

--- Determine the Types comprising each generated group.
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : With added tables for:
--
--       self.Zones.Sub[_i].BuiltSpawner[_j][_k].Types = _groupTypes
--       self.Zones.Main.BuiltSpawner[_j][_k].Types = _groupTypes
--
-- where
--
--       _i = Number of the self.Zone.Sub table
--       _j = # main group self.Sub[_i].GroupSettings or #self.Main.GroupSettings
--       _k = # sub group in self.Sub[_i].GroupSettings.NumberGroups or #self.Main.GroupSettings.NumberGroups
--       _groupTypes = {
--                        [1] = "Supply",
--                        [..] = "AAA",
--                        [n] = "typeName",
--                      }
function SPECTRE.DYNAMIC_SPAWNER:SetGroupTypes()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupTypes = {Time = {},}
    self.DebugLog.SetGroupTypes.Time.start = os.clock()
  end

  local typeList = {}
  for _k, _v in pairs(self.ParsedTypes) do
    typeList[#typeList + 1] = _k
  end

  local function removeTypeFromList(typeList, randType)
    local idx = SPECTRE.Utils.getIndex(typeList, randType)
    if idx ~= nil then
      table.remove(typeList, idx)
    end
  end

  local function generateGroupTypes(zone, groupSettings)
    local groupTypes = {}
    local allTypes = {}

    for _j = 1, #groupSettings, 1 do
      zone.BuiltSpawner[_j] = {}
      for _k = 1, groupSettings[_j].NumberGroups, 1 do
        zone.BuiltSpawner[_j][_k] = {}
        typeList = SPECTRE.Utils.Shuffle(typeList)
        local _groupTypes = {}

        for _t = 1, groupSettings[_j].GroupSize + self.Config.numExtraUnits, 1 do
          if _t <= groupSettings[_j].GroupSize then
            local randType = SPECTRE.Utils.PickRandomFromTable(typeList)
            local amount_min = self.ParsedTypes[randType].amounts.min
            local amount_max = self.ParsedTypes[randType].amounts.max
            local amount_numUsed = self.ParsedTypes[randType].amounts.numUsed
            local limited = self.ParsedTypes[randType].limited
            amount_numUsed = amount_numUsed + 1
            self.ParsedTypes[randType].amounts.numUsed = amount_numUsed

            if amount_max ~= 0 and amount_numUsed >= amount_max then
              removeTypeFromList(typeList, randType)
            end

            if amount_numUsed >= amount_min and limited == 1 then
              removeTypeFromList(typeList, randType)
            end

            _groupTypes[#_groupTypes + 1] = randType
            allTypes[#allTypes + 1] = randType
            self.AllTypes[#self.AllTypes + 1] = randType
          else
            local curNumExtraUnit = _t - groupSettings[_j].GroupSize
            local extraType
            local tempCounter = 0

            for _iTemp = 1, #self.ExtraTypesToGroups, 1 do
              for _x = 1, self.ExtraTypesToGroups[_iTemp].numtype, 1 do
                tempCounter = tempCounter + 1
                if tempCounter == curNumExtraUnit then
                  extraType = self.ExtraTypesToGroups[_iTemp].type
                  break
                end
              end
              if tempCounter == curNumExtraUnit then
                break
              end
            end

            _groupTypes[#_groupTypes + 1] = extraType
            allTypes[#allTypes + 1] = extraType
            self.AllTypes[#self.AllTypes + 1] = extraType
          end
        end

        zone.BuiltSpawner[_j][_k].Types = _groupTypes
      end
    end

    zone.AllTypes = allTypes
  end

  for _i = 1, #self.Zones.Sub, 1 do
    self.Zones.Sub[_i].BuiltSpawner = {}
    self.Zones.Sub[_i].AllTypes = {}
    generateGroupTypes(self.Zones.Sub[_i], self.Zones.Sub[_i].GroupSettings)
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypes() - self.Zones.Sub[_i]")
      BASE:E(self.Zones.Sub[_i])
    end
  end

  self.Zones.Main.AllTypes = {}
  self.Zones.Main.BuiltSpawner = {}
  generateGroupTypes(self.Zones.Main, self.Zones.Main.GroupSettings)

  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupTypes.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypes() - Time: " .. self.DebugLog.SetGroupTypes.Time.stop - self.DebugLog.SetGroupTypes.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypes() - self.Zones.Main")
    BASE:E(self.Zones.Main)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypes() - TOTAL COUNT")
    for _k, _v in pairs(self.ParsedTypes) do
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypes() - TOTAL COUNT - " .. _k)
      BASE:E(self.ParsedTypes[_k].amounts.numUsed)
    end
  end

  return self
end

--- Determine the corresponding type template for the generated Types comprising each generated group.
--
--      The template name is pulled from the list of provided template groupname
--      defined in the mission editor corresponding to the type.
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : With added tables for:
--
--       self.Zones.Sub[_i].BuiltSpawner[_j][_k].TemplateNames = _groupTypes
--       self.Zones.Main.BuiltSpawner[_j][_k].TemplateNames = _groupTypes
--
-- where
--
--       _i = Number of the self.Zone.Sub table
--       _j = # main group self.Sub[_i].GroupSettings or #self.Main.GroupSettings
--       _k = # sub group in self.Sub[_i].GroupSettings.NumberGroups
--            or
--            #self.Main.GroupSettings.NumberGroups
--
--       _groupTypes = {
--                        [1] = "Template_Supply_Ural375",
--                        [..] = "Template_ATGM_BTRRD",
--                        [n] = "typeName",
--                      }
function SPECTRE.DYNAMIC_SPAWNER:SetGroupTypesTemplates()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupTypesTemplates = {Time = {},}
    self.DebugLog.SetGroupTypesTemplates.Time.start = os.clock()
  end

  local function generateTemplateNames(zone, groupSettings, builtSpawner)
    for _j = 1, #groupSettings, 1 do
      for _k = 1, groupSettings[_j].NumberGroups, 1 do
        local _groupTypes = {}
        for _t = 1, groupSettings[_j].GroupSize + self.Config.numExtraUnits, 1 do
          local Type_ = builtSpawner[_j][_k].Types[_t]
          local TypeTable_ = self.ParsedTypes[Type_].names
          TypeTable_ = SPECTRE.Utils.Shuffle(TypeTable_)
          local randType = SPECTRE.Utils.PickRandomFromTable(TypeTable_)
          _groupTypes[#_groupTypes + 1] = randType
        end
        builtSpawner[_j][_k].TemplateNames = _groupTypes
      end
    end
  end

  for _i = 1, #self.Zones.Sub, 1 do
    generateTemplateNames(self.Zones.Sub[_i], self.Zones.Sub[_i].GroupSettings, self.Zones.Sub[_i].BuiltSpawner)
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypesTemplates() - self.Zones.Sub[_i]")
      BASE:E(self.Zones.Sub[_i])
    end
  end

  generateTemplateNames(self.Zones.Main, self.Zones.Main.GroupSettings, self.Zones.Main.BuiltSpawner)

  if self.DebugEnabled == 1 then
    self.DebugLog.SetGroupTypesTemplates.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypesTemplates() - Time: " .. self.DebugLog.SetGroupTypesTemplates.Time.stop - self.DebugLog.SetGroupTypesTemplates.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - SetGroupTypesTemplates() - self.Zones.Main")
    BASE:E(self.Zones.Main)
  end

  return self
end

--- Determines the coordinates for all generated Types.
--
--      Determines center for each grouping of Types, then
--      determines the placement of each type based on group centers.
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : Returns modified self array. See functions:
--
--       SPECTRE.DYNAMIC_SPAWNER:Set_Vec2_GroupCenters()
--       SPECTRE.DYNAMIC_SPAWNER:Set_Vec2_Types()
function SPECTRE.DYNAMIC_SPAWNER:DetermineCoordinates()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.DetermineCoordinates = {Time = {},}
    self.DebugLog.DetermineCoordinates.Time.start = os.clock()
  end
  -- self:FindObjects()
  self:Set_Vec2_GroupCenters()
  self:Set_Vec2_Types()

  if self.DebugEnabled == 1 then
    self.DebugLog.DetermineCoordinates.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER: DetermineCoordinates - Time: " .. self.DebugLog.DetermineCoordinates.Time.stop - self.DebugLog.DetermineCoordinates.Time.start)
  end
  return self
end

--- ###Generates and activates in game units based on generated dynamic spawner.
--
-- * Spawned units follow naming conventions.
-- * All Type group & unit names are based on the zone they fall in to.
--
--        --- The Dynamic Spawner returns a MOOSE #GROUP Object for each spawned Type.
--        -- May be accessed as any other Moose #GROUP object.
--
--         _spawnunit = SPAWN:New():Spawn()
--
--         self.Zones.Main.BuiltSpawner[_j][_k].ActivatedUnits[_m]    = _spawnunit
--         self.Zones.Sub[_i].BuiltSpawner[_j][_k].ActivatedUnits[_m] = _spawnunit
--
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : self with added table for .ActivatedUnits
--
--        self.Zones.Sub[_i].BuiltSpawner[_j][_k].ActivatedUnits[#] = _spawnunit
--        self.Zones.Main.BuiltSpawner[_j][_k].ActivatedUnits[#] = _spawnunit
-- where
--
--        _i = Number of the self.Zone.Sub table
--        _j = # main group self.Sub[_i].GroupSettings or #self.Main.GroupSettings
--        _k = # sub group in self.Sub[_i].GroupSettings.NumberGroups or #self.Main.GroupSettings.NumberGroups
--        _spawnunit = SPAWN:NewWithAlias(template_, name_ .. "_" .. self.Zones.Sub[_i].TypeCounter)
--                          :InitHeading(0,364)
--                          :SpawnFromVec2(vec2_)
--                     or
--                     SPAWN:NewWithAlias(template_, name_ .. "_" .. self.Zones.Main.TypeCounter)
--                          :InitHeading(0,364)
--                          :SpawnFromVec2(vec2_)
-- where
--
--        name_ = self.Zones.Sub[_i].name or self.Zones.Main.name
--        template_ = self.Zones.Sub[_i].BuiltSpawner[_j][_k].TemplateNames[#] or self.Zones.Main.BuiltSpawner[_j][_k].TemplateNames[#]
--        vec2_ = self.Zones.Sub[_i].BuiltSpawner[_j][_k].Vec2Types[#] or self.Zones.Main.BuiltSpawner[_j][_k].Vec2Types[#]
--
function SPECTRE.DYNAMIC_SPAWNER:Spawn()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.Spawn = {Time = {},}
    self.DebugLog.Spawn.Time.start = os.clock()
  end

  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Spawn() - ENTER")
  end

  local function spawnUnits(zone, name, builtSpawner, typeCounter)
    for _j = 1, #zone.GroupSettings, 1 do
      for _k = 1, zone.GroupSettings[_j].NumberGroups, 1 do
        builtSpawner[_j][_k].ActivatedUnits = {}
        for _m = 1, zone.GroupSettings[_j].GroupSize + self.Config.numExtraUnits, 1 do
          local template_ = builtSpawner[_j][_k].TemplateNames[_m]
          local vec2_ = builtSpawner[_j][_k].Vec2Types[_m]
          
          
          
          local tempCode = typeCounter
          local FoundGroup
          repeat
            if self.DebugEnabled == 1 then
              BASE:E("DEBUG : AIRDROP determining if group exists")
              BASE:E("DEBUG : tempCode " .. tempCode)
              BASE:E("DEBUG : groupname " )
              BASE:E(name .. "_" ..  tempCode .. "#001")
            end
            FoundGroup = GROUP:FindByName(name .. "_" .. tempCode .. "#001")
            if self.DebugEnabled == 1 then
              BASE:E("DEBUG : found? ")
              BASE:E(FoundGroup)
            end
            if FoundGroup then
              tempCode = tempCode + 1
            else
              FoundGroup = false
            end
          until (FoundGroup == false)
          typeCounter = tempCode



          local _spawnunit = SPAWN:NewWithAlias(template_, name .. "_" .. typeCounter)
            :InitHeading(0,364)
            :SpawnFromVec2(vec2_)
          builtSpawner[_j][_k].ActivatedUnits[_m] = _spawnunit
          typeCounter = typeCounter + 1
        end
      end
    end
    return typeCounter
  end

  for _i = 1, #self.Zones.Sub, 1 do
    self.Zones.Sub[_i].TypeCounter = SPECTRE.DYNAMIC_SPAWNER.COUNTER
    self.Zones.Sub[_i].TypeCounter = spawnUnits(self.Zones.Sub[_i], self.Zones.Sub[_i].name, self.Zones.Sub[_i].BuiltSpawner, self.Zones.Sub[_i].TypeCounter)
    SPECTRE.DYNAMIC_SPAWNER.COUNTER = self.Zones.Sub[_i].TypeCounter
  end

  self.Zones.Main.TypeCounter = SPECTRE.DYNAMIC_SPAWNER.COUNTER
  self.Zones.Main.TypeCounter = spawnUnits(self.Zones.Main, self.Zones.Main.name, self.Zones.Main.BuiltSpawner, self.Zones.Main.TypeCounter)
  SPECTRE.DYNAMIC_SPAWNER.COUNTER = self.Zones.Main.TypeCounter

  if self.DebugEnabled == 1 then
    self.DebugLog.Spawn.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Spawn() - Time: " .. self.DebugLog.Spawn.Time.stop - self.DebugLog.Spawn.Time.start)
  end

  return self
end

---_framework.
-- ===
--
-- *All Functions associated with the framework of the DYNAMIC_SPAWNER class.*
--
-- ===
--
--      You probably shouldnt use these.
--
--
-- ===
-- @section _framework

--- Yield function for the internally used coroutine.
--
-- Allows the spawner to be run in 'multithreading', preventing interruption of main game state.
--
-- Allows Dynamic Spawner to be run "in background" over time.
--
-- @param #DYNAMIC_SPAWNER self
-- @param limit : The limit on operations before a yield is triggered.
-- @return #DYNAMIC_SPAWNER self
--
--      self with new operation counter value.
--      (Incremented by 1. Reset to 0 if limit is reached and yield is triggered)
function SPECTRE.DYNAMIC_SPAWNER:CO_Yield(limit)
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - CO_Yield")
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - CO_Yield - Co_Counter")
    BASE:E(self.Co_Counter)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - CO_Yield - Limit")
    BASE:E(limit)
  end
  self.Co_Counter = self.Co_Counter + 1
  if self.Co_Counter >= limit then
    self.Co_Counter = 0
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - CO_Yield() - YIELDED")
    end
    self.Co_MultiGenerate.yield()
    --coroutine.yield()
  end
  return self
end

--- Outputs debug information about the DYNAMIC_SPAWNER into the in game messages.
--
-- Displays: General Unit Info, Zone Info, Length of time taken for program stages
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self
function SPECTRE.DYNAMIC_SPAWNER:DebugMessage()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage() ")
    self.DebugLog.DebugMessage = {Time = {},}
    self.DebugLog.DebugMessage.Time.start = os.clock()
  end
  if self.DebugMessages == 1 then

    local report = REPORT:New("SPECTRE|DYNAMIC_SPAWNER - " .. self.Zones.Main.name)
    report:Add("------------------------------------------------------------------------------------------------")
    report:Add(" ")

    ------------ Num Types
    local numTypes = #self.AllTypes
    local numMain = #self.Zones.Main.AllTypes
    local numSubs = 0
    for _i = 1, #self.Zones.Sub, 1 do
      numSubs = numSubs + #self.Zones.Sub[ _i].AllTypes
    end

    --------------Execution Times
    local _trun = 4
    local exe_ConfigParse  = SPECTRE.Utils.trunc((self.DebugLog.ConfigParse.Time.stop - self.DebugLog.ConfigParse.Time.start), _trun) or "nul"
    local exe_WeightZones  = SPECTRE.Utils.trunc((self.DebugLog.WeightZones.Time.stop - self.DebugLog.WeightZones.Time.start), _trun) or "nul"
    local exe_Spawn        = SPECTRE.Utils.trunc((self.DebugLog.Spawn.Time.stop       - self.DebugLog.Spawn.Time.start), _trun) or "nul"
    local exe_GroupCenters = SPECTRE.Utils.trunc((self.DebugLog.Set_Vec2_GroupCenters.Time.stop - self.DebugLog.Set_Vec2_GroupCenters.Time.start), _trun) or "nul"
    local exe_Types        = SPECTRE.Utils.trunc((self.DebugLog.Set_Vec2_Types.Time.stop        - self.DebugLog.Set_Vec2_Types.Time.start), _trun) or "nul"
    local exe_Generation   = SPECTRE.Utils.trunc((self.DebugLog.GenerationProcess.Time.stop     - self.DebugLog.GenerationProcess.Time.start), _trun) or "nul"

    report:Add("Total Types Spawned: " .. numTypes .. " | Main Zone: " .. numMain .. " | Sub Zones: " .. numSubs)
    report:Add(" ")
    report:Add("Total  Run  Time   : " .. exe_Generation .."s")
    report:Add(" ")
    report:Add("Execution Times |=================================================")
    report:Add(" ")
    report:Add("Config: " .. exe_ConfigParse .. "s " .. " | Zones: " .. exe_WeightZones .. "s | Groups: " .. exe_GroupCenters .. "s | Spawn: " .. exe_Spawn .. "s")
    report:Add("Other: " .. math.abs(exe_Generation - (exe_ConfigParse+exe_WeightZones+exe_Spawn+exe_GroupCenters+exe_Types))  .. "s ")
    report:Add("Types: " .. exe_Types .. "s")
    report:Add(" ")
    -------------Types


    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - AllTypesMain ")
      BASE:E(self.Zones.Main.AllTypes)
      for _i = 1, #self.Zones.Sub, 1 do
        BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - AllTypes sub " .. _i)
        BASE:E(self.Zones.Sub[_i].AllTypes)
      end
    end

    report:Add("================================= Types Spawned | Overall: ")
    local countMerged = SPECTRE.Utils.CountValues(self.AllTypes)
    for _k,_v in pairs(countMerged) do
      report:AddIndent(_k .. " : " .. _v, "-")
    end
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - self.AllTypes ")
      BASE:E(self.AllTypes)
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - self.AllTypes counts ")
      BASE:E(countMerged)
    end

    if self.DebugSummaryOnly == false or self.DebugSummaryOnly == nil then

      report:Add(" ")
      report:Add("================================= Types Spawned | Main Zone: " .. self.Zones.Main.name)
      local countMain = SPECTRE.Utils.CountValues(self.Zones.Main.AllTypes)
      for _k,_v in pairs(countMain) do
        report:AddIndent(_k .. " : " .. _v, "-")
      end
      if self.DebugEnabled == 1 then
        BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - result main")
        BASE:E(countMain)
      end


      for _i = 1, #self.Zones.Sub, 1 do
        report:Add(" ")
        report:Add("================================= Types Spawned | Sub Zones: " .. self.Zones.Sub[_i].name)
        local countSub = SPECTRE.Utils.CountValues(self.Zones.Sub[_i].AllTypes)
        for _k,_v in pairs(countSub) do
          report:AddIndent(_k .. " : " .. _v, "-")
        end
        if self.DebugEnabled == 1 then
          BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage - result sub " .. _i)
          BASE:E(countSub)
        end
      end

    end

    if self.DebugEnabled == 1 then
      local out = report:Text()
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - DebugMessage() - report:Text()")
      BASE:E(out)
    end

    trigger.action.outText(report:Text(),20, false)
  end
  if self.DebugEnabled == 1 then
    self.DebugLog.DebugMessage.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER: DebugMessage - Time: " .. self.DebugLog.DebugMessage.Time.stop - self.DebugLog.DebugMessage.Time.start)
  end
  return self
end

---Generates and activates the SPECTRE.DYNAMIC_SPAWNER based on provided configs/settings.
--
-- Runs through:
--
--         self:ConfigParse()
--         self:WeightZones()
--         self:SetNumTypesPerZone()
--         self:SetGroupsPerZone()
--         self:SetGroupTypes()
--         self:SetGroupTypesTemplates()
--         self:DetermineCoordinates()
--         self:Spawn()
-- @param #DYNAMIC_SPAWNER self : the SPECTRE.DYNAMIC_SPAWNER OBJECT
-- @return #DYNAMIC_SPAWNER self : self with tables added from the following operations:
--
--         SPECTRE.DYNAMIC_SPAWNER:ConfigParse()
--         SPECTRE.DYNAMIC_SPAWNER:WeightZones()
--         SPECTRE.DYNAMIC_SPAWNER:SetNumTypesPerZone()
--         SPECTRE.DYNAMIC_SPAWNER:SetGroupsPerZone()
--         SPECTRE.DYNAMIC_SPAWNER:SetGroupTypes()
--         SPECTRE.DYNAMIC_SPAWNER:SetGroupTypesTemplates()
--         SPECTRE.DYNAMIC_SPAWNER:DetermineCoordinates()
--         SPECTRE.DYNAMIC_SPAWNER:Spawn()
--
--         See specific above function for more details.
function SPECTRE.DYNAMIC_SPAWNER.GenerationProcess(self)
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.GenerationProcess = {Time = {},}
    self.DebugLog.GenerationProcess.Time.start = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - GenerationProcess() - start time")
    BASE:E(self.DebugLog.GenerationProcess.Time.start)
  end
  self:ConfigParse()
  self:WeightZones()
  self:SetNumTypesPerZone()
  self:SetGroupsPerZone()
  self:SetGroupTypes()
  self:SetGroupTypesTemplates()
  self:DetermineCoordinates()
  self:Spawn()

  if self.DebugEnabled == 1 then
    self.DebugLog.GenerationProcess.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - GenerationProcess() - Time: " ..  self.DebugLog.GenerationProcess.Time.stop - self.DebugLog.GenerationProcess.Time.start)
    --self:DEBUG_PRINT_self()
  end
  if self.DebugMessages == 1 then
    self:DebugMessage()
  end
  return self
end

--- Determines the Vec2 for the center of each generated group in every zone.
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : self with added tables for .ObjectCoords.groupcenters and .GroupCenterVec2
--
--           self.Zones.Sub[_i].BuiltSpawner[_j][_k].GroupCenterVec2 = possibleVec2
--           self.Zones.Sub[_i].ObjectCoords.groupcenters[#] = possibleVec2
--           self.Zones.Main.ObjectCoords.groupcenters[#] = possibleVec2
--           self.Zones.Main.BuiltSpawner[_j][_k].GroupCenterVec2 = possibleVec2
-- where
--
--       _i = Number of the self.Zone.Sub table
--       _j = # main group self.Sub[_i].GroupSettings or #self.Main.GroupSettings
--       _k = # sub group in self.Sub[_i].GroupSettings.NumberGroups or #self.Main.GroupSettings.NumberGroups
--       possibleVec2 = {x = #, y = #,}
function SPECTRE.DYNAMIC_SPAWNER:Set_Vec2_GroupCenters()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Set_Vec2_GroupCenters - Enter")
    self.DebugLog.Set_Vec2_GroupCenters = {Time = {},}
    self.DebugLog.Set_Vec2_GroupCenters.Time.start = os.clock()
  end
  self.Zones.Main.ObjectCoords = { groupcenters = {} }

  for i = 1, #self.Zones.Sub do
    local subZone = self.Zones.Sub[i]
    subZone.ObjectCoords = { groupcenters = {} }

    for j = 1, #subZone.GroupSettings do
      local groupSettings = subZone.GroupSettings[j]
      local numGroups = groupSettings.NumberGroups

      for k = 1, numGroups do
        local possibleVec2
        local flag_goodcoord = false

        repeat
          flag_goodcoord = true

          possibleVec2 = subZone.zone:GetRandomVec2()

          if not self:vec2AtNoGoSurface(possibleVec2) then
            flag_goodcoord = self:CheckVec2_NoGoZones(possibleVec2, self.Zones.Restricted)
          end

          if flag_goodcoord then
            for _, coords in pairs(subZone.ObjectCoords) do
              local distance

              if coords == "units" then
                distance = groupSettings.minSeperation
              elseif coords == "groupcenters" then
                distance = groupSettings.minSeparation_Groups
              else
                distance = subZone.DistanceFromBuildings
              end

              if coords == "groupcenters" then
                for _, checkCoord in ipairs(subZone.ObjectCoords[coords]) do
                  if SPECTRE.WORLD.f_distance(checkCoord, possibleVec2) < distance then
                    flag_goodcoord = false
                    break
                  end
                end
              end

              if not flag_goodcoord then
                break
              end
            end
          end
        until flag_goodcoord

        subZone.BuiltSpawner[j][k].GroupCenterVec2 = possibleVec2
        subZone.ObjectCoords.groupcenters[#subZone.ObjectCoords.groupcenters + 1] = possibleVec2
        self.Zones.Main.ObjectCoords.groupcenters[#self.Zones.Main.ObjectCoords.groupcenters + 1] = possibleVec2
      end
    end
  end

  for j = 1, #self.Zones.Main.GroupSettings do
    local groupSettings = self.Zones.Main.GroupSettings[j]
    local numGroups = groupSettings.NumberGroups

    for k = 1, numGroups do
      local possibleVec2
      local flag_goodcoord = false

      repeat
        flag_goodcoord = true

        possibleVec2 = self.Zones.Main.zone:GetRandomVec2()

        if not self:vec2AtNoGoSurface(possibleVec2) then
          flag_goodcoord = self:CheckVec2_NoGoZones(possibleVec2, self.Zones.Restricted)
        end

        if flag_goodcoord then
          for _, coords in pairs(self.Zones.Main.ObjectCoords) do
            local distance

            if coords == "units" then
              distance = groupSettings.minSeperation
            elseif coords == "groupcenters" then
              distance = groupSettings.minSeparation_Groups
            else
              distance = self.Zones.Main.DistanceFromBuildings
            end

            if coords == "groupcenters" then
              for _, checkCoord in ipairs(self.Zones.Main.ObjectCoords[coords]) do
                if SPECTRE.WORLD.f_distance(checkCoord, possibleVec2) < distance then
                  flag_goodcoord = false
                  break
                end
              end
            end

            if not flag_goodcoord then
              break
            end
          end
        end
      until flag_goodcoord

      self.Zones.Main.BuiltSpawner[j][k].GroupCenterVec2 = possibleVec2
      self.Zones.Main.ObjectCoords.groupcenters[#self.Zones.Main.ObjectCoords.groupcenters + 1] = possibleVec2
    end
  end
  if self.DebugEnabled == 1 then
    self.DebugLog.Set_Vec2_GroupCenters.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER: Set_Vec2_GroupCenters - Time: " .. self.DebugLog.Set_Vec2_GroupCenters.Time.stop - self.DebugLog.Set_Vec2_GroupCenters.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Set_Vec2_GroupCenters() - self.Zones.Main.BuiltSpawner")
    BASE:E(self.Zones.Main.BuiltSpawner)
  end
  return self
end

--- Determines the Vec2 for each of the Types of each generated group in every zone.
--
-- Creates a subzone around the group center and places all types within.
--
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : self with added tables for .zone, .ObjectCoords, .Vec2Types
--
--        self.Zones.Sub[_i].BuiltSpawner[_j][_k].zone = ZONE_RADIUS:New(tempZoneName,tempZoneVec2,tempZoneRadius)
--        self.Zones.Sub[_i].BuiltSpawner[_j][_k].ObjectCoords = SPECTRE.DYNAMIC_SPAWNER.FindObjectsInZone(self.Zones.Sub[_i].BuiltSpawner[_j][_k].zone)
--        self.Zones.Sub[_i].BuiltSpawner[_j][_k].Vec2Types[#] = possibleVec2
--           and
--        self.Zones.Main.BuiltSpawner[_j][_k].zone = ZONE_RADIUS:New(tempZoneName,tempZoneVec2,tempZoneRadius)
--        self.Zones.Main.BuiltSpawner[_j][_k].ObjectCoords = SPECTRE.DYNAMIC_SPAWNER.FindObjectsInZone(self.Zones.Main.BuiltSpawner[_j][_k].zone)
--        self.Zones.Main.BuiltSpawner[_j][_k].Vec2Types[#] = possibleVec2
-- where
--
--       _i = Number of the self.Zone.Sub table
--       _j = # main group self.Sub[_i].GroupSettings or #self.Main.GroupSettings
--       _k = # sub group in self.Sub[_i].GroupSettings.NumberGroups or #self.Main.GroupSettings.NumberGroups
--       tempZoneName = self.Zones.Sub[_i].name .. "z".. _i .. "j" .. _j .. "k" .. _k
--                         or
--                      self.Zones.Main.name .. "j" .. _j .. "k" .. _k
--       tempZoneVec2 = self.Zones.Sub[_i].BuiltSpawner[_j][_k].GroupCenterVec2
--                         or
--                      self.Zones.Main.BuiltSpawner[_j][_k].GroupCenterVec2
--       tempZoneRadius = (_distanceFromUnits * _groupSize) + (_distanceFromGroups * _numGroup ) + _distanceFromBuildings
--       possibleVec2 = {x = #, y = #,}
function SPECTRE.DYNAMIC_SPAWNER:Set_Vec2_Types()
 -- local DEBUG = false or self.DebugEnabled
  if self.DebugEnabled == 1 then
    self.DebugLog.Set_Vec2_Types = {Time = {},}
    self.DebugLog.Set_Vec2_Types.Time.start = os.clock()
  end
  --local counter_operation = 0
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Set_Vec2_Types() - ENTER")
  end

  local function generateVec2Types(zone, groupSettings, distanceFromBuildings)
    local vec2Types = {}
    local objectCoords = SPECTRE.DYNAMIC_SPAWNER.FindObjectsInZone(zone)
    local groupSize = groupSettings.GroupSize
    local numGroups = groupSettings.NumberGroups
    local distanceFromUnits = groupSettings.maxSeperation
    local distanceFromGroups = groupSettings.minSeparation_Groups

    for typeNum = 1, groupSize + self.Config.numExtraUnits do
      local possibleVec2
      local flag_goodcoord = false

      repeat
        flag_goodcoord = true
        possibleVec2 = zone:GetRandomVec2()

        for _, coords in pairs(objectCoords) do
          local distance = coords == "units" and groupSettings.minSeperation or distanceFromBuildings

          for _, checkCoord in ipairs(coords) do
            if SPECTRE.WORLD.f_distance(checkCoord, possibleVec2) < distance then
              flag_goodcoord = false
              break
            end
          end

          if not flag_goodcoord then
            break
          end
        end
      until flag_goodcoord

      vec2Types[typeNum] = possibleVec2
      objectCoords.units[#objectCoords.units + 1] = possibleVec2
    end

    return vec2Types, objectCoords
  end

  for i = 1, #self.Zones.Sub do
    local subZone = self.Zones.Sub[i]

    for j = 1, #subZone.GroupSettings do
      local groupSettings = subZone.GroupSettings[j]

      for k = 1, groupSettings.NumberGroups do
        local builtSpawner = subZone.BuiltSpawner[j][k]
        local tempZoneName = subZone.name .. "z" .. i .. "j" .. j .. "k" .. k
        local tempZoneVec2 = builtSpawner.GroupCenterVec2
        local tempZoneRadius = (groupSettings.maxSeperation * groupSettings.GroupSize) +
          (groupSettings.minSeparation_Groups * groupSettings.NumberGroups) +
          subZone.DistanceFromBuildings

        builtSpawner.zone = ZONE_RADIUS:New(tempZoneName, tempZoneVec2, tempZoneRadius)
        builtSpawner.Vec2Types, builtSpawner.ObjectCoords = generateVec2Types(builtSpawner.zone, groupSettings, subZone.DistanceFromBuildings)
      end
    end
  end

  for j = 1, #self.Zones.Main.GroupSettings do
    local groupSettings = self.Zones.Main.GroupSettings[j]

    for k = 1, groupSettings.NumberGroups do
      local builtSpawner = self.Zones.Main.BuiltSpawner[j][k]
      local tempZoneName = self.Zones.Main.name .. "j" .. j .. "k" .. k
      local tempZoneVec2 = builtSpawner.GroupCenterVec2
      local tempZoneRadius = (groupSettings.maxSeperation * groupSettings.GroupSize) +
        (groupSettings.minSeparation_Groups * groupSettings.NumberGroups) +
        self.Zones.Main.DistanceFromBuildings

      builtSpawner.zone = ZONE_RADIUS:New(tempZoneName, tempZoneVec2, tempZoneRadius)
      builtSpawner.Vec2Types, builtSpawner.ObjectCoords = generateVec2Types(builtSpawner.zone, groupSettings, self.Zones.Main.DistanceFromBuildings)
    end
  end
  if self.DebugEnabled == 1 then
    self.DebugLog.Set_Vec2_Types.Time.stop = os.clock()
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Set_Vec2_Types() - Time: " .. self.DebugLog.Set_Vec2_Types.Time.stop - self.DebugLog.Set_Vec2_Types.Time.start)
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - Set_Vec2_Types() - self.Zones.Main.BuiltSpawner")
    BASE:E(self.Zones.Main.BuiltSpawner)
  end
  return self
end

--- Find all Object entities in all spawner related main and sub zones.
--
-- Finds the following, then adds them to a table for tracking:
--
--       Object.Category.SCENERY
--       Object.Category.STATIC
--       Object.Category.UNIT
--       Unit.Category.GROUND_UNIT
--       Unit.Category.STRUCTURE
--       Unit.Category.SHIP
-- @param #DYNAMIC_SPAWNER self
-- @return #DYNAMIC_SPAWNER self : self with an added ObjectCoords table of all objects detected in zone.
--
--        self.Zones.Sub[_i].ObjectCoords = ObjectCoords
--        self.Zones.Main.ObjectCoords = ObjectCoords
-- where
--
--        _i = subzone key number in self.Zones.Sub table
--        ObjectCoords = {
--                          building = {DATA},
--                          others   = {DATA},
--                          units    = {DATA},
--                       }
function SPECTRE.DYNAMIC_SPAWNER:FindObjects()
  local function processObjects(zone)
    local ObjectCoords = {
      buildings = {},
      others = {},
      units = {}
    }
    local objects = zone.ScanData and zone.ScanData.Scenery or {}
    local units = zone.ScanData and zone.ScanData.Units or {}
    local sceneryTable = zone.ScanData and zone.ScanData.SceneryTable or {}

    for _, _object in pairs(objects) do
      for _, _scen in pairs(_object) do
        local scenery = _scen
        local description = scenery:GetDesc()
        if description and description.attributes and description.attributes.Buildings then
          ObjectCoords.buildings[#ObjectCoords.buildings + 1] = { x = scenery:GetCoordinate().x, y = scenery:GetCoordinate().z }
        else
          ObjectCoords.others[#ObjectCoords.others + 1] = { x = scenery.SceneryObject:getPosition().p.x, y = scenery.SceneryObject:getPosition().p.z }
        end
      end
    end

    for _, _object in pairs(units) do
      local unitPosition = UNIT:FindByName(_object:getName()):GetPosition()
      ObjectCoords.units[#ObjectCoords.units + 1] = { x = unitPosition.p.x, y = unitPosition.p.z }
    end

    for _, sceneryObject in ipairs(sceneryTable) do
      ObjectCoords.others[#ObjectCoords.others + 1] = { x = sceneryObject.SceneryObject:getPosition().p.x, y = sceneryObject.SceneryObject:getPosition().p.z }
    end

    return ObjectCoords
  end

  for i = 1, #self.Zones.Sub do
    self.Zones.Sub[i].ObjectCoords = processObjects(self.Zones.Sub[i].zone)
  end

  self.Zones.Main.ObjectCoords = processObjects(self.Zones.Main.zone)

  return self
end

--- Find all Object entities in provided ZONE_RADIUS object.
--
-- Finds the following, then adds them to a table for tracking:
--
--       Object.Category.SCENERY
--       Object.Category.STATIC
--       Object.Category.UNIT
--       Unit.Category.GROUND_UNIT
--       Unit.Category.STRUCTURE
--       Unit.Category.SHIP
-- @param _zone: ZONE_RADIUS object to scan for objects.
-- @return ObjectCoords : table of all objects detected in zone.
--
--        ObjectCoords = {
--                          building = {DATA},
--                          others   = {DATA},
--                          units    = {DATA},
--                       }
--
function SPECTRE.DYNAMIC_SPAWNER.FindObjectsInZone(_zone)
  local ObjectCoords = {
    buildings = {},
    others = {},
    units = {}
  }

  _zone:Scan({Object.Category.SCENERY, Object.Category.STATIC, Object.Category.UNIT}, {Unit.Category.GROUND_UNIT, Unit.Category.STRUCTURE, Unit.Category.SHIP})

  local scanData = _zone.ScanData
  if scanData then
    -- Scenery and Static objects
    if scanData.Scenery then
      for _, sceneryList in pairs(scanData.Scenery) do
        for _, scenery in pairs(sceneryList) do
          local description = scenery:GetDesc()
          if description and description.attributes and description.attributes.Buildings then
            ObjectCoords.buildings[#ObjectCoords.buildings + 1] = {x = scenery:GetCoordinate().x, y = scenery:GetCoordinate().z}
          else
            ObjectCoords.others[#ObjectCoords.others + 1] = {x = scenery.SceneryObject:getPosition().p.x, y = scenery.SceneryObject:getPosition().p.z}
          end
        end
      end
    end

    -- Units
    if scanData.Units then
      for _, unit in pairs(scanData.Units) do
        ObjectCoords.units[#ObjectCoords.units + 1] = {x = UNIT:FindByName(unit:getName()):GetPosition().p.x, y = UNIT:FindByName(unit:getName()):GetPosition().p.z}
      end
    end

    -- Scenery Table
    if scanData.SceneryTable then
      for _, scenery in ipairs(scanData.SceneryTable) do
        ObjectCoords.others[#ObjectCoords.others + 1] = {x = scenery.SceneryObject:getPosition().p.x, y = scenery.SceneryObject:getPosition().p.z}
      end
    end
  end

  return ObjectCoords
end

---Checks the surface at a vec2 and compares vs nogo surfaces.
--
-- If surface is nogo, returns true.
--
-- @param #DYNAMIC_SPAWNER self
-- @param vec2 to check surface of
-- @return true vec is a nogo surface
-- @return false vec is not a nogo surface
function SPECTRE.DYNAMIC_SPAWNER:vec2AtNoGoSurface(vec2)
 -- local DEBUG = false or self.DebugEnabled

  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - vec2AtNoGoSurface - ")
  end

  local surfaceType = COORDINATE:NewFromVec2(vec2):GetSurfaceType()

  local Surfaces = {
    LAND = true,
    SHALLOW_WATER = true,
    WATER = true,
    ROAD = true,
    RUNWAY = true,
  }

  surfaceType = Surfaces[surfaceType] and surfaceType or nil



  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|DYNAMIC_SPAWNER - vec2AtNoGoSurface - surfaceType")
    BASE:E(surfaceType)
  end
  if surfaceType == nil then return true end
  for _, noGoSurface in ipairs(self.NoGoSurface) do
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|DYNAMIC_SPAWNER - vec2AtNoGoSurface - noGoSurface")
      BASE:E(noGoSurface)
    end
    if noGoSurface == surfaceType then
      return true
    end
  end

  return false
end

--- Determines if vec2 is in the zone.
--
-- Multithreaded version of what is available in the SPECTRE.WORLD class.
--
-- Requires quadpoint zone, defined in ME.
-- @param #DYNAMIC_SPAWNER self
-- @param vec2 : Vec2 to check, {x = , y = }
-- @param zoneName : Name of quadpoint zone, defined in Mission Editor.
-- @return result : true or false
function SPECTRE.DYNAMIC_SPAWNER:PointInZone(vec2, zoneName)
  if self.DebugEnabled == 1 then
    BASE:E("DEBUG - PointInZone - zoneName")
    BASE:E(zoneName)
  end
  local _zone = mist.DBs.zonesByName[zoneName]
  if self.DebugEnabled == 1 then
    BASE:E("DEBUG - PointInZone - _zone")
    BASE:E(_zone)
  end
  local box =  _zone.verticies
  local _vec2 = {}
  if vec2.x == nil then
    _vec2.x = vec2[1]
    _vec2.y = vec2[2]
  else
    _vec2 = vec2
  end
  if self.DebugEnabled == 1 then
    BASE:E("DEBUG - PointInZone - vec2")
    BASE:E(vec2)
    BASE:E("DEBUG - PointInZone - _vec2")
    BASE:E(_vec2)
    BASE:E("DEBUG - PointInZone - bo2x")
    BASE:E(box)
  end
  -- self:CO_Yield(self.Config.operationLimit)
  local result = self:PointWithinShape(_vec2, box)--SPECTRE.POLY.PointWithinShape(_vec2, box)
  if self.DebugEnabled == 1 then
    BASE:E("SPECTRE|WORLD - PointInZone - result")
    BASE:E(result)
  end
  return result
end

--- Determines if vec2 is in a list of zones.
--
-- Multithreaded version of what is available in the SPECTRE.WORLD class.
--
-- Requires quadpoint zones, defined in ME.
-- @param #DYNAMIC_SPAWNER self
-- @param vec2 : Vec2 to check, {x = , y = }
-- @param zoneList : List of Names of quadpoint zone, defined in Mission Editor.
--
--        zoneList = {"name1","name2",...,n,}
-- @return 1 = not in zones
-- @return 0 = Vec2 is in Nogo zones
function SPECTRE.DYNAMIC_SPAWNER:CheckVec2_NoGoZones(possibleVec2,zoneList)
  if self.DebugEnabled == 1 then
    BASE:E("DEBUG - CheckVec2_NoGoZones - zoneNameList")
    BASE:E(zoneList)
    BASE:E("DEBUG - CheckVec2_NoGoZones - vec2")
    BASE:E(possibleVec2)
  end
  local result
  for _v = 1, #zoneList, 1 do
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|WORLD - CheckVec2_NoGoZones - vec2")
      BASE:E(possibleVec2)
      BASE:E("SPECTRE|WORLD - CheckVec2_NoGoZones - zoneNameList[_v]")
      BASE:E(zoneList[_v])
    end
    result = self:PointInZone(possibleVec2, zoneList[_v])--SPECTRE.DYNAMIC_SPAWNER.PointInZone(possibleVec2, zoneList[_v])
    if self.DebugEnabled == 1 then
      BASE:E("SPECTRE|WORLD - CheckVec2_NoGoZones - result")
      BASE:E(result)
    end
    if result then
      return 0
    end
  end
  return 1
end



---DYNAMIC_SPAWNER.PointWithinShape.
-- ===
-- Checks if point is within shape.
--
-- Multithreaded version of what is available in SPECTRE.WORLD
--
-- ===
-- @section DYNAMIC_SPAWNER.PointWithinShape


---PointWithinShape.
--
--       1. Draw a horizontal line to the right of each point and extend it to infinity.
--       2. Count the number of times the line intersects with polygon edges.
--       3. A point is inside the polygon if either count of intersections is odd or point lies on an edge of polygon.
--       4. If none of the conditions is true, then point lies outside.
-- @param #DYNAMIC_SPAWNER self
-- @param P The vec2 to test whether inside polygon or not.
--
--           P = {x=#,y=#}
-- @param Polygon Polygon to test P against. Table of Vec2 points. #Polygon must be >= 4
--
--        Polygon = {
--                    [1] = {x = #, y = #},
--                    [...] = {x = #, y = #},
--                    [n] = {x = #, y = #},
-- @return true
-- @return false
function SPECTRE.DYNAMIC_SPAWNER:PointWithinShape(point, polygon)
  if self.DebugEnabled == 1 then
    BASE:E("DEBUG - PointWithinShape - 1")
  end
  local i, j = #polygon, 1
  local oddNodes = false
  for i = 1, #polygon do
    if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
      if (polygon[i].x + (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
        oddNodes = not oddNodes
      end
    end
    j = i
  end
  return oddNodes
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.FileIO** 
--
-- File Input/Output operations for tracking game data.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.FileIO}
-- ===
--
--  ***FileIO for SPECTRE.***
--
--   * The FileIO Class.
--
--   * All aspects of the FileIO are accessed via this class.
--
--     -- Send table Data from DCS -> text file.
--     -- Import table Data from text file -> DCS
--     -- Store and retrieve various aspects of SPECTRE.
--
-- ===
--
--
-- @module FileIO
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - File IO *** ")

---FileIO.
-- ===
-- 
-- *File Input/Output operations for tracking game data.*
--
-- ===
-- @section FileIO

--- ###FileIO
-- ===
--
--      File Input/Output operations for tracking game data.
--
-- * FileIO for SPECTRE
--
--   * The FileIO Class.
--
--   * All aspects of the FileIO are accessed via this class.
--
-- @field #FileIO
-- @field ClassName SPECTRE.OBJECT.FileIO
-- @field ClassID The ID number of the class.
SPECTRE.FileIO = {
  ClassName = "FileIO",
  ClassID = 0,
}

---FileIO functions.
-- ===
-- *All Functions associated with the class.*
--
-- ===
-- @section FileIO functions

---Access and store info from GetGroundResourceData from PlayerManagerMod.
--
-- REQUIRES PLAYERMANAGERMOD
-- 
-- @param GroundDataTable : GetGroundResourceData from PlayerManagerMod
-- @return LoadedDatabase : Table of GetGroundResourceData
function SPECTRE.FileIO.StoreGroundResourceData(GroundDataTable)
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "GroundResources.lua"
  SPECTRE.FileIO.persistence.store(PlayerDatabase_File, GroundDataTable)
end

--- Checks if a specific file exists.
-- 
-- @param filePath : The filepath for the file, PATH + FILE.extension
-- @return true : File does indeed exist
-- @return false : File does not exist :(
function SPECTRE.FileIO.file_exists(filePath)
  local file = io.open(filePath, "r")
  if (file) then
    io.close(file)
    return true
  else
    return false
  end
end

do
  local write, writeIndent, writers, refCount;
  ---FileIO.persistence.
  -- ===
  -- 
  -- *Stores persistence generation functions.*
  -- 
  -- ===
  -- @section persistence

  --- ###Houses methods for interacting with files outside of the game.
  -- ===
  -- 
  --     -Exports table of data from MissionScripting environment to text file
  --     -Imports table of data from text file to MissionScripting environment
  --     -Dumps table to string format
  -- @field #persistence
  SPECTRE.FileIO.persistence = {}

  ---Convert table to string to output to console.
  --@param o : table
  --@return o : String version of table
  function SPECTRE.FileIO.persistence.dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. SPECTRE.FileIO.persistence.dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end
  ---Store table output to file.
  --
  --@param path : filepath
  --@param ... : data
  function SPECTRE.FileIO.persistence.store (path, ...)
    local file, e = io.open(path, "w");
    if not file then
      return error(e);
    end
    local n = select("#", ...);
    -- Count references
    local objRefCount = {}; -- Stores reference that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)));
    end;
    -- Export Objects with more than one ref and assign name
    -- First, create empty tables for each
    local objRefNames = {};
    local objRefIdx = 0;
    file:write("-- Persistent Data\n");
    file:write("local multiRefObjects = {\n");
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1;
        objRefNames[obj] = objRefIdx;
        file:write("{};"); -- table objRefIdx
      end;
    end;
    file:write("\n} -- multiRefObjects\n");
    -- Then fill them (this requires all empty multiRefObjects to exist)
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        file:write("multiRefObjects["..idx.."][");
        write(file, k, 0, objRefNames);
        file:write("] = ");
        write(file, v, 0, objRefNames);
        file:write(";\n");
      end;
    end;
    -- Create the remaining objects
    for i = 1, n do
      file:write("local ".."obj"..i.." = ");
      write(file, (select(i,...)), 0, objRefNames);
      file:write("\n");
    end
    -- Return them
    if n > 0 then
      file:write("return obj1");
      for i = 2, n do
        file:write(" ,obj"..i);
      end;
      file:write("\n");
    else
      file:write("return\n");
    end;
    if type(path) == "string" then
      file:close();
    end;
  end;
  ---Load table data from file to table.
  --@param path : filepath
  function SPECTRE.FileIO.persistence.load (path)
    local f, e;
    if type(path) == "string" then
      f, e = loadfile(path);
    else
      f, e = path:read('*a')
    end
    if f then
      return f();
    else
      return nil, e;
    end;
  end;
  
  -- Private methods
  -- write thing (dispatcher)
  write = function (file, item, level, objRefNames)
    writers[type(item)](file, item, level, objRefNames);
  end;

  -- write indent
  writeIndent = function (file, level)
    for i = 1, level do
      file:write("\t");
    end;
  end;

  -- recursively count references
  refCount = function (objRefCount, item)
    -- only count reference types (tables)
    if type(item) == "table" then
      -- Increase ref count
      if objRefCount[item] then
        objRefCount[item] = objRefCount[item] + 1;
      else
        objRefCount[item] = 1;
        -- If first encounter, traverse
        for k, v in pairs(item) do
          refCount(objRefCount, k);
          refCount(objRefCount, v);
        end;
      end;
    end;
  end;

  -- Format items for the purpose of restoring
  writers = {
    ["nil"] = function (file, item)
      file:write("nil");
    end;
    ["number"] = function (file, item)
      file:write(tostring(item));
    end;
    ["string"] = function (file, item)
      file:write(string.format("%q", item));
    end;
    ["boolean"] = function (file, item)
      if item then
        file:write("true");
      else
        file:write("false");
      end
    end;
    ["table"] = function (file, item, level, objRefNames)
      local refIdx = objRefNames[item];
      if refIdx then
        -- Table with multiple references
        file:write("multiRefObjects["..refIdx.."]");
      else
        -- Single use table
        file:write("{\n");
        for k, v in pairs(item) do
          writeIndent(file, level+1);
          file:write("[");
          write(file, k, level+1, objRefNames);
          file:write("] = ");
          write(file, v, level+1, objRefNames);
          file:write(";\n");
        end
        writeIndent(file, level);
        file:write("}");
      end;
    end;
    ["function"] = function (file, item)
      -- Does only work for "normal" functions, not those
      -- with upvalues or c functions
      local dInfo = debug.getinfo(item, "uS");
      if dInfo.nups > 0 then
        file:write("nil --[[functions with upvalue not supported]]");
      elseif dInfo.what ~= "Lua" then
        file:write("nil --[[non-lua function not supported]]");
      else
        local r, s = pcall(string.dump,item);
        if r then
          file:write(string.format("loadstring(%q)", s));
        else
          file:write("nil --[[function could not be dumped]]");
        end
      end
    end;
    ["thread"] = function (file, item)
      file:write("nil --[[thread]]\n");
    end;
    ["userdata"] = function (file, item)
      file:write("nil --[[userdata]]\n");
    end;
  }
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.OBJECT** 
--
-- SPECTRE OBJECTS.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.OBJECT}
-- ===
--
--  ***OBJECT for SPECTRE.***
--
--   * The OBJECT Class.
--
--   * All aspects of OBJECT are accessed via this class.
--
--     -- Houses ENUMS.
--
-- ===
--
--
-- @module OBJECT
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - OBJECT *** ")


---OBJECT.
--
-- ===
-- *Different OBJECT types that SPECTRE uses.*
--
-- ===
-- @section OBJECT


---###OBJECT
-- 
--      Different OBJECT types that SPECTRE uses.
--
-- @field #OBJECT
-- @param DYNAMIC_SPAWNER #string, "DYNAMIC_SPAWNER"
-- @param AI #string, "AI"
-- @param FileIO #string, "FileIO"
-- @param PLAYER_MANAGER #string, "PLAYER_MANAGER"
-- @param POINT_MANAGER #string, "POINT_MANAGER"
-- @param POLY #string, "POLY"
-- @param Utils #string, "Utils"
-- @param WORLD #string, "WORLD"
SPECTRE.OBJECT = { 
  DYNAMIC_SPAWNER = "DYNAMIC_SPAWNER",
  AI = "AI",
  FileIO = "FileIO",
  PLAYER_MANAGER = "PLAYER_MANAGER",
  POINT_MANAGER = "POINT_MANAGER",
  POLY = "POLY",
  Utils = "Utils",
  WORLD = "WORLD",
}


-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.PLAYER_MANAGER** 
--
-- Player management and tracking operations.
-- 
-- ===
--      @{SPECTRE} ---> @{SPECTRE.PLAYER_MANAGER}
-- ===
--
--  ***PLAYER_MANAGER for SPECTRE.***
--
--   * The PLAYER_MANAGER Class.
--
--   * All aspects of the PLAYER_MANAGER are accessed via this class.
--
--     -- lorum ipsem.
--
-- ===
-- 
-- @module PLAYER_MANAGER
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - PLAYER_MANAGER *** ")
---PLAYER_MANAGER.
--
-- ===
-- 
-- *Player management and tracking operations.*
--
-- ===
-- @section PLAYER_MANAGER

--- ###PLAYER_MANAGER
-- ===
--
--      Player management and tracking operations.
--
-- * PLAYER_MANAGER for SPECTRE
--
--   * The PLAYER_MANAGER Class.
--
--   * All aspects of the PLAYER_MANAGER are accessed via this class.
--
-- @field #PLAYER_MANAGER
-- @field ClassName SPECTRE.OBJECT.PLAYER_MANAGER
-- @field ClassID The ID number of the class.
SPECTRE.PLAYER_MANAGER = {
  ClassName = "PLAYER_MANAGER",
  ClassID = 0, 
}

---PLAYER_MANAGER.Funcs.
-- ===
-- 
-- *All Functions associated with the class.*
--
-- ===
-- @section PLAYER_MANAGER.Funcs

--- Clear perm world markers associated with the player.
-- 
-- @param PlayerName Name of player to clear markers for
-- @param flag Indicates type of markers to clear. 
-- 
--        0 = All,
--        1 = CAP, 
--        2 = Tomahawk, 
--        3 = Bomber, 
--        4 = Airdrop
--        
function SPECTRE.PLAYER_MANAGER.ClearWorldMarkers(PlayerName, flag)

  --cap
  if flag == 1 or flag == 0 then
    for _i = 1, #_G["Player_".. PlayerName].CAP_Markers.MarkerArrays , 1 do
      local markID = _G["Player_".. PlayerName].CAP_Markers.MarkerArrays[_i].PermMarkerID
      trigger.action.removeMark(markID)
    end
  end
  --Tomahawk
  if flag == 2 or flag == 0 then
    for _i = 1, #_G["Player_".. PlayerName].Tomahawk_Markers.MarkerArrays , 1 do
      local markID = _G["Player_".. PlayerName].Tomahawk_Markers.MarkerArrays[_i].PermMarkerID
      trigger.action.removeMark(markID)
    end
  end
  --Bomber
  if flag == 3 or flag == 0 then
    for _i = 1, #_G["Player_".. PlayerName].Bomber_Markers.MarkerArrays , 1 do
      local markID = _G["Player_".. PlayerName].Bomber_Markers.MarkerArrays[_i].PermMarkerID
      trigger.action.removeMark(markID)
    end
  end
  --Airdrop
  if flag == 4 or flag == 0 then
    for _i = 1, #_G["Player_".. PlayerName].Airdrop_Markers.MarkerArrays , 1 do
      local markID = _G["Player_".. PlayerName].Airdrop_Markers.MarkerArrays[_i].PermMarkerID
      trigger.action.removeMark(markID)
    end
  end
  --Strike
  if flag == 5 or flag == 0 then
    for _i = 1, #_G["Player_".. PlayerName].Strike_Markers.MarkerArrays , 1 do
      local markID = _G["Player_".. PlayerName].Strike_Markers.MarkerArrays[_i].PermMarkerID
      trigger.action.removeMark(markID)
    end
  end
end

--- Find closest friendly airfield to the unit.
-- 
-- @param PlayerName Name of the unit
-- @return NearestAirbaseInfo The closest airfield to the player
function SPECTRE.PLAYER_MANAGER.ClosestAirfield(PlayerName)

  local coal = _G["Player_".. PlayerName].Coalition

  if coal == 2 then coal = "blue" end
  if coal == 1 then coal = "red" end
  if coal == 0 then coal = "neutral" end

  local PlayerUnitName = _G["Player_".. PlayerName].UnitName
  local PlayerUnit = UNIT:FindByName(PlayerUnitName)
  local PlayerPosition = PlayerUnit:GetPointVec2()

  local Airfields = SET_AIRBASE:New():FilterCoalitions(coal):FilterOnce()
  local NearestAirbase = Airfields:FindNearestAirbaseFromPointVec2(PlayerPosition)

  local NearestAirbaseInfo = {
    Vec3 = NearestAirbase.parking[1].Vec3,
    Name = NearestAirbase.parking[1].AirbaseName,
  }
  return NearestAirbaseInfo
end


---Access and return info from GetGroundResourceData from PlayerManagerMod.
--
-- REQUIRES PLAYERMANAGERMOD
-- 
-- @return LoadedDatabase : Table of GetGroundResourceData
function SPECTRE.PLAYER_MANAGER.GetGroundResourceData()
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "GroundResources.lua"
  local LoadedDatabase = SPECTRE.FileIO.persistence.load(PlayerDatabase_File)
  return LoadedDatabase
end


---Set up event handlers for already existing airdropped units.
--
-- @param coal coalition to search for units and add event handlers.
--
--       takes "blue", "red", or "neutral"
--       
function SPECTRE.PLAYER_MANAGER.AddEventHandler_ExistingAirdrop(coal)
  local GroundUnitsSet = SET_GROUP:New():FilterCoalitions(coal):FilterCategoryGround():FilterPrefixes({"TANK_Group_","IFV_Group_","ARTILLERY_Group_","AAA_Group_","IRSAM_Group_","RDRSAM_Group_","EWR_Group_","SUPPLY_Group_"}):FilterOnce()
  if GroundUnitsSet ~= nil then
    if coal == "blue" then coal = 2 end
    if coal == "red" then coal = 1 end
    if coal == "neutral" then coal = 0 end
    GroundUnitsSet:ForEachGroup(function(GroupObject)
      local groupname = GroupObject:GetName()
      local descriptor
      if string.find(groupname, "TANK") then descriptor = "TANK" end
      if string.find(groupname, "IFV") then descriptor = "IFV" end
      if string.find(groupname, "ARTILLERY") then descriptor = "ARTILLERY" end
      if string.find(groupname, "AAA") then descriptor = "AAA" end
      if string.find(groupname, "IRSAM") then descriptor = "IRSAM" end
      if string.find(groupname, "RDRSAM") then descriptor = "RDRSAM" end
      if string.find(groupname, "EWR") then descriptor = "EWR" end
      if string.find(groupname, "SUPPLY") then descriptor = "SUPPLY" end
      if coal == 2  and descriptor == "EWR" then
        blueIADS:addEarlyWarningRadar(groupname .. "-01")--:sub(1, -5))
      end
      GroupObject:HandleEvent(EVENTS.Dead)
      local DroppedDead = function(eventData)

        if GroupObject:CountAliveUnits() == 0 then
          MESSAGE:New(descriptor .. " group destroyed! Prepping new assets.", 10, "NOTICE"):ToCoalition( coal )

          local restockTimer=TIMER:New(function()
            if descriptor == "TANK" then
              RESOURCES.Airdrop[1]["_Tank"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_Tank"],"add")
              COUNTERS.RESTOCK.Airdrop.Tank = COUNTERS.RESTOCK.Airdrop.Tank - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_Tank"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "IFV" then
              RESOURCES.Airdrop[1]["_IFV"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_IFV"],"add")
              COUNTERS.RESTOCK.Airdrop.IFV = COUNTERS.RESTOCK.Airdrop.IFV - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_IFV"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "ARTILLERY" then
              RESOURCES.Airdrop[1]["_Artillery"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_Artillery"],"add")
              COUNTERS.RESTOCK.Airdrop.Artillery = COUNTERS.RESTOCK.Airdrop.Artillery - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_Artillery"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "AAA" then
              RESOURCES.Airdrop[1]["_AAA"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_AAA"],"add")
              COUNTERS.RESTOCK.Airdrop.AAA = COUNTERS.RESTOCK.Airdrop.AAA - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_AAA"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "IRSAM" then
              RESOURCES.Airdrop[1]["_SAM_IR"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_SAM_IR"],"add")
              COUNTERS.RESTOCK.Airdrop.SAM_IR = COUNTERS.RESTOCK.Airdrop.SAM_IR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_SAM_IR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "RDRSAM" then
              RESOURCES.Airdrop[1]["_SAM_RDR"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_SAM_RDR"],"add")
              COUNTERS.RESTOCK.Airdrop.SAM_RDR = COUNTERS.RESTOCK.Airdrop.SAM_RDR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_SAM_RDR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "EWR" then
              RESOURCES.Airdrop[1]["_EWR"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_EWR"],"add")
              COUNTERS.RESTOCK.Airdrop.EWR = COUNTERS.RESTOCK.Airdrop.EWR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_EWR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "SUPPLY" then
              RESOURCES.Airdrop[1]["_Supply"] = SPECTRE.Utils.Ticker(RESOURCES.Airdrop[1]["_Supply"],"add")
              COUNTERS.RESTOCK.Airdrop.Supply = COUNTERS.RESTOCK.Airdrop.Supply - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_Supply"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
          end, descriptor)

          if descriptor == "TANK" then
            COUNTERS.RESTOCK.Airdrop.Tank = COUNTERS.RESTOCK.Airdrop.Tank + 1
          end
          if descriptor == "IFV" then
            COUNTERS.RESTOCK.Airdrop.IFV = COUNTERS.RESTOCK.Airdrop.IFV + 1
          end
          if descriptor == "ARTILLERY" then
            COUNTERS.RESTOCK.Airdrop.Artillery = COUNTERS.RESTOCK.Airdrop.Artillery + 1
          end
          if descriptor == "AAA" then
            COUNTERS.RESTOCK.Airdrop.AAA = COUNTERS.RESTOCK.Airdrop.AAA + 1
          end
          if descriptor == "IRSAM" then
            COUNTERS.RESTOCK.Airdrop.SAM_IR = COUNTERS.RESTOCK.Airdrop.SAM_IR + 1
          end
          if descriptor == "RDRSAM" then
            COUNTERS.RESTOCK.Airdrop.SAM_RDR = COUNTERS.RESTOCK.Airdrop.SAM_RDR + 1
          end
          if descriptor == "EWR" then
            COUNTERS.RESTOCK.Airdrop.EWR = COUNTERS.RESTOCK.Airdrop.EWR + 1
          end
          if descriptor == "SUPPLY" then
            COUNTERS.RESTOCK.Airdrop.Supply = COUNTERS.RESTOCK.Airdrop.Supply + 1
          end
          restockTimer:Start(400)

        end
      end
      function GroupObject:OnEventDead(eventData)
        DroppedDead(eventData)
      end
    end)
    GroundUnitsSet = nil
  end
end

---Access and store info from PlayerDatabase from PlayerManagerMod.
--
-- REQUIRES PLAYERMANAGERMOD
-- 
-- @param PlayerName_ The playername to search for
function SPECTRE.PLAYER_MANAGER.StorePlayerData(PlayerName_)
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "PlayerDatabase.lua"
  local LoadedDatabase = SPECTRE.FileIO.persistence.load(PlayerDatabase_File)
  local PlayerUCID_ = _G[ "Player_".. PlayerName_].UCID
  local RedPlayerPoints_ = _G[ "Player_".. PlayerName_].Points.Red or 0
  local BluePlayerPoints_ = _G[ "Player_".. PlayerName_].Points.Blue or 0
  for _i = 1, #LoadedDatabase, 1 do
    if LoadedDatabase[_i]["ucid"] == PlayerUCID_ then
      LoadedDatabase[_i]["pointsred"] = RedPlayerPoints_
      LoadedDatabase[_i]["pointsblue"] = BluePlayerPoints_
      SPECTRE.FileIO.persistence.store(PlayerDatabase_File, LoadedDatabase)
    end
  end
end


---Access and return info from PlayerDatabase from PlayerManagerMod.
--
-- REQUIRES PLAYERMANAGERMOD
-- 
-- @param PlayerName_ The playername to search for
-- @return result : Table of {PlayerUCID\_, PlayerPoints_} for requested player
function SPECTRE.PLAYER_MANAGER.GetPlayerData(PlayerName_)
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "PlayerDatabase.lua"
  local LoadedDatabase = SPECTRE.FileIO.persistence.load(PlayerDatabase_File)
  local PlayerUCID_
  local RedPlayerPoints_
  local BluePlayerPoints_
  local result
  for _i = 1, #LoadedDatabase, 1 do
    if LoadedDatabase[_i]["name"] == PlayerName_ then
      PlayerUCID_ = LoadedDatabase[_i]["ucid"]
      RedPlayerPoints_ = LoadedDatabase[_i]["pointsred"]
      BluePlayerPoints_ = LoadedDatabase[_i]["pointsblue"]
      result = {PlayerUCID_, RedPlayerPoints_ , BluePlayerPoints_}
      return result
    end
  end

end

---Setup Tables for Players in the global environment for tracking + operations.
--
-- If PlayerTable !exist, create; else update unit/group info for table
--
-- Uses PlayerManagerMod database to get UCID + stored points
-- 
-- @param SlotData Returned Event inforation from Player Event, EnterAircraft
function SPECTRE.PLAYER_MANAGER.SetupPlayerTable(SlotData)
  local PlayerName = SlotData.IniPlayerName
  if _G["Player_".. PlayerName] == SNULL then
    local PlayerPersistanceData = SPECTRE.PLAYER_MANAGER.GetPlayerData(PlayerName)
    local PlayerUCID = PlayerPersistanceData[1]
    local PlayerPoints = {Red = PlayerPersistanceData[2], Blue = PlayerPersistanceData[3]}
    _G[ "Player_".. PlayerName] = {}
    _G[ "Player_".. PlayerName].PlayerID_ = SlotData.initiator.id_
    _G[ "Player_".. PlayerName].GroupID_ = SlotData.IniDCSGroup.id_
    _G[ "Player_".. PlayerName].PlayerName = SlotData.IniPlayerName
    _G[ "Player_".. PlayerName].GroupName = SlotData.IniGroupName
    _G[ "Player_".. PlayerName].UnitName = SlotData.IniUnitName
    _G[ "Player_".. PlayerName].UnitType = SlotData.IniTypeName
    _G[ "Player_".. PlayerName].Coalition = SlotData.IniCoalition
    _G[ "Player_".. PlayerName].Points = PlayerPoints
    _G[ "Player_".. PlayerName].UCID = PlayerUCID
    _G[ "Player_".. PlayerName].CAP_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Tomahawk_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Bomber_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Airdrop_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Escort_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Strike_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
  else
    local PlayerPersistanceData = SPECTRE.PLAYER_MANAGER.GetPlayerData(PlayerName)
    local PlayerUCID = PlayerPersistanceData[1]
    local PlayerPoints = {Red = PlayerPersistanceData[2], Blue = PlayerPersistanceData[3]}
    _G[ "Player_".. PlayerName].PlayerID_ = SlotData.initiator.id_
    _G[ "Player_".. PlayerName].GroupID_ = SlotData.IniDCSGroup.id_
    _G[ "Player_".. PlayerName].PlayerName = SlotData.IniPlayerName
    _G[ "Player_".. PlayerName].GroupName = SlotData.IniGroupName
    _G[ "Player_".. PlayerName].UnitName = SlotData.IniUnitName
    _G[ "Player_".. PlayerName].UnitType = SlotData.IniTypeName
    _G[ "Player_".. PlayerName].Coalition = SlotData.IniCoalition
    _G[ "Player_".. PlayerName].Points = PlayerPoints
    _G[ "Player_".. PlayerName].UCID = PlayerUCID
    _G[ "Player_".. PlayerName].CAP_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Tomahawk_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Bomber_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Airdrop_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Escort_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
    _G[ "Player_".. PlayerName].Strike_Markers = {
      MarkerArrays = {},
      MenuArrays = {}
    }
  end
end

--- Limits the maximum amount of marks able to be stored.
-- 
-- Removes oldest marker from map and marker table.
-- 
-- @param type : Type of Marker to Remove 
--
--       Takes: 
--       "CAP_Markers", "Bomber_Markers", "Tomahawk_Markers", "Airdrop_Markers"
--
-- @param PlayerName : PlayerName for operation
-- @param limit : Total amount of markers to allow
function SPECTRE.PLAYER_MANAGER.LimitMaxMarkers(type, PlayerName, limit)
  if type == "CAP_Markers" then
    local CurrentAmountMarkers = #_G["Player_".. PlayerName].CAP_Markers.MarkerArrays
    local AmountToRemove = CurrentAmountMarkers - limit
    if AmountToRemove > 0 then
      for _i = 1, AmountToRemove, 1 do
        trigger.action.removeMark(_G["Player_".. PlayerName].CAP_Markers.MarkerArrays[1].PermMarkerID)
        table.remove(_G["Player_".. PlayerName].CAP_Markers.MarkerArrays,1)
      end
    end
  end
  if type == "Bomber_Markers" then
    local CurrentAmountMarkers = #_G["Player_".. PlayerName].Bomber_Markers.MarkerArrays
    local AmountToRemove = CurrentAmountMarkers - limit
    if AmountToRemove > 0 then
      for _i = 1, AmountToRemove, 1 do
        trigger.action.removeMark(_G["Player_".. PlayerName].Bomber_Markers.MarkerArrays[1].PermMarkerID)
        table.remove(_G["Player_".. PlayerName].Bomber_Markers.MarkerArrays,1)
      end
    end
  end
  if type == "Tomahawk_Markers" then
    local CurrentAmountMarkers = #_G["Player_".. PlayerName].Tomahawk_Markers.MarkerArrays
    local AmountToRemove = CurrentAmountMarkers - limit
    if AmountToRemove > 0 then
      for _i = 1, AmountToRemove, 1 do
        trigger.action.removeMark(_G["Player_".. PlayerName].Tomahawk_Markers.MarkerArrays[1].PermMarkerID)
        table.remove(_G["Player_".. PlayerName].Tomahawk_Markers.MarkerArrays,1)
      end
    end
  end
  if type == "Airdrop_Markers" then
    local CurrentAmountMarkers = #_G["Player_".. PlayerName].Airdrop_Markers.MarkerArrays
    local AmountToRemove = CurrentAmountMarkers - limit
    if AmountToRemove > 0 then
      for _i = 1, AmountToRemove, 1 do
        trigger.action.removeMark(_G["Player_".. PlayerName].Airdrop_Markers.MarkerArrays[1].PermMarkerID)
        table.remove(_G["Player_".. PlayerName].Airdrop_Markers.MarkerArrays,1)
      end
    end
  end
  if type == "Strike_Markers" then
    local CurrentAmountMarkers = #_G["Player_".. PlayerName].Strike_Markers.MarkerArrays
    local AmountToRemove = CurrentAmountMarkers - limit
    if AmountToRemove > 0 then
      for _i = 1, AmountToRemove, 1 do
        trigger.action.removeMark(_G["Player_".. PlayerName].Strike_Markers.MarkerArrays[1].PermMarkerID)
        table.remove(_G["Player_".. PlayerName].Strike_Markers.MarkerArrays,1)
      end
    end
  end
end





-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.POINT_MANAGER** 
--
-- All operations involving points earned/redeemed by a player.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.POINT_MANAGER}
-- ===
--
--  ***POINT_MANAGER for SPECTRE.***
--
--   * The POINT_MANAGER Class.
--
--   * All aspects of the POINT_MANAGER are accessed via this class.
--
--     -- Lorem Ipsum.
--
-- ===
--
--
-- @module POINT_MANAGER
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - POINT_MANAGER *** ")

---POINT_MANAGER.
--
-- ===
-- *All operations involving points earned/redeemed by a player.*
--
-- ===
-- @section POINT_MANAGER

--- ###POINT_MANAGER
-- ===
--
--      All operations involving points earned/redeemed by a player.
--
-- * POINT_MANAGER for SPECTRE
--
--   * The POINT_MANAGER Class.
--
--   * All aspects of the POINT_MANAGER are accessed via this class.
--
-- @field #POINT_MANAGER
-- @field ClassName SPECTRE.OBJECT.POINT_MANAGER
-- @field ClassID The ID number of the class.
SPECTRE.POINT_MANAGER = {
  ClassName = "POINT_MANAGER",
  ClassID = 0,
}

---POINT_MANAGER.Config.
--
-- ===
-- *Settings for a point based redeem system.*
--
-- ===
-- @section POINT_MANAGER.Config

---Settings for a point based redeem system.
--
-- Point cost for redeems + Point Reward for Kills based on type.
-- @field #POINT_MANAGER.Config
SPECTRE.POINT_MANAGER.Config = {
  _PointsPerKill_AA = 10,
  _PointsPerKill_Heli = 4,
  _PointsPerKill_AWACS = 30,
  _PointsPerKill_AG = {
    _General = 2,
    _Buildings = 7,
    _Tanks = 6,
    _APC = 3,
    _IFV = 5,
  },
  _PointsPerKill_SAM = {
    _General = 7,
    _LRSam = 20,
    _MRSam = 15,
    _SRSam = 10,
    _EWR = 50,
  },
  _PointsPerKill_AAA = 8,
  _KillTypes_Air = {
    "Helicopters",
    "Planes",
    "AWACS",
  },
  _KillTypes_Ground = {
    "Buildings",
    "SAM elements",
    "AAA",
    "Tanks",
    "APC",
    "IFV",
    "EWR",
  },
  _KillTypes_SAM = {
    "SR SAM",
    "MR SAM",
    "LR SAM",
  },
  _PointsPerCSAR = 5,
  _PointCost_CAP = 100,
  _PointCost_Bomber = 50,
  _PointCost_Strike = 55,
  _PointCost_Tomahawk = 70,
  _PointCost_Escort = 75,
  _PointCost_Airdrop = {
    _Artillery = 50,
    _IFV = 30,
    _Tank = 50,
    _AAA = 60,
    _SAM_IR = 70,
    _SAM_RDR = 150,
    _EWR = 250,
    _Supply = 30,
  },
}

---POINT_MANAGER.func.
-- ===
-- All Functions associated with the class.
--
-- ===
-- @section POINT_MANAGER.func

--- Disperse Points from kill.
-- @param EventData : Data from event triggering point disperse
function SPECTRE.POINT_MANAGER.DispersePoints(EventData)
  EventData = EventData or nil
  local ShooterName = EventData.IniPlayerName
  local ShooterCoalition = EventData.IniCoalition
  local TargetCoalition = EventData.TgtCoalition
  local TargetType = EventData.TgtTypeName --or nil"MiG-25PD"
  if EventData.TgtUnitName == "No target object for Event ID 28" then
    if DEBUG == 1 then
      BASE:E("DEBUG: mist.DBs.deadObjects[EventData.TgtDCSUnit.id_]")
      BASE:E(mist.DBs.deadObjects[EventData.TgtDCSUnit.id_])
    end
    TargetType = mist.DBs.deadObjects[EventData.TgtDCSUnit.id_].objectData.type
    TargetCoalition = mist.DBs.deadObjects[EventData.TgtDCSUnit.id_].objectData.coalition
    if TargetCoalition == "blue" then TargetCoalition = 2 end
    if TargetCoalition == "red" then TargetCoalition = 1 end
    if TargetCoalition == "neutral" then TargetCoalition = 0 end
    mist.DBs.deadObjects[EventData.TgtDCSUnit.id_] = nil
  end
  if DEBUG == 1 then
    BASE:E("DEBUG: Shooter Name")
    BASE:E(ShooterName)
    BASE:E("DEBUG: TYPE:")
    BASE:E(TargetType)
  end
  local TargetDesc = Unit.getDescByName(TargetType )
  local TargetAttributes = TargetDesc.attributes
  if DEBUG == 1 then
    BASE:E("DEBUG: TargetAttributes")
    BASE:E(TargetAttributes)
  end

  local PointReward = 0
  --AIR CHECK AND DISPERSE
  if SPECTRE.Utils.table_contains(TargetAttributes, "Air") then
    for _i = 1, #SPECTRE.POINT_MANAGER.Config._KillTypes_Air,1 do
      if SPECTRE.Utils.table_contains(TargetAttributes, SPECTRE.POINT_MANAGER.Config._KillTypes_Air[_i]) then
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Air[_i] == "Helicopters" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_Heli then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_Heli end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Air[_i] == "Planes" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AA then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AA end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Air[_i] == "AWACS" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AWACS then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AWACS end
        end
      end
    end
  else
    PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._General
    for _i = 1, #SPECTRE.POINT_MANAGER.Config._KillTypes_Ground,1 do
      if SPECTRE.Utils.table_contains(TargetAttributes, SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i]) then

        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "Buildings" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Buildings then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Buildings end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "AAA" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AAA then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AAA end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "Buildings" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Buildings then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Buildings end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "Tanks" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Tanks then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._Tanks end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "APC" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._APC then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._APC end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "IFV" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._IFV then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_AG._IFV end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "EWR" then
          if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._EWR then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._EWR end
        end
        if   SPECTRE.POINT_MANAGER.Config._KillTypes_Ground[_i] == "SAM elements" then
          PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._General
          for _i = 1, #SPECTRE.POINT_MANAGER.Config._KillTypes_SAM ,1 do
            if SPECTRE.Utils.table_contains(TargetAttributes, SPECTRE.POINT_MANAGER.Config._KillTypes_SAM[_i]) then
              if   SPECTRE.POINT_MANAGER.Config._KillTypes_SAM[_i] == "SR SAM" then
                if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._SRSam then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._SRSam end
              end
              if   SPECTRE.POINT_MANAGER.Config._KillTypes_SAM[_i] == "MR SAM" then
                if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._MRSam then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._MRSam end
              end
              if   SPECTRE.POINT_MANAGER.Config._KillTypes_SAM[_i] == "LR SAM" then
                if PointReward < SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._LRSam then PointReward = SPECTRE.POINT_MANAGER.Config._PointsPerKill_SAM._LRSam end
              end
            end
          end
        end

      end
    end

  end
  

  local oldPoints = 0
  if G["Player_".. ShooterName].Coalition == "RED" then
    oldPoints = G["Player_".. ShooterName].Points.Red
  end
  if G["Player_".. ShooterName].Coalition == "BLUE" then
    oldPoints = G["Player_".. ShooterName].Points.Blue
  end

  if ShooterCoalition ~= TargetCoalition then
    oldPoints = oldPoints + PointReward
  else
    PointReward = math.ceil(PointReward/2)
    oldPoints = oldPoints - PointReward
    if oldPoints < 0 then
    oldPoints = 0
    end
    trigger.action.outTextForGroup( _G["Player_".. ShooterName].GroupID_, "Destroying friendly assets is a court martialable offense! Deducting " .. PointReward .. " points." ,10)
  end
  _G["Player_".. ShooterName].Points = oldPoints
  
end




-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.POLY**
--
-- POLYGON and shape operations.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.POLY}
-- ===
--
--  ***POLY for SPECTRE.***
--
--   * The POLY Class.
--
--   * All aspects of the POLY are accessed via this class.
--
--     -- Lorem Ipsum.
--
-- ===
--
--
-- @module POLY
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - POLY *** ")

---POLY.
--
-- ===
-- *POLYGON and shape operations.*
--
-- ===
-- @section POLY

--- ###POLY
-- ===
--
--      POLYGON and shape operations.
--
-- * POLY for SPECTRE
--
--   * The POLY Class.
--
--   * All aspects of the POLY are accessed via this class.
--
-- @field #POLY
-- @field ClassName SPECTRE.OBJECT.POLY
-- @field ClassID The ID number of the class.
SPECTRE.POLY = {
  ClassName = "POLY",
  ClassID = 0,
}

---POLY.PointWithinShape.
-- ===
-- Checks if point is within shape.
--
-- ===
-- @section POLY.PointWithinShape

---PointWithinShape.
--
--       1. Draw a horizontal line to the right of each point and extend it to infinity.
--       2. Count the number of times the line intersects with polygon edges.
--       3. A point is inside the polygon if either count of intersections is odd or point lies on an edge of polygon.
--       4. If none of the conditions is true, then point lies outside.
-- @param P The vec2 to test whether inside polygon or not.
--
--           P = {x=#,y=#}
-- @param Polygon Polygon to test P against. Table of Vec2 points. #Polygon must be >= 4
--
--        Polygon = {
--                    [1] = {x = #, y = #},
--                    [...] = {x = #, y = #},
--                    [n] = {x = #, y = #},
-- @return true
-- @return false
function SPECTRE.POLY.PointWithinShape(P, Polygon)
  local inside
  inside = SPECTRE.POLY.checkInside(Polygon, P)
  return inside
end

---POLY.PointWithinShape____.
-- ===
-- Child funtions used in @{SPECTRE.POLY.PointWithinShape}.
--
-- - @{SPECTRE.POLY.onLine}
-- - @{SPECTRE.POLY.direction}
-- - @{SPECTRE.POLY.isIntersect}
-- - @{SPECTRE.POLY.checkInside}
--
-- ===
-- @section POLY.PointWithinShape____

---onLine.
--
-- Checks if point is on a line.
-- @param l1 line
--
--       l1 = {
--              p1 = {x = #, y = #},
--              p2 = {x = #, y = #},
--       }
-- @param p point
--
--       p = {x = #, y = #}
-- @return true
-- @return false
function SPECTRE.POLY.onLine(l1, p)
  -- Check whether p is on the line or not
  if (p.x <= math.max(l1.p1.x, l1.p2.x)
    and p.x <= math.min(l1.p1.x, l1.p2.x)
    and (p.y <= math.max(l1.p1.y, l1.p2.y)
    and p.y <= math.min(l1.p1.y, l1.p2.y)
    )) then
    return true
  end
  return false
end

---direction.
--
-- Checks if point is on a line.
-- @param a point, a = {x=#,y=#}
-- @param b point, b = {x=#,y=#}
-- @param c point, c = {x=#,y=#}
-- @return 0 Colinear
-- @return 1 Clockwise direction
-- @return 2 Anti-clockwise direction
function SPECTRE.POLY.direction(a, b, c)
  local _1 = (b.y - a.y)
  local _2 = (c.x - b.x)
  local _3 = (b.x - a.x)
  local _4 = (c.y - b.y)
  local val = _1 * _2 - _3 * _4
  if (val == 0) then
    -- Colinear
    return 0
  elseif (val < 0) then
    -- Anti-clockwise direction
    return 2
  end
  -- Clockwise direction
  return 1
end

---isIntersect.
--
-- Check if lines intersect.
-- Lines are made from 2 Vec2 points.
-- @param l1 line 1
--
--       l1 = {
--              p1 = {x = #, y = #},
--              p2 = {x = #, y = #},
--       }
-- @param l2 line 2
--
--       l2 = {
--              p1 = {x = #, y = #},
--              p2 = {x = #, y = #},
--       }
-- @return true Lines intersect
-- @return false Lines do not intersect
function SPECTRE.POLY.isIntersect(l1, l2)
  -- Four direction for two lines and points of other line
  local dir1 = SPECTRE.POLY.direction(l1.p1, l1.p2, l2.p1)
  local dir2 = SPECTRE.POLY.direction(l1.p1, l1.p2, l2.p2)
  local dir3 = SPECTRE.POLY.direction(l2.p1, l2.p2, l1.p1)
  local dir4 = SPECTRE.POLY.direction(l2.p1, l2.p2, l1.p2)
  -- When intersecting
  if (dir1 ~= dir2 and dir3 ~= dir4) then
    return true
  end
  -- When p2 of line2 are on the line1
  if (dir1 == 0 and SPECTRE.POLY.onLine(l1, l2.p1)) then
    return true
  end
  -- When p1 of line2 are on the line1
  if (dir2 == 0 and SPECTRE.POLY.onLine(l1, l2.p2)) then
    return true
  end
  -- When p2 of line1 are on the line2
  if (dir3 == 0 and SPECTRE.POLY.onLine(l2, l1.p1)) then
    return true
  end
  -- When p1 of line1 are on the line2
  if (dir4 == 0 and SPECTRE.POLY.onLine(l2, l1.p2)) then
    return true
  end
  return false
end

---checkInside.
--
--       1. Draw a horizontal line to the right of each point and extend it to infinity.
--       2. Count the number of times the line intersects with polygon edges.
--       3. A point is inside the polygon if either count of intersections is odd or point lies on an edge of polygon.
--       4. If none of the conditions is true, then point lies outside.
-- @param poly Polygon to test P against. Table of Vec2 points. #poly must be >= 3, else returns false
--
--        poly = {
--                    [1] = {x = #, y = #},
--                    [...] = {x = #, y = #},
--                    [n] = {x = #, y = #},
-- @param p The vec2 to test whether inside polygon or not.
--
--           p = {x=#,y=#}
-- @return true
-- @return false
function SPECTRE.POLY.checkInside(poly, p)
  local n = #poly
  -- When polygon has less than 3 edge, it is not polygon
  if (n < 3) then
    return false
  end

  -- Create a point at infinity, y is same as point p
  local tmp= {x = 99999999, y = p.y}
  local exline = { p1 = p, p2 = tmp }
  local count = 0
  local i = "bunny"
  while (i ~= 0)
  do
    if i == "bunny" then i = 1 end
    -- Forming a line from two consecutive points of
    -- poly
    local side
    if ((i + 1) % n) == 0 then
      side = { p1 = poly[i], p2 = poly[n] }
    else
      side = { p1 = poly[i], p2 = poly[(i + 1) % n] }
    end
    if (SPECTRE.POLY.isIntersect(side, exline)) then

      -- If side is intersects exline
      if (SPECTRE.POLY.direction(side.p1, p, side.p2) == 0) then
        return SPECTRE.POLY.onLine(side, p)
      end
      count = count + 1
    end
  end
  if (count % 2) == 0 then
    --even
    --is not in poly
    return false
  else
    --odd
    --is in poly
    return true
  end
end

---POLY.Misc.
-- ===
-- Misc Poly functions.
--
--       You probably shouldnt use these.
--
-- ===
-- @section POLY.Misc

--- BoundingBox.
-- @param box
-- @param tx
-- @param ty
-- @return (box[2].x >= tx and box[2].y >= ty) and (box[1].x <= tx and box[1].y <= ty)
-- @return (box[1].x >= tx and box[2].y >= ty) and (box[2].x <= tx and box[1].y <= ty)
function SPECTRE.POLY.BoundingBox(box, tx, ty)
  return  (box[2].x >= tx and box[2].y >= ty)
    and (box[1].x <= tx and box[1].y <= ty)
    or  (box[1].x >= tx and box[2].y >= ty)
    and (box[2].x <= tx and box[1].y <= ty)
end

--- colinear.
-- @param line
-- @param x
-- @param y
-- @param e
-- @return math.abs(y - f(x)) <= e
function SPECTRE.POLY.colinear(line, x, y, e)
  e = e or 0.1
  local m = (line[2].y - line[1].y) / (line[2].x - line[1].x)
  local function f(x) return line[1].y + m*(x - line[1].x) end
  return math.abs(y - f(x)) <= e
end

--- PointWithinLine.
-- @param line
-- @param tx
-- @param ty
-- @param e
-- @return SPECTRE.POLY.colinear(line, tx, ty, e)
-- @return false
function SPECTRE.POLY.PointWithinLine(line, tx, ty, e)
  e = e or 0.66
  if SPECTRE.POLY.BoundingBox(line, tx, ty) then
    return SPECTRE.POLY.colinear(line, tx, ty, e)
  else
    return false
  end
end

--- CrossingsMultiplyTest.
-- @param pgon
-- @param tx
-- @param ty
-- @return true
-- @return false
function SPECTRE.POLY.CrossingsMultiplyTest(pgon, tx, ty)
  local i, yflag0, yflag1, inside_flag
  local vtx0, vtx1
  local numverts = #pgon
  vtx0 = pgon[numverts]
  vtx1 = pgon[1]
  -- get test bit for above/below X axis
  yflag0 = ( vtx0.y >= ty )
  inside_flag = false
  for i=2,numverts+1 do
    yflag1 = ( vtx1.y >= ty )
    if ( yflag0 ~= yflag1 ) then
      if ( ((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) * (vtx0.y - vtx1.y)) == yflag1 ) then
        inside_flag =  not inside_flag
      end
    end
    -- Move to the next pair of vertices, retaining info as possible.
    yflag0  = yflag1
    vtx0    = vtx1
    vtx1    = pgon[i]
  end
  return  inside_flag
end

--- GetIntersect.
--
-- Checks for intersection of points, returns point of intersect.
-- @param points
-- @return xk, yk
function SPECTRE.POLY.GetIntersect( points )
  local g1 = points[1].x
  local h1 = points[1].y

  local g2 = points[2].x
  local h2 = points[2].y

  local i1 = points[3].x
  local j1 = points[3].y

  local i2 = points[4].x
  local j2 = points[4].y

  local xk = 0
  local yk = 0

  if SPECTRE.POLY.checkIntersect({x=g1, y=h1}, {x=g2, y=h2}, {x=i1, y=j1}, {x=i2, y=j2}) then
    local a = h2-h1
    local b = (g2-g1)
    local v = ((h2-h1)*g1) - ((g2-g1)*h1)

    local d = i2-i1
    local c = (j2-j1)
    local w = ((j2-j1)*i1) - ((i2-i1)*j1)

    xk = (1/((a*d)-(b*c))) * ((d*v)-(b*w))
    yk = (-1/((a*d)-(b*c))) * ((a*w)-(c*v))
  end
  return xk, yk
end






-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.Utils**
--
-- Utilities included in and part of SPECTRE.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.Utils}
-- ===
--
--  ***Utils for SPECTRE.***
--
--   * The Utils Class.
--
--   * All aspects of the Utils are accessed via this class.
--
--     -- lorem ipsum
--
-- ===
--
--
-- @module Utils
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - Utils *** ")

---Utils.
-- ===
--
-- *Utilities included in and part of SPECTRE.*
--
-- ===
-- @section Utils

--- ###Utils
-- ===
--
--      Utilities included in and part of SPECTRE.
--
-- * Utils for SPECTRE
--
--   * The Utils Class.
--
--   * All aspects of the Utils are accessed via this class.
--
-- @field #Utils
-- @field ClassName SPECTRE.OBJECT.Utils
-- @field ClassID The ID number of the class.
SPECTRE.Utils = {
  ClassName = "Utils",
  ClassID = 0,
}

---Utils Table Functions.
-- ===
--
-- *All Table Manipulation Functions associated with the class.*
--
-- ===
-- @section Utils Table Functions

--- Check if table contains element.
-- If contains, Return True
-- @param table table to check
-- @param Key_element what to check for
-- @return return true or false
function SPECTRE.Utils.table_contains(table, Key_element)
  for key, value in pairs(table) do
    if key == Key_element then
      return true
    end
  end
  return false
end

--- Merge 2 Tables.
-- @param t1 : Table 1 (to be added to)
-- @param t2 : Table 2 (To be added to Table 1)
-- @return t1
function SPECTRE.Utils.merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      SPECTRE.Utils.merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

---Counts occurances of values in a Table.
-- @param table : Table to be checked
--
--      Table t = {"string", "string", ..., n,}
-- @return counts : table of occurances
--
--      Table: counts = { [occurance1] = #times occured, ... }
function SPECTRE.Utils.CountValues(table)
  local counts = {}
  for _, v in ipairs(table) do
    counts[v] = counts[v] and counts[v] + 1 or 1
  end
  return counts
end

---Shuffles a Table.
-- @param t : Table to be shuffled
-- @return s : Shuffled table
function SPECTRE.Utils.Shuffle(t)
  local s = {}
  for i = 1, #t do s[i] = t[i] end
  for i = #t, 2, -1 do
    local j = math.random(i)
    s[i], s[j] = s[j], s[i]
  end
  return s
end

---Pick Random From Table.
-- @param t : Table
-- @return s : picked value
function SPECTRE.Utils.PickRandomFromTable(t)
  local s = t[ math.random( #t )]
  return s
end

---Gets the index of a value in a table.
-- @param tab : table
-- @param val : value
-- @return index : index of value in table or nil
function SPECTRE.Utils.getIndex(tab, val)
  local index = nil
  for i, v in ipairs (tab) do
    if (v == val) then
      index = i
    end
  end
  return index
end

---Utils Misc Functions.
-- ===
--
-- *All Misc Functions associated with the class.*
--
-- ===
-- @section Utils Misc Functions

--- Deletes all ground units of a coalition in a zone.
-- 
-- Provide a ZONE_RADIUS zoneName, and a coalition.
-- 
-- May also provide an eventFlag to raise event when destroying units.
-- @param zoneName : ZONE_RADIUS zoneName
-- @param coalition : Takes "red" or "blue" or "neutral"
-- @param eventFlag : optional true, false, or nil
-- Defaults to true if not provided.
function SPECTRE.Utils.DeleteUnitsInZone(zoneName, coalition, eventFlag)
    eventFlag = eventFlag or true
    local Zone_ = ZONE:FindByName(zoneName)
    local ZoneSet = SET_GROUP:New():FilterZones({Zone_}):FilterCoalitions(coalition):FilterCategoryGround():FilterOnce()
    local function DelGroup (__group)
      __group:Destroy(eventFlag)
    end
    ZoneSet:ForEachGroup(DelGroup)
end


--- Modify a Counter.
-- add or subtract 1
-- @param Resource : The counter to be modified
-- @param Operation : Takes "add" or "sub"
-- @return value : new value of resource
function SPECTRE.Utils.Ticker(Resource, Operation)
  local value = Resource
  if Operation == "add" then
    value = value + 1
  end
  if Operation == "sub" then
    if value ~= 0 then
      value = value - 1
    end
  end
  return value
end

--- Convert PlaceName from OnEventBaseCaptured to match AirfieldName in AIRBASE class.
-- @param PlaceName Paramter returned from OnEventBaseCaptured.place event data
-- @return output : Converted name to Airfield name list format
function SPECTRE.Utils.AirfieldNameConvert(PlaceName)
  -- Replace "-" with "_"
  local sub1 = string.gsub(PlaceName, '-', '_')
  -- Replace " " with "_"
  local sub2 = string.gsub(sub1, ' ', '_')
  -- Remove '
  local output = string.gsub(sub2, '\'', '')
  return output
end

--- Truncate a number's decimal to a specified amount of digits.
-- @param num number to do work on.
-- @param digits amount of digits to truncate decimal to.
-- @return output : worked on number
function SPECTRE.Utils.trunc(num, digits)
  local mult = 10^(digits)
  local output = math.modf(num*mult)/mult
  return output
end

---Utils SSB Functions.
-- ===
--
-- *All Functions associated with SSB.*
--
-- ===
-- @section Utils SSB Functions

--- Enable/Disable Slot for player aircraft based on a known group naming convention.
--
-- Player Aircraft slots must be named in the format:
--
--       "field .. aircraft .. number"
--
-- EX. Name of group to be enabled: "Abu_F18-1"
--
-- @param AircraftList Table of all aircraft types names, EX. {"\_F18-", "_F16-", ... }
-- @param field The airfield denotation of group name, EX. "Abu"
-- @param flag Flag value for SSB enable/Disable, EX. 0
-- @param startNum starting number value, EX. 1
-- @param endNum End Number Value, EX. 4
function SPECTRE.Utils.SlotEnableDisable(AircraftList, field, flag, startNum, endNum)
  startNum = startNum or nil
  endNum = endNum or nil
  for AircraftListCount = 1, #AircraftList, 1 do
    local aircraft = AircraftList[AircraftListCount]
    for _iCounter = startNum,endNum,1 do
      local number = tostring(_iCounter)
      trigger.action.setUserFlag(field .. aircraft .. number,flag)
    end
  end
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPECTRE.WORLD**
--
-- WORLD operations for tracking game data and state.
--
-- ===
--      @{SPECTRE} ---> @{SPECTRE.WORLD}
-- ===
--
--  ***WORLD for SPECTRE.***
--
--   * The WORLD Class.
--
--   * All aspects of the WORLD are accessed via this class.
--
--     -- WORLD operations for tracking game data and state.
--
-- ===
--
--
-- @module WORLD
-- @extends SPECTRE

env.info(" *** LOAD S.P.E.C.T.R.E. - World *** ")

---WORLD.
-- ===
--
-- *WORLD operations for tracking game data and state.*
--
-- ===
-- @section WORLD

--- ###WORLD
-- ===
--
--      WORLD operations for tracking game data and state.
--
-- * WORLD for SPECTRE
--
--   * The WORLD Class.
--
--   * All aspects of the WORLD are accessed via this class.
--
-- @field #WORLD
-- @field ClassName SPECTRE.OBJECT.WORLD
-- @field ClassID The ID number of the class.
SPECTRE.WORLD = {
  ClassName = "WORLD",
  ClassID = 0,
}

---WORLD Zone.
-- ===
--
-- *Functions for tracking zone game data and state.*
--
-- ===
-- @section WORLD Zone

--- Determines if vec2 is in the zone.
-- Requires quadpoint zone, defined in ME.
-- @param vec2 : Vec2 to check, {x = , y = }
-- @param zoneName : Name of quadpoint zone, defined in Mission Editor.
-- @return result : true or false
function  SPECTRE.WORLD.PointInZone(vec2, zoneName)
  local _zone = mist.DBs.zonesByName[zoneName]
  local box =  _zone.verticies
  local _vec2 = {}
  if vec2.x == nil then
    _vec2.x = vec2[1]
    _vec2.y = vec2[2]
  else
    _vec2 = vec2
  end
  local result = SPECTRE.POLY.PointWithinShape(_vec2, box)
  return result
end

--- Determines if vec2 is in a list of zones.
-- Requires quadpoint zones, defined in ME.
-- @param vec2 : Vec2 to check, {x = , y = }
-- @param zoneList : List of Names of quadpoint zone, defined in Mission Editor.
--
--        zoneList = {"name1","name2",...,n,}
-- @return 1 = not in zones
-- @return 0 = Vec2 is in Nogo zones
function SPECTRE.WORLD.CheckVec2_NoGoZones(possibleVec2,zoneList)
  local result
  for _v = 1, #zoneList, 1 do
    result = SPECTRE.WORLD.PointInZone(possibleVec2, zoneList[_v])
    if result then
      return 0
    end
  end
  return 1
end

--- Creates a Red Circle and Marker at the desired coord for specific team if specific units are detected in a zone
-- @param ZoneName Name of Zone to check if units exist within, EX. "Zone_Damascus"
-- @param ObjectCategory Object Category to scan for within zone, EX. Object.Category.UNIT
-- @param Table_UnitCategory Table of units types to scan for, EX. {Unit.Category.GROUND\_UNIT}
-- @param UnitCoalition Coalition of units to scan for, EX. coalition.side.RED
-- @param Coordinate Coordinate to center Marker on
-- @param MarkCoalition Coalition to create the marker for, Coalition: All=-1, Neutral=0, Red=1, Blue=2. Default -1=All.
-- @param MarkerRadius Radium for the marker (meters)
-- @param MarkText Text to include in the marker
-- @return ReturnTable : {MarkerID,CircleID} - Table containing ID for created Marker and Circle
function SPECTRE.WORLD.TargetMarker_CreateAtPointIfUnitsExistInZone(ZoneName, ObjectCategory, Table_UnitCategory, UnitCoalition, Coordinate, MarkCoalition, MarkerRadius, MarkText)
  MarkCoalition = MarkCoalition or -1
  MarkText = MarkText or ""
  MarkerRadius = MarkerRadius or 5000
  local CircleID = nil
  local MarkerID = nil
  local zoneCheck = ZONE:FindByName ( ZoneName )
  zoneCheck:Scan(ObjectCategory, Table_UnitCategory  )
  if     zoneCheck:CheckScannedCoalition(UnitCoalition) == true then
    CircleID = Coordinate:CircleToAll(MarkerRadius,MarkCoalition,{1,0,0},1,{1,0,0},0.4,4,true)
    MarkerID = Coordinate:MarkToCoalition(MarkText,MarkCoalition,true)
  end
  local ReturnTable = {MarkerID,CircleID}
  return ReturnTable
end

---WORLD Airbase.
-- ===
--
-- *Functions for tracking Airbase game data and state.*
--
-- ===
-- @section WORLD Airbase

---Finds closest airbase to vec2.
-- @param AirbaseList List of airbase names to evaluate
-- @param _vec2 for check
-- @return ClosestAirbase : {Name, Vec3} of closest airbase from list to desired Vec2
function SPECTRE.WORLD.FindNearestAirbaseToPointVec2(AirbaseList, _vec2)
  local distance = 99999999999
  local ClosestAirbase
  local PointCoord = COORDINATE:NewFromVec2(_vec2)
  for _i = 1, #AirbaseList , 1 do
    local airbaseVec3 = AIRBASE:FindByName(AirbaseList[_i]):GetVec3()--:GetVec2()
    local AirbaseCoord = COORDINATE:NewFromVec3(airbaseVec3)
    local _distance = PointCoord:Get2DDistance(AirbaseCoord)
    if _distance < distance then
      distance = _distance
      ClosestAirbase = {AirbaseList[_i], airbaseVec3}
    end
  end
  return ClosestAirbase
end

--- Get and create list of all airbases owned by coalition.
-- @param coal coalition
-- @param map Map, takes "Syria", "Persia", "Sinai" or "Caucasus"
-- @return _AirbaseListOwned : List of owned airfields
function SPECTRE.WORLD.GetOwnedAirbaseCoal(coal,map)
  local _AirbaseListTheatre = {}
  local _AirbaseListOwned = {}
  if map == "Syria" then
    _AirbaseListTheatre = AIRBASE.Syria
  elseif map == "Persia" then
    _AirbaseListTheatre = AIRBASE.PersianGulf
  elseif map == "Caucasus" then
    _AirbaseListTheatre = AIRBASE.Caucasus
  elseif map == "Sinai" then
    _AirbaseListTheatre = AIRBASE.Sinai
  end
  for key, value in pairs(_AirbaseListTheatre) do
    local airbase_ = AIRBASE:FindByName(value)
    local airbase_Coal = airbase_:GetCoalition()
    if airbase_Coal == coal then
      _AirbaseListOwned[#_AirbaseListOwned+1]= value
    end
  end
  return _AirbaseListOwned
end

--- Find closest friendly airfield to vec2.
-- @param coal : Takes 0, 1, 2 (2=blue, 1 = red, 0 = neutral)
-- @param _vec2 vec2 to check for closest friendly airbase
-- @param map : theatre of war, "Persia", "Syria", Caucuses"
-- @return NearestAirbaseInfo The closest airfield to the player
function SPECTRE.WORLD.ClosestAirfieldVec2(coal, _vec2, map)
  local _Airfields = SPECTRE.WORLD.GetOwnedAirbaseCoal(coal, map)
  if coal == 2 then coal = "blue" end
  if coal == 1 then coal = "red" end
  if coal == 0 then coal = "neutral" end
  local NearestAirbase = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(_Airfields, _vec2)
  local NearestAirbaseInfo = {
    Name = NearestAirbase[1],
    Vec3 = NearestAirbase[2],
  }
  return NearestAirbaseInfo
end

---WORLD Misc.
-- ===
--
-- *Misc Functions for tracking game data and state.*
--
-- ===
-- @section WORLD Misc

--- Find distance between two different Vec2.
-- @param p1 : Vec2
--
--        p1 = { x = #, y = #}
-- @param p2 : Vec2
--
--        p2 = { x = #, y = #}
-- @return distance
function SPECTRE.WORLD.f_distance(p1, p2)
  return math.sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

