SPECTRE.DebugEnabled = 1


--- PLYRMGR setup.
-- 
-- The Player Manager allows you to have:
--
-- Automated Point Rewards for destroying in game units.
-- 
-- Automated Point Redeems for in-game support.
--
-- The ability to track and manage player stats over time when used with SPECTRE persistence, all from within the game environment.

SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.

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