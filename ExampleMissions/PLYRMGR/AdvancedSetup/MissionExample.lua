SPECTRE.DebugEnabled = 1
SPECTRE:Persistence("MissionExample")

--- Advanced PLYRMGR setup - continued from BasicSetup.


SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.

---You can set the costs for custom support redemption:
-- use the `SPECTRE.PLYRMGR:setPointCost_` methods.
SPECTRE.PLYRMGR:setPointCost_CAP(500)
SPECTRE.PLYRMGR:setPointCost_AIRDROP_ARTILLERY(20)
SPECTRE.PLYRMGR:setPointCost_TOMAHAWK(100)


---You can set the amount of resources available for custom support redemption:
--
-- use the table `SPECTRE.PLYRMGR.RESOURCES`

SPECTRE.PLYRMGR.RESOURCES.CAP = 5

SPECTRE.PLYRMGR.RESOURCES.AIRDROP = {
  ARTILLERY = {Red = 30, Blue = 30}, -- Artillery AIRDROP resources.
  IFV       = {Red = 3, Blue = 30}, -- IFV AIRDROP resources.
  TANK      = {Red = 3, Blue = 30}, -- Tank AIRDROP resources.
  AAA       = {Red = 3, Blue = 10}, -- AAA AIRDROP resources.
  IRSAM     = {Red = 3, Blue = 3}, -- SAM_IR AIRDROP resources.
  RDRSAM    = {Red = 3, Blue = 3}, -- SAM_RDR AIRDROP resources.
  EWR       = {Red = 3, Blue = 1}, -- EWR AIRDROP resources.
  SUPPLY    = {Red = 3, Blue = 30} -- Supply AIRDROP resources.
}


--- The point rewards are based on the highest threat attribute assigned to the destroyed unit. 
-- 
-- You can modify rewards by modifying the following tables:
-- 
-- EX: If a plane with attributes `Fighters` & `Interceptors` is destroyed, it will reward
-- the player with 15 points, as it is the highest value of possible rewards.
-- 
SPECTRE.REWARDS.Config.PointRewards["Air"] = {
  General = 10,
  ["Helicopters"] = {
    General = 1,
    ["Attack helicopters"] = 4,
    ["Transport helicopters"] = 2,
  },
  ["Planes"] = {
    General = 10,
    ["AWACS"] = 50,
    ["Tankers"] = 50,
    ["Aux"] = 12,
    ["UAVs"] = 20,
    ["Transports"] = 7,
    ["Battle airplanes"] = {
      General = 10,
      ["Fighters"] = 10,
      ["Interceptors"] = 15,
      ["Multirole fighters"] = 12,
      ["Bombers"] = {
        General = 20,
        ["Strategic bombers"] = 25,
      },
      ["Battleplanes"] = 11,
      ["Missiles"] = {
        General = 5,
        ["Cruise missiles"] = 40,
        ["Anti-Ship missiles"] = 50,
      },
    },
  },
}
---.
SPECTRE.REWARDS.Config.PointRewards["Ships"] = {
  General = 50,
  ["Unarmed ships"] = 5,
  ["Armed ships"] = {
    General = 55,
    ["Light armed ships"] = 60,
    ["Heavy armed ships"] = {
      General = 70,
      ["Corvettes"] = 75,
      ["Frigates"] = 80,
      ["Destroyers"] = 100,
      ["Cruisers"] = 75,
      ["Aircraft Carriers"] = 200,
    }
  }
}
---.
SPECTRE.REWARDS.Config.PointRewards["Ground Units"] = {
  General = 2,
  ["LightArmoredUnits"] = {
    General = 2,
    ["IFV"] = 5,
    ["APC"] = 3,
    ["Artillery"] = {
      General = 5,
      ["MLRS"] = 10,
    }
  },
  ["HeavyArmoredUnits"] = {
    General = 2,
    ["Tanks"] = 6,
    ["Buildings"] = 7,
    ["Fortifications"] = 7,
  },
  ["Ground vehicles"] = {
    General = 2,
    ["AAA"] = {
      General = 8,
      ["Static AAA"] = 10,
      ["Mobile AAA"] = 15,
    },
    ["EWR"] = 50,
    ["Unarmed vehicles"] = {
      General = 0,
      ["Cars"] = 0,
      ["Trucks"] = 0,
    },
    ["SAM elements"] = {
      General = 7,
      ["SR SAM"] = {
        General = 10,
        ["SAM SR"] = 15,
        ["SAM TR"] = 15,
        ["SAM LL"] = 12,
        ["SAM CC"] = 20,
        ["SAM AUX"] = 11,
      }, --short range
      ["MR SAM"] = {
        General = 15,
        ["SAM SR"] = 20,
        ["SAM TR"] = 20,
        ["SAM LL"] = 17,
        ["SAM CC"] = 25,
        ["SAM AUX"] = 16,
      }, --medium range
      ["LR SAM"] = {
        General = 20,
        ["SAM SR"] = 25,
        ["SAM TR"] = 25,
        ["SAM LL"] = 22,
        ["SAM CC"] = 30,
        ["SAM AUX"] = 21,
      }, --long range
    },
    ["Armed ground units"] = {
      General = 2,
      ["Infantry"] = {
        General = 2,
        ["MANPADS AUX"] = 5,
        ["MANPADS"] = 10,
      }
    }
  }
}




---------------------------------------------------------------------------------------------------------------------------------.

--- BELOW IS THE SAME AS FROM `BASIC SETUP` EXAMPLE: 

---------------------------------------------------------------------------------------------------------------------------------.


--If you want to set a custom welcome message, set it first:

SPECTRE.PLYRMGR.Settings.Reports.Welcome = {
  "Welcome to EXAMPLE PLYRMGR mission!",
  "=============================",
  "~ text ~",
  "   lorem ipsum   ",
  " ",
  "GOAL: Capture All Zones. See Briefing.",
  " ",
  "Points may be used to redeem custom support via:",
  "Comm Menu -> F10: Other -> Point Redeem / Custom Support",
}


--- If you wish to use the automated custom support options, set the template group names for the redeems.
-- The redeems ignore the coalition/country of the template.
--
-- SPECTRE will automatically set the Coalition/Country for redeems based on the affiliation of the player who redeems the support option.
--
-- IMPORTANT:
--
-- Airdrop & Strike have both a transport group, and the actual dropped group.
--
-- TOMAHAWK : The group used should exist in the mission before redemption. SPECTRE sends the redeem orders to the given group name.
--            Make sure the group assigned actually has Tomahawk missiles on board.
--
--
-- If you are using persistence mods such as DSMC, SPECTRE will automatically scan for and reassign all relevant internal handlers for
-- player support units on server restart.


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

SPECTRE.PLYRMGR:enablePersistance() -- Here, I am setting global values to enable persistent tracking of player/points
  :enableRewards()                  -- This allows players to recieve points upon destroying units.
  :enableSupport_All()              -- This allows players access to ALL custom support redemption options.

--- If you only want specific support options enabled, use `:enableSupport(type, enabled)`
--  :enableSupport(type,true)
--
-- Where `type` =
--
-- SPECTRE.PLYRMGR.Settings.Support.AIRDROP
-- SPECTRE.PLYRMGR.Settings.Support.BOMBER
-- SPECTRE.PLYRMGR.Settings.Support.CAP
-- SPECTRE.PLYRMGR.Settings.Support.STRIKE
-- SPECTRE.PLYRMGR.Settings.Support.TOMAHAWK
--
-- and enabled = Boolean `true` or `false`


--- After setting your config, you can initiate the Player Manager.
playerManager_ = SPECTRE.PLYRMGR:New():Init()

local _placeholder = ""
