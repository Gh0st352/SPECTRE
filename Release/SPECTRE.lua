--- S.P.E.C.T.R.E. (Special Purpose Extension for Creating Truly Reactive Environments)
-- ------------------------------------------------------------------------------------------
-- Requires MOOSE, MIST, SSB to be loaded before SPECTRE.lua for certain functions to work.
-- Functions with external dependencies will be clearly marked.
-- ------------------------------------------------------------------------------------------
-- 
-- S. - Special         |
-- P. - Purpose         | CompileTime : Saturday, January 6, 2024 7:03:49 AM
-- E. - Extension for   |      Commit : 6adc313af566c4a566e5aefe11b85fc2bd03d026
-- C. - Creating        |	    Version : 0.9.9
-- T. - Truly           |      Github : https://github.com/Gh0st352
-- R. - Reactive        |      Author : Gh0st
-- E. - Environments    |     Discord : gh0st352
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


--- **SPECTRE**
--
-- Special Purpose Extension for Creating Truly Reactive Environments
--
-- (SPECTRE) serves as the foundational class for the extension.
--
-- This class acts as the access point for all aspects and functionalities of SPECTRE, offering capabilities to enhance and
-- manage the simulation environment dynamically.
--
-- The class is fully compatible with IntelliSense and IntelliJ, providing
-- a robust and intuitive development experience.
--
-- Key features and properties include:
-- * All in one intelligent framework for speeding mission development.
-- * `ZONEMGR` Utilizes DBSCAN Clustering Algorithm to contribute to mission learning.
-- * System is capable of using the determined clusters to decide course of action for mission zones based on cluster information.
-- * More advanced implementations to come.
-- * `SPAWNER` is capable of spawning thousands of unique unit combinations and sizes in fractions of a second with no client/server lag.
-- * Debugging capabilities controlled by `DebugEnabled`.
-- * Configuration for map, coalitions, and countries.
-- * Persistence management, including flags and file paths for various components.
-- * Mission status tracking and management.
-- * Storage for user-defined data in `SPECTRE.USERSTORAGE`.
--
--        EX: local userinfo = {x = "I want to save this",[3] = false}
--            SPECTRE.USERSTORAGE["userinfo"] = userinfo
--
--        If persistence is enabled, you can get your data back the next load by:
--
--            local userinfo = {}
--            userinfo = SPECTRE.USERSTORAGE["userinfo"]
--
--
--  @{SPECTRE} ---> @{AI}
--  @{SPECTRE} ---> @{BRAIN}
--  @{SPECTRE} ---> @{HANDLERS}
--  @{SPECTRE} ---> @{IADS}
--  @{SPECTRE} ---> @{IO}
--  @{SPECTRE} ---> @{MARKERS}
--  @{SPECTRE} ---> @{MENU}
--  @{SPECTRE} ---> @{PLYRMGR}
--  @{SPECTRE} ---> @{POLY}
--  @{SPECTRE} ---> @{REWARDS}
--  @{SPECTRE} ---> @{SPAWNER}
--  @{SPECTRE} ---> @{UTILS}
--  @{SPECTRE} ---> @{WORLD}
--  @{SPECTRE} ---> @{ZONEMGR}
--
--
-- ===
--
-- @module SPECTRE

--- `SPECTRE`.
--
-- Special Purpose Extension for Creating Truly Reactive Environments
--
-- (SPECTRE) serves as the foundational class for the extension.
--
-- This class acts as the access point for all aspects and functionalities of SPECTRE, offering capabilities to enhance and
-- manage the simulation environment dynamically.
--
-- The class is fully compatible with IntelliSense and IntelliJ, providing
-- a robust and intuitive development experience.
--
-- Key features and properties include:
-- * Debugging capabilities controlled by `DebugEnabled`.
-- * Configuration for map, coalitions, and countries.
-- * Persistence management, including flags and file paths for various components.
-- * Mission status tracking and management.
-- * Storage for user-defined data.
--
-- @field #SPECTRE
SPECTRE = {}

--- Debugging switch for SPECTRE (0 = off, 1 = on).
SPECTRE.DebugEnabled = 0
---.
SPECTRE.COUNTER = 1

--- Name of the map SPECTRE is operating on.
SPECTRE.MAPNAME = "Syria"

--- Coalition definitions used by SPECTRE.
SPECTRE.Coalitions = {
  Red = coalition.side.RED,
  Blue = coalition.side.BLUE
}

--- Country definitions used by SPECTRE.
SPECTRE.Countries = {
  Red = country.id.CJTF_RED,
  Blue = country.id.CJTF_BLUE
}

--- Flag to enable persistence in SPECTRE.
SPECTRE._persistence = false


--- Flag indicating whether SPECTRE settings have been loaded.
SPECTRE._loaded = false

--- Flag to identify the first run of SPECTRE in a mission.
SPECTRE._firstRun = true

--- Flag indicating if a mission is in progress.
SPECTRE._missionInProgress = false

--- Event handler for mission end events.
SPECTRE._endMizHandler = {}

--- Locations for persisting various components of SPECTRE.
SPECTRE._persistenceLocations = {
  SPECTRE       = {folder = "SPECTRE", path = ""},
  missionStatus = {folder = "missionStatus", path = ""},
  SPAWNER       = {folder = "SPAWNER", path = ""},
  ZONEMGR       = {folder = "ZONEMGR", path = ""},
  PLYRMGR       = {folder = "PLYRMGR", path = ""},
  IADS          = {folder = "IADS", path = ""}
}


--- File name for the master profile file of SPECTRE.
SPECTRE._masterProfileFile = "SPECTRE.lua"

--- User-defined storage within SPECTRE.
SPECTRE.USERSTORAGE = {}


--- Constructor for creating a new instance of the SPECTRE class.
--
-- This function initializes a new instance of the SPECTRE class, leveraging inheritance from the BASE class.
-- The created SPECTRE instance is ready to be configured and utilized within the simulation environment,
-- serving as a central component for various operational functionalities.
--
-- @param #SPECTRE
-- @return #SPECTRE self The newly created SPECTRE instance.
function SPECTRE:New()
  local self=BASE:Inherit(self, BASE:New())
  --local self = UTILS.DeepCopy(self)
  return self
end

-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainSyria()
  self.MAPNAME = "Syria"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainPersianGulf()
  self.MAPNAME = "Persia"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainCaucasus()
  self.MAPNAME = "Caucasus"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainSinai()
  self.MAPNAME = "Sinai"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainMarianaIslands()
  self.MAPNAME = "MarianaIslands"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainNevada()
  self.MAPNAME = "Nevada"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainNormandy()
  self.MAPNAME = "Normandy"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainSouthAtlantic()
  self.MAPNAME = "SouthAtlantic"
  return self
end
-- Sets SPECTRE to use the proper terrain info.
-- @param #SPECTRE
-- @return #SPECTRE self
function SPECTRE:setTerrainTheChannel()
  self.MAPNAME = "TheChannel"
  return self
end

--- Destroys a group object when it reaches a waypoint.
--
-- This function is designed to delete a specified group object upon reaching a waypoint.
-- It is a standalone global function, not encapsulated under the main `SPECTRE` class,
-- to accommodate the specific operational requirement of group destruction in response to
-- waypoint attainment.
--
-- @param group The group object to be destroyed upon reaching a waypoint.
function SPECTREDeleteOnWP_(group)
  group:Destroy(true)
end

--- Enable and configure persistence for the SPECTRE system.
--
-- This function activates the persistence feature in the SPECTRE system, setting up paths for saving various
-- components of the system based on the given mission name. It checks for existing persistence files and loads
-- them if available, ensuring continuity across mission sessions. The function also sets up an event handler
-- for mission end to trigger necessary finalization processes. This persistence mechanism is crucial for
-- maintaining the state of the SPECTRE system across different missions, providing a seamless experience.
--
-- @param #SPECTRE self The instance of the SPECTRE class.
-- @param MissionName A unique name representing the mission, used for organizing persistence data.
-- @return #SPECTRE self The updated SPECTRE instance with persistence enabled and configured.
function SPECTRE:Persistence(MissionName)
  -- Activate persistence
  self._persistence = true
  -- Debug Information
  SPECTRE.UTILS.debugInfo("SPECTRE:Persistence | Checking persistence for Mission: " .. MissionName )
  -- Set paths for saving different components of the spawner
  self._persistenceLocations.SPECTRE.folder = MissionName
  self._persistenceLocations.SPECTRE.path = MissionName .. "/"
  self._persistenceLocations.missionStatus.path = MissionName .. "/".. self._persistenceLocations.missionStatus.folder .. "/"
  self._persistenceLocations.SPAWNER.path = MissionName .. "/".. self._persistenceLocations.SPAWNER.folder .. "/"
  self._persistenceLocations.ZONEMGR.path = MissionName .. "/".. self._persistenceLocations.ZONEMGR.folder .. "/"
  self._persistenceLocations.PLYRMGR.path = MissionName .. "/".. self._persistenceLocations.PLYRMGR.folder .. "/"
  self._persistenceLocations.IADS.path = MissionName .. "/".. self._persistenceLocations.IADS.folder .. "/"

  -- Where to go to sleep.
  local _tmasterProfileFile = tostring(self._masterProfileFile)
  local _fmasterProfileName = tostring(self._persistenceLocations.missionStatus.path .. _tmasterProfileFile)
  self._masterProfileFile = tostring(_fmasterProfileName)
  -- Check for existing persistence files and load if present
  if SPECTRE.IO.file_exists(self._masterProfileFile) then
    -- Load Stuff
    local _oldSelf = SPECTRE.IO.PersistenceFromFile(self._masterProfileFile)
    self = SPECTRE.UTILS.setTableValues(_oldSelf, self)
    self._loaded = true
    SPECTRE.UTILS.debugInfo("SPECTRE:Persistence | PERSISTENCE | LOADED OLD SELF")
  end
  self._missionInProgress = true
  self._endMizHandler = EVENT:New()
  self._endMizHandler:HandleEvent(EVENTS.MissionEnd, function(eventData)
    self:_EndMission(eventData)
  end)
  -- Debug output for constructed paths
  SPECTRE.UTILS.debugInfo("SPECTRE:Persistence | Paths:")
  SPECTRE.UTILS.debugInfo("  missionStatus:  " .. self._persistenceLocations.missionStatus.path)
  SPECTRE.UTILS.debugInfo("  Profile:        " .. self._masterProfileFile)
  SPECTRE.UTILS.debugInfo("  SPAWNER:        " .. self._persistenceLocations.SPAWNER.path)
  SPECTRE.UTILS.debugInfo("  ZONEMGR:        " .. self._persistenceLocations.ZONEMGR.path)
  SPECTRE.UTILS.debugInfo("  PLYRMGR:        " .. self._persistenceLocations.PLYRMGR.path)
  SPECTRE.UTILS.debugInfo("  IADS:           " .. self._persistenceLocations.IADS.path)
  return self
end

--- Internal.
-- ===
--
-- *.*
--
-- ===
-- @section SPECTRE

--- Handler for the end mission event.
--
-- This internal function is triggered by the "End Mission" event and is responsible for managing the final
-- steps of a mission within the SPECTRE system. It logs the mission completion, invokes the `EndMission`
-- function to handle the necessary finalization processes, and ensures that SPECTRE is appropriately
-- updated and saved at the end of a mission. This function plays a critical role in ensuring a smooth
-- transition and preserving the state of SPECTRE for future operations if persistence is enabled.
--
-- @param #SPECTRE self The instance of the SPECTRE class.
-- @param eventData Data associated with the "End Mission" event.
-- @return #SPECTRE self The SPECTRE instance, having processed the end of the mission.
function SPECTRE:_EndMission(eventData)
  SPECTRE.UTILS.debugInfo("SPECTRE:_EndMission | PERSISTENCE | The mission has ended! Saving....")
  self:EndMissionSave()
  return self
end

---Save and prepare SPECTRE for the next operation.
--
-- This function is responsible for preparing the SPECTRE system for subsequent operations.
-- It handles the state transition by updating internal flags and performing necessary cleanup or reset actions.
-- Additionally, it exports the current state of SPECTRE to a file for persistence, enabling the system to resume
-- effectively in the next mission.
--
-- @param #SPECTRE
-- @return #SPECTRE self The SPECTRE instance, prepared for the next operation.
function SPECTRE:EndMissionSave()
  if self._firstRun == true then self._firstRun = false end
  if self._missionInProgress == false then self._firstRun = true end
  -- Collect self and center thoughts for the next go.
  local SPECTRE_settings = SPECTRE.UTILS.templateFromObject(self)
  SPECTRE.UTILS.debugInfo("SPECTRE:_EndMission | PERSISTENCE | Exporting self... ")
  SPECTRE.UTILS.debugInfo("SPECTRE:_EndMission | PERSISTENCE | Saving To:          " .. self._masterProfileFile)
  SPECTRE.UTILS.debugInfo("SPECTRE:_EndMission | PERSISTENCE | _missionInProgress: " .. tostring(self._missionInProgress))
  SPECTRE.UTILS.debugInfo("SPECTRE:_EndMission | PERSISTENCE | _firstRun:          " .. tostring(self._firstRun))
  SPECTRE.IO.PersistenceToFile(self._masterProfileFile, SPECTRE_settings, true)
  return self
end

--- **AI**
--
-- Automated AI Handling.
--
--  ***Dynamic AI Management for SPECTRE.***
--
--   * The AI Class.
--
--   * All aspects of the AI are accessed via this class.
--
--     -- Dynamic Management of DCS AI Units.
--     -- Enables AI-driven operations within the SPECTRE framework.
--     -- Provides functions for AI route planning, waypoint generation, and mission configurations.
--     -- Ensures AI entities operate seamlessly within the SPECTRE environment.
--
-- ===
--
-- @module AI
-- @extends SPECTRE

--- SPECTRE.AI.
--
-- Core module for handling AI-driven operations within the SPECTRE framework.
--
-- This module facilitates the generation and management of AI entities, ensuring they operate seamlessly within the SPECTRE environment. Functions include route planning, waypoint generation, and AI mission configurations, allowing for robust and dynamic AI behaviors on the battlefield.
--
-- @section AI
-- @field #AI
SPECTRE.AI = {}

--- Common.
-- ===
--
-- *All Functions commonly associated with AI operations.*
--
-- ===
-- @section SPECTRE.AI

--- Configure Common Options for a Spawn Group.
--
--  @{SPECTRE.AI.configureCommonOptions}
--
-- Sets a series of common options for the given spawn group.
-- The function configures the behavior of the spawn group in various combat scenarios, such as rules of engagement,
-- weapon usage, evasion, fuel management, and communication systems.
--
-- @param spawnGroup_ The spawn group to be configured.
-- @return #spawnGroup_ The configured spawn group.
-- @usage local configuredGroup = SPECTRE.AI.configureCommonOptions(spawnGroup)
function SPECTRE.AI.configureCommonOptions(spawnGroup_)
  -- Set the group to open fire on sight
  spawnGroup_:OptionROEOpenFire()

  -- Set the group to evade when under fire
  spawnGroup_:OptionROTEvadeFire()

  -- Allow the group to jettison weapons when threatened
  spawnGroup_:OptionAllowJettisonWeaponsOnThreat()

  -- Do not force the group to return to base when low on fuel
  spawnGroup_:OptionRTBBingoFuel(false)

  -- Do not restrict the use of afterburners
  spawnGroup_:OptionRestrictBurner(false)

  -- Allow the group to freely engage targets if possible
  spawnGroup_:OptionROEWeaponFreePossible(true)

  -- Enable EPLRS (Enhanced Position Location Reporting System) for the group
  spawnGroup_:CommandEPLRS(true)

  return spawnGroup_
end

--- Set Common Event Handlers for a Spawn Group.
--
--  @{SPECTRE.AI.setCommonEventHandlers}
--
-- Configures common event handlers for the given spawn group, reacting to landing, crashing, and dying events.
-- The function sets up event handlers for the spawn group to handle various scenarios such as landing, crashing, and dying.
-- It also manages restocking through the provided manager and displays messages to the coalition when certain events occur.
--
-- @param spawnGroup_ The spawn group to set event handlers for.
-- @param MANAGER The manager responsible for scheduling restocks.
-- @param Packet Packet data containing the Marker ID.
-- @param messageOnLand Message to display when the group lands.
-- @param messageOnDead Message to display when the group is dead or crashes.
-- @return #spawnGroup_ The spawn group with configured event handlers.
-- @usage local eventConfiguredGroup = SPECTRE.AI.setCommonEventHandlers(spawnGroup, managerInstance, packetData, "Landed!", "Dead!")
function SPECTRE.AI.setCommonEventHandlers(spawnGroup_, MANAGER, Packet, messageOnLand, messageOnDead)
  spawnGroup_.WIPE_ = false

  -- Common function to handle both landing and dead/crash events
  local function handleEvent(_, eventData, message)
    local coal = eventData.IniCoalition
    if spawnGroup_:CountAliveUnits() == 0 and not spawnGroup_.WIPE_ then
      spawnGroup_.WIPE_ = true
      MESSAGE:New(message, 20, "NOTICE"):ToCoalition(coal)
      SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)
      MANAGER:scheduleRestock(coal, Packet.Type)
    end
  end

  spawnGroup_.onGroupLand = function(_, eventData)
    handleEvent(_, eventData, messageOnLand)
  end

  spawnGroup_.onGroupCrashOrDead = function(_, eventData)
    handleEvent(_, eventData, messageOnDead)
  end

  spawnGroup_:HandleEvent(EVENTS.Land, spawnGroup_.onGroupLand)
  spawnGroup_:HandleEvent(EVENTS.Crash, spawnGroup_.onGroupCrashOrDead)
  spawnGroup_:HandleEvent(EVENTS.Dead, spawnGroup_.onGroupCrashOrDead)

  return spawnGroup_
end


--- Racetrack.
-- ===
--
-- *All Functions associated with Racetrack operations.*
--
-- ===
-- @section SPECTRE.AI

--- Prepare Racetrack Coordinates.
--
--  @{SPECTRE.AI.prepareRacetrackCoords}
--
-- This function prepares the racetrack coordinates based on the given parameters.
-- It calculates the starting and ending coordinates of a racetrack pattern using the reference coordinate,
-- altitude, heading, distance, and an offset flag. The offset flag determines if the racetrack should be built using `SPECTRE.AI.BuildRacetrack`.
--
-- @param Coordinate_ The reference coordinate.
-- @param Alt Altitude to be set for the racetrack coordinates.
-- @param heading The heading direction.
-- @param distance Distance for the racetrack translation.
-- @param OFFSET A flag to determine if the racetrack should be built using `SPECTRE.AI.BuildRacetrack`.
-- @return #RacetrackStart The starting coordinate of the racetrack.
-- @return #RacetrackEnd The ending coordinate of the racetrack.
-- @usage local startCoord, endCoord = SPECTRE.AI.prepareRacetrackCoords(referenceCoord, altitude, dir, dist, offsetFlag)
function SPECTRE.AI.prepareRacetrackCoords(Coordinate_, Alt, heading, distance, OFFSET)
  -- Create a new coordinate from the provided one and set its altitude
  local Cap_Marker_Coord = COORDINATE:NewFromCoordinate(Coordinate_)
  Cap_Marker_Coord.y = Alt

  local RacetrackStart, RacetrackEnd
  if heading and distance then
    -- Calculate the translation distance once for optimization
    local translationDistance = UTILS.NMToMeters(distance)

    -- Determine the start and end of the racetrack based on the heading and distance
    RacetrackStart = Cap_Marker_Coord:Translate(translationDistance, heading, true)
    RacetrackEnd = Cap_Marker_Coord:Translate(translationDistance, heading + 180, true)
  else
    -- If heading or distance is not provided, use the original coordinate as the start
    RacetrackStart = Cap_Marker_Coord
  end

  -- Set the altitude for the racetrack start
  RacetrackStart.y = Alt

  -- Build the racetrack if the OFFSET flag is set to 1
  if OFFSET == 1 then
    RacetrackStart, RacetrackEnd = SPECTRE.AI.BuildRacetrack(RacetrackStart, RacetrackEnd, heading)
  end

  return RacetrackStart, RacetrackEnd
end

--- Build Racetrack Coordinates.
--
--  @{SPECTRE.AI.BuildRacetrack}
--
-- Adjusts the racetrack's start and end coordinates based on a given heading.
-- The function takes into account the heading direction and adjusts the start and end coordinates accordingly.
--
-- @param RacetrackStart The starting coordinate of the racetrack.
-- @param RacetrackEnd The ending coordinate of the racetrack.
-- @param heading The heading direction.
-- @return #RacetrackStart The adjusted starting coordinate of the racetrack.
-- @return #RacetrackEnd The adjusted ending coordinate of the racetrack.
-- @usage local adjustedStart, adjustedEnd = SPECTRE.AI.BuildRacetrack(startCoord, endCoord, dir)
function SPECTRE.AI.BuildRacetrack(RacetrackStart, RacetrackEnd, heading)
  if RacetrackEnd then
    local offset = UTILS.NMToMeters(8)
    local sin_ = math.sin(math.rad(heading))
    local cos_ = math.cos(math.rad(heading))
    local offX = offset * sin_
    local offZ = offset * cos_

    -- Adjust offsets based on the heading
    if heading == 0 or heading == 180 or heading == 360 then
      offX = 0
    elseif heading == 90 or heading == 270 then
      offZ = 0
    elseif (heading > 0 and heading < 90) or (heading > 180 and heading < 270) then
      offZ = -offZ
    end

    -- Apply the offsets to the racetrack start and end coordinates
    RacetrackStart.x = RacetrackStart.x + offX
    RacetrackStart.z = RacetrackStart.z + offZ
    RacetrackEnd.x = RacetrackEnd.x + offX
    RacetrackEnd.z = RacetrackEnd.z + offZ
  end

  return RacetrackStart, RacetrackEnd
end

--- Handlers.
-- ===
--
-- *All Handler operations associated with Racetrack AI.*
--
-- ===
-- @section SPECTRE.AI

--- Set Airdrop Event Handlers for a Spawn Group.
--
--  @{SPECTRE.AI.setAirdropEventHandlers}
--
-- Configures event handlers for the given spawn group, reacting to dying events for airdrops.
-- The function sets up an event handler for the spawn group to manage the scenario where an airdrop dies.
-- It manages restocking through the provided manager and displays a message to the coalition when the airdrop is dead.
--
-- @param spawnGroup_ The spawn group to set the event handler for.
-- @param MANAGER The manager responsible for scheduling restocks.
-- @param Packet Packet data containing the Marker ID.
-- @param messageOnDead Message to display when the group is dead.
-- @return #spawnGroup_ The spawn group with the configured event handler.
-- @usage local airdropConfiguredGroup = SPECTRE.AI.setAirdropEventHandlers(spawnGroup, managerInstance, packetData, "Dead!")
function SPECTRE.AI.setAirdropEventHandlers(spawnGroup_, MANAGER, Packet, messageOnDead)
  spawnGroup_.WIPE_ = false

  -- Handle dead event for the spawn group
  spawnGroup_.onGroupCrashOrDead = function(_, eventData)
    local coal = eventData.IniCoalition
    if spawnGroup_:CountAliveUnits() == 0 and not spawnGroup_.WIPE_ then
      spawnGroup_.WIPE_ = true
      MESSAGE:New(messageOnDead, 20, "NOTICE"):ToCoalition(coal)

      -- Remove marker if it exists
      if Packet.MarkerID then
        SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)
      end

      -- Schedule restock
      MANAGER:scheduleRestock(coal, Packet.Type, Packet.subtype_)
    end
  end

  -- Set the event handler for the dead event
  spawnGroup_:HandleEvent(EVENTS.Dead, spawnGroup_.onGroupCrashOrDead)

  return spawnGroup_
end

--- configureGroup.
--
-- `Handles the configuration and setup for AI groups within the SPECTRE framework`.
--
--  Manages the configuration, behavior, and settings of AI groups within the SPECTRE framework.
--  This module ensures that AI entities operate according to predefined rules and can be adjusted dynamically.
--
--   * `Centralized configuration management for AI groups.`
--
--   * `Ensures consistent behavior and settings for AI entities.`
--
--   * `Provides utilities for dynamic AI group adjustments based on scenarios or player actions.`
--
-- @section SPECTRE.AI
-- @field #configureGroup
SPECTRE.AI.configureGroup = {}

--- Configure a CAP Group.
--
--  @{SPECTRE.AI.configureGroup.CAP}
--
-- Sets up a Combat Air Patrol (CAP) group by configuring common options, routing it, and adding event handlers.
-- This function provides a comprehensive setup for a CAP group, ensuring that it operates according to desired parameters and behaviors.
-- It combines the application of common configurations, route setting, and event handling for efficient group management.
--
-- @param MANAGER The manager responsible for various operations like restocking.
-- @param spawnGroup_ The spawn group to be configured for CAP.
-- @param route The route for the CAP.
-- @param Packet Packet data containing information like Marker ID.
-- @return #spawnGroup_ The configured spawn group for CAP.
-- @usage local capConfiguredGroup = SPECTRE.AI.configureGroup.CAP(managerInstance, spawnGroup, capRoute, packetData)
function SPECTRE.AI.configureGroup.CAP(MANAGER, spawnGroup_, route, Packet)
  -- Set common options for the spawn group
  spawnGroup_ = SPECTRE.AI.configureCommonOptions(spawnGroup_)

  -- Set the route for the CAP group
  spawnGroup_:Route(route, 0)

  -- Define messages for landing and dead events
  local messageOnLand = "A custom CAP flight has returned to base! Prepping new assets."
  local messageOnDead = "A custom CAP flight has been lost! Prepping new assets."

  -- Set common event handlers for the CAP group
  spawnGroup_ = SPECTRE.AI.setCommonEventHandlers(spawnGroup_, MANAGER, Packet, messageOnLand, messageOnDead)

  return spawnGroup_
end

--- Configure a Bomber Group.
--
--  @{SPECTRE.AI.configureGroup.BOMBER}
--
-- Sets up a bomber group by configuring common options, routing it, and adding event handlers, among other operations.
-- This function provides a detailed setup for a bomber group, ensuring that it operates with desired behaviors.
-- Key aspects of the setup include common configuration, route setting, waypoint tasks, periodic checks for ammunition,
-- and event handling for efficient group management.
--
-- @param MANAGER The manager responsible for various operations like restocking.
-- @param spawnGroup_ The bomber group to be configured.
-- @param route The route for the bomber.
-- @param Packet Packet data containing information like Marker ID.
-- @return The configured bomber group.
-- @usage local bomberConfiguredGroup = SPECTRE.AI.configureGroup.BOMBER(managerInstance, bomberGroup, bomberRoute, packetData)
function SPECTRE.AI.configureGroup.BOMBER(MANAGER, spawnGroup_, route, Packet)
  -- Set common options for the bomber group
  spawnGroup_ = SPECTRE.AI.configureCommonOptions(spawnGroup_)

  -- Define and set a task to delete the bomber group on reaching a waypoint
  local _DelTask = spawnGroup_:TaskFunction("SPECTREDeleteOnWP_", spawnGroup_)
  spawnGroup_:SetTaskWaypoint(route[#route], _DelTask)

  -- Set the route for the bomber group
  spawnGroup_:Route(route, 1)

  -- Schedule a periodic check for bomber ammunition
  spawnGroup_.ammocheck_  = SCHEDULER:New({spawnGroup_}, function()
    SPECTRE.UTILS.debugInfo("spawnGroup_.ammocheck_")
    if not spawnGroup_.InitTime then spawnGroup_.InitTime = os.time() end
    if spawnGroup_ then
      local BomberAmmo = spawnGroup_:GetAmmunition()
      if BomberAmmo == 0 or (os.time - spawnGroup_.InitTime  > 600) then
        MESSAGE:New("Bomber is Winchester. RTB for rearm and refuel.", 20, "NOTICE"):ToCoalition(Packet.coal)
        spawnGroup_:Destroy(false)
        spawnGroup_.ammocheck_:Stop()
        spawnGroup_.ammocheck_ = nil
        spawnGroup_ = nil
        collectgarbage()
        collectgarbage()
        SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)
        MANAGER:scheduleRestock(Packet.coal, Packet.Type)
      end
    end
  end, {}, 0, 60)

  -- Define messages for landing and dead events
  local messageOnLand = "Custom Bomber flight has returned to base! Prepping new assets."
  local messageOnDead = "Custom Bomber flight has been lost! Prepping more assets."

  -- Set common event handlers for the bomber group
  spawnGroup_ = SPECTRE.AI.setCommonEventHandlers(spawnGroup_, MANAGER, Packet, messageOnLand, messageOnDead)

  return spawnGroup_
end


--- Configure a Strike Group.
--
--  @{SPECTRE.AI.configureGroup.STRIKE}
--
-- Sets up a strike group by configuring common options, routing it, checking if it enters a specific zone, and adding event handlers.
-- This function manages the configuration and behavior of a strike group for precise operations.
-- Key aspects of the setup include common configuration, route setting, zone checks for target drops, and event handling.
-- It ensures that the strike group operates effectively, detecting when it enters a designated drop zone, and spawning the designated units at that location.
--
-- @param MANAGER The manager responsible for various operations like restocking.
-- @param spawnGroup_ The strike group to be configured.
-- @param route The route for the strike group.
-- @param Packet Packet data containing various information.
-- @return The configured strike group.
-- @usage local strikeConfiguredGroup = SPECTRE.AI.configureGroup.STRIKE(managerInstance, strikeGroup, strikeRoute, packetData)
function SPECTRE.AI.configureGroup.STRIKE(MANAGER, spawnGroup_, route, Packet)
  -- Set common options for the strike group
  spawnGroup_ = SPECTRE.AI.configureCommonOptions(spawnGroup_)

  -- Define and set a task to delete the strike group on reaching a waypoint
  local _DelTask = spawnGroup_:TaskFunction("SPECTREDeleteOnWP_", spawnGroup_)
  spawnGroup_:SetTaskWaypoint(route[#route], _DelTask)
  spawnGroup_:Route(route, 0)

  -- Create a zone around the target coordinate
  local ZoneDrop = ZONE_RADIUS:New(Packet.spawnGroupName, Packet.TargetCoord:GetVec2(), UTILS.NMToMeters(0.3))

  -- Schedule a periodic check to see if the strike group is inside the zone
  spawnGroup_.zonecheck_ = SCHEDULER:New({ZoneDrop}, function()
    if spawnGroup_:IsAlive() then
      if ZoneDrop and spawnGroup_:IsAnyInZone(ZoneDrop) then
        ZoneDrop = nil
        spawnGroup_.zonecheck_:Stop()
        spawnGroup_.zonecheck_ = nil
        collectgarbage()
        collectgarbage()

        local DroppedGroup = SPAWN:NewWithAlias(Packet.aliasDropped_, string.format(SPECTRE.MENU.Settings[Packet.Type].Units.AliasPrefix, Packet.tempCode))
          :InitCoalition(Packet.coal_)
          :InitCountry(Packet.country_)
          :SpawnFromVec2(Packet.TargetCoord:GetVec2())

        spawnGroup_:Destroy(false)
        MESSAGE:New("Strike Team deployment at " .. Packet.Coordinate_:ToStringMGRS() .. " successful! Resources replenished.", 20, "NOTICE"):ToCoalition(Packet.coal)
        SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)
        MANAGER:scheduleRestock(Packet.coal, Packet.Type)
      end
    else
      spawnGroup_.zonecheck_:Stop()
      spawnGroup_.zonecheck_ = nil
      collectgarbage()
      collectgarbage()
    end
  end, {}, 0, 5)

  -- Define messages for landing and dead events
  local messageOnLand = "LZ too hot! Strike team transport RTB!"
  local messageOnDead = "Strike team transport shot down before drop! Prepping new assets."

  -- Set common event handlers for the strike group
  spawnGroup_ = SPECTRE.AI.setCommonEventHandlers(spawnGroup_, MANAGER, Packet, messageOnLand, messageOnDead)

  return spawnGroup_
end

--- Configure an Airdrop Group.
--
--  @{SPECTRE.AI.configureGroup.AIRDROP}
--
-- Sets up an airdrop group by configuring common options, routing it, checking if it enters a specific zone, and adding event handlers.
-- This function is specifically tailored for airdrop groups, ensuring their successful deployment and subsequent behavior within the simulation.
-- It incorporates zone checks to determine the precise drop location, ensuring accurate delivery of the intended cargo or units.
--
-- @param MANAGER The manager responsible for various operations like restocking.
-- @param spawnGroup_ The airdrop group to be configured.
-- @param route The route for the airdrop group.
-- @param Packet Packet data containing various information.
-- @return The configured airdrop group.
-- @usage local airdropConfiguredGroup = SPECTRE.AI.configureGroup.AIRDROP(managerInstance, airdropGroup, airdropRoute, packetData)
function SPECTRE.AI.configureGroup.AIRDROP(MANAGER, spawnGroup_, route, Packet)
  -- Set common options for the airdrop group
  spawnGroup_ = SPECTRE.AI.configureCommonOptions(spawnGroup_)

  -- Define and set a task to delete the airdrop group on reaching a waypoint
  local _DelTask = spawnGroup_:TaskFunction("SPECTREDeleteOnWP_", spawnGroup_)
  spawnGroup_:SetTaskWaypoint(route[#route], _DelTask)
  spawnGroup_:Route(route, 0)

  -- Create a zone around the target coordinate
  local ZoneDrop = ZONE_RADIUS:New(Packet.spawnGroupName, Packet.TargetCoord:GetVec2(), UTILS.NMToMeters(0.3))

  -- Schedule a periodic check to see if the airdrop group is inside the zone
  spawnGroup_.zonecheck_ = SCHEDULER:New({ZoneDrop}, function()
    if spawnGroup_:IsAlive() then
      if ZoneDrop and spawnGroup_:IsAnyInZone(ZoneDrop) then
        ZoneDrop = nil
        spawnGroup_.zonecheck_:Stop()
        spawnGroup_.zonecheck_ = nil
        collectgarbage()
        collectgarbage()

        local DroppedGroup = SPAWN:NewWithAlias(Packet.aliasDropped_, string.format(SPECTRE.MENU.Settings[Packet.Type].Types[Packet.subtype_].AliasPrefix, Packet.tempCode))
          :InitCoalition(Packet.coal_)
          :InitCountry(Packet.country_)
          :OnSpawnGroup(function(DroppedGroup_)
            local messageOnDead = Packet.subtype_ .. " group destroyed! Prepping new assets."
            DroppedGroup_ = SPECTRE.AI.setAirdropEventHandlers(DroppedGroup_, MANAGER, Packet, messageOnDead)
          end)

        DroppedGroup:SpawnFromVec2(Packet.TargetCoord:GetVec2())
        spawnGroup_:Destroy(false)
        MESSAGE:New(Packet.subtype_ .. " airdrop at " .. Packet.Coordinate_:ToStringMGRS() .. " successful! Prepping new transport.", 20, "NOTICE"):ToCoalition(Packet.coal)
        SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)
      end
    else
      spawnGroup_.zonecheck_:Stop()
      spawnGroup_.zonecheck_ = nil
      collectgarbage()
      collectgarbage()
    end
  end, {}, 0, 5)

  -- Define messages for landing and dead events
  local messageOnLand = Packet.subtype_ .. " airdrop shot down before drop!"
  local messageOnDead = Packet.subtype_ .. " airdrop shot down before drop!"

  -- Set common event handlers for the airdrop group
  spawnGroup_ = SPECTRE.AI.setCommonEventHandlers(spawnGroup_, MANAGER, Packet, messageOnLand, messageOnDead)

  return spawnGroup_
end

--- buildWaypoints.
--
-- This namespace encompasses functions tailored to construct and define waypoints
-- for various AI operations. Waypoints are critical in guiding AI units along desired
-- paths or trajectories during their missions.
--
-- Key Features:
--
-- - Creates waypoints based on specific mission types and objectives.
-- - Allows for dynamic pathing, ensuring AI units can adapt to changing conditions or objectives.
-- - Ensures that AI units travel along optimal or strategic routes to their destinations.
-- - Supports various mission types, such as Combat Air Patrols, bombings, airdrops, and more.
-- - Integrates with other systems to gather context, ensuring waypoints are relevant and practical.
--
-- @section SPECTRE.buildWaypoints
-- @field #buildWaypoints
SPECTRE.AI.buildWaypoints = {}


--- Build CAP Waypoints.
--
--  @{SPECTRE.AI.buildWaypoints.CAP}
--
-- Constructs waypoints for a Combat Air Patrol (CAP) based on the data provided in the Packet.
-- This function is essential for defining the trajectory and behavior of CAP units within the simulation.
-- By specifying key parameters within the Packet, users can achieve desired CAP patterns and formations.
--
-- @param Packet Data packet containing various parameters needed for building waypoints.
-- @return Packet The Packet updated with the constructed waypoints.
-- @usage local updatedPacket = SPECTRE.AI.buildWaypoints.CAP(packetData)
function SPECTRE.AI.buildWaypoints.CAP(Packet)
  -- Set the CAP marker coordinate based on the provided coordinate and altitude
  Packet.Cap_Marker_Coord = COORDINATE:NewFromCoordinate(Packet.Coordinate_)
  Packet.Cap_Marker_Coord.y = Packet.Alt

  -- Prepare racetrack coordinates
  Packet.RacetrackStart, Packet.RacetrackEnd = SPECTRE.AI.prepareRacetrackCoords(Packet.Coordinate_, Packet.Alt, Packet.heading, Packet.distance, Packet.OFFSET)

  -- Generate a random spawn coordinate within a 5 NM radius from the airbase coordinate
  Packet.spawnCoord = Packet.airbaseCoord:GetRandomCoordinateInRadius(UTILS.NMToMeters(5))
  Packet.spawnCoord.y = Packet.Alt

  -- Calculate the waypoint inbound to the destination
  Packet.wptInboundToD = Packet.spawnCoord:Translate(UTILS.NMToMeters(5), Packet.spawnCoord:HeadingTo(Packet.RacetrackStart), true)
  Packet.wptInboundToD.y = Packet.Alt

  return Packet
end

--- Build Bomber Waypoints.
--
--  @{SPECTRE.AI.buildWaypoints.BOMBER}
--
-- Constructs waypoints for a bomber based on the data provided in the Packet.
-- This function is pivotal in defining the trajectory, altitude, and behavior of bomber units within the simulation.
-- It facilitates random and strategic waypoint generation, ensuring unpredictable and effective bombing routes.
--
-- @param Packet Data packet containing various parameters needed for building waypoints.
-- @return Packet The Packet updated with the constructed waypoints.
-- @usage local updatedPacket = SPECTRE.AI.buildWaypoints.BOMBER(packetData)
function SPECTRE.AI.buildWaypoints.BOMBER(Packet)


  -- Define a random cruise altitude between 45,000 and 55,000 feet in meters
  Packet.cruiseAlt = UTILS.FeetToMeters(math.random(45, 55) * 1000)

  -- Generate a random spawn coordinate within a 5 NM radius from the airbase coordinate and set its altitude to cruise altitude
  Packet.spawnCoord = Packet.airbaseCoord:GetRandomCoordinateInRadius(UTILS.NMToMeters(5))
  Packet.spawnCoord.y = Packet.cruiseAlt

  -- Set drop coordinate as the provided coordinate in the Packet and adjust its altitude to land height
  Packet.dropCoord = Packet.Coordinate_
  Packet.dropCoord.y = Packet.dropCoord:GetLandHeight()

  -- Define an initial point (IP) waypoint as the spawn coordinate and adjust its altitude
  Packet.wptIP = Packet.spawnCoord
  Packet.wptIP.y = 13716

  -- Calculate the 2D distance between the target and airbase
  Packet.distTgtToAirbase = Packet.airbaseCoord:Get2DDistance(Packet.dropCoord)

  -- Define an outbound waypoint to destination after the bomber drops its payload
  Packet.wptOutboundToD = Packet.airbaseCoord:Translate(math.min(UTILS.NMToMeters(40), Packet.distTgtToAirbase * 0.25), Packet.airbaseCoord:HeadingTo(Packet.dropCoord) + 10, true)
  Packet.wptOutboundToD.y = Packet.cruiseAlt

  return Packet
end

--- Build Bomber Waypoints.
--
--  @{SPECTRE.AI.buildWaypoints.BOMBER}
--
-- Constructs waypoints for a bomber based on the data provided in the Packet.
-- This function defines the trajectory, altitude, and behavior of bomber units within the simulation by generating waypoints.
-- It uses the parameters within the Packet for waypoint generation to ensure accurate and intended bomber routes.
--
-- @param Packet Data packet containing various parameters needed for building waypoints.
-- @return Packet The Packet updated with the constructed waypoints.
-- @usage local updatedPacket = SPECTRE.AI.buildWaypoints.BOMBER(packetData)
function SPECTRE.AI.buildWaypoints.STRIKE(Packet)


  -- Define a random cruise altitude between 200 and 300 feet in meters
  Packet.cruiseAlt = UTILS.FeetToMeters(math.random(200, 300))

  -- Generate a random spawn coordinate within a 0.5 NM radius from the airbase coordinate and set its altitude to cruise altitude
  Packet.spawnCoord = Packet.airbaseCoord:GetRandomCoordinateInRadius(UTILS.NMToMeters(0.5))
  Packet.spawnCoord.y = Packet.cruiseAlt

  -- Set the target coordinate as the provided coordinate in the Packet and adjust its altitude to a random value between 30 and 100 feet
  Packet.TargetCoord = Packet.Coordinate_
  Packet.TargetCoord.y = UTILS.FeetToMeters(math.random(30, 100))

  -- Define the coordinates for the first and second waypoints
  Packet.WPT1_coord = Packet.spawnCoord:Translate(UTILS.NMToMeters(5), Packet.spawnCoord:HeadingTo(Packet.TargetCoord), true)
  Packet.WPT1_coord.y = Packet.cruiseAlt
  Packet.WPT2_coord = Packet.TargetCoord:Translate(UTILS.NMToMeters(10), Packet.TargetCoord:HeadingTo(Packet.spawnCoord), true)
  Packet.WPT2_coord.y = Packet.TargetCoord.y

  -- Create the waypoints with the appropriate settings
  Packet.WPT1 = Packet.WPT1_coord:WaypointAir(COORDINATE.WaypointAltType.RADIO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.FlyoverPoint, UTILS.MpsToKmph(130), false)
  Packet.WPT_Target = Packet.TargetCoord:WaypointAir(COORDINATE.WaypointAltType.RADIO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.FlyoverPoint, UTILS.MpsToKmph(130), false)
  Packet.WPT2 = Packet.WPT2_coord:WaypointAir(COORDINATE.WaypointAltType.RADIO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.TurningPoint, UTILS.MpsToKmph(130), false)

  return Packet
end

--- Build Airdrop Waypoints.
--
--  @{SPECTRE.AI.buildWaypoints.AIRDROP}
--
-- Constructs waypoints for an airdrop mission based on the data provided in the Packet.
-- This function uses the data in the Packet to define the trajectory, altitude, and sequence of waypoints for an airdrop mission.
-- The waypoints ensure the airdrop group follows the intended path and performs airdrop operations at the designated locations.
--
-- @param Packet Data packet containing various parameters needed for building waypoints.
-- @return Packet The Packet updated with the constructed waypoints.
-- @usage local updatedPacket = SPECTRE.AI.buildWaypoints.AIRDROP(packetData)
function SPECTRE.AI.buildWaypoints.AIRDROP(Packet)


  -- Define a random cruise altitude between 15,000 and 25,000 feet in meters
  Packet.cruiseAlt = UTILS.FeetToMeters(math.random(15, 25) * 1000)

  -- Generate a random spawn coordinate within a 5 NM radius from the airbase coordinate and set its altitude to cruise altitude
  Packet.spawnCoord = Packet.airbaseCoord:GetRandomCoordinateInRadius(UTILS.NMToMeters(5))
  Packet.spawnCoord.y = Packet.cruiseAlt

  -- Set the target coordinate as the provided coordinate in the Packet and adjust its altitude to a random value between 2,000 and 5,000 feet
  Packet.TargetCoord = Packet.Coordinate_
  Packet.TargetCoord.y = UTILS.FeetToMeters(math.random(2, 5) * 1000)

  -- Define the coordinates for the first and second waypoints
  Packet.WPT1_coord = Packet.spawnCoord:Translate(UTILS.NMToMeters(5), Packet.spawnCoord:HeadingTo(Packet.TargetCoord), true)
  Packet.WPT1_coord.y = Packet.cruiseAlt
  Packet.WPT2_coord = Packet.TargetCoord:Translate(UTILS.NMToMeters(10), Packet.TargetCoord:HeadingTo(Packet.spawnCoord), true)
  Packet.WPT2_coord.y = Packet.TargetCoord.y

  -- Create the waypoints with the appropriate settings
  Packet.WPT1 = Packet.WPT1_coord:WaypointAir(COORDINATE.WaypointAltType.BARO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.FlyoverPoint, UTILS.MpsToKmph(300), false)
  Packet.WPT_Target = Packet.TargetCoord:WaypointAir(COORDINATE.WaypointAltType.BARO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.FlyoverPoint, UTILS.MpsToKmph(300), false)
  Packet.WPT2 = Packet.WPT2_coord:WaypointAir(COORDINATE.WaypointAltType.BARO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.TurningPoint, UTILS.MpsToKmph(300), false)

  return Packet
end

--- buildPacket.
--
-- This namespace encompasses functions responsible for assembling data packets
-- essential for AI operations. These packets contain vital information required
-- by the AI to execute their missions accurately.
--
-- Key Features:
--
-- - Gathers and organizes data from various inputs, such as markers and player details.
-- - Provides a standardized structure for data that AI operations can readily interpret.
-- - Supports a wide range of operations, including Combat Air Patrols, bombings, and airdrops.
-- - Ensures that AI units have all the necessary context for their tasks, such as target locations, routes, and potential threats.
--
-- @section SPECTRE.AI
-- @field #buildPacket
SPECTRE.AI.buildPacket = {}


--- Determine Nearest Airbase Values for Packet.
--
--  @{SPECTRE.AI.buildPacket.determineNearestAirbaseValues}
--
-- Finds the closest airbase to the provided coordinate in the Packet and updates the Packet with the airbase's information.
-- The function evaluates the available airbases based on the provided target coordinates and coalition information to determine the optimal airbase.
-- This ensures effective deployment and routing of units based on their proximity to their intended operational area.
--
-- @param Packet Data packet containing various parameters including the target coordinate.
-- @return Packet The Packet updated with the nearest airbase's information.
-- @usage local updatedPacket = SPECTRE.AI.buildPacket.determineNearestAirbaseValues(packetData)
function SPECTRE.AI.buildPacket.determineNearestAirbaseValues(Packet)
  -- Extract the Vec2 representation of the target coordinate from the Packet
  Packet.markerVec2 = Packet.Coordinate_:GetVec2()

  -- Find the nearest airbase to the target coordinate for the specified coalition
  Packet.NearestAirbase = SPECTRE.WORLD.ClosestAirfieldVec2(Packet.coal, Packet.markerVec2)

  -- Extract the airbase's name and coordinate
  Packet.airbaseName = Packet.NearestAirbase.Name
  Packet.airbaseCoord = COORDINATE:NewFromVec3(Packet.NearestAirbase.Vec3)

  -- Debug information
  SPECTRE.UTILS.debugInfo("Packet", Packet)

  return Packet
end

--- Determine Marker Values for Packet.
--
--  @{SPECTRE.AI.buildPacket.determineMarkerValues}
--
-- Fetches details about a specific marker related to the provided Player and updates the Packet with relevant information.
-- The function extracts marker details based on the specified player and marker index. This ensures accurate retrieval and utilization of marker information for further operational decisions.
--
-- @param Packet Data packet to be updated with marker details.
-- @param Player Player object containing marker information.
-- @param MarkerIndex Index of the marker in the Player's marker arrays.
-- @return Packet The Packet updated with the marker's information.
-- @usage local updatedPacket = SPECTRE.AI.buildPacket.determineMarkerValues(packetData, somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)
  -- Fetch and store marker details from the Player's marker arrays using the provided index
  Packet.markerArray = Player.Markers[Packet.Type].MarkerArrays[MarkerIndex]
  Packet.Coordinate_ = Packet.markerArray.MarkCoords
  Packet.descriptor = Packet.markerArray.descriptor
  Packet.RequestingUnit = Player.name
  Packet.code = Packet.markerArray.code
  Packet.coal = Player.side
  Packet.MarkerID = Packet.markerArray.PermMarkerID

  -- Debug information
  SPECTRE.UTILS.debugInfo("Packet", Packet)

  return Packet
end

--- Determine AI Coalition Values for Packet.
--
--  @{SPECTRE.AI.buildPacket.determineAICoalitionValues}
--
-- Determines AI's coalition, country, and alias based on the player's coalition and the type of operation.
-- The function identifies the appropriate coalition, country, and template alias values for AI-controlled units. These determinations are based on the player's side and the specific type of operation, ensuring the AI behaves appropriately in context.
--
-- @param Packet Data packet containing the player's coalition and the operation type.
-- @return Packet The Packet updated with the AI's coalition values.
-- @usage local updatedPacket = SPECTRE.AI.buildPacket.determineAICoalitionValues(packetData)
function SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)
  -- Debug information
  SPECTRE.UTILS.debugInfo("Packet", Packet)
  SPECTRE.UTILS.debugInfo("Packet.Type", Packet.Type)
  SPECTRE.UTILS.debugInfo("Packet.subtype_", Packet.subtype_)

  local PlayerSide = Packet.coal
  local Type = Packet.Type
  local coal_, country_, alias_, aliasDropped_

  -- Define values based on player's coalition
  --  if PlayerSide == 1 then
  --    coal_ = SPECTRE.Coalitions.Red
  --    country_ = SPECTRE.Countries.Red
  --    alias_ = SPECTRE.MENU.Settings[Type].TemplateName.Red or "ALIAS_"
  --  else
  --    coal_ = SPECTRE.Coalitions.Blue
  --    country_ = SPECTRE.Countries.Blue
  --    alias_ = SPECTRE.MENU.Settings[Type].TemplateName.Blue or "ALIAS_"
  --  end


  -- Define specific alias values for STRIKE and AIRDROP types
  if Type == "STRIKE" then
    alias_ = PlayerSide == 1 and SPECTRE.MENU.Settings[Type].Transport.TemplateName.Red or SPECTRE.MENU.Settings[Type].Transport.TemplateName.Blue
    aliasDropped_ = PlayerSide == 1 and SPECTRE.MENU.Settings[Type].Units.TemplateName.Red or SPECTRE.MENU.Settings[Type].Units.TemplateName.Blue
  elseif Type == "AIRDROP" then
    alias_ = PlayerSide == 1 and SPECTRE.MENU.Settings[Type].TemplateName.Red or SPECTRE.MENU.Settings[Type].TemplateName.Blue
    aliasDropped_ = PlayerSide == 1 and SPECTRE.MENU.Settings[Type].Types[Packet.subtype_].TemplateName.Red or SPECTRE.MENU.Settings[Type].Types[Packet.subtype_].TemplateName.Blue
  else
    alias_ = PlayerSide == 1 and SPECTRE.MENU.Settings[Type].TemplateName.Red or SPECTRE.MENU.Settings[Type].TemplateName.Blue
  end
  coal_ = PlayerSide == 1 and SPECTRE.Coalitions.Red or SPECTRE.Coalitions.Blue
  country_ = PlayerSide == 1 and SPECTRE.Countries.Red or SPECTRE.Countries.Blue
  -- Update the Packet with the determined values
  Packet.coal_ = coal_
  Packet.country_ = country_
  Packet.alias_ = alias_
  Packet.aliasDropped_ = aliasDropped_

  -- Debug information
  SPECTRE.UTILS.debugInfo("Packet", Packet)

  return Packet
end

--- Build CAP Packet.
--
-- Constructs a data packet for the Combat Air Patrol (CAP) scenario based on the provided player and marker index.
-- The function gathers and organizes information necessary for setting up a CAP mission. This includes determining the nearest airbase to the target, the coalition details for the AI units, and the appropriate waypoints for the mission.
--
-- @param Player The player object.
-- @param MarkerIndex Index of the marker for which the CAP packet is to be built.
-- @return route The constructed CAP data packet.
-- @usage local capPacket = SPECTRE.AI.buildPacket.CAP(somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.CAP(Player, MarkerIndex)
  -- Initial default values for the Packet
  local Packet = {
    Type = "CAP",
    OFFSET = 1,
    Zone_Engage = 92600
  }

  -- Local function to calculate distance based on provided initial distance.
  local function calculateDistance(initialDistance)
    if initialDistance and initialDistance > 20 then
      return (initialDistance - 14) / 2
    end
    return initialDistance and (initialDistance / 2) or nil
  end

  -- Fetch and store marker details
  Packet = SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)

  -- Determine the nearest airbase and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineNearestAirbaseValues(Packet)

  -- Determine AI coalition values and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)

  -- Calculate heading and distance based on the marker's values
  Packet.heading = Packet.markerArray.heading and (((Packet.markerArray.heading % 360) + 360) % 360) or nil
  Packet.distance = calculateDistance(Packet.markerArray.distance)

  -- Define altitude and speed for the CAP
  Packet.Alt = UTILS.FeetToMeters(UTILS.Randomize(30000, 0.15))
  Packet.speed = UTILS.KnotsToMps(485)

  -- Build waypoints for the CAP and update the Packet
  Packet = SPECTRE.AI.buildWaypoints.CAP(Packet)

  return Packet
end

--- Build TOMAHAWK Packet.
--
-- Constructs a data packet for the Tomahawk missile scenario based on the provided player and marker index.
-- This function gathers and organizes information necessary for setting up a Tomahawk missile launch. This includes extracting marker details from the player's data and determining coalition details for the AI units.
--
-- @param Player The player object.
-- @param MarkerIndex Index of the marker for which the TOMAHAWK packet is to be built.
-- @return route The constructed TOMAHAWK data packet.
-- @usage local tomahawkPacket = SPECTRE.AI.buildPacket.TOMAHAWK(somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.TOMAHAWK(Player, MarkerIndex)
  -- Initial default value for the Packet
  local Packet = {
    Type = "TOMAHAWK"
  }

  -- Fetch and store marker details
  Packet = SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)

  -- Determine AI coalition values and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)

  return Packet
end

--- Build BOMBER Packet.
--
-- Constructs a data packet for the bomber scenario based on the provided player and marker index.
-- This function aggregates and arranges information necessary for configuring a bomber mission. It gathers marker details from the player's data, determines the nearest airbase, specifies coalition details for the AI units, and prepares the bombing task details.
--
-- @param Player The player object.
-- @param MarkerIndex Index of the marker for which the BOMBER packet is to be built.
-- @return route The constructed BOMBER data packet.
-- @usage local bomberPacket = SPECTRE.AI.buildPacket.BOMBER(somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.BOMBER(Player, MarkerIndex)


  -- Initial default value for the Packet
  local Packet = {
    Type = "BOMBER"
  }

  -- Local function to calculate distance based on provided initial distance.
  local function calculateDistance(initialDistance)
    if initialDistance and initialDistance > 20 then
      return (initialDistance - 14) / 2
    end
    return initialDistance and (initialDistance / 2) or nil
  end

  -- Fetch and store marker details
  Packet = SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)

  -- Determine the nearest airbase and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineNearestAirbaseValues(Packet)

  -- Determine AI coalition values and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)

  -- Build waypoints for the bomber and update the Packet
  Packet = SPECTRE.AI.buildWaypoints.BOMBER(Packet)

  -- Define bombing task for the bomber
  Packet.bombTask = {
    id = 'CarpetBombing',
    params = {
      point            = Packet.dropCoord:GetVec2(),
      x                = Packet.dropCoord:GetVec2().x,
      y                = Packet.dropCoord:GetVec2().y,
      groupAttack      = true,
      expend           = AI.Task.WeaponExpend.ALL,
      attackQtyLimit   = false,
      attackQty        = 1,
      directionEnabled = true,
      direction        = math.rad(math.random(360)),
      altitudeEnabled  = true,
      altitude         = UTILS.FeetToMeters(40000),
      weaponType       = 2147485680,
      attackType       = "Carpet",
      carpetLength     = 200, -- 100 meters if precise strike, otherwise 500 meters
    },
  }

  return Packet
end

--- Build STRIKE Packet.
--
-- Constructs a data packet for the strike scenario based on the provided player and marker index.
-- This function gathers necessary information for creating a strike mission. It fetches marker details from the player's data, determines the nearest airbase, sets coalition details for the AI units, and configures the waypoints for the strike mission.
--
-- @param Player The player object.
-- @param MarkerIndex Index of the marker for which the STRIKE packet is to be built.
-- @return route The constructed STRIKE data packet.
-- @usage local strikePacket = SPECTRE.AI.buildPacket.STRIKE(somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.STRIKE(Player, MarkerIndex)
  -- Initial default value for the Packet
  local Packet = {
    Type = "STRIKE"
  }

  -- Fetch and store marker details
  Packet = SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)

  -- Determine the nearest airbase and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineNearestAirbaseValues(Packet)

  -- Determine AI coalition values and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)

  -- Store the code as a temporary variable
  Packet.tempCode = Packet.code

  -- Ensure the generated group name is unique
  local FoundGroup
  repeat
    FoundGroup = GROUP:FindByName(SPECTRE.MENU.Settings[Packet.Type].Units.AliasPrefix .. Packet.tempCode .. "#001")
    if FoundGroup then
      Packet.tempCode = Packet.tempCode + 1
    else
      FoundGroup = false
    end
  until (FoundGroup == false)

  -- Build waypoints for the strike and update the Packet
  Packet = SPECTRE.AI.buildWaypoints.STRIKE(Packet)

  -- Set the group name for spawning
  Packet.spawnGroupName = string.format(SPECTRE.MENU.Settings[Packet.Type].Transport.AliasPrefix, Packet.code)

  return Packet
end

--- Build AIRDROP Packet.
--
-- Constructs a data packet for the airdrop scenario based on the given player and marker index.
-- This function compiles essential information to initiate an airdrop mission. It extracts marker details from the player's data, identifies the nearest airbase, sets the AI units' coalition details, and designs the waypoints for the airdrop mission.
--
-- @param Player The player object.
-- @param MarkerIndex Index of the marker for which the AIRDROP packet is to be constructed.
-- @return route The constructed AIRDROP data packet.
-- @usage local airdropPacket = SPECTRE.AI.buildPacket.AIRDROP(somePlayer, markerIdx)
function SPECTRE.AI.buildPacket.AIRDROP(Player, MarkerIndex)
  -- Initialize default values for the Packet
  local Packet = {
    Type = "AIRDROP"
  }

  -- Retrieve and store marker details
  Packet = SPECTRE.AI.buildPacket.determineMarkerValues(Packet, Player, MarkerIndex)

  -- Extract the subtype from the marker array
  Packet.subtype_ = Packet.markerArray.Packet.MarkerType[2]

  -- Determine the closest airbase and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineNearestAirbaseValues(Packet)

  -- Define AI coalition values and update the Packet
  Packet = SPECTRE.AI.buildPacket.determineAICoalitionValues(Packet)

  -- Store the code in a temporary variable
  Packet.tempCode = Packet.code

  -- Ensure the group name is unique
  local FoundGroup
  repeat
    FoundGroup = GROUP:FindByName(SPECTRE.MENU.Settings[Packet.Type].Types[Packet.subtype_].AliasPrefix .. Packet.tempCode .. "#001")
    if FoundGroup then
      Packet.tempCode = Packet.tempCode + 1
    else
      FoundGroup = false
    end
  until (FoundGroup == false)

  -- Construct waypoints for the airdrop and update the Packet
  Packet = SPECTRE.AI.buildWaypoints.AIRDROP(Packet)

  -- Define the group name for spawning
  Packet.spawnGroupName = string.format(SPECTRE.MENU.Settings.AIRDROP.AliasPrefix, Packet.code)

  return Packet
end

--- buildRoute.
--
-- This namespace houses functions dedicated to the construction of routes
-- for various AI operations. The primary purpose is to generate waypoints
-- and define specific paths that AI units will follow during their missions.
--
-- Key Characteristics:
--
-- - Handles a range of paths from simple direct routes to complex mission patterns.
-- - Supports operations such as CAP orbits, bombing runs, and airdrop missions.
-- - Utilizes parameters like mission type, target location, and potential threats.
-- - Ensures AI units can efficiently and safely execute their designated tasks.
--
-- @section SPECTRE.buildRoute
-- @field #buildRoute
SPECTRE.AI.buildRoute = {}


--- Build CAP Route.
--
-- Constructs a route for Combat Air Patrol (CAP) operations based on the given group and packet.
-- This function defines the waypoints and tasks for a CAP operation.
-- It sets the aircraft to orbit a specified racetrack while being ready to engage targets within a designated zone.
--
-- @param spawnGroup_ The group for which the CAP route is to be constructed.
-- @param Packet The data packet containing details for route construction.
-- @return route The constructed CAP route.
-- @usage local capRoute = SPECTRE.AI.buildRoute.CAP(someGroup, somePacket)
function SPECTRE.AI.buildRoute.CAP(spawnGroup_, Packet)

  -- Define altitude based on the inbound waypoint's altitude
  local Alt = Packet.wptInboundToD.y

  -- Create enroute tasks to engage targets in the specified zone
  local enroutetasks = {
    spawnGroup_:EnRouteTaskEngageTargetsInZone(Packet.Cap_Marker_Coord:GetVec2(), Packet.Zone_Engage, {"Air"})
  }

  -- Define the waypoints for the route
  local route = {
    -- Inbound waypoint to the designated area
    Packet.wptInboundToD:WaypointAir(COORDINATE.WaypointAltType.BARO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.FlyoverPoint, UTILS.MpsToKmph(Packet.speed), false),
    -- Start of the racetrack orbit
    Packet.RacetrackStart:WaypointAir(COORDINATE.WaypointAltType.BARO, COORDINATE.WaypointType.TurningPoint, COORDINATE.WaypointAction.TurningPoint, UTILS.MpsToKmph(Packet.speed), false)
  }

  -- Assign the enroute tasks to each waypoint in the route
  for _, r in ipairs(route) do
    r.task = spawnGroup_:TaskCombo(enroutetasks)
  end

  -- Define tasks for the aircraft to orbit the racetrack and engage targets in the zone
  local tasks = {
    spawnGroup_:TaskOrbit(Packet.RacetrackStart, Alt, Packet.speed, Packet.RacetrackEnd),
    spawnGroup_:EnRouteTaskEngageTargetsInZone(Packet.Cap_Marker_Coord:GetVec2(), Packet.Zone_Engage, {"Air"})
  }

  -- Assign the combined tasks to the last waypoint in the route
  route[#route].task = spawnGroup_:TaskCombo(tasks)

  return route
end

--- Build Bomber Route.
--
-- Constructs a route for bomber operations based on the given group and packet.
-- This function defines the waypoints for the bomber, including the ingress and egress points of its bombing run.
--
-- @param spawnGroup_ The group for which the bomber route is to be constructed.
-- @param Packet The data packet containing details for route construction.
-- @return route The constructed bomber route.
-- @usage local bomberRoute = SPECTRE.AI.buildRoute.BOMBER(someGroup, somePacket)
function SPECTRE.AI.buildRoute.BOMBER(spawnGroup_, Packet)

  -- Define the waypoints for the route
  local route = {
    -- Initial Point (IP) or ingress point for the bomber to begin its attack run
    Packet.wptIP:WaypointAirTurningPoint(COORDINATE.WaypointAltType.BARO, UTILS.KnotsToKmph(550), {Packet.bombTask}, "Attack Ingress"),
    -- Outbound waypoint or end point after the attack is completed
    Packet.wptOutboundToD:WaypointAirTurningPoint(COORDINATE.WaypointAltType.BARO, UTILS.KnotsToKmph(550), {}, "End Mission")
  }

  return route
end

--- Build Strike Route.
--
-- Constructs a simple route for strike operations based on the information provided in the `Packet` parameter.
--
-- @param spawnGroup_ The group for which the strike route is to be constructed.
-- @param Packet The data packet containing details for route construction.
-- @return route The constructed strike route.
-- @usage local strikeRoute = SPECTRE.AI.buildRoute.STRIKE(someGroup, somePacket)
function SPECTRE.AI.buildRoute.STRIKE(spawnGroup_, Packet)

  -- Define the waypoints for the strike route
  local route = {
    -- Initial waypoint for the strike group
    Packet.WPT1,
    -- Waypoint at the target location
    Packet.WPT_Target,
    -- Waypoint after the target location
    Packet.WPT2
  }

  return route
end

--- Build Airdrop Route.
--
-- Constructs a simple route for airdrop operations based on the information provided in the `Packet` parameter.
--
-- @param spawnGroup_ The group that will execute the airdrop operation.
-- @param Packet The data packet containing details for route construction.
-- @return route The constructed airdrop route.
-- @usage local airdropRoute = SPECTRE.AI.buildRoute.AIRDROP(someGroup, somePacket)
function SPECTRE.AI.buildRoute.AIRDROP(spawnGroup_, Packet)

  -- Define the waypoints for the airdrop route
  local route = {
    -- Initial waypoint for the airdrop group
    Packet.WPT1,
    -- Waypoint at the airdrop target location
    Packet.WPT_Target,
    -- Waypoint after the airdrop target location
    Packet.WPT2
  }

  return route
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **BRAIN**
--
-- The brain of SPECTRE, allowing the game to interpret various units positioning and data with ML strategies.
--
-- Contains methods for easily interpreting and persisting data.
--
-- @module BRAIN
-- @extends SPECTRE

--- SPECTRE.BRAIN.
--
-- The brain of SPECTRE, allowing the game to interpret various units positioning and data with ML strategies.
--
-- Contains methods for easily interpreting and persisting data.
--
-- @field #BRAIN
SPECTRE.BRAIN = {}

--- Persistence.
-- ===
--
-- *All Functions commonly associated with AI operations.*
--
-- ===
-- @section SPECTRE.BRAIN

--- Checks for the existence of a persistence file and manages object persistence.
--
-- This function handles the persistence of objects, checking for existing persistence files and loading them if present.
-- If the file is not found, or if the function is forced to bypass loading, it will run a specified input function on the object.
-- After processing the input function, if persistence is enabled and the object was not previously loaded, the function saves
-- the object to the persistence file. This functionality is essential for maintaining consistent state across game sessions or reloads.
--
-- @param _filename The filename and path of the persistence file, relative to saved games mission folder.
-- @param force A boolean flag indicating whether to force bypass the loading of an existing file.
-- @param _Object The object to be checked and potentially persisted.
-- @param _persistence A boolean flag indicating whether persistence is enabled.
-- @param _InputFunction The function to be executed on the object if the persistence file does not exist or is bypassed.
-- @param ... Additional parameters to be passed to the _InputFunction.
-- @return _Object The object after loading from a persistence file or processing through the _InputFunction.
-- @usage  Example:
--
--             self.FILLSPAWNERS[_Randname] = SPECTRE.BRAIN.checkAndPersist(
--              _filename,
--              force,
--              self.FILLSPAWNERS[_Randname],
--              self._persistence,
--              function(_Object)  -- Update: Include _Object as a parameter
--                return self._CreateSpawnerTemplate(_SPWNR, _Object)  -- Update: Pass _Object to the new function
--              end
--            )
--  where
--
--            function SPECTRE.ZONEMGR._CreateSpawnerTemplate(_SPWNR, _Object)
--              -- Update _Object with the new template and return it
--              _Object = SPECTRE.UTILS.templateFromObject(_SPWNR)
--              return _Object
--            end
-- @usage local persistedObject = SPECTRE.BRAIN.checkAndPersist("path/to/file", false, myObject, true, function(obj) return modifyObject(obj) end)
function SPECTRE.BRAIN.checkAndPersist(_filename, force, _Object, _persistence, _InputFunction, ...)
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | PERSISTENCE  | ----------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | PATH         | " .. tostring(_filename))
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | Force        | " .. tostring(force))
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | _persistence | " .. tostring(_persistence))
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | _Object      | " , _Object)

  force = force or false
  local loaded = false

  -- Check for existing persistence files and load if present
  if _persistence and not force then
    if SPECTRE.IO.file_exists(_filename) then
      _Object = SPECTRE.IO.PersistenceFromFile(_filename)
      loaded = true
    end
  end

  -- If object is loaded, return it
  if loaded then
    SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | PERSISTENCE  | LOADED EXISTING")
    SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | LOAD _Object | " , _Object)
    return _Object
  else

    if _InputFunction then
      -- Run the input function with parameters
      _Object = _InputFunction(_Object, ...)
    end
    -- Save the object if persistence is enabled and object was not loaded
    if _persistence and not loaded then
      SPECTRE.IO.PersistenceToFile(_filename, _Object)
      SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.checkAndPersist | PERSISTENCE  | NOT FOUND, SAVING NEW")
    end
  end

  return _Object
end


--- x - Watchers.
-- ===
--
-- *All watchers.*
--
-- ===
-- @section SPECTRE.BRAIN


--- Builds a watcher on a table to monitor changes to a specific key.
--
-- This function iterates through each key-value pair in a provided table and sets up a proxy table with a metatable to watch changes. 
-- The proxy uses metatable magic to intercept changes to a specific key. 
-- When a change to the specified key is detected, a watcher function is called with additional arguments if provided. 
-- This is useful for monitoring changes to a table and triggering specific actions when those changes occur.
--
-- @param table_ The table on which the watcher is to be set.
-- @param key_ The key in the table to monitor for changes.
-- @param watcherFunction The function to call when a change to the specified key is detected.
-- @param ... Additional arguments to pass to the watcherFunction.
-- @usage SPECTRE.BRAIN:buildWatcher(myTable, "myKey", function(key, value) print("Key " .. key .. " changed to " .. value) end)
function SPECTRE.BRAIN:buildWatcher(table_, key_, watcherFunction, ...)
  local extraArgs = {...}  -- Capture extra arguments in a table

  for tableKey_, tableValue_ in pairs(table_) do
    local proxy = {
      __actualValue = tableValue_  -- Store actual value
    }

    setmetatable(proxy, {
      __index = function(t, k)
        return t.__actualValue[k]  -- Access actual value
      end,
      
      __newindex = function(t, k, v)
        if k == key_ then
          -- Call the watcher function with extra arguments
          watcherFunction(tableKey_, v, unpack(extraArgs))
        end
        t.__actualValue[k] = v  -- Modify actual value
      end
    })

    table_[tableKey_] = proxy  -- Replace original value with the proxy
  end
end

--- x - Machine Learning.
-- ===
--
-- *Machine Learning algorithms.*
--
-- ===
-- @section SPECTRE.BRAIN


SPECTRE.BRAIN.DBSCANNER = {}
SPECTRE.BRAIN.DBSCANNER.params = {}
SPECTRE.BRAIN.DBSCANNER._DBScan = {}
SPECTRE.BRAIN.DBSCANNER.Clusters = {}
SPECTRE.BRAIN.DBSCANNER.Points = {}
SPECTRE.BRAIN.DBSCANNER.numPoints = 1
SPECTRE.BRAIN.DBSCANNER.f = 2
SPECTRE.BRAIN.DBSCANNER.p = 0.1
SPECTRE.BRAIN.DBSCANNER.epsilon = 0
SPECTRE.BRAIN.DBSCANNER.min_samples = 0
SPECTRE.BRAIN.DBSCANNER.Area = 0
SPECTRE.BRAIN.DBSCANNER._RadiusExtension = 0

--- Constructs a new DBSCANNER object.
--
-- This function initializes a new DBSCANNER object with specified parameters. 
-- It sets up the points, area, and radius extension for the DBSCAN algorithm. 
-- It also calls 'generateDBSCANparams' to calculate necessary parameters for the DBSCAN process.
--
-- @param Points An array of points for the DBSCAN algorithm.
-- @param Area The area to be considered for the DBSCAN algorithm.
-- @param RadiusExtension The radius extension value for the DBSCAN calculations.
-- @return self The newly created DBSCANNER object.
-- @usage local dbscanner = SPECTRE.BRAIN.DBSCANNER:New(pointsArray, areaValue, radiusExtension)
function SPECTRE.BRAIN.DBSCANNER:New(Points, Area, RadiusExtension)
  local self=BASE:Inherit(self, SPECTRE:New())
  self.Points = Points
  self.numPoints = #Points
  self.Area = Area
  self._RadiusExtension = RadiusExtension or 0
  self:generateDBSCANparams()
  return self
end

--- Generates parameters for the DBSCAN algorithm based on the object's attributes.
--
-- This function calculates 'epsilon' and 'min_samples' for the DBSCAN algorithm, based on:
-- the number of points, the area, and specific factors 'f' and 'p'
-- It updates the object with these calculated values. 
--
-- @return self The updated DBSCANNER object with newly calculated parameters.
-- @usage dbscanner:generateDBSCANparams() -- Updates the 'dbscanner' object with DBSCAN parameters.
function SPECTRE.BRAIN.DBSCANNER:generateDBSCANparams()
  -- Initial calculations
  local n = self.numPoints
  self.epsilon = self.f * math.sqrt(self.Area / n)
  self.min_samples = math.ceil(self.p * n)

  -- Debug information consolidated
  SPECTRE.UTILS.debugInfo("SPECTRE.BRAIN.DBSCANNER:generateDBSCANparams | ------------------------\n" ..
    "| NumUnits    | " .. n .. "\n" ..
    "| ZoneArea    | " .. self.Area .. "\n" ..
    "| f           | " .. self.f .. "\n" ..
    "| p           | " .. self.p .. "\n" ..
    "| epsilon     | " .. self.epsilon .. "\n" ..
    "| min_samples | " .. self.min_samples)

  return self
end

--- Executes the DBSCAN clustering algorithm and post-processes the clusters.
--
-- This function initiates the DBSCAN clustering process by calling '_DBScan' and then performs post-processing on the clusters formed. 
-- It structures the scanning process and post-processing as a sequence of operations on the DBSCANNER object.
--
-- @return self The DBSCANNER object after completing the scan and post-processing steps.
-- @usage dbscanner:Scan() -- Performs the DBSCAN algorithm and post-processes the results.
function SPECTRE.BRAIN.DBSCANNER:Scan()
  self:_DBScan()
  self:post_process_clusters()
  return self
end

--- Core function of the DBSCAN algorithm for clustering points.
--
-- This internal function implements the DBSCAN clustering algorithm. 
-- It initializes each point as unmarked, then iterates through each point to determine if it is a core point and expands clusters accordingly. 
-- Points are marked as either part of a cluster or as noise.
--
-- @return self The DBSCANNER object with updated clustering information.
-- @usage dbscanner:_DBScan() -- Directly performs the DBSCAN clustering algorithm.
function SPECTRE.BRAIN.DBSCANNER:_DBScan()
  -- Initialization
  local UNMARKED, NOISE = 0, -1
  local cluster_id = 0
  self._DBScan = {}
  -- Mark all units as unmarked initially
  for _, unit in ipairs(self.Points) do
    self._DBScan[unit.unit] = UNMARKED
  end
  -- Main clustering loop
  for _, unit in ipairs(self.Points) do
    if self._DBScan[unit.unit] == UNMARKED then
      local neighbors = self:region_query(unit)
      if #neighbors < self.min_samples then
        self._DBScan[unit.unit] = NOISE
      else
        cluster_id = cluster_id + 1
        self:expand_cluster(unit, neighbors, cluster_id)
      end
    end
  end
  return self
end

--- Identifies neighboring points within a specified epsilon distance of a given point.
--
-- This function searches for neighbors of a given 'point' within the 'epsilon' radius. 
-- It utilizes a private function '_distance' to calculate the Euclidean distance between points. 
-- The function is used within the DBSCAN algorithm to find points in the epsilon neighborhood of a given point.
--
-- @param point The point around which neighbors are to be found.
-- @return neighbors A list of neighboring points within the epsilon distance of the given point.
-- @usage local neighbors = dbscanner:region_query(specificPoint) -- Finds neighbors of 'specificPoint'.
function SPECTRE.BRAIN.DBSCANNER:region_query(point)
  local function _distance(point1, point2)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = point1.x - point2.x
    local dy = point1.y - point2.y

    -- Use the Pythagorean theorem to compute the distance
    return math.sqrt(dx^2 + dy^2)
  end
  -- Debug information consolidated
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:region_query | --------------------------------------------\n" ..
    "| point       | ", point)

  local neighbors = {}
  -- Iterate through detected units and find neighbors within the epsilon distance
  for _, unit in ipairs(self.Points) do
    if _distance(point.vec2, unit.vec2) < self.epsilon then
      table.insert(neighbors, unit)
    end
  end
  return neighbors
end

--- Expands a cluster around a given point based on its neighbors and a specified cluster ID.
--
-- This function adds a given point and its neighbors to a cluster identified by 'cluster_id'. 
-- It iteratively checks each neighbor and includes them in the cluster if they are not already part of another cluster or marked as noise. 
-- The function also discovers new neighbors of neighbors, expanding the cluster until no further additions are possible.
--
-- @param point The point around which the cluster is being expanded.
-- @param neighbors The initial set of neighbors of the point.
-- @param cluster_id The identifier of the cluster being expanded.
-- @return self The updated DBSCANNER object after expanding the cluster.
-- @usage dbscanner:expand_cluster(corePoint, initialNeighbors, clusterId) -- Expands a cluster around 'corePoint'.
function SPECTRE.BRAIN.DBSCANNER:expand_cluster(point, neighbors, cluster_id)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:expand_cluster | -------------------------------------------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:expand_cluster | cluster_id  | " .. cluster_id)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:expand_cluster | point       | ", point)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:expand_cluster | neighbors   | ", neighbors)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:expand_cluster | labels      | ", self._DBScan)
  local UNMARKED, NOISE = 0, -1
  self._DBScan[point.unit] = cluster_id
  local i = 1
  while i <= #neighbors do
    local neighbor = neighbors[i]
    if self._DBScan[neighbor.unit] == NOISE or self._DBScan[neighbor.unit] == UNMARKED then
      self._DBScan[neighbor.unit] = cluster_id
      local new_neighbors = self:region_query(neighbor)
      if #new_neighbors >= self.min_samples then
        for _, new_neighbor in ipairs(new_neighbors) do
          table.insert(neighbors, new_neighbor)
        end
      end
    end
    i = i + 1
  end
  return self
end

--- Post-processes the clusters formed by the DBSCAN algorithm.
--
-- After clustering is done, this function processes each cluster to compute its center, radius, and other relevant details. 
-- It organizes the clusters into a sorted array and calculates the center and radius for each cluster, including any radius extension. 
-- The results are stored in the 'Clusters' attribute of the DBSCANNER object.
--
-- @return self The updated DBSCANNER object with fully processed clusters.
-- @usage dbscanner:post_process_clusters() -- Post-processes clusters to compute centers and radii.
function SPECTRE.BRAIN.DBSCANNER:post_process_clusters()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:post_process_clusters | -------------------------------------------- ")
  local function _distance(point1, point2)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = point1.x - point2.x
    local dy = point1.y - point2.y

    -- Use the Pythagorean theorem to compute the distance
    return math.sqrt(dx^2 + dy^2)
  end
  local clusters = {}
  local cluster_centers = {}
  local cluster_radii = {}
  self.Clusters = {}
  -- Group units by cluster
  for _, unit in ipairs(self.Points) do
    local cluster = self._DBScan[unit.unit]
    if not clusters[cluster] then
      clusters[cluster] = {}
    end
    table.insert(clusters[cluster], unit)
  end

  -- Compute center and radius for each cluster
  for cluster, units in pairs(clusters) do
    local sum_x = 0
    local sum_y = 0
    local max_radius = 0
    for _, unit in ipairs(units) do
      sum_x = sum_x + unit.vec2.x
      sum_y = sum_y + unit.vec2.y
    end
    local center = {x = sum_x / #units, y = sum_y / #units}
    cluster_centers[cluster] = center

    for _, unit in ipairs(units) do
      local distance = _distance(center, unit.vec2)
      if distance > max_radius then
        max_radius = distance
      end
    end
    cluster_radii[cluster] = max_radius
  end

  local sorted_groups = {}
  for cluster, units in pairs(clusters) do
    if cluster > 0 then
      table.insert(sorted_groups, {
        Units = units,
        Center = cluster_centers[cluster],
        CenterVec3 = mist.utils.makeVec3(cluster_centers[cluster]),
        Radius = cluster_radii[cluster] + self._RadiusExtension,
      })
    end
  end
  self.Clusters = sorted_groups
  return self
end




-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **HANDLERS**
--
-- Various prebuilt event handlers.
--
-- ===
--
-- @module HANDLERS
-- @extends SPECTRE


--- SPECTRE.HANDLERS.
--
-- Various prebuilt event handlers.
--
-- @field #HANDLERS
SPECTRE.HANDLERS = {}
SPECTRE.HANDLERS._Handlers = EVENT:New()

--- New HANDLERS instance.
-- @param #HANDLERS
-- @return #HANDLERS self
function SPECTRE.HANDLERS:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  return self
end


--- ParachuteCleanup.
-- ===
--
-- Automatically clean up pesky parachute markers on the map upon touchdown.
--
-- ===
-- @section SPECTRE.HANDLERS


---Automatically clean up pesky parachute markers on the map upon touchdown.
-- @field #HANDLERS.ParachuteCleanup
SPECTRE.HANDLERS.ParachuteCleanup = {}
SPECTRE.HANDLERS.ParachuteCleanup = EVENT:New()
--- Initializes the Parachute Cleanup handler.
--
-- This function sets up an event handler to remove parachutes from the map upon landing after ejection. 
-- It listens to the `EVENTS.LandingAfterEjection` event and triggers `_ParachuteCleanup` function whenever such an event occurs.
--
-- @return #HANDLERS.ParachuteCleanup self The updated ParachuteCleanup handler with event handling initialized.
-- @usage SPECTRE.HANDLERS:ParachuteCleanupInit() -- Initializes the Parachute Cleanup event handling.
function SPECTRE.HANDLERS:ParachuteCleanupInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | Init")
  self:HandleEvent(EVENTS.LandingAfterEjection, self._ParachuteCleanup)
  return self
end
--- Handles the cleanup of parachutes on landing after ejection.
--
-- This function is triggered upon landing after ejection events. 
-- It logs the event details and, if the initiator (parachute) exists, attempts to destroy it. 
-- This function is designed to be used as an event handler and not called directly.
--
-- @param ParachuteCleanupEvent The event data associated with a landing after ejection.
-- @usage Called internally as an event handler for `EVENTS.LandingAfterEjection`.
function SPECTRE.HANDLERS:_ParachuteCleanup(ParachuteCleanupEvent)
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | OnEventLandingAfterEjection")
    local force = true
    local _Randname = os.time()
    local _filename = SPECTRE._persistenceLocations.SPECTRE.path .. "DEBUG/ParachuteCleanup/" .. _Randname .. ".lua"
    SPECTRE.IO.PersistenceToFile(_filename, ParachuteCleanupEvent, force)
  end

  SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | Event", ParachuteCleanupEvent)
  SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | initiator", ParachuteCleanupEvent.initiator)

  -- Ensure the initiator is the correct type and exists
  if ParachuteCleanupEvent.initiator and ParachuteCleanupEvent.initiator:isExist() then
    -- Attempt to destroy the unit with error handling
    local status, err = pcall(function()
      Unit.destroy(ParachuteCleanupEvent.initiator)
    end)
    if not status then
      SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | Error destroying unit:", err)
    end
  else
    SPECTRE.UTILS.debugInfo("SPECTRE.HANDLERS.ParachuteCleanup | Invalid initiator or does not exist")
  end
end


-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **IADS**
--
-- The Integrated Air Defense System (IADS) module for SPECTRE, leveraging Skynet-IADS for advanced air defense simulation.
--
-- Automatically adds all eligible groups to their relevant IADs. Manual set up no longer required.
--
-- All SKYNET functions can be called by
--
--      local newIADS =  IADS:New()
--      newIADS.SkynetIADS:`SKYNET FUNCTION HERE`()
--
-- This module integrates the functionalities of Skynet-IADS, with the SPECTRE system.
--
-- Skynet-IADS is required for this module to function properly.
--
--      For more information and the Skynet-IADS source, visit: https://github.com/walder/Skynet-IADS
--
-- `HIGHLIGHTS`
--
-- The SPECTRE.IADS module integrates several key features and functionalities to enhance air defense simulations:
--
-- **Seamless Integration with SPECTRE:**
--
--      Leverages the existing capabilities of the SPECTRE framework,
--      ensuring smooth operation and coordination with other SPECTRE modules.
--
-- **Automated Zone Management:**
--
--      Works in conjunction with user defined Zone names to automatically detect
--      and classify air defense units within specified zones, simplifying setup and deployment.
--
-- **Enhanced Air Defense Tactics:**
--      Supports advanced tactics such as SAM site activation/deactivation
--      for generated units automatically.
--
-- **Integration with External Systems:**
--
--      Facilitates integration with external systems and modules,
--      expanding the scope and interoperability of air defense simulations.
--
--
-- @module IADS
-- @extends SPECTRE

--- Main.
-- ===
--
-- *Main exposed access points.*
--
-- ===
-- @section SPECTRE.IADS

--- SPECTRE.IADS.
--
-- The core table representing the IADS functionality within the SPECTRE framework.
--
-- This table acts as the primary interface for implementing and managing IADS operations,
-- integrating Skynet-IADS features into the SPECTRE environment.
--
-- It requires the Skynet-IADS system to be installed and properly configured.
--
-- Access more about Skynet-IADS at: https://github.com/walder/Skynet-IADS
--
-- The primary table/interface for IADS functionalities within SPECTRE.
-- @field #IADS
SPECTRE.IADS = {}
--- Scheduler for periodic IADS updates.
-- This field in the IADS module is dedicated to managing the scheduler responsible for periodic updates of the IADS.
-- A scheduler object that triggers periodic updates within the IADS system.
SPECTRE.IADS.UpdateSched = {}
SPECTRE.IADS.UpdateSchedOBJ = {}
SPECTRE.IADS.name = ""
--- Flag indicating if IADS is currently being updated.
-- This boolean field signifies whether an update process for the IADS is currently active or not.
-- A boolean flag to control and check the status of ongoing IADS updates.
SPECTRE.IADS.UpdatingIADS = false
--- Storage for SkynetIADS object.
-- This field holds the Skynet Integrated Air Defense System object for managing air defense networks.
-- A container for the Skynet IADS object.
SPECTRE.IADS.SkynetIADS = {}
--- Storage for Managed SAMs.
-- A storage field dedicated to Surface-to-Air Missile (SAM) systems managed within the IADS.
-- A collection of managed SAM systems.
SPECTRE.IADS.SAMs = {}
--- Storage for Managed EWRs.
-- A storage field dedicated to Early Warning Radars (EWRs) managed within the IADS.
-- A collection of managed EWR systems.
SPECTRE.IADS.EWRs = {}
--- Storage for Zones to scan for units to add to IADS.
SPECTRE.IADS.ZONENAMES = {}
--- Storage for built groups from detected ZONEMGR units.
-- This field stores the names of groups that have been constructed based on units detected by the Zone Manager.
-- A list of group names built from ZONEMGR-detected units.
SPECTRE.IADS._GroupNames = {}
--- Storage for _GroupAttributes from detected ZONEMGR units.
-- A field that holds attributes of groups, derived from units identified by the Zone Manager.
-- A collection of attributes for groups based on ZONEMGR-detected units.
SPECTRE.IADS._GroupAttributes = {}
--- Coalition to build IADs for.
-- A numerical value representing the coalition for which the IADS is being built.
-- An integer indicating the coalition (e.g., 0, 1, 2).
SPECTRE.IADS.coal = 0
--- How often to update self.
-- This field specifies the interval at which the IADS should update itself.
-- An integer representing the update interval in seconds.
SPECTRE.IADS.UpdateInterval = 25
--- Nudge factor for update interval.
-- A modifier that adds randomness to the IADS update interval.
-- A decimal value representing the nudge factor for the update interval.
SPECTRE.IADS.UpdateIntervalNudge = 0.25
SPECTRE.IADS.samTypesDB_LU = {}
SPECTRE.IADS.samTypesDB_ = {
  "NASAMS", "Hawk sr", "RLS_19J6", "Osa", "Straight Flush", "S_75M_Volhov",
  "Patriot cp", "SA-9 Gaskin", "EWR P-37 BAR LOCK", "ZSU-23-4 Shilka", "SA-11 Buk LN 9A310M1",
  "S-300PS 5P85C ln", "S-200", "Gepard", "Tor 9A331", "S-300PS 40B6MD sr_19J6",
  "p-19 s-125 sr", "Rapier", "Hawk tr", "SA-3 Goa", "Patriot AMG", "SA-11 Gadfly",
  "rapier_fsa_launcher", "NASAMS_Radar_MPQ64F1", "HQ-7_STR_SP", "Kub 1S91 str",
  "Kub", "Hawk str", "SA-10 Grumble", "NASAMS_LN_B", "5p73 s-125 ln", "Tor",
  "SA-11 Buk SR 9S18M1", "Kub 2P25 ln", "CSA-4", "SA-19 Grison", "HQ-7", "Zues",
  "S-300", "Patriot ECS", "rapier_fsa_blindfire_radar", "Strela-10M3", "HEMTT_C-RAM_Phalanx",
  "Phalanx", "Patriot EPP", "rapier_fsa_optical_tracker_unit", "SA-2 Guideline", "Patriot",
  "S-300PS 5H63C 30H6_tr", "NASAMS_Command_Post", "SA-15 Gauntlet", "S-300PS 64H6E sr",
  "snr s-125 tr", "SNR_75V", "Flat Face", "Strela-1 9P31", "S-300PS 40B6MD sr",
  "Hawk ln", "HQ-7_LN_SP", "Roland Radar", "SA-13 Gopher", "Buk", "S-300PS 40B6M tr",
  "S-300PS 54K6 cp", "Snow Drift", "SA-5 Gammon", "RPC_5N62V", "Osa 9A33 ln",
  "Hawk", "S-75", "Patriot ln", "SA-8 Gecko", "S-200_Launcher", "2S6 Tunguska",
  "Roland EWR", "Roland ADS", "S-300PS 5P85D ln", "SA-11 Buk CC 9S470M1", "NASAMS_LN_C",
  "SA-6 Gainful", "Patriot str", "S-125"
}
SPECTRE.IADS.EWTypesDB_LU = {}
SPECTRE.IADS.EWTypesDB_ = {
  "Dog Ear", "Tall Rack", "FPS-117 Dome", "55G6 EWR",
  "Dog Ear radar", "Box Spring", "1L13 EWR", "FPS-117"
}
function SPECTRE.IADS.createLookupTable(list)
  local lookup = {}
  for _, value in ipairs(list) do
    lookup[value] = true
  end
  return lookup
end

--- Create a new instance of the Integrated Air Defense System (IADS) Manager.
--
-- This function initializes a new IADS manager for a specified coalition and Zone Manager.
-- The IADS manager is responsible for coordinating and managing air defense assets within a defined area.
--
-- @param #IADS self The IADS instance.
-- @param coal Coalition number (0, 1, or 2) to which this IADS belongs.
-- @param ZONENAMES table of The names of zones to scan for units to add to IADS.
-- @return #IADS self The newly created IADS manager instance.
function SPECTRE.IADS:New(coal,ZONENAMES)
  local self = BASE:Inherit(self, SPECTRE:New())
  self.samTypesDB_LU = self.createLookupTable(self.samTypesDB_)
  self.EWTypesDB_LU = self.createLookupTable(self.EWTypesDB_)
  self.coal = coal
  self.ZONENAMES = ZONENAMES
  return self
end



--- Create Skynet Object.
-- Initializes a new Skynet IADS object with the given name.
-- @param #IADS self The IADS instance.
-- @param name The name for the Skynet IADS.
-- @return #IADS self The IADS instance with the Skynet IADS created.
function SPECTRE.IADS:createSkynet(name)
  self.SkynetIADS = SkynetIADS:create(name)
  self.name = name
  return self
end

--- Enable Debug Mode for IADS.
-- Activates various debug settings for the IADS's Skynet component.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:DebugOn()
  local iadsDebug = self.SkynetIADS:getDebugSettings()
  iadsDebug.IADSStatus = true
  iadsDebug.radarWentDark = true
  iadsDebug.contacts = true
  iadsDebug.radarWentLive = true
  iadsDebug.noWorkingCommmandCenter = false
  iadsDebug.ewRadarNoConnection = false
  iadsDebug.samNoConnection = false
  iadsDebug.jammerProbability = true
  iadsDebug.addedEWRadar = false
  iadsDebug.hasNoPower = false
  iadsDebug.harmDefence = true
  iadsDebug.samSiteStatusEnvOutput = true
  iadsDebug.earlyWarningRadarStatusEnvOutput = true
  iadsDebug.commandCenterStatusEnvOutput = true
  return self
end

--- Deactivate Skynet Object in IADS.
-- This function deactivates the Skynet IADS component.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:deactivateSkynet()
  self.SkynetIADS:deactivate()
  return self
end

--- Set Skynet update interval in IADS.
-- This function sets the update interval for the Skynet IADS component.
-- @param #IADS self The instance of the IADS class.
-- @param interval The time interval in seconds for Skynet updates.
-- @return #IADS self The instance of the IADS class after setting the interval.
function SPECTRE.IADS:setSkynetUpdateInterval(interval)
  interval = interval or 5
  self.SkynetIADS:setUpdateInterval(interval)
  return self
end

--- Set the update interval and nudge factor for IADS.
-- This function configures the interval and nudge factor for the IADS system updates.
-- @param #IADS self The IADS instance.
-- @param interval The time interval in seconds for IADS updates (optional, default 25 seconds).
-- @param nudge A nudge factor to adjust the interval (optional, default 0.25).
-- @return #IADS self The IADS instance after configuration.
function SPECTRE.IADS:setUpdateInterval(interval, nudge)
  interval = interval or 25
  nudge = nudge or 0.25
  self.UpdateInterval = interval
  self.UpdateIntervalNudge = nudge
  return self
end

--- Initialize the IADS.
-- This function initializes the IADS by updating its configuration and setting up a schedule for further updates.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:Init()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:Init | ")

  self:Update()
  self:UpdateSchedInit()
  return self
end


--- Initialize the update scheduler for the IADS.
-- This function sets up a scheduler to periodically perform updates on the IADS. It ensures that updates are
-- only executed when a previous update cycle is not in progress.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:UpdateSchedInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:UpdateSchedInit | ---------------------")
  -- Initialize a scheduler to periodically check and update zones
  self.UpdateSchedOBJ = SCHEDULER:New()

  self.UpdateSched = self.UpdateSchedOBJ:Schedule(self, function()
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS:self.UpdateSched | ")
    -- Only proceed if zones are not already being updated
    if not self.UpdatingIADS then
      self.UpdatingIADS = true
      local _timer = TIMER:New(function()

          self:Update()
          self.UpdatingIADS = false
      end)
      _timer:Start(math.random(1,3))

    end
    return self
  end, {self}, 30, self.UpdateInterval, self.UpdateIntervalNudge)
  return self
end

--- Perform an update cycle for the IADS.
-- This function executes a series of tasks including retrieving groups within the assigned Zone Names, getting group attributes,
-- classifying groups, adding new SAMs, and adding new EWRs to the IADS.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:Update()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:Update | ")
  self:getGroupsInZones()
  self:getGroupAttributes()
  self:classifyGroups()
  self:addNewSAMs()
  self:addNewEWRs()
  return self
end

--- SAM TypeDef.
-- This section defines the Surface-to-Air Missile (SAM) component within the Integrated Air Defense System (IADS).
-- @section SPECTRE.IADS
-- @field #IADS.SAM A table representing the SAM module within IADS.
SPECTRE.IADS.SAM = {}
--- SAM Type.
-- The type of SAM system represented, e.g., short-range, medium-range, or long-range SAM.
-- A string describing the type of SAM system.
SPECTRE.IADS.SAM.type = ""
--- SAM Group Name.
-- The name of the group in the DCS world that this SAM object represents.
-- A string containing the group name of the SAM system.
SPECTRE.IADS.SAM.groupName = ""
--- Skynet SAM Object.
-- The associated Skynet IADS object for this SAM, managing its behavior and properties in the IADS network.
-- A SkynetIADS object representation of the SAM system.
SPECTRE.IADS.SAM.SkynetObj = {}
--- Act As Early Warning.
-- A boolean indicating whether the SAM site should also act as an Early Warning Radar.
-- A boolean flag, true if the SAM acts as EWR, false otherwise.
SPECTRE.IADS.SAM.ActAsEW = false
--- Go Live Zone.
-- Defines the conditions under which the SAM system will switch to a live (active) state.
-- A value determining the condition for SAM activation, based on SkynetIADSAbstractRadarElement constants.
SPECTRE.IADS.SAM.goLiveZone = ""--SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_KILL_ZONE --SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE
--- Go Live Percent.
-- Specifies the percentage of maximum engagement range at which the SAM system will go live.
-- An integer indicating the percent of maximum range for SAM activation.
SPECTRE.IADS.SAM.goLivePercent = 100
--- Can Engage Air Weapons.
-- Determines if the SAM site is capable of engaging air weapons.
-- A boolean flag, true if SAM can engage air weapons, false otherwise.
SPECTRE.IADS.SAM.CanEngageAirWeapons = true
--- Can Engage HARM Missiles.
-- Specifies if the SAM site can engage HARM (High-speed Anti-Radiation Missile) missiles.
-- A boolean flag, true if SAM can engage HARM missiles, false otherwise.
SPECTRE.IADS.SAM.CanEngageHARMS = true

--- Create a new SAM object.
-- This function is responsible for initializing a new Surface-to-Air Missile (SAM) object within the IADS framework.
-- It sets up various properties and configurations specific to the SAM type, such as engagement zones, weapon engagement capabilities, and live range percentages.
-- @param #IADS.SAM self The SAM class.
-- @param _Name The name of the SAM group.
-- @param _SAMTYPE The type of the SAM (e.g., LR SAM, MR SAM).
-- @param #IADS _IADS The instance of the IADS to which this SAM belongs.
-- @return #IADS.SAM self The newly created SAM object.
function SPECTRE.IADS.SAM:New(_Name, _SAMTYPE, _IADS)
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | ------------------ ")
  -- Inherit properties from the BASE class.
  local self = BASE:Inherit(self, SPECTRE:New())
  self.goLiveZone = SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_KILL_ZONE
  self.groupName = _Name
  self.type = _SAMTYPE
  self.SkynetObj = _IADS.SkynetIADS:getSAMSiteByGroupName(_Name)
  if self.SkynetObj then
    self.SkynetObj:setEngagementZone(self.goLiveZone)
    self.SkynetObj:setCanEngageAirWeapons(self.CanEngageAirWeapons)
    self.SkynetObj:setCanEngageHARM(self.CanEngageHARMS)

    if self.type == "LR SAM" then
      self.goLivePercent = 75
      self.SkynetObj:setGoLiveRangeInPercent(self.goLivePercent)
    elseif self.type == "MR SAM" then
      self.goLivePercent = 85
      self.SkynetObj:setGoLiveRangeInPercent(self.goLivePercent)
    end

    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | groupName | " .. self.groupName)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | type                | " .. self.type)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | ActAsEW             | " .. tostring(self.ActAsEW))
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | goLiveZone          | " .. self.goLiveZone)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | goLivePercent       | " .. self.goLivePercent)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | CanEngageAirWeapons | " .. tostring(self.CanEngageAirWeapons))
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | CanEngageHARMS      | " .. tostring(self.CanEngageHARMS))
  end
  return self
end


--- EWR TypeDef.
-- This section defines the Early Warning Radar (EWR) component within the Integrated Air Defense System (IADS).
-- @section SPECTRE.IADS
-- @field #IADS.EWR A table representing the EWR module within IADS.
SPECTRE.IADS.EWR = {}
--- EWR Group Name.
-- The name of the group in the DCS world that this EWR object represents.
-- A string containing the group name of the EWR system.
SPECTRE.IADS.EWR.groupName = ""
--- EWR Unit Name.
-- The name of the specific unit in the DCS world that this EWR object represents.
-- A string containing the unit name of the EWR system.
SPECTRE.IADS.EWR.unitName = ""
--- Skynet EWR Object.
-- The associated Skynet IADS object for this EWR, managing its behavior and properties in the IADS network.
-- A SkynetIADS object representation of the EWR system.
SPECTRE.IADS.EWR.SkynetObj = {}
--- Go Live Zone.
-- Defines the conditions under which the EWR system will switch to a live (active) state.
-- A value determining the condition for EWR activation, based on SkynetIADSAbstractRadarElement constants.
SPECTRE.IADS.EWR.goLiveZone = ""--SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE
--- Go Live Percent.
-- Specifies the percentage of maximum detection range at which the EWR system will go live.
-- An integer indicating the percent of maximum range for EWR activation.
SPECTRE.IADS.EWR.goLivePercent = 100

--- Create a new EWR object.
-- This function is responsible for initializing a new Early Warning Radar (EWR) object within the IADS framework.
-- It sets up various properties and configurations specific to the EWR, such as engagement zones and live range percentages.
-- @param #IADS.EWR self The EWR class.
-- @param _groupName The name of the EWR group.
-- @param _unitName The name of the EWR unit.
-- @param #IADS _IADS The instance of the IADS to which this EWR belongs.
-- @return #IADS.EWR self The newly created EWR object.
function SPECTRE.IADS.EWR:New(_groupName, _unitName, _IADS)
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS.EWR:New | ------------------ ")
  -- Inherit properties from the BASE class.
  local self = BASE:Inherit(self, SPECTRE:New())
  self.goLiveZone = SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE
  self.groupName = _groupName
  self.unitName = _unitName
  self.SkynetObj = _IADS.SkynetIADS:getEarlyWarningRadarByUnitName(_unitName)

  if self.SkynetObj then
    self.SkynetObj:setEngagementZone(self.goLiveZone)
    self.SkynetObj:setGoLiveRangeInPercent(self.goLivePercent)

    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | groupName | " .. self.groupName)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | unitName  | " .. self.unitName)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | goLiveZone          | " .. self.goLiveZone)
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS.SAM:New | goLivePercent       | " .. self.goLivePercent)
  end
  return self
end

--- DangerZone.
-- ===
--
-- *Internal functions, can be used externally with care and understanding.*
--
-- ===
-- @section SPECTRE.IADS

--- Retrieve and store the names of groups within ZONEMGR.
-- This function gathers all groups corresponding to units present in the zones managed by ZONEMGR.
-- It filters these groups based on their coalition and stores their names for further processing.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:getGroupsInZones()

  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | ")
  self._GroupNames = {}

  --Get all groups for units in zone
  for _, _ZoneName in pairs(self.ZONENAMES) do

    SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | _ZoneName | " .. _ZoneName)
    local _detectedUnits = SPECTRE.WORLD.FindUnitsInZone(_ZoneName)

    if _detectedUnits[self.coal] then
      SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | _detectedUnits for coal " .. self.coal)
      for _, _Unit in ipairs(_detectedUnits[self.coal]) do
        SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | _Unit " , _Unit)
        local unitName  = _Unit.name
        SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | unitName | " .. unitName)
        local _unit     = Unit.getByName(unitName)

        if _unit then
          SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | unit found", _unit)
          local unitType  = _unit:getTypeName()
          SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | unitType " .. unitType)


          local IADSUNIT = self.samTypesDB_LU[unitType]
          local IADSUNITEW = self.EWTypesDB_LU[unitType]

          if IADSUNIT or IADSUNITEW then
            local _Group    =  Unit.getGroup(_unit )
            if _Group then
              SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | group found", _Group)
              local groupName = Group.getName(_Group)
              if groupName and (not self.SAMs[groupName] and not self.EWRs[groupName]) then
                SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupsInZones | groupName | " .. groupName)
                SPECTRE.UTILS.safeInsert(self._GroupNames,groupName)
              end
            end
          end
        end

      end
    end
  end
  return self
end

--- Retrieve and store attributes of groups.
-- This function processes each group name stored in the IADS instance, obtaining and storing their respective attributes.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:getGroupAttributes()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:getGroupAttributes | ")
  self._GroupAttributes = {}
  --Get all Attributes for all groups
  for _, _groupName in ipairs(self._GroupNames) do
    self._GroupAttributes[_groupName] = SPECTRE.UTILS.GetGroupAttributes(_groupName)
  end
  return self
end

--- Classify groups based on their attributes.
-- This function categorizes each group based on its attributes into different classes like SR SAM, MR SAM, LR SAM, and EWR.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:classifyGroups()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:classifyGroups | ")
  self._ClassifiedGroups = {
    ["SR SAM"] = {},
    ["MR SAM"] = {},
    ["LR SAM"] = {},
    ["EWR"] = {},
    ["SAM"] = {},
  }

  -- Iterate over each key in the inputTable
  for key, types in pairs(self._GroupAttributes) do
    -- Flags to check if the key contains any of the unwanted types
    --local containsRestrictedType = false

    -- Check if the key contains any of the unwanted types
    --    containsRestrictedType = SPECTRE.UTILS.table_hasValue(types, "AAA")
    --    if not containsRestrictedType then
    --      containsRestrictedType = SPECTRE.UTILS.table_hasValue(types, "IR Guided SAM")
    --    end
    --    if not containsRestrictedType then
    --      containsRestrictedType = SPECTRE.UTILS.table_hasValue(types, "Mobile AAA")
    --    end


    -- If the key doesn't contain any of the unwanted types, add it to the appropriate category in the OutputTable
    -- if not containsRestrictedType then
    -- Check if the key contains wanted types
    local containsType = false
    local containsTypeEWR = false
    local containsTypeLR = false
    local containsTypeMR = false
    local containsTypeSR = false

    -- Check if the key contains any of the unwanted types
    containsTypeEWR = SPECTRE.UTILS.table_hasValue(types, "EWR")
    containsType = containsTypeEWR
    if not containsType then
      -- Check if the key contains any of the unwanted types
      containsTypeLR = SPECTRE.UTILS.table_hasValue(types, "LR SAM")
      containsType = containsTypeLR
    elseif not containsType then
      containsTypeMR = SPECTRE.UTILS.table_hasValue(types, "MR SAM")
      containsType = containsTypeMR
    end
    if not containsType then
      containsTypeSR = SPECTRE.UTILS.table_hasValue(types, "SR SAM")
      containsType = containsTypeSR
    end

    if containsType then
      if containsTypeEWR then
        table.insert(self._ClassifiedGroups["EWR"], key)
      elseif containsTypeLR then
        table.insert(self._ClassifiedGroups["LR SAM"], key)
      elseif containsTypeMR then
        table.insert(self._ClassifiedGroups["MR SAM"], key)
      elseif containsTypeSR then
        table.insert(self._ClassifiedGroups["SR SAM"], key)
      else
        table.insert(self._ClassifiedGroups["SAM"], key)
      end
    end
    --end
  end
  return self
end

--- Add new SAM sites to the IADS.
-- This function iterates through classified groups and adds each SAM site to the Skynet IADS.
-- It excludes EWR from being added as a SAM site. New SAM objects are created for each group name not already present.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:addNewSAMs()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:addNewSAMs | ")
  for _SAMTYPE, _GroupNames in pairs (self._ClassifiedGroups) do
    SPECTRE.UTILS.debugInfo("SPECTRE.IADS:addNewSAMs | _SAMTYPE | " , _SAMTYPE)
    if _SAMTYPE ~= "EWR" then
      for _, _Name in ipairs (_GroupNames) do
       --BASE:E("SPECTRE.IADS:addNewSAMs | _Name | " .. _Name)
        if not self.SAMs[_Name] then

          --          local unitCOAL = GROUP:FindByName(_Name):GetCoalition()
          --          SPECTRE.UTILS.debugInfo("SPECTRE.IADS:addNewSAMs | unitCOAL | " .. unitCOAL)

          self.SkynetIADS:addSAMSite(_Name)

          self.SAMs[_Name] = self.SAM:New(_Name, _SAMTYPE, self)
        end
      end
    end
  end
  return self
end


--- Add new Early Warning Radars (EWRs) to the IADS.
-- This function iterates through the classified groups specifically tagged as "EWR" and adds each EWR to the Skynet IADS.
-- It ensures that only new EWRs, not already part of the IADS, are added. New EWR objects are created for each group name.
-- @param #IADS
-- @return #IADS self
function SPECTRE.IADS:addNewEWRs()
  SPECTRE.UTILS.debugInfo("SPECTRE.IADS:addNewEWRs | ")

  for _, _Name in ipairs (self._ClassifiedGroups["EWR"]) do
    if not self.EWRs[_Name] then
      local _unitName
      -- Find EWR Unit in group
      local _GROUPunits = GROUP:FindByName(_Name):GetUnits()
      for _, _unitOb in pairs(_GROUPunits) do
        local _attributes = SPECTRE.UTILS.GetUnitAttributes(_unitOb.UnitName)
        if SPECTRE.UTILS.table_contains(_attributes,"EWR") then
          _unitName = _unitOb.UnitName
          break
        end
      end

      self.SkynetIADS:addEarlyWarningRadar(_unitName)
      self.EWRs[_Name] = self.EWR:New(_Name, _unitName, self)
    end

  end
  return self
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **IO**
--
-- File and Object Management Utilities for SPECTRE.
--
--   * Provides functionality to read, write, and manage files.
--
--   * Enables object serialization to and from persistent storage.
--
--   * Offers utilities to check and ensure directory and file existence.
--
--      For example, you can easily serialize game state data, save it to a file, and load it back when needed.
--
-- ===
--
-- @module IO
-- @extends SPECTRE

--- IO.
--
-- This module encompasses utilities and methods related to input/output operations, particularly those concerning file handling and object persistence.
-- With these functionalities, developers can perform tasks like saving game states, loading configurations, or managing in-game databases more efficiently.
--
-- @section SPECTRE.IO
-- @field #IO
SPECTRE.IO = {}


--- Files & Folders.
-- ===
--
-- *All Functions associated with Files & Folders operations.*
--
-- ===
-- @section SPECTRE.IO

--- Checks if a directory exists and creates it if not.
--
--  @{SPECTRE.IO.DirExists}
--
-- This function checks for the existence of a specified directory.
-- If the directory does not exist, it will be created.
--
-- @param Dir The path of the directory to check.
-- @usage SPECTRE.IO.DirExists("path/to/directory") -- Checks and possibly creates the directory at the specified path.
function SPECTRE.IO.DirExists(Dir)
  -- If the directory does not exist, create it
  if not lfs.attributes(Dir) then
    lfs.mkdir(Dir)
  end
end

--- Checks if a file exists and creates it if not.
--
--  @{SPECTRE.IO.FileExists}
--
-- This function checks for the existence of a specified file.
-- If the file does not exist, an empty file will be created.
-- Any errors encountered during file creation are currently not handled.
--
-- @param File The path of the file to check.
-- @usage SPECTRE.IO.FileExists("path/to/file.txt") -- Checks and possibly creates the file at the specified path.
function SPECTRE.IO.FileExists(File)
  -- If the file does not exist, create it
  if not lfs.attributes(File) then
    local file = io.open(File, "w")
    if file then
      file:close()
    else
    -- TODO: Error handling?
    end
  end
end

--- Extracts the filename and path from a full filepath.
--
--  @{SPECTRE.IO.extractFilenameAndPath}
--
-- This function breaks a given full filepath into its constituent filename and path.
--
-- @param filepath The full filepath to process.
-- @return filePath_ The path without the filename.
-- @return filename The extracted filename from the filepath.
-- @usage local path, name = SPECTRE.IO.extractFilenameAndPath("path/to/myFile.txt") -- Extracts "/path/to/" as path and "myFile.txt" as name.
function SPECTRE.IO.extractFilenameAndPath(filepath)
  -- Use the string.match function with a pattern to extract the filename.
  local filename = string.match(filepath, "[^/\\]+$")
  -- Use string.sub to extract the part of the filepath before the filename.
  local filePath_ = string.sub(filepath, 1, -(string.len(filename) + 1))

  -- If the filepath uses backslashes as separators on Windows, you can modify the pattern like this:
  filePath_ = SPECTRE.IO.removeLastSlashOrBackslash(filePath_)
  return filePath_, filename
end

--- Loads an object from a specified filepath.
--
--  @{SPECTRE.IO.PersistenceFromFile}
--
-- This function takes a full filepath as input and extracts the directory path and filename using the `SPECTRE.IO.extractFilenameAndPath` method.
-- It then constructs the absolute path to the file and attempts to load an object from it using the `SPECTRE.IO.persistence.load` method.
--
-- @param filepath The full filepath from which to load the object.
-- @return Object The object loaded from the file, or nil if the file does not contain a valid object.
-- @usage local myObject = SPECTRE.IO.PersistenceFromFile("path/to/myFile.txt") -- Loads the object from the specified filepath.
function SPECTRE.IO.PersistenceFromFile(filepath)
  local filepath_, filename = SPECTRE.IO.extractFilenameAndPath(filepath)
  -- Construct the full path to the file
  local _Path  = lfs.writedir() .. filepath_
  local _File = _Path .. "/" .. filename
  -- Load the object from the file
  local Object = SPECTRE.IO.persistence.load(_File)

  return Object
end

--- Removes the trailing slash or backslash from a string.
--
--  @{SPECTRE.IO.removeLastSlashOrBackslash}
--
-- This function examines the last character of an input string. If the last character is either a slash ('/') or a backslash ('\\'),
-- the function removes it and returns the modified string. If the last character is not a slash or backslash, the function returns the input string unmodified.
--
-- @param inputString The string from which to potentially remove a trailing slash or backslash.
-- @return string The modified string without a trailing slash or backslash, or the original string if no modification was made.
-- @usage local newPath = SPECTRE.IO.removeLastSlashOrBackslash("path/to/directory/") -- Returns "/path/to/directory".
function SPECTRE.IO.removeLastSlashOrBackslash(inputString)
  local lastChar = inputString:sub(-1)

  if lastChar == '/' or lastChar == '\\' then
    return inputString:sub(1, -2) -- Remove the last character
  else
    return inputString -- Return the input string as is
  end
end

--- Saves an object to a specified file within the SPECTRE directory.
--
--  @{SPECTRE.IO.PersistenceToFile}
--
-- This function takes an object and a filepath as arguments. It constructs a full path to the file,
-- ensures the directory and file exist (creating them if necessary), and then saves the object to the file.
-- The object is saved using the `SPECTRE.IO.persistence.store` method.
--
-- @param filepath The path to the file where the object should be saved.
-- @param Object The object to be saved to the file.
-- @param noFunc (Optional, if true does not export functions)
-- @usage SPECTRE.IO.PersistenceToFile("path/to/file.txt", myObject) -- Saves the `myObject` to "file.txt" within the specified path in the SPECTRE directory.
function SPECTRE.IO.PersistenceToFile(filepath, Object, noFunc)
  noFunc = noFunc or false
  local filepath_, filename = SPECTRE.IO.extractFilenameAndPath(filepath)
  -- Construct the full path to the file
  local _Path  = lfs.writedir() .. filepath_
  --  SPECTRE.UTILS.debugInfo("_Path",_Path)
  local _File = _Path .. "/" .. filename

  -- Ensure the directory and file exist
  SPECTRE.IO.DirExists(_Path)
  SPECTRE.IO.FileExists(_File)

  if noFunc then
    SPECTRE.IO.persistence.storeNoFunc(_File, Object)
  else
    -- Store the object in the file
    SPECTRE.IO.persistence.store(_File, Object)
  end
end

--- Determines the existence of a file at a specified path.
--
--  @{SPECTRE.IO.file_exists}
--
-- A utility function designed to check the existence of a file at a given path. It tries to open the file for reading.
-- If the file is accessible, it confirms its existence by returning true. If the file cannot be accessed or does not exist, it returns false.
--
-- @param filePath The absolute or relative path of the file to be verified.
-- @return true Indicates the file exists.
-- @return false Indicates the file does not exist.
-- @usage local fileExists = SPECTRE.IO.file_exists("data/files/file.txt") -- Verifies the existence of "file.txt" in the "data/files" directory.
function SPECTRE.IO.file_exists(filePath)

  -- Attempt to open the file for reading
  local file = io.open(lfs.writedir() .. filePath, "r")

  if (file) then
    file:close()  -- Close the file if it was successfully opened
    return true   -- File exists
  else
    return false  -- File does not exist
  end
end

do
  local write, writeNoFunc, writeSerialString, writeIndent, writeIndentSerial, writers, writersNoFunc, writersSerialString, refCount;

  --- Internal Methods.
  -- 
  -- Not meant to be used directly, but can be.
  --
  --  *Stores persistence generation functions.*
  --
  -- Houses methods for interacting with files outside of the game.
  --
  -- ===
  --
  --     -Exports table of data from MissionScripting environment to text file
  --     -Imports table of data from text file to MissionScripting environment
  --     -Dumps table to string format
  --
  -- @section IO.persistence
  -- @field #persistence
  SPECTRE.IO.persistence = {}

  --- Transforms a table or value into its string representation.
  --
  --  @{SPECTRE.IO.persistence.dump}
  --
  -- A utility function crafted to convert a table into its string representation recursively.
  -- For any non-table values, the function will directly convert them into strings.
  --
  -- @param o The table or value that needs conversion.
  -- @return #string A string that represents the serialized form of the given table or value.
  -- @usage local serializedString = SPECTRE.IO.persistence.dump(dataTable) -- Retrieves the string format of `dataTable`.
  function SPECTRE.IO.persistence.dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. SPECTRE.IO.persistence.dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end

  --- Persists multiple Lua values by serializing and saving them to a file.
  --
  --  @{SPECTRE.IO.persistence.store}
  --
  -- A utility function designed to serialize multiple Lua values, including tables, into a string format.
  -- It then writes the serialized string into a specified file. This method ensures efficient storage by
  -- avoiding redundant storage of duplicate table references.
  --
  -- @param path The path where the serialized values should be written.
  -- @param ... Lua values that need to be serialized and persisted.
  -- @usage SPECTRE.IO.persistence.store("destination/file.txt", dataTable1, dataTable2) -- Serializes and saves `dataTable1` and `dataTable2` to the defined file.
  function SPECTRE.IO.persistence.store(path, ...)
    local file, e = io.open(path, "w")
    if not file then
      return error(e)
    end

    local n = select("#", ...)
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    file:write("-- Persistent Data\n")
    file:write("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        file:write("{};") -- table objRefIdx
      end
    end
    file:write("\n} -- multiRefObjects\n")

    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        file:write("multiRefObjects["..idx.."][")
        write(file, k, 0, objRefNames)
        file:write("] = ")
        write(file, v, 0, objRefNames)
        file:write(";\n")
      end
    end

    -- Create the remaining objects
    for i = 1, n do
      file:write("local obj"..i.." = ")
      write(file, (select(i,...)), 0, objRefNames)
      file:write("\n")
    end

    -- Return the serialized values
    if n > 0 then
      file:write("return obj1")
      for i = 2, n do
        file:write(", obj"..i)
      end
      file:write("\n")
    else
      file:write("return\n")
    end

    if type(path) == "string" then
      file:close()
    end
  end

  ---  NO FUNCTION OUTPUT VERSION.
  -- @param path The path where the serialized values should be written.
  -- @param ... Lua values that need to be serialized and persisted.
  -- @usage SPECTRE.IO.persistence.store("destination/file.txt", dataTable1, dataTable2) -- Serializes and saves `dataTable1` and `dataTable2` to the defined file.
  function SPECTRE.IO.persistence.storeNoFunc(path, ...)
    local file, e = io.open(path, "w")
    if not file then
      return error(e)
    end

    local n = select("#", ...)
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    file:write("-- Persistent Data\n")
    file:write("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        file:write("{};") -- table objRefIdx
      end
    end
    file:write("\n} -- multiRefObjects\n")

    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        file:write("multiRefObjects["..idx.."][")
        writeNoFunc(file, k, 0, objRefNames)
        file:write("] = ")
        writeNoFunc(file, v, 0, objRefNames)
        file:write(";\n")
      end
    end

    -- Create the remaining objects
    for i = 1, n do
      file:write("local obj"..i.." = ")
      writeNoFunc(file, (select(i,...)), 0, objRefNames)
      file:write("\n")
    end

    -- Return the serialized values
    if n > 0 then
      file:write("return obj1")
      for i = 2, n do
        file:write(", obj"..i)
      end
      file:write("\n")
    else
      file:write("return\n")
    end

    if type(path) == "string" then
      file:close()
    end
  end

  function SPECTRE.IO.persistence.serializeNoFunc(...)
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | ------------------------- ")
    local serialString_ = ""

    local n = select("#", ...)

    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | Count references ~~~~~ ")
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | Export Objects with more than one ref and assign name ~~~~~ ")
    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    serialString_ = serialString_ .. ("-- Persistent Data\n")
    serialString_ = serialString_ .. ("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        serialString_ = serialString_ .. ("{};") -- table objRefIdx
      end
    end
    serialString_ = serialString_ .. ("\n} -- multiRefObjects\n")

    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | Fill the multi-reference objects ~~~~~ ")
    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        serialString_ = serialString_ .. ("multiRefObjects["..idx.."][")
        serialString_ = writeSerialString(serialString_, k, 0, objRefNames)
        serialString_ = serialString_ .. ("] = ")
        serialString_ = writeSerialString(serialString_, v, 0, objRefNames)
        serialString_ = serialString_ .. (";\n")
      end
    end
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | Create the remaining objects ~~~~~ ")
    -- Create the remaining objects
    for i = 1, n do
      serialString_ = serialString_ .. ("local obj"..i.." = ")
      serialString_ = writeSerialString(serialString_, (select(i,...)), 0, objRefNames)
      serialString_ = serialString_ .. ("\n")
    end
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | Return the serialized values ~~~~~ ")
    -- Return the serialized values
    if n > 0 then
      serialString_ = serialString_ .. ("return obj1")
      for i = 2, n do
        serialString_ = serialString_ .. (", obj"..i)
      end
      serialString_ = serialString_ .. ("\n")
    else
      serialString_ = serialString_ .. ("return\n")
    end
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | serialString_ : " .. serialString_)
    return serialString_
  end


  --- Loads and executes Lua content from the specified path or file object.
  --
  --  @{SPECTRE.IO.persistence.load}
  --
  -- This utility function reads, loads, and executes Lua content from a given file path or a file-like object.
  -- If the content is successfully loaded and executed, the result of the execution is returned.
  -- In case of an error during loading, it returns `nil` alongside an error message.
  --
  -- @param serialString_
  -- @return e The result of the Lua content execution, or `nil` and an associated error message if an error occurs.
  -- @usage local executionResult = SPECTRE.IO.persistence.load("directory/luaScript.lua") -- Loads and executes the Lua script at the defined path.
  function SPECTRE.IO.persistence.deSerialize(serialString_)
    -- Attempt to load the serialized data string as a Lua chunk
    local f, e = loadstring(serialString_)
    if f then
      -- Execute the chunk to deserialize it into Lua objects
      return f()
    else
      -- Return nil and the error if the chunk cannot be loaded
      return nil, e
    end
  end

  --- Loads and executes Lua content from the specified path or file object.
  --
  --  @{SPECTRE.IO.persistence.load}
  --
  -- This utility function reads, loads, and executes Lua content from a given file path or a file-like object.
  -- If the content is successfully loaded and executed, the result of the execution is returned.
  -- In case of an error during loading, it returns `nil` alongside an error message.
  --
  -- @param path The path to the Lua file, or a file-like object containing Lua content.
  -- @return e The result of the Lua content execution, or `nil` and an associated error message if an error occurs.
  -- @usage local executionResult = SPECTRE.IO.persistence.load("directory/luaScript.lua") -- Loads and executes the Lua script at the defined path.
  function SPECTRE.IO.persistence.load(path)
    local f, e
    if type(path) == "string" then
      f, e = loadfile(path)
    else
      f, e = path:read('*a')
    end
    if f then
      return f()
    else
      return nil, e
    end
  end

  -- Private methods

  --- Writes the provided item to the file using the appropriate writer based on the item's type.
  --
  -- This function selects a writer function based on the type of the provided item and then invokes it.
  -- The writer functions are expected to be stored in the `writers` table, indexed by the item type.
  --
  -- @param file The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  write = function (file, item, level, objRefNames)
    writers[type(item)](file, item, level, objRefNames)
  end

  --- NO FUNCTION OUTPUT VERSION.
  --
  -- @param file The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  writeNoFunc = function (file, item, level, objRefNames)
    writersNoFunc[type(item)](file, item, level, objRefNames)
  end

  ---  serial OUTPUT VERSION.
  --
  -- @param serialString_ The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  writeSerialString = function (serialString_, item, level, objRefNames)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO.serializeNoFunc | START writeSerialString | ------------------")
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | pre serialString_ : " .. serialString_)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | item : " , item)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | level : " .. level)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | objRefNames : " , objRefNames)
    return writersSerialString[type(item)](serialString_, item, level, objRefNames)
  end

  --- Writes indentation to the provided file.
  --
  -- This function writes a specified number of tab characters to the given file, creating an indentation effect.
  --
  -- @param file The file object to write to.
  -- @param level The number of tab characters to write.
  -- @usage writeIndent(myFile, 3) -- Writes 3 tab characters to `myFile` for indentation.
  writeIndent = function (file, level)
    for i = 1, level do
      file:write("\t")
    end
  end

  writeIndentSerial = function (serialString_, level)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO.serializeNoFunc | writeIndentSerial | ------------------")
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | serialString_ : " .. serialString_)
--    SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | level : " .. level)
    for i = 1, level do
      serialString_ = serialString_ .. ("  ")
    end
    return serialString_
  end

  --- Counts references for tables recursively.
  --
  -- This function increases the reference count for tables. When encountering a table for the first time,
  -- it counts its references and then recursively counts the references of its keys and values.
  --
  -- @param objRefCount A table that stores reference counts for other tables.
  -- @param item The item (potentially a table) whose references are to be counted.
  -- @usage refCount(objRefCountTable, myTable) -- Counts references for `myTable` and updates `objRefCountTable`.
  refCount = function (objRefCount, item)
    --SPECTRE.UTILS.debugInfo("SPECTRE.IO:refCount | ~~~~~ ")
    -- only count reference types (tables)
    if type(item) == "table" then
      -- Increase ref count
      if objRefCount[item] then
        objRefCount[item] = objRefCount[item] + 1
      else
        objRefCount[item] = 1
        -- If first encounter, traverse
        for k, v in pairs(item) do
          refCount(objRefCount, k)
          refCount(objRefCount, v)
        end
      end
    end
  end

  --- Table of writer functions for serializing various types of Lua data.
  --
  -- Each function in this table converts a Lua value of a specific type into a string representation suitable for storing in a file.
  writers = {
    ["nil"] = function(file)
      file:write("nil")
    end,

    ["number"] = function(file, item)
      file:write(tostring(item))
    end,

    ["string"] = function(file, item)
      file:write(string.format("%q", item))
    end,

    ["boolean"] = function(file, item)
      if item then
        file:write("true")
      else
        file:write("false")
      end
    end,

    ["table"] = function(file, item, level, objRefNames)
      local refIdx = objRefNames[item]
      if refIdx then
        file:write("multiRefObjects["..refIdx.."]")
      else
        file:write("{\n")
        for k, v in pairs(item) do
          writeIndent(file, level+1)
          file:write("[")
          write(file, k, level+1, objRefNames)
          file:write("] = ")
          write(file, v, level+1, objRefNames)
          file:write(";\n")
        end
        writeIndent(file, level)
        file:write("}")
      end
    end,

    ["function"] = function(file, item)
      local dInfo = debug.getinfo(item, "uS")
      if dInfo.nups > 0 then
        file:write("nil --[[functions with upvalue not supported]]")
      elseif dInfo.what ~= "Lua" then
        file:write("nil --[[non-lua function not supported]]")
      else
        local r, s = pcall(string.dump,item)
        if r then
          file:write(string.format("loadstring(%q)", s))
        else
          file:write("nil --[[function could not be dumped]]")
        end
      end
    end,

    ["thread"] = function(file)
      file:write("nil --[[thread]]")
    end,

    ["userdata"] = function(file)
      file:write("nil --[[userdata]]")
    end
  }

  --- NO FUNCTION OUTPUT VERSION.
  writersNoFunc = {
    ["nil"] = function(file)
      file:write("nil")
    end,

    ["number"] = function(file, item)
      file:write(tostring(item))
    end,

    ["string"] = function(file, item)
      file:write(string.format("%q", item))
    end,

    ["boolean"] = function(file, item)
      if item then
        file:write("true")
      else
        file:write("false")
      end
    end,

    ["table"] = function(file, item, level, objRefNames)
      local refIdx = objRefNames[item]
      if refIdx then
        file:write("multiRefObjects["..refIdx.."]")
      else
        file:write("{\n")
        for k, v in pairs(item) do
          writeIndent(file, level+1)
          file:write("[")
          writeNoFunc(file, k, level+1, objRefNames)
          file:write("] = ")
          writeNoFunc(file, v, level+1, objRefNames)
          file:write(";\n")
        end
        writeIndent(file, level)
        file:write("}")
      end
    end,

    ["function"] = function(file, item)
      file:write("nil --[[INTENDEDSKIP]]")
    end,

    ["thread"] = function(file)
      file:write("nil --[[thread]]")
    end,

    ["userdata"] = function(file)
      file:write("nil --[[userdata]]")
    end
  }
  --- SERIAL OUTPUT VERSION.
  --
  --
  -- ---------------------------------------------
  --
  --
  writersSerialString = {
    ["nil"] = function(serialString_)
      return serialString_ .. ("nil")
    end,

    ["number"] = function(serialString_, item)
      return serialString_ .. (tostring(item))
    end,

    ["string"] = function(serialString_, item)
      return serialString_ .. (string.format("%q", item))
    end,

    ["boolean"] = function(serialString_, item)
      if item then
        return serialString_ .. ("true")
      else
        return serialString_ .. ("false")
      end
    end,

    ["table"] = function(serialString_, item, level, objRefNames)
--      SPECTRE.UTILS.debugInfo("SPECTRE.IO.serializeNoFunc | START writersSerialString | ------------------")
--      SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | pre serialString_ : " .. serialString_)
--      SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | item : " , item)
--      SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | level : " .. level)
--      SPECTRE.UTILS.debugInfo("SPECTRE.IO:serializeNoFunc | objRefNames : " , objRefNames)

      local refIdx = objRefNames[item]
      if refIdx then
        serialString_ = serialString_ .. ("multiRefObjects["..refIdx.."]")
      else
        serialString_ = serialString_ .. ("{\n")
        for k, v in pairs(item) do

          serialString_ = writeIndentSerial(serialString_, level+1)
          serialString_ = serialString_ .. ("[")
          serialString_ = writeSerialString(serialString_, k, level+1, objRefNames)
          serialString_ = serialString_ .. ("] = ")
          serialString_ = writeSerialString(serialString_, v, level+1, objRefNames)
          serialString_ = serialString_ .. (";\n")
        end
        serialString_ = writeIndentSerial(serialString_, level)
        serialString_ = serialString_ .. ("}")
      end
      return serialString_
    end,

    ["function"] = function(serialString_, item)
      return serialString_ .. ("nil --[[INTENDEDSKIP]]")
    end,

    ["thread"] = function(serialString_)
      return serialString_ .. ("nil --[[thread]]")
    end,

    ["userdata"] = function(serialString_)
      return serialString_ .. ("nil --[[userdata]]")
    end
  }
end



-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **MARKERS**
--
-- Management and Manipulation of Markers within SPECTRE.
--
--   * Provides functionalities to create, modify, and delete markers.
--
--   * Offers searching capabilities based on various marker attributes.
--
--   * Allows interaction with both player-specific and global world markers.
--
-- `EXAMPLE: To find a marker by its text, use the function: SPECTRE.MARKERS.World.FindByText("Target Location")`
--
-- ===
--
-- @module MARKERS
-- @extends SPECTRE

--- SPECTRE.MARKERS.
--
-- This module offers comprehensive control over markers within the SPECTRE system, facilitating operations like searching, modifying, and deleting markers both at the player and world level.
--
-- @section MARKERS
-- @field #MARKERS
SPECTRE.MARKERS = {}

--- World Markers.
--
-- Contains methods and functionalities to interact with world markers within the SPECTRE system.
-- This module provides ways to locate, remove, or inspect markers that are present in the global game environment based on attributes such as text or ID.
--
-- @section SPECTRE.MARKERS
-- @field #World
SPECTRE.MARKERS.World = {}

--- Search for a marker in the world using its text.
--
--  @{SPECTRE.MARKERS.World.FindByText}
--
-- Scans the world markers to identify a marker with the designated text.
--
-- @param Text The specific text string to look for among the world markers.
-- @return _item The marker entity that matches the given text, if located.
-- @usage local marker = SPECTRE.MARKERS.World.FindByText("Target Location") -- Locates the marker labeled "Target Location".
function SPECTRE.MARKERS.World.FindByText(Text)
  SPECTRE.UTILS.debugInfo("SPECTRE.MARKERS.World.FindByText | " ..  Text)
  local CurrentMarkersTable = world.getMarkPanels()

  -- Iterate over all markers to find the one with the specified text.
  for _, _item in pairs(CurrentMarkersTable) do
    --SPECTRE.UTILS.debugInfo("_item", _item)
    if _item.text == Text then
      SPECTRE.UTILS.debugInfo("SPECTRE.MARKERS.World.FindByText | MATCH ", _item)
      return _item
    end
  end

  -- If no marker found with the specified text, return nil.
  return nil
end

--- Remove a marker by its ID from the world.
--
--  @{SPECTRE.MARKERS.World.RemoveByID}
--
-- Erases a specified marker from the world using the marker's unique ID.
--
-- @param MarkerID The unique identifier of the marker that needs to be removed.
-- @usage SPECTRE.MARKERS.World.RemoveByID(5) -- Deletes the marker with ID 5 from the world.
function SPECTRE.MARKERS.World.RemoveByID(MarkerID)
  trigger.action.removeMark(MarkerID)
end

--- Markers Table.
--
-- Provides utilities to manage and manipulate player-specific marker tables within the SPECTRE system.
-- This includes functionalities to find, remove, or modify markers based on various attributes such as ID, text, or index.
--
-- @section SPECTRE.MARKERS
-- @field #Table
SPECTRE.MARKERS.Table = {}


--- Remove a marker by its index from a player's marker array.
--
--  @{SPECTRE.MARKERS.Table.RemoveByIndex}
--
-- Deletes a specific marker from the designated player's marker array using the marker's index.
--
-- @param Player The player object whose marker array will be updated.
-- @param Type The category or type of the marker.
-- @param Index The position or index of the marker within the array that needs to be removed.
-- @usage local somePlayer = { Markers = { CAP = { MarkerArrays = {...} } } }; SPECTRE.MARKERS.Table.RemoveByIndex(somePlayer, "CAP", 2) -- Erases the 2nd marker of type "CAP" from `somePlayer`'s marker array.
function SPECTRE.MARKERS.Table.RemoveByIndex(Player, Type, Index)
  table.remove(Player.Markers[Type].MarkerArrays, Index)
end


--- Find the index of a marker by its ID in a player's marker array.
--
--  @{SPECTRE.MARKERS.Table.FindIndexByID}
--
-- Searches through a specified marker array of a player to identify the index of a marker with the provided ID.
-- The function returns the index position if found, or `nil` if the marker ID is not present in the array.
--
-- @param PlayerUCID The unique ID of the player whose marker array will be examined.
-- @param Type The category or type of the marker.
-- @param ID The specific ID of the marker being searched for within the array.
-- @return #_i The index position of the marker within the marker array, or `nil` if not found.
-- @usage local markerIndex = SPECTRE.MARKERS.Table.FindIndexByID("12345678", "CAP", 5) -- Searches for the marker with ID 5 of type "CAP" in the marker array of the player with UCID "12345678".
function SPECTRE.MARKERS.Table.FindIndexByID(PlayerUCID, Type, ID)
  local markerType = SPECTRE.MARKERS.Settings[Type].MarkerEnum
  local markerArray = SPECTRE.PLAYER.Players[PlayerUCID][markerType .. "_Markers"].MarkerArrays

  -- Iterate over the marker array to find the index with the specified ID.
  for _i = 1, #markerArray do
    if markerArray[_i].MarkerID == ID then
      return _i
    end
  end

  -- If no marker found with the specified ID, return nil.
  return nil
end




-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **MENU**
--
-- `Manages all interactive menus for the SPECTRE framework`.
--
--   * `Provides tools for creating, displaying, and interacting with custom menus.`
--
--   * `Allows dynamic menu creation based on context and user roles.`
--
--   * `Ensures seamless user experience through intuitive menu navigation and prompts.`
--
-- ===
--
-- @module MENU
-- @extends SPECTRE

--- MENU.
--
-- `Manages all interactive menus for the SPECTRE framework`.
--
--   * `Provides tools for creating, displaying, and interacting with custom menus.`
--
--   * `Allows dynamic menu creation based on context and user roles.`
--
--   * `Ensures seamless user experience through intuitive menu navigation and prompts.`
--
-- @section SPECTRE.MENU
-- @field #MENU
SPECTRE.MENU = {}

--- Settings.
--
-- `Central configuration for various settings of the SPECTRE Custom Support Module.`
--
-- A collection of settings that dictate the behavior and properties of different custom supports in the SPECTRE module.
-- Each section corresponds to different types of support or actions available in the custom support system.
--
--   * Defines settings for different support types such as CAP, TOMAHAWK, AIRDROP, etc.
--   * Provides a structured way to retrieve and manage settings for different aspects of custom support.
--   * Facilitates easier modification and customization of support behavior and properties.
--
-- @section SPECTRE.MENU
-- @field #Settings
SPECTRE.MENU.Settings = {}

--- Settings.CAP.
--
--  `Configuration settings specific to CAP (Combat Air Patrol) support.`
--
--   * Defines template names for CAP support based on coalition (Blue or Red).
--   * Provides alias prefix for CAP, facilitating dynamic naming.
--
-- Contains configuration settings specific to CAP (Combat Air Patrol) support within the SPECTRE module.
--
-- @field #Settings.CAP
SPECTRE.MENU.Settings.CAP = {
  TemplateName = {Blue = "", Red = ""},
  AliasPrefix = "CAP_ID%d",
}
--- Settings.TOMAHAWK.
-- see `SPECTRE.MENU.Settings.CAP`
-- @field #Settings.TOMAHAWK
SPECTRE.MENU.Settings.TOMAHAWK = {
  TemplateName = {Blue = "", Red = ""},
}
--- Settings.BOMBER.
-- see `SPECTRE.MENU.Settings.CAP`
-- @field #Settings.BOMBER
SPECTRE.MENU.Settings.BOMBER = {
  TemplateName =  {Blue = "", Red = ""},
  AliasPrefix = "BOMBER_ID%d",
}
--- Settings.AIRDROP.
-- see `SPECTRE.MENU.Settings.CAP`
-- @field #Settings.AIRDROP
SPECTRE.MENU.Settings.AIRDROP = {
  TemplateName =  {Blue = "", Red = ""},
  AliasPrefix = "AIRDROP_TRANSPORT_%d",
  Types = {
    TANK = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "TANK_ID%d",
    },
    IFV = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "IFV_ID%d",
    },
    ARTILLERY = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "ARTILLERY_ID%d",
    },
    AAA = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "AAA_ID%d",
    },
    IRSAM = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "IRSAM_ID%d",
    },
    RDRSAM = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "RDRSAM_ID%d",
    },
    EWR = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "EWR_ID%d",
    },
    SUPPLY = {
      TemplateName =  {Blue = "", Red = ""},
      AliasPrefix = "SUPPLY_ID%d",
    },
  },
}
--- Settings.STRIKE.
-- see `SPECTRE.MENU.Settings.CAP`
-- @field #Settings.STRIKE
SPECTRE.MENU.Settings.STRIKE = {
  Units = {
    TemplateName =  {Blue = "", Red = ""},
    AliasPrefix = "STRIKE_ID%d",
  },
  Transport = {
    TemplateName =  {Blue = "", Red = ""},
    AliasPrefix = "STRIKE_TRANSPORT_ID%d",
  },
}

--- Stock Text.
--
--  `Central repository for all stock text messages related to the SPECTRE custom support system.`
--
-- A collection of stock texts that facilitate a consistent and easily maintainable system of messages.
-- Each section corresponds to different aspects or features of the SPECTRE custom support system.
--
--   * Simplifies the modification of messages and ensures consistency across the system.
--   * Provides a structured way to retrieve and manage pre-defined texts.
--   * Enhances maintainability by centralizing all textual content.
--
-- @section SPECTRE.MENU
-- @field #MENU.Text
SPECTRE.MENU.Text = {}

--- Text.Main.
-- @field #Text.Main
SPECTRE.MENU.Text.Main = {}
--- Main.Title.
-- @field #Text.Main.Title
SPECTRE.MENU.Text.Main.Title = "Point Redeem / Custom Support"
--- Main.PrintPoints.
-- @field #Text.Main.PrintPoints
SPECTRE.MENU.Text.Main.PrintPoints = "Print Point Balance"
--- Main.PrintInstructions.
-- @field #Text.Main.PrintInstructions
SPECTRE.MENU.Text.Main.PrintInstructions = "Print Instructions"
--- Main.InfoPoints.
-- @field #Text.Main.InfoPoints
SPECTRE.MENU.Text.Main.InfoPoints = "How to earn points"
--- Main.LowBalance.
-- @field #Text.Main.LowBalance
SPECTRE.MENU.Text.Main.LowBalance = "You do not have enough points to redeem this asset."
--- Main.OutOfStock.
-- @field #Text.Main.OutOfStock
SPECTRE.MENU.Text.Main.OutOfStock = "All resources of this type are currently tasked, try again later."
--- Main.PointBalance.
-- @field #Text.Main.PointBalance
SPECTRE.MENU.Text.Main.PointBalance = "Your Point balance for the current team:"

--- Text.CAP.
-- @field #Text.CAP
SPECTRE.MENU.Text.CAP = {}
--- CAP.Title.
-- @field #Text.CAP.Title
SPECTRE.MENU.Text.CAP.Title = "C.A.P."
--- CAP.Cost.
-- @field #Text.CAP.Cost
SPECTRE.MENU.Text.CAP.Cost =  ""
--- Text.TOMAHAWK.
-- @field #Text.TOMAHAWK
SPECTRE.MENU.Text.TOMAHAWK = {}
--- TOMAHAWK.Title.
-- @field #Text.TOMAHAWK.Title
SPECTRE.MENU.Text.TOMAHAWK.Title = "Tomahawk Strike"
--- TOMAHAWK.Cost.
-- @field #Text.TOMAHAWK.Cost
SPECTRE.MENU.Text.TOMAHAWK.Cost =  ""
--- Text.BOMBER.
-- @field #Text.BOMBER
SPECTRE.MENU.Text.BOMBER = {}
--- BOMBER.Title.
-- @field #Text.BOMBER.Title
SPECTRE.MENU.Text.BOMBER.Title = "B52 Strike"
--- BOMBER.Cost.
-- @field #Text.BOMBER.Cost
SPECTRE.MENU.Text.BOMBER.Cost =  ""
--- Text.AIRDROP.
-- @field #Text.AIRDROP
SPECTRE.MENU.Text.AIRDROP = {}
--- AIRDROP.Title.
-- @field #Text.AIRDROP.Title
SPECTRE.MENU.Text.AIRDROP.Title = "Airdrop Units"
--- AIRDROP.Cost.
-- @field #Text.AIRDROP.Cost
SPECTRE.MENU.Text.AIRDROP.Cost =  ""
--- Text.STRIKE.
-- @field #Text.STRIKE
SPECTRE.MENU.Text.STRIKE = {}
--- STRIKE.Title.
-- @field #Text.STRIKE.Title
SPECTRE.MENU.Text.STRIKE.Title = "Strike Team"
--- STRIKE.Cost.
-- @field #Text.STRIKE.Cost
SPECTRE.MENU.Text.STRIKE.Cost =  ""

--- Stock Reports.
--
-- `Provides predefined textual reports for various menu functionalities in the SPECTRE framework`.
--
--   * `Centralized location for all textual content ensuring consistency and easy updates.`
--
--   * `Covers a variety of menu functionalities from earning points to specific instructions for custom actions.`
--
--   * `Supports dynamic string formatting for context-specific information.`
--
-- @section SPECTRE.MENU
-- @field #Text.Reports
SPECTRE.MENU.Text.Reports = {}
--- Reports.EarningPoints.
-- @field #Text.Reports.EarningPoints
SPECTRE.MENU.Text.Reports.EarningPoints = {
  "Earn points by destroying units. High tier units reward more points.",
  "--------------------------------",
  " ",
  "** Suicide runs will not be rewarded. **",
  "*** You must still be alive when a unit is destroyed to receive points. ***",
  " ",
  "** Destroying ally assets incurs a penalty based on the equivalent enemy unit reward amount. **",
}
--- Text.Reports.Instructions.
-- @field #Text.Reports.Instructions
SPECTRE.MENU.Text.Reports.Instructions = {}
--- Reports.Instructions.AIRDROPCOST
-- @field #Text.Reports.Instructions.AIRDROPCOST
SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
  "Airdrop Group {Type} Costs:",
  "================================",
  "",
  "Usage: /airdrop artillery",
  string.format("Artillery Cost: %d Points", 0),
  "Usage: /airdrop ifv",
  string.format("Infantry Fighting Vehicle Cost: %d Points", 0),
  "Usage: /airdrop tank",
  string.format("Tank Cost: %d Points", 0),
  "Usage: /airdrop aaa",
  string.format("Anti-Aircraft Artillery Cost: %d Points", 0),
  "Usage: /airdrop irsam",
  string.format("IR SAM Cost: %d Points", 0),
  "Usage: /airdrop rdrsam",
  string.format("Radar SAM Cost: %d Points", 0),
  "Usage: /airdrop ewr",
  string.format("Early Warning Radar Cost: %d Points", 0),
  "Usage: /airdrop supply",
  string.format("Supply Cost: %d Points", 0),
}
--- Reports.Instructions.CAP
-- @field #Text.Reports.Instructions.CAP
SPECTRE.MENU.Text.Reports.Instructions.CAP = {
  "Custom CAP Instructions:",
  "================================",
  " ",
  "   Request A.I. units from friendly airbase nearest the marker to patrol the desired position.",
  " ",
  "   Circular Orbit:",
  "1. Place a marker on the F10 map where you want C.A.P.",
  "2. Add the text '/cap' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to spawn the CAP flight!",
  "-------------------------------",
  "   Racetrack Pattern:",
  "1. Place a marker on the F10 map where you want C.A.P.",
  "2. Add the text '/cap {heading} {distance}' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to spawn the CAP flight!",
  "-------------------------------",
  "** Be sure to use the correct format! /cap ### ##  **",
  "*** /cap 3numbers 2numbers ***",
  "**** When deciding on placement, keep in mind the locations of enemy SAM threats! ****",
}
--- Reports.Instructions.TOMAHAWK
-- @field #Text.Reports.Instructions.TOMAHAWK
SPECTRE.MENU.Text.Reports.Instructions.TOMAHAWK = {
  "Custom Tomahawk Strike Instructions:",
  "================================",
  " ",
  "Usage: /tomahawk",
  "1. Place a marker on the F10 map where you want a naval strike.",
  "2. Add the text '/tomahawk' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to call in the Tomahawk Strike!",
  "-------------------------------",
  "**** When deciding on placement, keep in mind the locations of enemy anti-missile threats! ****",
}
--- Reports.Instructions.BOMBER
-- @field #Text.Reports.Instructions.BOMBER
SPECTRE.MENU.Text.Reports.Instructions.BOMBER = {
  "Custom B-52 Bomber Strike Instructions:",
  "================================",
  "",
  "Request B-52H units from friendly airbase nearest the marker to carpet bomb the desired area.",
  "",
  "Usage: /bomber",
  "1. Place a marker on the F10 map where you want a B-52 carpet bomb.",
  "2. Add the text '/bomber' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to call in the B-52 Strike!",
  "-------------------------------",
  "** When deciding on placement, keep in mind the locations of enemy threats! **",
  "**** Protect your bombers! If they are shot down, you will NOT be refunded! ****",
}
--- Reports.Instructions.AIRDROP
-- @field #Text.Reports.Instructions.AIRDROP
SPECTRE.MENU.Text.Reports.Instructions.AIRDROP = {
  "Custom Airdrop Instructions:",
  "================================",
  "",
  "Request a transport from friendly airbase nearest the marker to airdrop units at a location.",
  "",
  "Usage: /airdrop {type}",
  "1. Place a marker on the F10 map where you want to airdrop units.",
  "2. Add the text '/airdrop {type}' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to task a transport for the airdrop!",
  "-------------------------------",
  "~~ All airdropped units may be controlled via Combined Arms ~~",
  "-------------------------------",
  "EX: '/airdrop ifv' will task a transport to airdrop an IFV group at the desired location.",
  "** Be sure to protect your airdrop transport! If they are destroyed, you will NOT be refunded **",
  "**** The transport must make it within 3nm of your marker to spawn units. ****",
  "-------------------------------",
  "Use menu option 'Print Airdrop Types & Costs' for a full list of airdrop unit types and costs",
}
--- Reports.Instructions.STRIKE
-- @field #Text.Reports.Instructions.STRIKE
SPECTRE.MENU.Text.Reports.Instructions.STRIKE = {
  "Strike Team Instructions:",
  "================================",
  "",
  "Request A.I. from friendly airbase nearest the marker to drop troops at the marker.",
  "",
  "Usage: /strike",
  "1. Place a marker on the F10 map at a position you wish to assault.",
  "2. Add the text '/strike' to the marker (no quotes).",
  "3. The marker will be updated with an ID number.",
  "4. Look for the ID in this menu to task a strike team to location!",
  "-------------------------------",
  "~~ The strike team consists of helicopters which will attempt to drop soldiers at the marker.~~",
  "",
  "** Protect your strike team! If they are destroyed enroute, you will NOT be refunded. **",
  "**** The transport must make it within 0.3nm of your marker to drop the strike team. ****",
}

--- Print.
--
-- Contains a set of functions designed to communicate various custom support-related information to players.
-- Each function is crafted to present specific details, guidelines, or status updates, ensuring players are well-informed.
--
-- @section SPECTRE.MENU
-- @field #MENU.Print
SPECTRE.MENU.Print = {}

--- Display the current point balance of a player.
--
--  @{SPECTRE.MENU.Print.Balance}
--
-- This function generates a report detailing the player's current point balance.
-- It then displays this report to the player's group, providing a visual representation of their available points.
--
-- @param Player The player whose point balance will be displayed.
-- @usage SPECTRE.MENU.Print.Balance(somePlayer) -- Presents the player's point balance.
function SPECTRE.MENU.Print.Balance(Player)
  -- Create a new report with the main point balance text.
  local report = REPORT:New(SPECTRE.MENU.Text.Main.PointBalance)
  report:Add("================================")
  report:Add("")
  report:Add(string.format("%d Points", Player.Points[Player.side]))
  trigger.action.outTextForGroup(Player.GroupID, report:Text(), 15)
end

--- Placeholder function that performs no actions.
--
--  @{SPECTRE.MENU.Print.NULL}
--
-- This function exists as a placeholder or stub and doesn't execute any operations when called.
-- It can be used as a default callback or to indicate that a particular action is intentionally left blank.
--
-- @usage SPECTRE.MENU.Print.NULL() -- Executes no actions.
function SPECTRE.MENU.Print.NULL()
  -- Placeholder function: No operations performed here.
  return
end

--- Displays instructions detailing the costs associated with an airdrop.
--
--  @{SPECTRE.MENU.Print.AirdropCost}
--
-- This function provides players with a breakdown of the costs involved when requesting an airdrop.
-- By detailing these costs, players can make informed decisions about when and how frequently to request airdrops,
-- ensuring they manage their resources efficiently.
--
-- @param Player The player who will be informed about the airdrop costs.
-- @usage SPECTRE.MENU.Print.AirdropCost(currentPlayer) -- Provides currentPlayer with a detailed breakdown of airdrop costs.
function SPECTRE.MENU.Print.AirdropCost(Player)
  -- Generate a report with the airdrop cost instructions.
  local report = SPECTRE.UTILS.ReportGenerator(SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST)

  -- Display the report text to the player's group.
  trigger.action.outTextForGroup(Player.GroupID, report:Text(), 45)
end

--- Stock Instructions.
--
-- `Provides a collection of print functions to display instructions related to custom support within the SPECTRE system.`
--
-- Contains a set of functions that display various instructions to players regarding custom support features in the SPECTRE system.
-- Each function in this subclass is tailored to a specific instruction set, ensuring clarity and comprehensibility.
--
--   * Centralizes all instruction print functions.
--   * Ensures players receive consistent and clear guidance.
--   * Facilitates easy updates or additions to instruction sets.
--
-- @field #Print.Instructions
SPECTRE.MENU.Print.Instructions = {}

--- Displays instructions to the player on how to earn points.
--
--  @{SPECTRE.MENU.Print.Instructions.EarningPoints}
--
-- This function provides the player with a guide on the various ways to accumulate points within the game.
-- By presenting this information, players can understand the mechanics better and strategize their gameplay to maximize point acquisition.
--
-- @param Player The player who will be informed about the methods of earning points.
-- @usage SPECTRE.MENU.Print.Instructions.EarningPoints(currentPlayer) -- Provides currentPlayer with a detailed guide on how to earn points.
function SPECTRE.MENU.Print.Instructions.EarningPoints(Player)
  -- Generate a report with the instructions for earning points.
  local report = SPECTRE.UTILS.ReportGenerator(SPECTRE.MENU.Text.Reports.EarningPoints)

  -- Display the report text to the player's group.
  trigger.action.outTextForGroup(Player.GroupID, report:Text(), 45)
end

--- Displays instructions based on the provided menu type to the player.
--
--  @{SPECTRE.MENU.Print.Instructions_}
--
-- This function retrieves the instructions associated with the specified menu type and displays them to the player.
-- The instructions help guide the player in understanding the actions or options available within a particular menu.
--
-- @param menuType The specific type of menu for which instructions are being sought.
-- @param Player The player who will view the instructions.
-- @usage SPECTRE.MENU.Print.Instructions_("CAP", currentPlayer) -- Presents the instructions for the CAPMenu to the currentPlayer.
function SPECTRE.MENU.Print.Instructions_(menuType, Player)
  -- Generate a report with the instructions for the given menu type.
  local report = SPECTRE.UTILS.ReportGenerator(SPECTRE.MENU.Text.Reports.Instructions[menuType])

  -- Display the report text to the player's group.
  trigger.action.outTextForGroup(Player.GroupID, report:Text(), 60)
end

--- Buttons.
--
--   `Handles the creation and management of menu buttons within the SPECTRE system.`
--
-- Provides utilities and functions related to menu button creation, management, and interaction in the SPECTRE system.
-- This subclass ensures that in-game menus are interactive, dynamic, and tailored to the player's needs and actions.
--
--   * Allows for dynamic generation of in-game menu buttons.
--   * Provides functions to dispatch, activate, or deactivate menu buttons.
--   * Ensures efficient and user-friendly menu navigation.
--
-- @section SPECTRE.MENU
-- @field #MENU.Buttons
SPECTRE.MENU.Buttons = {}

--- Manages and dispatches menu buttons based on player and type.
--
--  @{SPECTRE.MENU.Buttons.Dispatcher}
--
-- This function handles the dispatch of menu buttons depending on the provided type and player.
-- It performs various checks including resource availability and player points balance before
-- executing the dispatch. It also updates related resources, player points, and provides coalition-wide notifications.
--
-- @param MANAGER The central manager responsible for overseeing resources.
-- @param Player The player requesting the dispatch action.
-- @param Type The type of action being dispatched (e.g., "AIRDROP").
-- @param MarkerIndex The index of the marker associated with the dispatch.
-- @usage SPECTRE.MENU.Buttons.Dispatcher(managerInstance, somePlayer, "AIRDROP", 1) -- Initiates an airdrop based on the specified marker for the provided player.
SPECTRE.MENU.Buttons.Dispatcher = function(MANAGER, Player, Type, MarkerIndex)
  -- Debugging segment
  SPECTRE.UTILS.debugInfo("SPECTRE.MENU.Buttons.Dispatcher")
  SPECTRE.UTILS.debugInfo("MANAGER",MANAGER)
  SPECTRE.UTILS.debugInfo("Player",Player)
  SPECTRE.UTILS.debugInfo("Type",Type)
  SPECTRE.UTILS.debugInfo("MarkerIndex",MarkerIndex)
  SPECTRE.UTILS.debugInfo("MANAGER.RESOURCES",MANAGER.RESOURCES)

  -- Retrieve player data and associated CAP marker details
  local _MarkerArray = Player.Markers[Type].MarkerArrays[MarkerIndex]
  local DROPTYPE = _MarkerArray.Packet.MarkerType[2] or nil
  local Coordinate = _MarkerArray.MarkCoords
  local descriptor = _MarkerArray.descriptor
  local _ResourceCounter
  local points = Player.Points[Player.side]
  local _sideText
  if  Player.side == 1 then _sideText = "Red" else _sideText = "Blue" end

local flag_NOREDEEM = false

  if Type == "AIRDROP" and DROPTYPE then
    _ResourceCounter = MANAGER.RESOURCES[Type][DROPTYPE][_sideText]
    -- Check if resources are available
    if _ResourceCounter == 0 then
      trigger.action.outTextForGroup(Player.GroupID, SPECTRE.MENU.Text.Main.OutOfStock, 15)
      flag_NOREDEEM = true
      
      -- Check if player has enough points
    elseif points < SPECTRE.REWARDS.Config.PointCost[Type][DROPTYPE] then
    flag_NOREDEEM = true
      trigger.action.outTextForGroup(Player.GroupID, SPECTRE.MENU.Text.Main.LowBalance, 15)
    else
      -- Deduct points and update resources
      Player.Points[Player.side] = Player.Points[Player.side] - SPECTRE.REWARDS.Config.PointCost[Type][DROPTYPE]
      MANAGER.RESOURCES[Type][DROPTYPE][_sideText] = MANAGER.RESOURCES[Type][DROPTYPE][_sideText] - 1
      _ResourceCounter = MANAGER.RESOURCES[Type][DROPTYPE][_sideText]
    end

  else
    _ResourceCounter = MANAGER.RESOURCES[Type][_sideText]
    -- Check if resources are available
    if _ResourceCounter == 0 then
    flag_NOREDEEM = true
      trigger.action.outTextForGroup(Player.GroupID, SPECTRE.MENU.Text.Main.OutOfStock, 15)
      -- Check if player has enough points
    elseif points < SPECTRE.REWARDS.Config.PointCost[Type] then
    flag_NOREDEEM = true
      trigger.action.outTextForGroup(Player.GroupID, SPECTRE.MENU.Text.Main.LowBalance, 15)
    else
      -- Deduct points and update resources
      Player.Points[Player.side] = Player.Points[Player.side] - SPECTRE.REWARDS.Config.PointCost[Type]
      MANAGER.RESOURCES[Type][_sideText] =  MANAGER.RESOURCES[Type][_sideText] - 1
      _ResourceCounter = MANAGER.RESOURCES[Type][_sideText]
    end
  end
if flag_NOREDEEM == false then
  -- Inform coalition about the dispatched CAP
  local report = REPORT:New(Type .. " has been dispatched!")
  report:Add("================================")
  report:Add("ORDERS: " .. descriptor)
  report:AddIndent("AO: " .. Coordinate:ToStringMGRS(nil), "-")
  report:AddIndent("Requested By: " .. Player.name, "-")
  report:AddIndent("Resources available: " .. _ResourceCounter, "-")
  trigger.action.outTextForCoalition(Player.side, report:Text(), 30)

  --    Call the TYPE spawner function
  MANAGER.TRACKERS[Type][MarkerIndex] = MANAGER.SPAWNER[Type](MANAGER, Player, MarkerIndex)

  -- Remove markers
  SPECTRE.MARKERS.Table.RemoveByIndex(Player, Type, MarkerIndex)
  Player.Markers[Type].MenuArrays.Main:RemoveSubMenus() -- Remove the support menu for TYPE operations
  Player:setupSubMenu(Type, MANAGER) -- Build the support menu for TYPE operations
  end
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **PLYRMGR**
--
-- Comprehensive player management module within the SPECTRE framework.
--
--   * Manages player data, including points, groups, and slots.
--   * Handles dynamic support functionalities like CAP, AIRDROP, and STRIKE.
--   * Integrates with in-game events for real-time player updates.
--
--
-- ===
--
-- @module PLYRMGR
-- @extends SPECTRE

--- PLYRMGR.
--
-- This field represents the player management system within the broader SPECTRE framework. It includes functionalities
-- for random seed generation, resource management, and player-specific operations. The module manages various aspects
-- of player interaction and gameplay within the simulation environment.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR
SPECTRE.PLYRMGR = {
  _randSeedMin = 500, -- Minimum value for the random seed generator.
  _randSeedMax = 2000, -- Maximum value for the random seed generator.
  _randSeedNom = 2000, -- Nominal value for the random seed generator.
  _randSeedNudge = 0.7 -- Nudge factor for the random seed generation process.
}

--- A table storing player-related data, indexed by player UCID.
-- This table is used to keep track of individual player data within the SPECTRE.PLYRMGR system.
-- @field #PLYRMGR.Players
SPECTRE.PLYRMGR.Players = {}


--- A table to store tracking information related to player actions or events.
-- It is used to monitor and manage various player-related events and actions in the game.
-- @field #PLYRMGR.TRACKERS
SPECTRE.PLYRMGR.TRACKERS = {}

--- An instance of an EVENT object to handle various game or simulation events.
-- This object is pivotal for event handling within the SPECTRE.PLYRMGR system.
-- @field #PLYRMGR.Handler_
SPECTRE.PLYRMGR.Handler_ = EVENT:New()

--- Settings.
-- ===
--
-- *All Functions associated with Settings.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- A table to store the settings for the SPECTRE.PLYRMGR system.
-- This includes various configurations and options that dictate the behavior of the system.
-- @field #PLYRMGR.Settings
SPECTRE.PLYRMGR.Settings = {}

--- Indicates whether a reward system is active within the SPECTRE.PLYRMGR system.
-- A true value enables the reward system, while false disables it.
SPECTRE.PLYRMGR.Settings.Rewards = false

--- Indicates whether data persistence across sessions or events is active.
-- A true value enables data persistence, while false disables it.
SPECTRE.PLYRMGR.Settings.Persistance = false

--- A table to store report templates for the SPECTRE.PLYRMGR system.
SPECTRE.PLYRMGR.Settings.Reports = {}

--- The welcome report template for the SPECTRE.PLYRMGR system.
SPECTRE.PLYRMGR.Settings.Reports.Welcome = {
  "Welcome to S.P.E.C.T.R.E. Dynamic Campaign!",
  "================================",
  "MISSION: Capture all enemy zones.",
}

--- Specifies which type of support functionalities are active (CAP, TOMAHAWK, BOMBER, etc.).
-- This table is used to enable or disable different support functionalities within the SPECTRE.PLYRMGR system.
-- @field #PLYRMGR.Settings.Support
SPECTRE.PLYRMGR.Settings.Support = {}

--- Indicates whether CAP (Combat Air Patrol) support is active.
SPECTRE.PLYRMGR.Settings.Support.CAP = false

--- Indicates whether TOMAHAWK support is active.
SPECTRE.PLYRMGR.Settings.Support.TOMAHAWK = false

--- Indicates whether BOMBER support is active.
SPECTRE.PLYRMGR.Settings.Support.BOMBER = false

--- Indicates whether AIRDROP support is active.
SPECTRE.PLYRMGR.Settings.Support.AIRDROP = false

--- Indicates whether STRIKE support is active.
SPECTRE.PLYRMGR.Settings.Support.STRIKE = false

--- Create a new player manager instance.
--
-- This function initializes a new player manager instance, inheriting properties from the SPECTRE base class.
-- It also generates a random seed count within specified parameters and iterates through the 'math.random()' function
-- that number of times to ensure varied randomization in subsequent operations.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The newly created player manager instance.
function SPECTRE.PLYRMGR:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  -- Generate a nominal random seed count based on defined parameters.
  local _randseedCount = SPECTRE.UTILS.generateNominal(self._randSeedNom, self._randSeedMin, self._randSeedMax, self._randSeedNudge)

  -- Iterate through 'math.random()' to ensure varied randomization.
  for _seedC = 1, _randseedCount, 1 do
    math.random()
  end
  return self
end

--- Sets the point cost for CAP custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_CAP(cost_)
  SPECTRE.REWARDS.Config.PointCost.CAP = cost_
  SPECTRE.MENU.Text.CAP.Cost = string.format("C.A.P. Cost: %d Points", cost_)
  return self
end

--- Sets the point cost for TOMAHAWK custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_TOMAHAWK(cost_)
  SPECTRE.REWARDS.Config.PointCost.TOMAHAWK = cost_
  SPECTRE.MENU.Text.TOMAHAWK.Cost = string.format("Tomahawk Cost: %d Points", cost_)
  return self
end

--- Sets the point cost for BOMBER custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_BOMBER(cost_)
  SPECTRE.REWARDS.Config.PointCost.BOMBER = cost_
  SPECTRE.MENU.Text.BOMBER.Cost = string.format("Bomber Cost: %d Points", cost_)
  return self
end

--- Sets the point cost for STRIKE custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_STRIKE(cost_)
  SPECTRE.REWARDS.Config.PointCost.STRIKE = cost_
  SPECTRE.MENU.Text.STRIKE.Cost = string.format("Strike Team Cost: %d Points", cost_)
  return self
end

--- Sets the point cost for AIRDROP_ARTILLERY custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_ARTILLERY(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }

  return self
end
--- Sets the point cost for AIRDROP_IFV custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_IFV(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_TANK custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_TANK(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_AAA custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_AAA(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_IRSAM custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_IRSAM(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_RDRSAM custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_RDRSAM(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_EWR custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_EWR(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end

--- Sets the point cost for AIRDROP_SUPPLY custom support redemption.
-- @param #PLYRMGR self
-- @param cost_
-- @return #PLYRMGR self
function SPECTRE.PLYRMGR:setPointCost_AIRDROP_SUPPLY(cost_)
  SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY = cost_

  SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
    "Airdrop Group {Type} Costs:",
    "================================",
    "",
    "Usage: /airdrop artillery",
    string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
    "Usage: /airdrop ifv",
    string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
    "Usage: /airdrop tank",
    string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
    "Usage: /airdrop aaa",
    string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
    "Usage: /airdrop irsam",
    string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
    "Usage: /airdrop rdrsam",
    string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
    "Usage: /airdrop ewr",
    string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
    "Usage: /airdrop supply",
    string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
  }
  return self
end



--- Init.
-- ===
--
-- *All Functions associated with Init operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Initialize the SPECTRE.PLYRMGR instance.
--
-- This function is responsible for initializing various subsystems of the player manager instance.
-- It includes initializing the reward system, tracking system, and persistence system.
-- Additionally, it registers an event handler for the event when a player enters an aircraft.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The initialized player manager instance.
function SPECTRE.PLYRMGR:Init()
  -- Initialize the reward system.
  self:RewardsInit()

  -- Initialize the tracking system.
  self:TrackersInit()

  -- Initialize the persistence system.
  self:PersistanceInit()

  -- Register the event handler for when a player enters an aircraft.
  self:HandleEvent(EVENTS.PlayerEnterAircraft, self.PlayerEnterAircraft_)

  return self
end

--- Initialize the rewards system for the SPECTRE.PLYRMGR instance.
--
-- This function is tasked with setting up the rewards system within the player manager instance.
-- It checks whether the rewards system is enabled in the settings, and if so, it sets up an event handler
-- that is responsible for rewarding players for kill events. This setup ensures that players receive appropriate
-- rewards for their in-game actions when the rewards system is active.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after initializing the rewards system.
function SPECTRE.PLYRMGR:RewardsInit()
  -- Check if the rewards system is enabled in the settings.
  if self.Settings.Rewards then
    -- Set up an event handler for rewarding players upon kill events.
    self:HandleEvent(EVENTS.Kill, self.RewardKillEvent_)
  end
  return self
end

--- Initialize the persistence system for the SPECTRE.PLYRMGR instance.
--
-- This function sets up the persistence system within the player manager instance, provided that persistence is enabled in the settings.
-- It begins by importing existing persistence data, detecting any existing units within the mission, and then proceeds to set up
-- event handlers for player actions and mission events that are relevant to maintaining persistence. These event handlers are crucial for
-- tracking and responding to various scenarios, such as players leaving units, crashes, and the end of the mission, ensuring
-- the persistence of game state across sessions.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after initializing the persistence system.
function SPECTRE.PLYRMGR:PersistanceInit()
  -- Check if the persistence system is enabled in the settings.
  if self.Settings.Persistance then
    -- Import persistence data.
    self:ImportData()
    -- Detect existing units in the mission.
    self:DetectExistingUnits()
    -- Set up event handlers for player actions and mission events related to persistence.
    self:HandleEvent(EVENTS.PlayerLeaveUnit, self.PlayerLeaveUnit_)
    self:HandleEvent(EVENTS.Crash, self.CrashEvent_)
    self:HandleEvent(EVENTS.MissionEnd, self.EndMission_)
  end
  return self
end

--- Initialize the trackers for the SPECTRE.PLYRMGR.Manager instance based on the support settings.
--
-- This function is responsible for setting up trackers and event handlers for various types of support.
-- It iterates over all support settings and initializes trackers for each enabled support type. This involves setting up specific marker
-- functions and event handlers to track changes in markers related to each type of support. The function ensures that appropriate tracking
-- mechanisms are in place for the enabled support features, facilitating efficient management and response to in-game events.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after initializing the trackers.
-- @usage manager:TrackersInit() -- Initialize trackers based on the manager's support settings.
function SPECTRE.PLYRMGR:TrackersInit()
  -- Iterate over all support settings
  for supportType, isEnabled in pairs(self.Settings.Support) do
    -- Initialize tracker if the support type is not "ESCORT" and it is enabled
    if isEnabled then
      self.TRACKERS[supportType] = {}

      -- Set the event marker function
      self._EventMarker = self["_EventMarker"]

      local markerSettings = self.MARKERS.Settings[supportType]
      if not markerSettings.KeyWords or #markerSettings.KeyWords == 0 then
        self.MARKERS.TRACKERS[supportType] = MARKEROPS_BASE:New(markerSettings.TagName, markerSettings.CaseSensitive)
      else
        self.MARKERS.TRACKERS[supportType] = MARKEROPS_BASE:New(markerSettings.TagName, markerSettings.KeyWords, markerSettings.CaseSensitive)
      end

      -- Set up event handler for changes in markers
      self.MARKERS.TRACKERS[supportType].OnAfterMarkChanged = function(From, Event, To, Text, Keywords, Coord)
        local origText = Keywords
        local sanitizedText = Keywords:gsub("/", ""):upper()
        local MarkerInfo = {}
        for word in sanitizedText:gmatch("%w+") do table.insert(MarkerInfo, word) end

        local Packet = {
          From = From,
          Event = Event,
          To = To,
          Text = Text,
          origText = origText,
          sanitizedText = sanitizedText,
          MarkerType = MarkerInfo,
          Keywords = Keywords,
          Coord = Coord,
        }
        self  = self._EventMarker(self, Packet)
        return self
      end
    end
  end
  return self
end

--- Schedulers.
-- ===
--
-- *All Functions associated with Schedulers operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Schedule a resource restock for a given coalition and type.
--
-- This function is responsible for scheduling the restocking of resources. It handles both general resource types and
-- specific types related to airdrops. Based on the coalition number and resource type, it updates resource counters and
-- notifies the appropriate coalition about the restock. It includes a timer to handle the restocking process after a specified delay.
--
-- @param #PLYRMGR self The instance of the player manager.
-- @param coal Coalition number (2 for Blue, otherwise Red).
-- @param type The general resource type.
-- @param AIRDROPTYPE The specific type for airdrops (optional).
-- @return #PLYRMGR self The updated player manager instance after scheduling the restock.
function SPECTRE.PLYRMGR:scheduleRestock(coal, type, AIRDROPTYPE)
  -- Determine the coalition name based on the given number.
  local coal_ = (coal == 2) and "Blue" or "Red"

  -- Create a timer to handle the restock.
  local restockTimer = TIMER:New(function()
    local report
    if not AIRDROPTYPE then
      -- Update resource counters for general types.
      self.RESOURCES[type][coal_] = self.RESOURCES[type][coal_] + 1
      self.COUNTERS.RESTOCK[type][coal_] = self.COUNTERS.RESTOCK[type][coal_] - 1
      report = REPORT:New("A new custom " .. type .. " is available for tasking.")
      report:AddIndent("Total " .. type .. " Resources available: " .. self.RESOURCES[type][coal_], "-")
    else
      -- Update resource counters for specific airdrop types.
      self.RESOURCES[type][AIRDROPTYPE][coal_] = self.RESOURCES[type][AIRDROPTYPE][coal_] + 1
      self.COUNTERS.RESTOCK[type][AIRDROPTYPE][coal_] = self.COUNTERS.RESTOCK[type][AIRDROPTYPE][coal_] - 1
      report = REPORT:New("New " .. AIRDROPTYPE .. " group is available for airdrop.")
      report:AddIndent("Total " .. AIRDROPTYPE .. " Resources available: " .. self.RESOURCES[type][AIRDROPTYPE][coal_], "-")
    end
    -- Notify the coalition about the restock.
    trigger.action.outTextForCoalition(coal, report:Text(), 10 )
  end)

  -- Update the restock counter immediately.
  if not AIRDROPTYPE then
    self.COUNTERS.RESTOCK[type][coal_] = self.COUNTERS.RESTOCK[type][coal_] + 1
  else
    self.COUNTERS.RESTOCK[type][AIRDROPTYPE][coal_] = self.COUNTERS.RESTOCK[type][AIRDROPTYPE][coal_] + 1
  end

  -- Start the restock timer (after a 30-second delay).
  restockTimer:Start(30)
  return self
end

--- Persistence.
-- ===
--
-- *All Functions associated with Persistence operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Import resource data for the SPECTRE.PLYRMGR instance.
--
-- This function is responsible for importing resource data into the player manager instance.
-- It achieves this by calling the Import method on the RESOURCES member of the player manager,
-- effectively loading and integrating resource data into the manager's operational context.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after importing the resource data.
function SPECTRE.PLYRMGR:ImportData()
  -- Call the Import method on the RESOURCES member to load the resource data.
  self.RESOURCES:Import()
  return self
end

--- Enable Toggles.
-- ===
--
-- *All Functions associated with Enable Toggles.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Enable or disable all support settings for the SPECTRE.PLYRMGR instance.
--
-- This function is responsible for toggling the status of all support settings within the player manager instance.
-- It sets the value of each support setting based on the provided 'enabled' parameter. If no value is given,
-- it defaults to enabling all support settings ('true'). This function allows for a comprehensive and quick
-- adjustment of all support settings in a single call, either enabling or disabling them as required.
--
-- @param #PLYRMGR self The player manager instance for which support settings are to be adjusted.
-- @param enabled A boolean value (true or false) to enable or disable all support settings respectively. Defaults to true if not specified.
-- @return #PLYRMGR self The player manager instance after adjusting the support settings.
function SPECTRE.PLYRMGR:enableSupport_All(enabled)
  -- Default to true if no value is provided.
  enabled = enabled or true

  -- Iterate over all support settings and set their value based on the 'enabled' parameter.
  for key in pairs(self.Settings.Support) do
    self.Settings.Support[key] = enabled
  end

  return self
end

--- Enable or disable a specific support setting for the SPECTRE.PLYRMGR instance.
--
-- This function is used to adjust a specific support setting within the player manager instance.
-- It allows for enabling or disabling an individual support setting, identified by the 'type' parameter,
-- based on the provided 'enabled' parameter. If no value for 'enabled' is given, the function defaults to enabling
-- the support setting ('true'). This targeted approach enables fine-grained control over each distinct support setting.
--
-- @param #PLYRMGR self The player manager instance for which the support setting is to be adjusted.
-- @param type The specific support setting under SPECTRE.PLYRMGR.Settings.Support to be modified.
-- @param enabled A boolean value (true or false) to enable or disable the specified support setting. Defaults to true if not specified.
-- @return #PLYRMGR self The player manager instance after adjusting the specified support setting.
function SPECTRE.PLYRMGR:enableSupport(type, enabled)
  -- Default to true if no value is provided.
  enabled = enabled or true

  -- Set the specific support setting based on the 'enabled' parameter.
  self.Settings.Support[type] = enabled

  return self
end

--- Enable or disable the rewards system for the SPECTRE.PLYRMGR instance.
--
-- This function controls the activation status of the rewards system within the player manager instance.
-- It sets the rewards setting to either enabled or disabled based on the provided 'enabled' parameter.
-- If no value is given, the function defaults to enabling the rewards system ('true'). This allows for easy
-- toggling of the rewards system, facilitating gameplay customization according to player or scenario requirements.
--
-- @param #PLYRMGR self The player manager instance for which the rewards system is to be toggled.
-- @param enabled A boolean value (true or false) to enable or disable the rewards system respectively. Defaults to true if not specified.
-- @return #PLYRMGR self The player manager instance after toggling the rewards system.
-- @usage manager:enableRewards() -- Enable the rewards system.
-- @usage manager:enableRewards(false) -- Disable the rewards system.
function SPECTRE.PLYRMGR:enableRewards(enabled)
  -- Default to true if no value is provided.
  enabled = enabled or true

  -- Set the rewards setting based on the 'enabled' parameter.
  self.Settings.Rewards = enabled

  return self
end

--- Enable or disable the persistence system for the SPECTRE.PLYRMGR instance.
--
-- This function is used to toggle the persistence system of the player manager instance.
-- It adjusts the persistence setting to either enable or disable it, based on the value provided in the 'enabled' parameter.
-- In the absence of a provided value, the function defaults to enabling the persistence system ('true').
-- This toggle capability allows for flexible management of game state persistence, adapting to different gameplay needs or scenarios.
--
-- @param #PLYRMGR self The player manager instance for which the persistence system is to be toggled.
-- @param enabled A boolean value (true or false) to enable or disable the persistence system respectively. Defaults to true if not specified.
-- @return #PLYRMGR self The player manager instance after toggling the persistence system.
function SPECTRE.PLYRMGR:enablePersistance(enabled)
  -- Default to true if no value is provided.
  enabled = enabled or true

  -- Set the persistence setting based on the 'enabled' parameter.
  self.Settings.Persistance = enabled

  return self
end

--- Check if any support settings are enabled for the SPECTRE.PLYRMGR instance.
--
-- This function examines the support settings of the player manager instance and determines if any of them are currently enabled.
-- It iterates over all the support settings and returns true as soon as it finds an enabled setting. If none of the settings are enabled,
-- the function will return false. This is useful for quickly ascertaining the overall status of support systems within the game environment.
--
-- @param #PLYRMGR
-- @return #boolean True if any support setting is enabled, otherwise false.
function SPECTRE.PLYRMGR:anySupportOn()
  -- Iterate over all support settings.
  for _, supportEnabled in pairs(self.Settings.Support) do
    -- If any support setting is enabled, return true.
    if supportEnabled then return true end
  end

  -- If no support setting is enabled, return false.
  return false
end

--- Marker OPs.
-- ===
--
-- *All Functions associated with Markers operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR


--- Process marker events and take actions based on the marker type.
--
-- This function is designed to interpret and respond to marker events. It analyzes the marker type and descriptor,
-- sets up new markers, and modifies player menus based on the marker's intent. The function handles different marker
-- types, such as CAP, TOMAHAWK, BOMBER, STRIKE, and AIRDROP, executing specific actions for each. It ensures that marker
-- events are processed correctly, facilitating dynamic in-game interactions based on player inputs.
--
-- @param #PLYRMGR self The player manager instance processing the marker event.
-- @param Packet Information about the marker event, including type and other relevant data.
-- @return #PLYRMGR self The player manager instance after processing the marker event.
-- @usage manager:_EventMarker(packetData) -- Process the marker event based on the provided packet data.
function SPECTRE.PLYRMGR:_EventMarker(Packet)
  local _,_,heading, distance, code,MarkInfo,NewMarkerCoord,PlayerUCID,descriptor,newMarkerText,newMarkerID
  --local _tCode = SPECTRE.COUNTERS
  code = SPECTRE.COUNTER--self.COUNTERS.CodeMarker -- Incrementing CodeMarker counter
  --self.COUNTERS.CodeMarker = self.COUNTERS.CodeMarker + 5
  SPECTRE.COUNTER = SPECTRE.COUNTER + 1
  --  local _,_,heading, distance, code,MarkInfo,NewMarkerCoord,PlayerUCID,descriptor,newMarkerText,newMarkerID
  --  local _tCode = SPECTRE.COUNTERS
  --  code = _tCode--self.COUNTERS.CodeMarker -- Incrementing CodeMarker counter
  --  --self.COUNTERS.CodeMarker = self.COUNTERS.CodeMarker + 5
  --  SPECTRE.COUNTERS = code + 1
  MarkInfo = SPECTRE.MARKERS.World.FindByText(Packet.origText) -- Finding mark info using Text
  NewMarkerCoord = COORDINATE:New(MarkInfo.pos.x,MarkInfo.pos.y,MarkInfo.pos.z) -- Creating a new coordinate object
  PlayerUCID = SPECTRE.UTILS.GetPlayerInfo(MarkInfo.author, "ucid") -- Fetching the unique ID of the player who changed the mark

  local markerType = Packet.MarkerType[1]


  if markerType == "CAP" then
    heading = Packet.MarkerType[2] or nil
    distance = Packet.MarkerType[3] or nil
    descriptor = heading and string.format("- Racetrack %03d for %d", heading, distance) or "- Circular Orbit"
  end

  if markerType == "TOMAHAWK" then
    descriptor =  "- Tomahawk Strike"
  end

  if markerType == "BOMBER" then
    descriptor =  "- B-52 Carpet Bomb"
  end

  if markerType == "STRIKE" then
    descriptor =  "- Strike Team"
  end

  if markerType == "AIRDROP" then
    local dropType = Packet.MarkerType[2]
    if dropType and self.MARKERS.Settings.AIRDROP.Types[dropType] then
      descriptor = "- Airdrop " .. dropType .. " group."
    else
      trigger.action.outTextForGroup( self.Players[PlayerUCID].GroupID, "Invalid airdrop type request. Please check you are using the correct format." ,15)
    end
    -- Handle invalid airdrop type
    SPECTRE.MARKERS.World.RemoveByID(MarkInfo.idx)
  end


  if not descriptor then return self end -- Exit if descriptor is not found

  newMarkerText = "ID: " .. markerType .. code .. " " .. descriptor
  newMarkerID = NewMarkerCoord:MarkToGroup(newMarkerText,self.Players[PlayerUCID].GROUP,true) -- Create a new marker on the map

  local MarkerTable = {
    Packet = Packet,
    descriptor = descriptor,
    newMarkerText = newMarkerText,
    code = code,
    MarkInfo = MarkInfo,
    PermMarkerID = newMarkerID,
    MarkCoords = NewMarkerCoord,
    heading = heading and tonumber(heading),
    distance = distance and tonumber(distance)
  }

  self:AddMarkerToPlayer(PlayerUCID, MarkerTable) --Add new mark to player table
  SPECTRE.MARKERS.World.RemoveByID(MarkInfo.idx) -- Remove the old mark
  self.Players[PlayerUCID].Markers[markerType].MenuArrays.Main:RemoveSubMenus() -- Remove the support menu for TYPE operations
  self.Players[PlayerUCID]:setupSubMenu(markerType, self) -- Build the support menu for TYPE operations

  return self
end

--- Events.
-- ===
--
-- *All Functions associated with Events operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Event handler for the "Kill" event.
--
-- This function serves as an event handler for the "Kill" event within the player manager system. When a kill event is triggered,
-- it identifies the player responsible for the event and awards them points based on the specifics of the event. The function
-- ensures that players are appropriately rewarded for their in-game achievements, reinforcing game dynamics and player engagement.
--
-- @param #PLYRMGR self The player manager instance handling the "Kill" event.
-- @param eventData Data associated with the "Kill" event, including information about the initiator and the event details.
-- @return #PLYRMGR self The player manager instance after processing the "Kill" event.
function SPECTRE.PLYRMGR:RewardKillEvent_(eventData)
  -- Fetch the unique ID of the player who initiated the event
  local PlayerUCID = SPECTRE.UTILS.GetPlayerInfo(eventData.IniPlayerName, "ucid")

  -- If the event initiator is a player, disperse points based on the event data
  if PlayerUCID and self.Players[PlayerUCID] then
    local pointsAwarded = SPECTRE.REWARDS.DispersePoints(eventData)
    self.Players[PlayerUCID]:UpdatePoints(pointsAwarded)
  end

  return self
end

--- Event handler for the "End Mission" event.
--
-- This function acts as an event handler for the "End Mission" event in the player manager system.
-- It is triggered at the conclusion of a mission and is responsible for collating end-of-mission resources and storing ground resource data.
-- The function ensures that essential data related to mission resources is accurately compiled and saved, providing continuity and
-- consistency in resource management across game sessions.
--
-- @param #PLYRMGR self The player manager instance handling the "End Mission" event.
-- @param eventData Data associated with the "End Mission" event, typically including mission-closure details.
-- @return #PLYRMGR self The player manager instance after handling the "End Mission" event.
-- @usage manager:EndMission_(eventData) -- Handle the "End Mission" event and perform end-of-mission tasks.
function SPECTRE.PLYRMGR:EndMission_(eventData)
  SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMission_ | eventData" , eventData)
  -- Collate end-of-mission resources
  self:EndMizResourceCollate()

  SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMission_ | self.RESOURCES.AIRDROP" , self.RESOURCES.AIRDROP)
  -- Store the ground resource data
  SPECTRE.IO.PersistenceToFile(SPECTRE._persistenceLocations.PLYRMGR.path .. "SupportResources/GroundResources.lua", self.RESOURCES.AIRDROP, true)
  return self
end

--- Event handler for the "PlayerEnterAircraft" event.
--
-- This function is an event handler that activates when a player enters an aircraft. It is responsible for setting up the player's data
-- within the manager's system, sending a welcome message to the player, and initializing the support menu if any support options are enabled.
-- The function ensures that players are properly integrated into the game's management system upon entering an aircraft, providing necessary
-- information and options for an enhanced gameplay experience.
--
-- @param #PLYRMGR self The player manager instance handling the "PlayerEnterAircraft" event.
-- @param eventData Data associated with the "PlayerEnterAircraft" event, including the player's details.
-- @return #PLYRMGR self The player manager instance after handling the "PlayerEnterAircraft" event.
function SPECTRE.PLYRMGR:PlayerEnterAircraft_(eventData)
if eventData.IniPlayerName ~= nil then
  -- Retrieve the player's information using their name from the event data
  local PlayerInfo = SPECTRE.UTILS.GetPlayerInfo(eventData.IniPlayerName)
  local PlayerUCID = PlayerInfo.ucid

  -- If the player doesn't already exist in the manager's player table, create a new entry for them
  if not self.Players[PlayerUCID] then
    self.Players[PlayerUCID] = self.Player:New(PlayerInfo, self):ImportData()
  end

  -- Update the player's slot data and send them a welcome message
  self.Players[PlayerUCID]:SlotDataUpdate(eventData)
  self.Players[PlayerUCID]:WelcomeMessage()

  -- If any support options are enabled, set up the support menu for the player
  if self:anySupportOn() then
    self.Players[PlayerUCID]:setupMenu(self)
  end
end
  return self
end

--- Event handler for the "PlayerLeaveUnit" event.
--
-- This function serves as an event handler for situations where a player leaves a unit in the game. It performs necessary actions
-- such as storing the player's data and clearing any world markers associated with that player. This ensures that the player's
-- game state is properly managed and updated when they exit a unit, maintaining the integrity and continuity of the gameplay experience.
--
-- @param #PLYRMGR self The player manager instance handling the "PlayerLeaveUnit" event.
-- @param eventData Data associated with the "PlayerLeaveUnit" event, including the player's details.
-- @return #PLYRMGR self The player manager instance after handling the "PlayerLeaveUnit" event.
-- @usage manager:PlayerLeaveUnit_(eventData) -- Handle the "PlayerLeaveUnit" event and perform necessary actions.
function SPECTRE.PLYRMGR:PlayerLeaveUnit_(eventData)
  -- If the event has a player initiator
  if eventData.IniPlayerName ~= nil then
    -- Retrieve the player's information using their name from the event data
    local PlayerInfo = SPECTRE.UTILS.GetPlayerInfo(eventData.IniPlayerName)
    local PlayerUCID = PlayerInfo.ucid

    -- If the player exists in the manager's player table
    if  self.Players[PlayerUCID] then
      -- Store the player's data, clear their world markers, and then remove them from the manager's player table
      self.Players[PlayerUCID]:StoreData()
      self.Players[PlayerUCID]:ClearWorldMarkers(0)
      self.Players[PlayerUCID] = nil
    end
  end
  return self
end

--- Event handler for the "Crash" event.
--
-- This function acts as an event handler for crash events within the game. It specifically handles cases where the initiator of the crash
-- is a player. In such instances, the function stores the player's data to ensure that any relevant game state or progress is recorded
-- accurately. This mechanism is crucial for maintaining a consistent and fair gameplay experience, especially in scenarios involving
-- unintended or accidental crashes.
--
-- @param #PLYRMGR self The player manager instance handling the "Crash" event.
-- @param eventData Data associated with the "Crash" event, including the player's details if they initiated the crash.
-- @return #PLYRMGR self The player manager instance after processing the "Crash" event.
-- @usage manager:CrashEvent_(eventData) -- Handle the "Crash" event and store the player's data if necessary.
function SPECTRE.PLYRMGR:CrashEvent_(eventData)
  -- If the event has a player initiator
  if eventData.IniPlayerName ~= nil then
    -- Retrieve the player's information using their name from the event data
    local PlayerInfo = SPECTRE.UTILS.GetPlayerInfo(eventData.IniPlayerName)
    local PlayerUCID = PlayerInfo.ucid

    -- If the player exists in the manager's player table, store their data
    if  self.Players[PlayerUCID] then
      self.Players[PlayerUCID]:StoreData()
    end
  end
  return self
end

--- Internal.
-- ===
--
--  Not meant to be used, but can be.
--
-- *All Functions associated with Internal operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Collate resources at the end of a mission.
--
-- This function is responsible for updating the resource counts at the conclusion of a mission. It goes through each support type and
-- tallies the remaining stock, adjusting the resource counts accordingly. The function handles different support types, including
-- special handling for AIRDROP types, ensuring that the resource data accurately reflects the state of resources at mission's end.
-- This is crucial for maintaining consistency and accuracy in resource tracking across game sessions.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after updating resource counts.
-- @usage manager:EndMizResourceCollate() -- Update resource counts at the end of the mission.
function SPECTRE.PLYRMGR:EndMizResourceCollate()
  SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMizResourceCollate | ----------------", self )
  -- Iterate over all support settings
  for supportType, isEnabled in pairs(self.Settings.Support) do
    SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMizResourceCollate | supportType: " .. supportType .. " | enabled: " .. tostring(isEnabled))
    if isEnabled then
      -- If the support type is not AIRDROP, update the Red and Blue resources directly
      if supportType ~= "AIRDROP" then

--        self.RESOURCES[supportType].Red = self.RESOURCES[supportType].Red + self.COUNTERS.RESTOCK[supportType].Red
--        self.RESOURCES[supportType].Blue = self.RESOURCES[supportType].Blue + self.COUNTERS.RESTOCK[supportType].Blue
      else
        SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMizResourceCollate | AIRDROP.Types: " , self.MARKERS.Settings.AIRDROP.Types)
        -- If the support type is AIRDROP, iterate over the airdrop types and update their counts
        for airdropType, _ in pairs(self.MARKERS.Settings.AIRDROP.Types) do
          SPECTRE.UTILS.debugInfo("SPECTRE.PLYRMGR:EndMizResourceCollate | airdropType: " .. airdropType)
          self.RESOURCES[supportType][airdropType].Blue = self.RESOURCES[supportType][airdropType].Blue + self.COUNTERS.RESTOCK[supportType][airdropType].Blue
          self.RESOURCES[supportType][airdropType].Red = self.RESOURCES[supportType][airdropType].Red + self.COUNTERS.RESTOCK[supportType][airdropType].Red
        end
      end
    end
  end
  return self
end

--- Detect existing ground units and set up event handlers for them based on their types.
--
-- This function is responsible for identifying existing ground units within the game and setting up appropriate event handlers for each.
-- It first constructs a list of filter prefixes based on airdrop type settings. Then, it iterates over ground units that match these prefixes,
-- processing each unit by setting up event handlers that are tailored to their specific airdrop types. This function ensures that existing
-- ground units are integrated into the game's event handling system, allowing for responsive and dynamic gameplay interactions based on unit types.
--
-- @param #PLYRMGR
-- @return #PLYRMGR self The player manager instance after detecting and setting up event handlers for existing units.
-- @usage manager:DetectExistingUnits() -- Detect existing units and set up their event handlers.
function SPECTRE.PLYRMGR:DetectExistingUnits()
  -- Construct the list of filter prefixes based on the provided airdrop type settings
  local filterprefixes = {}
  for _, airdropType in pairs(SPECTRE.MENU.Settings.AIRDROP.Types) do
    local prefix = airdropType.AliasPrefix:sub(1, -3)
    table.insert(filterprefixes, prefix)
  end

  -- Helper function to process each group of ground units
  local function processGroup(GroupObject, Manager)
    local groupname = GroupObject:GetName()
    local split_str = {}

    -- Split the group name based on underscores
    for word in string.gmatch(groupname, '([^_]+)') do
      table.insert(split_str, word)
    end

    local Packet = {
      Type = "AIRDROP",
      subtype_ = split_str[1]
    }

    local messageOnDead = Packet.subtype_ .. " group destroyed! Prepping new assets."
    -- Set event handlers for the group based on its airdrop type
    GroupObject = SPECTRE.AI.setAirdropEventHandlers(GroupObject, Manager, Packet, messageOnDead)
  end

  -- Create a set of existing ground units that match the filter prefixes and process each of them
  local GroundUnitsSet = SET_GROUP:New():FilterCategoryGround():FilterPrefixes(filterprefixes):FilterOnce()
  GroundUnitsSet:ForEachGroup(processGroup, self)

  return self
end

--- Client.
-- ===
--
-- *All Functions associated with Client operations.*
--
-- ===
-- @section SPECTRE.PLYRMGR

--- Set up the player table.
--
-- This function is tasked with initializing a player table within the player manager system.
-- It uses the provided player information and event data to create and set up a new player object.
-- This includes updating the player's slot data and integrating the player into the manager's system,
-- thereby ensuring that the player's details are accurately recorded and managed within the game's context.
--
-- @param #PLYRMGR self The player manager instance responsible for setting up the player table.
-- @param eventData Data associated with the relevant event, used for updating player slot data.
-- @param PlayerInfo Attribute table containing the player's details, such as unique ID.
-- @return #PLYRMGR self The player manager instance after setting up the player table.
-- @usage manager:SetupPlayerTable(eventData, PlayerInfo) -- Initialize the player table using the provided player information and event data.
function SPECTRE.PLYRMGR:SetupPlayerTable(eventData, PlayerInfo)
  -- Retrieve the player's unique ID from the provided player information
  local PlayerUCID = PlayerInfo["ucid"]

  -- Create a new player object, update its slot data, and assign it to the manager's player table
  local PlayerObject = self.Player:New(PlayerInfo, self):SlotDataUpdate(eventData)
  self.Players[PlayerUCID] = PlayerObject

  return self
end

--- Adds a marker to the appropriate player's marker table based on the marker type.
--
-- This function is responsible for categorizing and assigning markers to players based on the operation type, such as CAP, Bomber, etc.
-- It takes the marker details and integrates them into the player's data, ensuring that the markers are properly managed and accessible
-- within the context of each player's ongoing operations. The function also enforces a limit on the number of markers a player can have
-- for a specific type, maintaining an organized and manageable marker system.
--
-- @param #PLYRMGR self The player manager instance responsible for adding markers to a player's data.
-- @param PlayerUCID The unique identifier for the player.
-- @param MarkerTable Table containing details about the marker, including its type and other relevant information.
-- @return #PLYRMGR self The player manager instance after adding the marker to the player's data.
-- @usage manager:AddMarkerToPlayer(PlayerUCID, MarkerTable) -- Assigns a marker to the appropriate table for the specified player.
function SPECTRE.PLYRMGR:AddMarkerToPlayer(PlayerUCID, MarkerTable)
  -- Extract the type of the marker from the MarkerTable's Packet data
  local type = MarkerTable.Packet.MarkerType[1]

  -- Add the marker to the player's marker table based on its type
  local playerMarkers = self.Players[PlayerUCID].Markers[type].MarkerArrays
  playerMarkers[#playerMarkers + 1] = MarkerTable

  -- Limit the number of markers for the player to a maximum of 5
  self.Players[PlayerUCID]:LimitMaxMarkers(type, 5)
end

---SPAWNER.
--
-- This section defines the SPAWNER field within the PLYRMGR namespace.
-- The SPAWNER table is utilized for managing and controlling various spawning functionalities within the SPECTRE.PLYRMGR system.
-- It plays a critical role in dynamically creating or manipulating game entities as per the game logic or player interactions.
--
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.SPAWNER
SPECTRE.PLYRMGR.SPAWNER = {}

--- Spawn a Combat Air Patrol (CAP) based on a player's marker and index.
--
-- This function is designed to spawn a Combat Air Patrol (CAP) unit in response to a player's action.
-- It utilizes the details provided in the player's marker to determine the patrol path and spawn configuration.
-- The function pre-calculates various flight parameters and then proceeds to spawn the CAP unit, ensuring that it
-- follows the intended route and behavior as per the game scenario. This is crucial for dynamic and responsive gameplay
-- where player inputs directly influence in-game events and actions.
--
-- @param #PLYRMGR.SPAWNER self The spawner instance from the player manager system.
-- @param #PLYRMGR.Player Player The player who is executing the CAP operation.
-- @param MarkerIndex The index of the player's marker, used to extract coordinates and relevant information for the CAP.
-- @return spawnGroup The spawned group of the CAP, fully configured and initiated.
-- @usage spawner:CAP(Player, MarkerIndex) -- Spawns a CAP based on the specified player's marker and index.
function SPECTRE.PLYRMGR.SPAWNER:CAP(Player, MarkerIndex)
  -- Build the packet for the CAP using player information and marker index
  local Packet = SPECTRE.AI.buildPacket.CAP(Player, MarkerIndex)

  -- Set up the spawn configuration for the CAP
  local spawnGroup = SPAWN:NewWithAlias(Packet.alias_, string.format(SPECTRE.MENU.Settings.CAP.AliasPrefix, Packet.code))
    :InitCoalition(Packet.coal_)
    :InitCountry(Packet.country_)
    :InitCleanUp(120)
    :InitSkill("Excellent")
    :OnSpawnGroup(
      function(spawnGroup_, MANAGER)
        -- Build the CAP route using the spawn group and packet details
        local route = SPECTRE.AI.buildRoute.CAP(spawnGroup_, Packet)
        -- Configure the spawn group for the CAP
        spawnGroup_ = SPECTRE.AI.configureGroup.CAP(MANAGER, spawnGroup_, route, Packet)
      end, self)

  -- Set the initial heading of the spawn group towards the racetrack's start position
  spawnGroup:InitHeading(Packet.spawnCoord:HeadingTo(Packet.RacetrackStart))

  -- Spawn the CAP group at the specified coordinates
  spawnGroup:SpawnFromVec3(Packet.spawnCoord:GetVec3())

  return spawnGroup
end

--- Spawn a Tomahawk missile strike based on a player's marker and index.
--
-- This function orchestrates the spawning of a Tomahawk missile strike in response to a player's command.
-- It interprets the details from the player's marker to direct a designated group
-- to fire at multiple targets around the marker's coordinates. This function enhances the strategic elements of gameplay,
-- allowing players to execute precise missile strikes based on their tactical decisions.
--
-- @param #PLYRMGR.SPAWNER self The spawner instance from the player manager system.
-- @param #PLYRMGR.Player Player The player who is executing the Tomahawk missile strike operation.
-- @param MarkerIndex The index of the player's marker, used to extract coordinates and relevant information for the missile strike.
-- @return The spawned group responsible for executing the Tomahawk missile strike.
-- @usage spawner:TOMAHAWK(Player, MarkerIndex) -- Spawns a Tomahawk missile strike based on the specified player's marker and index.
function SPECTRE.PLYRMGR.SPAWNER:TOMAHAWK(Player, MarkerIndex)
  -- Build the packet for the Tomahawk strike using player information and marker index
  local Packet = SPECTRE.AI.buildPacket.TOMAHAWK(Player, MarkerIndex)

  -- Find the group responsible for firing the Tomahawk missiles
  local FireGroup = GROUP:FindByName(Packet.alias_)

  -- Instruct the group to fire at 5 random points around the marker's coordinates
  for _iCounter = 1, 5 do
    local RandomPoint = Packet.Coordinate_:GetRandomVec2InRadius(10)
    local Task = FireGroup:TaskFireAtPoint(RandomPoint, 1, 1, 3221225470)
    FireGroup:PushTask(Task, 1)
  end

  -- Remove the marker after the Tomahawk strike has been executed
  SPECTRE.MARKERS.World.RemoveByID(Packet.MarkerID)

  -- Schedule a restock of the Tomahawk missiles
  self:scheduleRestock(Packet.coal, Packet.Type)
end


--- Spawn a bomber aircraft based on a player's marker and index.
--
-- This function is responsible for spawning a bomber aircraft in response to a player's directive.
-- It uses the details provided in the player's marker to determine the bomber's flight path and spawn configuration.
-- The function sets up the necessary parameters and then proceeds to spawn the bomber aircraft, ensuring that it
-- follows the intended route and carries out the designated mission as per the player's strategy and gameplay dynamics.
--
-- @param #PLYRMGR.SPAWNER self The spawner instance from the player manager system.
-- @param #PLYRMGR.Player Player The player who is executing the bomber operation.
-- @param MarkerIndex The index of the player's marker, used to extract coordinates and relevant information for the bomber's mission.
-- @return Spawned group of the bomber aircraft, fully configured and initiated for the mission.
-- @usage spawner:BOMBER(Player, MarkerIndex) -- Spawns a bomber aircraft based on the specified player's marker and index.
function SPECTRE.PLYRMGR.SPAWNER:BOMBER(Player, MarkerIndex)
  -- Build the packet for the bomber using player information and marker index
  local Packet = SPECTRE.AI.buildPacket.BOMBER(Player, MarkerIndex)

  -- Set up the spawn configuration for the bomber
  local spawnGroup = SPAWN:NewWithAlias(Packet.alias_, string.format(SPECTRE.MENU.Settings.BOMBER.AliasPrefix, Packet.code))
    :InitCoalition(Packet.coal_)
    :InitCountry(Packet.country_)
    :InitCleanUp(120)
    :InitSkill("Excellent")
    :OnSpawnGroup(
      function(spawnGroup_, MANAGER)
        -- Build the bomber's route using the spawn group and packet details
        local route = SPECTRE.AI.buildRoute.BOMBER(spawnGroup_, Packet)
        -- Configure the spawn group for the bomber
        spawnGroup_ = SPECTRE.AI.configureGroup.BOMBER(MANAGER, spawnGroup_, route, Packet)
      end, self)

  -- Set the initial heading of the spawn group towards the drop coordinates
  spawnGroup:InitHeading(Packet.spawnCoord:HeadingTo(Packet.dropCoord))

  -- Spawn the bomber group at the specified coordinates
  spawnGroup:SpawnFromVec3(Packet.spawnCoord:GetVec3())

  return spawnGroup
end

--- Spawn a strike group based on a player's marker and index.
--
-- This function is tasked with spawning a strike group in accordance with a player's instructions.
-- It utilizes the information from the player's marker to determine the strike group's path and spawn configuration.
-- After configuring the necessary parameters, the function proceeds to spawn the strike group, ensuring that it executes
-- the intended mission in alignment with the player's strategic objectives. This functionality enhances the tactical aspect
-- of gameplay, allowing players to influence in-game events through their decisions and actions.
--
-- @param #PLYRMGR.SPAWNER self The spawner instance from the player manager system.
-- @param #PLYRMGR.Player Player The player responsible for executing the strike operation.
-- @param MarkerIndex The index of the player's marker, used to determine coordinates and details for the strike mission.
-- @return Spawned group of the strike, fully prepared and configured for the operation.
-- @usage spawner:STRIKE(Player, MarkerIndex) -- Spawns a strike group based on the specified player's marker and index.
function SPECTRE.PLYRMGR.SPAWNER:STRIKE(Player, MarkerIndex)
  -- Build the packet for the strike using player information and marker index
  local Packet = SPECTRE.AI.buildPacket.STRIKE(Player, MarkerIndex)

  -- Set up the spawn configuration for the strike group
  local spawnGroup = SPAWN:NewWithAlias(Packet.alias_, string.format(SPECTRE.MENU.Settings.STRIKE.Transport.AliasPrefix, Packet.code))
    :InitCoalition(Packet.coal_)
    :InitCountry(Packet.country_)
    :InitCleanUp(120)
    :InitSkill("Excellent")
    :OnSpawnGroup(
      function(spawnGroup_, MANAGER)
        -- Build the strike's route using the spawn group and packet details
        local route = SPECTRE.AI.buildRoute.STRIKE(spawnGroup_, Packet)
        -- Configure the spawn group for the strike
        spawnGroup_ = SPECTRE.AI.configureGroup.STRIKE(MANAGER, spawnGroup_, route, Packet)
      end, self)

  -- Set the initial heading of the spawn group towards the target coordinates
  spawnGroup:InitHeading(Packet.spawnCoord:HeadingTo(Packet.TargetCoord))

  -- Spawn the strike group at the specified coordinates
  spawnGroup:SpawnFromVec3(Packet.spawnCoord:GetVec3())

  return spawnGroup
end

--- Spawn an airdrop group based on a player's marker and index.
--
-- This function facilitates the spawning of an airdrop group in alignment with a player's commands.
-- It leverages the details from the player's marker to establish the airdrop path and configure the spawn settings.
-- After setting up the necessary parameters, the function proceeds to spawn the airdrop group, ensuring that it
-- adheres to the planned route and objectives, as dictated by the player's strategic decisions.
-- This feature enriches the game by allowing players to directly influence logistical aspects through tactical airdrops.
--
-- @param #PLYRMGR.SPAWNER self The spawner instance within the player manager system.
-- @param #PLYRMGR.Player Player The player orchestrating the airdrop operation.
-- @param MarkerIndex The index of the player's marker, which provides coordinates and details for the airdrop.
-- @return spawnGroup The spawned group for the airdrop, fully equipped and ready for the mission.
-- @usage spawner:AIRDROP(Player, MarkerIndex) -- Spawns an airdrop group based on the specified player's marker and index.
function SPECTRE.PLYRMGR.SPAWNER:AIRDROP(Player, MarkerIndex)
  -- Build the packet for the airdrop using player information and marker index
  local Packet = SPECTRE.AI.buildPacket.AIRDROP(Player, MarkerIndex)

  -- Set up the spawn configuration for the airdrop group
  local spawnGroup = SPAWN:NewWithAlias(Packet.alias_, string.format(SPECTRE.MENU.Settings.AIRDROP.AliasPrefix, Packet.code))
    :InitCoalition(Packet.coal_)
    :InitCountry(Packet.country_)
    :InitCleanUp(120)
    :InitSkill("Excellent")
    :OnSpawnGroup(
      function(spawnGroup_, MANAGER)
        -- Build the airdrop's route using the spawn group and packet details
        local route = SPECTRE.AI.buildRoute.AIRDROP(spawnGroup_, Packet)
        -- Configure the spawn group for the airdrop
        spawnGroup_ = SPECTRE.AI.configureGroup.AIRDROP(MANAGER, spawnGroup_, route, Packet)
      end, self)

  -- Set the initial heading of the spawn group towards the target coordinates
  spawnGroup:InitHeading(Packet.spawnCoord:HeadingTo(Packet.TargetCoord))

  -- Spawn the airdrop group at the specified coordinates
  spawnGroup:SpawnFromVec3(Packet.spawnCoord:GetVec3())

  return spawnGroup
end

--- MARKERS.
-- This section defines the MARKERS field within the PLYRMGR namespace.
-- The MARKERS table is used for managing and tracking various marker-related functionalities in the SPECTRE.PLYRMGR system.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.MARKERS
SPECTRE.PLYRMGR.MARKERS = {}

--- MARKERS Settings.
-- This section contains various settings for the SPECTRE Custom Support Module related to markers.
-- It includes configurations for different types of support operations such as CAP, Bomber, Tomahawk, etc.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.MARKERS.Settings
SPECTRE.PLYRMGR.MARKERS.Settings = {}

--- Settings for Combat Air Patrol (CAP) markers.
SPECTRE.PLYRMGR.MARKERS.Settings.CAP = {
  TagName = "/cap", -- Tag used to identify CAP markers.
  KeyWords = {"%d%d%d* %d+"}, -- Keywords or patterns recognized in CAP markers.
  CaseSensitive = false, -- Specifies if the CAP marker recognition is case sensitive.
  MarkerEnum = "CAP" -- Enumeration type for CAP markers.
}

--- Settings for Tomahawk missile strike markers.
SPECTRE.PLYRMGR.MARKERS.Settings.TOMAHAWK = {
  TagName = "/tomahawk", -- Tag used to identify Tomahawk strike markers.
  KeyWords = {}, -- Keywords or patterns recognized in Tomahawk markers.
  CaseSensitive = false, -- Specifies if the Tomahawk marker recognition is case sensitive.
  MarkerEnum = "TOMAHAWK" -- Enumeration type for Tomahawk markers.
}

--- Settings for Bomber strike markers.
SPECTRE.PLYRMGR.MARKERS.Settings.BOMBER = {
  TagName = "/bomber", -- Tag used to identify Bomber strike markers.
  KeyWords = {}, -- Keywords or patterns recognized in Bomber markers.
  CaseSensitive = false, -- Specifies if the Bomber marker recognition is case sensitive.
  MarkerEnum = "BOMBER" -- Enumeration type for Bomber markers.
}

--- Settings for Airdrop operation markers.
SPECTRE.PLYRMGR.MARKERS.Settings.AIRDROP = {
  TagName = "/airdrop", -- Tag used to identify Airdrop markers.
  KeyWords = {"%a"}, -- Keywords or patterns recognized in Airdrop markers.
  CaseSensitive = false, -- Specifies if the Airdrop marker recognition is case sensitive.
  MarkerEnum = "AIRDROP", -- Enumeration type for Airdrop markers.
  Types = { -- Defines different types of airdrops.
    TANK = "TANK",
    IFV = "IFV",
    ARTILLERY = "ARTILLERY",
    AAA = "AAA",
    IRSAM = "IRSAM",
    RDRSAM = "RDRSAM",
    EWR = "EWR",
    SUPPLY = "SUPPLY"
  }
}

--- Settings for Strike operation markers.
SPECTRE.PLYRMGR.MARKERS.Settings.STRIKE = {
  TagName = "/strike", -- Tag used to identify Strike operation markers.
  KeyWords = {}, -- Keywords or patterns recognized in Strike markers.
  CaseSensitive = false, -- Specifies if the Strike marker recognition is case sensitive.
  MarkerEnum = "STRIKE" -- Enumeration type for Strike markers.
}


--- MARKERS TRACKERS.
-- This section defines the TRACKERS field within the MARKERS namespace of PLYRMGR.
-- The TRACKERS table is used for managing and tracking various types of player-made markers within the SPECTRE.PLYRMGR system.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.MARKERS.TRACKERS
SPECTRE.PLYRMGR.MARKERS.TRACKERS = {}

--- Tracker for player-made CAP markers.
-- This tracker specifically handles CAP (Combat Air Patrol) markers created by players, managing their interpretation and response within the game.
SPECTRE.PLYRMGR.MARKERS.TRACKERS.CAP = {}

--- Tracker for player-made TOMAHAWK markers.
-- This tracker is designated for managing and responding to TOMAHAWK strike markers that players place in the game.
SPECTRE.PLYRMGR.MARKERS.TRACKERS.TOMAHAWK = {}

--- Tracker for player-made BOMBER markers.
-- Responsible for handling markers related to bomber operations, this tracker interprets and responds to player directives for bomber strikes.
SPECTRE.PLYRMGR.MARKERS.TRACKERS.BOMBER = {}

--- Tracker for player-made AIRDROP markers.
-- This tracker oversees the handling of airdrop requests, ensuring that player-made airdrop markers are processed and acted upon correctly.
SPECTRE.PLYRMGR.MARKERS.TRACKERS.AIRDROP = {}

--- Tracker for player-made STRIKE markers.
-- This tracker deals with strike operation requests from players, managing markers related to various strike missions within the game.
SPECTRE.PLYRMGR.MARKERS.TRACKERS.STRIKE = {}

--- RESOURCES.
-- This class within the SPECTRE.PLYRMGR module handles the management of resources available for various support functionalities.
-- It maintains counters indicating the amount of resources available for both 'Red' and 'Blue' factions for each type of support (e.g., CAP, TOMAHAWK, etc.).
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.RESOURCES
SPECTRE.PLYRMGR.RESOURCES = {}

--- CAP support resource counters.
-- These counters indicate the number of resources available for CAP (Combat Air Patrol) support for each faction.
-- @field #PLYRMGR.RESOURCES.CAP
SPECTRE.PLYRMGR.RESOURCES.CAP = {
  Red = 3, -- Resources for the Red faction.
  Blue = 3 -- Resources for the Blue faction.
}

--- TOMAHAWK support resource counters.
-- These counters indicate the number of resources available for TOMAHAWK support for each faction.
-- @field #PLYRMGR.RESOURCES.TOMAHAWK
SPECTRE.PLYRMGR.RESOURCES.TOMAHAWK = {
  Red = 3,
  Blue = 3
}

--- BOMBER support resource counters.
-- These counters indicate the number of resources available for BOMBER support for each faction.
-- @field #PLYRMGR.RESOURCES.BOMBER
SPECTRE.PLYRMGR.RESOURCES.BOMBER = {
  Red = 3,
  Blue = 3
}

--- STRIKE support resource counters.
-- These counters indicate the number of resources available for STRIKE support for each faction.
-- @field #PLYRMGR.RESOURCES.STRIKE
SPECTRE.PLYRMGR.RESOURCES.STRIKE = {
  Red = 3,
  Blue = 3
}

--- AIRDROP support resource counters for various types.
-- These counters indicate the number of resources available for different types of AIRDROP support for each faction.
-- @field #PLYRMGR.RESOURCES.AIRDROP
SPECTRE.PLYRMGR.RESOURCES.AIRDROP = {
  --  Red = 3, -- General resources for the Red faction.
  --  Blue = 3, -- General resources for the Blue faction.
  ARTILLERY = {Red = 3, Blue = 3}, -- Artillery AIRDROP resources.
  IFV = {Red = 3, Blue = 3}, -- IFV AIRDROP resources.
  TANK = {Red = 3, Blue = 3}, -- Tank AIRDROP resources.
  AAA = {Red = 3, Blue = 3}, -- AAA AIRDROP resources.
  IRSAM = {Red = 3, Blue = 3}, -- SAM_IR AIRDROP resources.
  RDRSAM = {Red = 3, Blue = 3}, -- SAM_RDR AIRDROP resources.
  EWR = {Red = 3, Blue = 3}, -- EWR AIRDROP resources.
  SUPPLY = {Red = 3, Blue = 3} -- Supply AIRDROP resources.
}

--- Import function for the `SPECTRE.PLYRMGR.RESOURCES` class.
--
-- This method is crucial for importing resource data into the `SPECTRE.PLYRMGR.RESOURCES` class.
-- It specifically focuses on importing data related to the `AIRDROP` functionality.
-- The method retrieves and integrates resource data from a specified file, ensuring that the system has up-to-date information
-- on available resources for airdrop operations.
--
-- @param #PLYRMGR.RESOURCES
-- @return #PLYRMGR.RESOURCES self The updated instance of the `SPECTRE.PLYRMGR.RESOURCES` class with the imported airdrop data.
function SPECTRE.PLYRMGR.RESOURCES:Import()
  local _filename = SPECTRE._persistenceLocations.PLYRMGR.path .. "SupportResources/GroundResources.lua"
  self.AIRDROP = SPECTRE.BRAIN.checkAndPersist(
    _filename,
    false,
    self.AIRDROP,
    true,
    function(_Object)  -- Update: Include _Object as a parameter
      return _Object  -- Update: Pass _Object to the new function
    end
  )
  --self.AIRDROP  = SPECTRE.IO.PersistenceFromFile(SPECTRE._persistenceLocations.PLYRMGR.path .. "SupportResources/GroundResources.lua")
  return self
end

--- COUNTERS.
-- Counter for the amount of resources available for custom support functionalities.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.COUNTERS
SPECTRE.PLYRMGR.COUNTERS = {
  CodeMarker = 100, -- Overall Code Counter for generated marker operations.
  CodeESCORT = 1, -- Overall Code Counter for escort operations.
  ID_ = 6000 -- Overall ID Counter for marker operations.
}

--- COUNTERS RESTOCK.
-- Tracker for how many restock timers are active, allowing re-adding resources to the available pool if the mission restarts.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.COUNTERS.RESTOCK
SPECTRE.PLYRMGR.COUNTERS.RESTOCK = {
  CAP = {Red = 3, Blue = 3}, -- Counter for CAP resources with active restock timers.
  TOMAHAWK = {Red = 3, Blue = 3}, -- Counter for TOMAHAWK resources with active restock timers.
  BOMBER = {Red = 3, Blue = 3}, -- Counter for BOMBER resources with active restock timers.
  STRIKE = {Red = 3, Blue = 3}, -- Counter for STRIKE resources with active restock timers.
  AIRDROP = { -- Counters for various AIRDROP resources with active restock timers.
    --    Red = 3,
    --    Blue = 3,
    ARTILLERY = {Red = 3, Blue = 3},
    IFV = {Red = 3, Blue = 3},
    TANK = {Red = 3, Blue = 3},
    AAA = {Red = 3, Blue = 3},
    IRSAM = {Red = 3, Blue = 3},
    RDRSAM = {Red = 3, Blue = 3},
    EWR = {Red = 3, Blue = 3},
    SUPPLY = {Red = 3, Blue = 3}
  }
}

--- Player TypeDef.
-- This class is responsible for creating and managing Player Objects within the SPECTRE system.
-- It encompasses all aspects related to player management, including attributes and state.
-- @section SPECTRE.PLYRMGR
-- @field #PLYRMGR.Player
SPECTRE.PLYRMGR.Player = {
  MANAGER = {}, -- Reference to the manager handling this player.
  id = 0, -- Unique identifier for the player.
  name = "", -- Name of the player.
  side = 0, -- Side of the player (e.g., Red or Blue).
  slot = 0, -- Slot occupied by the player.
  ucid = "", -- Unique Client ID of the player.
  GROUP = {}, -- Group to which the player belongs.
  GroupName = "", -- Name of the player's group.
  GroupID = 0, -- Identifier for the player's group.
  UnitName = "", -- Name of the unit the player is controlling.
  UnitID = 0, -- Identifier for the unit the player is controlling.
  TypeName = "", -- Type of the unit the player is controlling.
  Points = { -- Points accrued by the player on each side.
    [1] = 0, -- Points for side 1.
    [2] = 0, -- Points for side 2.
  }
}

--- Creates a new SPECTRE.PLYRMGR.Player instance.
--
-- This function is responsible for constructing and initializing a new instance of the SPECTRE.PLYRMGR.Player class.
-- It takes detailed information about the player and a reference to the managing entity within the SPECTRE system.
-- The new player instance is set up with all necessary attributes, preparing it for interaction and management within the game environment.
--
-- @param #PLYRMGR.Player self The base instance from which the new player instance is derived.
-- @param PlayerInfo Table containing details about the player, such as id, name, side, slot, and ucid.
-- @param #PLYRMGR MANAGER Reference to the manager responsible for handling this player instance.
-- @return #PLYRMGR.Player self The newly created and initialized player instance.
-- @usage local playerInstance = SPECTRE.PLYRMGR.Player:New(playerDetails, managerRef) -- Creates a new player instance.
function SPECTRE.PLYRMGR.Player:New(PlayerInfo, MANAGER)
  local self = BASE:Inherit(self, SPECTRE:New()) -- Inherit from the BASE class
  self.MANAGER = MANAGER -- Assign the manager reference to the player

  -- Initialize player attributes from the provided PlayerInfo
  self.id    = PlayerInfo["id"]
  self.name  = PlayerInfo["name"]
  self.side  = PlayerInfo["side"]
  self.slot  = PlayerInfo["slot"]
  self.ucid  = PlayerInfo["ucid"]

  return self -- Return the initialized player instance
end

--- Updates the player's slot data based on the given eventData.
--
-- This function is crucial for updating the attributes of a SPECTRE.PLYRMGR.Player instance using information from in-game events.
-- It extracts and applies relevant data from the provided eventData to the player's instance, ensuring that the player's in-game
-- information is accurately reflected and up to date. This includes updating group names, unit names, IDs, and other pertinent details.
--
-- @param #PLYRMGR.Player self The player instance to be updated.
-- @param eventData Table containing event-related details, used to update the player's slot data.
-- @return #PLYRMGR.Player self The updated player instance with the latest slot data.
-- @usage playerInstance:SlotDataUpdate(eventDetails) -- Updates the player's slot data based on event details.
function SPECTRE.PLYRMGR.Player:SlotDataUpdate(eventData)
  -- Update player attributes using the eventData
  self.GroupName  = eventData.IniGroupName
  self.GroupID    = eventData.IniDCSGroup.id_
  self.UnitName   = eventData.IniUnitName
  self.UnitID     = eventData.initiator.id_
  self.TypeName   = eventData.IniTypeName
  self.GROUP      = GROUP:FindByName(self.GroupName) -- Find the group object by the group name

  return self -- Return the updated player instance
end

--- Import player data.
--
-- This function is responsible for importing player data into a SPECTRE.PLYRMGR.Player instance. It attempts to retrieve the player's
-- data from a pre-existing database. If the specific player's data is not found in the database, it assigns default values to the player's
-- instance. This ensures that each player has the necessary data loaded for their gameplay, whether it's retrieved from stored data or initialized
-- with default settings.
--
-- @param #PLYRMGR.Player
-- @return #PLYRMGR.Player self The updated player instance with either imported data or default values.
-- @usage playerInstance:ImportData() -- Imports data for the given player.
function SPECTRE.PLYRMGR.Player:ImportData()
  -- Define the path to the player database and the specific player's data file.

  local force = force or false
  local _Randname = name_ or os.time()
  local _filename =  SPECTRE._persistenceLocations.PLYRMGR.path .. "PlayerDB/" .. self.ucid .. ".lua"
  self.Points = SPECTRE.BRAIN.checkAndPersist(
    _filename,
    force,
    self.Points,
    self._persistence,
    function(_Object)  -- Update: Include _Object as a parameter
      _Object[1] = 100
      _Object[2] = 100
      return _Object  -- Update: Pass _Object to the new function
    end
  )



  --  -- Check if the player's data file exists.
  --  if lfs.attributes(PlayerDatabase_File) then
  --    -- Load the player's data from the file.
  --    LoadedDatabase = SPECTRE.IO.PersistenceFromFile(PlayerDatabase_File)
  --    -- If the database is loaded successfully, extract the player's point values.
  --    self.Points[1] = LoadedDatabase["pointsred"] or 100
  --    self.Points[2] = LoadedDatabase["pointsblue"] or 100
  --  else
  --    -- If the player's data file doesn't exist, assign default values.
  --    self.Points[1] = 100
  --    self.Points[2] = 100
  --  end

  return self  -- Return the updated player instance.
end

--- Stores the player's data, specifically points for red and blue teams, in a designated file.
--
-- This function handles the persistent storage of player data for the SPECTRE.PLYRMGR.Player instance. It ensures that the necessary directory
-- and data file exist for storing the player's data. The function constructs a data structure comprising the player's points for the red and
-- blue teams, then saves this data in the player's designated file. If the directory or file does not exist, they are created to facilitate
-- data storage, ensuring that player's progress and points are retained across game sessions.
--
-- @param #PLYRMGR.Player
-- @return #PLYRMGR.Player self The player instance after storing its data.
-- @usage playerInstance:StoreData() -- Persists the player's data in the designated file.
function SPECTRE.PLYRMGR.Player:StoreData()
  -- Define the path to the player database and the specific player's data file.
  local PlayerDatabase_Path = SPECTRE._persistenceLocations.PLYRMGR.path .. "PlayerDB/"--lfs.writedir() .. "SPECTRE/PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. self.ucid .. ".lua"

  --  -- Ensure the directory exists or create it if not.
  --  SPECTRE.IO.DirExists(PlayerDatabase_Path)
  --
  --  -- Ensure the player's data file exists or create it if not.
  --  SPECTRE.IO.FileExists(PlayerDatabase_File)

  -- Store the data structure in the player's data file.
  SPECTRE.IO.PersistenceToFile(PlayerDatabase_File, self.Points)

  return self -- Return the player instance
end

--- Updates the player's points based on their side with a specified reward.
--
-- This function is crucial for managing the scoring system within the SPECTRE.PLYRMGR.Player instance.
-- It identifies the player's current side (either red or blue) and increases their points by the specified reward amount.
-- This allows for dynamic point allocation based on player actions and achievements in the game, ensuring an accurate reflection
-- of their performance.
--
-- @param #PLYRMGR.Player self The instance of the player object to be updated.
-- @param pointReward The amount of points to be added to the player's current points tally.
-- @return #PLYRMGR.Player self The player instance after updating the points.
-- @usage playerInstance:UpdatePoints(10) -- Adds 10 points to the player's current points based on their side.
function SPECTRE.PLYRMGR.Player:UpdatePoints(pointReward)
  -- Update the player's points based on their side with the given reward.
  self.Points[self.side] = self.Points[self.side] + pointReward

  return self -- Return the updated player instance.
end

--- Generates and displays a welcome message for the player.
--
-- This function is designed to create a personalized welcome message for the player using a predefined report template.
-- The message includes information about the player's current points, specific to their side (either red or blue).
-- Once constructed, this welcome message is displayed to the player within the game, providing them with essential information
-- and a warm introduction or reminder at the start of or during the gameplay.
--
-- @param #PLYRMGR.Player
-- @return #PLYRMGR.Player self The player instance after the welcome message has been displayed.
-- @usage playerInstance:WelcomeMessage() -- Displays the welcome message to the player.
function SPECTRE.PLYRMGR.Player:WelcomeMessage()
  local report = SPECTRE.UTILS.ReportGenerator(SPECTRE.PLYRMGR.Settings.Reports.Welcome)
  report:Add("")
  report:AddIndent("You have: " .. self.Points[self.side] .. " points.", "--")
  trigger.action.outTextForGroup(self.GroupID, report:Text(), 20)
end

--- Limits the maximum number of markers a player can have for a specific type.
--
-- This function plays a crucial role in managing the number of active markers a player can have for a particular type,
-- such as "CAP" or "STRIKE". It checks the current count of markers against a specified limit. If the number exceeds the limit,
-- the function systematically removes the oldest markers until the count aligns with the limit. This ensures a manageable
-- number of markers for each type, preventing clutter and maintaining organization within the game's interface.
--
-- @param #PLYRMGR.Player self The player instance whose markers are to be limited.
-- @param type The type of marker to limit (e.g., "CAP", "STRIKE").
-- @param limit The maximum number of markers allowed for the specified type.
-- @return #PLYRMGR.Player self The player instance after applying the marker limit.
-- @usage playerInstance:LimitMaxMarkers("CAP", 5) -- Ensures that the player has no more than 5 CAP markers.
function SPECTRE.PLYRMGR.Player:LimitMaxMarkers(type, limit)
  -- Get the current number of markers of the specified type for the player.
  local CurrentAmountMarkers = #self.Markers[type].MarkerArrays

  -- Calculate the number of markers to remove.
  local AmountToRemove = CurrentAmountMarkers - limit

  -- If the player exceeds the marker limit...
  if AmountToRemove > 0 then
    -- Remove the oldest markers until the limit is met.
    for _i = 1, AmountToRemove, 1 do
      -- Remove the marker from the in-game display.
      trigger.action.removeMark(self.Markers[type].MarkerArrays[1].PermMarkerID)

      -- Remove the marker from the player's internal list.
      table.remove(self.Markers[type].MarkerArrays, 1)
    end
  end

  return self -- Return the player instance.
end

--- Set up a submenu for a specific menu type for a player.
--
-- This function is responsible for setting up a submenu of a specific type (e.g., "CAP", "STRIKE") for a player within the SPECTRE.PLYRMGR system.
-- It creates menu items and commands based on the chosen type, integrating them into the player's group menu. This includes creating options
-- for point balance, instructions, and specific actions related to the menu type. The function enhances the interactive aspect of the game by
-- providing players with tailored menu options that correspond to their in-game choices and actions.
--
-- @param #PLYRMGR.Player self The player instance for which the submenu is to be set up.
-- @param menuType The type of menu to set up (e.g., "CAP", "STRIKE").
-- @param #PLYRMGR MANAGER The player manager instance responsible for the overall menu system.
-- @return #PLYRMGR.Player self The player instance after the submenu setup.
function SPECTRE.PLYRMGR.Player:setupSubMenu(menuType, MANAGER)

  -- Extract relevant references for the menu type.
  local marker = self.Markers[menuType]
  local menuText = SPECTRE.MENU.Text[menuType]
  local printInstructions = SPECTRE.MENU.Print.Instructions_

  -- Create the main menu and associated commands for the player's group.
  marker.MenuArrays.Main = MENU_GROUP:New(self.GROUP, menuText.Title, self.MainMenu)
  marker.MenuArrays.PointBalance = MENU_GROUP_COMMAND:New(self.GROUP, SPECTRE.MENU.Text.Main.PrintPoints, marker.MenuArrays.Main, SPECTRE.MENU.Print.Balance, self)
  marker.MenuArrays.Instructions = MENU_GROUP_COMMAND:New(self.GROUP, SPECTRE.MENU.Text.Main.PrintInstructions, marker.MenuArrays.Main, printInstructions, menuType, self)

  --  -- Special menu handling for Escort type.
  --  if menuType == MANAGER.MARKERS.Settings.ESCORT.MarkerEnum then
  --  --marker.MenuArrays.Request = MENU_GROUP_COMMAND:New(self.GROUP, menuText.Title, marker.MenuArrays.Main, SPECTRE.MENU.SPAWNER.Menu.Escort, self)
  --  end

  -- Special menu handling for Airdrop type.
  if menuType == MANAGER.MARKERS.Settings.AIRDROP.MarkerEnum then
    marker.MenuArrays.PointCost = MENU_GROUP_COMMAND:New(self.GROUP, menuText.Cost, marker.MenuArrays.Main, SPECTRE.MENU.Print.AirdropCost, self)
  else
    marker.MenuArrays.PointCost = MENU_GROUP_COMMAND:New(self.GROUP, menuText.Cost, marker.MenuArrays.Main, SPECTRE.MENU.Print.NULL)
  end

  -- Create a menu option for each marker associated with the player.
  for Index_ = 1, #marker.MarkerArrays, 1 do
    local MARKER_OPTION_ = MENU_GROUP_COMMAND:New(self.GROUP, "Spawn ID: " .. menuType .. marker.MarkerArrays[Index_].code ,marker.MenuArrays.Main,SPECTRE.MENU.Buttons.Dispatcher, MANAGER, self, menuType, Index_)
  end

  return self -- Return the player instance.
end

--- Set up the main menu and associated submenus for a player.
--
-- This function creates the main menu for a player and populates it with various submenus and commands, based on the player's available support options.
-- It checks the support settings in the manager and, for each enabled support type, sets up the corresponding submenu. This allows players to interact
-- with different aspects of the game, such as earning points or initiating specific support actions, directly through an in-game menu system.
--
-- @param #PLYRMGR.Player self The player instance for which the main menu and submenus are to be set up.
-- @param #PLYRMGR MANAGER The player manager instance, used to reference support settings and functionalities.
-- @return #PLYRMGR.Player self The player instance after setting up the main menu and submenus.
function SPECTRE.PLYRMGR.Player:setupMenu(MANAGER)

  -- Create the main menu for the player's group.
  self.MainMenu = MENU_GROUP:New(self.GROUP, SPECTRE.MENU.Text.Main.Title)

  -- Add a command in the main menu to show information on earning points.
  local EarningPoints = MENU_GROUP_COMMAND:New(self.GROUP, SPECTRE.MENU.Text.Main.InfoPoints, self.MainMenu, SPECTRE.MENU.Print.Instructions.EarningPoints, self)

  -- Loop through the support settings in the manager.
  -- If a support setting is enabled (set to true), then set up the associated submenu for that type.
  for _k, _v in pairs(MANAGER.Settings.Support) do
    if _v == true then
      self:setupSubMenu(_k,MANAGER)
    end
  end

  return self -- Return the player instance.
end

--- Clear world markers associated with the player based on a given flag.
--
-- This function is designed to remove specific types of world markers associated with the player, based on the provided numeric flag.
-- It maps flags to corresponding marker types (e.g., "CAP", "TOMAHAWK", "BOMBER", etc.) and clears those markers from the game world.
-- This allows for selective removal of markers, ensuring that the game environment remains organized and clutter-free,
-- especially in scenarios where numerous markers may be present.
--
-- @param #PLYRMGR.Player self The player instance whose markers are to be cleared.
-- @param flag Numeric flag determining which types of markers to clear (0 for all, 1 for "CAP", etc.).
-- @return #PLYRMGR.Player self The player instance after clearing the specified markers.
function SPECTRE.PLYRMGR.Player:ClearWorldMarkers(flag)

  -- Mapping of flags to marker types.
  local flagToMarkerType = {
    [0] = {"CAP", "TOMAHAWK", "BOMBER", "AIRDROP", "STRIKE"},
    [1] = {"CAP"},
    [2] = {"TOMAHAWK"},
    [3] = {"BOMBER"},
    [4] = {"AIRDROP"},
    [5] = {"STRIKE"},
  }

  -- Identify the marker types to be cleared based on the flag.
  local markers = flagToMarkerType[flag]

  -- If no marker types are identified for the given flag, exit the function.
  if not markers then return end

  -- Loop through the identified marker types.
  for _, markerType in ipairs(markers) do
    local markerArray = self.Markers[markerType].MarkerArrays

    -- Loop through each marker of the current type and remove it from the world.
    for _i, markerData in ipairs(markerArray) do
      trigger.action.removeMark(markerData.PermMarkerID)
    end
  end

  return self -- Return the player instance.
end
--- SPECTRE.PLYRMGR.Player.Markers.
-- This table stores marker-related data for different types of operations within the SPECTRE.PLYRMGR.Player class.
-- @field #PLYRMGR.Player.Markers
SPECTRE.PLYRMGR.Player.Markers = {}

--- CAP Markers.
-- Stores arrays for CAP (Combat Air Patrol) markers and associated menus.
-- @field #PLYRMGR.Player.Markers.CAP
SPECTRE.PLYRMGR.Player.Markers.CAP = {
  MarkerArrays = {}, -- Array to store marker data for CAP operations.
  MenuArrays = {} -- Array to store menu data for CAP operations.
}

--- TOMAHAWK Markers.
-- Stores arrays for TOMAHAWK missile strike markers and associated menus.
-- @field #PLYRMGR.Player.Markers.TOMAHAWK
SPECTRE.PLYRMGR.Player.Markers.TOMAHAWK = {
  MarkerArrays = {}, -- Array to store marker data for TOMAHAWK strikes.
  MenuArrays = {} -- Array to store menu data for TOMAHAWK strikes.
}

--- BOMBER Markers.
-- Stores arrays for bomber strike markers and associated menus.
-- @field #PLYRMGR.Player.Markers.BOMBER
SPECTRE.PLYRMGR.Player.Markers.BOMBER = {
  MarkerArrays = {}, -- Array to store marker data for bomber strikes.
  MenuArrays = {} -- Array to store menu data for bomber strikes.
}

--- AIRDROP Markers.
-- Stores arrays for airdrop operation markers and associated menus.
-- @field #PLYRMGR.Player.Markers.AIRDROP
SPECTRE.PLYRMGR.Player.Markers.AIRDROP = {
  MarkerArrays = {}, -- Array to store marker data for airdrop operations.
  MenuArrays = {} -- Array to store menu data for airdrop operations.
}

--- STRIKE Markers.
-- Stores arrays for strike operation markers and associated menus.
-- @field #PLYRMGR.Player.Markers.STRIKE
SPECTRE.PLYRMGR.Player.Markers.STRIKE = {
  MarkerArrays = {}, -- Array to store marker data for strike operations.
  MenuArrays = {} -- Array to store menu data for strike operations.
}

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **POLY**
--
-- Shape manipulation and analytical geometry.
-- 
-- ===
--
-- @module POLY
-- @extends SPECTRE

--- SPECTRE.POLY.
--
-- Shape manipulation and analytical geometry.
--
-- @section POLY
-- @field #POLY
SPECTRE.POLY = {}

--- Line.
-- ===
--
-- *All Functions associated with line operations.*
--
-- ===
-- @section SPECTRE.POLY


--- Extend a Line.
--
-- Extends both ends of a given line by a specified length.
--
-- @param line A table containing two points, each having 'x' and 'y' attributes.
-- @param extension The length by which both ends of the line will be extended.
-- @return The extended line with modified points.
-- @usage local extended = SPECTRE.POLY.extendLine({{x=0, y=0}, {x=1, y=1}}, 1) -- Extends the line by 1 unit on both ends.
function SPECTRE.POLY.extendLine(line, extension)
  -- Calculate the differences in x and y coordinates between the two points
  local dx = line[2].x - line[1].x
  local dy = line[2].y - line[1].y
  -- Calculate the length of the line
  local length = math.sqrt(dx^2 + dy^2)
  -- If the length is 0, simply return the line as it is
  if length == 0 then return line end
  -- Normalize the direction vector
  local nx = dx / length
  local ny = dy / length
  -- Extend the starting point of the line
  line[1].x = line[1].x - nx * extension
  line[1].y = line[1].y - ny * extension
  -- Extend the ending point of the line
  line[2].x = line[2].x + nx * extension
  line[2].y = line[2].y + ny * extension
  return line
end

--- Find Perpendicular Endpoint.
--
-- Calculates the endpoint of a line segment that is perpendicular to a given line, originates from a given point, and has a given length.
--
-- @param Point A table containing an 'x' and 'y' attribute representing the starting point of the perpendicular line segment.
-- @param line A table containing two points, each having 'x' and 'y' attributes, representing the original line.
-- @param length The length of the perpendicular line segment.
-- @return A table with 'x' and 'y' attributes representing the endpoint of the perpendicular line segment.
-- @usage local endpoint = SPECTRE.POLY.findPerpendicularEndpoints({x=1, y=1}, {{x=0, y=0}, {x=1, y=1}}, 1) -- Finds the endpoint of a 1 unit long perpendicular line segment.
function SPECTRE.POLY.findPerpendicularEndpoints(Point, line, length)
  -- Calculate the differences in x and y coordinates between the two points of the line
  local dx = line[2].x - line[1].x
  local dy = line[2].y - line[1].y
  -- If the dx is 0, then the line is vertical and the perpendicular line is horizontal
  if dx == 0 then
    return {x = Point.x, y = Point.y + length}
  end
  -- Calculate the slope of the line
  local m = dy / dx
  -- Calculate the slope of the perpendicular line
  local m_perpendicular = -1 / m
  -- Find the x-coordinate of the endpoint of the perpendicular line segment
  local x = Point.x + length / math.sqrt(1 + m_perpendicular^2)
  -- Using the point-slope form of a line equation, calculate the y-coordinate of the endpoint
  local y = Point.y + m_perpendicular * (x - Point.x)
  return {x = x, y = y}
end

--- Calculate Line Slope.
--
-- Calculates the slope of a given line.
--
-- @param line A table containing two points, each having 'x' and 'y' attributes.
-- @return The slope of the line, or 'math.huge' if the line is vertical.
-- @usage local slope = SPECTRE.POLY.calculateLineSlope({{x=0, y=0}, {x=1, y=1}}) -- Calculates the slope of the line.
function SPECTRE.POLY.calculateLineSlope(line)
  -- Calculate the differences in x and y coordinates between the two points of the line
  local dx = line[2].x - line[1].x
  local dy = line[2].y - line[1].y
  -- If dx is 0, the line is vertical and slope is infinite
  if dx == 0 then
    return math.huge
  end
  -- Calculate the slope of the line using the formula (change in y) / (change in x)
  local slope = dy/dx
  return slope
end

--- Find Other Endpoint of a Line Segment.
--
-- Calculates the other endpoint of a line segment given one endpoint, the slope, and the length of the segment.
--
-- @param endpoint A table containing an 'x' and 'y' attribute representing one endpoint of the line segment.
-- @param slope The slope of the line segment.
-- @param length The length of the line segment.
-- @return A table with 'x' and 'y' attributes representing the other endpoint of the line segment.
-- @usage local otherEndpoint = SPECTRE.POLY.findOtherEndpoint({x=1, y=1}, 1, 1) -- Finds the other endpoint of the line segment.
function SPECTRE.POLY.findOtherEndpoint(endpoint, slope, length)
  -- If slope is infinite (i.e., the line is vertical)
  if slope == math.huge then
    return {x = endpoint.x, y = endpoint.y + length}
  end
  -- Calculate the magnitude of the direction vector of the line
  local magnitude = math.sqrt(1 + slope^2)
  -- Normalize the direction vector to get unit vector components
  local unit_dx = 1 / magnitude
  local unit_dy = slope / magnitude
  -- Calculate the x and y components of the displacement from the given endpoint to the other endpoint
  local dx = unit_dx * length
  local dy = unit_dy * length
  -- Compute the coordinates of the other endpoint
  local OtherEnd = {
    x = endpoint.x + dx,
    y = endpoint.y + dy
  }
  return OtherEnd
end

--- Calculate Midpoint of a Line Segment.
--
-- Computes the midpoint of a given line segment.
--
-- @param line A table containing two points, each having 'x' and 'y' attributes.
-- @return A table with 'x' and 'y' attributes representing the midpoint of the line segment.
-- @usage local midpoint = SPECTRE.POLY.getMidpoint({{x=0, y=0}, {x=2, y=2}}) -- Calculates the midpoint of the line segment.
function SPECTRE.POLY.getMidpoint(line)
  -- Calculate the x and y coordinates of the midpoint using the average of the endpoints' coordinates
  return {
    x = (line[1].x + line[2].x) / 2,
    y = (line[1].y + line[2].y) / 2
  }
end

--- Check if Two Lines are Within a Specified Offset.
--
-- Determines if two line segments are within a certain offset from each other by sampling points on the lines.
--
-- @param LineA A table containing two points of the first line segment, each having 'x' and 'y' attributes.
-- @param LineB A table containing two points of the second line segment, each having 'x' and 'y' attributes.
-- @param Offset The distance threshold for the points on the lines.
-- @return True if the lines are within the offset, false otherwise.
-- @usage local result = SPECTRE.POLY.isWithinOffset(line1, line2, 10) -- Checks if line1 and line2 are within an offset of 10 units from each other.
function SPECTRE.POLY.isWithinOffset(LineA, LineB, Offset)
  local DesiredPoints = 11
  -- Compute the ratio of the lengths of LineA and LineB
  local PointConfirmRate = SPECTRE.UTILS.computeRatio(SPECTRE.POLY.lineLength(LineA), SPECTRE.POLY.lineLength(LineB))
  -- Compute the number of confirmation points needed based on the desired points and the computed ratio
  local threshold = DesiredPoints * PointConfirmRate
  -- Nested function to check if the sampled points on one line are within the offset of the other line
  local function checkPointsWithinOffset(lineToSample, lineToCheckAgainst)
    local ticker = 0
    -- Sample equally spaced points from the line
    local points = SPECTRE.POLY.getEquallySpacedPoints(lineToSample, DesiredPoints)
    -- Check each sampled point against the other line to determine proximity
    for _, point in ipairs(points) do
      if math.sqrt(SPECTRE.POLY.pointToSegmentSquared(point.x, point.y, lineToCheckAgainst[1].x, lineToCheckAgainst[1].y, lineToCheckAgainst[2].x, lineToCheckAgainst[2].y)) <= Offset then
        ticker = ticker + 1
        if ticker >= threshold then
          return true
        end
      end
    end
    return false
  end
  -- Check both LineA against LineB and LineB against LineA to account for both possibilities
  return checkPointsWithinOffset(LineA, LineB) or checkPointsWithinOffset(LineB, LineA)
end

--- Calculate Length of a Line Segment.
--
-- Computes the length of a given line segment using the Pythagorean theorem.
--
-- @param line A table containing two points, each having 'x' and 'y' attributes.
-- @return The length of the line segment.
-- @usage local length = SPECTRE.POLY.lineLength({{x=0, y=0}, {x=3, y=4}}) -- Calculates the length of the line segment (should return 5 in this example).
function SPECTRE.POLY.lineLength(line)
  -- Calculate the differences in x and y coordinates between the two endpoints of the line
  local dx = line[2].x - line[1].x
  local dy = line[2].y - line[1].y
  -- Use the Pythagorean theorem to compute the length of the line segment
  return math.sqrt(dx^2 + dy^2)
end

--- Generate a Random Point on a Line Segment.
--
-- Computes a random point on a given line segment using linear interpolation.
--
-- @param inputLine A table containing two points, each having 'x' and 'y' attributes.
-- @return A table with 'x' and 'y' attributes representing the randomly generated point on the line segment.
-- @usage local randomPoint = SPECTRE.POLY.randomPointOnLine({{x=0, y=0}, {x=10, y=10}}) -- Gets a random point on the line segment.
function SPECTRE.POLY.randomPointOnLine(inputLine)
  local p1, p2 = inputLine[1], inputLine[2]
  -- Generate a random parameter t in [0, 1]
  local t = math.random()
  -- Compute the x and y coordinates of the random point using linear interpolation
  return {
    x = p1.x + t * (p2.x - p1.x),
    y = p1.y + t * (p2.y - p1.y)
  }
end

--- Generate Equally Spaced Points on a Line Segment.
--
-- Computes a set of equally spaced points on a given line segment using linear interpolation.
--
-- @param InputLine A table containing two points, each having 'x' and 'y' attributes.
-- @param DesiredPoints The number of equally spaced points to generate.
-- @return A table of tables, each with 'x' and 'y' attributes, representing the equally spaced points on the line segment.
-- @usage local points = SPECTRE.POLY.getEquallySpacedPoints({{x=0, y=0}, {x=10, y=10}}, 5) -- Gets 5 equally spaced points on the line segment.
function SPECTRE.POLY.getEquallySpacedPoints(InputLine, DesiredPoints)
  local P1, P2 = InputLine[1], InputLine[2]
  local OutputPoints = {}
  -- Iterate from 1 to DesiredPoints to compute each equally spaced point
  for i = 1, DesiredPoints do
    -- Calculate the parameter t based on the current iteration and total number of desired points
    local t = i / (DesiredPoints + 1)
    -- Compute the x and y coordinates of each point using linear interpolation
    table.insert(OutputPoints, {
      x = (1 - t) * P1.x + t * P2.x,
      y = (1 - t) * P1.y + t * P2.y
    })
  end
  return OutputPoints
end

--- Compute Intersection Point of Two Line Segments.
--
-- Computes the intersection point of two given line segments. Returns (0, 0) if the line segments don't intersect.
--
-- @param points A table containing four points, each having 'x' and 'y' attributes. The first two points represent the first line segment and the next two represent the second line segment.
-- @return xk,yk The x and y coordinates of the intersection point.
-- @usage local x, y = SPECTRE.POLY.GetIntersect({{x=0, y=0}, {x=10, y=10}, {x=0, y=10}, {x=10, y=0}}) -- Gets the intersection point of the two line segments.
function SPECTRE.POLY.GetIntersect(points)
  -- Extract points for clarity
  local p1, p2, p3, p4 = points[1], points[2], points[3], points[4]
  -- Initialize intersection point coordinates
  local xk, yk = 0, 0
  -- Check if the two line segments intersect
  if SPECTRE.POLY.checkIntersect(p1, p2, p3, p4) then
    -- Compute line parameters for the line formed by points p1 and p2
    local a = p2.y - p1.y
    local b = p2.x - p1.x
    local v = a * p1.x - b * p1.y
    -- Compute line parameters for the line formed by points p3 and p4
    local c = p4.y - p3.y
    local d = p4.x - p3.x
    local w = c * p3.x - d * p3.y
    -- Compute intersection point using determinants
    local denom = a * d - b * c
    if denom ~= 0 then
      xk = (d * v - b * w) / denom
      yk = (-a * w + c * v) / denom
    end
  end
  -- Return intersection point
  return xk, yk
end

--- Check if Two Line Segments Intersect.
--
-- Determines if two given line segments intersect using orientation values.
--
-- @param l1 A table containing two points (p1 and p2) representing the first line segment, each having 'x' and 'y' attributes.
-- @param l2 A table containing two points (p1 and p2) representing the second line segment, each having 'x' and 'y' attributes.
-- @return bool  True if the line segments intersect, false otherwise.
-- @usage local intersect = SPECTRE.POLY.isIntersect({p1={x=0, y=0}, p2={x=10, y=10}}, {p1={x=0, y=10}, p2={x=10, y=0}}) -- Checks if the two line segments intersect.
function SPECTRE.POLY.isIntersect(l1, l2)
  -- Calculate orientation values for each pair of points from the two lines
  local dir1 = SPECTRE.POLY.direction(l1.p1, l1.p2, l2.p1)
  local dir2 = SPECTRE.POLY.direction(l1.p1, l1.p2, l2.p2)
  local dir3 = SPECTRE.POLY.direction(l2.p1, l2.p2, l1.p1)
  local dir4 = SPECTRE.POLY.direction(l2.p1, l2.p2, l1.p2)
  -- If orientations of the endpoints with respect to each line are different, the lines intersect
  if dir1 ~= dir2 and dir3 ~= dir4 then
    return true
  end
  -- Check for colinearity and if a point of one line lies on the other line
  if dir1 == 0 and SPECTRE.POLY.onLine(l1, l2.p1) then
    return true
  end
  if dir2 == 0 and SPECTRE.POLY.onLine(l1, l2.p2) then
    return true
  end
  if dir3 == 0 and SPECTRE.POLY.onLine(l2, l1.p1) then
    return true
  end
  if dir4 == 0 and SPECTRE.POLY.onLine(l2, l1.p2) then
    return true
  end
  -- If none of the above conditions are met, lines do not intersect
  return false
end


--- Point.
-- ===
--
-- *All Functions associated with vertex operations.*
--
-- ===
-- @section SPECTRE.POLY

--- Calculate Distance Between Two Points.
--
-- Computes the distance between two given points using the Pythagorean theorem.
--
-- @param point1 A table having 'x' and 'y' attributes representing the first point.
-- @param point2 A table having 'x' and 'y' attributes representing the second point.
-- @return The distance between the two points.
-- @usage local dist = SPECTRE.POLY.distance({x=0, y=0}, {x=3, y=4}) -- Calculates the distance between the two points (should return 5 in this example).
function SPECTRE.POLY.distance(point1, point2)
  -- Calculate the differences in x and y coordinates between the two points
  local dx = point1.x - point2.x
  local dy = point1.y - point2.y

  -- Use the Pythagorean theorem to compute the distance
  return math.sqrt(dx^2 + dy^2)
end

--- Calculate Squared Distance from a Point to a Line Segment.
--
-- Computes the squared distance from a given point to a line segment.
--
-- @param px x-coordinate of the point.
-- @param py y-coordinate of the point.
-- @param ax x-coordinate of the first endpoint of the line segment.
-- @param ay y-coordinate of the first endpoint of the line segment.
-- @param bx x-coordinate of the second endpoint of the line segment.
-- @param by y-coordinate of the second endpoint of the line segment.
-- @return number The squared distance from the point to the line segment.
-- @usage local squaredDist = SPECTRE.POLY.pointToSegmentSquared(1, 1, 0, 0, 2, 2) -- Calculates the squared distance from the point to the line segment.
function SPECTRE.POLY.pointToSegmentSquared(px, py, ax, ay, bx, by)
  -- Calculate the squared distance between the endpoints of the segment
  local l2 = SPECTRE.POLY.distanceSquared(ax, ay, bx, by)

  -- If the segment is a point, return the squared distance to the point
  if l2 == 0 then return SPECTRE.POLY.distanceSquared(px, py, ax, ay) end

  -- Project the point onto the line segment and find the parameter t
  local t = SPECTRE.POLY.dot(px - ax, py - ay, bx - ax, by - ay) / l2

  -- If t is outside [0, 1], the point lies outside the segment, so return the squared distance to the nearest endpoint
  if t < 0 then return SPECTRE.POLY.distanceSquared(px, py, ax, ay) end
  if t > 1 then return SPECTRE.POLY.distanceSquared(px, py, bx, by) end

  -- Compute the squared distance from the point to its projection on the segment
  return SPECTRE.POLY.distanceSquared(px, py, ax + t * (bx - ax), ay + t * (by - ay))
end

--- Calculate Squared Distance Between Two Points.
--
-- Computes the squared distance between two given points using the Pythagorean theorem.
--
-- @param ax x-coordinate of the first point.
-- @param ay y-coordinate of the first point.
-- @param bx x-coordinate of the second point.
-- @param by y-coordinate of the second point.
-- @return number The squared distance between the two points.
-- @usage local squaredDist = SPECTRE.POLY.distanceSquared(0, 0, 3, 4) -- Calculates the squared distance between the two points (should return 25 in this example).
function SPECTRE.POLY.distanceSquared(ax, ay, bx, by)
  -- Calculate the differences in x and y coordinates between the two points
  local dx = ax - bx
  local dy = ay - by

  -- Return the squared distance using the Pythagorean theorem
  return dx * dx + dy * dy
end

--- Calculate Cross Product of Vectors Formed by Three Points.
--
-- Computes the cross product (determinant) of the vectors formed by three given points.
--
-- @param p1 A table having 'x' and 'y' attributes representing the first point.
-- @param p2 A table having 'x' and 'y' attributes representing the second point.
-- @param p3 A table having 'x' and 'y' attributes representing the third point.
-- @return number The cross product of the vectors formed by the three points.
-- @usage local crossProd = SPECTRE.POLY:crossProduct({x=0, y=0}, {x=1, y=1}, {x=0, y=2}) -- Calculates the cross product of the vectors formed by the three points.
function SPECTRE.POLY:crossProduct(p1, p2, p3)
  -- Calculate and return the cross product (determinant) of the vectors formed by the three points
  return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x)
end

--- Check if Point is Colinear with a Line Segment.
--
-- Determines if a given point is colinear with a line segment within a specified tolerance.
--
-- @param line A table containing two points, each having 'x' and 'y' attributes, representing the line segment.
-- @param x x-coordinate of the test point.
-- @param y y-coordinate of the test point.
-- @param e Tolerance value for colinearity check. Defaults to 0.1 if not provided.
-- @return boolean True if the point is colinear with the line segment within the tolerance, false otherwise.
-- @usage local isColinear = SPECTRE.POLY.colinear({{x=0, y=0}, {x=10, y=10}}, 5, 5) -- Checks if the point (5,5) is colinear with the line segment.
function SPECTRE.POLY.colinear(line, x, y, e)
  e = e or 0.1  -- Default tolerance

  -- If the line segment is vertical
  if line[2].x - line[1].x == 0 then
    return math.abs(x - line[1].x) <= e
  end

  -- Calculate the slope of the line
  local m = (line[2].y - line[1].y) / (line[2].x - line[1].x)

  -- Compute the expected y-coordinate for the given x using the line equation
  local expectedY = line[1].y + m * (x - line[1].x)

  -- Check if the actual y is close enough to the expected y within the tolerance
  return math.abs(y - expectedY) <= e
end

--- Check if Point is On or Within Bounds of a Line Segment.
--
-- Determines if a given point lies on or within the bounds of a line segment.
--
-- @param l1 A table containing two points (p1 and p2) representing the line segment, each having 'x' and 'y' attributes.
-- @param p A table having 'x' and 'y' attributes representing the test point.
-- @return boolean True if the point lies on or within the bounds of the line segment, false otherwise.
-- @usage local isOnLine = SPECTRE.POLY.onLine({p1={x=0, y=0}, p2={x=10, y=10}}, {x=5, y=5}) -- Checks if the point (5,5) lies on the line segment.
function SPECTRE.POLY.onLine(l1, p)
  -- Check if the x and y coordinates of the point are within the bounds of the line segment's endpoints
  if (p.x >= math.min(l1.p1.x, l1.p2.x) and p.x <= math.max(l1.p1.x, l1.p2.x)
    and p.y >= math.min(l1.p1.y, l1.p2.y) and p.y <= math.max(l1.p1.y, l1.p2.y)) then
    return true
  end

  return false
end

--- Check if a Point is Within a Polygon.
--
-- Determines if a given point lies inside a polygon using the ray casting method.
--
-- @param P A table having 'x' and 'y' attributes representing the point to check.
-- @param Polygon A table containing vertices of the polygon, each vertex is a table with 'x' and 'y' attributes.
-- @return boolean True if the point lies inside the polygon, false otherwise.
-- @usage local isWithin = SPECTRE.POLY.PointWithinShape({x=5, y=5}, {{x=0, y=0}, {x=10, y=0}, {x=10, y=10}, {x=0, y=10}}) -- Checks if the point (5,5) lies inside the square polygon.
function SPECTRE.POLY.PointWithinShape(P, Polygon)
  local n = #Polygon

  -- A polygon must have at least 3 vertices to enclose a space
  if n < 3 then
    return false
  end

  -- Create a point for line segment from P to infinite
  local extreme = {x = 99999999, y = P.y}

  -- Count intersections of the above line with sides of polygon
  local count = 0
  local i = 1

  -- Use a loop to iterate through all sides of the polygon
  repeat
    local next = (i % n) + 1
    local side = {p1 = Polygon[i], p2 = Polygon[next]}

    -- Check if the line segment formed by P and extreme intersects with the side of the polygon
    if SPECTRE.POLY.isIntersect(side, {p1 = P, p2 = extreme}) then

      -- If the point P is collinear with the side of the polygon, check if it lies on the segment
      if SPECTRE.POLY.direction(side.p1, P, side.p2) == 0 then
        return SPECTRE.POLY.onLine(side, P)
      end

      -- Increment the count of intersections
      count = count + 1
    end

    i = next
  until i == 1

  -- Return `true` if count is odd, `false` otherwise. If the count of intersections is odd, the point is inside.
  return (count % 2) == 1
end

--- Determine the Direction of Turn for Three Ordered Points.
--
-- Computes the direction of a turn for three ordered points. It can be clockwise, counterclockwise, or the points can be collinear.
--
-- @param a First point, a table with 'x' and 'y' attributes.
-- @param b Second point, a table with 'x' and 'y' attributes.
-- @param c Third point, a table with 'x' and 'y' attributes.
-- @return 0 if the points are collinear
-- @return 1 if the direction is clockwise
-- @return 2 if the direction is counterclockwise
-- @usage local dir = SPECTRE.POLY.direction({x=0, y=0}, {x=1, y=1}, {x=2, y=2}) -- Returns 0 as the points are collinear.
function SPECTRE.POLY.direction(a, b, c)
  local val = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)

  -- Check if the points are collinear
  if val == 0 then
    return 0
      -- Check if the direction is counterclockwise
  elseif val < 0 then
    return 2
      -- If not collinear and not counterclockwise, then it's clockwise
  else
    return 1
  end
end

--- Calculate the Dot Product of Two Vectors.
--
-- Computes the dot product of two vectors given their 'x' and 'y' components.
--
-- @param ax The 'x' component of the first vector.
-- @param ay The 'y' component of the first vector.
-- @param bx The 'x' component of the second vector.
-- @param by The 'y' component of the second vector.
-- @return number The dot product of the two vectors.
-- @usage local product = SPECTRE.POLY.dot(1, 2, 3, 4) -- Calculates the dot product of vectors (1,2) and (3,4).
function SPECTRE.POLY.dot(ax, ay, bx, by)
  -- Return the dot product of the two vectors
  return ax * bx + ay * by
end

--- Shape.
-- ===
--
-- *All Functions associated with Closed Shape operations.*
--
-- ===
-- @section SPECTRE.POLY



--- Convert a Polygonal Zone into a List of Line Segments.
--
-- Takes a zone represented as a list of points and converts it into a list of line segments.
--
-- @param zone A list of points representing the polygonal zone. Each point is a table with 'x' and 'y' attributes.
-- @return lines A list of line segments. Each line segment is represented by two points (start and end).
-- @usage local lines = SPECTRE.POLY.convertZoneToLines({{x=0, y=0}, {x=10, y=0}, {x=10, y=10}, {x=0, y=10}}) -- Converts a square zone into its four edges.
function SPECTRE.POLY.convertZoneToLines(zone)
  local lines = {}

  -- Iterate through the points in the zone
  for i = 1, #zone do
    -- Determine the next point (if the current point is the last one, the next is the first)
    local nextIndex = (i == #zone) and 1 or (i + 1)

    -- Create a line segment between the current point and the next point
    table.insert(lines, {{x = zone[i].x, y = zone[i].y}, {x = zone[nextIndex].x, y = zone[nextIndex].y}})
  end

  return lines
end

--- Ensure a Quadrilateral is Convex.
--
-- Adjusts a quadrilateral to ensure that it is convex by checking the cross products of consecutive vertices. If necessary, it swaps the last two vertices.
--
-- @param zoneCoords A list of four points representing the quadrilateral. Each point is a table with 'x' and 'y' attributes.
-- @return zoneCoords The possibly adjusted list of four points ensuring the quadrilateral is convex.
-- @usage local convexZone = SPECTRE.POLY.ensureConvex({{x=0, y=0}, {x=10, y=0}, {x=10, y=10}, {x=0, y=10}}) -- Adjusts the zone to ensure it's convex.
function SPECTRE.POLY.ensureConvex(zoneCoords)
  -- Calculate the signs of the cross products of consecutive vertices
  local signs = {
    SPECTRE.POLY:crossProduct(zoneCoords[1], zoneCoords[2], zoneCoords[3]) >= 0,
    SPECTRE.POLY:crossProduct(zoneCoords[2], zoneCoords[3], zoneCoords[4]) >= 0,
    SPECTRE.POLY:crossProduct(zoneCoords[3], zoneCoords[4], zoneCoords[1]) >= 0,
    SPECTRE.POLY:crossProduct(zoneCoords[4], zoneCoords[1], zoneCoords[2]) >= 0
  }

  -- If the signs are not consistent, swap the last two vertices
  if not (signs[1] == signs[2] and signs[2] == signs[3] and signs[3] == signs[4]) then
    zoneCoords[3], zoneCoords[4] = zoneCoords[4], zoneCoords[3]
  end

  return zoneCoords
end

--- Calculates the area of a polygon.
-- @param coords ipairs vec2 table
-- @return area
function SPECTRE.POLY.polygonArea(coords)
  local n = #coords
  local area = 0
  for i=1, n-1 do
    area = area + coords[i].x * coords[i+1].y - coords[i+1].x * coords[i].y
  end
  area = area + coords[n].x * coords[1].y - coords[1].x * coords[n].y
  return 0.5 * math.abs(area)
end

--- Triangulate a Quadrilateral into Two Triangles.
--
-- Takes a 4-point polygon (quadrilateral) and splits it into two triangles.
--
-- @param zoneCoords A list of four points representing the quadrilateral. Each point is a table with 'x' and 'y' attributes.
-- @return table A list containing two triangles formed from the quadrilateral. {[1] = triangle1,[2] = triangle2,}
-- @return error An error message if the input does not represent a 4-point polygon.
-- @usage local triangles = SPECTRE.POLY.triangulateZone({{x=0, y=0}, {x=10, y=0}, {x=10, y=10}, {x=0, y=10}}) -- Splits the square into two triangles.
function SPECTRE.POLY.triangulateZone(zoneCoords)
  -- Ensure we have a 4-point zone
  if #zoneCoords ~= 4 then
    return nil, "Expected a 4-point polygon"
  end
  -- Create the first triangle using the first three points of the zone
  local triangle1 = {
    [1] = zoneCoords[1],
    [2] = zoneCoords[2],
    [3] = zoneCoords[3],
  }
  -- Create the second triangle using the first, third, and fourth points of the zone
  local triangle2 = {
    [1] = zoneCoords[1],
    [2] = zoneCoords[3],
    [3] = zoneCoords[4],
  }
  -- Return the two triangles
  return {
    [1] = triangle1,
    [2] = triangle2,
  }
end

--- Determine if a Point is Inside a Polygon using Crossings Multiply Test.
--
-- Uses the crossings or even-odd rule method to determine if a given point, specified by its 'x' and 'y' coordinates, lies inside the polygon 'pgon'.
--
-- @param pgon A list of points representing the polygon vertices in order. Each point is a table with 'x' and 'y' attributes.
-- @param tx The 'x' coordinate of the point to check.
-- @param ty The 'y' coordinate of the point to check.
-- @return boolean 'true' if the point is inside the polygon, 'false' otherwise.
-- @usage local insidePolygon = SPECTRE.POLY.CrossingsMultiplyTest({{x=0, y=0}, {x=10, y=0}, {x=10, y=10}, {x=0, y=10}}, 5, 5) -- Returns 'true' as the point is inside the square.
function SPECTRE.POLY.CrossingsMultiplyTest(pgon, tx, ty)
  local numverts = #pgon              -- Get the number of vertices in the polygon
  local inside_flag = false           -- Initialize the flag for the point being inside the polygon
  local yflag0 = (pgon[numverts].y >= ty)  -- Determine if the last vertex is above the test point
  -- Loop through each vertex of the polygon
  for i = 1, numverts do
    local vtx0 = pgon[i]
    local vtx1 = pgon[i % numverts + 1]
    local yflag1 = (vtx1.y >= ty)
    -- Check if the edge from the current vertex to the next vertex crosses the horizontal line through the test point
    if yflag0 ~= yflag1 then
      -- Check if the test point is to the left of the edge
      if ((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) * (vtx0.y - vtx1.y)) == yflag1 then
        inside_flag = not inside_flag   -- Toggle the inside flag
      end
    end
    yflag0 = yflag1  -- Update yflag0 for the next iteration
  end
  -- Return the result
  return inside_flag
end

--- Generates a list of subcircles within a main circle while avoiding overlaps.
--
-- OLD FUNCTION. Kept for later updates. Good Version is built into `SPECTRE.SPAWNER.generateSubZoneCircles`
--
-- This function generates a list of subcircles within a main circle defined by `mainCircleSize` and `mainCircleVec2`. It aims to create `numSubCircles` subcircles with a minimum size of `subCircleMinSize`. The generated subcircles are guaranteed not to overlap with each other or extend beyond the boundaries of the main circle.
--
-- @param mainCircleSize The size (diameter) of the main circle.
-- @param mainCircleVec2 The center coordinates of the main circle.
-- @param numSubCircles The desired number of subcircles to generate.
-- @param subCircleMinSize The minimum size (diameter) of each subcircle.
-- @return table A table containing the generated subcircles, each represented as a table with `vec2` (center coordinates) and `diameter` (size) attributes.
function SPECTRE.POLY.generateSubCircles(mainCircleSize, mainCircleVec2, numSubCircles, subCircleMinSize)
  SPECTRE.UTILS.debugInfo("SPECTRE.POLY.generateSubCircles | ---------------------- |")
  local generatedSubCircles = {}
  local mainRadius = mainCircleSize / 2
  local attempts = 0 -- to prevent infinite loops

  while #generatedSubCircles < numSubCircles and attempts < numSubCircles * 100 do
    local subCircle = {}
    local subRadius

    subRadius = math.random(subCircleMinSize / 2, mainRadius) / 2
    local angle = math.random() * 2 * math.pi
    local maxDistFromCenter = mainRadius - subRadius
    local minDistFromCenter = subRadius
    local distFromCenter = math.random(minDistFromCenter, maxDistFromCenter)

    subCircle.vec2 = {
      x = mainCircleVec2.x + distFromCenter * math.cos(angle),
      y = mainCircleVec2.y + distFromCenter * math.sin(angle)
    }

    subCircle.diameter = subRadius * 2
    if SPECTRE.POLY.isSubCircleValid(subCircle, generatedSubCircles, mainCircleVec2, mainRadius) then
      table.insert(generatedSubCircles, subCircle)
    end
    attempts = attempts + 1
  end
  return generatedSubCircles
end
--- Checks if a subcircle is valid based on a threshold for overlapping with other subcircles and being within the main circle's boundaries.
--
-- This function determines the validity of a `subCircle` by considering whether it overlaps with any of the `generatedSubCircles` beyond the specified `threshold`. Additionally, it checks if the `subCircle` remains within the boundaries of the main circle defined by `mainCircleVec2` and `mainRadius`.
--
-- @param subCircle The subcircle to validate.
-- @param generatedSubCircles A list of already generated subcircles to compare against.
-- @param mainCircleVec2 The center coordinates of the main circle.
-- @param mainRadius The radius of the main circle.
-- @param threshold The allowed threshold for overlapping (0 to 1).
-- @return boolean Returns true if the subcircle is valid; otherwise, false.
function SPECTRE.POLY.isSubCircleValid(subCircle, generatedSubCircles, mainCircleVec2, mainRadius)
  for _, existingSubCircle in ipairs(generatedSubCircles) do
    if SPECTRE.POLY.doesCircleOverlap(subCircle, existingSubCircle) then
      return false
    end
  end
  return SPECTRE.POLY.isWithinMainCircle(subCircle, mainCircleVec2, mainRadius)
end
--- Checks if a subcircle is completely within the boundaries of the main circle.
--
-- This function verifies whether the given `subCircle` is entirely contained within the main circle defined by `mainCircleVec2` and `mainRadius`.
--
-- @param subCircle The subcircle to check.
-- @param mainCircleVec2 The center coordinates of the main circle.
-- @param mainRadius The radius of the main circle.
-- @return boolean Returns true if the subcircle is entirely within the main circle; otherwise, false.
function SPECTRE.POLY.isSubCircleValidThreshold(subCircle, generatedSubCircles, mainCircleVec2, mainRadius, threshold)
  for _, existingSubCircle in ipairs(generatedSubCircles) do
    if SPECTRE.POLY.doesCircleOverlapThreshold(subCircle, existingSubCircle, threshold) then
      return false
    end
  end
  return SPECTRE.POLY.isWithinMainCircleThreshold(subCircle, mainCircleVec2, mainRadius, threshold)
end

--- Checks if a subcircle is within the boundaries of the main circle with a specified threshold.
--
-- This function evaluates whether the `subCircle` remains within the main circle defined by `mainCircleVec2` and `mainRadius`, considering a specified `threshold`. The `threshold` allows for some degree of overlap with the main circle.
--
-- @param subCircle The subcircle to check.
-- @param mainCircleVec2 The center coordinates of the main circle.
-- @param mainRadius The radius of the main circle.
-- @param threshold The threshold for allowed overlap (0 to 1).
-- @return boolean Returns true if the subcircle is within the main circle with the given threshold; otherwise, false.
function SPECTRE.POLY.isWithinMainCircle(subCircle, mainCircleVec2, mainRadius)
  local dx = subCircle.vec2.x - mainCircleVec2.x
  local dy = subCircle.vec2.y - mainCircleVec2.y
  local distanceToCenter = math.sqrt(dx * dx + dy * dy)
  return distanceToCenter + subCircle.diameter / 2 <= mainRadius
end
--- Checks if two circles overlap.
--
-- This function determines whether two circles defined by `subCircle1` and `subCircle2` overlap with each other.
--
-- @param subCircle1 The first circle to check for overlap.
-- @param subCircle2 The second circle to check for overlap.
-- @return boolean Returns true if the circles overlap; otherwise, false.
function SPECTRE.POLY.isWithinMainCircleThreshold(subCircle, mainCircleVec2, mainRadius, threshold)
  local dx = subCircle.vec2.x - mainCircleVec2.x
  local dy = subCircle.vec2.y - mainCircleVec2.y
  local distanceToCenter = math.sqrt(dx * dx + dy * dy)
  local allowedOutside = subCircle.diameter / 2 * threshold
  return distanceToCenter + subCircle.diameter / 2 - allowedOutside <= mainRadius
end
--- Checks if two circles overlap.
--
-- This function determines whether two circles defined by `subCircle1` and `subCircle2` overlap with each other.
--
-- @param subCircle1 The first circle to check for overlap.
-- @param subCircle2 The second circle to check for overlap.
-- @return boolean Returns true if the circles overlap; otherwise, false.
function SPECTRE.POLY.doesCircleOverlap(subCircle1, subCircle2)
  local dx = subCircle1.vec2.x - subCircle2.vec2.x
  local dy = subCircle1.vec2.y - subCircle2.vec2.y
  local distanceBetweenCenters = math.sqrt(dx * dx + dy * dy)
  return distanceBetweenCenters < (subCircle1.diameter / 2 + subCircle2.diameter / 2)
end
--- Checks if two circles overlap with a specified threshold.
--
-- This function assesses whether two circles defined by `subCircle1` and `subCircle2` overlap with each other while considering a specified `threshold`. The `threshold` allows for some degree of non-overlapping.
--
-- @param subCircle1 The first circle to check for overlap.
-- @param subCircle2 The second circle to check for overlap.
-- @param threshold The threshold for allowed overlap (0 to 1).
-- @return boolean Returns true if the circles overlap within the given threshold; otherwise, false.
function SPECTRE.POLY.doesCircleOverlapThreshold(subCircle1, subCircle2, threshold)
  local dx = subCircle1.vec2.x - subCircle2.vec2.x
  local dy = subCircle1.vec2.y - subCircle2.vec2.y
  local distanceBetweenCenters = math.sqrt(dx * dx + dy * dy)
  local allowedOverlap = (subCircle1.diameter / 2 + subCircle2.diameter / 2) * (1 - threshold)
  return distanceBetweenCenters < allowedOverlap
end

--- Shrinks a polygon's boundaries by given distance.
-- @param polygon vec2 ipair
-- @param shrinkDistance
-- @return shrunkenPolygon
function SPECTRE.POLY.getShrunkenPolygon(polygon, shrinkDistance)
  SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | ------- ", polygon)
  SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | shrinkDistance " ..  shrinkDistance)
  -- This function will calculate the shrunken polygon vertices.
  -- For each edge, move the edge towards the inside of the polygon by shrinkDistance.
  -- This is a simplified version and does not handle cases where the polygon collapses.
  local shrunkenPolygon = {}
  for i = 1, #polygon do
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | i " ..  i)
    local j = (i % #polygon) + 1
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | j " ..  j)
    -- Calculate the direction vector for the edge.
    local dirVec = {x = polygon[j].y - polygon[i].y, y = polygon[i].x - polygon[j].x}
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | dirVec.x " ..  dirVec.x)
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | dirVec.y " ..  dirVec.y)
    -- Normalize the direction vector.
    local length = math.sqrt(dirVec.x * dirVec.x + dirVec.y * dirVec.y)
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | length " ..  length)
    dirVec.x = (dirVec.x / length) * shrinkDistance
    dirVec.y = (dirVec.y / length) * shrinkDistance
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | NORM dirVec.x " ..  dirVec.x)
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | NORM dirVec.y " ..  dirVec.y)
    -- Move the vertices towards the inside of the polygon by the shrinkDistance.
    shrunkenPolygon[i] = {x = polygon[i].x + dirVec.x, y = polygon[i].y + dirVec.y}
    shrunkenPolygon[j] = {x = polygon[j].x + dirVec.x, y = polygon[j].y + dirVec.y}
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | shrunkenPolygon[i] " ,  shrunkenPolygon[i])
    SPECTRE.UTILS.debugInfo("SPECTRE.POLY.getShrunkenPolygon | shrunkenPolygon[j] " ,  shrunkenPolygon[j])
  end
  return shrunkenPolygon
end

--- Gets min and max distance across a polygon.
-- @param polygon vec2 ipair
-- @return minDistance, maxDistance
function SPECTRE.POLY.getMinMaxDistances(polygon)
  local minDistance = math.huge -- Start with the largest possible value.
  local maxDistance = 0 -- Start with the smallest possible value.
  local function distanceBetweenPoints(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    return math.sqrt(dx * dx + dy * dy)
  end
  for i = 1, #polygon do
    for j = i + 2, #polygon do -- i + 2 to skip adjacent vertices.
      if j ~= i and (j ~= i + 1) and (i ~= 1 or j ~= #polygon) then -- Exclude the edges of the polygon.
        local dist = distanceBetweenPoints(polygon[i], polygon[j])
        minDistance = math.min(minDistance, dist)
        maxDistance = math.max(maxDistance, dist)
    end
    end
  end
  return minDistance, maxDistance
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **REWARDS**
-- 
-- Player reward distribution and settings. 
-- 
-- ===
--
-- @module REWARDS
-- @extends SPECTRE


--- REWARDS.
--
-- Player reward distribution and settings. 
--
-- @section SPECTRE.REWARDS
-- @field #REWARDS
SPECTRE.REWARDS = {}

--- Disperse Reward Points Based on Event Data.
--
-- Evaluates the event data to determine the reward points for a given action, such as shooting or destroying targets. Takes into account friendly fire and other specific criteria.
--
-- @param EventData The data associated with the event.
-- @return PointReward The calculated reward or penalty points based on the event data.
function SPECTRE.REWARDS.DispersePoints(EventData)
  ---
  -- Finds the reward point value for a given input by recursing through the provided table.
  --
  -- @param #table table The table containing the possible point values.
  -- @param #table input The specific attributes to search for in the table.
  -- @return #number bestValue The highest point value found for the given input.
  local function findReward(table, input)
    local bestValue = table.General or 0
    for key, value in pairs(table) do
      if input[key] and type(value) == "table" then
        local newValue = findReward(value, input)
        bestValue = math.max(bestValue, newValue)
      elseif input[key] and type(value) == "number" then
        bestValue = math.max(bestValue, value)
      end
    end
    return bestValue
  end

  ---
  -- Gets the matching point value for the input attributes.
  --
  -- @param inputTable The table of attributes to find a matching point reward for.
  -- @return A matching point reward value.
  local function getMatchingValue(inputTable)
    return findReward(SPECTRE.REWARDS.Config.PointRewards, inputTable)
  end

  EventData = EventData or {}
  local ShooterName = EventData.IniPlayerName
  local ShooterCoalition = EventData.IniCoalition
  local TargetCoalition = EventData.TgtCoalition
  local TargetType = EventData.TgtTypeName

  if EventData.TgtUnitName == "No target object for Event ID 28" then
    local deadObject = mist.DBs.deadObjects[EventData.TgtDCSUnit.id_]
    if deadObject then
      TargetType = deadObject.objectData.type
      TargetCoalition = (deadObject.objectData.coalition == "red") and 1 or 2
      mist.DBs.deadObjects[EventData.TgtDCSUnit.id_] = nil
    end
  end
if TargetType then 
  local TargetDesc = Unit.getDescByName(TargetType)
  local TargetAttributes = TargetDesc.attributes
  local PointReward = getMatchingValue(TargetAttributes)

  if ShooterCoalition == TargetCoalition then
    PointReward = (math.ceil(PointReward / 2))
    trigger.action.outTextForGroup(EventData.IniDCSGroup.id_, "Destroying friendly assets is a court martialable offense! Deducting " .. PointReward .. " points.", 10)
    PointReward = -(PointReward)
  end

  return PointReward
  else 
  return 0
  end
end

--- Config.
--
-- Settings for a point based redeem system.
--
-- Point cost for redeems + Point Reward for Kills based on type.
--
-- @section SPECTRE.REWARDS
-- @field #Config
SPECTRE.REWARDS.Config = {}

--- PointCost.
-- Point cost for redeems.
-- @field #Config.PointCost
SPECTRE.REWARDS.Config.PointCost = {}
---.
SPECTRE.REWARDS.Config.PointCost.CAP = 100
---.
SPECTRE.REWARDS.Config.PointCost.BOMBER = 50
---.
SPECTRE.REWARDS.Config.PointCost.STRIKE = 55
---.
SPECTRE.REWARDS.Config.PointCost.TOMAHAWK = 70
---.
SPECTRE.REWARDS.Config.PointCost.ESCORT = 75
---.
SPECTRE.REWARDS.Config.PointCost.AWAKS = 200
---.
SPECTRE.REWARDS.Config.PointCost.TANKER = 100
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP = { }
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY = 50
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV = 30
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK = 50
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA = 60
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM = 70
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM = 150
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR = 250
---.
SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY = 30

--- PointRewards.
-- Point Reward for Kills based on type.
-- @field #Config.PointRewards
SPECTRE.REWARDS.Config.PointRewards = {}
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


SPECTRE.MENU.Text.CAP.Cost = string.format("C.A.P. Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.CAP)
SPECTRE.MENU.Text.TOMAHAWK.Cost = string.format("Tomahawk Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.TOMAHAWK)
SPECTRE.MENU.Text.BOMBER.Cost = string.format("Bomber Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.BOMBER)
SPECTRE.MENU.Text.AIRDROP.Cost = "Print Airdrop Types & Costs"
SPECTRE.MENU.Text.STRIKE.Cost = string.format("Strike Team Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.STRIKE)

SPECTRE.MENU.Text.Reports.Instructions.AIRDROPCOST = {
  "Airdrop Group {Type} Costs:",
  "================================",
  "",
  "Usage: /airdrop artillery",
  string.format("Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.ARTILLERY),
  "Usage: /airdrop ifv",
  string.format("Infantry Fighting Vehicle Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IFV),
  "Usage: /airdrop tank",
  string.format("Tank Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.TANK),
  "Usage: /airdrop aaa",
  string.format("Anti-Aircraft Artillery Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.AAA),
  "Usage: /airdrop irsam",
  string.format("IR SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.IRSAM),
  "Usage: /airdrop rdrsam",
  string.format("Radar SAM Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.RDRSAM),
  "Usage: /airdrop ewr",
  string.format("Early Warning Radar Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.EWR),
  "Usage: /airdrop supply",
  string.format("Supply Cost: %d Points", SPECTRE.REWARDS.Config.PointCost.AIRDROP.SUPPLY),
}





-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **SPAWNER**
--
-- *Automated Spawning System for SPECTRE*
--
-- The SPAWNER class is a sophisticated component of the SPECTRE system, dedicated to the automated
-- spawning of dynamic simulation units. It serves as a centralized access point for all functionalities
-- related to the dynamic generation, placement, and spawning of units within a simulated environment.
--
-- Features:
--
--   - **Dynamic Generation of DCS Units**:
--      Efficiently generates units based on pre-defined or dynamic parameters.
--   - **Intelligent Integration with Existing Elements**:
--      Seamlessly integrates with existing elements in the simulation,
--      such as ground and sea buildings, units, and objects,
--      ensuring a cohesive and uninterrupted simulation experience.
--   - **Non-Blocking Design**:
--      Carefully engineered to avoid stalling or interfering with the main game thread,
--      maintaining optimal performance and stability of the simulation.
--   - **Configurable Generation Parameters**:
--      Offers a high level of customization through a configuration table,
--      allowing users to tailor the spawning process to specific needs and scenarios.
--
-- @module SPAWNER
-- @extends SPECTRE

--- 1 - Dynamic Spawner.
-- ===
--
-- *All Functions associated with Dynamic Spawner operations.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- SPECTRE.SPAWNER.
--
-- *Core Module for Dynamic Unit Management in SPECTRE System*
--
-- This module plays a pivotal role in the SPECTRE system, providing advanced capabilities for
-- dynamically generating, positioning, and deploying units within the simulation. It is crafted to
-- offer a balance between automation and user-defined control, facilitating a realistic and
-- dynamic simulation environment.
--
-- Responsibilities:
--
--   - **Automated Unit Generation**:
--
--       Automates the creation of units, leveraging both pre-set and adaptable generation logic.
--
--   - **Smart Placement and Positioning**:
--
--       Ensures units are placed in suitable and realistic locations,
--       enhancing the authenticity of the simulation environment.
--
--   - **Customizable Spawning Mechanics**:
--
--       Empowers users with tools to customize various aspects of the spawning process,
--       aligning with diverse simulation requirements.
--
--   - **Seamless Simulation Integration**:
--
--       Designed to integrate flawlessly with the broader SPECTRE system,
--       contributing to a coherent and immersive simulation experience.
--
-- @field #SPAWNER
SPECTRE.SPAWNER = {}

--- Create a new SPAWNER instance.
--
-- This function is responsible for constructing a new instance of the SPAWNER class within the SPECTRE framework.
-- It initializes the SPAWNER with base properties and configures it with a randomized seed for various operations.
-- This setup is essential for the SPAWNER's functionality, which may include generating game entities or managing dynamic events.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:New()
  local self=BASE:Inherit(self, SPECTRE:New())
  local _randseedCount = SPECTRE.UTILS.generateNominal(self._randSeedNom, self._randSeedMin, self._randSeedMax, self._randSeedNudge)
  for _seedC = 1 , _randseedCount, 1 do
    math.random()
  end
  return self
end
--- Initiate a lag reduction process at mission start.
--
-- This function serves as a preemptive measure to reduce server lag during spawns. It works by spawning and
-- immediately deleting one instance of each Type Template Group found in the SPAWNER. This process helps cache
-- these groups on the server, mitigating potential lag or hangs that can occur when SPAWNER spawns units faster
-- than the game can cache them. This function should be used only at the start of a mission to optimize performance
-- during subsequent spawn operations.
--
-- @param #SPAWNER self
function SPECTRE.SPAWNER:LagBuster()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:LagBuster | START ---------------- |")
  for _type, _typeObj in pairs(self.TEMPLATETYPES_) do
    local _spawns = {}
    for _, _groupName in ipairs(_typeObj.GroupNames) do
      _spawns[#_spawns + 1] = SPAWN:NewWithAlias(_groupName, _groupName .. "_LagBuster"):Spawn()
    end
    for _, _group in ipairs(_spawns) do
      _group:Destroy(false)
    end
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:LagBuster | END ---------------- |")
end


-- Random seed settings for generation processes within the SPAWNER system.

--- The minimum value for the random seed.
SPECTRE.SPAWNER._randSeedMin = 500
--- The maximum value for the random seed.
SPECTRE.SPAWNER._randSeedMax = 2000
-- The nominal (default) value for the random seed.
SPECTRE.SPAWNER._randSeedNom = 2000
-- A factor to introduce variability in the random seed generation.
SPECTRE.SPAWNER._randSeedNudge = 0.7

-- Basic configurations and state indicators for the SPAWNER system.

--- Sets the index reference for the SPAWNER class.
SPECTRE.SPAWNER.__index = SPECTRE.SPAWNER
--- Scheduler for managing spawn operations.
SPECTRE.SPAWNER.MasterSpawnScheduler = {}
--- Indicates if the generation process is complete.
SPECTRE.SPAWNER.GenerationComplete = false
--- Indicates if the generation process is currently in progress.
SPECTRE.SPAWNER.GenerationInProgress = false
--- A counter to keep track of spawned entities.
SPECTRE.SPAWNER.COUNTER = 1

-- Prefix and coalition/country settings for spawned units.

--- A prefix string for spawned entities.
SPECTRE.SPAWNER.PREFIX = ""
--- Default coalition for spawned units.
SPECTRE.SPAWNER.spawnCoalition = ""
--- Default country for spawned units.
SPECTRE.SPAWNER.spawnCountry = ""
--- A prefix string for spawner templates to detect.
SPECTRE.SPAWNER.TemplatePrefix = ""
-- Type management containers for SPAWNER.

--- Container for all types of entities to be spawned.
SPECTRE.SPAWNER.AllTypes = {}
--- Manipulatable container for entity types.
SPECTRE.SPAWNER.AllTypesManip_ = {}
--- Container for types with spawn limits.
SPECTRE.SPAWNER.LimitedTypes = {}
--- Container for types without spawn limits.
SPECTRE.SPAWNER.NonLimitedTypes = {}

-- Spawn count settings.

--- Minimum count for total types.
SPECTRE.SPAWNER._totalTypesMin = 0
--- Maximum count for total types.
SPECTRE.SPAWNER._totalTypesMax = 0
--- Base delay in seconds between spawns.
SPECTRE.SPAWNER._spawnDelay = 6
--- Variance factor for spawn delay.
SPECTRE.SPAWNER.spawnDelayVariance = 0.5
--- Nominal count for total types.
SPECTRE.SPAWNER._totalTypesNominal = 0


-- Debugging configurations.

--- Debug message level.
SPECTRE.SPAWNER.DebugMessages = 0
--- Player ID for debug menu display.
SPECTRE.SPAWNER.DebugMenuPlayer = 0
--- Logs for debugging purposes.
SPECTRE.SPAWNER.BenchmarkLog = {}
--- Indicates whether benchmarking is enabled.
SPECTRE.SPAWNER.Benchmark = false

--- List of surface types where spawning is prohibited.
SPECTRE.SPAWNER.NoGoSurface = {
  "WATER",        -- Surface type: Water
  "SHALLOW_WATER",-- Surface type: Shallow Water
  "RUNWAY",       -- Surface type: Runway
  "nil",          -- Represents an undefined or non-existent surface type
}

--- Counter for co-routines within the SPAWNER system.
-- Co-routines are functions that can be paused and resumed for complex tasks.
SPECTRE.SPAWNER.Co_Counter = 0

--- Indicates if persistence is enabled for the SPAWNER system.
-- When true, SPAWNER maintains state across game sessions or events.
SPECTRE.SPAWNER._persistence = false

--- Configurations for spawn count adjustments.
SPECTRE.SPAWNER.nudgeFactor =  0.5  -- Factor for fine-tuning spawn counts.
SPECTRE.SPAWNER.min =  0            -- Minimum spawn count.
SPECTRE.SPAWNER.max = 0             -- Maximum spawn count.
SPECTRE.SPAWNER.nominal = 0         -- Default spawn count.

--- Container for additional types or groups in a specific zone.
SPECTRE.SPAWNER._queueExtraTypeToGroupsZONE_A = {}

--- Configurations for zone sizes within the SPAWNER system.
SPECTRE.SPAWNER.ZoneSize = {
  Main = {
    -- Minimum size of the main zone.
    min = 0,
    -- Maximum size of the main zone.
    max = 0,
    -- Default size of the main zone.
    nominal = 0,
    -- Adjustment factor for the main zone size.
    nudgeFactor = 0,
    -- Actual calculated size of the main zone.
    Actual = 0
  },
  Sub = {
    -- Minimum size of subzones.
    min = 0,
    -- Maximum size of subzones.
    max = 0,
    -- Default size of subzones.
    nominal = 0,
    -- Adjustment factor for subzone sizes.
    nudgeFactor = 0,
    -- Actual calculated size of subzones.
    Actual = 0
  }
}

--- Container for restricted zones within SPAWNER.
SPECTRE.SPAWNER.ZonesRestricted = {}

--- Container for generated subcircles within zones.
SPECTRE.SPAWNER.generatedSubCircles = {}

--- Vector position (Vec2) representing the main point or center for a zone.
SPECTRE.SPAWNER.ZoneMainVec2 = {}

--- Container for storing names of zones managed by SPAWNER.
SPECTRE.SPAWNER.ZoneNames = {}

--- persistenceFiles.
-- Persistence file information for SPAWNER.
-- Contains file paths and load status for persisted data.
SPECTRE.SPAWNER._persistenceFiles = {
  SPAWNER = {name = "", loaded = false},           -- File path and load status for SPAWNER.
  TEMPLATETYPES_ = {name = "", loaded = false},    -- File path and load status for template types.
  ZONES = {name = "", loaded = false}              -- File path and load status for zones.
}

--- Zones.
-- Zone configurations within SPAWNER.
-- Contains definitions for main, sub, and restricted zones used in spawning.
SPECTRE.SPAWNER.Zones = {
  Main = {},         -- Main zones for spawning.
  Sub = {},          -- Subzones for detailed spawn management.
  Restricted = {}    -- Zones where spawning is restricted or controlled.
}

--- 2 - typeENUMS.
-- ===
--
-- *All typeENUMS.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- typeENUMS.
--
-- This table provides a mapping of enumerated type names to their descriptive string representation in the `SPECTRE.SPAWNER` system.
-- It serves as a dictionary for type names, ensuring consistent naming and easy reference across the system.
--
-- @field #SPAWNER.typeENUMS
SPECTRE.SPAWNER.typeENUMS =  {}
---.
SPECTRE.SPAWNER.typeENUMS.Ships = "Ships"
---.
SPECTRE.SPAWNER.typeENUMS.UnarmedShips = "Unarmed ships"
---.
SPECTRE.SPAWNER.typeENUMS.ArmedShips = "Armed ships"
---.
SPECTRE.SPAWNER.typeENUMS.LightArmedShips = "Light armed ships"
---.
SPECTRE.SPAWNER.typeENUMS.HeavyArmedShips = "Heavy armed ships"
---.
SPECTRE.SPAWNER.typeENUMS.Corvettes = "Corvettes"
---.
SPECTRE.SPAWNER.typeENUMS.Frigates = "Frigates"
---.
SPECTRE.SPAWNER.typeENUMS.Destroyers = "Destroyers"
---.
SPECTRE.SPAWNER.typeENUMS.Cruisers = "Cruisers"
---.
SPECTRE.SPAWNER.typeENUMS.AircraftCarriers = "Aircraft Carriers"
---.
SPECTRE.SPAWNER.typeENUMS.GroundUnits = "Ground Units"
---.
SPECTRE.SPAWNER.typeENUMS.Infantry = "Infantry"
---.
SPECTRE.SPAWNER.typeENUMS.LightArmoredUnits = "LightArmoredUnits"
---.
SPECTRE.SPAWNER.typeENUMS.IFV = "IFV"
---.
SPECTRE.SPAWNER.typeENUMS.APC = "APC"
---.
SPECTRE.SPAWNER.typeENUMS.Artillery = "Artillery"
---.
SPECTRE.SPAWNER.typeENUMS.MLRS = "MLRS"
---.
SPECTRE.SPAWNER.typeENUMS.HeavyArmoredUnits = "HeavyArmoredUnits"
---.
SPECTRE.SPAWNER.typeENUMS.ModernTanks = "Modern Tanks"
---.
SPECTRE.SPAWNER.typeENUMS.OldTanks = "Old Tanks"
---.
SPECTRE.SPAWNER.typeENUMS.Tanks = "Tanks"
---.
SPECTRE.SPAWNER.typeENUMS.Buildings = "Buildings"
---.
SPECTRE.SPAWNER.typeENUMS.Fortifications = "Fortifications"
---.
SPECTRE.SPAWNER.typeENUMS.GroundVehicles = "Ground vehicles"
---.
SPECTRE.SPAWNER.typeENUMS.AAA = "AAA"
---.
SPECTRE.SPAWNER.typeENUMS.AA_flak = "AA_flak"
---.
SPECTRE.SPAWNER.typeENUMS.StaticAAA = "Static AAA"
---.
SPECTRE.SPAWNER.typeENUMS.MobileAAA = "Mobile AAA"
---.
SPECTRE.SPAWNER.typeENUMS.EWR = "EWR"
---.
SPECTRE.SPAWNER.typeENUMS.UnarmedVehicles = "Unarmed vehicles"
---.
SPECTRE.SPAWNER.typeENUMS.Cars = "Cars"
---.
SPECTRE.SPAWNER.typeENUMS.Trucks = "Trucks"
---.
SPECTRE.SPAWNER.typeENUMS.SamElements = "SAM elements"
---.
SPECTRE.SPAWNER.typeENUMS.IRGuidedSam = "IR Guided SAM"
---.
SPECTRE.SPAWNER.typeENUMS.SRsam = "SR SAM"
---.
SPECTRE.SPAWNER.typeENUMS.MRsam = "MR SAM"
---.
SPECTRE.SPAWNER.typeENUMS.LRsam = "LR SAM"
---.
SPECTRE.SPAWNER.typeENUMS.ArmedGroundUnits = "Armed ground units"
---.
SPECTRE.SPAWNER.typeENUMS.MANPADS = "MANPADS"

--- 4 - Config.
-- ===
--
-- *All Config associated with Dynamic Spawner operations.*
--
-- ===
-- @section SPECTRE.SPAWNER


--- Config.
-- Configuration settings for the `SPECTRE.SPAWNER`.
-- This section defines various parameters used by the spawner system.
SPECTRE.SPAWNER.Config = {
  operationLimit = 150,           -- Number of operations the spawner can perform for an action.
  operationInterval = 0,          -- Interval in seconds between operations.
  LimitedSpawnStrings = {},       -- Table of strings limiting spawn conditions.
  Types = {}                      -- Table specifying different types of spawns.
}

--- 5 - Enable Toggles.
-- ===
--
-- *All Functions associated with Enable Toggles.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Enables or disables the benchmarking mode for the SPAWNER instance.
--
-- This function serves to toggle the benchmarking mode in a SPAWNER instance. Benchmarking mode can be used to measure
-- performance or other metrics within the SPAWNER's operations. When enabled, the SPAWNER instance may track additional
-- data or operate differently to facilitate benchmarking.
--
-- @param #SPAWNER self
-- @param enabled Boolean value indicating whether to enable (true) or disable (false) the benchmarking mode.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_Benchmark(enabled)
  self.Benchmark = enabled or false
  return self
end

--- Enables persistence for a SPECTRE.SPAWNER object.
--
-- This function activates persistence for the SPAWNER instance, allowing it to save its state across sessions.
-- It sets up the necessary file paths for storing the spawner's data, including templates and zone information, under a unique spawner name.
-- This capability is essential for maintaining continuity in game scenarios, ensuring that the state of the SPAWNER can be retrieved and
-- restored accurately in subsequent sessions.
--
-- @param #SPAWNER self
-- @param spawnerName A unique name used as the identifier for saving the spawner object. This name is also used as the filename in the persistence database.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:enablePersistence(spawnerName)
  -- Debug Information
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:enablePersistence | Enabling persistence for spawner: " .. spawnerName)

  -- Activate persistence
  self._persistence = true

  -- Set paths for saving different components of the spawner
  self._persistenceFiles.SPAWNER.name = SPECTRE._persistenceLocations.SPAWNER.path .. spawnerName .. "/" .. spawnerName .. ".lua"
  self._persistenceFiles.TEMPLATETYPES_.name = SPECTRE._persistenceLocations.SPAWNER.path .. spawnerName .. "/TYPETEMPLATES_/TEMPLATETYPES_.lua"
  self._persistenceFiles.ZONES.name = SPECTRE._persistenceLocations.SPAWNER.path .. spawnerName .. "/ZONES/ZONES.lua"

  -- Debug output for constructed paths
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:enablePersistence | Paths:")
  SPECTRE.UTILS.debugInfo("  SPAWNER:        " .. self._persistenceFiles.SPAWNER.name)
  SPECTRE.UTILS.debugInfo("  TEMPLATETYPES_: " .. self._persistenceFiles.TEMPLATETYPES_.name)
  SPECTRE.UTILS.debugInfo("  ZONES:          " .. self._persistenceFiles.ZONES.name)

  return self
end

--- Resets the persistence settings of the SPECTRE spawner system.
--
-- This function disables persistence for the SPAWNER instance by setting the `_persistence` attribute to `false`. It also resets the filenames
-- and loaded statuses within the `_persistenceFiles` attribute for SPAWNER and TEMPLATETYPES_ objects. This is essential for scenarios
-- where persistence needs to be cleared or reconfigured, ensuring that the SPAWNER starts afresh without carrying over any previous state
-- information.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:resetPersistence()
  self._persistence = false
  self._persistenceFiles = {
    SPAWNER         = {name = "", loaded = false},
    TEMPLATETYPES_  = {name = "", loaded = false},
  }
  return self
end

--- 6 - Setup.
-- ===
--
-- *All functions associated with Setup Operations*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Set the coalition for the SPAWNER.
--
-- This function assigns a specific coalition to the SPAWNER instance. The specified coalition
-- is used for all spawn operations conducted by this SPAWNER. This setting is essential for
-- defining the allegiance of the spawned units.
--
-- @param #SPAWNER self
-- @param coalition The coalition to be assigned to the SPAWNER.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setCoalition(coalition)
  self.spawnCoalition = coalition
  return self
end

--- Set the country for the SPAWNER.
--
-- This function assigns a specific country to the SPAWNER instance. The specified country
-- is used for all spawn operations conducted by this SPAWNER. This setting is crucial for
-- defining the nationality of the spawned units.
--
-- @param #SPAWNER self
-- @param country The country to be assigned to the SPAWNER.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setCountry(country)
  self.spawnCountry = country
  return self
end

--- Sets a name prefix for all spawned groups by the SPAWNER instance.
--
-- This function assigns a specific prefix to be added to the names of all groups spawned by the SPAWNER instance.
-- The prefix helps in identifying or categorizing groups based on different criteria or operational contexts within the game environment.
-- This can be particularly useful for tracking or managing groups dynamically during gameplay.
--
-- @param #SPAWNER self
-- @param PREFIX The prefix string to be added to all spawned GROUP names.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setNamePrefix(PREFIX)
  self.PREFIX = PREFIX or ""
  return self
end

--- Configures the zones for the SPECTRE.SPAWNER class.
--
-- This function is pivotal in setting up the operational zones for the SPAWNER instance. It defines the main zone, optional subzones,
-- and restricted zones where spawning is not permitted. The function ensures that the SPAWNER operates within designated areas,
-- respecting any constraints imposed by no-go zones. This configuration is critical for maintaining the spatial integrity and strategic
-- dynamics of spawned entities within the game environment.
--
-- @param #SPAWNER self
-- @param MainZone The name of the main zone for the spawner.
-- @param SubZones (Optional) A list of names for all subzones. These are used for weighting spawn probabilities or distributions.
-- @param NoGoZones (Optional) A list of names for all zones where spawning is explicitly prohibited.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:SetZones(MainZone, SubZones, NoGoZones)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZones |  ---------------- |")
  if self.Benchmark == true then
    self.BenchmarkLog.SetZones = {Time = {},}
    self.BenchmarkLog.SetZones.Time.start = os.clock()
  end
  -- Debug Information
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZones | -------------------------------------------------------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZones | MainZone: " .. MainZone)

  -- Initialize optional tables if they aren't provided
  SubZones = SubZones or {}
  NoGoZones = NoGoZones or {}

  -- Debug output for subzones and restricted zones
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZones | SubZones: ", table.concat(SubZones, ", "))
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZones | NoGoZones: ", table.concat(NoGoZones, ", "))

  -- Set the main zone
  self.Zones.Main = self.Zone_:New(MainZone)

  -- Set the subzones
  for _, zoneName in ipairs(SubZones) do
    self.Zones.Sub[zoneName] = self.Zone_:New(zoneName)
  end

  -- Compute weights for zones
  self:weightZones()

  -- Set the restricted zones
  self.Zones.Restricted = NoGoZones
  if self.Benchmark == true then
    self.BenchmarkLog.SetZones.Time.stop = os.clock()
  end

  return self
end

--- Imports template settings into the SPAWNER instance.
--
-- This function takes a template object and applies its settings to the SPAWNER instance. It effectively updates the SPAWNER's configuration
-- based on the provided template, allowing for dynamic customization or reconfiguration of the SPAWNER's behavior and attributes. This can
-- be particularly useful for initializing the SPAWNER with predefined settings or for changing its operational parameters on the fly.
--
-- @param #SPAWNER self
-- @param template_ The template object containing settings to be imported into the SPAWNER instance.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:ImportTemplate(template_)
  self = SPECTRE.UTILS.setTableValues(template_, self)
  return self
end

--- Detects and matches groups to templates based on a given prefix.
--
-- This function scans through groups in the game environment, matching them to predefined templates based on their names, which contain the specified prefix.
-- It determines the template type with the highest priority for each matched group. The function also respects persistence settings, either loading existing templates
-- or creating new ones based on detection results. An optional 'force' parameter can override persistence checks to ensure fresh detection.
--
-- @param #SPAWNER self
-- @param TemplatePrefix The prefix used to match group names against predefined templates.
-- @param force (Optional) Boolean flag to force detection, ignoring existing persistence files.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:DetectTypeTemplates(TemplatePrefix, force)
  if self.Benchmark == true then
    self.BenchmarkLog.DetectTypeTemplates = {Time = {},}
    self.BenchmarkLog.DetectTypeTemplates.Time.start = os.clock()
  end
  -- Default force to false if not provided
  force = force or false
  -- Debug information
  SPECTRE.UTILS.debugInfo("Detecting type templates | Prefix: " .. TemplatePrefix .. " | Force: ", force)

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DetectTypeTemplates | SearchString: " .. TemplatePrefix .. " | Force: ", force)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DetectTypeTemplates | PERSISTENCE:  ", self._persistence)

  self.TemplatePrefix = TemplatePrefix

  self.TEMPLATETYPES_ = SPECTRE.BRAIN.checkAndPersist(
    self._persistenceFiles.TEMPLATETYPES_.name,
    force,
    self.TEMPLATETYPES_,
    self._persistence,
    function(_Object)
      return self:_detectHighestAttributes(TemplatePrefix, _Object)
    end
  )
  if self.Benchmark == true then
    self.BenchmarkLog.DetectTypeTemplates.Time.stop = os.clock()
  end
  return self
end

--- Set the maximum amount and usage limitation for a specific template type.
--
-- This function updates the maximum value and usage limitation for a given template type in the `TEMPLATETYPES_` table
-- of the `SPECTRE.SPAWNER` object. It sets the maximum value for the type, and optionally, a limitation flag that determines
-- whether the spawner should restrict the use of this type when the configuration mathematics does not add up.
-- This is particularly useful for hard-limiting certain types, like AAA/SAM spawns, to maintain gameplay balance.
--
-- @param #SPAWNER self
-- @param typeENUM The type enumeration key for the template type.
-- @param max (Optional) The maximum value for the template type. Defaults to `9999` if not provided.
-- @param limited (Optional) A boolean flag indicating whether to limit the use of this type. Defaults to `false`. If set to `true`, the spawner will not use these types as overflow selection.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setTypeAmounts(typeENUM, max, limited)
  -- Default values for min and max
  max = max or 9999
  limited = limited or false
  -- Set values for the specified typeENUM
  self.TEMPLATETYPES_[typeENUM].Max = max
  self.TEMPLATETYPES_[typeENUM].limited = limited

  -- Return self for potential method chaining
  return self
end

--- 7 - Generation.
-- ===
--
-- *All Functions associated with Generation operations.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Adds an extra type with a specified number to the SPAWNER groups.
--
-- This function is tasked with enhancing the SPAWNER groups by adding an additional type and its quantity.
-- It updates the main spawn settings to include the new type and recalculates the total number of extra types and units.
-- These adjustments are then applied to all sub-zones, ensuring a unified and coherent configuration across different zones.
-- This function is pivotal for dynamically customizing the composition of spawned groups in the game environment.
--
-- @param #SPAWNER self
-- @param _TYPE The type of entity or characteristic to be added.
-- @param _numTYPE The number of entities or quantity of the specified type to add.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:AddExtraTypeToGroups(_TYPE, _numTYPE)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroups |  ---------------- |")
  local setting = self.Zones.Main.SpawnAmountSettings
  if not setting.ExtraTypesToGroups[_TYPE] then setting.ExtraTypesToGroups[_TYPE] = 0 end
  setting.ExtraTypesToGroups[_TYPE] = setting.ExtraTypesToGroups[_TYPE] + _numTYPE
  setting.numExtraTypes = SPECTRE.UTILS.sumTable(setting.ExtraTypesToGroups)
  setting.numExtraUnits = 0
  for _t, _tv in pairs(setting.ExtraTypesToGroups) do
    setting.numExtraUnits = setting.numExtraUnits + _tv
  end
  --  setting.numExtraUnits = setting.numExtraUnits + _numTYPE
  for _zoneName, _zoneObject in pairs (self.Zones.Sub) do
    local settingSub = _zoneObject.SpawnAmountSettings
    if not settingSub.ExtraTypesToGroups[_TYPE] then settingSub.ExtraTypesToGroups[_TYPE] = 0 end
    settingSub.ExtraTypesToGroups[_TYPE] = setting.ExtraTypesToGroups[_TYPE]
    settingSub.numExtraTypes = setting.numExtraTypes
    settingSub.numExtraUnits = setting.numExtraUnits
  end
  return self
end

--- Repeatedly apply the `_RollUpdates` method.
--
-- This function calls the `_RollUpdates` method multiple times, based on the value of
-- `self.Zones.Main.SpawnAmountSettings.Generated.NudgeRecip`. The function's purpose is to ensure that
-- updates are applied consistently across the spawner system. Debug information is output for each iteration
-- if `SPECTRE.DebugEnabled` is set to 1, providing details on the operation and iteration count.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Jiggle()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Jiggle | ---------------")
  if self.Benchmark == true then
    self.BenchmarkLog.Jiggle = {Time = {},}
    self.BenchmarkLog.Jiggle.Time.start = os.clock()
  end
  -- Debug: Print the total spawns and number of subzones
  SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:Jiggle ------------------------------------- | SPAWNS TOTAL: %d | SPAWN DIVS: %d", self.Zones.Main.SpawnAmountSettings.Generated.Actual, self.Zones.Main.numSubZones))

  -- Repeatedly apply the `_RollUpdates` method
  for _ = 1, self.Zones.Main.SpawnAmountSettings.Generated.NudgeRecip do
    -- Debug: Print the current cycle number
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:Jiggle ------------------------------------- | CYCLE   :  %d / %d", _, self.Zones.Main.SpawnAmountSettings.Generated.NudgeRecip))
    self:_RollUpdates()
  end
  if self.Benchmark == true then
    self.BenchmarkLog.Jiggle.Time.stop = os.clock()
  end
  -- Return self for potential method chaining
  return self
end



--- Set spawn amounts for both main and subzones.
--
-- This function configures the spawn amounts for the main zone and its subzones. It uses the provided nominal,
-- minimum, maximum, and nudge factor values to calculate and set these amounts. The function ensures the calculated
-- values are within the specified limits and applies them to each subzone. It also employs a 'jiggle' process to
-- introduce randomness into the spawn amounts. Debug information, including configuration details and calculated values,
-- is output if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled.
--
-- @param #SPAWNER self
-- @param nominal The nominal spawn amount.
-- @param min The minimum spawn amount, with a default of 0 if not provided.
-- @param max The maximum spawn amount, defaults to the nominal value if not provided.
-- @param nudgeFactor The factor to introduce randomness, defaults to 0.5 if not provided.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setSpawnAmounts(nominal, min, max, nudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:setSpawnAmounts | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.setSpawnAmounts = {Time = {},}
    self.BenchmarkLog.setSpawnAmounts.Time.start = os.clock()
  end


  -- Set default values for arguments if not provided
  nudgeFactor = nudgeFactor or 0.5
  min = min or 0
  max = max or nominal

  -- Debug header
  SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:setSpawnAmounts | CONFIG | NOMINAL: %d | MIN: %d | MAX: %d | NUDGE FACTOR: %f", nominal, min, max, nudgeFactor))

  -- Calculate main zone values
  self.Zones.Main.numSubZones = SPECTRE.UTILS.sumTable(self.Zones.Sub)
  self.Zones.Main:setSpawnAmounts(nominal, min, max, nudgeFactor):RollSpawnAmounts()

  -- Calculate spawn configurations for subzones
  local avgDistribution = self.Zones.Main.SpawnAmountSettings.Generated.Actual / self.Zones.Main.numSubZones
  local spawnsMax = math.min(avgDistribution + avgDistribution * self.Zones.Main.SpawnAmountSettings.Generated.Ratio.Max,
    self.Zones.Main.SpawnAmountSettings.Generated.Max / self.Zones.Main.numSubZones)
  local spawnsMin = math.max(avgDistribution - avgDistribution * self.Zones.Main.SpawnAmountSettings.Generated.Ratio.Min,
    self.Zones.Main.SpawnAmountSettings.Generated.Min / self.Zones.Main.numSubZones)

  -- Debug information for Zone configurations
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneCFG(self.Zones.Main)
    SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(self.Zones.Main)
  end

  -- Set spawn amounts for each subzone
  for _, zoneObject_ in pairs(self.Zones.Sub) do
    zoneObject_:setSpawnAmounts(avgDistribution, spawnsMin, spawnsMax, SPECTRE.UTILS.generateNudge(self.Zones.Main.SpawnAmountSettings.Generated.NudgeFactor)):RollSpawnAmounts()
  end

  self:Jiggle()

  if self.Benchmark == true then
    self.BenchmarkLog.setSpawnAmounts.Time.stop = os.clock()
  end
  return self
end

--- Calculate and assign weight to the main zone and its subzones.
--
-- This function is responsible for computing and assigning weights to both the main zone and its subzones
-- within the SPAWNER system. The weight of each subzone is calculated based on its area relative to the main zone's area.
-- After determining the weights for all subzones, the main zone's weight is adjusted accordingly to ensure
-- that the total of all weights equals 1. This ensures a balanced distribution of importance or influence among
-- the zones. Debug information related to the calculated weights and adjustments is output if `SPECTRE.DebugEnabled`
-- is set to 1. Benchmark timing is recorded if enabled.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:weightZones()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:weightZones | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.weightZones = {Time = {},}
    self.BenchmarkLog.weightZones.Time.start = os.clock()
  end


  local mainZone = self.Zones.Main
  local subZones = self.Zones.Sub
  local totalWeight = 0

  -- Calculate weights for each subzone
  for _, zoneObject_ in pairs(subZones) do
    zoneObject_.weight = zoneObject_.area / mainZone.area
    totalWeight = totalWeight + zoneObject_.weight
  end

  -- Adjust main zone's weight
  mainZone.weight = 1 - totalWeight

  -- Debug information for zone weights
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneWeights(mainZone, subZones)
  end
  if self.Benchmark == true then
    self.BenchmarkLog.weightZones.Time.stop = os.clock()
  end
  return self
end

--- Calculate and assign group settings for each subzone based on the specified group sizes.
--
-- This function determines the number and configuration of groups to be spawned in each subzone.
-- It calculates the number of groups for different sizes based on the total spawn amount and specified
-- group sizes. Each group is then configured with specific spacing settings, and a new group settings
-- object is created for each group. The function provides detailed configuration for group distribution
-- and layout within each subzone. Debug information regarding the group configurations and sizes is
-- output if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:RollSpawnGroupSizes()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:RollSpawnGroupSizes | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.RollSpawnGroupSizes = {Time = {},}
    self.BenchmarkLog.RollSpawnGroupSizes.Time.start = os.clock()
  end

  -- Debug header
  SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(self.Zones.Main)
  local subZones = self.Zones.Sub

  for zoneName_, zoneObject_ in pairs(subZones) do
    --SPECTRE.UTILS.DEBUGoutput.infoSubzoneGroupSizes(zoneObject_)

    local groupSizes_ = zoneObject_.GroupSizes
    local SpacingSettings_ = zoneObject_.SpacingSettings
    local numTypesZone = zoneObject_.SpawnAmountSettings.Generated.Actual

    for i = 1, #groupSizes_ do
      local size = groupSizes_[i]
      local numGroupSize = math.floor(numTypesZone / size)

      if numGroupSize > 0 then
        numTypesZone = numTypesZone - (numGroupSize * size)
        local index_ = SPECTRE.UTILS.sumTable(zoneObject_.GroupSettings) + 1

        zoneObject_.GroupSettings[index_] = self:_createGroupSettings(size, numGroupSize, SpacingSettings_)

      end
    end
    SPECTRE.UTILS.DEBUGoutput.infoGroupSettings(zoneObject_)
  end
  if self.Benchmark == true then
    self.BenchmarkLog.RollSpawnGroupSizes.Time.stop = os.clock()
  end
  return self
end

--- Sets the spacing configurations for a specified group size for all zones in the spawner.
--
-- This function is used to configure the spacing between groups and units within those groups
-- for a specified group size across all subzones in the SPAWNER system. It allows setting minimum
-- and maximum separations for both groups and individual units within groups. If specific values
-- for these parameters are not provided, the function defaults to using values from
-- `SPECTRE.SPAWNER.SpacingSettings_`. This configuration is crucial for maintaining organized
-- and strategically placed spawns within the game environment.
--
-- @param #SPAWNER self
-- @param groupSize The size of the group for which spacing is being configured.
-- @param groupMinSep (Optional) The minimum separation between groups, default value used if not specified.
-- @param groupMaxSep (Optional) The maximum separation between groups, default value used if not specified.
-- @param unitMinSep (Optional) The minimum separation between units within a group, default value used if not specified.
-- @param unitMaxSep (Optional) The maximum separation between units within a group, default value used if not specified.
-- @param distFromBuildings (Optional) The minimum distance from buildings, defaulting to 20 if not specified.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setGroupSpacing(groupSize, groupMinSep, groupMaxSep, unitMinSep, unitMaxSep , distFromBuildings)
  for zoneName_, zoneObject_ in pairs(self.Zones.Sub) do
    zoneObject_:setGroupSpacing(groupSize, groupMinSep, groupMaxSep, unitMinSep, unitMaxSep , distFromBuildings)
  end
  return self
end
--- Set the priority of group sizes for the main zone and its subzones.
--
-- This function assigns a set of group size priorities to the main zone and all subzones within the SPAWNER system.
-- The group size priority is defined by an array where each element represents a group size and its index indicates
-- its priority, with a lower index indicating a higher priority. This configuration determines the order in which
-- different group sizes are considered during the spawning process.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param groupSizePrio An array defining the group sizes and their priorities, e.g., `{[1] = 4, [2] = 3, [3] = 2, [4] = 1}`.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setGroupSizePrio(groupSizePrio)
  self.Zones.Main.GroupSizes = groupSizePrio
  for zoneName_, zoneObject_ in pairs(self.Zones.Sub) do
    zoneObject_.GroupSizes = groupSizePrio
  end
  return self
end

--- Roll and assign group types for each subzone.
--
-- This function initiates the process of generating and assigning group types for each subzone within the SPAWNER system.
-- It starts by seeding types using the `_seedTypes` method. Then, for each subzone, it generates group types and templates
-- by calling `_generateGroupTypes` and `_generateGroupTemplates`. This comprehensive process ensures that each subzone
-- is populated with appropriately sized and varied groups, according to the SPAWNER's configuration. Debug information
-- is output for each step of the process if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled,
-- providing performance metrics for the group rolling process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:RollSpawnGroupTypes()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:RollSpawnGroupTypes | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.RollSpawnGroupTypes = {Time = {},}
    self.BenchmarkLog.RollSpawnGroupTypes.Time.start = os.clock()
  end

  self:_seedTypes()
  for _zoneName, _zoneObject in pairs(self.Zones.Sub) do
    self:_generateGroupTypes(_zoneObject):_generateGroupTemplates(_zoneObject)
  end

  if self.Benchmark == true then
    self.BenchmarkLog.RollSpawnGroupTypes.Time.stop = os.clock()
  end
  return self
end

--- Determine and set placement for groups and units within each subzone.
--
-- This function handles the placement of groups and units in each subzone of the SPAWNER system.
-- It iterates through all subzones, setting vector positions (`Vec2`) for both group centers and
-- individual unit templates within those groups. The process ensures that each group and unit is
-- appropriately positioned within the confines of their respective subzones. Debug information
-- regarding the placement process is output if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing
-- is recorded if enabled, to monitor the efficiency of the placement process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:RollPlacement()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:RollPlacement | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.RollPlacement = {Time = {},}
    self.BenchmarkLog.RollPlacement.Time.start = os.clock()
  end

  for _zoneName, _zoneObject in pairs(self.Zones.Sub) do
    self:Set_Vec2_GroupCenters(_zoneObject):Set_Vec2_UnitTemplates(_zoneObject)
  end

  if self.Benchmark == true then
    self.BenchmarkLog.RollPlacement.Time.stop = os.clock()
  end
  return self
end

--- Set up spawn groups for each subzone.
--
-- This function orchestrates the setup of spawn groups for each subzone within the SPAWNER system.
-- It iterates through all subzones, invoking a setup process for each that configures the groups
-- to be spawned according to the zone's settings. This setup includes determining group sizes, types,
-- and positions. The process is vital for preparing each subzone with the appropriate spawn configurations
-- before actual spawning takes place. Debug information is output for each subzone's setup process if
-- `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled, to assess the efficiency
-- of the setup process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:SetupSpawnGroups()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetupSpawnGroups | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.SetupSpawnGroups = {Time = {},}
    self.BenchmarkLog.SetupSpawnGroups.Time.start = os.clock()
  end
  for _zoneName, _zoneObject in pairs(self.Zones.Sub) do
    self:_SetupSpawnGroups(_zoneObject)
  end
  if self.Benchmark == true then
    self.BenchmarkLog.SetupSpawnGroups.Time.stop = os.clock()
  end
  return self
end

--- Trigger the spawning process for each subzone.
--
-- This function initiates the spawning of groups in each subzone managed by the SPAWNER. It iterates through
-- all subzones, executing a spawn operation for each. This is the final step in the spawn process where the
-- previously configured groups and units are actually instantiated in the game environment. Debug information
-- is output for each subzone's spawn operation if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing
-- is recorded if enabled, to assess the performance of the spawning process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Spawn()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Spawn | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.Spawn = {Time = {},}
    self.BenchmarkLog.Spawn.Time.start = os.clock()
  end
  for _zoneName, _zoneObject in pairs(self.Zones.Sub) do
    self:_Spawn(_zoneObject)
  end
  if self.Benchmark == true then
    self.BenchmarkLog.Spawn.Time.stop = os.clock()
  end
  return self
end

--- Generate and spawn all groups and units as per the SPAWNER configuration.
--
-- This function encompasses the entire generation and spawning process for the SPAWNER. It rolls spawn group types,
-- places groups and units, sets up spawn groups, and finally triggers the spawn. This function is the high-level
-- orchestrator for all SPAWNER operations, ensuring that all necessary steps are taken to generate and spawn units
-- according to the configured settings. Debug information and benchmark timing are output if enabled, providing
-- insights into each step of the generation process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Generate()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Generate | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.Generate = {Time = {},}
    self.BenchmarkLog.Generate.Time.start = os.clock()
  end

  self:RollSpawnGroupTypes()
  self:RollPlacement()
  self:SetupSpawnGroups()
  self:Spawn()

  --SPECTRE.IO.PersistenceToFile("TEST/SPAWNER/" .. os.time() .. "_spawner.lua",self,true)
  
  if self.Benchmark == true then
    self.BenchmarkLog.Generate.Time.stop = os.clock()
  end
  return self
end



--- 8 - Utilities.
-- ===
--
-- *Utilities for dynamic spawns*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Check if a vector position is within a no-go area.
--
-- This function determines whether a given vector position (`possibleVec2`) falls within any restricted
-- areas or surfaces defined in the SPAWNER system. It first checks against no-go surfaces and then against
-- restricted zones. The function returns a flag indicating whether the position is suitable (not within
-- no-go areas) for spawning purposes. Debug information is output detailing the checks and their outcomes
-- if `SPECTRE.DebugEnabled` is set to 1.
--
-- @param #SPAWNER self
-- @param possibleVec2 The vector position to be checked.
-- @param restrictedZones A list of restricted zones to check against.
-- @return flag_goodcoord A boolean flag indicating if the position is outside no-go areas (true if suitable, false otherwise).
function SPECTRE.SPAWNER.checkNOGO(self, possibleVec2, restrictedZones)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:checkNOGO | -------------------------------------------------------------------------")
  local flag_goodcoord = true
  if self:vec2AtNoGoSurface(possibleVec2) then
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.checkNOGO | NOGO SURFACE: TRUE")
    flag_goodcoord = false
  else
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.checkNOGO | NOGO SURFACE: FALSE")
  end
  if flag_goodcoord then
    if self:Vec2inZones(possibleVec2, restrictedZones) then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.checkNOGO | NOGO ZONE: TRUE")
      flag_goodcoord = false
    else
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.checkNOGO | NOGO ZONE: FALSE")
    end
  end
  return flag_goodcoord
end

--- Find and catalog all Object entities within a specified ZONE_RADIUS object.
--
-- This function scans a given ZONE_RADIUS object and identifies various Object entities present within it.
-- It catalogs scenery, static objects, and units, including ground units, structures, and ships.
-- The function creates a table, `ObjectCoords`, which categorizes and stores the coordinates of all detected objects.
-- This data is essential for understanding the zone's composition and for making informed decisions about
-- spawn placements and other operations within the zone.
--
-- Finds the following, then adds them to a table for tracking:
--
--       Object.Category.SCENERY
--       Object.Category.STATIC
--       Object.Category.UNIT
--       Unit.Category.GROUND_UNIT
--       Unit.Category.STRUCTURE
--       Unit.Category.SHIP
--
--        ObjectCoords = {
--                          building = {DATA},
--                          others   = {DATA},
--                          units    = {DATA},
--                       }
--
-- @param _zone ZONE_RADIUS object to be scanned for objects.
-- @return ObjectCoords A table containing the coordinates of all objects detected in the zone, categorized by type.
function SPECTRE.SPAWNER.FindObjectsInZone(_zone)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.FindObjectsInZone | -------------------------------------------------------------------------")
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
        if unit then
          ObjectCoords.units[#ObjectCoords.units + 1] = {x = UNIT:FindByName(unit:getName()):GetPosition().p.x, y = UNIT:FindByName(unit:getName()):GetPosition().p.z}
        end
      end
    end

    -- Scenery Table
    if scanData.SceneryTable then
      for _, scenery in ipairs(scanData.SceneryTable) do
        if scenery then
          ObjectCoords.others[#ObjectCoords.others + 1] = {x = scenery.SceneryObject:getPosition().p.x, y = scenery.SceneryObject:getPosition().p.z}
        end
      end
    end
  end

  return ObjectCoords
end

--- Check if a given vector position is on a no-go surface.
--
-- This function evaluates the surface type at a specified vector position (`vec2`) and determines whether
-- it matches any of the defined no-go surface types in the SPAWNER. If the surface type at the vector position
-- is listed as a no-go surface, the function returns true, indicating that the location is unsuitable for certain
-- operations like spawning. This check is crucial for ensuring that activities such as spawning occur only in
-- appropriate areas.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param vec2 The vector position to be checked.
-- @return boolean true if the vector position is on a no-go surface, false otherwise.
function SPECTRE.SPAWNER:vec2AtNoGoSurface(vec2)
  -- local DEBUG = false or SPECTRE.DebugEnabled
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:vec2AtNoGoSurface | -------------------------------------------------------------------------")
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:vec2AtNoGoSurface | vec2.x : " .. vec2.x .. " | vec2.y : " .. vec2.y)

  local surfaceType = COORDINATE:NewFromVec2(vec2):GetSurfaceType()
  local Surfaces = {
    [1] = "LAND",
    [2] = "SHALLOW_WATER",
    [3] = "WATER",
    [4] = "ROAD",
    [5] = "RUNWAY",
  }
  -- SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:vec2AtNoGoSurface | surfaceType | " ..  Surfaces[surfaceType] or "NOT FOUND")
  for _, noGoSurface in ipairs(self.NoGoSurface) do
    if noGoSurface == Surfaces[surfaceType] then
      --SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:vec2AtNoGoSurface | NOGO SURFACE |")
      return true
    end
  end
  return false
end

--- Determine if a given vector position is within a list of specified zones.
--
-- This function checks whether a provided vector position (`vec2`) falls within any of the zones listed in
-- `zoneList`. The zones are expected to be quadpoint zones defined in the Mission Editor. If the vector
-- position is found within any of these zones, the function returns true, indicating the location is within
-- a restricted or designated area. This check is vital for validating positions against specific spatial
-- constraints or boundaries.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param vec2 The vector position to be checked, in the format `{x = , y = }`.
-- @param zoneList A list of zone names to check against, e.g., `{"name1", "name2", ..., "nameN"}`.
-- @return boolean true if the vector position is within any of the specified zones, false otherwise.
function SPECTRE.SPAWNER:Vec2inZones(vec2,zoneList)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Vec2inZones | -------------------------------------------------------------------------")
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Vec2inZones | vec2.x : " .. vec2.x .. " | vec2.y : " .. vec2.y)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Vec2inZones | zoneList |", zoneList)
  local result
  for _v = 1, #zoneList, 1 do
    result = self:PointInZone(vec2, zoneList[_v])
    if result then
      return true
    end
  end
  return false
end

--- Determine if a given vector position is within a specified quadpoint zone.
--
-- This function checks if a specified vector position (`vec2`) is within the bounds of a given
-- quadpoint zone, as defined in the Mission Editor. The zone is identified by its name. The function
-- assesses whether the vector position falls within the geometric boundaries of the zone. This check
-- is essential for spatial validation and ensuring that positions align with designated areas or
-- operational boundaries.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param vec2 The vector position to be checked, in the format `{x = , y = }`.
-- @param zoneName The name of the quadpoint zone as defined in the Mission Editor.
-- @return result Boolean value indicating whether the vector position is within the zone (true) or not (false).
function SPECTRE.SPAWNER:PointInZone(vec2, zoneName)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointInZone | -------------------------------------------------------------------------")
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointInZone | vec2.x : " .. vec2.x .. " | vec2.y : " .. vec2.y)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointInZone | vec2     |", vec2)
  local _zone = mist.DBs.zonesByName[zoneName]
  local box =  _zone.verticies
  local _vec2 = {}
  if vec2.x == nil then
    _vec2.x = vec2[1]
    _vec2.y = vec2[2]
  else
    _vec2 = vec2
  end

  local result = self:PointWithinShape(_vec2, box)
  return result
end

--- Determine if a point lies within a given polygon shape.
--
-- This function uses a ray-casting algorithm to determine if a given point (`point`) is inside a specified polygon.
-- The algorithm works by drawing a horizontal line to the right of the point and extending it to infinity, then
-- counting the number of times this line intersects with the edges of the polygon. The point is considered inside
-- the polygon if the count of intersections is odd or if the point lies on an edge of the polygon. This method is
-- used for complex spatial checks, particularly useful in scenarios where geometric boundaries need to be accurately
-- assessed.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param point The vector position to test, in the format `{x = #, y = #}`.
-- @param polygon The polygon against which the point is being tested. It is a table of vector positions defining the polygon's vertices.
-- @return oddNodes True if the point is inside the polygon, false otherwise.
function SPECTRE.SPAWNER:PointWithinShape(point, polygon)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointWithinShape | -------------------------------------------------------------------------")
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointWithinShape | vec2.x : " .. point.x .. " | vec2.y : " .. point.y)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:PointWithinShape | polygon |" , polygon)
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


--- 9 - Zone TypeDef.
--
-- ===
--
-- Defines properties and attributes associated with a zone in the `SPECTRE.SPAWNER` system.
-- This table specifies various parameters related to the zone's configuration and settings.
-- It includes information on zone dimensions, weighting, and group settings.
--
-- ===
-- @section SPECTRE.SPAWNER

--- Defines properties and attributes associated with a zone in the `SPECTRE.SPAWNER` system.
-- This table specifies various parameters related to the zone's configuration and settings.
-- It includes information on zone dimensions, weighting, and group settings.
-- @field #SPAWNER.Zone_
SPECTRE.SPAWNER.Zone_ = {
  -- Name of the zone.
  name = "",
  -- Object representing the zone.
  Object = {},
  -- Types available for ZoneSpawn.
  Types = {},
  -- Storage for spawner configurations.
  BuiltSpawner = {},
  -- Settings for groups within the zone.
  GroupSettings = {},
  -- Radius of the zone in meters.
  radius = 0,
  -- Area of the zone in square meters.
  area = 0,
  -- Weight associated with the zone, used in calculations.
  weight = 0,
  -- Number of sub-zones within the main zone.
  numSubZones = 0,
  -- Average distribution of entities within the zone.
  avgDistribution = 0,
  -- Priority of group sizes to be created within the zone.
  GroupSizes = {
    [1] = 4,
    [2] = 3,
    [3] = 2,
    [4] = 1,
  },
  -- Storage for obstacle coordinates within the zone.
  ObjectCoords = {
    -- Storage for the placement of spawned units within the zone.
    groupcenters = {},
  },

}

--- Create a new instance of the SPECTRE.SPAWNER.Zone_ object.
--
-- This constructor function initializes a new instance of the Zone_ object within the SPAWNER system.
-- It sets up the zone with a specified name and initializes various properties such as the associated DCS zone object,
-- its radius, area, and initial weight. The function also sets default group spacing settings for different group sizes.
-- This setup is essential for managing zones and their characteristics within the SPAWNER framework.
--
-- @param #SPAWNER.Zone_ self The instance of the Zone_ object being created.
-- @param zoneName The name of the zone to be initialized.
-- @return #SPAWNER.Zone_ self The newly created Zone_ instance with the specified configurations.
-- @usage local zoneInstance = SPECTRE.SPAWNER.Zone_:New("MyZone") -- Initializes and returns a new zone named "MyZone".
function SPECTRE.SPAWNER.Zone_:New(zoneName)
  local self = BASE:Inherit(self, SPECTRE:New())

  -- Initialize properties based on the given zone name
  self.name = zoneName
  self.Object = ZONE:FindByName(zoneName)
  self.radius = self.Object:GetRadius()
  self.area = math.pi * (self.radius^2)
  self.weight = 0

  -- Set default group spacing settings
  self:setGroupSpacing(1, 5, nil, 2, 3, 20)
  self:setGroupSpacing(2, 25, nil, 10, 35, 30)
  self:setGroupSpacing(3, 30, nil, 15, 35, 35)
  self:setGroupSpacing(4, 35, nil, 15, 40, 35)

  return self
end

--- Configure spawn amount settings for a specific zone.
--
-- This function is responsible for calculating and setting various spawn settings for a zone.
-- It takes into consideration factors such as the zone's weight and adjusts spawn counts
-- accordingly, computing threshold values to manage deviations. The settings include nominal,
-- minimum, and maximum spawn counts, as well as a nudge factor for fine-tuning. These calculations
-- are crucial for controlling the spawn behavior within the zone, ensuring spawns are aligned
-- with strategic objectives.
--
-- @param #SPAWNER.Zone_ self The instance of the Zone_ object being configured.
-- @param nominal The nominal spawn count.
-- @param min The minimum spawn count.
-- @param max The maximum spawn count.
-- @param nudgeFactor The nudge factor for adjusting spawn counts.
-- @return #SPAWNER.Zone_ self The zone object with updated spawn amount settings.
-- @usage local modifiedZone = myZone:setSpawnAmounts(50, 40, 60, 0.2) -- Configures and returns spawn settings for 'myZone'.
function SPECTRE.SPAWNER.Zone_:setSpawnAmounts(nominal, min, max, nudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.Zone_:setSpawnAmounts |  ---------------- |")


  local CFG = self.SpawnAmountSettings.Config  -- Reference to config spawn settings

  -- Configure spawn settings based on provided arguments
  CFG.NudgeFactor = nudgeFactor
  CFG.NudgeRecip = nudgeFactor ~= 0 and 1 / nudgeFactor or 0
  CFG.Nominal = math.ceil(nominal)
  CFG.Ratio.Max = max / nominal - 1
  CFG.Ratio.Min = min / nominal
  CFG.Max = math.ceil(max)
  CFG.Min = math.ceil(min)
  CFG.Weighted = math.ceil(nominal * self.weight)
  CFG.DivisionFactor = CFG.Nominal / CFG.Weighted
  CFG.Actual = math.ceil(SPECTRE.UTILS.generateNominal(CFG.Nominal, CFG.Min, CFG.Max, CFG.NudgeFactor))
  CFG.ActualWeighted = math.ceil(CFG.Actual * self.weight)

  -- Calculate threshold deviations
  CFG.Thresholds = {
    overNom  = math.max(0, CFG.Actual - CFG.Nominal),
    underNom = math.max(0, CFG.Nominal - CFG.Actual),
    overMax  = math.max(0, CFG.Actual - CFG.Max),
    underMax = math.max(0, CFG.Max - CFG.Actual),
    overMin  = math.max(0, CFG.Actual - CFG.Min),
    underMin = math.max(0, CFG.Min - CFG.Actual)
  }

  -- Output debug information if debugging is enabled
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneCFG(self)
  end

  return self
end

--- Generate and adjust spawn amount settings for a specific zone.
--
-- This function recalculates spawn settings for a zone based on the existing configuration.
-- It derives a new nudge factor and adjusts spawn counts, ensuring they align with the strategic
-- objectives of the zone. The function also calculates various threshold values to manage and
-- understand deviations from nominal counts. This recalibration is crucial for dynamically
-- adjusting spawns to changing conditions or requirements within the zone.
--
-- @param #SPAWNER.Zone_
-- @return #SPAWNER.Zone_ self
-- @usage local modifiedZone = myZone:RollSpawnAmounts() -- Recalculates and returns adjusted spawn settings for 'myZone'.
function SPECTRE.SPAWNER.Zone_:RollSpawnAmounts()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.Zone_:RollSpawnAmounts |  ---------------- |")
  local GEN = self.SpawnAmountSettings.Generated  -- Reference to generated spawn settings
  local CFG = self.SpawnAmountSettings.Config     -- Reference to config spawn settings

  -- Derive new nudge factor and related values
  GEN.NudgeFactor = SPECTRE.UTILS.generateNudge(CFG.NudgeFactor)
  GEN.NudgeRecip = GEN.NudgeFactor ~= 0 and 1 / GEN.NudgeFactor or 0

  -- Calculate spawn amounts based on derived nudge factor and zone's weight
  GEN.Nominal = math.ceil(SPECTRE.UTILS.generateNominal(CFG.Actual, CFG.Min, CFG.Max, GEN.NudgeFactor))
  GEN.Ratio.Max = CFG.Ratio.Max
  GEN.Ratio.Min = CFG.Ratio.Min
  GEN.Max = math.ceil(math.min(GEN.Nominal + (GEN.Nominal * GEN.Ratio.Max), CFG.Max))
  GEN.Min = math.ceil(math.max(GEN.Nominal - (GEN.Nominal * GEN.Ratio.Min), CFG.Min))
  GEN.Weighted = math.ceil(GEN.Nominal * self.weight)
  GEN.DivisionFactor = GEN.Nominal / GEN.Weighted
  GEN.Actual = math.ceil(SPECTRE.UTILS.generateNominal(GEN.Nominal, GEN.Min, GEN.Max, GEN.NudgeFactor))
  GEN.ActualWeighted = math.ceil(GEN.Actual * self.weight)

  -- Calculate threshold deviations
  GEN.Thresholds = {
    overNom  = math.max(0, GEN.Actual - CFG.Nominal),
    underNom = math.max(0, CFG.Nominal - GEN.Actual),
    overMax  = math.max(0, GEN.Actual - CFG.Max),
    underMax = math.max(0, CFG.Max - GEN.Actual),
    overMin  = math.max(0, GEN.Actual - CFG.Min),
    underMin = math.max(0, CFG.Min - GEN.Actual)
  }

  -- Output debug information if debugging is enabled
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(self)
  end

  return self
end

--- Update the threshold values for the spawn amount settings of a zone.
--
-- This function recalculates the threshold values for a zone's spawn settings.
-- It assesses how much the actual spawn count deviates from the nominal, minimum,
-- and maximum counts defined in the configuration. These recalculated thresholds
-- are crucial for understanding and managing spawn behavior in relation to
-- the defined limits, ensuring that the spawning process remains controlled and
-- within expected parameters.
--
-- @param #SPAWNER.Zone_
-- @return #SPAWNER.Zone_ self The zone object with updated threshold values.
-- @usage local modifiedZone = myZone:_UpdateGenThresholds() -- Updates and returns recalculated threshold values for 'myZone'.
function SPECTRE.SPAWNER.Zone_:_UpdateGenThresholds()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.Zone_:_UpdateGenThresholds |  ---------------- |")
  local GEN = self.SpawnAmountSettings.Generated  -- Reference to generated spawn settings
  local CFG = self.SpawnAmountSettings.Config     -- Reference to config spawn settings

  -- Calculate threshold deviations
  GEN.Thresholds = {
    overNom  = math.max(0, GEN.Actual - CFG.Nominal),
    underNom = math.max(0, CFG.Nominal - GEN.Actual),
    overMax  = math.max(0, GEN.Actual - CFG.Max),
    underMax = math.max(0, CFG.Max - GEN.Actual),
    overMin  = math.max(0, GEN.Actual - CFG.Min),
    underMin = math.max(0, CFG.Min - GEN.Actual)
  }

  -- Output debug information if debugging is enabled
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(self)
  end

  return self
end

--- Set the spacing configurations for a specified group size within a zone.
--
-- This function configures the spacing settings for groups of a specific size within a zone.
-- It sets the minimum and maximum separation distances between groups and between units within those groups.
-- These configurations are vital for ensuring proper spacing and organization of spawned groups,
-- avoiding overcrowding and ensuring tactical effectiveness. Default values are used if specific
-- parameters are not provided.
--
-- @param #SPAWNER.Zone_ self The instance of the Zone_ object being configured.
-- @param groupSize The size of the group for which spacing settings are being configured.
-- @param groupMinSep (Optional) The minimum separation distance between groups.
-- @param groupMaxSep (Optional) The maximum separation distance between groups.
-- @param unitMinSep (Optional) The minimum separation distance between units within a group.
-- @param unitMaxSep (Optional) The maximum separation distance between units within a group.
-- @param distFromBuildings (Optional) The minimum distance from nearby buildings.
-- @return #SPAWNER.Zone_ self The zone object with updated group spacing settings.
-- @usage modifiedZone = myZone:setGroupSpacing(3, 10, 20, 2, 4) -- Configures spacing settings for groups of size 3 in 'myZone'.
function SPECTRE.SPAWNER.Zone_:setGroupSpacing(groupSize, groupMinSep, groupMaxSep, unitMinSep, unitMaxSep , distFromBuildings)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER.Zone_:setGroupSpacing |  ---------------- |")
  -- Default spacing values from SPECTRE.SPAWNER.SpacingSettings_ if not provided
  groupMinSep = groupMinSep or SPECTRE.SPAWNER.SpacingSettings_.Groups.minSeperation
  groupMaxSep = groupMaxSep or SPECTRE.SPAWNER.SpacingSettings_.Groups.maxSeperation
  unitMinSep  = unitMinSep  or SPECTRE.SPAWNER.SpacingSettings_.Units.minSeperation
  unitMaxSep  = unitMaxSep  or SPECTRE.SPAWNER.SpacingSettings_.Units.maxSeperation
  distFromBuildings = distFromBuildings or  SPECTRE.SPAWNER.SpacingSettings_.DistanceFromBuildings
  -- Initialize the spacing settings for the given group size
  self.SpacingSettings[groupSize] = SPECTRE.SPAWNER.SpacingSettings_:New()
  self.SpacingSettings[groupSize].Groups = {
    minSeperation = groupMinSep,
    maxSeperation = groupMaxSep
  }
  self.SpacingSettings[groupSize].Units = {
    minSeperation = unitMinSep,
    maxSeperation = unitMaxSep
  }
  self.SpacingSettings[groupSize].DistanceFromBuildings = distFromBuildings  -- Default distance from buildings

  return self
end


--- Configuration settings for spawn amounts within a zone.
--
-- This template defines various settings related to the spawning of units or objects within a zone.
-- It includes factors affecting spawn quantities, such as nudge factors, ratios, and thresholds.
-- @field #SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate
SPECTRE.SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate = {
  -- Extra types to be added to groups.
  ExtraTypesToGroups = {},
  -- Number of extra types to be added.
  numExtraTypes = 0,
  -- Number of extra units to be added.
  numExtraUnits = 0,
  -- Factor used to introduce variability in spawn counts.
  NudgeFactor = 0,
  -- Reciprocal of the nudge factor for adjustments.
  NudgeRecip = 0,
  -- Ratio settings for spawn counts.
  Ratio = {
    -- Maximum ratio for spawn count adjustment.
    Max = 0,
    -- Minimum ratio for spawn count adjustment.
    Min = 0
  },
  -- Maximum allowable spawn count.
  Max = 0,
  -- Minimum allowable spawn count.
  Min = 0,
  -- Factor for division in calculations.
  DivisionFactor = 0,
  -- Actual calculated spawn count.
  Actual = 0,
  -- Weight-adjusted actual spawn count.
  ActualWeighted = 0,
  -- Nominal or standard spawn count.
  Nominal = 0,
  -- Weighted nominal spawn count.
  Weighted = 0,
  -- Thresholds for deviation in spawn counts.
  Thresholds = {
    -- Over nominal threshold.
    overNom = 0,
    -- Under nominal threshold.
    underNom = 0,
    -- Over maximum threshold.
    overMax = 0,
    -- Under maximum threshold.
    underMax = 0,
    -- Over minimum threshold.
    overMin = 0,
    -- Under minimum threshold.
    underMin = 0
  }
}

--- Create a new instance of SpawnAmountSettingsConfigTemplate for a zone.
--
-- This constructor function initializes a new instance of the SpawnAmountSettingsConfigTemplate,
-- which is part of the SPECTRE.SPAWNER.Zone_ system. The template is used to configure spawn amount
-- settings for zones within the SPAWNER framework. The function employs inheritance from the BASE class
-- to create an object with the properties and behaviors specific to spawn amount configurations.
--
-- @param #SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate
-- @return #SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate self The newly created SpawnAmountSettingsConfigTemplate instance.
function SPECTRE.SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  return self
end

--- Defines properties and attributes for spacing settings in the `SPECTRE.SPAWNER` system.
-- This table specifies parameters related to the separation distances between groups and units,
-- and their distance from buildings.
-- @field #SPAWNER.SpacingSettings_
SPECTRE.SPAWNER.SpacingSettings_ = {
  Groups = {
    -- Minimum separation between groups in meters.
    minSeperation = 15,
    -- Maximum separation between groups in meters.
    maxSeperation = 30
  },
  Units = {
    -- Minimum separation between units within groups in meters.
    minSeperation = 15,
    -- Maximum separation between units within groups in meters.
    maxSeperation = 30
  },
  -- Minimum distance from buildings in meters.
  DistanceFromBuildings = 20
}

--- Create a new instance of SpacingSettings for the SPECTRE spawner system.
--
-- This constructor function initializes a new instance of SpacingSettings, a component of the SPECTRE spawner system.
-- The newly created object is tailored to manage and configure the spacing
-- settings for spawn operations, crucial for ensuring proper placement and distribution of spawned units.
--
-- @param #SPAWNER.SpacingSettings_
-- @return #SPAWNER.SpacingSettings_ self
-- @usage local spacingSettingsInstance = SPECTRE.SPAWNER.SpacingSettings_:New() -- Instantiates a new SpacingSettings object.
function SPECTRE.SPAWNER.SpacingSettings_:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  return self
end

--- Configuration settings for spawn amounts within a zone.
--
-- This structure defines both the configured and dynamically generated settings related to the number of entities to be spawned within a zone.
-- It includes extra types and units settings, as well as specific configurations for spawn amounts.
-- @field #SPAWNER.Zone_.SpawnAmountSettings
SPECTRE.SPAWNER.Zone_.SpawnAmountSettings = {
  -- Extra types to be added to groups within the zone.
  ExtraTypesToGroups = {},
  -- Number of extra types to be included in the spawn.
  numExtraTypes = 0,
  -- Number of extra units to be included in the spawn.
  numExtraUnits = 0,
  -- Configured settings for spawn amounts within the zone.
  Config = SPECTRE.SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate:New(),
  -- Dynamically generated settings based on the configuration.
  Generated = SPECTRE.SPAWNER.Zone_.SpawnAmountSettingsConfigTemplate:New()
}

--- Configuration settings for spacing within a zone.
--
-- This structure defines the general spacing configurations for groups and units within a zone.
-- It includes settings for minimum and maximum separations between groups and units, and the distance from buildings.
-- @field #SPAWNER.Zone_.SpacingSettings
SPECTRE.SPAWNER.Zone_.SpacingSettings = {
  -- General spacing settings for the zone.
  General = SPECTRE.SPAWNER.SpacingSettings_:New()
}



--- 10 - ZONEMGR.
--
-- ===
--
-- *All Functions associated with ZONEMGR operations.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Adds an extra type with a specified number to the AddExtraTypeToGroupsZONE_A queue.
--
-- This function is designed to augment the AddExtraTypeToGroupsZONE_A queue within the SPAWNER class by adding an additional type and its corresponding quantity.
-- It is useful for dynamically adjusting the composition or characteristics of groups within a specific zone, allowing for customized and flexible game scenarios.
--
-- @param #SPAWNER self
-- @param _TYPE The type of entity or characteristic to be added to the queue.
-- @param _numTYPE The number of entities or quantity of the specified type to add.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_A(_TYPE, _numTYPE)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_A | -------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_A | _TYPE: " .. tostring(_TYPE))
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_A | _numTYPE: " .. tostring(_numTYPE))
  self._queueExtraTypeToGroupsZONE_A[_TYPE] = _numTYPE
  return self
end

--- Applies the extra type settings from AddExtraTypeToGroupsZONE_A to AddExtraTypeToGroupsZONE_B.
--
-- This function transfers the extra type settings configured in GroupsZONE_A to AddExtraTypeToGroupsZONE_B within the SPAWNER class.
-- It iterates through the types and quantities specified in the queue for AddExtraTypeToGroupsZONE_A and applies these settings to AddExtraTypeToGroupsZONE_B.
-- This ensures consistency and synchronization of extra types across different zones, facilitating coherent and balanced game dynamics.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  ---------------- |")
  for _TYPE, _numTYPE in pairs(self._queueExtraTypeToGroupsZONE_A) do

    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  MAIN ZONE")

    local setting = self.Zones.Main.SpawnAmountSettings
    if not setting.ExtraTypesToGroups[_TYPE] then setting.ExtraTypesToGroups[_TYPE] = 0 end
    setting.ExtraTypesToGroups[_TYPE] = setting.ExtraTypesToGroups[_TYPE] + _numTYPE
    setting.numExtraTypes = SPECTRE.UTILS.sumTable(setting.ExtraTypesToGroups)
    setting.numExtraUnits = 0
    for _t, _tv in pairs(setting.ExtraTypesToGroups) do
      setting.numExtraUnits = setting.numExtraUnits + _tv
    end
    --  setting.numExtraUnits = setting.numExtraUnits + _numTYPE
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  SUB ZONES")
    for _zoneName, _zoneObject in pairs (self.Zones.Sub) do
      local settingSub = _zoneObject.SpawnAmountSettings
      if not settingSub.ExtraTypesToGroups[_TYPE] then settingSub.ExtraTypesToGroups[_TYPE] = 0 end
      settingSub.ExtraTypesToGroups[_TYPE] = setting.ExtraTypesToGroups[_TYPE]
      settingSub.numExtraTypes = setting.numExtraTypes
      settingSub.numExtraUnits = setting.numExtraUnits

      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  Zone         : " .. _zoneName)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  numExtraTypes: " .. settingSub.numExtraTypes)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  numExtraUnits: " .. settingSub.numExtraUnits)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B |  _TYPE        : " .. _TYPE)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:AddExtraTypeToGroupsZONE_B | Extra of Types: " .. settingSub.ExtraTypesToGroups[_TYPE])
    end
  end

  return self
end


--- FOR ZONEMGR USE: Set spawn amounts for both main and subzones.
--
-- This function initializes the spawn amount settings for the SPAWNER object. It is designed for use
-- by ZONEMGR and is part of a two-step process that allows spawn zones to be determined at a later stage.
-- The function sets nominal, minimum, maximum, and nudge factor values for spawn amounts.
-- The nudge factor introduces a degree of randomness in spawn amounts, with a default value of 0.5 if not specified.
--
-- @param #SPAWNER self
-- @param nominal The nominal (standard or expected) spawn amount.
-- @param min The minimum spawn amount, defaults to 0 if not provided.
-- @param max The maximum spawn amount, defaults to the value of `nominal` if not provided.
-- @param nudgeFactor The factor used to introduce randomness in spawn amounts, defaults to 0.5 if not provided.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setSpawnAmountsZONE_A(nominal, min, max, nudgeFactor)
  -- Set default values for arguments if not provided
  self.nominal = nominal
  self.nudgeFactor = nudgeFactor or 0.5
  self.min = min or 0
  self.max = max or nominal
  return self
end

--- FOR DYNAMIC SPAWN ZONE USE: Set size for main zone.
--
-- This function sets the size parameters for the main zone in the SPAWNER object.
-- It defines the nominal, minimum, and maximum sizes, as well as a nudge factor to introduce
-- randomness in size determination. The function is particularly relevant for dynamic spawn zones,
-- allowing customization of zone size based on specified criteria. Default values are provided
-- for minimum size (0 meters) and nudge factor (0.5) if they are not explicitly set.
--
-- @param #SPAWNER self
-- @param nominal The nominal size of the main zone in meters.
-- @param min The minimum size of the main zone in meters, defaults to 0 if not provided.
-- @param max The maximum size of the main zone in meters, defaults to the value of `nominal` if not provided.
-- @param nudgeFactor The factor used to introduce randomness in the size of the main zone, defaults to 0.5 if not provided.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setZoneSizeMain(nominal, min, max, nudgeFactor)
  -- Set default values for arguments if not provided
  self.ZoneSize.Main.nominal = nominal
  self.ZoneSize.Main.nudgeFactor = nudgeFactor or 0.5
  self.ZoneSize.Main.min = min or 0
  self.ZoneSize.Main.max = max or nominal
  return self
end

--- FOR DYNAMIC SPAWN ZONE USE: Set number of subzones for spawner.
--
-- This function configures the number of subzones for the SPAWNER object. It sets the nominal,
-- minimum, and maximum number of subzones, along with a nudge factor that introduces randomness
-- into the calculation. The sizes of subzones are determined based on these numbers. Default values
-- are assigned to the minimum number of subzones (0) and the nudge factor (0.5) if they are not
-- specifically provided.
--
-- @param #SPAWNER self
-- @param nominal The nominal number of subzones.
-- @param min The minimum number of subzones, defaults to 0 if not provided.
-- @param max The maximum number of subzones, defaults to the value of `nominal` if not provided.
-- @param nudgeFactor The factor used to introduce randomness in the number of subzones, defaults to 0.5 if not provided.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setNumSubZones(nominal, min, max, nudgeFactor)
  -- Set default values for arguments if not provided
  self.ZoneSize.Sub.nominal = nominal
  self.ZoneSize.Sub.nudgeFactor = nudgeFactor or 0.5
  self.ZoneSize.Sub.min = min or 0
  self.ZoneSize.Sub.max = max or nominal
  return self
end

--- FOR DYNAMIC SPAWN ZONE USE: Set restricted zones for spawner.
--
-- This function defines a set of restricted zones for the SPAWNER object. It allows specifying
-- zones where spawning should be limited or prohibited. The function accepts a table of restricted
-- zones and applies these restrictions to the SPAWNER's operation. If no restricted zones are
-- provided, the function defaults to an empty table, implying no restrictions.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param restrictedZones A table of restricted zones. Defaults to an empty table if not provided.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setZoneRestricted(restrictedZones)
  self.ZonesRestricted = restrictedZones or {}
  return self
end

--- FOR DYNAMIC SPAWN ZONE USE: Set number of subzones for spawner.
--
-- This function parses and assigns names to the main zone and its subzones for the SPAWNER object.
-- It generates unique names for each zone by appending a random factor to the provided MainZoneName.
-- The function also creates instances of `ZONE_RADIUS` for both the main and subzones using their respective names
-- and size attributes. The names of restricted zones, if any, are also included in the zone naming process.
-- Debug information regarding the assigned zone names is printed if `SPECTRE.DebugEnabled` is set to 1.
--
-- @param #SPAWNER self
-- @param MainZoneName The name of the main zone to which subzones are related.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:parseSubCirclesToZoneNames( MainZoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:parseSubCirclesToZoneNames | ---------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:parseSubCirclesToZoneNames | MainZoneName: " .. MainZoneName)
  local ZoneNames = {}
  local randFact = os.time()
  ZoneNames.Main = MainZoneName .. randFact
  ZONE_RADIUS:New(MainZoneName  .. randFact, self.ZoneMainVec2,self.ZoneSize.Main.Actual,false)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:parseSubCirclesToZoneNames | ZONE Main Name: " .. ZoneNames.Main)
  ZoneNames.Sub = {}
  for _subZoneNum, _subCircle in ipairs(self.generatedSubCircles) do
    local _subZoneName = ZoneNames.Main .. "_" .. _subZoneNum
    table.insert(ZoneNames.Sub, _subZoneName)
    ZONE_RADIUS:New(_subZoneName,_subCircle.vec2,_subCircle.diameter/2,false)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:parseSubCirclesToZoneNames | ZONE Sub Name: " .. _subZoneName)
  end
  ZoneNames.Restricted = self.ZonesRestricted
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:parseSubCirclesToZoneNames | ZONE Restricted Names: ", ZoneNames.Restricted)
  self.ZoneNames = ZoneNames
  return self
end

--- DYNAMIC GEN ONLY: Set the generated zones for the SPAWNER.
--
-- This function establishes the zones for the SPAWNER object, including the main zone, subzones, and restricted zones.
-- It initializes these zones based on the names provided in `self.ZoneNames`. If the subzones and restricted zones
-- are not specified, they are initialized as empty sets. The function also calculates zone weights for spawn balancing.
-- Debug information is output for zone names and weights if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing
-- is recorded if enabled, tracking the performance of the zone setup process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:SetZonesGenerated()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZonesGenerated | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.SetZones = {Time = {},}
    self.BenchmarkLog.SetZones.Time.start = os.clock()
  end
  local MainZone = self.ZoneNames.Main
  local SubZones = self.ZoneNames.Sub
  local NoGoZones = self.ZoneNames.Restricted
  -- Debug Information

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZonesGenerated | MainZone: " .. MainZone)

  -- Initialize optional tables if they aren't provided
  SubZones = SubZones or {}
  NoGoZones = NoGoZones or {}

  -- Debug output for subzones and restricted zones
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZonesGenerated | SubZones: ", table.concat(SubZones, ", "))
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SetZonesGenerated | NoGoZones: ", table.concat(NoGoZones, ", "))

  -- Set the main zone
  self.Zones.Main = self.Zone_:New(MainZone)

  -- Set the subzones
  for _, zoneName in ipairs(SubZones) do
    self.Zones.Sub[zoneName] = self.Zone_:New(zoneName)
  end

  -- Compute weights for zones
  self:weightZones()

  -- Set the restricted zones
  self.Zones.Restricted = NoGoZones
  if self.Benchmark == true then
    self.BenchmarkLog.SetZones.Time.stop = os.clock()
  end

  return self
end

--- DYNAMIC GEN ONLY: Generate subzone circles for dynamic spawn zones.
--
-- This function generates geometric data for subzones within a dynamic spawn zone. It calculates
-- and assigns positions and sizes for subzone circles based on the provided main zone vector (`vec2`)
-- and internal size settings. The function ensures that the subzones are appropriately placed within the main zone
-- and do not overlap with any restricted zones. Debug information is output, detailing the generation process and
-- the properties of each subzone circle if `SPECTRE.DebugEnabled` is set to 1. The function uses several internal
-- configurations and thresholds to manage the generation process.
--
-- @param #SPAWNER self
-- @param vec2 The vector position of the main zone.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:generateSubZoneCircles(vec2)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | -------------------------------------------------------------------------")
  self.generatedSubCircles = {}
  self.ZoneMainVec2 = vec2
  local _mainSett = self.ZoneSize.Main
  local _subSett = self.ZoneSize.Sub
  local mainCircleSize = SPECTRE.UTILS.generateNominal(_mainSett.nominal, _mainSett.min, _mainSett.max, _mainSett.nudgeFactor)
  self.ZoneSize.Main.Actual = mainCircleSize
  local mainCircleVec2 = vec2
  local numSubCircles = math.floor(SPECTRE.UTILS.generateNominal(_subSett.nominal, _subSett.min, _subSett.max, _subSett.nudgeFactor))
  self.ZoneSize.Sub.Actual = numSubCircles
  local subCircleMinSize = (mainCircleSize/numSubCircles)/2

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | mainCircleSize   | " .. mainCircleSize)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | numSubCircles    | " .. numSubCircles)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | subCircleMinSize | " .. subCircleMinSize)

  --local generatedSubCircles = SPECTRE.POLY.generateSubCircles(mainCircleSize, mainCircleVec2, numSubCircles, subCircleMinSize, true, self)

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | -------VEC 2 GEN ------ |")
  self.generatedSubCircles = {}
  local generatedSubCircles = {}
  local mainRadius = mainCircleSize / 2
  local attempts = 0 -- to prevent infinite loops
  local attemptLimit = numSubCircles * self.Config.operationLimit

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | #generatedSubCircles       |" .. #generatedSubCircles)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | numSubCircles              |" .. numSubCircles)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | attempts                   |" .. attempts)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | numSubCircles              |" .. numSubCircles)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | self.Config.operationLimit |" .. self.Config.operationLimit)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | attemptLimit               |" .. attemptLimit)


  -- while #generatedSubCircles < numSubCircles and attempts < attemptLimit do
  repeat
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | CURRENT ATTEMPT            |" .. attempts)
    local flag_goodcoord = true
    local glassBreak = 0
    local subCircle = {}
    local subRadius

    repeat
      flag_goodcoord = true
      subRadius = math.random(subCircleMinSize / 2, mainRadius) / 2
      local angle =  math.random() * 2 * math.pi
      local maxDistFromCenter = mainRadius - subRadius
      local minDistFromCenter = subRadius
      local distFromCenter = math.random(minDistFromCenter, maxDistFromCenter)

      subCircle.vec2 = {
        x = mainCircleVec2.x + distFromCenter * math.cos(angle),
        y = mainCircleVec2.y + distFromCenter * math.sin(angle)
      }
      subCircle.diameter = subRadius * 2
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | vec2.x : " .. subCircle.vec2.x .. " | vec2.y " .. subCircle.vec2.y)

      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | ------- GOODCOORD CHECK -------- |")

      if flag_goodcoord then flag_goodcoord = self.checkNOGO(self, subCircle.vec2, self.ZonesRestricted) end

      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | GOODCOORD? | " .. tostring(flag_goodcoord))
      if glassBreak >= self.Config.operationLimit then
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | --- GLASSBREAK --")
        flag_goodcoord = true
      end
      glassBreak = glassBreak + 1
    until flag_goodcoord


    if SPECTRE.POLY.isSubCircleValidThreshold(subCircle, generatedSubCircles, mainCircleVec2, mainRadius, 0.75) then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | SubCircle: VALID")
      table.insert(generatedSubCircles, subCircle)
    else
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | SubCircle: INVALID, regen")
    end

    if attempts >= attemptLimit then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | --- attempts GLASSBREAK --")
      flag_goodcoord = true
    end
    attempts = attempts + 1
  until #generatedSubCircles == numSubCircles and flag_goodcoord--end


  if SPECTRE.DebugEnabled == 1 then
    for _, _v in ipairs(generatedSubCircles) do
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | generatedSubCircle | " .. _)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | diameter | " .. _v.diameter)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | vec2.x   | " ..  _v.vec2.x)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | vec2.y   | " ..  _v.vec2.y)
    end
  end
  self.generatedSubCircles = generatedSubCircles
  return self
end

--- FOR ZONEMGR USE: Set spawn amounts for both main and subzones (Part B).
--
-- This function is the second part of the process to set spawn amounts for the SPAWNER object. It is used
-- after the initial setup of spawn zones and configuration parameters (handled in `setSpawnAmountsZONE_A`).
-- This function calculates and assigns spawn amounts for the main zone and each subzone based on predefined settings
-- and a calculated average distribution. The function also allows for the application of nudge factors to introduce
-- variability in spawn amounts. Debug information is generated if `SPECTRE.DebugEnabled` is set to 1, providing details
-- on the configuration and generation of spawn amounts. Benchmark timing is recorded if enabled.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:setSpawnAmountsZONE_B()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:setSpawnAmountsZONE_B | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog.setSpawnAmounts = {Time = {},}
    self.BenchmarkLog.setSpawnAmounts.Time.start = os.clock()
  end

  local nudgeFactor = self.nudgeFactor
  local min = self.min
  local max = self.max
  local nominal = self.nominal

  -- Debug header
  SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:setSpawnAmountsZONE_B | CONFIG | NOMINAL: %d | MIN: %d | MAX: %d | NUDGE FACTOR: %f", nominal, min, max, nudgeFactor))

  -- Calculate main zone values
  self.Zones.Main.numSubZones = SPECTRE.UTILS.sumTable(self.Zones.Sub)
  self.Zones.Main:setSpawnAmounts(nominal, min, max, nudgeFactor):RollSpawnAmounts()

  -- Calculate spawn configurations for subzones
  local avgDistribution = self.Zones.Main.SpawnAmountSettings.Generated.Actual / self.Zones.Main.numSubZones
  local spawnsMax = math.min(avgDistribution + avgDistribution * self.Zones.Main.SpawnAmountSettings.Generated.Ratio.Max,
    self.Zones.Main.SpawnAmountSettings.Generated.Max / self.Zones.Main.numSubZones)
  local spawnsMin = math.max(avgDistribution - avgDistribution * self.Zones.Main.SpawnAmountSettings.Generated.Ratio.Min,
    self.Zones.Main.SpawnAmountSettings.Generated.Min / self.Zones.Main.numSubZones)

  -- Debug information for Zone configurations
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.DEBUGoutput.infoZoneCFG(self.Zones.Main)
    SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(self.Zones.Main)
  end

  -- Set spawn amounts for each subzone
  for _, zoneObject_ in pairs(self.Zones.Sub) do
    zoneObject_:setSpawnAmounts(avgDistribution, spawnsMin, spawnsMax, SPECTRE.UTILS.generateNudge(self.Zones.Main.SpawnAmountSettings.Generated.NudgeFactor)):RollSpawnAmounts()
  end

  self:Jiggle()

  if self.Benchmark == true then
    self.BenchmarkLog.setSpawnAmounts.Time.stop = os.clock()
  end
  return self
end

--- FOR ZONEMGR USE: Dynamically generate a spawn zone.
--
-- This function orchestrates a series of operations to dynamically generate and configure a spawn zone.
-- It involves generating subzone circles, parsing these subzones into zone names, setting up the generated zones,
-- and configuring spawn amounts and group sizes. Additional operations for group type addition and final generation
-- are also performed. The function allows for benchmarking and summary generation, controlled through optional
-- parameters. This method is key for creating flexible and dynamic spawn zones within the SPAWNER framework.
--
-- @param #SPAWNER self
-- @param vec2 The vector location where the spawner will operate.
-- @param name The name to be used for the generated zone.
-- @param benchmark (optional) A boolean flag to enable benchmarking.
-- @param summary (optional) A boolean flag to enable summary generation.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:DynamicGenerationZONE(vec2, name, benchmark, summary)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DynamicGenerationZONE | -------------------------------------------------------------------------")
  benchmark = benchmark or false
  summary = summary or false
  self:generateSubZoneCircles(vec2)
  self:parseSubCirclesToZoneNames(name)
  self:SetZonesGenerated()
  self:AddExtraTypeToGroupsZONE_B()
  self:setSpawnAmountsZONE_B()
  self:RollSpawnGroupSizes()
  self:Generate()
  if self.Benchmark then
    if benchmark then self:_SaveBenchmark() end
    if summary then self:Summary() end
  end
  return self
end

--- 11 - Misc.
-- ===
--
-- *Misc Methods*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Saves and reports benchmarking data for the SPAWNER instance.
--
-- This function is dedicated to processing and displaying benchmarking data collected by the SPAWNER instance.
-- It calculates execution times for various benchmarked functions and zones, then outputs this information for analysis.
-- This function is critical for performance evaluation, helping to identify potential bottlenecks or areas for optimization within the SPAWNER's operations.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_SaveBenchmark()
  local _trun = 6
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:BENCHMARK INFO   |")
  for _benchmarkFuncName, _value in pairs (self.BenchmarkLog) do
    SPECTRE.UTILS.debugInfo("_benchmarkFuncName",_benchmarkFuncName)
    SPECTRE.UTILS.debugInfo("_value",_value)
    if  _value.Time then
      local exe_Time = _value.Time.stop - _value.Time.start
      _value.Time.real = exe_Time
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:BENCHMARK INFO   | Param: "  .._benchmarkFuncName .. " | Time: " .. SPECTRE.UTILS.trunc(exe_Time, _trun) .. "s" )
    else
      for _benchmarkZoneName, _valueZone in pairs (self.BenchmarkLog[_benchmarkFuncName]) do
        if  _valueZone.Time then
          local exe_Time = _valueZone.Time.stop - _valueZone.Time.start
          _valueZone.Time.real = exe_Time
          SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:BENCHMARK INFO   | Param: "  .._benchmarkFuncName .. " | Zone: " .. _benchmarkZoneName .. " | Time: " .. SPECTRE.UTILS.trunc(exe_Time, _trun) .. "s")
        end
      end
    end
  end
  return self
end

--- Generates and saves a summary report for SPAWNER activities.
--
-- This function creates a comprehensive summary of the SPAWNER's activities, including details on spawned groups, types, templates, and benchmarking data.
-- It aggregates information from various zones, calculating the total number of groups, types, and templates used. The function also includes benchmarking
-- times for different SPAWNER operations, offering insights into performance. The summary is saved to a file and detailed logs are produced for analysis.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Summary()
  SPECTRE.IO.PersistenceToFile(SPECTRE._persistenceLocations.SPAWNER.path .. "Summary/" .. self.Zones.Main.name .. ".lua", self, true)
  local curDEBUG = SPECTRE.DebugEnabled
  SPECTRE.DebugEnabled = 1

  local numSpawnedTypes = 0
  local numSpawnedTemplates = 0
  local allTypesNames = {}
  local allTypesCount = 0
  local allTemplatesNames = {}
  local allTemplatesCount = 0
  local numGroups = 0

  for _zoneName, _zoneObject in pairs (self.Zones.Sub) do
    local _AmountSetting = _zoneObject.SpawnAmountSettings
    for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
      for _GIndex = 1, setting.numGroups, 1 do
        for _UIndex = 1, setting.size + _AmountSetting.numExtraUnits, 1 do
          table.insert(allTypesNames, setting.Types[_GIndex][_UIndex])
          table.insert(allTemplatesNames, setting.Templates[_GIndex][_UIndex])
          allTypesCount = allTypesCount + 1
          allTemplatesCount = allTemplatesCount + 1
        end
        numGroups = numGroups + 1
      end
    end
  end

  local numUniqueTypesNames = 0
  local numUniqueTemplates = 0
  local uniqueTypesNames = SPECTRE.UTILS.CountValues(allTypesNames)
  local uniqueTemplates = SPECTRE.UTILS.CountValues(allTemplatesNames)

  for _k,_v in pairs(uniqueTypesNames) do
    numUniqueTypesNames = numUniqueTypesNames + 1
  end
  for _k,_v in pairs(uniqueTemplates) do
    numUniqueTemplates = numUniqueTemplates + 1
  end


  local setGEN = self.Zones.Main.SpawnAmountSettings.Generated
  local setCFG = self.Zones.Main.SpawnAmountSettings.Config

  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ZONE | " .. self.Zones.Main.name .. " | #SUBZONES | " .. self.Zones.Main.numSubZones )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | GROUPS SPAWNED          : " .. numGroups .. " | TYPES USED | " .. allTypesCount .. " | TEMPLATES USED | " .. allTemplatesCount )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | UNIQUE TYPES USED       : " .. numUniqueTypesNames .. " | UNIQUE TEMPLATES USED | " .. numUniqueTemplates )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | GEN TARGET # SPAWNS     : " .. setGEN.Actual .. " | OVER NOM: " .. setGEN.Thresholds.overNom .. " | UNDER NOM: " .. setGEN.Thresholds.underNom  )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | OVER MAX: " .. setGEN.Thresholds.overMax .. " | UNDER MIN: " .. setGEN.Thresholds.underMin  )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | CFG NOM : " .. setCFG.Nominal .. " CFG Min : " .. setCFG.Min .. " CFG Max : " .. setCFG.Max )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | # EXTRA TYPES: " .. self.Zones.Main.SpawnAmountSettings.numExtraTypes .. " | # EXTRA UNITS: " .. self.Zones.Main.SpawnAmountSettings.numExtraUnits  )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | GENERATE TOTAL   : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.Generate.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME |   Group SIZE GEN : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.RollSpawnGroupSizes.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME |   Group TYPE GEN : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.RollSpawnGroupTypes.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | PLACEMENT TOTAL  : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.RollPlacement.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | SETUP GROUPS     : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.SetupSpawnGroups.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | SPAWN GROUPS     : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.Spawn.Time.real, 5) .. " seconds"  or "enableBenchmark")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ------ NUMBER OF TYPES USED")
  for _Name, _numUsed in pairs(uniqueTypesNames) do
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | " .. _numUsed .. " : " .. _Name )
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ------ NUMBER OF TEMPLATES USED")
  for _Name, _numUsed in pairs(uniqueTemplates) do
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | " .. _numUsed .. " : " .. _Name )
  end
  for _zoneName, _zoneObject in pairs (self.Zones.Sub) do
    local _AmountSetting = _zoneObject.SpawnAmountSettings
    local numSpawnedTypes = 0
    local numSpawnedTemplates = 0
    local allTypesNames = {}
    local allTypesCount = 0
    local allTemplatesNames = {}
    local allTemplatesCount = 0
    local numGroups = 0

    --    if not allTypesNames[_zoneName] then allTypesNames[_zoneName] = {} end
    --    if not allTemplatesNames[_zoneName] then allTemplatesNames[_zoneName] = {} end
    for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
      for _GIndex = 1, setting.numGroups, 1 do
        for _UIndex = 1, setting.size + _AmountSetting.numExtraUnits, 1 do
          table.insert(allTypesNames, setting.Types[_GIndex][_UIndex])
          table.insert(allTemplatesNames, setting.Templates[_GIndex][_UIndex])
          allTypesCount = allTypesCount + 1
          allTemplatesCount = allTemplatesCount + 1
        end
        numGroups = numGroups + 1
      end
    end

    local numUniqueTypesNames = 0
    local numUniqueTemplates = 0
    local uniqueTypesNames = SPECTRE.UTILS.CountValues(allTypesNames)
    local uniqueTemplates = SPECTRE.UTILS.CountValues(allTemplatesNames)

    for _k,_v in pairs(uniqueTypesNames) do
      numUniqueTypesNames = numUniqueTypesNames + 1
    end
    for _k,_v in pairs(uniqueTemplates) do
      numUniqueTemplates = numUniqueTemplates + 1
    end


    local setGEN = _zoneObject.SpawnAmountSettings.Generated
    local setCFG = _zoneObject.SpawnAmountSettings.Config

    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | SUBZONE SUMMARY | " .. _zoneObject.name .. " | #SUBZONES | " .. _zoneObject.numSubZones )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | GROUPS SPAWNED          : " .. numGroups .. " | TYPES USED | " .. allTypesCount .. " | TEMPLATES USED | " .. allTemplatesCount )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | UNIQUE TYPES USED       : " .. numUniqueTypesNames .. " | UNIQUE TEMPLATES USED | " .. numUniqueTemplates )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | GEN TARGET # SPAWNS     : " .. setGEN.Actual .. " | OVER NOM: " .. setGEN.Thresholds.overNom .. " | UNDER NOM: " .. setGEN.Thresholds.underNom  )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | OVER MAX: " .. setGEN.Thresholds.overMax .. " | UNDER MIN: " .. setGEN.Thresholds.underMin  )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | CFG NOM : " .. setCFG.Nominal .. " CFG Min : " .. setCFG.Min .. " CFG Max : " .. setCFG.Max )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | # EXTRA TYPES: " .. _zoneObject.SpawnAmountSettings.numExtraTypes .. " | # EXTRA UNITS: " .. _zoneObject.SpawnAmountSettings.numExtraUnits  )
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | Group TYPE     : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog._generateGroupTypes[_zoneObject.name].Time.real, 5) .. " seconds" or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | Group TEMPLATE : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog._generateGroupTemplates[_zoneObject.name].Time.real , 5) .. " seconds" or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | Unit  VEC2     : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.Set_Vec2_UnitTemplates[_zoneObject.name].Time.real , 5) .. " seconds" or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | Group VEC2     : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog.Set_Vec2_GroupCenters[_zoneObject.name].Time.real, 5) .. " seconds"  or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | SETUP GROUPS   : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog._SetupSpawnGroups[_zoneObject.name].Time.real, 5) .. " seconds"  or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | TIME | SPAWN GROUPS   : " .. SPECTRE.UTILS.trunc(self.BenchmarkLog._Spawn[_zoneObject.name].Time.real, 5) .. " seconds"  or "enableBenchmark")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ---------------------------------------------------------------------------- ")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ------ NUMBER OF TYPES USED")
    for _Name, _numUsed in pairs(uniqueTypesNames) do
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | " .. _numUsed .. " : " .. _Name )
    end
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | ------ NUMBER OF TEMPLATES USED")
    for _Name, _numUsed in pairs(uniqueTemplates) do
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:SUMMARY   | " .. _numUsed .. " : " .. _Name )
    end
  end
  SPECTRE.DebugEnabled = curDEBUG
  return self
end

--- 12 - Internal Methods.
-- ===
--
-- *Internal methods, can be used with care and know how*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Execute the spawning process for a specific zone object.
--
-- This internal function handles the actual spawning of groups within a given zone. It iterates through
-- the group settings of the zone, spawning each group at the pre-calculated vector positions. The function
-- manages the timing and coordinates of each spawn, ensuring that groups are spawned accurately according to
-- their configurations. It utilizes a timer to stagger the spawning of groups for added realism and efficiency.
-- Debug information is output detailing each group's spawning process if `SPECTRE.DebugEnabled` is set to 1.
-- Benchmark timing is recorded if enabled, to track the performance of the spawning process for the zone.
--
-- @param #SPAWNER self
-- @param _zoneObject The zone object for which groups are being spawned.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_Spawn(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_Spawn | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog._Spawn then self.BenchmarkLog._Spawn = {} end
    self.BenchmarkLog._Spawn[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog._Spawn[_zoneObject.name].Time.start = os.clock()
  end

  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    -- Loop for the number of groups specified in the current setting.
    for _groupIndex = 1, setting.numGroups do
      -- List to store types for this group.
      local _UnitTypes = {}
      --local _UnitTypesobj = {}
      -- Loop for the size of the group + extra units.
      for _Unit = 1, setting.size + _zoneObject.SpawnAmountSettings.numExtraUnits do --+ self.Config.numExtraUnits
        local _vec2 = setting.TemplateCoords[_groupIndex][_Unit]
        local SpawnGroup_ = setting.SpawnedGROUPS[_groupIndex][_Unit]--:SpawnFromVec2(_vec2)
        local capturedSpawnGroup = SpawnGroup_
        local _Tvec2 = _vec2
        local _Timer = TIMER:New(function()

            local SpawnGroupt_ = capturedSpawnGroup:SpawnFromVec2(_vec2)

            SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_Spawn | GROUP ------------------------------------")
            SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_Spawn | SpawnGroup_    : ",  SpawnGroupt_:GetName())
            SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_Spawn | _vec2.x       : " .. _vec2.x .. " | _vec2.y :" .._vec2.y)

        end, capturedSpawnGroup, _vec2)
        _Timer:Start(math.random(2,10))
      end
    end
  end
  if self.Benchmark == true then
    self.BenchmarkLog._Spawn[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Called by DetectTypeTemplates.
function SPECTRE.SPAWNER:_detectHighestAttributes(TemplatePrefix, _Object)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DetectTypeTemplates | DETECT HIGHEST PRIORITY ATTRIBUTE ---------------------------------")

  -- Nested function to find the template type with the highest priority
  local function findTypeIndex(table, input)
    local highestPriority = -1
    local matchingType = nil
    -- Iterate through the TEMPLATETYPES_ table to find the matching type with highest priority
    for key, value in pairs(table) do
      for _i,_attr in ipairs(input) do
        if _attr == key and value._Priority and value._Priority > highestPriority then
          highestPriority = value._Priority
          matchingType = key
        end
      end
    end
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DetectTypeTemplates | MATCH TYPE: " .. matchingType)
    return matchingType
  end
  for Group_, GroupObject in pairs(mist.DBs.groupsByName) do
    if string.find(Group_, TemplatePrefix, 1, true) then
      local _groupAttributes = SPECTRE.UTILS.GetGroupAttributes(Group_)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:DetectTypeTemplates | GROUP:  " .. Group_ .. " | ATTRIBUTES: ", _groupAttributes)
      local matchedType = findTypeIndex(_Object, _groupAttributes)
      if matchedType then
        -- Add the group name to the matched type
        SPECTRE.UTILS.safeInsert(_Object[matchedType].GroupNames, Group_)
      end
    end
  end
  return _Object
end

--- Distributes difference in spawn amounts across subzones and introduces randomness.
--
-- This function is essential in the SPAWNER's spawn logic, especially when dealing with multiple zones. It processes the subzone data
-- from the `Zones.Sub` table, calculating the total 'Actual' spawn amounts for these subzones. The function also plays a role in
-- introducing randomness and variation in the spawn process. If debugging is enabled, it provides detailed information about the distribution
-- of spawns across the subzones. This step ensures that spawn logic accommodates both the pre-configured settings and dynamic elements in gameplay.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_seedRollUpdates()
  -- Debugging header
  if SPECTRE.DebugEnabled == 1 then
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedRollUpdates                             | -------------------------------------------------------------------------")
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_seedRollUpdates                             | DISTRIBUTE RESULTS | TOTAL SPAWNS: %d", self.Zones.Main.SpawnAmountSettings.Generated.Actual))
  end

  if self.Benchmark == true then
    self.BenchmarkLog._seedRollUpdates = {Time = {},}
    self.BenchmarkLog._seedRollUpdates.Time.start = os.clock()
  end



  -- Initialize the keys table, spawnsManip_ table, and _spawnsManipTotal counter
  self.keys = {}
  self.spawnsManip_ = {}
  self._spawnsManipTotal = 0

  -- Iterate over subzones, extract keys, and accumulate spawn amounts
  for k, zoneObject in pairs(self.Zones.Sub) do
    table.insert(self.keys, k)
    self.spawnsManip_[k] = zoneObject.SpawnAmountSettings.Generated.Actual
    self._spawnsManipTotal = self._spawnsManipTotal + self.spawnsManip_[k]
  end
  if self.Benchmark == true then
    self.BenchmarkLog._seedRollUpdates.Time.stop = os.clock()
  end
  -- Return self for potential method chaining
  return self
end

--- Introduce randomness in the spawn distribution.
--
-- This function plays a key role in diversifying the spawn distribution across different subzones.
-- It adds a layer of randomness while adhering to the minimum and maximum constraints for each subzone
-- and the total spawn limit of the main zone. The randomness ensures a dynamic and unpredictable gameplay
-- experience by varying the number of spawns in each subzone. Debug information is provided if debugging is enabled,
-- offering insights into the randomized adjustments made during the spawn distribution process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_introduceRandomness()


  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_introduceRandomness | ---------------")
  if self.Benchmark == true then
    self.BenchmarkLog._introduceRandomness = {Time = {},}
    self.BenchmarkLog._introduceRandomness.Time.start = os.clock()
  end

  -- Iterate over the zones as defined by the nudge reciprocation number
  for _ = 1, self.Zones.Main.SpawnAmountSettings.Generated.NudgeRecip do
    local subZoneKey_ = self.keys[math.random(self.Zones.Main.numSubZones)]
    local random_value = math.random(-2, 2)
    local newActual = self.spawnsManip_[subZoneKey_] + random_value
    local newTotal = self._spawnsManipTotal + random_value

    -- Debug: Print the random value introduced
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_introduceRandomness                         | ZONE: %s  | Random Value         : %d", self.Zones.Sub[subZoneKey_].name, random_value))

    -- Check if the new actual value and the new total value are within the allowed range
    if newActual > self.Zones.Sub[subZoneKey_].SpawnAmountSettings.Generated.Min
      and newTotal <= self.Zones.Main.SpawnAmountSettings.Generated.Max
      and newActual < self.Zones.Sub[subZoneKey_].SpawnAmountSettings.Generated.Max then

      -- Debug: Print values before update
      SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_introduceRandomness                         | ZONE: %s  | Before SubZone Actual: %d | Before MainZone Total: %d", self.Zones.Sub[subZoneKey_].name, self.spawnsManip_[subZoneKey_], self._spawnsManipTotal))

      -- Update the actual value and the total value with the new randomized numbers
      self.spawnsManip_[subZoneKey_] = newActual
      self._spawnsManipTotal = newTotal

      -- Debug: Print values after update
      SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_introduceRandomness                         | ZONE: %s  | After SubZone Actual : %d | After MainZone Total : %d", self.Zones.Sub[subZoneKey_].name, self.spawnsManip_[subZoneKey_], self._spawnsManipTotal))
    end
  end
  if self.Benchmark == true then
    self.BenchmarkLog._introduceRandomness.Time.stop = os.clock()
  end
  -- Return self for potential method chaining
  return self
end

--- Distribute difference in spawn amounts across subzones.
--
-- This function calculates the difference between the expected spawn amount for the main zone
-- and the total spawns across subzones. It then distributes this difference across the subzones
-- to ensure the total spawn amount matches the expected value for the main zone. Debug information
-- can be printed if `SPECTRE.DebugEnabled` is set to 1.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_distributeDifference()


  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_distributeDifference | ---------------")
  if self.Benchmark == true then
    self.BenchmarkLog._distributeDifference = {Time = {},}
    self.BenchmarkLog._distributeDifference.Time.start = os.clock()
  end

  -- Calculate the difference between the expected and current total spawn amount
  local difference = self.Zones.Main.SpawnAmountSettings.Generated.Actual - self._spawnsManipTotal

  -- Debug: Print the calculated difference
  SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_distributeDifference                        | ZONE: %s  | DIFFERENCE           : %d", self.Zones.Main.name, difference))

  -- Distribute the difference across the subzones
  for _ = 1, math.abs(difference) do
    local subZoneKey_ = self.keys[math.random(self.Zones.Main.numSubZones)]
    local _val = (difference > 0 and 1 or -1) -- Determine if we need to add or subtract

    -- Debug: Print changes before and after distribution
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_distributeDifference                        | ZONE: %s  | Change Value         : %d", self.Zones.Sub[subZoneKey_].name, _val))
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_distributeDifference                        | ZONE: %s  | Before SubZone Actual: %d | Before MainZone Total: %d", self.Zones.Sub[subZoneKey_].name, self.spawnsManip_[subZoneKey_], self._spawnsManipTotal))

    -- Update the spawn amounts for the subzone and the total
    self.spawnsManip_[subZoneKey_] = self.spawnsManip_[subZoneKey_] + _val
    self._spawnsManipTotal = self._spawnsManipTotal + _val

    -- Debug: Print updated values
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_distributeDifference                        | ZONE: %s  | After SubZone Actual : %d | After MainZone Total : %d", self.Zones.Sub[subZoneKey_].name, self.spawnsManip_[subZoneKey_], self._spawnsManipTotal))
  end
  if self.Benchmark == true then
    self.BenchmarkLog._distributeDifference.Time.stop = os.clock()
  end
  -- Return self for potential method chaining
  return self
end

--- Execute a sequence of updates on the SPECTRE.SPAWNER object.
--
-- This function orchestrates a series of method calls to update the `SPECTRE.SPAWNER` object.
-- It sequentially executes the following methods:
-- 1. `_seedRollUpdates` - Initiates updates based on seed rolls.
-- 2. `_introduceRandomness` - Injects randomness into the spawning process.
-- 3. `_distributeDifference` - Balances spawn distribution across subzones.
-- 4. `_assignAndUpdateSubZones` - Assigns spawns and updates subzone details.
-- This method chain is crucial for maintaining the operational integrity and dynamic behavior of the spawner.
-- If enabled, benchmark timing for this process is recorded for performance analysis.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_RollUpdates()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_RollUpdates | ---------------")
  if self.Benchmark == true then
    self.BenchmarkLog._RollUpdates = {Time = {},}
    self.BenchmarkLog._RollUpdates.Time.start = os.clock()
  end
  -- Chain together method calls for update

  self:_seedRollUpdates():_introduceRandomness():_distributeDifference():_assignAndUpdateSubZones()

  if self.Benchmark == true then
    self.BenchmarkLog._RollUpdates.Time.stop = os.clock()
  end

  return self
end


--- Assign computed values to subzones and perform updates.
--
-- This function takes computed values stored in `self.spawnsManip_` and applies them to the subzones.
-- It updates the generation thresholds of each subzone, applies clamping to these thresholds, and then verifies
-- the overall totals for consistency. If `SPECTRE.DebugEnabled` is set to 1, debug information is generated,
-- detailing the operations performed on each subzone, including updates to spawn totals and threshold adjustments.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_assignAndUpdateSubZones()
  -- Debug: Print header
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_assignAndUpdateSubZones | ASSIGN UPDATES")
  if self.Benchmark == true then
    self.BenchmarkLog._assignAndUpdateSubZones = {Time = {},}
    self.BenchmarkLog._assignAndUpdateSubZones.Time.start = os.clock()
  end


  -- Assign computed values to subzones and update them
  for zoneName, newActual in pairs(self.spawnsManip_) do
    -- Assign new actual spawn value
    self.Zones.Sub[zoneName].SpawnAmountSettings.Generated.Actual = newActual

    -- Debug: Print zone and new actual spawn total
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_assignAndUpdateSubZones | -------------------------------------------------")
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_assignAndUpdateSubZones | ZONE        | %s", zoneName))
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_assignAndUpdateSubZones | DISTRIBUTED | NEW ACTUAL SPAWN TOTAL | %d", newActual))

    -- Update generation thresholds and clamp them
    self.Zones.Sub[zoneName]:_UpdateGenThresholds()
    self:_thresholdClamp(zoneName)
  end

  -- Confirm the updated totals
  self:_confirmTotals()
  if self.Benchmark == true then
    self.BenchmarkLog._assignAndUpdateSubZones.Time.stop = os.clock()
  end
  -- Return self for potential method chaining
  return self
end

--- Adjust spawn values based on threshold violations.
--
-- This function assesses the spawn values of a specified subzone against its predefined thresholds
-- (maximum, minimum, and nominal). In cases where the spawn value exceeds or falls short of these thresholds,
-- adjustments are made by altering the spawn values of randomly selected subzones. This ensures that
-- the overall spawn values remain within acceptable limits. Debug information detailing the adjustment process
-- and the nature of threshold violations can be output if `SPECTRE.DebugEnabled` is set to 1.
--
-- @param #SPAWNER self
-- @param zoneName The name of the subzone being checked for threshold violations.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_thresholdClamp(zoneName)


  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_thresholdClamp | ---------------")
  local thresholds = self.Zones.Sub[zoneName].SpawnAmountSettings.Generated.Thresholds

  -- Check for threshold violations and adjust spawn values accordingly
  if thresholds.overMax > 0 or thresholds.underMin > 0 then
    local action, logAction, logMessage
    if thresholds.overMax > 0 then
      action = -1
      logAction = "REDUCING"
      logMessage = "OVER MAX SPAWNS"
    elseif thresholds.underMin > 0 then
      action = 1
      logAction = "INCREASING"
      logMessage = "UNDER MIN SPAWNS"
    elseif thresholds.overNom > 0 then
      action = -1
      logAction = "REDUCING"
      logMessage = "OVER NOM SPAWNS"
    elseif thresholds.underNom > 0 then
      action = 1
      logAction = "INCREASING"
      logMessage = "UNDER NOM SPAWNS"
    end

    -- Log the threshold violation and start adjustments
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_thresholdClamp | ZONE: %s | %s | Init Nudge", self.Zones.Main.name, logMessage))
    for _ = 1, math.abs(action * (thresholds.overMax + thresholds.underMin + thresholds.overNom + thresholds.underNom)) do
      local index = self.keys[math.random(#self.keys)]
      self.Zones.Sub[index].SpawnAmountSettings.Generated.Actual = self.Zones.Sub[index].SpawnAmountSettings.Generated.Actual + action
      SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_thresholdClamp | %s SUB ZONE: %s BY %d", logAction, index, action))
    end
  end

  -- Return self for potential method chaining
  return self
end

--- Confirm the total spawns across all subzones.
--
-- This function verifies that the sum of spawn values across all subzones aligns with the expected total
-- for the main zone. It iterates through each subzone, summing up their respective spawn values, and compares
-- this sum with the main zone's expected total spawn value. If `SPECTRE.DebugEnabled` is set to 1, it outputs
-- debug information, including the spawn totals for each subzone and the cumulative total, to facilitate monitoring
-- and verification of spawn distribution.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_confirmTotals()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_confirmTotals | ---------------")
  local confirmedTotal = 0

  for zoneName, zoneObj in pairs(self.Zones.Sub) do
    local currentZoneActual = zoneObj.SpawnAmountSettings.Generated.Actual

    if SPECTRE.DebugEnabled == 1 then
      -- Debug: Print details for the current subzone
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_confirmTotals | -------------------------------------------------")
      SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_confirmTotals | SUB ZONE    | %s", zoneName))
      SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_confirmTotals | DISTRIBUTED | SUB ZONE SPAWN TOTAL      | %d", currentZoneActual))
    end

    -- Update the confirmed total
    confirmedTotal = confirmedTotal + currentZoneActual
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_confirmTotals | DISTRIBUTED | NEW MAIN ZONE SPAWN TOTAL | %d", confirmedTotal))
  end

  if SPECTRE.DebugEnabled == 1 then
    -- Debug: Print details for the main zone
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_confirmTotals | MAIN ZONE          | %s", self.Zones.Main.name))
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_confirmTotals | -------------------------------------------------------------------------")
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:_confirmTotals | DISTRIBUTE RESULTS | Expected: %d | GOT: %d", self.Zones.Main.SpawnAmountSettings.Generated.Actual, confirmedTotal))
  end

  -- Return self for potential method chaining
  return self
end

--- Calculate and assign group types for a given zone.
--
-- This internal function generates the types of units for each group in a specified zone. It iterates
-- through the group settings of the zone, creating lists of unit types for each group based on the
-- specified sizes and available unit types. The function manages the allocation of unit types, ensuring
-- that the number of units of each type stays within the defined limits. It also handles the addition of
-- extra unit types to groups as specified in the zone's settings. Debug information is output for each step
-- of the process if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled.
--
-- @param #SPAWNER self
-- @param _zoneObject The zone object for which group types are being generated.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_generateGroupTypes(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog._generateGroupTypes then self.BenchmarkLog._generateGroupTypes = {} end
    self.BenchmarkLog._generateGroupTypes[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog._generateGroupTypes[_zoneObject.name].Time.start = os.clock()
  end

  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    -- Loop for the number of groups specified in the current setting.
    for _ = 1, setting.numGroups do
      -- List to store types for this group.
      local _UnitTypes = {}
      -- Loop for the size of the group + extra units.
      for _Unit = 1, setting.size do
        local typeToAdd  -- Variable to store the type to add for this iteration.
        local _TypeK

        -- Pick a random type.
        if SPECTRE.UTILS.sumTable(self.AllTypesManip_) > 0 then
          SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | AllTypesManip_ so pick from self.AllTypesManip_" , self.AllTypesManip_)
          _TypeK = SPECTRE.UTILS.PickRandomFromKVTable(self.AllTypesManip_)
        else
          SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | NOT AllTypesManip_ so pick from self.NonLimitedTypes" , self.NonLimitedTypes)
          _TypeK = SPECTRE.UTILS.PickRandomFromKVTable(self.NonLimitedTypes)
        end


        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | Selected Type:" , _TypeK)

        local randType = self.AllTypes[_TypeK]
        -- Increment the number used count for this type.
        randType.Actual = randType.Actual + 1
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | Selected Type Value self.AllTypes[_TypeK]:" , randType)

        if (randType.Actual >= randType.Max) then
          SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | Selected Type count is at max. Removing from possible choices.")
          SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | (randType.Actual >= randType.Max)")
          self.AllTypesManip_[_TypeK] = nil
        end

        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | Finalized Type to add:" ..  _TypeK)
        typeToAdd = _TypeK
        -- Add the selected type to the group types list, all types list, and the main AllTypes list.
        table.insert(_UnitTypes, typeToAdd)
      end

      for _type, _numType in pairs(_zoneObject.SpawnAmountSettings.ExtraTypesToGroups) do
        for _i = 1, _numType, 1 do
          table.insert(_UnitTypes, _type)
        end
      end
      table.insert(_groupTypes, _UnitTypes)
    end
    -- Add the group types list to the main group list for this iteration.
    setting.Types = _groupTypes
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | setting" , setting)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | _groupSettingIndex" ..  _groupSettingIndex)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | setting.Types" , setting.Types)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | setting.Types[_groupSettingIndex]" , setting.Types[_groupSettingIndex])
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTypes | _groupTypes" , _groupTypes)
  end
  if self.Benchmark == true then
    self.BenchmarkLog._generateGroupTypes[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Generate group templates for a specific zone object.
--
-- This function is tasked with creating templates for groups within a given zone. It iterates through the
-- group settings of the zone, assigning unit types to each group based on predefined settings and types.
-- The function ensures that each group is composed of a mix of unit types as specified in the zone's settings,
-- including any additional units. The final templates are then stored in the zone's group settings. Debug information
-- regarding the composition of each group is output if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded
-- if enabled, to monitor the performance of the template generation process.
--
-- @param #SPAWNER self
-- @param _zoneObject The zone object for which group templates are being generated.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_generateGroupTemplates(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_generateGroupTemplates | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog._generateGroupTemplates then self.BenchmarkLog._generateGroupTemplates = {} end
    self.BenchmarkLog._generateGroupTemplates[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog._generateGroupTemplates[_zoneObject.name].Time.start = os.clock()
  end
  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    -- Loop for the number of groups specified in the current setting.
    for _ = 1, setting.numGroups do
      -- List to store types for this group.
      local _UnitTypes = {}
      -- Loop for the size of the group + extra units.
      for _Unit = 1, setting.size + _zoneObject.SpawnAmountSettings.numExtraUnits do --+ self.Config
        local typeToAdd  -- Variable to store the type to add for this iteration.
        local lookUpType  = setting.Types[_][_Unit]
        -- Pick a random type.
        local _Table = SPECTRE.UTILS.Shuffle(self.AllTypes[lookUpType].GroupNames)
        local _TypeV = SPECTRE.UTILS.PickRandomFromTable(_Table)
        SPECTRE.UTILS.debugInfo("_TypeV" , _TypeV)
        typeToAdd = _TypeV
        -- Add the selected type to the group types list, all types list, and the main AllTypes list.
        table.insert(_UnitTypes, typeToAdd)
      end
      table.insert(_groupTypes, _UnitTypes)
    end
    -- Add the group types list to the main group list for this iteration.
    setting.Templates = _groupTypes
  end
  if self.Benchmark == true then
    self.BenchmarkLog._generateGroupTemplates[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Initialize and assign type settings for the SPAWNER.
--
-- This function populates the SPAWNER with various types based on the template settings.
-- It filters and adds types that meet specific criteria, such as having a maximum count greater than zero
-- and belonging to a group. The function calculates the ratio of each type against the total and categorizes
-- types as either limited or non-limited based on their settings. This seeding process is crucial for
-- ensuring a diverse and balanced mix of types for spawn generation. Debug information detailing the
-- types added and their properties is output if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing
-- is recorded if enabled, to track the performance of the seeding process.
--
-- @param #SPAWNER
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_seedTypes()
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    self.BenchmarkLog._seedTypes = {Time = {},}
    self.BenchmarkLog._seedTypes.Time.start = os.clock()
  end

  local _AllTypes = {}
  local _totalTypesMax = 0
  for _typeENUM, _templateType in pairs (self.TEMPLATETYPES_ ) do

    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | _typeENUM" , _typeENUM)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | _templateType" , _templateType)

    if (_templateType.Max > 0)
      and
      #_templateType.GroupNames > 0
    then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | NOT NIL SO ADD: ")
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | _typeENUM" , _typeENUM)
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | _templateType" , _templateType)
      _AllTypes[_typeENUM] = _templateType
      _totalTypesMax       = _totalTypesMax + _templateType.Max
    end
  end

  for _typeENUM, _templateType in pairs (_AllTypes ) do
    _templateType.RatioMax = _templateType.Max/_totalTypesMax or 0
  end

  self._totalTypesMax = _totalTypesMax
  self.AllTypes = _AllTypes

  for _k, _v in pairs(self.AllTypes) do
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | ADD AllTypesManip_  | " , _k)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes | value:  | " , _v)
    self.AllTypesManip_[_k] = _v
    if _v.limited == true then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes |ADD LimitedTypes  | " , _k)
      self.LimitedTypes[_k] = _v
    else
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_seedTypes |ADD NonLimitedTypes  | " , _k)
      self.NonLimitedTypes[_k] = _v
    end
  end

  if self.Benchmark == true then
    self.BenchmarkLog._seedTypes.Time.stop = os.clock()
  end

  return self
end


--- Create and return a group settings object based on the provided size and group spacing configurations.
--
-- This function constructs a group settings object for a specified group size. It uses provided
-- spacing configurations for groups and units within those groups. The function calculates the minimum
-- and maximum separations for both groups and units, incorporating specific settings for the group size,
-- or defaulting to general settings if specific ones are not available. The created group settings object
-- is then configured with these spacing parameters, along with the number of groups and their sizes.
--
-- @param #SPAWNER self The instance of the SPAWNER class.
-- @param size The size of the group.
-- @param numGroupSize The number of groups of the specified size.
-- @param SpacingSettings_ The spacing settings for groups.
-- @return #GroupSettings_ A new group settings object with the specified configurations.
function SPECTRE.SPAWNER:_createGroupSettings(size, numGroupSize, SpacingSettings_)
  local groupsMinSeperation   = SpacingSettings_[size].Groups.minSeperation or SpacingSettings_.General.Groups.minSeperation
  local groupsMaxSeperation   = SpacingSettings_[size].Groups.maxSeperation or SpacingSettings_.General.Groups.maxSeperation
  local unitsMinSeperation    = SpacingSettings_[size].Units.minSeperation  or SpacingSettings_.General.Units.minSeperation
  local unitsMaxSeperation    = SpacingSettings_[size].Units.maxSeperation  or SpacingSettings_.General.Units.maxSeperation
  local distanceFromBuildings = SpacingSettings_[size].distanceFromBuildings or SpacingSettings_.General.DistanceFromBuildings

  return self.GroupSettings_:New():setGroupSettings(size, numGroupSize, groupsMinSeperation, groupsMaxSeperation, unitsMinSeperation, unitsMaxSeperation, distanceFromBuildings)
end


--- Set the vector positions for unit templates within each group of a zone.
--
-- This function is responsible for determining the specific vector positions (`Vec2`) for unit templates within each group
-- of a given zone. It iterates through each group setting within the zone, calculating potential positions for units while
-- adhering to specified separation requirements and checking against restricted areas. This process ensures that units are
-- appropriately spaced both within their groups and relative to other groups and restricted zones. The function generates
-- and stores these vector positions for use in subsequent spawning processes. Debug information is output detailing
-- the placement process if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled, to track the
-- efficiency of the vector positioning process.
--
-- @param #SPAWNER self
-- @param _zoneObject The zone object for which unit template positions are being set.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Set_Vec2_UnitTemplates(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Set_Vec2_UnitTemplates | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog.Set_Vec2_UnitTemplates then self.BenchmarkLog.Set_Vec2_UnitTemplates = {} end
    self.BenchmarkLog.Set_Vec2_UnitTemplates[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog.Set_Vec2_UnitTemplates[_zoneObject.name].Time.start = os.clock()
  end
  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    local _groupTypesobj = {}
    -- Loop for the number of groups specified in the current setting.
    for _groupIndex = 1, setting.numGroups do
      local tempZoneName = _zoneObject.name .. "z" .. _groupSettingIndex .. "j" .. _groupIndex
      local tempZoneVec2 = setting.GroupCenters[_groupIndex]

      local tempZoneRadius = (setting.seperation.units.max * setting.size) +
        (setting.seperation.groups.min * setting.numGroups) +
        setting.distanceFromBuildings

      setting.ZoneObjects[_groupIndex] = ZONE_RADIUS:New(tempZoneName, tempZoneVec2, tempZoneRadius)
      local _tempZoneObject = setting.ZoneObjects[_groupIndex]
      local objectCoords = self.FindObjectsInZone(_tempZoneObject)
      -- List to store types for this group.
      local _UnitTypes = {}
      --local _UnitTypesobj = {}

      -- Loop for the size of the group + extra units.
      for _Unit = 1, setting.size + _zoneObject.SpawnAmountSettings.numExtraUnits do --+ self.Config.numExtraUnits
        local possibleVec2
        local flag_goodcoord = true
        local glassBreak = 0

        repeat
          flag_goodcoord = true
          possibleVec2 = _tempZoneObject:GetRandomVec2()

          if flag_goodcoord then flag_goodcoord = self.checkNOGO(self, possibleVec2, self.Zones.Restricted) end

          if flag_goodcoord then
            for _, coords in pairs(objectCoords) do
              local distance = coords == "units" and setting.seperation.units.min or setting.distanceFromBuildings
              for _, checkCoord in ipairs(coords) do
                if SPECTRE.WORLD.f_distance(checkCoord, possibleVec2) < distance then
                  flag_goodcoord = false
                  break
                end
              end
              if not flag_goodcoord then break end
            end
          end

          if glassBreak >= self.Config.operationLimit then
            flag_goodcoord = true
          end
          glassBreak = glassBreak + 1
        until flag_goodcoord

        -- Add the selected type
        objectCoords.units[#objectCoords.units + 1] = possibleVec2
        table.insert(_UnitTypes, possibleVec2)
      end
      table.insert(_groupTypesobj, objectCoords)
      table.insert(_groupTypes, _UnitTypes)
    end
    -- Add the group types list to the main group list for this iteration.
    setting.TemplateCoords = _groupTypes
    setting.ObjectCoords = _groupTypesobj
  end

  if self.Benchmark == true then
    self.BenchmarkLog.Set_Vec2_UnitTemplates[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Set up spawn groups for a specific zone object.
--
-- This internal function configures the spawn groups for a given zone within the SPAWNER system.
-- It iterates through each group setting in the zone, creating spawn groups based on the predefined
-- templates, types, and vector positions. The function manages the creation and configuration of these
-- groups, ensuring they are properly initialized with the correct coalition, country, and heading.
-- Debug information is output for each group's configuration details if `SPECTRE.DebugEnabled` is set to 1.
-- Benchmark timing is recorded if enabled, to track the performance of the group setup process.
--
-- @param #SPAWNER
-- @param _zoneObject The zone object for which spawn groups are being set up.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:_SetupSpawnGroups(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog._SetupSpawnGroups then self.BenchmarkLog._SetupSpawnGroups = {} end
    self.BenchmarkLog._SetupSpawnGroups[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog._SetupSpawnGroups[_zoneObject.name].Time.start = os.clock()
  end
  local typeCounter = SPECTRE.COUNTER--self.COUNTER
  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    -- Loop for the number of groups specified in the current setting.
    for _groupIndex = 1, setting.numGroups do
      -- List to store types for this group.
      local _UnitTypes = {}

      -- Loop for the size of the group + extra units.
      for _Unit = 1, setting.size + _zoneObject.SpawnAmountSettings.numExtraUnits do --+ self.Config.numExtraUnits
        local _vec2 = setting.TemplateCoords[_groupIndex][_Unit]
        local _TemplateName = setting.Templates[_groupIndex][_Unit]
        local _TypeName = setting.Types[_groupIndex][_Unit]
        local _SPAWNNAME = self.PREFIX .. _TypeName

        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _Spawn")
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _vec2", _vec2)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _TemplateName", _TemplateName)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _TypeName", _TypeName)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _SPAWNNAME", _SPAWNNAME)

        local tempCode = typeCounter
        local FoundGroup
        repeat
          FoundGroup = GROUP:FindByName(_SPAWNNAME .. "_" .. tempCode .. "#001")
          if FoundGroup then
            tempCode = tempCode + 1
          else
            FoundGroup = false
          end
        until (FoundGroup == false)
        typeCounter = tempCode

        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | GROUP ------------------------------------")
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | Name          : ".. _SPAWNNAME .. "_" .. tempCode)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _TemplateName : ".. _TemplateName)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _vec2.x       : ".. _vec2.x .. " | _vec2.y : ".. _vec2.y)
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | spawnCoalition: " .. tostring(self.spawnCoalition))
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | spawnCountry  : " .. tostring(self.spawnCountry))

        local _spawnunit = SPAWN:NewWithAlias(_TemplateName, _SPAWNNAME .. "_" .. tempCode)
          :InitCoalition(self.spawnCoalition)
          :InitCountry(self.spawnCountry)
          :InitHeading(0,364)

        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:_SetupSpawnGroups | _spawnunit" , _spawnunit)
        typeCounter = typeCounter + 1
        -- Add the selected type to the group types list, all types list, and the main AllTypes list.
        table.insert(_UnitTypes, _spawnunit)
        --table.insert(_UnitTypesobj, objectCoords)
      end
      table.insert(_groupTypes, _UnitTypes)
    end
    -- Add the group types list to the main group list for this iteration.
    setting.SpawnedGROUPS = _groupTypes
  end
  SPECTRE.COUNTER = typeCounter
  if self.Benchmark == true then
    self.BenchmarkLog._SetupSpawnGroups[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Set the central vector positions for groups within a zone.
--
-- This function calculates and assigns central vector positions (`Vec2`) for each group in a given zone
-- object. It iterates through the group settings of the zone, determining suitable central positions for
-- the groups while respecting separation constraints from other units, groups, and restricted zones.
-- The function ensures that each group center is appropriately located, facilitating organized and
-- strategically placed spawns. Debug information is output detailing the process of finding these central
-- positions if `SPECTRE.DebugEnabled` is set to 1. Benchmark timing is recorded if enabled, to track the
-- efficiency of the positioning process.
--
-- @param #SPAWNER self
-- @param _zoneObject The zone object for which group centers are being set.
-- @return #SPAWNER self
function SPECTRE.SPAWNER:Set_Vec2_GroupCenters(_zoneObject)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:Set_Vec2_GroupCenters | -------------------------------------------------------------------------")
  if self.Benchmark == true then
    if not self.BenchmarkLog.Set_Vec2_GroupCenters then self.BenchmarkLog.Set_Vec2_GroupCenters = {} end
    self.BenchmarkLog.Set_Vec2_GroupCenters[_zoneObject.name] = {Time = {},}
    self.BenchmarkLog.Set_Vec2_GroupCenters[_zoneObject.name].Time.start = os.clock()
  end
  -- Loop through each group setting.
  for _groupSettingIndex, setting in ipairs(_zoneObject.GroupSettings) do
    local _groupTypes = {}
    -- Loop for the number of groups specified in the current setting.
    for _ = 1, setting.numGroups do
      local glassBreak = 0
      local possibleVec2
      local flag_goodcoord = true

      repeat
        flag_goodcoord = true
        possibleVec2 = _zoneObject.Object:GetRandomVec2()
        if flag_goodcoord then flag_goodcoord = self.checkNOGO(self, possibleVec2, self.Zones.Restricted) end

        if flag_goodcoord then
          for _, coords in pairs(_zoneObject.ObjectCoords) do
            local distance
            if coords == "units" then
              distance = setting.seperation.units.min
            elseif coords == "groupcenters" then
              distance = setting.seperation.groups.min
            else
              distance = setting.distanceFromBuildings
            end
            if coords == "groupcenters" then
              for _, checkCoord in ipairs(_zoneObject.ObjectCoords[coords]) do
                if SPECTRE.WORLD.f_distance(checkCoord, possibleVec2) < distance then
                  flag_goodcoord = false
                  break
                end
              end
            end
            if not flag_goodcoord then break end
          end
        end

        if glassBreak >= self.Config.operationLimit then
          flag_goodcoord = true
        end
        glassBreak = glassBreak + 1
      until flag_goodcoord

      _zoneObject.ObjectCoords.groupcenters[#_zoneObject.ObjectCoords.groupcenters + 1] = possibleVec2
      table.insert(_groupTypes, possibleVec2)
    end
    -- Add the group types list to the main group list for this iteration.
    setting.GroupCenters = _groupTypes
  end
  if self.Benchmark == true then
    self.BenchmarkLog.Set_Vec2_GroupCenters[_zoneObject.name].Time.stop = os.clock()
  end
  return self
end

--- Blueprint for template type objects in the `SPECTRE.SPAWNER` system.
-- This table outlines the basic structure and attributes that a template type object should possess.
-- @field #SPAWNER.templateTypesObject
SPECTRE.SPAWNER.templateTypesObject = {
  -- The priority value for the template type. Determines precedence in certain operations.
  _Priority = 0,
  -- A collection of group names associated with this template type.
  GroupNames = {},
  -- The actual value or count of the template type in a given context.
  Actual = 0,
  -- The nominal or standard value for the template type.
  Nominal = 0,
  -- The maximum allowable value or count for the template type.
  Max = 0,
  -- The minimum allowable value or count for the template type.
  Min = 0,
  -- Ratio used to calculate the maximum value relative to the nominal.
  RatioMax = 0,
  -- Ratio used to calculate the minimum value relative to the nominal.
  RatioMin = 0,
  -- Ratio used to adjust the nominal value under certain conditions.
  RatioNominal = 0,
  -- Flag indicating whether the template type has a limit on its usage or spawn count.
  limited = false
}

--- Create a new templateTypesObject.
--
-- This constructor function initializes a new instance of the templateTypesObject within the SPAWNER system.
-- It sets up the object with a given priority and initializes default values for its properties,
-- including group names and nominal, maximum, and minimum counts. This object is essential for managing
-- and organizing template types based on their priority and other characteristics.
--
-- @param #SPAWNER.templateTypesObject self The instance of the templateTypesObject being created.
-- @param Priority The priority level assigned to the template type object, with a default value of 0 if not specified.
-- @return #SPAWNER.templateTypesObject self The newly created instance of templateTypesObject with the specified priority.
-- @usage local newObj = SPECTRE.SPAWNER.templateTypesObject:New(1) -- Creates a new templateTypesObject with priority 1.
function SPECTRE.SPAWNER.templateTypesObject:New(Priority)
  local self = BASE:Inherit(self, SPECTRE:New())

  -- Set the provided priority and initialize default values for other properties
  self._Priority = Priority or 0
  self.GroupNames = {}
  self.Nominal = 0
  self.Max = 0
  self.Min = 0

  return self
end




--- Group settings for the SPECTRE spawner system.
-- This structure defines the configuration settings for groups in the dynamic spawning mechanism.
-- It controls aspects such as group size, number of groups, separation between entities, and distances from landmarks like buildings.
-- @field #SPAWNER.GroupSettings_
SPECTRE.SPAWNER.GroupSettings_ = {
  -- The size of the group.
  size = 0,
  -- The number of groups.
  numGroups = 0,
  -- Separation distances for groups and units within groups.
  seperation = {
    groups = {
      -- Minimum separation distance between groups.
      min = 0,
      -- Maximum separation distance between groups.
      max = 0
    },
    units = {
      -- Minimum separation distance between units within a group.
      min = 0,
      -- Maximum separation distance between units within a group.
      max = 0
    }
  },
  -- The minimum distance from buildings for spawning.
  distanceFromBuildings = 0,
  -- Storage for types assigned to this group.
  Types = {},
  -- Storage for template types assigned to this group.
  Templates = {},
  -- Coordinates for the center of each group.
  GroupCenters = {},
  -- Generated zone objects for each group.
  ZoneObjects = {},
  -- Coordinates for templates within each group.
  TemplateCoords = {},
  -- Coordinates for objects within each group.
  ObjectCoords = {},
  -- Spawned group objects.
  SpawnedGROUPS = {},
  -- Scheduler for spawning groups.
  SpawnScheduler = {}
}

--- Create a new instance of GroupSettings for the SPECTRE spawner system.
--
-- This constructor function initializes a new instance of GroupSettings, a component of the SPECTRE spawner system.
-- The newly created object is tailored to manage and configure group settings
-- for spawn operations, which is essential for controlling the characteristics and behavior of spawned groups.
--
-- @param #SPAWNER.GroupSettings_
-- @return #SPAWNER.GroupSettings_ self The newly initialized GroupSettings instance.
function SPECTRE.SPAWNER.GroupSettings_:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  return self
end

--- Set the configurations for a group within the SPECTRE.SPAWNER.GroupSettings_ object.
--
-- This function configures the settings for a group in the SPAWNER system. It defines various parameters
-- such as the size of the group, the number of such groups, and the separation distances between groups
-- and individual units within them. Additionally, it sets the minimum required distance from nearby buildings.
-- These settings are crucial for managing the spatial arrangement and behavior of spawned groups. The function
-- returns the updated `GroupSettings_` object with these configurations.
--
-- @param #SPAWNER.GroupSettings_ self The instance of the GroupSettings being configured.
-- @param size The size of the group.
-- @param numGroups The number of groups of the specified size.
-- @param groupsMinSeperation The minimum separation distance between groups.
-- @param groupsMaxSeperation The maximum separation distance between groups.
-- @param unitsMinSeperation The minimum separation distance between units within a group.
-- @param unitsMaxSeperation The maximum separation distance between units within a group.
-- @param distanceFromBuildings The minimum distance from nearby buildings.
-- @return #SPAWNER.GroupSettings_ self The updated GroupSettings object.
-- @usage local groupSettings = SPECTRE.SPAWNER.GroupSettings_:setGroupSettings(size, numGroups, groupsMinSeperation, groupsMaxSeperation, unitsMinSeperation, unitsMaxSeperation, distanceFromBuildings) -- Configures and returns group settings.
function SPECTRE.SPAWNER.GroupSettings_:setGroupSettings(size, numGroups, groupsMinSeperation, groupsMaxSeperation, unitsMinSeperation, unitsMaxSeperation, distanceFromBuildings)
  self.size = size
  self.numGroups = numGroups
  self.seperation = {
    groups = {min = groupsMinSeperation, max = groupsMaxSeperation},
    units = {min = unitsMinSeperation, max = unitsMaxSeperation},
  }
  self.distanceFromBuildings = distanceFromBuildings
  return self
end

--- 3 - TEMPLATETYPES_.
-- ===
--
-- *All TEMPLATETYPES_.*
--
-- ===
-- @section SPECTRE.SPAWNER

--- Definitions and attributes for template types in the `SPECTRE.SPAWNER` system.
--
-- This table defines the properties and attributes associated with template types in the `SPECTRE.SPAWNER` system.
-- It provides a mapping of different unit and vehicle types to their associated template objects.
--
-- @field #SPAWNER.TEMPLATETYPES_
SPECTRE.SPAWNER.TEMPLATETYPES_ = {}
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Ships]               = SPECTRE.SPAWNER.templateTypesObject:New(91)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.UnarmedShips]        = SPECTRE.SPAWNER.templateTypesObject:New(92)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.ArmedShips]          = SPECTRE.SPAWNER.templateTypesObject:New(93)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.LightArmedShips]     = SPECTRE.SPAWNER.templateTypesObject:New(94)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.HeavyArmedShips]     = SPECTRE.SPAWNER.templateTypesObject:New(95)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Corvettes]           = SPECTRE.SPAWNER.templateTypesObject:New(96)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Frigates]            = SPECTRE.SPAWNER.templateTypesObject:New(97)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Destroyers]          = SPECTRE.SPAWNER.templateTypesObject:New(98)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Cruisers]            = SPECTRE.SPAWNER.templateTypesObject:New(99)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.AircraftCarriers]    = SPECTRE.SPAWNER.templateTypesObject:New(100)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.GroundUnits]         = SPECTRE.SPAWNER.templateTypesObject:New(35)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Infantry]            = SPECTRE.SPAWNER.templateTypesObject:New(37)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.LightArmoredUnits]   = SPECTRE.SPAWNER.templateTypesObject:New(40)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.IFV]                 = SPECTRE.SPAWNER.templateTypesObject:New(53)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.APC]                 = SPECTRE.SPAWNER.templateTypesObject:New(54)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Artillery]           = SPECTRE.SPAWNER.templateTypesObject:New(51)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.MLRS]                = SPECTRE.SPAWNER.templateTypesObject:New(52)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.HeavyArmoredUnits]   = SPECTRE.SPAWNER.templateTypesObject:New(45)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.ModernTanks]         = SPECTRE.SPAWNER.templateTypesObject:New(57)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.OldTanks]            = SPECTRE.SPAWNER.templateTypesObject:New(56)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Tanks]               = SPECTRE.SPAWNER.templateTypesObject:New(55)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Buildings]           = SPECTRE.SPAWNER.templateTypesObject:New(65)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Fortifications]      = SPECTRE.SPAWNER.templateTypesObject:New(60)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.GroundVehicles]      = SPECTRE.SPAWNER.templateTypesObject:New(30)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.AAA]                 = SPECTRE.SPAWNER.templateTypesObject:New(71)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.AA_flak]             = SPECTRE.SPAWNER.templateTypesObject:New(73)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.StaticAAA]           = SPECTRE.SPAWNER.templateTypesObject:New(72)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.MobileAAA]           = SPECTRE.SPAWNER.templateTypesObject:New(75)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.EWR]                 = SPECTRE.SPAWNER.templateTypesObject:New(86)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.UnarmedVehicles]     = SPECTRE.SPAWNER.templateTypesObject:New(21)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Cars]                = SPECTRE.SPAWNER.templateTypesObject:New(25)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.Trucks]              = SPECTRE.SPAWNER.templateTypesObject:New(27)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.SamElements]         = SPECTRE.SPAWNER.templateTypesObject:New(80)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.IRGuidedSam]         = SPECTRE.SPAWNER.templateTypesObject:New(84)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.SRsam]               = SPECTRE.SPAWNER.templateTypesObject:New(81)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.MRsam]               = SPECTRE.SPAWNER.templateTypesObject:New(82)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.LRsam]               = SPECTRE.SPAWNER.templateTypesObject:New(83)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.ArmedGroundUnits]    = SPECTRE.SPAWNER.templateTypesObject:New(32)
---.
SPECTRE.SPAWNER.TEMPLATETYPES_[SPECTRE.SPAWNER.typeENUMS.MANPADS]             = SPECTRE.SPAWNER.templateTypesObject:New(85)

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **UTILS**
--
--  Assorted utilities.
--
-- ===
--
-- @module UTILS
-- @extends SPECTRE

--- SPECTRE.UTILS.
--
-- @section UTILS
-- @field #UTILS
SPECTRE.UTILS = {}

--- Placeholder function that performs no actions.
--
-- This function exists as a placeholder or stub and doesn't execute any operations when called.
-- It can be used as a default callback or to indicate that a particular action is intentionally left blank.
--
-- @usage SPECTRE.UTILS.NULL() -- Executes no actions.
function SPECTRE.UTILS.NULL()
  -- Placeholder function: No operations performed here.
  return
end

--- Table Utilities.
-- ===
--
-- *All Functions associated with Table operations.*
--
-- ===
-- @section SPECTRE.UTILS


--- Safely insert a value into a table without duplicates.
--
-- Inserts the specified value into the table only if it doesn't already exist in the table.
--
-- @param tbl The table in which the value will be inserted.
-- @param value The value to be inserted into the table.
-- @usage SPECTRE.UTILS.safeInsert(myTable, "newValue") -- Inserts "newValue" into myTable only if it doesn't exist.
function SPECTRE.UTILS.safeInsert(tbl, value)
  for _, v in pairs(tbl) do
    if v == value then
      return
    end
  end
  table.insert(tbl, value)
end

--- Remove matching entries from table A based on table B.
--
-- Iterates through table A and removes any entries that match any entry in table B.
--
-- @param A The main table from which entries will be removed.
-- @param B The reference table used to determine which entries to remove from table A.
-- @return A The modified table A after removing the matching entries.
-- @usage local modifiedA = SPECTRE.UTILS.removeMatchingEntries({1, 2, 3, 4, 5}, {2, 4}) -- Returns {1, 3, 5}.
function SPECTRE.UTILS.removeMatchingEntries(A, B)
  local BSet = {}
  for i = 1, #B do
    BSet[B[i]] = true
  end

  local i = 1
  while i <= #A do
    if BSet[A[i]] then
      table.remove(A, i)
    else
      i = i + 1
    end
  end
  return A
end

--- Finds elements in a master list that are not present in two given sublists.
--
-- This function identifies elements in the 'Master_' list that are not found in either 'subListA_' or 'subListB_'.
-- It uses a helper function 'isInList' to check for element presence in the sublists.
--
-- @param subListA_ The first sublist to check against the master list.
-- @param subListB_ The second sublist to check against the master list.
-- @param Master_ The master list from which elements are to be checked.
-- @return result A list of elements from 'Master_' not found in either 'subListA_' or 'subListB_'.
-- @usage local unusedElements = SPECTRE.UTILS.findUnusedElements({1, 2, 3}, {4, 5, 6}, {1, 2, 3, 4, 5, 6, 7, 8}) -- Returns {7, 8}.
function SPECTRE.UTILS.findUnusedElements(subListA_, subListB_, Master_)
  local result = {}
  local foundInAorB

  -- Function to check if an element is in a given list
  local function isInList(element, list)
    for _, value in ipairs(list) do
      if value == element then
        return true
      end
    end
    return false
  end

  -- Iterate through each element in Master_
  for _, element in ipairs(Master_) do
    -- Check if the element is in subListA_ or subListB_
    foundInAorB = isInList(element, subListA_) or isInList(element, subListB_)

    -- If the element is not found in subListA_ or B, add it to the result
    if not foundInAorB then
      table.insert(result, element)
    end
  end

  return result
end

--- Check if a table contains a specific key.
--
-- Determines if a given key exists within the specified table.
--
-- @param tbl The table to check.
-- @param targetKey The key to search for.
-- @return boolean True if the key exists, false otherwise.
-- @usage local exists = SPECTRE.UTILS.table_contains(someTable, "someKey") -- Checks if "someKey" exists in someTable.
function SPECTRE.UTILS.table_contains(tbl, targetKey)
  return tbl[targetKey] ~= nil
end

--- Check if a table contains a specific value.
--
-- Determines if a given key exists within the specified table.
--
-- @param tbl The table to check.
-- @param val The key to search for.
-- @return boolean True if the key exists, false otherwise.
function SPECTRE.UTILS.table_hasValue(tbl, val)
  for index, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

--- Gets # keys for K,V pair object.
--
-- Used for non numerically indexed tables
--
-- @param t The table to check.
-- @return sum Number of keys in the table.
function SPECTRE.UTILS.sumTable(t)
  local sum = 0
  for k, v in pairs(t) do
    sum = sum + 1
  end
  return sum
end

--- Deeply merge two tables.
--
-- Recursively merges two tables, with values from the second table taking precedence.
--
-- @param t1 The first table.
-- @param t2 The second table from which values will be copied/overwritten to the first table.
-- @return t1 The merged table.
-- @usage local mergedTable = SPECTRE.UTILS.merge(baseTable, updateTable) -- Merges baseTable with updateTable.
function SPECTRE.UTILS.merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      SPECTRE.UTILS.merge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

--- Count occurrences of each value in a table.
--
-- Counts the number of times each value appears in the table.
--
-- @param t The table containing values to be counted.
-- @return counts A table with keys as the unique values from t and values as their respective counts.
-- @usage local counts = SPECTRE.UTILS.CountValues({1, 2, 2, 3, 3, 3}) -- Returns {1=1, 2=2, 3=3}.
function SPECTRE.UTILS.CountValues(t)
  local counts = {}
  for _, v in ipairs(t) do
    counts[v] = (counts[v] or 0) + 1
  end
  return counts
end

--- Shuffle the elements of a table.
--
-- Creates a shuffled copy of the input table using the Fisher-Yates algorithm.
--
-- @param t The table to be shuffled.
-- @return s A shuffled copy of the input table.
-- @usage local shuffled = SPECTRE.UTILS.Shuffle({1, 2, 3, 4, 5}) -- Returns a shuffled version of the input list.
function SPECTRE.UTILS.Shuffle(t)
  math.random()
  math.random()
  local s = {}
  for i = 1, #t do
    s[i] = t[i]
  end
  for i = #s, 2, -1 do
    local j = math.random(i)  -- Random index from 1 to i
    s[i], s[j] = s[j], s[i]   -- Swap elements at indices i and j
  end
  return s
end

--- Pick a random element from a table.
--
-- Selects and returns a random element from the provided table.
--
-- @param t The table from which to pick a random element.
-- @return element The randomly selected element from the table.
-- @usage local randomElement = SPECTRE.UTILS.PickRandomFromTable({1, 2, 3, 4, 5}) -- Returns a random number from the input list.
function SPECTRE.UTILS.PickRandomFromTable(t)
  math.random()
  math.random()
  return t[math.random(#t)]
end

--- Pick a random key from a KV table.
--
-- Selects and returns a random key from the provided table.
--
-- @param t The table from which to pick a random element.
-- @return key The randomly selected element from the table.
-- @usage local randomElement = SPECTRE.UTILS.PickRandomFromTable({1, 2, 3, 4, 5}) -- Returns a random number from the input list.
function SPECTRE.UTILS.PickRandomFromKVTable(t)
  math.random()
  math.random()
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  local keys = SPECTRE.UTILS.Shuffle(keys)
  return keys[math.random(#keys)]
end

--- Get the index of a value in a table.
--
-- Searches for the first occurrence of the specified value in the table and returns its index.
--
-- @param tab The table to search.
-- @param val The value to search for.
-- @return i The index of the value in the table, or nil if not found.
-- @usage local index = SPECTRE.UTILS.getIndex({10, 20, 30, 40}, 30) -- Returns 3.
function SPECTRE.UTILS.getIndex(tab, val)
  for i, v in ipairs(tab) do
    if v == val then
      return i
    end
  end
  return nil
end

--- Removes a specified substring from a given string.
--
-- This function eliminates all occurrences of 'substr' from 'str'. It handles special characters in the substring by escaping them before removal. The removal process uses Lua's string.gsub function.
--
-- @param str The original string from which the substring is to be removed.
-- @param substr The substring that needs to be removed from 'str'.
-- @return modifiedStr The modified string with 'substr' removed.
-- @usage local modifiedString = SPECTRE.UTILS.removeSubstring("Hello world", "world") -- Returns "Hello ".
function SPECTRE.UTILS.removeSubstring(str, substr)
  -- Pattern escape to handle special characters in the substring.
  local escapedSubstr = string.gsub(substr, "([%W])", "%%%1")

  -- Use gsub to replace all occurrences of the substring with an empty string.
  local modifiedStr = string.gsub(str, escapedSubstr, "")

  return modifiedStr
end

--- Game Manipulation.
-- ===
--
-- *All Functions associated with Game Manipulation operations.*
--
-- ===
-- @section SPECTRE.UTILS

---Get all type attributes related to all units in a group.
-- @param GroupName_ String name of group
-- @return _groupAttributes
function SPECTRE.UTILS.GetGroupAttributes(GroupName_)
  local _groupAttributes = {}
  local _GROUPunits = GROUP:FindByName(GroupName_):GetUnits()
  for _, _unitOb in pairs(_GROUPunits) do
    local _UNIT = Unit.getByName(_unitOb.UnitName)
    local _UNITtype = _UNIT:getTypeName()
    local _UNITDesc = Unit.getDescByName(_UNITtype)
    local _UNITAttributes = _UNITDesc.attributes
    for _k, _v in pairs (_UNITAttributes) do
      SPECTRE.UTILS.safeInsert(_groupAttributes, _k)
    end
  end
  return _groupAttributes
end

---Get all type attributes related to all units in a group.
-- @param UnitName_ String name of group
-- @return _UNITAttributes
function SPECTRE.UTILS.GetUnitAttributes(UnitName_)
  local _UNIT = Unit.getByName(UnitName_)
  local _UNITtype = _UNIT:getTypeName()
  local _UNITDesc = Unit.getDescByName(_UNITtype)
  local _UNITAttributes = _UNITDesc.attributes
  return _UNITAttributes
end


--- Delete units in a specified zone.
--
-- Deletes units within a given zone, filtered by a specified coalition, and optionally raises an event flag.
--
-- @param zoneName The name of the zone where units will be deleted.
-- @param coalition The coalition of the units to be deleted.
-- @param eventFlag Optional parameter to raise event flag when a unit is destroyed. Default is true.
-- @usage SPECTRE.UTILS.DeleteUnitsInZone("TargetZone", "blue") -- Deletes blue coalition units in the "TargetZone".
function SPECTRE.UTILS.DeleteUnitsInZone(zoneName, coalition, eventFlag)
  eventFlag = eventFlag or true

  local Zone_ = ZONE:FindByName(zoneName)

  local ZoneSet = SET_GROUP:New()
    :FilterZones({Zone_})
    :FilterCoalitions(coalition)
    :FilterCategoryGround()
    :FilterOnce()

  local function DelGroup (__group)
    __group:Destroy(eventFlag)
  end

  ZoneSet:ForEachGroup(DelGroup)
end

--- Convert an airfield name to a standardized format.
--
-- Replaces specific characters in the given place name for standardization purposes. Specifically, "-" and " " are replaced with "_", and single quotes are removed.
--
-- @param PlaceName The original place name to be converted.
-- @return PlaceName The converted place name.
-- @usage local convertedName = SPECTRE.UTILS.AirfieldNameConvert("Air-Field 'Test'") -- Returns "Air_Field_Test".
function SPECTRE.UTILS.AirfieldNameConvert(PlaceName)
  PlaceName = string.gsub(PlaceName, '-', '_')      -- Replace "-" with "_"
  PlaceName = string.gsub(PlaceName, ' ', '_')     -- Replace " " with "_"
  PlaceName = string.gsub(PlaceName, '\'', '')     -- Remove '
  return PlaceName
end


--- Retrieve information about a player.
--
-- Retrieves specific or complete information about a player based on the provided player name.
--
-- @param PlayerName The name of the player.
-- @param attribute Optional attribute to retrieve specific data about the player.
-- @return information The requested information or nil if the player is not found.
-- @usage local playerScore = SPECTRE.UTILS.GetPlayerInfo("JohnDoe", "ucid") -- Retrieves the ucid for the player "JohnDoe".
function SPECTRE.UTILS.GetPlayerInfo(PlayerName, attribute)
  if not PlayerName then return nil end

  local playerList = net.get_player_list()

  for i=1, #playerList do
    local playerInfo = net.get_player_info(i)
    if playerInfo then
      if playerInfo.name then
        if playerInfo.name == PlayerName then
          return attribute and playerInfo[attribute] or playerInfo
        end
      end
    end
  end

  return nil
end

--- Generate a report from a table of data.
--
-- Iterates through the ReportTable and constructs a REPORT object with the provided entries.
--
-- @param ReportTable The table containing report entries.
-- @return report The constructed REPORT object.
-- @usage local myReport = SPECTRE.UTILS.ReportGenerator({"Header", "Line1", "Line2"}) -- Generates a report with the provided lines.
function SPECTRE.UTILS.ReportGenerator(ReportTable)
  local report = REPORT:New(ReportTable[1])
  for _i = 2, #ReportTable do
    report:Add(ReportTable[_i])
  end
  return report
end

--- Deletes groups by their names.
--
-- Iterates through a list of group names and deletes each group. It uses the 'GROUP:FindByName' method to find the group and then destroys it.
--
-- @param _GroupNames An ipair table of group names to be deleted.
-- @usage SPECTRE.UTILS.deleteGroupsByName({"Group1", "Group2"}) -- Deletes groups named 'Group1' and 'Group2'.
function SPECTRE.UTILS.deleteGroupsByName(_GroupNames)
  for _,_gName in ipairs(_GroupNames) do
    GROUP:FindByName(_gName):Destroy(true)
  end
end

--- Retrieves group names that contain a specified string.
--
-- This function scans all groups and returns the names of those whose name includes the provided string. It utilizes the 'mist.DBs.groupsByName' database for group information.
--
-- @param string The string to match within group names.
-- @return _groupNames An ipair list of group names that contain the specified string.
-- @usage local matchingGroups = SPECTRE.UTILS.getGroupNamesbyStringMatch("Alpha") -- Returns a list of group names containing 'Alpha'.
function SPECTRE.UTILS.getGroupNamesbyStringMatch(string)
  local _groupNames = {}
  local allGroups = mist.DBs.groupsByName
  for groupName, groupData in pairs(allGroups) do
    if string.match(groupData.groupName, string) then
      table.insert(_groupNames, groupData.groupName)
    end
  end
  return _groupNames
end

--- Maths.
-- ===
--
-- *All Functions associated with Maths operations.*
--
-- ===
-- @section SPECTRE.UTILS


--- Generates a nudge value based on a provided factor.
--
-- This function calculates a nudge value within a dynamic range based on the 'NudgeFactor'. 
-- If 'NudgeFactor' is 1 or 0, it returns the 'NudgeFactor' itself. 
-- Otherwise, it calculates a random decimal between a lower and an upper bound, derived from 'NudgeFactor'. 
-- The lower bound is the greater of 'NudgeFactor' minus its square, and 0.01. 
-- The upper bound is the lesser of 'NudgeFactor' plus its square, and 0.99.
--
-- @param NudgeFactor The factor based on which the nudge value is generated.
-- @return returnValue The calculated nudge value, a decimal between the determined lower and upper bounds.
-- @usage local nudgeValue = SPECTRE.UTILS.generateNudge(0.5) -- Returns a random decimal between 0.01 and 0.99, based on the calculated bounds.
function SPECTRE.UTILS.generateNudge(NudgeFactor)
  --SPECTRE.UTILS.debugInfo("SPECTRE.UTILS.generateNudge : " .. NudgeFactor )
  -- Check if NudgeFactor is 1 or 0
  if NudgeFactor == 1 or NudgeFactor == 0 then
    return NudgeFactor
  end

  local lowerBound = math.max((NudgeFactor - ((NudgeFactor * NudgeFactor))), 0.01)
  local upperBound = math.min((NudgeFactor + ((NudgeFactor * NudgeFactor))), 0.99)

  -- Generate random number between lowerBound and upperBound
  local returnValue =  SPECTRE.UTILS.randomDecimalBetween(lowerBound, upperBound) --SPECTRE.UTILS.math_random(lowerBound,upperBound)
  --  SPECTRE.UTILS.debugInfo("SPECTRE.UTILS.generateNudge : lowerBound: " .. lowerBound )
  --  SPECTRE.UTILS.debugInfo("SPECTRE.UTILS.generateNudge : upperBound: " .. upperBound )
  --  SPECTRE.UTILS.debugInfo("SPECTRE.UTILS.generateNudge : returnValue: " .. returnValue )
  return returnValue
end

--- Generates a random decimal number between two values.
--
-- This function returns a random decimal number within the range of two specified values 'a' and 'b'. 
-- If 'a' is greater than 'b', their values are swapped to ensure a valid range. 
-- It ensures randomness by calling 'math.random()' twice before calculation.
--
-- @param a The lower bound of the range.
-- @param b The upper bound of the range.
-- @return randomDecimal A random decimal number between 'a' and 'b'.
-- @usage local randomNum = SPECTRE.UTILS.randomDecimalBetween(1.0, 2.0) -- Returns a random decimal between 1.0 and 2.0.
function SPECTRE.UTILS.randomDecimalBetween(a, b)
  math.random()
  math.random()
  if a > b then
    a, b = b, a
  end
  return a + (b - a) * math.random()
end

--- Generates a nominal value based on a given range, nudged by a specified factor.
--
-- This function calculates a value within a range around 'Nominal', nudged by 'NudgeFactor'. 
-- If 'NudgeFactor' is 1, it returns 'Nominal'. 
-- If 'NudgeFactor' is 0, it randomly returns either 'Min' or 'Max'. 
-- Otherwise, it calculates a 'nudged' range around 'Nominal' and returns a random decimal within this range.
--
-- @param Nominal The central value around which the range is calculated.
-- @param Min The minimum possible value.
-- @param Max The maximum possible value.
-- @param NudgeFactor The factor determining the extent of the nudge from 'Nominal'.
-- @return returnNominal A number within the nudged range around 'Nominal'.
-- @usage local nominalValue = SPECTRE.UTILS.generateNominal(50, 40, 60, 0.5) -- Returns a value in a nudged range around 50.
function SPECTRE.UTILS.generateNominal(Nominal, Min, Max, NudgeFactor)
  math.random()
  math.random()
  -- If NudgeFactor is 1, return Nominal
  if NudgeFactor == 1 then
    return Nominal
  end

  -- If NudgeFactor is 0, return either Min or Max randomly
  if NudgeFactor == 0 then
    if math.random() < 0.5 then
      return Min
    else
      return Max
    end
  end

  -- Calculate the nudged range
  local nudgedMin = math.max(Nominal - (NudgeFactor * ((Nominal - Min) / 2)), Min)
  local nudgedMax = math.min(Nominal + (NudgeFactor * ((Max - Nominal) / 2)), Max)
  local returnValue  = SPECTRE.UTILS.randomDecimalBetween(nudgedMin, nudgedMax)

  -- Return a number from the nudged range
  return returnValue
end

--- Truncate a number to a specified number of decimal places.
--
-- Truncates the given number to the desired number of decimal places without rounding.
--
-- @param num The number to be truncated.
-- @param digits The number of decimal places to which the number should be truncated. Defaults to 0 if not provided.
-- @return number The truncated number.
-- @usage local truncatedNum = SPECTRE.UTILS.trunc(3.14159, 2) -- Returns 3.14.
function SPECTRE.UTILS.trunc(num, digits)
  local mult = 10^(digits or 0)  -- default to 0 if digits is nil
  return math.modf(num * mult) / mult
end

--- Compute the ratio between two numbers.
--
-- Computes the ratio between A and B. If A is greater than B, it returns the ratio B/A; otherwise, it returns A/B. If either A or B is zero, the function returns 0.00.
--
-- @param A The first number.
-- @param B The second number.
-- @return number The computed ratio.
-- @usage local ratio = SPECTRE.UTILS.computeRatio(4, 2) -- Returns 0.5.
function SPECTRE.UTILS.computeRatio(A, B)
  if A == 0 or B == 0 then
    return 0.00
  end
  return (A > B) and (B / A) or (A / B)
end

--- Templatize.
-- ===
--
-- *All Functions associated with Template operations.*
--
-- ===
-- @section SPECTRE.UTILS

--- Creates a template from a given object.
--
-- This function serializes an object into a string using 'SPECTRE.IO.persistence.serializeNoFunc' and then deserializes it back into a table. 
-- The resulting table serves as a template for the original object.
--
-- @param OBJECT_ The object to be converted into a template.
-- @return _template The template derived from the given object.
-- @usage local objectTemplate = SPECTRE.UTILS.templateFromObject(myObject) -- Converts 'myObject' into a template.
function SPECTRE.UTILS.templateFromObject(OBJECT_)
  local serialString_ = SPECTRE.IO.persistence.serializeNoFunc(OBJECT_)
  local _template = SPECTRE.IO.persistence.deSerialize(serialString_)
  return _template
end

--- Sets values in one table based on a template table.
--
-- Updates the 'output_' table with values from the 'template_' table. 
-- It skips overwriting any functions and the '__index' key. 
-- The function handles nested tables recursively, ensuring deep copying of table values.
--
-- @param template_ The template table providing the values.
-- @param output_ The output table to be updated.
-- @return output_ The updated output table.
-- @usage local updatedTable = SPECTRE.UTILS.setTableValues(templateTable, outputTable) -- Updates 'outputTable' with values from 'templateTable'.
function SPECTRE.UTILS.setTableValues(template_, output_)
  for key, value in pairs(template_) do
    -- Skip if the key is __index or if the value in output_ is a function
    if key ~= "__index" and type(output_[key]) ~= "function" then
      if type(value) == "table" and type(output_[key]) == "table" then
        -- Recursive call if both template_ and output_ have a table at the current key
        SPECTRE.UTILS.setTableValues(value, output_[key])
      else
        -- Set the value in output_ to match the template_
        output_[key] = value
      end
    end
  end
  return output_
end

--- DEBUG.
-- ===
--
-- *All Functions associated with DEBUG operations.*
--
-- ===
-- @section SPECTRE.UTILS

--- Log debug information if debugging is enabled.
--
-- Logs a given message when the SPECTRE.DebugEnabled flag is set to 1. 
-- If additional data is provided, it's also logged.
--
-- @param message The debug message to be logged.
-- @param data Optional data to be logged.
-- @usage SPECTRE.UTILS.debugInfo("Debug Message", {key="value"}) -- Logs the message and data if debugging is enabled.
function SPECTRE.UTILS.debugInfo(message, data)
  if SPECTRE.DebugEnabled == 1 then
    env.info(message)
    if data then BASE:E(data) end
  end
end


--- Recursively prints a table's contents up to a specified depth.
--
-- This function iterates over each key-value pair in the table 'tbl', printing them. If the value is a table, it recursively calls itself, increasing the indentation level. The printing is limited to 'maxLevel' depth to prevent excessively deep traversal.
--
-- @param tbl The table to be printed.
-- @param level The current depth level (starts at 0).
-- @param maxLevel The maximum depth level to print.
-- @usage SPECTRE.UTILS.PrintTable(myTable, 0, 3) -- Prints the contents of 'myTable' up to a depth of 3 levels.
function SPECTRE.UTILS.PrintTable(tbl, level, maxLevel)
  if level > maxLevel then
    return
  end
  for key, value in pairs(tbl) do
    BASE:E(string.rep("  ", level) .. key)
    if type(value) == "table" then
      SPECTRE.UTILS.PrintTable(value, level + 1, maxLevel)
    else
      BASE:E(string.rep("  ", level + 1) .. value)
    end
  end
end


--- UTILS.DEBUGoutput.
-- @field #DEBUGoutput
SPECTRE.UTILS.DEBUGoutput = {}

---.
function SPECTRE.UTILS.DEBUGoutput.infoZoneWeights(mainZone, subZones)
  SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:infoZoneWeights | ZONE: %s | WEIGHT: %f", mainZone.name, mainZone.weight))
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneWeights | ---------------------------")
  for _, zoneObject_ in pairs(subZones) do
    SPECTRE.UTILS.debugInfo(string.format("SPECTRE.SPAWNER:infoZoneWeights | ZONE: %s | WEIGHT: %f", zoneObject_.name, zoneObject_.weight))
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneWeights | -------------------------------------------------------------------------")
end
---.
function SPECTRE.UTILS.DEBUGoutput.infoZoneCFG(zone_)
  local CFGSpawnAmountSettings_ = zone_.SpawnAmountSettings.Config
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | -------------------------------------------------------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | ZONE       | " .. zone_.name .. "     |     # SubZones: " .. zone_.numSubZones )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | -------------------------------------------------------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | ACTUAL SPAWN TOTAL | " .. CFGSpawnAmountSettings_.Actual)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | ACTUAL WEIGHTED    | " .. CFGSpawnAmountSettings_.ActualWeighted)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | MIN                | " .. CFGSpawnAmountSettings_.Min)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | MAX                | " .. CFGSpawnAmountSettings_.Max)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | NOMINAL            | " .. CFGSpawnAmountSettings_.Nominal)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | NOM WEIGHTED       | " .. CFGSpawnAmountSettings_.Weighted)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | RATIO MIN          | " .. CFGSpawnAmountSettings_.Ratio.Min)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | RATIO MAX          | " .. CFGSpawnAmountSettings_.Ratio.Max)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | DIV FACTOR         | " .. CFGSpawnAmountSettings_.DivisionFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CONFIG     | NUDGE FACTOR       | " .. CFGSpawnAmountSettings_.NudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | THRESHOLDS |--------------------|")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CHECK      | NOMINAL    |  OVER | " .. CFGSpawnAmountSettings_.Thresholds.overNom .. " | UNDER: " .. CFGSpawnAmountSettings_.Thresholds.underNom)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CHECK      | MAX        |  OVER | " .. CFGSpawnAmountSettings_.Thresholds.overMax)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneCFG              | CHECK      | MIN        | UNDER | " .. CFGSpawnAmountSettings_.Thresholds.underMin)
end
---.
function SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(zone_)
  local GENSpawnAmountSettings_ = zone_.SpawnAmountSettings.Generated
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | -------------------------------------------------------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | ZONE       | " .. zone_.name .. "     |     # SubZones: " .. zone_.numSubZones )
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | -------------------------------------------------------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | ACTUAL SPAWN TOTAL | " .. GENSpawnAmountSettings_.Actual)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | ACTUAL WEIGHTED    | " .. GENSpawnAmountSettings_.ActualWeighted)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | MIN                | " .. GENSpawnAmountSettings_.Min)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | MAX                | " .. GENSpawnAmountSettings_.Max)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | NOMINAL            | " .. GENSpawnAmountSettings_.Nominal)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | NOM WEIGHTED       | " .. GENSpawnAmountSettings_.Weighted)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | RATIO MIN          | " .. GENSpawnAmountSettings_.Ratio.Min)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | RATIO MAX          | " .. GENSpawnAmountSettings_.Ratio.Max)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | DIV FACTOR         | " .. GENSpawnAmountSettings_.DivisionFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | GENERATED  | NUDGE FACTOR       | " .. GENSpawnAmountSettings_.NudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | THRESHOLDS |")
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | CHECK      | NOMINAL    |  OVER | " .. GENSpawnAmountSettings_.Thresholds.overNom .. " | UNDER: " .. GENSpawnAmountSettings_.Thresholds.underNom)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | CHECK      | MAX        |  OVER | " .. GENSpawnAmountSettings_.Thresholds.overMax)
  SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoZoneGEN              | CHECK      | MIN        | UNDER | " .. GENSpawnAmountSettings_.Thresholds.underMin)
end

---.
function SPECTRE.UTILS.DEBUGoutput.infoGroupSettings(zone_)
  SPECTRE.UTILS.DEBUGoutput.infoZoneGEN(zone_)
  for _i = 1, #zone_.GroupSettings do
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | -------------------------------------------------------------------------")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings | Setting Index  ------  | " ..  _i)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings |            Group Size  | " ..  zone_.GroupSettings[_i].size)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings |         Number Groups  | " ..  zone_.GroupSettings[_i].numGroups)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings | distanceFromBuildings  | " ..  zone_.GroupSettings[_i].distanceFromBuildings)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings | ---- Seperation  ------|----------------------------")
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings |          Groups Max:   | " ..  zone_.GroupSettings[_i].seperation.groups.max .. " | Groups Min: " ..  zone_.GroupSettings[_i].seperation.groups.min)
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:infoGroupSettings        | GroupSettings |          Units Max :   | " ..  zone_.GroupSettings[_i].seperation.units.max ..  " | Units Min: " ..  zone_.GroupSettings[_i].seperation.units.min)
  end


end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **WORLD**
--
--  *Functions for tracking zone game data and state.*
--
-- ===
--
-- @module WORLD
-- @extends SPECTRE

--- SPECTRE.WORLD.
--
-- *Functions for tracking zone game data and state.*
--
-- @section WORLD
-- @field #WORLD
SPECTRE.WORLD = {}

---Zone.
-- ===
--
-- *Functions for tracking zone game data and state.*
--
-- ===
-- @section SPECTRE.WORLD

--- Check if a given 2D vector point is inside a specified zone.
--
-- @param vec2 table: A table containing the x and y coordinates of the point to check (e.g., {x=0, y=0}).
-- @param zoneName string: The name of the zone to check against.
-- @return boolean: Returns true if the Vec2 is inside the zone, otherwise returns false.
function SPECTRE.WORLD.PointInZone(vec2, zoneName)
  -- Fetch the zone data from the mist database using the provided zone name
  local _zone = mist.DBs.zonesByName[zoneName]

  -- Get the vertices (corners) of the zone
  local box = _zone.verticies

  -- Standardize the vec2 format
  vec2.x = vec2.x or vec2[1]
  vec2.y = vec2.y or vec2[2]

  -- Determine if the vec2 is within the zone boundaries
  local result = SPECTRE.POLY.PointWithinShape(vec2, box)

  return result
end

--- Check if a given 2D vector point is inside any of the specified no-go zones.
--
-- @param possibleVec2 table: A table containing the x and y coordinates of the point to check (e.g., {x=0, y=0}).
-- @param zoneList table: A list of zones (represented by their names or objects) to check against.
-- @return number: Returns 0 if the Vec2 is inside any of the no-go zones, otherwise returns 1.
function SPECTRE.WORLD.Vec2inZones(possibleVec2, zoneList)
  -- Iterate through each zone in the list and check if the provided Vec2 is inside it
  for _, zone in ipairs(zoneList) do
    if SPECTRE.WORLD.PointInZone(possibleVec2, zone) then
      return 0  -- If Vec2 is inside any of the zones, return 0
    end
  end

  return 1  -- If Vec2 was not found in any of the zones, return 1
end

function SPECTRE.WORLD.FindUnitsInZone(ZoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.WORLD:FindUnitsInZone | -------------------------------------------- ")
  local temp_detectedUnits = {}
  temp_detectedUnits[0] = {}
  temp_detectedUnits[1] = {}
  temp_detectedUnits[2] = {}
  local t_ZOBJ = ZONE:FindByName(ZoneName)
  t_ZOBJ:Scan({Object.Category.UNIT}, {Unit.Category.GROUND_UNIT, Unit.Category.STRUCTURE, Unit.Category.SHIP})
  local scanData = t_ZOBJ.ScanData
  if scanData then
    -- Units
    if scanData.Units then
      for _, unit in pairs(scanData.Units) do
        local _unitCoal = unit:getCoalition()
        local _unitName = unit:getName()
        local _life = unit:getLife()
        SPECTRE.UTILS.debugInfo("SPECTRE.WORLD:FindUnitsInZone | FOUND UNIT  | _unitCoal | " .. _unitCoal .. " | _unitName | " .. _unitName)
        temp_detectedUnits[_unitCoal][#temp_detectedUnits[_unitCoal] + 1] = {
          name = _unitName,
          unitObj = unit,
          coal = _unitCoal,
          life = _life,
        }
      end
    end
  end
  return temp_detectedUnits
end

---Markers.
-- ===
--
-- *Functions for tracking zone game data and state.*
--
-- ===
-- @section SPECTRE.WORLD

--- Create a red target marker at a specified coordinate if units of a given category and coalition exist within a zone.
--
-- Old function kept for sentimental value. Still works.
--
-- @param ZoneName string: The name of the zone to check for units.
-- @param ObjectCategory number: The category of the object (e.g., Object.Category.UNIT).
-- @param Table_UnitCategory table: A list of unit categories to scan for within the zone (e.g., {Unit.Category.GROUND_UNIT}).
-- @param UnitCoalition number: The coalition code of the units to check for (e.g., 0 = neutral, 1 = red, 2 = blue).
-- @param Coordinate OBJECT: The coordinate object where the marker should be created.
-- @param MarkCoalition number (optional): The coalition that should see the marker. Default is -1 (all coalitions).
-- @param MarkerRadius number (optional): The radius of the created circle around the marker. Default is 5000.
-- @param MarkText string (optional): The text to display on the marker. Default is an empty string.
-- @return table: A list containing the marker ID and circle ID.
function SPECTRE.WORLD.TargetMarker_CreateAtPointIfUnitsExistInZone(ZoneName, ObjectCategory, Table_UnitCategory, UnitCoalition, Coordinate, MarkCoalition, MarkerRadius, MarkText)
  -- Default values for optional parameters
  MarkCoalition = MarkCoalition or -1
  MarkText = MarkText or ""
  MarkerRadius = MarkerRadius or 5000

  -- Fetch the specified zone by name and scan it for the specified unit categories
  local zoneCheck = ZONE:FindByName(ZoneName)
  zoneCheck:Scan(ObjectCategory, Table_UnitCategory)

  local CircleID, MarkerID

  -- If units of the specified coalition are found in the scanned zone, create a circle and marker
  if zoneCheck:CheckScannedCoalition(UnitCoalition) then
    CircleID = Coordinate:CircleToAll(MarkerRadius, MarkCoalition, {1, 0, 0}, 1, {1, 0, 0}, 0.4, 4, true)
    MarkerID = Coordinate:MarkToCoalition(MarkText, MarkCoalition, true)
  end

  -- Return the created circle and marker IDs in a table
  return {MarkerID, CircleID}
end

---Airbase.
-- ===
--
-- *Functions for tracking zone game data and state.*
--
-- ===
-- @section SPECTRE.WORLD

--- Find the nearest airbase from a provided list to a given 2D vector point.
--
-- @param AirbaseList table: A list of airbase names to search within.
-- @param _vec2 table: A table containing the x and y coordinates of the given point (e.g., {x=0, y=0}).
-- @return table: A list containing the name and 3D vector coordinates of the nearest airbase.
function SPECTRE.WORLD.FindNearestAirbaseToPointVec2(AirbaseList, _vec2)
  SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | -------------------------------------------------------------------------")

  local maxInitialDistance = 99999999999
  local closestAirbaseDistance = maxInitialDistance
  local closestAirbaseDetails
  local queryPointCoord = COORDINATE:NewFromVec2(_vec2)  -- Convert the given Vec2 to a COORDINATE object

  -- Iterate over each airbase in the provided list and find the closest
  for _, airbaseName in ipairs(AirbaseList) do
    SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | airbaseName: " .. airbaseName)

    local airbaseVec3 = AIRBASE:FindByName(airbaseName):GetVec3()
    local airbaseCoord = COORDINATE:NewFromVec3(airbaseVec3)
    local currentDistance = queryPointCoord:Get2DDistance(airbaseCoord)

    SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | currentDistance: " .. currentDistance)

    if currentDistance < closestAirbaseDistance then
      SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | closest so far --")
      closestAirbaseDistance = currentDistance
      closestAirbaseDetails = {airbaseName, airbaseVec3}
    end
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | CLOSEST: ")
  SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | Name   : " .. closestAirbaseDetails[1])
  SPECTRE.UTILS.debugInfo("SPECTRE.WORLD.FindNearestAirbaseToPointVec2 | Vec3   : " , closestAirbaseDetails[2])
  -- Return the details of the closest airbase
  return closestAirbaseDetails
end

--- Retrieve a list of airbases owned by a specific coalition for a given map.
--
-- @param coal number: The coalition code (e.g., 0 = neutral, 1 = red, 2 = blue).
-- @return table: A list of airbases owned by the specified coalition in the given map.
function SPECTRE.WORLD.GetOwnedAirbaseCoal(coal)
  -- Lookup table to determine the correct list of airbases based on the map parameter
  local airbaseMapLookup = {
    ["Syria"] = AIRBASE.Syria,
    ["Persia"] = AIRBASE.PersianGulf,
    ["Caucasus"] = AIRBASE.Caucasus,
    ["Sinai"] = AIRBASE.Sinai,
    ["MarianaIslands"] = AIRBASE.MarianaIslands,
    ["Nevada"] = AIRBASE.Nevada,
    ["Normandy"] = AIRBASE.Normandy,
    ["SouthAtlantic"] = AIRBASE.SouthAtlantic,
    ["TheChannel"] = AIRBASE.TheChannel
  }

  local _AirbaseListTheatre = airbaseMapLookup[SPECTRE.MAPNAME] or {} -- Initialize using the lookup
  local _AirbaseListOwned = {} -- Initialize a list to hold owned airbases for the specified coalition

  -- Iterate over each airbase in the theatre and determine if it's owned by the specified coalition
  for key, value in pairs(_AirbaseListTheatre) do
    local airbase_ = AIRBASE:FindByName(value)
    local airbase_Coal = airbase_:GetCoalition()

    -- If the airbase is owned by the specified coalition, add it to the list
    if airbase_Coal == coal then
      _AirbaseListOwned[#_AirbaseListOwned+1] = value
    end
  end

  SPECTRE.UTILS.debugInfo("_AirbaseListOwned",_AirbaseListOwned)
  -- Return the list of owned airbases
  return _AirbaseListOwned
end

--- Retrieve information about the closest airfield to a given 2D vector point based on coalition and map.
--
-- @param coal number: The coalition code (0 = neutral, 1 = red, 2 = blue).
-- @param _vec2 table: A table containing the x and y coordinates of the given point (e.g., {x=0, y=0}).
-- @return table: Information about the nearest airbase, containing its name and 3D vector coordinates.
function SPECTRE.WORLD.ClosestAirfieldVec2(coal, _vec2)
  -- Get airfields owned by the coalition
  local _Airfields = SPECTRE.WORLD.GetOwnedAirbaseCoal(coal)
  SPECTRE.UTILS.debugInfo("_Airfields",_Airfields)
  -- Find the nearest airbase to the given point
  local NearestAirbase = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(_Airfields, _vec2)
  SPECTRE.UTILS.debugInfo("NearestAirbase",NearestAirbase)
  -- Construct and return the nearest airbase info
  local NearestAirbaseInfo = {
    Name = NearestAirbase[1],
    Vec3 = NearestAirbase[2],
  }
  return NearestAirbaseInfo
end


--- Calculate the Euclidean distance between two points in a 2D space.
--
-- @param p1 table: A table containing the x and y coordinates of the first point (e.g., {x=0, y=0}).
-- @param p2 table: A table containing the x and y coordinates of the second point (e.g., {x=1, y=1}).
-- @return number: The Euclidean distance between the two points.
function SPECTRE.WORLD.f_distance(p1, p2)
  -- Calculate the differences in x and y coordinates
  local dx = p1.x - p2.x
  local dy = p1.y - p2.y

  -- Compute the Euclidean distance using Pythagoras' theorem
  return math.sqrt(dx^2 + dy^2)
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

--- **ZONEMGR**
--
-- The brain of SPECTRE, allowing the game to interpret various units positioning and data with ML strategies.
--
-- Intelligently manage hotspots, intelligence, sitrep, and automated spawning in the zones.
--
-- The `ZONEMGR` module within the SPECTRE system is designed for dynamic zone management,
-- offering a centralized approach to handle various zone-related operations.
--
-- @module ZONEMGR
-- @extends SPECTRE


--- 1 - Zone Manager.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- SPECTRE.ZONEMGR.
--
-- The brain of SPECTRE, allowing the game to interpret various units positioning and data with ML strategies.
--
-- Intelligently manage hotspots, intelligence, sitrep, and automated spawning in the zones.
--
-- The `ZONEMGR` module within the SPECTRE system is designed for dynamic zone management,
-- offering a centralized approach to handle various zone-related operations.
--
-- @field #ZONEMGR
SPECTRE.ZONEMGR = {}

--- Configurations for ZONEMGR operations.
-- @field #ZONEMGR.Config Configuration table with operation limit.
SPECTRE.ZONEMGR.Config = {}

--- Maximum number of operations that ZONEMGR can handle.
-- Defines the upper limit for ZONEMGR operations.
SPECTRE.ZONEMGR.Config.operationLimit = 150

--- Minimum value for random seed generation.
-- Sets the lower bound for random seed values.
SPECTRE.ZONEMGR._randSeedMin = 500

--- Maximum value for random seed generation.
-- Sets the upper bound for random seed values.
SPECTRE.ZONEMGR._randSeedMax = 2000

--- Nominal value for random seed generation.
-- The default or standard seed value used in randomization.
SPECTRE.ZONEMGR._randSeedNom = 2000

--- Nudge factor for random seed adjustment.
-- Modifier to fine-tune the randomization process.
SPECTRE.ZONEMGR._randSeedNudge = 0.7

--- Flag for enabling persistence functionality.
-- Indicates if persistence is active in ZONEMGR.
SPECTRE.ZONEMGR._persistence = false

SPECTRE.ZONEMGR._markerScheduler = {}
SPECTRE.ZONEMGR._markerQueue = {}
SPECTRE.ZONEMGR._removeMarkerQueue = {}
SPECTRE.ZONEMGR._hotspotQueue = {}
SPECTRE.ZONEMGR._HotspotSched = {}

--- WIP.
-- Flag for enabling CAP functionality.
-- Indicates if CAP Defense is active in ZONEMGR.
SPECTRE.ZONEMGR._enableCAP = false
SPECTRE.ZONEMGR.UpdatingCAP = false
SPECTRE.ZONEMGR.COUNTER = 1
SPECTRE.ZONEMGR.Handler_ = EVENT:New()
SPECTRE.ZONEMGR.schedulerCAPMin = 20
SPECTRE.ZONEMGR.schedulerCAPMax = 30
SPECTRE.ZONEMGR.schedulerCAPFactor = 0.25

--- WIP.
-- Flag for enabling CAP functionality.
-- Indicates if CAP Defense is active in ZONEMGR.
SPECTRE.ZONEMGR._schedlerCAP = {}

--- WIP.
-- Storage for CAP template group names.
-- ipair, key = coalition, value = ipair string table of CAP template group names
SPECTRE.ZONEMGR._CAPtemplates = {
  [0] = {},
  [1] = {},
  [2] = {}
}

--- WIP.
SPECTRE.ZONEMGR.settingsCAP = {
  [0] = {
    RestockTime = 999999,
    Min = 0,
    Nominal = 0,
    Max = 0,
    PlayerRatio = 1,
    NudgeFactor = 0.5,
  },
  [1] = {
    RestockTime = 30,
    Min = 2,
    Nominal = 6,
    Max = 12,
    PlayerRatio = 1,
    NudgeFactor = 0.5,
  },
  [2] = {
    RestockTime = 30,
    Min = 1,
    Nominal = 3,
    Max = 4,
    PlayerRatio = 1,
    NudgeFactor = 0.5,
  },
}

SPECTRE.ZONEMGR._CAPspawns = {
  [0] = {},
  [1] = {},
  [2] = {},
}

--- Flag for enabling _AirfieldCaptureSpawns functionality.
SPECTRE.ZONEMGR._AirfieldCaptureSpawns = false
--- Flag for enabling _AirfieldCaptureClean functionality.
SPECTRE.ZONEMGR._AirfieldCaptureClean = false
--- Persistence settings for different templates.
-- @field #ZONEMGR.persistanceSettings Specifies paths for Fill and Airfield templates.
SPECTRE.ZONEMGR.persistanceSettings = {
  FillTemplates = "SPAWNERTemplates/Fill/",
  AirfieldTemplates = "SPAWNERTemplates/Airfield/",
}

--- Table to store Admin UCIDs for special functions like LiveEditor.
SPECTRE.ZONEMGR.AdminUCIDs = {}

--- keep small, for ex: zone with min distance from side to side = 148680m, a scale facor of 0.05 gives min dist from detected groups of 148680*0.05=7434m.
SPECTRE.ZONEMGR._smartFillMinDistFactor = 0.05

--- Dictionary to store zone instances.
-- @field #ZONEMGR.Zones
SPECTRE.ZONEMGR.Zones = {}

--- Dictionary to store airfield spawner instances.
-- @field #ZONEMGR.AIRFIELDSPAWNERS
SPECTRE.ZONEMGR.AIRFIELDSPAWNERS = {}

--- Dictionary to store fill spawner instances.
-- @field #ZONEMGR.FILLSPAWNERS
SPECTRE.ZONEMGR.FILLSPAWNERS = {}

--- Dictionary to store generated airfield spawns.
-- @field #ZONEMGR.generatedAirfields
SPECTRE.ZONEMGR.generatedAirfields = {}

--- Dictionary to store generated fill spawns.
-- @field #ZONEMGR.generatedFills
SPECTRE.ZONEMGR.generatedFills = {}

--- Flag indicating if zones are currently being updated.
SPECTRE.ZONEMGR.UpdatingZones = false

--- Scheduler for periodic Zone ownership updates.
-- @field #ZONEMGR.UpdateSched
SPECTRE.ZONEMGR.UpdateSched = {}

--- Flag indicating if SSB management is active.
SPECTRE.ZONEMGR.SSB = false

--- Flags for SSB on state (default 0).
SPECTRE.ZONEMGR.SSBon = 0

--- Flags for SSB off states (default 100).
SPECTRE.ZONEMGR.SSBoff = 100

--- Boolean Toggle for drawing unit hotspots (default false).
SPECTRE.ZONEMGR.Hotspots = false

--- Boolean Toggle for drawing hotspot intel (default false).
SPECTRE.ZONEMGR.Intel = false

--- Code marker for the zones (default 1035200).
SPECTRE.ZONEMGR.codeMarker_ = 1035200

--- A list to seed airbases.
-- @field #ZONEMGR.AirbaseSeed
SPECTRE.ZONEMGR.AirbaseSeed = {}

--- Factor for determining minimum distance for smart fill (scale factor).
SPECTRE.ZONEMGR._smartFillMinDistFactor = 0.05

--- How often to update self.
SPECTRE.ZONEMGR.UpdateInterval = 25

--- Adjust how often to update self.
SPECTRE.ZONEMGR.UpdateIntervalNudge = 0.25
--- Adjust this factor based on desired granularity for hotspots.
-- Hotspots
SPECTRE.ZONEMGR.AI_f = 2 -- 1.5
--- Percentage of total units (adjust based on your use case).
-- Hotspots
SPECTRE.ZONEMGR.AI_p = 0.1 -- 0.02
--- Create a new zone manager instance.
--
-- This function initializes a new instance of the SPECTRE.ZONEMGR class. It inherits from the BASE class
-- and sets up the random seed count based on predefined parameters.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The newly created instance of the zone manager.
-- @usage local zoneManager = SPECTRE.ZONEMGR:New() -- Creates a new zone manager instance.
function SPECTRE.ZONEMGR:New()
  local self = BASE:Inherit(self, SPECTRE:New())
  local _randseedCount = SPECTRE.UTILS.generateNominal(self._randSeedNom, self._randSeedMin, self._randSeedMax, self._randSeedNudge)
  for _seedC = 1 , _randseedCount, 1 do
    math.random()
  end
  return self
end

--- 2 - Enable Toggles.
-- ===
--
-- *All toggles associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Enable or disable the CAP defense system for the SPECTRE.ZONEMGR instance.
--
-- This function controls the activation state of the persistence system within the SPECTRE.ZONEMGR class.
-- It allows the persistence feature to be toggled on or off. When enabled, the persistence system maintains
-- stateful data across different game sessions or events. The function defaults to enabling persistence if no
-- specific value is provided.
--
-- @param #ZONEMGR self
-- @param enabled A boolean value (true or false) to enable or disable the system respectively. Defaults to true if not specified.
-- @return #ZONEMGR self
function SPECTRE.ZONEMGR:enableCAP(enabled)
  -- Default to true if no value is provided
  enabled = enabled or true

  -- Set the persistence setting based on the 'enabled' parameter
  self._enableCAP = enabled

  return self
end

--- Enable or disable the persistence system for the SPECTRE.ZONEMGR instance.
--
-- This function controls the activation state of the persistence system within the SPECTRE.ZONEMGR class.
-- It allows the persistence feature to be toggled on or off. When enabled, the persistence system maintains
-- stateful data across different game sessions or events. The function defaults to enabling persistence if no
-- specific value is provided.
--
-- @param #ZONEMGR self The instance of the zone manager to adjust the persistence setting.
-- @param enabled A boolean value (true or false) to enable or disable the persistence system respectively. Defaults to true if not specified.
-- @return #ZONEMGR self The zone manager instance with the updated persistence setting.
-- @usage zoneManager:enablePersistance(true) -- Enables the persistence system.
-- @usage zoneManager:enablePersistance(false) -- Disables the persistence system.
function SPECTRE.ZONEMGR:enablePersistance(enabled)
  -- Default to true if no value is provided
  enabled = enabled or true

  -- Set the persistence setting based on the 'enabled' parameter
  self._persistence = enabled

  return self
end

--- Enable or disable automatic spawns for the coalition that captures an airfield for the SPECTRE.ZONEMGR instance.
--
--  EX: If enabled, when Blue captures an airfield, will pull a random AIRFIELDSPAWNER template from ZONEMGR db and spawn friendly blue units at the field.
--
-- @param #ZONEMGR self The instance of the zone manager to adjust the persistence setting.
-- @param enabled A boolean value (true or false) to enable or disable the persistence system respectively. Defaults to true if not specified.
-- @return #ZONEMGR self The zone manager instance with the updated persistence setting.
-- @usage zoneManager:enableAirfieldCaptureSpawns(true) -- Enables automatic spawns for the coalition that captures an airfield at the airfield.
-- @usage zoneManager:enableAirfieldCaptureSpawns(false) -- Disables automatic spawns for the coalition that captures an airfield at the airfield.
function SPECTRE.ZONEMGR:enableAirfieldCaptureSpawns(enabled)
  -- Default to true if no value is provided
  enabled = enabled or true
  self._AirfieldCaptureSpawns = enabled
  return self
end

--- Enables or disables hotspots within the ZoneManager.
--
-- This function is responsible for activating or deactivating hotspot functionality in the ZoneManager. Hotspots are key areas or points
-- of interest within game zones, and managing their activation is crucial for dynamic gameplay. The function takes an optional parameter
-- to specify whether hotspots should be enabled or disabled, defaulting to true (enabled) if not specified.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param enabled (optional) Boolean value to enable (true) or disable (false) hotspots. Defaults to true if not specified.
-- @return #ZONEMGR self The zone manager instance with hotspots enabled or disabled as specified.
-- @usage local zoneManagerWithHotspots = SPECTRE.ZONEMGR:enableHotspots() -- Enables hotspots in the ZoneManager.
function SPECTRE.ZONEMGR:enableHotspots(enabled)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:InitHotspots | ---------------------")
  enabled = enabled or true

  self.Hotspots = enabled
  return self
end
--- Enables or disables hotspot intelligence within the ZoneManager.
--
-- This function manages the activation of hotspot intelligence in the ZoneManager, which provides strategic insights
-- about key areas within game zones. It allows the game to offer enhanced interactive and tactical experiences based on hotspot activities.
-- The function can be configured to enable or disable this feature, with a default behavior of enabling it if no specific instruction is provided.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param enabled (optional) Boolean value to enable (true) or disable (false) the hotspot intelligence feature. Defaults to true if not specified.
-- @return #ZONEMGR self The zone manager instance with the hotspot intelligence feature enabled or disabled as specified.
-- @usage local zoneManagerWithIntel = SPECTRE.ZONEMGR:enableHotspotIntel() -- Enables hotspot intelligence in the ZoneManager.
function SPECTRE.ZONEMGR:enableHotspotIntel(enabled)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:enableHotspotIntel | ---------------------")
  enabled = enabled or true

  self.Intel = enabled
  return self
end


--- Enables live editing of managed zones via markers.
--
-- This function allows for real-time modifications to the managed zones through the use of in-game markers.
-- It supports various commands for deleting and spawning elements like zones, airfields, and circles,
-- providing flexibility and dynamic control over the game's strategic elements. The function handles different
-- edit types and sets up event handlers for marker changes, enabling users to interactively manage zones directly within the game environment.
--
-- Delete: /del [command] [coal] [opt param, ...]
--
--      /del zone [coal]
--      /del airfield [coal]
--      /del allairfield [coal]
--      /del circle [coal] [Circle Diameter (meters), centered on marker]
--
-- Spawn: /spawn [command] [coal] [opt param, ...]
--
--      /spawn zone [coal] [country] [smart] [bias]
--      /spawn zone 1 1 1 2
--      /spawn airfield [coal] [country]
--      /spawn allairfield [coal] [country]
--      /spawn circle [coal] [Circle Diameter (meters), centered on marker] [country] [name]
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance with live edit functionality enabled.
-- @usage local zoneManagerWithLiveEdit = SPECTRE.ZONEMGR:enableLiveEdit() -- Enables live editing of zones in the ZoneManager.
function SPECTRE.ZONEMGR:enableLiveEdit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:enableLiveEdit | ---------------------")
  --  self.LIVEEDIT:Init(self)
  -- Iterate over all support settings
  for editType, isEnabled in pairs(self.Settings.Edit) do
    -- Initialize tracker if the support type is not "ESCORT" and it is enabled
    if isEnabled then
      self.MARKERS.TRACKERS[editType] = {}

      -- Set the event marker function
      self._EventMarker = self["_EventMarker"]

      local markerSettings = self.MARKERS.Settings[editType]
      if not markerSettings.KeyWords or #markerSettings.KeyWords == 0 then
        self.MARKERS.TRACKERS[editType] = MARKEROPS_BASE:New(markerSettings.TagName, markerSettings.CaseSensitive)
      else
        self.MARKERS.TRACKERS[editType] = MARKEROPS_BASE:New(markerSettings.TagName, markerSettings.KeyWords, markerSettings.CaseSensitive)
      end

      -- Set up event handler for changes in markers
      self.MARKERS.TRACKERS[editType].OnAfterMarkChanged = function(From, Event, To, Text, Keywords, Coord)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | LIVEEDIT | ".. editType .. ":OnAfterMarkChanged | ------------------------")
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | From   | ", From)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | Event  | ", Event)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | To     | ", To)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | Text   | ", Text)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | Keywords| ", Keywords)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | coord   | ", Coord)

        local origText = Keywords
        local sanitizedText = Keywords:gsub("/", ""):upper()
        local MarkerType = {}
        for word in sanitizedText:gmatch("%w+") do table.insert(MarkerType, word) end
        local MarkInfo = SPECTRE.MARKERS.World.FindByText(origText)

        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | MarkerType   | ", MarkerType)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | MarkInfo     | ", MarkInfo)
        local Packet = {
          From = From,
          Event = Event,
          To = To,
          Text = Text,
          sanitizedText = sanitizedText,
          MarkerType = MarkerType,
          MarkInfo = MarkInfo,
          Keywords = Keywords,
          Coord = Coord,
        }
        self  = self._EventMarker(self, Packet)
        return self
      end
    end
  end

  return self
end
--- x - Utilities.
-- ===
--
-- *Misc utilities associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Retrieves the coalition ownership of a specified zone.
--
-- This function determines and returns the current coalition ownership of a specific zone within the SPECTRE.ZONEMGR system.
-- It first calls a method to determine the zone's current ownership status and then retrieves the coalition (either Red, Blue, or None)
-- that owns the zone. This information is crucial for various gameplay mechanics and strategies related to zone control.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param zoneName The name of the zone whose coalition ownership is to be determined.
-- @return ownedBy The current coalition (Red, Blue, or None) that owns the specified zone.
-- @usage local owningCoalition = zoneManager:getZoneCoalition("Zone1") -- Retrieves the coalition owning "Zone1".
function SPECTRE.ZONEMGR.getZoneCoalition(self, zoneName)
  self.Zones[zoneName]:DetermineZoneOwnership()
  local ownedBy = self.Zones[zoneName].OwnedByCoalition
  return ownedBy
end

--- Retrieves the airfields and zones owned by the red and blue coalitions.
--
-- This function iterates through the zones managed by the `ZONEMGR` instance, determining which coalition owns each zone and airfield.
-- It classifies the zones and airfields based on their ownership and returns separate lists for red and blue coalitions.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @return redZones Table of zones owned by the red coalition.
-- @return blueZones Table of zones owned by the blue coalition.
-- @return redAirfields Table of airfields owned by the red coalition.
-- @return blueAirfields Table of airfields owned by the blue coalition.
-- @usage local redZones, blueZones, redAirfields, blueAirfields = zoneManager:getOwnedProperty() -- Retrieves owned zones and airfields.
function SPECTRE.ZONEMGR.getOwnedProperty(self)
  local redZones, blueZones, redAirfields, blueAirfields = {}, {}, {}, {}
  for _k, _v in pairs(self.Zones) do
    local zoneOwnedBy = self:getZoneCoalition(_k)
    if zoneOwnedBy == 1 then
      table.insert(redZones, _k)
    elseif zoneOwnedBy == 2 then
      table.insert(blueZones, _k)
    end
    for _ab, _abV in pairs(_v.Airbases) do
      local airfieldOwnedBy = _abV.ownedBy
      if airfieldOwnedBy == 1 then
        table.insert(redAirfields, _ab)
      elseif airfieldOwnedBy == 2 then
        table.insert(blueAirfields, _ab)
      end
    end
  end
  return redZones, blueZones, redAirfields, blueAirfields
end

--- Calculates a strategically positioned vector point within a zone.
--
-- This function computes a vector point within specified boundaries that adheres to certain strategic constraints such as
-- coalition bias, minimum and maximum distances from hotspots, and clustering effects. It is designed to smartly position
-- game elements in a way that respects the current state of the battlefield and strategic considerations, making it a key
-- component for dynamic gameplay and scenario generation within the SPECTRE.ZONEMGR system.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param quad_bounds The bounding coordinates defining the area within which the point is to be generated.
-- @param hotspot_clusters Clusters of hotspots that influence the positioning of the point.
-- @param coalition_bias Bias towards a specific coalition in determining the point's position.
-- @param min_distance The minimum distance the point should maintain from any hotspot.
-- @param max_distance The maximum distance within which the point should be from any hotspot.
-- @return point The calculated vector point that satisfies the given constraints.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage local strategicPoint = newZoneManager:getSmartVec2(quadBounds, hotspots, coalitionBias, minDist, maxDist) -- Calculates a strategic point within the specified parameters.
function SPECTRE.ZONEMGR.getSmartVec2(self, quad_bounds, hotspot_clusters, coalition_bias, min_distance, max_distance)
  coalition_bias = coalition_bias or 0
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | -------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | coalition_bias | " ..  coalition_bias )
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | min_distance   | " ..  min_distance)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | max_distance   | " ..  max_distance)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | quad_bounds[1] | x: " ..  quad_bounds[1].x .. " | y: " .. quad_bounds[1].y)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | quad_bounds[2] | x: " ..  quad_bounds[2].x .. " | y: " .. quad_bounds[2].y)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | quad_bounds[3] | x: " ..  quad_bounds[3].x .. " | y: " .. quad_bounds[3].y)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | quad_bounds[4] | x: " ..  quad_bounds[4].x .. " | y: " .. quad_bounds[4].y)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | -------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | hotspot_clusters " , hotspot_clusters)
  local function random_point_in_polygon(quad_bounds, hotspot_clusters, min_distance)
    local function random_point_in_bounds(bounds)
      local x_min = math.min(bounds[1].x, bounds[3].x)
      local x_max = math.max(bounds[1].x, bounds[3].x)
      local y_min = math.min(bounds[1].y, bounds[3].y)
      local y_max = math.max(bounds[1].y, bounds[3].y)
      return {
        x = math.random() * (x_max - x_min) + x_min,
        y = math.random() * (y_max - y_min) + y_min
      }
    end

    local function is_point_outside_all_clusters(point, clusters, min_dist)
      for _, cluster in ipairs(clusters) do

        if  cluster.Center and SPECTRE.POLY.distance(point, cluster.Center) < (cluster.Radius + min_dist) then
          return false
        end
      end
      return true
    end

    local point
    local _glassBreak2 = 0
    local _valid2 = false
    repeat
      point = random_point_in_bounds(quad_bounds)
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | Determining point in bounds")

      local _outsideClusterFlag = true
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | Determining point outside clusters")
      _outsideClusterFlag = is_point_outside_all_clusters(point, hotspot_clusters, min_distance)

      _valid2 = SPECTRE.POLY.PointWithinShape(point, quad_bounds) and _outsideClusterFlag

      if _glassBreak2 >= self.Config.operationLimit then
        SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:getSmartVec2 | is_point_outside_all_clusters --- GLASSBREAK --")
        _valid2 = true
      end
      _glassBreak2 = _glassBreak2 + 1
    until _valid2
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | point_outside_all_clusters & point_in_bounds")
    return point
  end

  local function distance_to_nearest_hotspot(p, hotspots)
    local min_distance = math.huge
    for _, group in ipairs(hotspots) do
      for _, unit in ipairs(group.Units) do
        local distance = SPECTRE.POLY.distance(p, unit.vec2)
        if distance < min_distance then
          min_distance = distance
        end
      end
    end
    return min_distance
  end

  local function is_cluster_empty(cluster)
    return not cluster or #cluster == 0
  end

  local valid = false
  local glassBreak = 0
  local point
  while not valid do

    point = random_point_in_polygon(quad_bounds, hotspot_clusters, min_distance)
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | random_point       | x: " ..  point.x .. " | y: " .. point.y)
    local distancePointToRed
    local distancePointToBlue
    if is_cluster_empty(hotspot_clusters[1]) and is_cluster_empty(hotspot_clusters[2]) then
      coalition_bias = 0
    else
      distancePointToRed = is_cluster_empty(hotspot_clusters[1]) and max_distance or distance_to_nearest_hotspot(point, hotspot_clusters[1])
      distancePointToBlue  = is_cluster_empty(hotspot_clusters[2]) and max_distance or distance_to_nearest_hotspot(point, hotspot_clusters[2])
    end
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | distancePointToRed  | " .. tostring(distancePointToRed))
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | distancePointToBlue | " .. tostring(distancePointToBlue))

    local satisfies_bias = true
    if coalition_bias == 1 then
      if not is_cluster_empty(hotspot_clusters[1]) then
        satisfies_bias = distancePointToRed <= distancePointToBlue
      elseif not is_cluster_empty(hotspot_clusters[2]) then
        satisfies_bias = distancePointToBlue > (min_distance+(max_distance*.05)) and distancePointToBlue <= max_distance
      end
    elseif coalition_bias == 2 then
      if not is_cluster_empty(hotspot_clusters[2]) then
        satisfies_bias = distancePointToBlue <= distancePointToRed
      elseif not is_cluster_empty(hotspot_clusters[1]) then
        satisfies_bias = distancePointToRed > (min_distance+(max_distance*.05)) and distancePointToRed <= max_distance
      end
    end
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | satisfies_bias   | " .. tostring(satisfies_bias))
    local satisfies_distance = true
    if not is_cluster_empty(hotspot_clusters[1]) or not is_cluster_empty(hotspot_clusters[2]) then
      satisfies_distance = distancePointToRed >= min_distance and distancePointToBlue >= min_distance and distancePointToRed <= max_distance and distancePointToBlue <= max_distance
    elseif coalition_bias == 1 and is_cluster_empty(hotspot_clusters[1]) then
      satisfies_distance = distancePointToBlue >= max_distance
    elseif coalition_bias == 2 and is_cluster_empty(hotspot_clusters[2]) then
      satisfies_distance = distancePointToRed >= max_distance
    end
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | satisfies_distance   | " .. tostring(satisfies_distance))
    valid = satisfies_bias and satisfies_distance
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | valid   | " .. tostring(valid))
    if glassBreak >= self.Config.operationLimit then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:generateSubZoneCircles | --- GLASSBREAK --")
      valid = true
    end
    glassBreak = glassBreak + 1
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.getSmartVec2 | final point       | x: " ..  point.x .. " | y: " .. point.y)
  return point
end

--- Identifies and categorizes units within a specified zone.
--
-- This function scans a defined zone (`t_ZOBJ`) for all units, including ground units, structures, and ships.
-- It categorizes detected units based on their coalition, providing an organized list of units within the zone.
-- This is useful for understanding the distribution and alignment of forces within a specific area, which can be
-- critical for strategic planning and decision making in gameplay scenarios.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param t_ZOBJ The zone object within which units are to be scanned and identified.
-- @return temp_detectedUnits A table categorizing detected units by coalition (0 for neutral, 1 for red, 2 for blue).
-- @usage local detectedUnits = zoneManager:FindUnitsInZone(zoneObject) -- Scans and categorizes units within the specified zone.
function SPECTRE.ZONEMGR.FindUnitsInZone(self, t_ZOBJ)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:FindUnitsInZone | -------------------------------------------- ")
  local temp_detectedUnits = {}
  temp_detectedUnits[0] = {}
  temp_detectedUnits[1] = {}
  temp_detectedUnits[2] = {}
  t_ZOBJ:Scan({Object.Category.UNIT}, {Unit.Category.GROUND_UNIT, Unit.Category.STRUCTURE, Unit.Category.SHIP})
  local scanData = t_ZOBJ.ScanData
  if scanData then
    -- Units
    if scanData.Units then
      for _, unit in pairs(scanData.Units) do
        local _unitCoal = unit:getCoalition()
        local _unitName = unit:getName()
        local _life = unit:getLife()
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:FindUnitsInZone | FOUND UNIT  | _unitCoal | " .. _unitCoal .. " | _unitName | " .. _unitName)
        temp_detectedUnits[_unitCoal][#temp_detectedUnits[_unitCoal] + 1] = {
          name = _unitName,
          unitObj = unit,
          coal = _unitCoal,
          life = _life,
        }
      end
    end
  end
  return temp_detectedUnits
end

--- Constructs a list of group names from detected units based on their coalition.
--
-- This function processes a list of detected units, filtering them by a specified coalition.
-- It retrieves the names of the groups to which these units belong.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param _detectedUnits A table containing units detected within a specific zone, categorized by coalition.
-- @param coal The coalition identifier (1 for red, 2 for blue) used to filter the detected units.
-- @return _GroupNames A table containing the names of groups that belong to the specified coalition.
-- @usage local groupNames = zoneManager:buildGroupsFromUnits(detectedUnits, coalitionId) -- Retrieves group names for units of a specific coalition.
function SPECTRE.ZONEMGR.buildGroupsFromUnits(self, _detectedUnits, coal)
  local _GroupNames = {}
  if #_detectedUnits[coal] > 0 then
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | Detected Coal Units")
    for _, _Unit in ipairs(_detectedUnits[coal]) do
      local unitName  = _Unit.name
      local _unit     = Unit.getByName(unitName)
      if _unit then
        local _Group    =  Unit.getGroup(_unit )
        if _Group then
          local groupName = Group.getName(_Group)
          if groupName then
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | group in Zone |" .. groupName)
            SPECTRE.UTILS.safeInsert(_GroupNames,groupName)
          end
        end
      end
    end
  end
  return _GroupNames
end

--- Determines the zone object for a given coordinate (Vec2).
--
-- This function iterates through all the zones managed by the ZoneManager and identifies which zone
-- a given set of coordinates (Vec2 format) falls into. This is particularly useful for pinpointing
-- the specific zone in which a marker, unit, or event is located based on its coordinates.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param vec2 The Vec2 coordinates used to determine the relevant zone.
-- @return #ZONEMGR.Zone _zoneObjectRETURN The zone object that contains the specified coordinates.
-- @usage local zoneObject = zoneManager:findZoneForVec2(coordinates) -- Retrieves the zone object for given coordinates.
function SPECTRE.ZONEMGR.findZoneForVec2(self, vec2)
  local markerInZone = false
  local _zoneObjectRETURN = {}
  for _zoneName, _zoneObject in pairs(self.Zones) do
    markerInZone = SPECTRE.POLY.PointWithinShape(vec2, _zoneObject.Vertices2D)
    if markerInZone then
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR  | mark in Zone |" .. _zoneName)
      _zoneObjectRETURN = _zoneObject
      break
    end
  end
  return _zoneObjectRETURN
end
--- x - Spawner.
-- ===
--
-- *All functions associated with Zone Manager spawning.*
--
-- ===
-- @section SPECTRE.ZONEMGR


--- Spawns airbase elements within specified zones.
--
-- This function is responsible for spawning airbase elements within the game environment. It can process one or multiple zones,
-- spawning airbases with specific characteristics such as coalition, country, and size. The function also handles the dynamic generation
-- of airfield structures based on the specified parameters. It's crucial for setting up the airbase infrastructure within different zones
-- managed by the ZONEMGR system.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param _airbaseName The name of the airbase to be spawned.
-- @param coalition The coalition to which the airbase belongs.
-- @param country The country to which the airbase belongs.
-- @param _zoneNameT (optional) Specific zone name to process, or all zones if not provided.
-- @param SPWNR_ (optional) Spawner to use for airbase generation.
-- @param SPWNRTemplate (optional) Creates a template on the fly from provided spawner, and uses that. SPWNR_ must be nil.
-- @return #ZONEMGR self The zone manager instance after spawning the airbase elements.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:spawnAirbase("Airbase1", 2, "USA", "Zone1") -- Spawns "Airbase1" in "Zone1" for the Blue coalition and USA.
function SPECTRE.ZONEMGR:spawnAirbase(_airbaseName, coalition, country, _zoneNameT, SPWNR_, SPWNRTemplate)
  _zoneNameT = _zoneNameT or nil
  SPWNR_ = SPWNR_ or nil
  SPWNRTemplate = SPWNRTemplate or nil
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | ------- ", _airbaseName)
  local zonesToProcess = _zoneNameT and {[_zoneNameT] = self.Zones[_zoneNameT]} or self.Zones
  for _zoneName, _zoneObject in pairs(zonesToProcess) do
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | Zone Name | ", _zoneName)
    local _airbaseObject = _zoneObject.Airbases[_airbaseName]
    if _airbaseObject then
      if SPWNRTemplate ~= nil then SPWNR_ = SPECTRE.SPAWNER:New():ImportTemplate(SPWNRTemplate) end
      local _spawner = SPWNR_ or SPECTRE.SPAWNER:New():ImportTemplate(self.AIRFIELDSPAWNERS[SPECTRE.UTILS.PickRandomFromKVTable(self.AIRFIELDSPAWNERS)])

      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | Airbase Object | ", _airbaseObject)
      local _vec2 = _airbaseObject.Object:GetVec2()
      local _airbaseSize = (_airbaseObject.Object.AirbaseZone.Radius * 1.5) * 2
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | Vec2.x | " .. _vec2.x)
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | Vec2.y | " .. _vec2.y)
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbase | Airbase Size | " .. _airbaseSize)

      local genIndex = #self.generatedAirfields + 1
      self.generatedAirfields[genIndex] = _spawner
      self.generatedAirfields[genIndex]:setCoalition(coalition)
      self.generatedAirfields[genIndex]:setCountry(country)
      self.generatedAirfields[genIndex]:setZoneSizeMain(_airbaseSize, _airbaseSize * 0.8, _airbaseSize * 1.2, 0.5)
      self.generatedAirfields[genIndex]:DynamicGenerationZONE(_vec2, _airbaseName)--, true, true)
    end
  end
  return self
end

--- Spawns airbases within a specific zone.
--
-- This function is designed to spawn all airbases within a given zone. It iterates through each airbase in the specified zone,
-- invoking the `spawnAirbase` method for each airbase with designated coalition and country parameters. This is essential for
-- populating specific zones with the required airbase infrastructure, tailored to the needs of the specified coalition and country.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param _zoneName The name of the zone where airbases are to be spawned.
-- @param _coalition The coalition to which the airbases will belong.
-- @param _country The country to which the airbases will belong.
-- @param SPWNRTemplate (optional) Creates a template on the fly from provided spawner, and uses that. SPWNR_ must be nil.
-- @return #ZONEMGR self The zone manager instance after spawning the airbases in the specified zone.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:spawnAirbasesInZone("Zone1", 2, "USA") -- Spawns all airbases in "Zone1" for the Blue coalition and USA.
function SPECTRE.ZONEMGR:spawnAirbasesInZone(_zoneName, _coalition, _country, SPWNRTemplate)
  SPWNRTemplate = SPWNRTemplate or nil
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbasesInZone | _zoneName | " ..  _zoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbasesInZone | coalition | " ,  _coalition)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnAirbasesInZone | country   | " ,  _country)
  local _zoneObject = self.Zones[_zoneName]
  for _airbaseName, _airbaseObject in pairs (_zoneObject.Airbases) do
    self:spawnAirbase(_airbaseName, _coalition, _country, _zoneName, nil, SPWNRTemplate)
  end
  return self
end


--- Spawns fill elements at a specified vector location within a zone.
--
-- This function is designed to spawn fill elements, such as troops or equipment, at a given vector location within a specified zone.
-- It allows customization of the spawn area's diameter, coalition, and country. The function selects a spawner template randomly or
-- uses a provided one, setting up the necessary parameters for dynamic generation within the zone. This feature is essential for
-- populating zones with various in-game elements, adding realism and strategic depth to the game environment.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param vec2_SpawnCenter The vector location (x, y coordinates) where fill elements are to be spawned.
-- @param diameter_SpawnZone The diameter of the spawn zone around the vector location.
-- @param coalition The coalition to which the fill elements will belong.
-- @param country The country to which the fill elements will belong.
-- @param _zoneName (optional) The name of the zone where the elements are to be spawned.
-- @param SPWNR_ (optional) The spawner to use for fill generation.
-- @param SPWNRTemplate (optional) Creates a template on the fly from provided spawner, and uses that. SPWNR_ must be nil.
-- @return #ZONEMGR self The zone manager instance after spawning the fill elements.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:spawnFillAtVec2({x = 1000, y = 2000}, 5000, 2, "USA", "Zone1") -- Spawns fill elements at the specified location in "Zone1".
function SPECTRE.ZONEMGR:spawnFillAtVec2(vec2_SpawnCenter, diameter_SpawnZone, coalition, country, _zoneName, SPWNR_ , SPWNRTemplate)
  SPWNR_ = SPWNR_ or nil
  SPWNRTemplate = SPWNRTemplate or nil
  _zoneName = _zoneName or nil

  if _zoneName == nil then
    local InZone = false
    for _zName, _zObject in pairs(self.Zones) do
      InZone =  SPECTRE.WORLD.PointInZone(vec2_SpawnCenter, _zName)

      if InZone then _zoneName = _zName break end
    end

  end

  if SPWNRTemplate ~= nil then SPWNR_ = SPECTRE.SPAWNER:New():ImportTemplate(SPWNRTemplate) end
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillAtVec2 | ------- ")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillAtVec2 | _zoneName : " .. _zoneName)
  local _spawner = SPWNR_ or SPECTRE.SPAWNER:New():ImportTemplate(self.FILLSPAWNERS[SPECTRE.UTILS.PickRandomFromKVTable(self.FILLSPAWNERS)])
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillAtVec2 | vec2_SpawnCenter.x | " .. vec2_SpawnCenter.x)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillAtVec2 | vec2_SpawnCenter.y | " .. vec2_SpawnCenter.y)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillAtVec2 | SpawnZone Diameter | " .. diameter_SpawnZone)

  local genIndex = #self.generatedFills + 1
  self.generatedFills[genIndex] = _spawner
  self.generatedFills[genIndex]:setCoalition(coalition)
  self.generatedFills[genIndex]:setCountry(country)
  self.generatedFills[genIndex]:setZoneSizeMain(diameter_SpawnZone, diameter_SpawnZone * 0.8, diameter_SpawnZone * 1.2, 0.5)
  self.generatedFills[genIndex]:DynamicGenerationZONE(vec2_SpawnCenter, _zoneName)--, true, true)
  return self
end

--- Spawns fill elements within a specified zone.
--
-- This function handles the spawning of fill elements like troops or equipment within a specific zone. It selects a spawner template,
-- either provided or picked randomly from available templates, and determines a central point within the zone to spawn these elements.
-- The function ensures that the spawning point and area are strategically viable and do not conflict with restricted zones. This is essential
-- for dynamically populating game zones with various elements, enhancing the gameplay experience and the tactical complexity of the zone.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param _zoneName The name of the zone where fill elements are to be spawned.
-- @param coalition The coalition to which the fill elements will belong.
-- @param country The country to which the fill elements will belong.
-- @param SPWNR_ (optional) The spawner to use for fill generation.
-- @param SPWNRTemplate (optional) Creates a template on the fly from provided spawner, and uses that. SPWNR_ must be nil.
-- @return #ZONEMGR self The zone manager instance after spawning the fill elements in the specified zone.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:spawnFillInZone("Zone1", 2, "USA") -- Spawns fill elements in "Zone1" for the Blue coalition and USA.
function SPECTRE.ZONEMGR:spawnFillInZone(_zoneName, coalition, country, SPWNR_, SPWNRTemplate)
  SPWNR_ = SPWNR_ or nil
  SPWNRTemplate = SPWNRTemplate or nil
  if SPWNRTemplate ~= nil then SPWNR_ = SPECTRE.SPAWNER:New():ImportTemplate(SPWNRTemplate) end
  local _bias = 0
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | ---- | " .. _zoneName .. " | --------")
  local _spawner = SPWNR_ or SPECTRE.SPAWNER:New():ImportTemplate(self.FILLSPAWNERS[SPECTRE.UTILS.PickRandomFromKVTable(self.FILLSPAWNERS)])
  local _zoneObject = self.Zones[_zoneName]
  local _initialMinDist, _initialMaxDist = SPECTRE.POLY.getMinMaxDistances(_zoneObject.Vertices2D)
  local _tNom = _initialMinDist/2
  local _offset = SPECTRE.UTILS.generateNominal(_tNom, _tNom*0.8, _tNom*1.2, _spawner.nudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | _offset | " .. _offset)
  local _nominal = _initialMinDist/2
  local vec2_SpawnCenter
  local flag_goodcoord = true
  local glassBreak = 0
  --_zoneObject:getHotspotGroups()
  repeat
    flag_goodcoord = true
    vec2_SpawnCenter = _zoneObject.ZONEPOLYOBJ:GetRandomVec2()
    if flag_goodcoord then flag_goodcoord = _spawner.checkNOGO(_spawner, vec2_SpawnCenter, _spawner.ZonesRestricted) end
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:spawnFillInZone | GOODCOORD? | " .. tostring(flag_goodcoord))
    if glassBreak >= _spawner.Config.operationLimit then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:spawnFillInZone | --- GLASSBREAK --")
      flag_goodcoord = true
    end
    glassBreak = glassBreak + 1
  until flag_goodcoord

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | ---- | " .. _zoneName .. " | --------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | vec2_SpawnCenter.x | " .. vec2_SpawnCenter.x)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | vec2_SpawnCenter.y | " .. vec2_SpawnCenter.y)

  local diameter_SpawnZone = SPECTRE.UTILS.generateNominal(_nominal, _nominal*0.8, _nominal*1.2, _spawner.nudgeFactor)-- scale based on zone size
  self:spawnFillAtVec2(vec2_SpawnCenter, diameter_SpawnZone, coalition, country, _zoneName, _spawner )
  return self
end

--- Spawns fill elements within a specified zone using intelligent positioning.
--
-- This function takes a strategic approach to spawn fill elements, such as troops or equipment, within a specified zone.
-- It utilizes the `getSmartVec2` method to determine an optimal spawning location based on various factors, including
-- minimum and maximum distances, hotspot clustering, and coalition bias. The function ensures the spawn point is outside
-- restricted areas and dynamically calculates the spawn zone's diameter. It's pivotal for introducing intelligent and
-- adaptive gameplay elements within the zones managed by the ZONEMGR system.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param _zoneName The name of the zone where fill elements are to be strategically spawned.
-- @param coalition The coalition to which the fill elements will belong.
-- @param country The country to which the fill elements will belong.
-- @param SPWNR_ (optional) The spawner to use for fill generation.
-- @param _bias (optional) A bias factor towards a specific coalition in positioning the fill elements.
-- @return #ZONEMGR self The zone manager instance after strategically spawning the fill elements in the specified zone.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:spawnFillInZoneSmart("Zone1", 2, "USA", nil, 0) -- Strategically spawns fill elements in "Zone1" for the Blue coalition and USA.
function SPECTRE.ZONEMGR:spawnFillInZoneSmart(_zoneName, coalition, country,  SPWNR_, _bias, SPWNRTemplate)
  SPWNR_ = SPWNR_ or nil
  SPWNRTemplate = SPWNRTemplate or nil
  if SPWNRTemplate ~= nil then SPWNR_ = SPECTRE.SPAWNER:New():ImportTemplate(SPWNRTemplate) end
  _bias = _bias or 0
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | ---- | " .. _zoneName .. " | --------")
  local _spawner = SPWNR_ or SPECTRE.SPAWNER:New():ImportTemplate(self.FILLSPAWNERS[SPECTRE.UTILS.PickRandomFromKVTable(self.FILLSPAWNERS)])
  local _zoneObject = self.Zones[_zoneName]
  local _initialMinDist, _initialMaxDist = SPECTRE.POLY.getMinMaxDistances(_zoneObject.Vertices2D)
  local _tNom = _initialMinDist/2
  local _offset = SPECTRE.UTILS.generateNominal(_tNom, _tNom*0.8, _tNom*1.2, _spawner.nudgeFactor)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | _offset | " .. _offset)
  local _nominal = _initialMinDist/2
  local vec2_SpawnCenter
  local flag_goodcoord = true
  local glassBreak = 0
  _zoneObject:getHotspotGroups()
  repeat
    flag_goodcoord = true
    vec2_SpawnCenter = self:getSmartVec2(_zoneObject.Vertices2D, _zoneObject.HotspotClusters, _bias, _initialMinDist*self._smartFillMinDistFactor, _initialMinDist) ---ZONE_POLYGON:NewFromPointsArray("Temp_" .. os.time() ,_tempZONEpoly):GetRandomVec2()--SPECTRE.POLY.getRandomPointInPolygon(_tempZONEpoly)
    if flag_goodcoord then flag_goodcoord = _spawner.checkNOGO(_spawner, vec2_SpawnCenter, _spawner.ZonesRestricted) end
    SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:spawnFillInZone | GOODCOORD? | " .. tostring(flag_goodcoord))
    if glassBreak >= _spawner.Config.operationLimit then
      SPECTRE.UTILS.debugInfo("SPECTRE.SPAWNER:spawnFillInZone | --- GLASSBREAK --")
      flag_goodcoord = true
    end
    glassBreak = glassBreak + 1
  until flag_goodcoord

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | ---- | " .. _zoneName .. " | --------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | vec2_SpawnCenter.x | " .. vec2_SpawnCenter.x)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:spawnFillInZone | vec2_SpawnCenter.y | " .. vec2_SpawnCenter.y)

  local diameter_SpawnZone = SPECTRE.UTILS.generateNominal(_nominal, _nominal*0.8, _nominal*1.2, _spawner.nudgeFactor)-- scale based on zone size
  self:spawnFillAtVec2(vec2_SpawnCenter, diameter_SpawnZone, coalition, country, _zoneName, _spawner )
  return self
end


--- x - Templates.
-- ===
--
-- *All functions associated with Zone Manager templates.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Clears all fill spawner templates in the zone manager.
--
-- This function resets the 'FILLSPAWNERS' table within the zone manager instance, effectively clearing all existing fill spawner templates.
-- It's useful for reinitializing or updating the spawner settings in the zone manager.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self
-- @usage zoneManager:clearFillSpawnerTemplates() -- Clears all fill spawner templat
function SPECTRE.ZONEMGR:clearFillSpawnerTemplates()
  self.FILLSPAWNERS = {}
  return self
end

--- Adds a fill spawner template to the zone manager.
--
-- This function adds a new spawner template or retrieves an existing one from a persistence file. It creates a unique identifier
-- for the template, checks for existing persistence files, and loads them if present. If the file is not found or if the force flag
-- is set, a new template is created from the provided spawner object. The function is essential for managing spawner templates,
-- ensuring that they are consistent and retrievable across game sessions when persistence is enabled.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param #SPAWNER _SPWNR The spawner object from which the template is created.
-- @param name_ (optional) The name of the template. Defaults to a unique identifier based on the current time.
-- @param force (optional) A boolean flag to force creation of a new template, regardless of existing persistence.
-- @return #ZONEMGR self The zone manager instance after adding or updating the spawner template.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:AddFillSpawnerTemplate(spawnerObject, "TemplateName", true) -- Adds or updates a template named "TemplateName".
function SPECTRE.ZONEMGR:AddFillSpawnerTemplate(_SPWNR, name_, force)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:AddFillSpawnerTemplate | ----------- " , _SPWNR )
  force = force or false
  local _Randname = name_ or os.time()
  local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. self.persistanceSettings.FillTemplates .. _Randname .. ".lua"
  self.FILLSPAWNERS[_Randname] = SPECTRE.BRAIN.checkAndPersist(
    _filename,
    force,
    self.FILLSPAWNERS[_Randname],
    self._persistence,
    function(_Object)  -- Update: Include _Object as a parameter
      return self._CreateSpawnerTemplate(_SPWNR, _Object)  -- Update: Pass _Object to the new function
    end
  )
  return self
end

--- Clears all Airfield spawner templates in the zone manager.
--
-- This function resets the 'AIRFIELDSPAWNERS' table within the zone manager instance, effectively clearing all existing Airfield spawner templates.
-- It's useful for reinitializing or updating the spawner settings in the zone manager.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self
-- @usage zoneManager:clearFillSpawnerTemplates() -- Clears all fill spawner templat
function SPECTRE.ZONEMGR:clearAirfieldSpawnerTemplates()
  self.AIRFIELDSPAWNERS = {}
  return self
end

--- Adds an airfield spawner template to the zone manager.
--
-- This function is responsible for adding a new airfield spawner template or retrieving an existing one from a persistence file.
-- It generates a unique identifier for the template and checks for existing persistence files, loading them if present. If no file
-- is found, or if the force creation flag is set, a new template is created from the provided spawner object. This functionality
-- is crucial for maintaining a consistent set of airfield spawner templates that can be reused and persist across game sessions.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param #SPAWNER _SPWNR The spawner object from which the airfield template is created.
-- @param name_ (optional) The name of the airfield template. Defaults to a unique identifier based on the current time.
-- @param force (optional) A boolean flag to force the creation of a new template, overriding existing persistence.
-- @return #ZONEMGR self The zone manager instance after adding or updating the airfield spawner template.
-- @usage local newZoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage newZoneManager:AddAirfieldSpawnerTemplate(spawnerObject, "AirfieldName", true) -- Adds or updates an airfield template named "AirfieldName".
function SPECTRE.ZONEMGR:AddAirfieldSpawnerTemplate(_SPWNR, name_, force)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:AddAirfieldSpawnerTemplate | ----------- " , _SPWNR )
  force = force or false
  local _Randname = name_ or os.time()
  local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. self.persistanceSettings.AirfieldTemplates .. _Randname .. ".lua"

  self.AIRFIELDSPAWNERS[_Randname] = SPECTRE.BRAIN.checkAndPersist(
    _filename,
    force,
    self.AIRFIELDSPAWNERS[_Randname],
    self._persistence,
    function(_Object)  -- Update: Include _Object as a parameter
      return self._CreateSpawnerTemplate(_SPWNR, _Object)  -- Update: Pass _Object to the new function
    end
  )
  return self
end

--- Creates a spawner template based on a provided spawner object.
--
-- This function generates a template from the given '_SPWNR' spawner object using 'SPECTRE.UTILS.templateFromObject'.
-- It updates the '_Object' with this new template.
-- This function is typically used internally within the zone manager to create or update templates for spawners.
--
-- @param _SPWNR The spawner object from which the template is to be created.
-- @param _Object The object to be updated with the new spawner template.
-- @return _Object The updated object with the new spawner template.
-- @usage local updatedObject = SPECTRE.ZONEMGR._CreateSpawnerTemplate(spawner, existingObject) -- Updates 'existingObject' with a template from 'spawner'.
function SPECTRE.ZONEMGR._CreateSpawnerTemplate(_SPWNR, _Object)
  -- Update _Object with the new template and return it
  _Object = SPECTRE.UTILS.templateFromObject(_SPWNR)
  return _Object
end

--- x - Init.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR


--- Initializes the ZoneManager with all necessary configurations.
--
-- This function is essential for starting a new ZoneManager object. It goes through a series of steps to fully initialize
-- the ZoneManager, including determining zone ownership, updating border ownership, setting drawing properties, and initializing
-- event handlers and update schedulers for each zone. This comprehensive setup ensures that all zones are properly configured
-- and ready for strategic gameplay and interactions within the game environment.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance after initialization.
-- @usage local initializedZoneManager = SPECTRE.ZONEMGR:Init() -- Initializes and configures the ZoneManager with all necessary settings.
function SPECTRE.ZONEMGR:Init()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:Init | ---------------------")
  -- Determine ownership of each zone.
  for zoneName, zoneObject in pairs(self.Zones) do
    zoneObject:DetermineZoneOwnership()
  end

  -- Update the border ownership for each zone.
  for zoneName, zoneObject in pairs(self.Zones) do
    zoneObject:UpdateBorderOwnership()
  end

  -- Determine the drawing color, draw the zone, and draw arrows for each zone.
  for zoneName, zoneObject in pairs(self.Zones) do
    zoneObject:DetermineDrawColor()
    zoneObject:DrawZone()
    zoneObject:DrawArrows()
  end
  self:InitSSB()
  -- Initialize event handlers for each zone.
  for zoneName, zoneObject in pairs(self.Zones) do
    zoneObject:InitHandlers()
  end

  -- Initialize the update scheduler.
  self:UpdateSchedInit()

  if self.Hotspots == true then
    self:HotspotSchedInit()
  end

  if self._enableCAP == true then
    self:CAPschedInit()
  end

  --  if self._AirfieldCaptureSpawns then
  --    self._AirfieldCaptureHandler = EVENT:New()
  --    self._AirfieldCaptureHandler:HandleEvent(EVENTS.BaseCaptured, function(eventData)
  --      self:_AirfieldCapture(eventData)
  --    end)
  --  end

  return self
end

--- Initializes a scheduler for periodic zone updates following base captures.
--
-- This function sets up a scheduler within the ZONEMGR system to periodically check and update zones. The updates are triggered
-- by changes resulting from base captures. It ensures that the zone states within the game environment are accurately updated to
-- reflect the latest developments, such as changes in ownership, borders, and zone draw colors. This dynamic updating is crucial
-- for maintaining an up-to-date and strategically accurate game map.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance with the update scheduler initialized.
-- @usage local updatedZoneManager = SPECTRE.ZONEMGR:UpdateSchedInit() -- Initializes the update scheduler for the ZoneManager.
function SPECTRE.ZONEMGR:UpdateSchedInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:UpdateSchedInit | ---------------------")
  self.UpdateSched = SCHEDULER:New(self, function()
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:self.UpdateSched | ")
    if not self.UpdatingZones then
      local zoneNeedsUpdate = false
      for zoneName, zoneObject in pairs(self.Zones) do
        if zoneObject.UpdateQueue > 0 then
          zoneNeedsUpdate = true
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:self.UpdateSched | ZONE NEEDS UPDATES: " .. zoneName .. " | Q:" .. zoneObject.UpdateQueue )
          self.UpdatingZones = true
          break
        end
      end
      if zoneNeedsUpdate then
        for zoneName, zoneObject in pairs(self.Zones) do
          zoneObject:DetermineZoneOwnership()
        end
        for zoneName, zoneObject in pairs(self.Zones) do
          zoneObject:UpdateBorderOwnership()
        end
        for zoneName, zoneObject in pairs(self.Zones) do
          zoneObject:DetermineDrawColor()
          zoneObject:DrawZone()
          zoneObject:DrawArrows()
        end
        for zoneName, zoneObject in pairs(self.Zones) do
          if zoneObject.UpdateQueue > 0 then
            zoneObject.UpdateQueue = zoneObject.UpdateQueue - 1
            if zoneObject.UpdateQueue > 2 then zoneObject.UpdateQueue = 2 end
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:self.UpdateSched | END UPDATE RUN: " .. zoneName .. " | Q: " .. zoneObject.UpdateQueue )
          end
        end
        self.UpdatingZones = false
      end
    end
    return self
  end, {self}, self.UpdateInterval, self.UpdateInterval, self.UpdateIntervalNudge)
  self:MarkerScheduleInit()
  return self
end

--- Initializes the marker update scheduler for the zone manager.
--
-- This function sets up a scheduler to manage marker operations within the zone manager.
-- It processes various marker queues including hotspot, marker, and marker removal queues.
-- The scheduler handles the addition, update, and removal of markers at specified intervals.
-- This only exists because of a bug in DCS. When it is fixed updates wont be tied to a schedule queue.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self
-- @usage zoneManager:MarkerScheduleInit() -- Initializes the marker update scheduler for 'zoneManager'.
function SPECTRE.ZONEMGR:MarkerScheduleInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:MarkerScheduleInit | ---------------------")

  -- Scheduler for managing marker operations
  self._markerScheduler = SCHEDULER:New(self, function()
    -- Process markers for hotspot queue
    for i = #self._hotspotQueue, 1, -1 do
      local _marker = self._hotspotQueue[i]
      if _marker then
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:MarkerSchedule | Mark Circle: " .. tostring(_marker.MarkerID))
        trigger.action.circleToAll(_marker.coal, _marker.MarkerID, _marker.Vec3, _marker.radius, _marker.color, _marker.fillColor, _marker.num, _marker.ReadOnly)
        table.remove(self._hotspotQueue, i)  -- Remove processed marker
      end
    end

    -- Process markers for marker queue
    for i = #self._markerQueue, 1, -1 do
      local _marker = self._markerQueue[i]
      if _marker then
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:MarkerSchedule | Mark Intel: " .. tostring(_marker.MarkerID))
        trigger.action.markToCoalition(_marker.MarkerID, _marker.intelString, _marker.Vec3, _marker.coal, _marker.ReadOnly)
        table.remove(self._markerQueue, i)  -- Remove processed marker
      end
    end

    -- Process markers for removal
    for i = #self._removeMarkerQueue, 1, -1 do
      local _marker = self._removeMarkerQueue[i]
      if _marker then
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:MarkerSchedule | Remove Marker: " .. tostring(_marker.MarkerID))
        trigger.action.removeMark(_marker.MarkerID)
        table.remove(self._removeMarkerQueue, i)  -- Remove processed marker
      end
    end

    return self
  end, {self}, self.UpdateInterval, self.UpdateInterval, self.UpdateIntervalNudge)  -- Schedule settings

  return self
end


--- Activates the SSB  property within the ZoneManager.
--
-- This function enables the SSB property for the ZoneManager.
-- The function allows for an optional parameter to enable or disable the SSB property, defaulting to true (enabled) if not specified.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param enabled (optional) Boolean value to enable (true) or disable (false) the SSB property. Defaults to true if not specified.
-- @return #ZONEMGR self The zone manager instance with the SSB property initialized.
-- @usage local zoneManagerWithSSB = SPECTRE.ZONEMGR:enableSSB() -- Initializes the SSB property in the ZoneManager.
function SPECTRE.ZONEMGR:enableSSB(enabled)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:InitSSB | ---------------------")
  enabled = enabled or true
  -- Enable the SSB property.
  self.SSB = enabled

  return self
end

--- Activates the SSB property within the ZoneManager.
--
-- This function inits  SSB  for the ZoneManager.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @return #ZONEMGR self The zone manager instance with the SSB property initialized.
-- @usage local zoneManagerWithSSB = SPECTRE.ZONEMGR:InitSSB() -- Initializes the SSB property in the ZoneManager.
function SPECTRE.ZONEMGR:InitSSB()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:InitSSB | ---------------------")
  if self.SSB == true then
    -- Enable the SSB property.
    -- Set the user flag "SSB" to the SSBoff value.
    trigger.action.setUserFlag("SSB", self.SSBoff)
  end
  return self
end

--- Initializes the scheduler for managing hotspots within zones.
--
-- This function iterates through all zones managed by the ZONEMGR system and initializes individual hotspot schedulers
-- for zones where hotspots are enabled. It ensures that hotspots
-- are actively managed and updated within each zone. This process is vital for maintaining a dynamic and engaging game
-- environment where strategic points (hotspots) can influence player actions and scenarios.
--
--
-- This function sets up a scheduler to periodically check and update hotspots within the zone. It ensures that the hotspots
-- and any related intelligence data are refreshed at regular intervals. The scheduler also accounts for ongoing updates,
-- avoiding overlaps in processing. This systematic approach to managing hotspots enhances the zone's dynamics, ensuring
-- that changes in game conditions are regularly reflected in hotspot statuses and information.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance with hotspot schedulers initialized for relevant zones.
-- @usage local zoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage zoneManager:HotspotSchedInit() -- Initializes hotspot schedulers for zones with hotspots enabled.
function SPECTRE.ZONEMGR:HotspotSchedInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSchedInit | ---------------------")
  for zoneName, zoneObject in pairs(self.Zones) do
    -- Initialize a scheduler to periodically check and update zones
    self._HotspotSched[zoneName] = {}
    self._HotspotSched[zoneName] = SCHEDULER:New(self, function()

        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | ZONE: " .. zoneName)
        -- Only proceed if zones are not already being updated
        if not zoneObject.UpdatingHotspots then
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATES NOT IN PROG, STARTING")
          zoneObject.UpdatingHotspots = true

          local _Timer = TIMER:New(function()
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATING     | " .. zoneObject.ZoneName )
            if zoneObject.Hotspots == true then
              zoneObject:getHotspotGroups()
              zoneObject:ClearHotspots()
              zoneObject:DrawHotspots()
            end
            if zoneObject.Intel == true then
              zoneObject:ClearIntel()
              zoneObject:getHotspotsIntel()
              --zoneObject:DrawHotspotsIntel()
            end
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | END UPDATING | " .. zoneObject.ZoneName )
            zoneObject.UpdatingHotspots = false
          end, zoneObject)
          _Timer:Start(math.random(1,5))
        else
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATES ALREADY IN PROG")
        end
    end, {self}, math.random(1,20), self.UpdateInterval, self.UpdateIntervalNudge)
  end
  return self
end

--- Initializes the Combat Air Patrol (CAP) scheduler for the zone manager.
--
-- This function sets up a scheduler to manage CAP operations within the zone manager.
--
-- It periodically checks and updates CAP units based on coalition ownership of zones.
--
-- The scheduler handles the dynamic allocation and management of CAP units, considering factors like:
-- zone ownership, available templates, and specific settings for each coalition.
--
-- It ensures CAP units are deployed and managed effectively in response to the changing game environment.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self
-- @usage zoneManager:CAPschedInit() -- Initializes the CAP scheduler for 'zoneManager'.
function SPECTRE.ZONEMGR:CAPschedInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPschedInit | ---------------------")

  self._schedlerCAP = SCHEDULER:New(self, function()
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:self.CAPsched | ")
    -- Only proceed if zones are not already being updated
    if not self.UpdatingCAP then
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPschedInit | UPDATES NOT IN PROG, STARTING")
      self.UpdatingCAP = true

      local _Timer = TIMER:New(function()
        for _coal = 1, 2, 1 do
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _coal: " .. _coal .. " ~~~~~~~~~~")
          local ownedZones = {}
          local _numTotal = 0
          for _k, _v in pairs(self.Zones) do
            _numTotal = _numTotal + 1
            if _v.OwnedByCoalition == _coal then ownedZones[_k] = _k end
          end
          local _numOwned = SPECTRE.UTILS.sumTable(ownedZones)

          local _percentOwned = _numOwned / _numTotal



          local _Templates = self._CAPtemplates[_coal]
          local _Settings = self.settingsCAP[_coal]
          local _Spawns = self._CAPspawns[_coal]
          local _genNom = SPECTRE.UTILS.generateNominal(_Settings.Nominal*_percentOwned > _Settings.Min and _Settings.Nominal*_percentOwned or _Settings.Min, _Settings.Min, _Settings.Max*_percentOwned, _Settings.NudgeFactor)
          local _FreeSpawns = _genNom - #_Spawns

          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | activeSpawns : " .. #_Spawns )
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _genNom      : " .. _genNom )
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _FreeSpawns  : " .. _FreeSpawns )

          local _SPAWNNAME = "CAP_" .. _coal
          local _spawnCountry = _coal == 1 and SPECTRE.Countries.Red or _coal == 2 and SPECTRE.Countries.Blue
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _spawnCountry   : " .. tostring(_spawnCountry) )

          while _FreeSpawns > 0 do
            local _spawnTemplate = SPECTRE.UTILS.PickRandomFromTable(_Templates)
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _spawnTemplate  : " .. tostring(_spawnTemplate ))

            local _selectedZone = SPECTRE.UTILS.PickRandomFromKVTable(ownedZones)
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPschedInit | UPDATING | _selectedZone  : " .. tostring(_selectedZone ))

            local _selectedAirbase
            if _selectedZone then
              local ownedAirbases = {}
              for _k, _v in pairs(self.Zones[_selectedZone].Airbases) do
                local _airbaseCoal = AIRBASE:FindByName(_k):GetCoalition()
                if _airbaseCoal == _coal then ownedAirbases[_k] = _k end
              end
              _selectedAirbase = SPECTRE.UTILS.PickRandomFromKVTable(ownedAirbases)
            end
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | _selectedAirbase  : " .. tostring(_selectedAirbase ))

            if _selectedAirbase then

              local typeCounter = SPECTRE.COUNTER--self.COUNTER
              local tempCode = typeCounter
              local FoundGroup

              repeat
                FoundGroup = GROUP:FindByName(_SPAWNNAME .. "_" .. tempCode .. "#001")
                if FoundGroup then
                  tempCode = tempCode + 1
                else
                  FoundGroup = false
                end
              until (FoundGroup == false)
              typeCounter = tempCode
              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | UPDATING | typeCounter     : " .. tostring(typeCounter) )

              local _specZoneObj = self.Zones[_selectedZone]
              local _initialMinDist, _initialMaxDist = SPECTRE.POLY.getMinMaxDistances(_specZoneObj.Vertices2D)

              local _bias = (math.random() > 0.5 and (_specZoneObj.HotspotClusters[1] and 1)) or ((_specZoneObj.HotspotClusters[2] and 2) or (_specZoneObj.HotspotClusters[1] and 1) ) or 0
              local _min = _bias == _coal and 0 or _initialMinDist*self._smartFillMinDistFactor
              local _max = _initialMinDist
              local _vec2SMART = self:getSmartVec2(_specZoneObj.Vertices2D, _specZoneObj.HotspotClusters, _bias , _min, _max)
              local _defenseCOORD = COORDINATE:NewFromVec2(_vec2SMART)


              local Packet = {
                Zone_Engage = _initialMinDist/2 > 92600 and _initialMinDist/2 or 92600,
                OFFSET = 1,
                Coordinate_ = _defenseCOORD,
                Alt = UTILS.FeetToMeters(UTILS.Randomize(30000, 0.15)),
                speed = UTILS.KnotsToMps(485),
                heading = nil,
                distance = nil,
                airbaseCoord = AIRBASE:FindByName(_selectedAirbase):GetCoordinate(),
              }
              Packet = SPECTRE.AI.buildWaypoints.CAP(Packet)

              if SPECTRE.DebugEnabled == 1 then
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | GROUP NAME   : " ..  _SPAWNNAME .. "_" .. tempCode)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | _bias        : " ..  _bias)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | _min         : " ..  _min)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | _max         : " ..  _max)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | Zone_Engage  : " ..  Packet.Zone_Engage)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | Alt          : " ..  Packet.Alt)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | speed        : " ..  Packet.speed)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched PACKET | UPDATING | _vec2SMART   : x = " ..  _vec2SMART.x .. " | y = " ..  _vec2SMART.y)
                --                local oppcoalt_ = {[0] = -1, [1] = 2, [2] = 1,} --2
                --                local color = {0.7, 0.46, 0.48, 0.9}
                --                local fillColor = {0.6, 0.66, 0.78, 0.5}
                --                local oppcoal = oppcoalt_[_coal]
                --                local _t = self.codeMarker_ + 1
                --                local _markID = _t
                --                self.codeMarker_= _markID
                --                trigger.action.circleToAll(-1 ,_markID , _defenseCOORD:GetVec3(),
                --                  (Packet.Zone_Engage), color, fillColor, 2, self.ReadOnly)
              end
              local _CAPgroup = SPAWN:NewWithAlias(_spawnTemplate, _SPAWNNAME .. "_" .. tempCode)
                :InitCoalition(_coal)
                :InitCountry(_spawnCountry)
                :InitCleanUp(120)
                --:InitAirbase(_selectedAirbase,SPAWN.Takeoff.Hot)
                :OnSpawnGroup(
                  function(spawnGroup_)
                    -- Build the CAP route using the spawn group and packet details
                    local route = SPECTRE.AI.buildRoute.CAP(spawnGroup_, Packet)
                    -- Configure the spawn group for the CAP
                    spawnGroup_ = SPECTRE.AI.configureCommonOptions(spawnGroup_)
                    -- Set the route for the CAP group
                    spawnGroup_:Route(route, math.random(1,5))
                  end, self)
                  :SpawnAtAirbase(AIRBASE:FindByName(_selectedAirbase),SPAWN.Takeoff.Hot,1000)
                --:Spawn()

              _CAPgroup.WIPE_ = false
              -- Common function to handle both landing and dead/crash events
              local function handleEvent(_, eventData, message)
                local coal = eventData.IniCoalition
                if _CAPgroup:CountAliveUnits() == 0 and not _CAPgroup.WIPE_ then
                  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup handleEvent | UPDATING | GROUP WIPE  : " ..  _SPAWNNAME .. "_" .. tempCode )
                  _CAPgroup.WIPE_ = true
                  local _spawnIndex = SPECTRE.UTILS.getIndex(_Spawns, _CAPgroup)
                  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup.handleEvent | UPDATING | _spawnIndex  : " ..  tostring(_spawnIndex) )
                  local _Restocktimer = TIMER:New(function()
                    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup handleEvent | UPDATING | _Restocktimer  : " ..  tostring(_SPAWNNAME) .. "_" .. tempCode )
                    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup handleEvent | UPDATING | REMOVING INDEX  : " .. tostring( _spawnIndex) .. " from " .. _coal, _Spawns )
                    table.remove(_Spawns,_spawnIndex)
                  end, self)
                  _Restocktimer:Start(_Settings.RestockTime)

                end
              end

              _CAPgroup.onGroupLand = function(_, eventData)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup.onGroupLand | UPDATING | eventData  : " , eventData )
                handleEvent(_, eventData)
              end

              _CAPgroup.onGroupCrashOrDead = function(_, eventData)
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_CAPgroup.onGroupCrashOrDead | UPDATING | eventData  : " , eventData )
                handleEvent(_, eventData)
              end

              _CAPgroup:HandleEvent(EVENTS.Land, _CAPgroup.onGroupLand)
              _CAPgroup:HandleEvent(EVENTS.Crash, _CAPgroup.onGroupCrashOrDead)
              _CAPgroup:HandleEvent(EVENTS.Dead, _CAPgroup.onGroupCrashOrDead)

              table.insert(_Spawns, _CAPgroup)
              _FreeSpawns = _FreeSpawns - 1
            else
              _FreeSpawns = 0
            end
          end
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPsched | END UPDATING | _coal: " .. _coal .. " ~~~~~~~~~~")
        end
        self.UpdatingCAP = false
        --return self
      end, self)
      _Timer:Start(math.random(1,5))
    else
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:CAPschedInit | UPDATES ALREADY IN PROG")
    end
    return self
  end, {self}, math.random(1,5), math.random(self.schedulerCAPMin,self.schedulerCAPMax), self.schedulerCAPFactor)

  return self
end


--- x - Setup.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Adds a CAP group template for a specified coalition.
--
-- This function adds a new Combat Air Patrol (CAP) group template to the zone manager for a specific coalition, ensuring no duplicates.
-- It updates the `_CAPtemplates` attribute by adding the specified group name if it's not already present.
--
-- @param #ZONEMGR self
-- @param coalition The coalition identifier (0, 1, or 2).
-- @param groupName The name of the CAP group to be added.
-- @return #ZONEMGR self
-- @usage zoneManager:addCAP(1, "CAPGroup1") -- Adds "CAPGroup1" to the CAP templates for coalition 1.
function SPECTRE.ZONEMGR:addCAP(coalition, groupName)
  if not SPECTRE.UTILS.table_hasValue( self._CAPtemplates[coalition], groupName) then
    table.insert(self._CAPtemplates[coalition],groupName )
    -- self._CAPtemplates[coalition][#self._CAPtemplates[coalition] + 1] = groupName
  end
  return self
end

--- Removes a CAP group template from a specified coalition.
--
-- This function removes a specified Combat Air Patrol (CAP) group template from the zone manager for a given coalition.
-- It locates the group name within the `_CAPtemplates` and removes it if found.
--
-- @param #ZONEMGR self
-- @param coalition The coalition identifier (0, 1, or 2).
-- @param groupName The name of the CAP group to be removed.
-- @return #ZONEMGR self
-- @usage zoneManager:removeCAP(1, "CAPGroup1") -- Removes "CAPGroup1" from the CAP templates for coalition 1.
function SPECTRE.ZONEMGR:removeCAP(coalition, groupName)
  local _index = SPECTRE.UTILS.getIndex(self._CAPtemplates[coalition], groupName)
  if _index then
    table.remove(self._CAPtemplates[coalition], _index)
  end
  return self
end

--- Adds a player UCID to the admin list.
--
-- This function adds a specified player's UCID to the zone manager's admin list, allowing for administrative control or privileges within the game.
--
-- @param #ZONEMGR self
-- @param ucid The player UCID to be added to the admin list.
-- @return #ZONEMGR self
-- @usage zoneManager:addAdmin("PlayerUCID1234") -- Adds "PlayerUCID1234" to the admin list.
function SPECTRE.ZONEMGR:addAdmin(ucid)
  self.AdminUCIDs[ucid] = ucid
  return self
end

--- Removes a player UCID from the admin list.
--
-- This function removes a specified player's UCID from the zone manager's admin list, revoking any administrative control or privileges.
--
-- @param #ZONEMGR self
-- @param ucid The player UCID to be removed from the admin list.
-- @return #ZONEMGR self
-- @usage zoneManager:removeAdmin("PlayerUCID1234") -- Removes "PlayerUCID1234" from the admin list.
function SPECTRE.ZONEMGR:removeAdmin(ucid)
  self.AdminUCIDs[ucid] = nil
  return self
end

--- Sets the interval and nudge factor for periodic zone updates.
--
-- This function configures the time interval and nudge factor for periodic updates of zones within the ZONEMGR system. The interval
-- determines how frequently the zone states are checked and potentially updated, while the nudge factor allows for slight adjustments
-- in timing to ensure optimal performance. This configuration is important for balancing the need for timely zone updates with
-- resource efficiency in the game environment.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param interval (optional) The time interval in seconds for zone updates. Defaults to 25 seconds if not specified.
-- @param nudge (optional) A nudge factor to adjust the update timing. Defaults to 0.25 if not specified.
-- @return #ZONEMGR self The zone manager instance with the updated interval settings.
-- @usage local zoneManager = SPECTRE.ZONEMGR:New() -- Creates a new ZoneManager instance.
-- @usage zoneManager:setUpdateInterval(30, 0.5) -- Sets the update interval to 30 seconds with a nudge factor of 0.5.
function SPECTRE.ZONEMGR:setUpdateInterval(interval, nudge)
  interval = interval or 25
  nudge = nudge or 0.25
  self.UpdateInterval = interval
  self.UpdateIntervalNudge = nudge
  return self
end

--- Sets the desired granularity for hotspots.
--
-- @param #ZONEMGR  self
-- @param factor Adjust this factor based on desired granularity for hotspots.
-- @return #ZONEMGR self
function SPECTRE.ZONEMGR:setAI_granularityFactor(factor)
  self.AI_f = factor
  return self
end


--- Sets the Percentage of total units for hotspots.
--
-- @param #ZONEMGR self
-- @param factor Adjust this factor based on Percentage of total units for hotspots.
-- @return #ZONEMGR self
function SPECTRE.ZONEMGR:setAI_percentFactor(factor)
  self.AI_p = factor
  return self
end

--- Configures the ZoneManager with specified zones.
--
-- This function is essential for initializing the ZoneManager with a specific set of zones. It seeds the airbases,
-- creates new Zone objects for each zone name provided, and determines the bordering zones. It also configures
-- zone-specific properties like airbases, ownership, and SSB groups. This setup is crucial for ensuring that
-- the ZoneManager is properly configured to manage the specified zones, facilitating strategic gameplay and zone
-- interactions within the game environment.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param ZoneNames A list of strings representing the names of the zones to be managed (e.g., {"Zone1", "Zone2"}).
-- @param SSBFarps Currently unused
-- @param SSBAll Currently unused
-- @return #ZONEMGR self The zone manager instance after setup with the specified zones.
-- @usage local setupZoneManager = SPECTRE.ZONEMGR:Setup({"Zone1", "Zone2"}) -- Sets up the ZoneManager with "Zone1" and "Zone2".
function SPECTRE.ZONEMGR:Setup(ZoneNames, SSBFarps, SSBAll)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:Setup | ---------------------")
  SSBFarps = SSBFarps or false
  SSBAll = SSBAll or false

  self:seedAirbase()
  for _, zone in ipairs(ZoneNames) do
    self.Zones[zone] = self.Zone:New(zone, self):enableZoneHotspot(self.Hotspots):enableHotspotIntel(self.Intel):enableAirfieldCaptureSpawns(self._AirfieldCaptureSpawns)
  end
  self:determineBorderingZones()
  for _, zone in ipairs(ZoneNames) do
    local currentZone = self.Zones[zone]

    currentZone:DetermineAirbasesInZone()
    currentZone:DetermineZoneOwnership()
    currentZone:DetermineAirbaseSSBGroups()
  end
  --    if SSBAll then
  --      currentZone:DetermineAirbaseSSBGroups_All()
  --    elseif SSBFarps then
  --      currentZone:DetermineAirbaseSSBGroups()
  --      currentZone:DetermineFARPSSBGroups()
  --    else
  --      currentZone:DetermineAirbaseSSBGroups()
  --    end
  --  end

  return self
end

--- x - Internal.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Identifies and defines the borders between adjacent zones.
--
-- This function plays a crucial role in the ZONEMGR system by identifying which zones border each other and determining
-- the specific sides where these borders occur. It comprehensively assesses each zone in relation to others, ensuring
-- that bordering zones are accurately recognized and their border details correctly established. This process is essential
-- for strategic gameplay elements, as it impacts zone control, movement, and conflict dynamics within the game environment.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance after determining the bordering zones.
-- @usage local zoneManagerWithBorders = SPECTRE.ZONEMGR:determineBorderingZones() -- Determines and defines the borders between adjacent zones in the ZoneManager.
function SPECTRE.ZONEMGR:determineBorderingZones()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:determineBorderingZones | ---------------------")
  for zoneName1, zone1 in pairs(self.Zones) do
    for zoneName2, zone2 in pairs(self.Zones) do

      -- Ensure we're not comparing a zone with itself
      if zoneName1 ~= zoneName2 then
        local borderIndex = 0  -- Initialize index for potential borders

        -- Compare borders of zone1 with zone2
        for _, lineA in ipairs(zone1.LinesVec2) do
          for _, lineB in ipairs(zone2.LinesVec2) do

            -- Check if two lines are close enough to be considered bordering
            if SPECTRE.POLY.isWithinOffset(lineA, lineB, zone1.BorderOffsetThreshold) then
              borderIndex = borderIndex + 1  -- Increment the index for borders found

              -- Initialize border data structure if it doesn't exist
              local zoneBorder = self.Zones[zoneName1].BorderingZones[zoneName2] or {}
              zoneBorder[borderIndex] = zoneBorder[borderIndex] or {}

              -- Populate border details
              local currentBorder = zoneBorder[borderIndex]
              currentBorder.OwnedByCoalition = 0
              currentBorder.ZoneLine = lineA
              currentBorder.ZoneLineLen = SPECTRE.POLY.lineLength(lineA)
              currentBorder.ZoneLineMidP = SPECTRE.POLY.getMidpoint(lineA)
              currentBorder.ZoneLineSlope = SPECTRE.POLY.calculateLineSlope(lineA)
              currentBorder.ZoneLinePerpendicularPoint = {}
              currentBorder.NeighborLine = lineB
              currentBorder.NeighborLineLen = SPECTRE.POLY.lineLength(lineB)
              currentBorder.NeighborLineMidP = SPECTRE.POLY.getMidpoint(lineB)
              currentBorder.NeighborLineSlope = SPECTRE.POLY.calculateLineSlope(lineB)
              currentBorder.NeighborLinePerpendicularPoint = {}
              currentBorder.MarkID = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
              }

              -- Determine the perpendicular points and update them
              local ArrowMP, line_, NeighborLine_, length_, NeighborLength_
              if currentBorder.ZoneLineLen <= currentBorder.NeighborLineLen then
                ArrowMP = currentBorder.ZoneLineMidP
                line_ = currentBorder.ZoneLine
                NeighborLine_ = {[1] = line_[2], [2] = line_[1]}
                length_ = self.Zones[zoneName1].ArrowLength
                NeighborLength_ = -(length_)
              else
                ArrowMP = currentBorder.NeighborLineMidP
                line_ = currentBorder.NeighborLine
                NeighborLine_ = {[1] = line_[2], [2] = line_[1]}
                length_ = self.Zones[zoneName1].ArrowLength
                NeighborLength_ = -(length_)
              end

              local _ZoneLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, line_, length_)
              local _NeighborLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, NeighborLine_, NeighborLength_)

              -- Adjust perpendicular points if needed to ensure they are within the zone shape
              if SPECTRE.POLY.PointWithinShape(_ZoneLinePerpendicularPoint, self.Zones[zoneName1].Vertices2D) then
                currentBorder.ZoneLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, line_, length_)
                currentBorder.NeighborLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, NeighborLine_, NeighborLength_)
              else
                currentBorder.ZoneLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, NeighborLine_, NeighborLength_)
                currentBorder.NeighborLinePerpendicularPoint = SPECTRE.POLY.findPerpendicularEndpoints(ArrowMP, line_, length_)
              end

              -- Save back the updated border data
              self.Zones[zoneName1].BorderingZones[zoneName2] = zoneBorder
            end
          end
        end
      end
    end
  end

  return self
end

--- Identifies the airbases relevant to the current map.
--
-- This function is crucial for establishing the correct context within the ZoneManager by identifying the airbases associated
-- with the current map. It utilizes a pre-defined lookup table that maps map names to their respective airbases, ensuring that
-- the ZoneManager is aware of the relevant airbases for zone management and related strategic decisions. This is essential for
-- accurately reflecting the geographical and strategic realities of the game's environment.
--
-- @param #ZONEMGR
-- @return #ZONEMGR self The zone manager instance after identifying the relevant airbases for the current map.
-- @usage local zoneManagerWithAirbase = SPECTRE.ZONEMGR:seedAirbase() -- Identifies and sets the airbases for the current map in the ZoneManager.
function SPECTRE.ZONEMGR:seedAirbase()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:seedAirbase | ---------------------")
  -- Define a lookup table to map map names to their respective airbases.
  local airbaseMap = {
    ["Syria"] = AIRBASE.Syria,
    ["Persia"] = AIRBASE.PersianGulf,
    ["Caucasus"] = AIRBASE.Caucasus,
    ["Sinai"] = AIRBASE.Sinai,
    ["MarianaIslands"] = AIRBASE.MarianaIslands,
    ["Nevada"] = AIRBASE.Nevada,
    ["Normandy"] = AIRBASE.Normandy,
    ["SouthAtlantic"] = AIRBASE.SouthAtlantic,
    ["TheChannel"] = AIRBASE.TheChannel
  }

  -- Set the AirbaseSeed property based on the current map name.
  self.AirbaseSeed = airbaseMap[SPECTRE.MAPNAME]

  return self
end

--- x - Live Editor.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Processes marker events for live editing in the ZoneManager.
--
-- This function handles marker events triggered by players, allowing for dynamic modifications to the game's zones.
-- It distinguishes between deletion and spawning commands, dispatching the appropriate actions based on the marker's content.
-- The function removes the original marker after processing the event to maintain a clean game environment.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the marker event, including the marker type and player information.
-- @return #ZONEMGR self The zone manager instance after processing the marker event.
-- @usage zoneManager:_EventMarker(packetData) -- Processes the marker event based on the provided packet data.
function SPECTRE.ZONEMGR:_EventMarker(Packet)
  local PlayerUCID = SPECTRE.UTILS.GetPlayerInfo(Packet.MarkInfo.author, "ucid") -- Fetching the unique ID of the player who changed the mark

  if SPECTRE.UTILS.table_contains(self.AdminUCIDs, PlayerUCID) then
    local markerType = string.upper(Packet.MarkerType[1])

    if markerType == "DEL" then
      self:_DELmarkerDispatcher(Packet)
    elseif markerType == "SPAWN" then
      self:_SPAWNmarkerDispatcher(Packet)
    end

    SPECTRE.MARKERS.World.RemoveByID(Packet.MarkInfo.idx)
  end
  return self
end

--- Dispatches delete operations based on marker events in the ZoneManager.
--
-- This function interprets marker events designated for deletion commands and routes them to the appropriate deletion functions.
-- It can handle a variety of deletion types, including zones, airfields, all airfields, and circles, providing a comprehensive
-- method for dynamically removing game elements via marker inputs.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the delete marker event, including the specific delete type and associated parameters.
-- @return #ZONEMGR self The zone manager instance after processing the delete marker event.
-- @usage zoneManager:_DELmarkerDispatcher(packetData) -- Dispatches the delete operation based on the marker event details.
function SPECTRE.ZONEMGR:_DELmarkerDispatcher(Packet)
  local _delType = string.upper(Packet.MarkerType[2])
  if _delType == "ZONE" then
    self:_DELzone(Packet)
  elseif _delType == "AIRFIELD" then
    self:_DELairfield(Packet)
  elseif _delType == "ALLAIRFIELD" then
    self:_DELallAirfield(Packet)
  elseif _delType == "CIRCLE" then
    self:_DELcircle(Packet)
  end
  return self
end

--- Dispatches spawn operations based on marker events in the ZoneManager.
--
-- This function interprets marker events designated for spawning commands and directs them to the corresponding spawning functions.
-- It is capable of handling various types of spawn requests, such as zones, airfields, all airfields, and circles,
-- providing versatile options for adding new game elements dynamically through markers.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the spawn marker event, including the specific spawn type and related parameters.
-- @return #ZONEMGR self The zone manager instance after executing the spawn marker event.
-- @usage zoneManager:_SPAWNmarkerDispatcher(packetData) -- Executes the spawn operation according to the details in the marker event.
function SPECTRE.ZONEMGR:_SPAWNmarkerDispatcher(Packet)
  local _SPAWNType = string.upper(Packet.MarkerType[2])
  if _SPAWNType == "ZONE" then
    self:_SPAWNzone(Packet)
  elseif _SPAWNType == "AIRFIELD" then
    self:_SPAWNairfield(Packet)
  elseif _SPAWNType == "ALLAIRFIELD" then
    self:_SPAWNallAirfield(Packet)
  elseif _SPAWNType == "CIRCLE" then
    self:_SPAWNcircle(Packet)
  end
  return self
end

--- Handles the deletion of a zone based on marker events in the ZoneManager.
--
-- This function processes a marker event designated for deleting a specific zone. It identifies the zone's location from the marker,
-- finds the relevant zone, and proceeds to delete any units within that zone for the specified coalition. This allows for dynamic
-- modification of the game environment in response to player inputs via markers.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the delete zone marker event, including marker type, position, and coalition.
-- @return #ZONEMGR self The zone manager instance after processing the delete zone marker event.
-- @usage zoneManager:_DELzone(packetData) -- Processes the deletion of a zone based on the marker event details.
function SPECTRE.ZONEMGR:_DELzone(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])
  local temp_detectedUnits = self:FindUnitsInZone(_Zone.ZONEPOLYOBJ)
  local _GroupNames = self:buildGroupsFromUnits(temp_detectedUnits, _coalT)
  SPECTRE.UTILS.deleteGroupsByName(_GroupNames)
  return self
end

--- Handles spawning elements in a specific zone based on marker events in the ZoneManager.
--
-- This function processes a marker event designated for spawning elements within a specific zone. It identifies the zone's location from the marker,
-- finds the relevant zone, and proceeds to spawn elements within that zone based on the specified coalition, country, and smart spawn parameters.
-- This allows for dynamic and strategic gameplay interactions through player inputs via markers.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the spawn zone marker event, including marker type, position, coalition, country, and smart spawn parameters.
-- @return #ZONEMGR self The zone manager instance after processing the spawn zone marker event.
-- @usage zoneManager:_SPAWNzone(packetData) -- Processes the spawning of elements in a zone based on the marker event details.
function SPECTRE.ZONEMGR:_SPAWNzone(Packet)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | ---------------------")
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])
  local _countryT = tonumber(MarkerType[4])
  local _convCoal, _convCountry

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | _coalT     | " .. MarkerType[3])
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | _countryT  | " .. MarkerType[4])

  if _countryT == 1 then _convCountry = SPECTRE.Countries.Red
  elseif _countryT == 2 then _convCountry = SPECTRE.Countries.Blue
  end

  if _coalT == 1 then _convCoal = SPECTRE.Coalitions.Red
  elseif _coalT == 2 then _convCoal = SPECTRE.Coalitions.Blue
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | ZoneName | ----- " .. _Zone.ZoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | Coal     | " .. _convCoal)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNzone | Country  | " .. _convCountry)

  local _smart = MarkerType[5] or 0
  if _smart == 0 then
    self:spawnFillInZone(_Zone.ZoneName, _convCoal, _convCountry)
  else
    local _bias = MarkerType[6] or 0
    self:spawnFillInZoneSmart(_Zone.ZoneName, _convCoal, _convCountry, nil, _bias)
  end

  return self
end
--- Deletes an airfield and its associated elements based on a marker event in the ZoneManager.
--
-- This function processes a marker event designated for deleting an airfield within a specific zone. It identifies the closest airfield based on the marker's location,
-- then finds and deletes all related groups within a defined radius of the airfield. This allows for dynamic changes in the game environment in response to player inputs via markers.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the delete airfield marker event, including marker type, position, and coalition.
-- @return #ZONEMGR self The zone manager instance after processing the delete airfield marker event.
-- @usage zoneManager:_DELairfield(packetData) -- Processes the deletion of an airfield and its associated elements based on the marker event details.
function SPECTRE.ZONEMGR:_DELairfield(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])

  local tABList = {}
  for _name, _ in pairs (_Zone.Airbases) do
    table.insert(tABList,_name)
  end

  local closestAB_ = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(tABList, vec2)
  local closestABVec3 = closestAB_[2]
  local t_ZOBJ = ZONE_RADIUS:New("TEMPZ_", mist.utils.makeVec2(closestABVec3), 15000, true)

  local temp_detectedUnits = self:FindUnitsInZone(t_ZOBJ)
  local _GroupNames = self:buildGroupsFromUnits(temp_detectedUnits, _coalT)

  SPECTRE.UTILS.deleteGroupsByName(_GroupNames)
  return self
end

--- Spawns an airfield based on a marker event in the ZoneManager.
--
-- This function handles a marker event designated for spawning an airfield within a specific zone. It calculates the closest airfield to the marker's position,
-- and then initiates the spawning of the airfield with the specified coalition and country parameters. This functionality allows for dynamic and strategic modifications
-- to the game environment in response to player inputs via markers.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the spawn airfield marker event, including marker type, position, coalition, and country.
-- @return #ZONEMGR self The zone manager instance after processing the spawn airfield marker event.
-- @usage zoneManager:_SPAWNairfield(packetData) -- Processes the spawning of an airfield based on the marker event details.
function SPECTRE.ZONEMGR:_SPAWNairfield(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])
  local _countryT = tonumber(MarkerType[4])
  local _convCoal, _convCountry

  if _countryT == 1 then _convCountry = SPECTRE.Countries.Red
  elseif _countryT == 2 then _convCountry = SPECTRE.Countries.Blue
  end

  if _coalT == 1 then _convCoal = SPECTRE.Coalitions.Red
  elseif _coalT == 2 then _convCoal = SPECTRE.Coalitions.Blue
  end


  local tABList = {}
  for _name, _ in pairs (_Zone.Airbases) do
    table.insert(tABList,_name)
  end

  local closestAB_ = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(tABList, vec2)
  self:spawnAirbase(closestAB_[1], _convCoal, _convCountry )
  return self
end

--- Deletes all airfields within a specific zone based on a marker event.
--
-- This function is responsible for handling a marker event that signals the deletion of all airfields within a designated zone.
-- It identifies the airbases within the zone specified by the marker's position and then proceeds to remove any related units
-- for the specified coalition. This function allows for dynamic and strategic control of airfield availability in the game environment,
-- offering an advanced level of interactivity and adaptability in response to player inputs.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the delete all airfield marker event, including marker type, position, and coalition.
-- @return #ZONEMGR self The zone manager instance after processing the delete all airfield marker event.
-- @usage zoneManager:_DELallAirfield(packetData) -- Processes the deletion of all airfields in a specified zone based on the marker event.
function SPECTRE.ZONEMGR:_DELallAirfield(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])

  for _name, _airbase in pairs (_Zone.Airbases) do
    --table.insert(tABList,_name)
    local closestAB_ = _airbase.Object
    local closestABVec2 = closestAB_:GetVec2()
    local t_ZOBJ = ZONE_RADIUS:New("TEMPZ_", closestABVec2, 15000, true)

    local temp_detectedUnits = self:FindUnitsInZone(t_ZOBJ)
    local _GroupNames = self:buildGroupsFromUnits(temp_detectedUnits, _coalT)

    SPECTRE.UTILS.deleteGroupsByName(_GroupNames)

  end
  return self
end

--- Spawns all airfields within a specific zone based on a marker event.
--
-- This function handles a marker event that instructs the spawning of all airfields within a designated zone. It determines
-- the airbases within the zone specified by the marker's position and spawns them for the specified coalition and country. This function
-- offers a dynamic approach to manage airfield availability within the game environment, responding to player inputs to adaptively modify
-- the strategic landscape.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the spawn all airfield marker event, including marker type, position, coalition, and country.
-- @return #ZONEMGR self The zone manager instance after processing the spawn all airfield marker event.
-- @usage zoneManager:_SPAWNallAirfield(packetData) -- Processes the spawning of all airfields in a specified zone based on the marker event.
function SPECTRE.ZONEMGR:_SPAWNallAirfield(Packet)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | ---------------------")
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])
  local _countryT = tonumber(MarkerType[4])
  local _convCoal, _convCountry

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | _coalT     | " .. MarkerType[3])
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | _countryT  | " .. MarkerType[4])


  if _countryT == 1 then _convCountry = SPECTRE.Countries.Red
  elseif _countryT == 2 then _convCountry = SPECTRE.Countries.Blue
  end

  if _coalT == 1 then _convCoal = SPECTRE.Coalitions.Red
  elseif _coalT == 2 then _convCoal = SPECTRE.Coalitions.Blue
  end
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | ZoneName | ----- " .. _Zone.ZoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | Coal     | " .. _convCoal)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:_SPAWNallAirfield | Country  | " .. _convCountry)

  self:spawnAirbasesInZone(_Zone.ZoneName, _convCoal, _convCountry )
  return self
end

--- Deletes units within a specified circular area based on a marker event.
--
-- This function processes a marker event that indicates the deletion of units within a circular area. It identifies the center
-- and radius of the circle from the marker's position and the additional parameters specified in the marker. The function then finds all units
-- within this area belonging to the specified coalition and removes them. This offers a precise and dynamic way to modify the game environment
-- based on player inputs, allowing for flexible manipulation of unit distributions within a defined radius.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the delete circle marker event, including the marker type, position, coalition, and radius.
-- @return #ZONEMGR self The zone manager instance after processing the delete circle marker event.
-- @usage zoneManager:_DELcircle(packetData) -- Processes the deletion of units within a circular area based on the marker event.
function SPECTRE.ZONEMGR:_DELcircle(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _Zone = self:findZoneForVec2(vec2)
  local _coalT = tonumber(MarkerType[3])
  local _radT = tonumber(MarkerType[4])/2

  local t_ZOBJ = ZONE_RADIUS:New("TEMPZ_", vec2, _radT, true)
  local temp_detectedUnits = self:FindUnitsInZone(t_ZOBJ)

  local _GroupNames = self:buildGroupsFromUnits(temp_detectedUnits, _coalT)

  SPECTRE.UTILS.deleteGroupsByName(_GroupNames)
  return self
end

--- Spawns units within a specified circular area based on a marker event.
--
-- This function processes a marker event that indicates the spawning of units within a circular area. It identifies the center,
-- radius, coalition, and country for the spawn area from the marker's details. The function then spawns units accordingly within this
-- circular zone, offering dynamic gameplay changes based on player inputs. This enables the creation of new units in specific areas,
-- allowing for flexible and strategic gameplay alterations.
--
-- @param #ZONEMGR self The instance of the zone manager.
-- @param Packet Table containing details about the spawn circle marker event, including the marker type, position, coalition, radius, and country.
-- @return #ZONEMGR self The zone manager instance after processing the spawn circle marker event.
-- @usage zoneManager:_SPAWNcircle(packetData) -- Processes the spawning of units within a circular area based on the marker event.
function SPECTRE.ZONEMGR:_SPAWNcircle(Packet)
  local MarkerType = Packet.MarkerType
  local MarkInfo = Packet.MarkInfo
  local vec2 = mist.utils.makeVec2(MarkInfo.pos)
  local _coalT = tonumber(MarkerType[3])
  local _diaT = tonumber(MarkerType[4])
  local _countryT = tonumber(MarkerType[5])
  local _nameT = MarkerType[6] or "TESTZONE" .. os.time()
  local _convCoal, _convCountry
  if _countryT == 1 then _convCountry = SPECTRE.Countries.Red
  elseif _countryT == 2 then _convCountry = SPECTRE.Countries.Blue
  end
  if _coalT == 1 then _convCoal = SPECTRE.Coalitions.Red
  elseif _coalT == 2 then _convCoal = SPECTRE.Coalitions.Blue
  end
  self:spawnFillAtVec2(vec2, _diaT, _convCoal, _convCountry, _nameT )
  return self
end


--- x - Live Edit Cfg.
-- ===
--
-- *All Functions associated with Zone Manager operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Marker settings for the SPECTRE.ZONEMGR module.
-- @field #SPECTRE.ZONEMGR.MARKERS
SPECTRE.ZONEMGR.MARKERS = {}

---.
--@field #SPECTRE.ZONEMGR.MARKERS.Settings
SPECTRE.ZONEMGR.MARKERS.Settings = {}
--- Marker settings for deletion commands.
-- @field #SPECTRE.ZONEMGR.MARKERS.Settings.DEL
SPECTRE.ZONEMGR.MARKERS.Settings.DEL = {}
SPECTRE.ZONEMGR.MARKERS.Settings.DEL.TagName = "/del"
SPECTRE.ZONEMGR.MARKERS.Settings.DEL.KeyWords = {"zone", "airfield", "circle", "allairfield"} --must update event handler hard code if changed
SPECTRE.ZONEMGR.MARKERS.Settings.DEL.CaseSensitive = false
SPECTRE.ZONEMGR.MARKERS.Settings.DEL.MarkerEnum = "DEL"

--- Marker settings for spawn commands.
-- @field #SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN
SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN = {}
SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN.TagName = "/spawn"
SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN.KeyWords = {"zone", "airfield", "circle", "allairfield"} --must update event handler hard code if changed
SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN.CaseSensitive = false
SPECTRE.ZONEMGR.MARKERS.Settings.SPAWN.MarkerEnum = "SPAWN"

--- Tracker for marker events.
-- @field #SPECTRE.ZONEMGR.MARKERS.TRACKERS
SPECTRE.ZONEMGR.MARKERS.TRACKERS = {}

--- Settings for the SPECTRE.ZONEMGR module.
SPECTRE.ZONEMGR.Settings = {}
--- Settings for edit functionalities.
SPECTRE.ZONEMGR.Settings.Edit = {}
SPECTRE.ZONEMGR.Settings.Edit.DEL = true
SPECTRE.ZONEMGR.Settings.Edit.SPAWN = true

--- Zone TypeDef.
--
-- Defines and manages properties and attributes associated with a Zone in the SPECTRE.ZONEMGR system.
--
-- This class is responsible for:
--
-- * Defining properties of a zone such as its shape, coalition, color, and more.
-- * Handling interactions with airbases and neighboring zones.
-- * Managing event handling and related attributes.
--
-- @section SPECTRE.ZONEMGR
-- @field #ZONEMGR.Zone
SPECTRE.ZONEMGR.Zone = {}
--- Flag to indicate if _AirfieldCaptureSpawns.
SPECTRE.ZONEMGR.Zone._AirfieldCaptureSpawns = false
--- Specifies the name of the zone.
SPECTRE.ZONEMGR.Zone.ZoneName = ""
--- Moose ZonePoly.
-- @field #ZONEMGR.Zone.ZONEPOLYOBJ
SPECTRE.ZONEMGR.Zone.ZONEPOLYOBJ = {}
--- Detected ground units in zone.
-- @field #ZONEMGR.Zone._detectedUnits
SPECTRE.ZONEMGR.Zone._detectedUnits = {}
--- Density-based clustering for ground units in zone.
-- @field #ZONEMGR.Zone._DBScan
SPECTRE.ZONEMGR.Zone._DBScan = {}
---.
SPECTRE.ZONEMGR.Zone._DBScanInProg = false
--- Processed DB clusters for ground units in zone.
-- @field #ZONEMGR.Zone.HotspotClusters
SPECTRE.ZONEMGR.Zone.HotspotClusters = {}
--- Marker storage for DB clusters.
-- @field #ZONEMGR.Zone.HotspotMarkers
SPECTRE.ZONEMGR.Zone.HotspotMarkers = {}
--- Intel Marker storage for DB clusters.
-- @field #ZONEMGR.Zone.IntelMarkers
SPECTRE.ZONEMGR.Zone.IntelMarkers = {}
--- Added to calculated radius for hotspot, extends radius of drawn circle, meters.
SPECTRE.ZONEMGR.Zone._hotspotDrawExtension = 1000
--- Area of Zone.
-- Hotspots
SPECTRE.ZONEMGR.Zone.Area = 0
--- Epsilon value for DBSCAN clustering.
-- Hotspots
SPECTRE.ZONEMGR.Zone.epsilon = 0
--- Minimum sample size for DBSCAN clustering.
-- Hotspots
SPECTRE.ZONEMGR.Zone.min_samples = 0
--- Adjust this factor based on desired granularity for hotspots.
-- Hotspots
SPECTRE.ZONEMGR.Zone.AI_f = 2 -- 1.5
--- Percentage of total units (adjust based on your use case).
-- Hotspots
SPECTRE.ZONEMGR.Zone.AI_p = 0.1 -- 0.02
--- Flag to indicate if the zone is currently being updated.
SPECTRE.ZONEMGR.Zone.UpdatingZone = false
--- Counter to track pending updates for the zone.
SPECTRE.ZONEMGR.Zone.UpdateQueue = 0
--- Reference to the ZoneManager managing this Zone.
-- @field #ZONEMGR.Zone.ZoneManager
SPECTRE.ZONEMGR.Zone.ZoneManager = {}
--- UpdatingHotSpots Flag indicating if hotspots are currently being updated.
SPECTRE.ZONEMGR.Zone.UpdatingHotspots = false
--- HotspotSched Scheduler for periodic unit hotspot drawing updates.
-- @field #ZONEMGR.Zone.HotspotSched
SPECTRE.ZONEMGR.Zone.HotspotSched = {}
--- Boolean Toggle for drawing unit hotspots (default false).
SPECTRE.ZONEMGR.Zone.Hotspots = false
--- Boolean Toggle for giving hotspot Intel (default false).
SPECTRE.ZONEMGR.Zone.Intel = false
--- Specifies the shape of the zone (Default: 7=Freeform).
SPECTRE.ZONEMGR.Zone.shapeId = 7
--- Specifies the coalition ownership of the zone (Default: All=-1).
SPECTRE.ZONEMGR.Zone.Coalition = -1
--- RGB values defining the color of the zone (Default: Black).
-- @field #ZONEMGR.Zone.Color
SPECTRE.ZONEMGR.Zone.Color = {0,0,0}
--- Transparency of the zone (Default: 0.80).
-- @field #ZONEMGR.Zone.Alpha
SPECTRE.ZONEMGR.Zone.Alpha = 0.80
--- RGB values defining the fill color of the zone (Default: Black).
-- @field #ZONEMGR.Zone.FillColor
SPECTRE.ZONEMGR.Zone.FillColor = {0,0,0}
--- Lookup table for RGB values based on coalition ownership.
-- @field #ZONEMGR.Zone._Colors
SPECTRE.ZONEMGR.Zone._Colors = {
  [0] = {0, 0, 0},
  [1] = {1, 0, 0},
  [2] = {0, 0, 1}
}
--- Lookup table for RGB fill colors based on coalition ownership.
-- @field #ZONEMGR.Zone._FillColors
SPECTRE.ZONEMGR.Zone._FillColors = {
  [0] = {0, 0, 0},
  [1] = {1, 0, 0},
  [2] = {0, 0, 1}
}
--- Lookup table for RGB arrow colors with transparency based on coalition ownership.
-- @field #ZONEMGR.Zone._ArrowColors
SPECTRE.ZONEMGR.Zone._ArrowColors = {
  [0] = {0, 0, 0, 0.80},
  [1] = {1, 0, 0, 0.80},
  [2] = {0, 0, 1, 0.80}
}
--- Specifies the transparency of the zone's fill color (Default: 0.20).
-- @field #ZONEMGR.Zone.FillAlpha
SPECTRE.ZONEMGR.Zone.FillAlpha = 0.20
--- Specifies the line type of the zone's border (Default: 4=Dot dash).
-- @field #ZONEMGR.Zone.LineType
SPECTRE.ZONEMGR.Zone.LineType = 4
--- Flag indicating if the zone marker is read-only (Default: true).
-- @field #ZONEMGR.Zone.ReadOnly
SPECTRE.ZONEMGR.Zone.ReadOnly = true
--- List of airbases contained within the zone.
-- @field #ZONEMGR.Zone.Airbases
SPECTRE.ZONEMGR.Zone.Airbases = {}
--- Event handler for the zone.
-- @field #ZONEMGR.Zone.Handler_
SPECTRE.ZONEMGR.Zone.Handler_ = EVENT:New()
--- Event handler for base capture events within the zone.
-- @field #ZONEMGR.Zone.BaseCapturedHandler_
SPECTRE.ZONEMGR.Zone.BaseCapturedHandler_ = {}
--- List of Static Shore-Based (SSB) entities within the zone.
-- @field #ZONEMGR.Zone.SSBList
SPECTRE.ZONEMGR.Zone.SSBList = {}
--- Specifies the coalition that owns the zone (Default: 0=Neutral).
-- @field #ZONEMGR.Zone.OwnedByCoalition
SPECTRE.ZONEMGR.Zone.OwnedByCoalition = 0
--- Specifies the coalition that previously owned the zone (Default: 0=Neutral).
-- @field #ZONEMGR.Zone.OldOwnedByCoalition
SPECTRE.ZONEMGR.Zone.OldOwnedByCoalition = 0
--- ID representing the drawn zone marker.
-- @field #ZONEMGR.Zone.DrawnZoneMarkID
SPECTRE.ZONEMGR.Zone.DrawnZoneMarkID = 0
--- Value indicating the threshold for border offsets (Default: 800).
-- @field #ZONEMGR.Zone.BorderOffsetThreshold
SPECTRE.ZONEMGR.Zone.BorderOffsetThreshold = 800
--- Specifies the length of arrows for the zone (Default: 20000).
-- @field #ZONEMGR.Zone.ArrowLength
SPECTRE.ZONEMGR.Zone.ArrowLength = 20000
--- List of zones that share a border with the current zone.
-- @field #ZONEMGR.Zone.BorderingZones
SPECTRE.ZONEMGR.Zone.BorderingZones = {}
--- 2D vertices that define the boundaries of the zone.
-- @field #ZONEMGR.Zone.Vertices2D
SPECTRE.ZONEMGR.Zone.Vertices2D = {
  [1] = {x = 0, y = 0},
  [2] = {x = 0, y = 0},
  [3] = {x = 0, y = 0},
  [4] = {x = 0, y = 0},
}
--- 3D vertices that define the boundaries of the zone.
-- @field #ZONEMGR.Zone.Vertices3D
SPECTRE.ZONEMGR.Zone.Vertices3D = {
  [1] = {x = 0, y = 0, z = 0},
  [2] = {x = 0, y = 0, z = 0},
  [3] = {x = 0, y = 0, z = 0},
  [4] = {x = 0, y = 0, z = 0},
}
--- Lines that define the boundaries of the zone in vector format.
-- @field #ZONEMGR.Zone.LinesVec2
SPECTRE.ZONEMGR.Zone.LinesVec2 = {}


--- Create a new Zone object.
--
-- This function initializes a new Zone object within the SPECTRE.ZONEMGR system. It involves inheriting properties from the BASE class,
-- setting essential attributes like ZoneManager and ZoneName, and performing geometric conversions. The function handles the transformation
-- of the zone's 2D vertices into lines and 3D coordinates, essential for zone manipulation and management in a 3D environment.
-- This method is vital for creating zones with accurately defined boundaries and properties.
--
-- @param #ZONEMGR.Zone self The base instance from which the new Zone object is derived.
-- @param ZoneName The name of the quadpoint zone to be transformed into a Zone object.
-- @param #ZONEMGR ZoneManager The parent ZoneManager managing this Zone.
-- @return #ZONEMGR.Zone self The newly created and initialized Zone object.
-- @usage local newZone = SPECTRE.ZONEMGR.Zone:New("SomeZoneName", someZoneManager) -- Creates a new Zone object with the specified name and ZoneManager.
function SPECTRE.ZONEMGR.Zone:New(ZoneName, ZoneManager)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:New | ---------------------")
  -- Inherit properties from the BASE class.
  local self = BASE:Inherit(self, SPECTRE:New())

  -- Set the ZoneManager and ZoneName properties.
  self.ZoneManager = ZoneManager
  self.ZoneName = ZoneName
  self.ZONEPOLYOBJ = ZONE_POLYGON:FindByName(ZoneName)
  -- Get the 2D vertices of the zone, ensuring they form a convex shape.
  self.Vertices2D = SPECTRE.POLY.ensureConvex(mist.DBs.zonesByName[ZoneName].verticies)
  self.Area = SPECTRE.POLY.polygonArea(self.Vertices2D)
  -- Convert the 2D vertices to lines.
  self.LinesVec2 = SPECTRE.POLY.convertZoneToLines(self.Vertices2D)
  
  self.AI_p = ZoneManager.AI_p
  self.AI_f = ZoneManager.AI_f
  
SPECTRE.ZONEMGR.f = 2 -- 1.5
--- Percentage of total units (adjust based on your use case).
-- Hotspots
SPECTRE.ZONEMGR.p = 0.1 -- 0.02


  -- Convert the 2D vertices to 3D coordinates.
  self.Vertices3D = {}
  for index, vertex2D in ipairs(self.Vertices2D) do
    self.Vertices3D[index] = mist.utils.makeVec3(vertex2D)
  end

  return self
end

--- x - Zone Functions.
-- ===
--
-- *All Functions associated with Zone operations.*
--
-- ===
-- @section SPECTRE.ZONEMGR

--- Handle base capture events.
--
-- This function is triggered when a base capture event occurs within the game. It plays a crucial role in updating the zone's state
-- in response to these events. Specifically, it increments the UpdateQueue each time a base is captured. Additionally, if the captured
-- airbase lies within the current zone and the SSB system is enabled in the ZoneManager, it updates
-- the SSB airfield configuration accordingly. This ensures that changes in base control are accurately reflected within the zone's operational context.
--
-- @param #ZONEMGR.Zone self The Zone instance handling the base capture event.
-- @param eventData Table containing the base captured event data.
-- @return #ZONEMGR.Zone self The Zone instance after processing the base capture event.
function SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_(eventData)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | ---------------------")
  -- Increment the UpdateQueue.
  self.UpdateQueue = self.UpdateQueue + 1

  -- Check if the captured airbase is within this zone.
  local capturedAirbase = self.Airbases[eventData.PlaceName]

  if capturedAirbase then
    capturedAirbase.oldOwnedBy = capturedAirbase.ownedBy
    capturedAirbase.ownedBy = capturedAirbase.Object:GetCoalition()--eventData.initiator.getCoalition(eventData.initiator)
  end

  if capturedAirbase and self.ZoneManager.SSB then
    self:UpdateSSBAirfield(eventData.PlaceName)
  end

  if self._AirfieldCaptureSpawns == true then


    if capturedAirbase and
      -- self._AirfieldCaptureSpawns == true and
      capturedAirbase.oldOwnedBy ~= capturedAirbase.ownedBy
      and capturedAirbase.oldOwnedBy ~= 3
    then
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | ---------------------")
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | CaptureSPAWN: " .. tostring(self._AirfieldCaptureSpawns))
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | Airfield    : " .. tostring(eventData.PlaceName))
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | Initiator   : " , eventData.initiator)
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | eventData   : " , eventData)
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | IniCoal     : " .. tostring(eventData.initiator.getCoalition(eventData.initiator)))
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:BaseCapturedHandler_ | IniCountry  : " .. tostring(eventData.initiator.getCountry(eventData.initiator)))
      self.ZoneManager:spawnAirbase(eventData.PlaceName, eventData.initiator.getCoalition(eventData.initiator), eventData.initiator.getCountry(eventData.initiator))
    end
  end
  if capturedAirbase and
    self._AirfieldCaptureClean
  then
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | ---------------------")

    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | removeJunk")
    local _vec2Clean = self.Airbases[eventData.PlaceName].vec2
    local _height = land.getHeight(_vec2Clean)
    local volS = {
      id = world.VolumeType.SPHERE,
      params = {
        point = {x = _vec2Clean.x, y = _height, z = _vec2Clean.y},
        radius = 5000
      }
    }
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | _vec2Clean", _vec2Clean)
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | _height", _height)
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | volS", volS)
    world.removeJunk(volS)

    --    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | removeDeadUnits")
    --    local t_ZOBJ = ZONE_RADIUS:New(tostring(os.time()) .. "_TEMP",_vec2Clean,volS.params.radius)
    --    local foundUnits = self.ZoneManager:FindUnitsInZone(t_ZOBJ)
    --
    --    SPECTRE.IO.PersistenceToFile("TEST/MISTDBs/deadObjects.lua", mist.DBs.deadObjects)
    --
    --    --Clean dead units
    --
    --    for _indexID, _Object in pairs (mist.DBs.deadObjects) do
    --
    --      if _Object.objectData then
    --        local _vec2 = {x = _Object.objectData.pos.x, y = _Object.objectData.pos.z}
    --
    --        if SPECTRE.POLY.distance(_vec2Clean, _vec2) < 5000 then
    --          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | Determined at airfield : " ..  _Object.objectData.unitName)
    --          trigger.action.explosion(_Object.objectData.pos , 1000 )
    --          --        local _unit = Unit.getByName(_Object.objectData.unitName)
    --          --        _unit:destroy()
    --        end
    --      end
    --
    --    end
    --
    --
    --    for _i = 0, 2, 1 do
    --      if foundUnits[_i] and #foundUnits[_i] > 0 then
    --        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | removeDeadUnits - Found Units to remove for: " .. _i)
    --        for _index, unit in ipairs (foundUnits[_i]) do
    --          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | Unit Name: ".. tostring( unit.name))
    --          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | Unit Life: ".. tostring( unit.life))
    --          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:_AirfieldCaptureClean | Unit: ", unit)
    --          if unit.life <= 2 then
    --            unit.unitObj:destroy(false)
    --          end
    --        end
    --      end
    --    end
  end

  return self
end

--- Bind the event handler for base capture events.
--
-- This function is crucial for integrating the zone with the game's event system, specifically for base capture events.
-- It binds the `BaseCapturedHandler_` function to the `BaseCaptured` event, allowing the zone to appropriately respond
-- and handle situations when a base within its boundaries is captured. This binding ensures that the zone's state and behavior
-- are dynamically updated in response to in-game actions and changes, particularly those involving base control.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after binding the event handler.
-- @usage local zoneWithHandler = someZone:InitHandlers() -- Binds the `BaseCapturedHandler_` to handle base capture events for the specified zone.
function SPECTRE.ZONEMGR.Zone:InitHandlers()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:InitHandlers | ---------------------")
  -- Bind the BaseCapturedHandler_ function to the BaseCaptured event.
  self:HandleEvent(EVENTS.BaseCaptured, self.BaseCapturedHandler_)

  return self
end

--- Determine the ownership of the zone.
--
-- This function assesses which coalition currently owns a particular zone based on the count of airbases under the control of each coalition within the zone.
-- It iterates through the airbases, tallying those controlled by the red and blue coalitions. The ownership of the zone is then determined by the coalition
-- with the majority of airbases. This function is essential for dynamically reflecting the shifting control of territories within the game environment.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after determining its ownership.
-- @usage local zoneWithOwnership = someZone:DetermineZoneOwnership() -- Determines the ownership of the specified zone.
function SPECTRE.ZONEMGR.Zone:DetermineZoneOwnership()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineZoneOwnership | ---------------------")
  -- Initialize counters for each coalition.
  local blueCount = 0
  local redCount = 0

  -- Count the number of airbases owned by each coalition.
  for AirbaseName, _ in pairs(self.Airbases) do
    local airbase = AIRBASE:FindByName(AirbaseName)
    local coalition = airbase:GetCoalition()

    if coalition == 1 then
      redCount = redCount + 1
    elseif coalition == 2 then
      blueCount = blueCount + 1
    end
  end

  local _tx = self.OwnedByCoalition
  self.OldOwnedByCoalition = _tx

  -- Determine the zone ownership based on the counts.
  if redCount > blueCount then
    self.OwnedByCoalition = 1  -- Red coalition
  elseif blueCount > redCount then
    self.OwnedByCoalition = 2  -- Blue coalition
  else
    self.OwnedByCoalition = 0  -- Neutral or no clear ownership
  end

  return self
end

--- Update the coalition ownership of each bordering zone.
--
-- This function is vital for maintaining the dynamic and interconnected nature of territorial control within the game.
-- It iterates over each zone that borders the current zone and updates its coalition ownership to reflect the coalition status
-- of the main zone's bordering zones. This approach ensures that changes in territorial control ripple out appropriately to
-- neighboring zones, reflecting a more realistic and strategic environment.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after updating the ownership of its bordering zones.
-- @usage local zoneWithUpdatedBorders = someZone:UpdateBorderOwnership() -- Updates the coalition ownership of each bordering zone for the specified zone.
function SPECTRE.ZONEMGR.Zone:UpdateBorderOwnership()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateBorderOwnership | ---------------------")
  -- Iterate over each bordering zone and update its coalition ownership.
  for BorderZoneName, BorderZone in pairs(self.BorderingZones) do
    BorderZone.OwnedByCoalition = self.ZoneManager.Zones[BorderZoneName].OwnedByCoalition
  end

  return self
end

--- Determine the drawing color for the zone.
--
-- This function assigns a drawing color to the zone based on its current coalition ownership. It checks the zone's coalition status
-- and selects a corresponding color from predefined color sets (_Colors and _FillColors). If no matching color is found in these sets,
-- the zone retains its existing color. This functionality is crucial for visually representing the dynamic control of different coalitions
-- over zones, enhancing the player's understanding and strategic decision-making based on territorial control.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after determining and setting the drawing color.
-- @usage local zoneWithDrawColor = someZone:DetermineDrawColor() -- Determines the drawing color for the specified zone based on its coalition ownership.
function SPECTRE.ZONEMGR.Zone:DetermineDrawColor()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineDrawColor | ---------------------")
  -- Determine the drawing color based on the coalition ownership.
  self.Color = self._Colors[self.OwnedByCoalition] or self.Color
  self.FillColor = self._FillColors[self.OwnedByCoalition] or self.FillColor

  return self
end

--- Draw the zone on the map.
--
-- This function is responsible for visually representing the zone on the map using its defined color properties. It first checks if a marker
-- for the zone already exists and removes it to avoid duplication. The function then draws the new zone using its current color and fill color,
-- along with other defined properties. This visual representation is key for players to easily identify and differentiate zones based on their
-- current status and coalition control, enhancing the strategic aspect of the game.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after being drawn on the map.
-- @usage local drawnZone = someZone:DrawZone() -- Draws the specified zone on the map using its color properties.
function SPECTRE.ZONEMGR.Zone:DrawZone()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawZone | ---------------------")
  -- If a zone marker already exists, remove it.
  if self.DrawnZoneMarkID ~= 0 then
    trigger.action.removeMark(self.DrawnZoneMarkID)
  end

  -- Assign a new mark ID and increment the global marker counter.
  self.DrawnZoneMarkID = self.ZoneManager.codeMarker_
  self.ZoneManager.codeMarker_ = self.ZoneManager.codeMarker_ + 1

  -- Set default alpha values for the zone's color and fill color, if not already defined.
  local color = self.Color
  color[4] = color[4] or self.Alpha

  local fillColor = self.FillColor
  fillColor[4] = fillColor[4] or self.FillAlpha

  -- Draw the zone using the defined properties.
  trigger.action.markupToAll(self.shapeId, -1, self.DrawnZoneMarkID, self.Vertices3D[4], self.Vertices3D[3], self.Vertices3D[2], self.Vertices3D[1], color, fillColor, self.LineType, self.ReadOnly)

  return self
end

--- Draw arrows from the zone to its bordering zones.
--
-- This function graphically represents the territorial dynamics between the current zone and its bordering zones.
-- It draws arrows pointing from the current zone to adjacent zones whenever there is a difference in coalition ownership.
-- This visual indication helps to illustrate the direction of territorial influence or contention, enhancing the strategic
-- comprehension of the game's geopolitical landscape for players. The function ensures that previous markers are cleared
-- before drawing new arrows to reflect the current state accurately.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after drawing arrows to its bordering zones.
-- @usage local zoneWithArrows = someZone:DrawArrows() -- Draws arrows from the specified zone to its bordering zones based on coalition differences.
function SPECTRE.ZONEMGR.Zone:DrawArrows()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawArrows | ---------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawArrows | Zone: " .. self.ZoneName)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawArrows | COAL: " .. self.OwnedByCoalition)
  -- Retrieve the current coalition owning the zone.
  local currentCoalition = self.OwnedByCoalition

  -- Clear existing markers for both coalitions
  for BorderZoneName, BorderObject in pairs(self.BorderingZones) do
    for _, borderDetail in ipairs(BorderObject) do
      -- Check and remove markers for coalition "1"
      if borderDetail.MarkID[1] ~= 0 then
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawArrows | removeMark | " .. borderDetail.MarkID[1])
        trigger.action.removeMark(borderDetail.MarkID[1])
        borderDetail.MarkID[1] = 0
      end
      -- Check and remove markers for coalition "2"
      if borderDetail.MarkID[2] ~= 0 then
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawArrows | removeMark | " .. borderDetail.MarkID[2])
        trigger.action.removeMark(borderDetail.MarkID[2])
        borderDetail.MarkID[2] = 0
      end
    end
  end

  -- Draw new arrows based on current ownership
  for BorderZoneName, BorderObject in pairs(self.BorderingZones) do
    local borderCoalition = BorderObject.OwnedByCoalition
    if borderCoalition ~= currentCoalition then
      for _, borderDetail in ipairs(BorderObject) do
        -- Assign a new mark ID and increment the global counter.
        borderDetail.MarkID[currentCoalition] = self.ZoneManager.codeMarker_
        self.ZoneManager.codeMarker_ = self.ZoneManager.codeMarker_ + 1

        -- Define the start and end points of the arrow.
        local ArrowTip = mist.utils.makeVec3(borderDetail.NeighborLinePerpendicularPoint)
        local ArrowEnd = mist.utils.makeVec3(borderDetail.ZoneLinePerpendicularPoint)

        -- Retrieve the appropriate arrow color.
        local arrowColors_ = self._ArrowColors[currentCoalition]

        -- Draw the arrow using the defined properties.
        trigger.action.markupToAll(4, currentCoalition, borderDetail.MarkID[currentCoalition], ArrowTip, ArrowEnd, arrowColors_, arrowColors_, 1, true)
      end
    end
  end

  return self
end

--- Update SSB flags at an Airfield.
--
-- This function plays a critical role in updating the user flags for each airfield within a zone, based on its coalition ownership and
-- its relationship to the SSB list. The function ensures that the correct flags are set for each airfield,
-- accurately indicating its current operational state. This is essential for managing airfield control and player spawns.
--
-- @param #ZONEMGR.Zone self The Zone instance within which the airfield flags are to be updated.
-- @param Airfield The name of the airfield, part of the self[Airbases] table.
-- @return #ZONEMGR.Zone self The Zone instance after updating the SSB flags at the specified airfield.
-- @usage local updatedZone = someZone:UpdateSSBAirfield("SomeAirfield") -- Updates the SSB flags for the specified airfield in the zone.
function SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield(Airfield)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | ---------------------")
  -- Get the object associated with the specified airbase.
  local ABobject = self.Airbases[Airfield]
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | ABobject" , ABobject)
  -- Retrieve flags associated with the zone manager.
  local flagOn = self.ZoneManager.SSBon
  local flagOff = self.ZoneManager.SSBoff
  local currentFlag


  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | flagOn  :" .. flagOn)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | flagOff :" .. flagOff)

  -- Iterate over each airbase and its group array in the SSBList.
  for airbaseName, groupArray in pairs(self.SSBList) do
    -- Determine the coalition owning the airbase.
    local airbaseOwner = AIRBASE:FindByName(airbaseName):GetCoalition()

    if airbaseOwner == 1 then
      airbaseOwner = "red"
    elseif airbaseOwner == 2 then
      airbaseOwner = "blue"
    else
      airbaseOwner = "neutral"
    end

    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | airbaseName :" .. airbaseName)
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:UpdateSSBAirfield | airbaseOwner :" .. airbaseOwner)

    -- Set user flags based on coalition ownership.
    for _, groupDetails in ipairs(groupArray) do
      if airbaseOwner == groupDetails.coal then
        currentFlag = flagOn
      else
        currentFlag = flagOff
      end
      trigger.action.setUserFlag(groupDetails.name, currentFlag)
    end
  end

  return self
end

--- Create a table associating airbases with their client units for Simple Slot Block (SSB) handling.
--
--  Detects all client spawn slots at airfields (airfield spawn) and all client slots within 5 Km of the airfield's vec2 (ground spawns)
--
--  Adds these units to the SSB manager for automatic toggling when the airfield changes coalition.
--
-- This function constructs a mapping between airbases and their client units for managing Simple Slot Blocks (SSB) in the game.
-- SSB is responsible for enabling or disabling player spawn slots. The function identifies client units at each airbase and
-- creates associations necessary for the strategic control of player spawn points. This mapping is essential for effectively
-- managing player access to specific airbases, reflecting real-time conditions and strategic decisions within the zone.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after creating the SSB airbase-client unit mapping.
-- @usage local zoneWithSSBGroups = someZone:DetermineAirbaseSSBGroups() -- Creates a mapping for airbases and client units for SSB handling.
function SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups | ---------------------")

  -- DETECT AND ADD SPAWNS AT ALL AIRFIELDS TO THE AIRFIELD SSB MANAGER
  -- Create a table to store airbases and their associated client units.
  local AirbasesClients = {}
  local _SSBAirfieldArrays = {}

  -- Iterate over each airbase.
  for airbase, ABobject in pairs(self.Airbases) do
    local airbaseUnitNames = {}
    -- Gather client names from the airbase's parking spots.
    for _, parkingSpot in ipairs(ABobject.Object.parking) do
      if parkingSpot.ClientSpot then SPECTRE.UTILS.safeInsert(airbaseUnitNames, parkingSpot.ClientName) end
    end
    -- If the airbase has client names, store them in the AirbasesClients table.
    if #airbaseUnitNames > 0 then AirbasesClients[airbase] = airbaseUnitNames end
  end

  -- Iterate over all groups.
  local allGroups = mist.DBs.groupsByName
  for groupName, groupData in pairs(allGroups) do
    if groupData and groupData.units then
      -- Iterate over each unit in the group.
      for _, unitData in ipairs(groupData.units) do
        if (unitData.skill == "Client" or unitData.skill == "Player") then
          -- Check if the unit's name matches any of the client names.
          for airbase, unitNames in pairs(AirbasesClients) do
            local _airbaseVec2 = self.Airbases[airbase].vec2
            for _, clientName in pairs(unitNames) do
              local _flagAddUnit = false
              if clientName == unitData.unitName then
                _flagAddUnit = true
              end
              if _flagAddUnit == true then
                -- If a match is found, store the group data.
                if not SPECTRE.UTILS.table_contains(_SSBAirfieldArrays, airbase) then _SSBAirfieldArrays[airbase] = {} end
                SPECTRE.UTILS.debugInfo("SPECTRE:DetermineAirbaseSSBGroups | ADDING: "..   unitData.unitName .. " | TO: " .. tostring(airbase) .. " | COAL: " .. groupData.coalition.. " | GROUP: " .. groupData.groupName)
                SPECTRE.UTILS.safeInsert(_SSBAirfieldArrays[airbase], {
                  name = groupData.groupName,
                  coal = groupData.coalition
                })
                break
              end
            end
          end
        end
      end
    end
  end
  if SPECTRE.DebugEnabled == 1 then
    local force = true
    local _Randname = "SSBList_Airfield"
    local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
    SPECTRE.IO.PersistenceToFile(_filename, _SSBAirfieldArrays, force)
  end
  -- DETECT AND ADD GROUND SPAWNS WITHIN 5000 METERS OF AIRFIELDS TO THE AIRFIELD SSB MANAGER
  for groupName, groupData in pairs(allGroups) do
    if groupData and groupData.units then
      -- Iterate over each unit in the group.
      for _, unitData in ipairs(groupData.units) do
        -- Check if the unit's name matches any of the client names.
        if (unitData.skill == "Client" or unitData.skill == "Player") then
          for airbase, ABobject in pairs(self.Airbases) do
            local _airbaseVec2 = ABobject.vec2
            local _flagAddUnit = false
            if SPECTRE.POLY.distance({x = unitData.x, y = unitData.y}, _airbaseVec2) <= 5000 then
              local _flagfound = false
              if SPECTRE.UTILS.table_contains(_SSBAirfieldArrays, airbase) then
                for _, v in ipairs(_SSBAirfieldArrays[airbase]) do
                  if v.name == groupData.groupName then
                    _flagfound = true
                    break
                  end
                end
              end
              if not _flagfound then _flagAddUnit = true end
            end
            if _flagAddUnit == true then
              if not SPECTRE.UTILS.table_contains(_SSBAirfieldArrays, airbase) then _SSBAirfieldArrays[airbase] = {} end
              SPECTRE.UTILS.safeInsert(_SSBAirfieldArrays[airbase], {
                name = groupData.groupName,
                coal = groupData.coalition
              })
              break
            end
          end
        end
      end
    end
  end
  -- Update the instance's SSBList with the gathered data.
  self.SSBList = _SSBAirfieldArrays

  if SPECTRE.DebugEnabled == 1 then
    local force = true
    local _Randname =  "SSBList_Ground"
    local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/" .. self.ZoneName .. "/" .. _Randname .. ".lua"
    SPECTRE.IO.PersistenceToFile(_filename, _SSBAirfieldArrays, force)
  end

  return self
end


--- DO NOT USE THIS YET.
--
-- The Airfield and FARP methods are efficient for their specific purpose. This does them both but faster.
--
-- Create a table associating airbases with their client units for Simple Slot Block (SSB) handling.
--
--  Detects all client spawn slots at airfields (airfield spawn) and all client slots within 5 Km of the airfield's vec2 (ground spawns)
--
--  Adds these units to the SSB manager for automatic toggling when the airfield changes coalition.
--
-- This function constructs a mapping between airbases and their client units for managing Simple Slot Blocks (SSB) in the game.
-- SSB is responsible for enabling or disabling player spawn slots. The function identifies client units at each airbase and
-- creates associations necessary for the strategic control of player spawn points. This mapping is essential for effectively
-- managing player access to specific airbases, reflecting real-time conditions and strategic decisions within the zone.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after creating the SSB airbase-client unit mapping.
-- @usage local zoneWithSSBGroups = someZone:DetermineAirbaseSSBGroups() -- Creates a mapping for airbases and client units for SSB handling.
function SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All | ---------------------")
  local _SSBAirfieldArrays = {}
  local airbaseNames = {}
  for airbase, ABobject in pairs(self.Airbases) do
    airbaseNames[#airbaseNames + 1] = airbase
  end
  local allGroups = mist.DBs.groupsByName
  -- DETECT AND ADD GROUND SPAWNS IN ZONE TO THE FARP SSB MANAGER. OMITS ALREADY ASSIGNED AIRFIELD SPAWNS
  for groupName, groupData in pairs(allGroups) do
    if groupData and groupData.units then
      -- Iterate over each unit in the group.
      for _, unitData in ipairs(groupData.units) do
        if (unitData.skill == "Client" or unitData.skill == "Player") then
          local _flagAddUnit = true
          local _vec2 = {x = unitData.x, y = unitData.y}
          local _nearestAB = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(airbaseNames, _vec2)
          local _nearestABname = _nearestAB[1]
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All | groupData.groupName : " .. groupData.groupName)
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All | _nearestABname      : " ..  _nearestABname)
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All | _SSBAirfieldArrays  : " , _SSBAirfieldArrays)
          if SPECTRE.UTILS.table_contains(_SSBAirfieldArrays, _nearestABname) then
            for _, _group in ipairs(_SSBAirfieldArrays[_nearestABname]) do
              if _group.name == groupData.groupName then
                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbaseSSBGroups_All | Already Exists, Do not add")
                _flagAddUnit = false
                break
              end
            end
          end
          if _flagAddUnit == true then
            if not SPECTRE.UTILS.table_contains(_SSBAirfieldArrays, _nearestABname) then _SSBAirfieldArrays[_nearestABname] = {} end
            SPECTRE.UTILS.safeInsert(_SSBAirfieldArrays[_nearestABname], {
              name = groupData.groupName,
              coal = groupData.coalition,
            })
            break
          end
        end
      end
    end
  end
  -- Update the instance's SSBList with the gathered data.
  self.SSBList = _SSBAirfieldArrays
  if SPECTRE.DebugEnabled == 1 then
    local force = true
    local _Randname =  "SSBList_All"
    local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
    SPECTRE.IO.PersistenceToFile(_filename, _SSBAirfieldArrays, force)
  end
  return self
end

--- FARP usage mainly, or "ground" spawns.
--
--  Detects all ground spawns in a Zone not assigned to an airfield and adds it to the Airfield SSB Manager for the closest airfield.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after creating the SSB airbase-client unit mapping.
-- @usage local zoneWithSSBGroups = someZone:DetermineAirbaseSSBGroups() -- Creates a mapping for airbases and client units for SSB handling.
function SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups()
  --  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | ---------------------")
  --  local airbaseNames = {}
  --  for airbase, ABobject in pairs(self.Airbases) do
  --    airbaseNames[#airbaseNames + 1] = airbase
  --  end
  --  local allGroups = mist.DBs.groupsByName
  --
  --  for groupName, groupData in pairs(allGroups) do
  --    if groupData and groupData.units then
  --      local _flagAddUnit = false
  --      for _, unitData in ipairs(groupData.units) do
  --
  --        if (unitData.skill == "Client" or unitData.skill == "Player") then
  --          local _vec2 = {x = unitData.x, y = unitData.y}
  --          if self.zoneManager:findZoneForVec2(coordinates)
  --          local _nearestAB = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(airbaseNames, _vec2)
  --          local _nearestABname = _nearestAB[1]
  --
  --          if self.Airbases[_nearestABname] then
  --
  --
  --            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | _nearestAB: " .. _nearestABname)
  --
  --            -- Refactored Duplicate Check
  --            if self.SSBList[_nearestABname] ~= nil then
  --              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | self.SSBList[_nearestABname] EXIST ")
  --              for _, existingGroup in ipairs(self.SSBList[_nearestABname]) do
  --                _flagAddUnit = true
  --                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | existingGroup.name :" .. existingGroup.name)
  --                SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | groupData.groupName :" .. groupData.groupName)
  --                if existingGroup.name == groupData.groupName then
  --                  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | _flagAddUnit = false")
  --                  _flagAddUnit = false
  --                  break
  --                end
  --              end
  --            else
  --              --self.SSBList[_nearestABname] = {}
  --              self.SSBList[_nearestABname] = {}
  --              _flagAddUnit = true
  --              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | _flagAddUnit = false")
  --            end
  --
  --            if _flagAddUnit then
  --              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | _flagAddUnit = true")
  --              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | groupData.groupName :" .. groupData.groupName)
  --              --self.SSBList[_nearestABname][#self.SSBList[_nearestABname] + 1] = {
  --              local data_ = {
  --                name = groupData.groupName,
  --                coal = groupData.coalition,
  --              }
  --              table.insert(self.SSBList[_nearestABname],data_)
  --            end
  --
  --
  --          end
  --
  --
  --        end
  --
  --      end
  --
  --    end
  --  end
  --
  --  if SPECTRE.DebugEnabled == 1 then
  --    local force = true
  --    local _Randname =  "SSBList_FARP"
  --    local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
  --    SPECTRE.IO.PersistenceToFile(_filename, self.SSBList, force)
  --  end
  return self
end

--function SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups()
--  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineFARPSSBGroups | ---------------------")
--  local airbaseNames = {}
--  for airbase, ABobject in pairs(self.Airbases) do
--    airbaseNames[#airbaseNames + 1] = airbase
--  end
--  local allGroups = mist.DBs.groupsByName
--  -- DETECT AND ADD GROUND SPAWNS IN ZONE TO THE FARP SSB MANAGER. OMITS ALREADY ASSIGNED AIRFIELD SPAWNS
--  for groupName, groupData in pairs(allGroups) do
--    if groupData and groupData.units then
--      -- Iterate over each unit in the group.
--      for _, unitData in ipairs(groupData.units) do
--        if (unitData.skill == "Client" or unitData.skill == "Player") then
--          local _flagAddUnit = true
--          local _vec2 = {x = unitData.x, y = unitData.y}
--          local _nearestAB = SPECTRE.WORLD.FindNearestAirbaseToPointVec2(airbaseNames, _vec2)
--          local _nearestABname = _nearestAB[1]
--          if SPECTRE.UTILS.table_contains(self.SSBList, _nearestABname) then
--            for _, _group in ipairs(self.SSBList[_nearestABname]) do
--              if _group.name == groupData.groupName then
--                _flagAddUnit = false
--                break
--              end
--            end
--          end
--          if _flagAddUnit == true then
--            if not SPECTRE.UTILS.table_contains(self.SSBList, _nearestABname) then self.SSBList[_nearestABname] = {} end
--            SPECTRE.UTILS.safeInsert(self.SSBList[_nearestABname], {
--              name = groupData.groupName,
--              coal = groupData.coalition,
--            })
--            break
--          end
--        end
--      end
--    end
--  end
--  if SPECTRE.DebugEnabled == 1 then
--    local force = true
--    local _Randname =  "SSBList_FARP"
--    local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
--    SPECTRE.IO.PersistenceToFile(_filename, self.SSBList, force)
--  end
--  return self
--end


--- Identify and list all airbases within the specified zone.
--
-- This function is essential for understanding the strategic layout of the zone by identifying all airbases within its boundaries.
-- It scans each airbase from the ZoneManager's list, checking if it is located within the zone's defined area. The function
-- ensures that only airbases lying within the zone are considered for further operations and strategies, thereby aligning
-- in-game elements with the zone's geographical constraints and characteristics.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after identifying and listing all airbases within it.
-- @usage local zoneWithIdentifiedAirbases = someZone:DetermineAirbasesInZone() -- Identifies and lists all the airbases located within the given zone.
function SPECTRE.ZONEMGR.Zone:DetermineAirbasesInZone()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DetermineAirbasesInZone | ---------------------")
  -- Get the list of airbases from the ZoneManager.
  local _AirbaseListTheatre = self.ZoneManager.AirbaseSeed

  -- Iterate over each airbase in the list.
  for _, airbaseName in pairs(_AirbaseListTheatre) do
    -- Find the airbase by its name.
    local airbase_ = AIRBASE:FindByName(airbaseName)

    -- Check if the airbase is within the specified zone.
    local isInZone = SPECTRE.POLY.PointWithinShape(airbase_:GetVec2(), self.Vertices2D)

    -- If the airbase is within the zone, add it to the Airbases table.
    if isInZone then
      self.Airbases[airbaseName] = {
        Object = airbase_,
        SPAWNER = {},
        ownedBy = airbase_:GetCoalition(),
        oldOwnedBy = airbase_:GetCoalition(),
        vec2 = airbase_:GetVec2(),
        name = airbaseName,
      }
    end
  end

  return self
end

--- Identify and return all units within the specified Quadpoint zone.
--
-- This function is designed to identify all units within the boundaries of the current zone. It scans through each unit from
-- the ZoneManager's list, checking if they are located within the zone's defined area. The function is crucial for gathering
-- comprehensive data about the units present in the zone, which can be used for various strategic and management purposes
-- within the game. It adds an additional layer of situational awareness by providing detailed information about the ground,
-- structure, and ship units present in the zone.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after identifying all units within it.
-- @usage local zoneWithIdentifiedUnits = someZone:FindUnitsInZone() -- Identifies and returns all units located within the given zone.
function SPECTRE.ZONEMGR.Zone:FindUnitsInZone()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | -------------------------------------------- ")

  self._detectedUnits = {}
  self._detectedUnits[0] = {}
  self._detectedUnits[1] = {}
  self._detectedUnits[2] = {}

  self.ZONEPOLYOBJ:Scan({Object.Category.UNIT}, {Unit.Category.GROUND_UNIT, Unit.Category.STRUCTURE, Unit.Category.SHIP})

  local scanData = self.ZONEPOLYOBJ.ScanData
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | scanData     | " , scanData)
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | SPECTRE.SPAWNER.TEMPLATETYPES_     | " , SPECTRE.SPAWNER.TEMPLATETYPES_)
  if scanData then
    -- Units
    if scanData.Units then
      for _, unit in pairs(scanData.Units) do
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | FOUND UNIT ------------------------ ", unit)
        local _unitCoal = unit:getCoalition()
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitCoal   | " .. _unitCoal)
        local _unitName = unit:getName()
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitName   | " .. _unitName)
        local unit_ = UNIT:FindByName(_unitName)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitName   | " , unit_)

        if unit_ then
          local _unitVec2 = {}
          local _tVecBuilderUNIT = unit_:GetPosition()
          _unitVec2.x = _tVecBuilderUNIT.p.x
          _unitVec2.y = _tVecBuilderUNIT.p.z
          local _unitid = unit.id_

          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitVec2.x | " .. _unitVec2.x)
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitVec2.y | " .. _unitVec2.y)
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | _unitid     | " .. _unitid)

          local matchedType
          if self.Intel == true then
            SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | INTEL DESIRED  ------------------------ ")
            -- Nested function to find the template type with the highest priority
            local function findTypeIndex(table, input)
              local highestPriority = -1
              local matchingType = nil
              -- Iterate through the TEMPLATETYPES_ table to find the matching type with highest priority
              for key, value in pairs(table) do
                for _, _attr in ipairs(input) do
                  if _attr == key and value._Priority and value._Priority > highestPriority then
                    highestPriority = value._Priority
                    matchingType = key
                  end
                end
              end
              SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:FindUnitsInZone | matchedType | " .. matchingType)
              return matchingType
            end
            local _UNITAttributes = SPECTRE.UTILS.GetUnitAttributes(_unitName)
            local _tempAttri = {}
            for _k, _v in pairs (_UNITAttributes) do
              --SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | ATRB | " .. _k)
              SPECTRE.UTILS.safeInsert(_tempAttri, _k)
            end
            matchedType = findTypeIndex(SPECTRE.SPAWNER.TEMPLATETYPES_, _tempAttri)
          end
          self._detectedUnits[_unitCoal][#self._detectedUnits[_unitCoal] + 1] = {
            name = _unitName,
            vec2 = _unitVec2,
            unit = _unitid,
            matchedType = matchedType or nil,
          }
        end
      end
    end
  end
  return self
end

--- Enable or disable the hotspot feature for the zone.
--
-- This function allows for toggling the hotspot feature of a zone on or off. A hotspot is typically an area of
-- strategic interest within the zone. Enabling the hotspot feature could be used to trigger specific behaviors
-- or responses related to the zone. The ability to enable or disable this feature programmatically adds flexibility
-- in how the zone is interacted with and managed during gameplay.
--
-- @param #ZONEMGR.Zone self The Zone instance for which the hotspot feature is to be enabled or disabled.
-- @param enabled (Optional) A boolean value to enable (true) or disable (false) the hotspot feature. Defaults to false if not specified.
-- @return #ZONEMGR.Zone self The Zone instance after toggling the hotspot feature.
-- @usage local updatedZone = someZone:enableZoneHotspot(true) -- Enables the hotspot feature for the specified zone.
function SPECTRE.ZONEMGR.Zone:enableZoneHotspot(enabled)
  enabled = enabled or false
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:enableZoneHotspot | ---------------------")
  self.Hotspots = enabled
  return self
end

--- Initialize a scheduler for managing hotspots within the zone.
--
-- This function sets up a scheduler to periodically check and update hotspots within the zone. It ensures that the hotspots
-- and any related intelligence data are refreshed at regular intervals. The scheduler also accounts for ongoing updates,
-- avoiding overlaps in processing. This systematic approach to managing hotspots enhances the zone's dynamics, ensuring
-- that changes in game conditions are regularly reflected in hotspot statuses and information.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after initializing the hotspot scheduler.
-- @usage local zoneWithScheduler = someZone:_HotspotSchedInit() -- Initializes the hotspot scheduler for the specified zone.
function SPECTRE.ZONEMGR.Zone:_HotspotSchedInit()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSchedInit | ---------------------")
  -- Initialize a scheduler to periodically check and update zones
  --self.ZoneManager._HotspotSched[self.ZoneName] = {}
  --self.ZoneManager._HotspotSched[self.ZoneName] = SCHEDULER:New(nil, function()
  --  self.HotspotSched = SCHEDULER:New(self, function()
  --    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:self.HotspotSched | ZONE: " .. self.ZoneName)
  --    -- Only proceed if zones are not already being updated
  --    if not self.UpdatingHotspots then
  --      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATES NOT IN PROG, STARTING")
  --      self.UpdatingHotspots = true
  --
  --      local _Timer = TIMER:New(function()
  --        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATING | " .. self.ZoneName .. " ~~~~~~~~~~")
  --        if self.Hotspots == true then
  --          self:getHotspotGroups()
  --          self:ClearHotspots()
  --          self:DrawHotspots()
  --        end
  --        if self.Intel == true then
  --          self:ClearIntel()
  --          self:getHotspotsIntel()
  --          --zoneObject:DrawHotspotsIntel()
  --        end
  --        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | END UPDATING | " .. self.ZoneName .. " ~~~~~~~~~~")
  --        self.UpdatingHotspots = false
  ----        return self
  --      end, self)
  --      _Timer:Start(math.random(1,5))
  --    else
  --      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR:HotspotSched | UPDATES ALREADY IN PROG")
  --    end
  --    return self
  --  end, {self}, math.random(1,20), self.UpdateInterval, self.UpdateIntervalNudge)

  return self
end
--- Enable or disable hotspot intelligence for the zone.
--
-- This function toggles the intelligence feature related to hotspots within the zone. When enabled, it allows for the collection
-- and processing of additional intelligence data associated with hotspots. This feature is essential for enhancing strategic
-- decision-making by providing more detailed insights into areas of interest within the zone.
--
-- @param #ZONEMGR.Zone self The Zone instance for which the hotspot intelligence feature is to be toggled.
-- @param enabled (Optional) A boolean value to enable (true) or disable (false) the hotspot intelligence feature. Defaults to false if not specified.
-- @return #ZONEMGR.Zone self The Zone instance after toggling the hotspot intelligence feature.
-- @usage local zoneWithHotspotIntel = someZone:enableHotspotIntel(true) -- Enables the hotspot intelligence feature for the specified zone.
function SPECTRE.ZONEMGR.Zone:enableHotspotIntel(enabled)
  enabled = enabled or false
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:enableZoneHotspotIntel | ---------------------")
  self.Intel = enabled
  return self
end


--- Enable or disable automatic spawns for the coalition that captures an airfield for the SPECTRE.ZONEMGR instance.
--
--  EX: If enabled, when Blue captures an airfield, will pull a random AIRFIELDSPAWNER template from ZONEMGR db and spawn friendly blue units at the field.
--
--  does not spawn units if old ownership coalition value was contested or same as new ownership.
--
-- @param #ZONEMGR.Zone self The instance of the zone manager to adjust the persistence setting.
-- @param enabled A boolean value (true or false) to enable or disable the persistence system respectively. Defaults to true if not specified.
-- @return #ZONEMGR.Zone self The zone manager instance with the updated persistence setting.
-- @usage zoneManager.Zones[ZONE NAME]:enableAirfieldCaptureSpawns(true) -- Enables automatic spawns for the coalition that captures an airfield at the airfield.
-- @usage zoneManager.Zones[ZONE NAME]:enableAirfieldCaptureSpawns(false) -- Disables automatic spawns for the coalition that captures an airfield at the airfield.
function SPECTRE.ZONEMGR.Zone:enableAirfieldCaptureSpawns(enabled)
  -- Default to true if no value is provided
  if enabled == nil then enabled = true end
  --  enabled = enabled or true
  self._AirfieldCaptureSpawns = enabled
  return self
end

--- WIP. Non Functional
--
-- Enable or disable automatic airfield cleanup on base capture.
--
--  EX: If enabled, when .
--
-- @param #ZONEMGR.Zone self The instance of the zone manager to adjust the persistence setting.
-- @param enabled A boolean value (true or false) to enable or disable the persistence system respectively. Defaults to true if not specified.
-- @return #ZONEMGR.Zone self The zone manager instance with the updated persistence setting.
-- @usage zoneManager.Zones[ZONE NAME]:enableAirfieldCaptureSpawns(true) -- Enables automatic spawns for the coalition that captures an airfield at the airfield.
-- @usage zoneManager.Zones[ZONE NAME]:enableAirfieldCaptureSpawns(false) -- Disables automatic spawns for the coalition that captures an airfield at the airfield.
function SPECTRE.ZONEMGR.Zone:enableAirfieldCaptureClean(enabled)
  -- Default to true if no value is provided
  if enabled == nil then enabled = true end
  --enabled = enabled or true
  self._AirfieldCaptureClean = enabled
  return self
end


--- Retrieve and organize groups of units as hotspots within the zone.
--
-- This function plays a key role in identifying and categorizing groups of units within the zone as hotspots. It first locates all units
-- in the zone and then applies a clustering algorithm (DBSCAN) to group these units based on proximity and coalition. This process results
-- in the formation of hotspots, which are clusters of units representing areas of strategic interest or activity within the zone. This organized
-- approach to identifying hotspots is crucial for understanding the distribution and concentration of forces or resources within the zone.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after identifying and organizing hotspot groups.
-- @usage local zoneWithHotspots = someZone:getHotspotGroups() -- Retrieves and organizes groups of units as hotspots within the zone.
function SPECTRE.ZONEMGR.Zone:getHotspotGroups()
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotGroups | ------------------------ ")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotGroups | FindUnitsInZone: " .. self.ZoneName)
  self:FindUnitsInZone()
  self.HotspotClusters = {}
  self._DBScan = {}

  for _coal = 0, 2 , 1 do
    if self._detectedUnits[_coal] and #self._detectedUnits[_coal] > 0 then
      local _DBscanner = SPECTRE.BRAIN.DBSCANNER:New(self._detectedUnits[_coal],self.Area, self._hotspotDrawExtension)
      _DBscanner.f = self.AI_f
      _DBscanner.p = self.AI_p
      _DBscanner:Scan()
      self.HotspotClusters[_coal] = _DBscanner.Clusters

      if SPECTRE.DebugEnabled == 1 then
        local force = true
        local _Randname = "Hotspot_DetectedUnits_" .. _coal
        local _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
        SPECTRE.IO.PersistenceToFile(_filename, self._detectedUnits[_coal], force)
        _Randname = "Hotspot_Clusters_" .. _coal
        _filename = SPECTRE._persistenceLocations.ZONEMGR.path .. "DEBUG/"  .. self.ZoneName .. "/" .. _Randname .. ".lua"
        SPECTRE.IO.PersistenceToFile(_filename, self.HotspotClusters[_coal], force)
      end

    end
  end
  return self
end


--- Draw hotspot circles on the map for each coalition.
--
-- This function visualizes hotspots on the map by drawing circles representing their locations and extents.
-- It iterates through hotspots identified for each coalition and draws a circle for each, using a specific color and fill color.
-- The function plays a crucial role in providing a visual representation of areas of high activity or strategic importance within the zone,
-- enhancing situational awareness and strategic planning.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after drawing the hotspots on the map.
-- @usage local zoneWithDrawnHotspots = someZone:DrawHotspots() -- Draws hotspot circles for each coalition in the zone.
function SPECTRE.ZONEMGR.Zone:DrawHotspots()
  -- Define constants
  -- local _coal = 1
  local oppcoalt_ = {[0] = -1, [1] = 2, [2] = 1,} --2
  local color = {0.36, 0.36, 0.36, 0.60}--0.6}
  local fillColor = {0.99, 0.847, 1,0.25}-- 0.25}
  for _coal = 0, 2 , 1 do
    local oppcoal = oppcoalt_[_coal]
    -- Check if there are hotspots to draw
    if self.HotspotClusters[_coal] and #self.HotspotClusters[_coal] > 0 then
      -- Debug information consolidated
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:DrawHotspots | ------------------------\n" ..
        "| Number of Hotspots | " .. #self.HotspotClusters[_coal])

      -- Draw each hotspot
      for _hotspotIndex, _Hotspot in ipairs(self.HotspotClusters[_coal]) do
        -- Assign a new mark ID and increment the global marker counter.
        local _tLength = #self.HotspotMarkers[_coal] + 1
        self.HotspotMarkers[_coal][_tLength] = {}
        self.HotspotMarkers[_coal][_tLength].MarkerID = self.ZoneManager.codeMarker_
        self.ZoneManager.codeMarker_ = self.ZoneManager.codeMarker_ + 1


        local markerTable_ = {
          MarkerID = self.HotspotMarkers[_coal][_tLength].MarkerID,
          Vec3 = _Hotspot.CenterVec3,
          coal = oppcoal,
          radius = (_Hotspot.Radius),
          color = color,
          fillColor = fillColor,
          num = 2,
          ReadOnly = self.ReadOnly,
        }
        table.insert(self.ZoneManager._hotspotQueue, markerTable_)

        -- Draw the zone using the defined properties.
        --        trigger.action.circleToAll(oppcoal, self.HotspotMarkers[_coal][_tLength].MarkerID, _Hotspot.CenterVec3,
        --          (_Hotspot.Radius), color, fillColor, 2, self.ReadOnly)
      end
    end
  end
  return self
end

--- Clear all drawn hotspots from the map for each coalition.
--
-- This function removes the visual representation of all hotspots previously drawn on the map for each coalition.
-- It ensures that the map reflects the current state of hotspots, allowing for updates or changes in strategic situations.
-- This clearing process is essential for maintaining an accurate and up-to-date visual depiction of the zone's hotspots.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after clearing the hotspots from the map.
-- @usage local zoneWithClearedHotspots = someZone:ClearHotspots() -- Clears all hotspot markers for each coalition in the zone.
function SPECTRE.ZONEMGR.Zone:ClearHotspots()
  -- local _coal = 1
  for _coal = 0, 2 , 1 do
    -- Check if there are hotspots to clear
    if self.HotspotMarkers[_coal] and #self.HotspotMarkers[_coal] > 0 then
      -- Debug information consolidated
      SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:ClearHotspots | ------------------------\n" ..
        "| Number of Hotspots to Clear | " .. #self.HotspotMarkers[_coal])

      -- Clear each hotspot
      for _hotspotIndex, _Hotspot in ipairs(self.HotspotMarkers[_coal]) do
        if _Hotspot.MarkerID ~= 0 then
          SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:ClearHotspots | Removing Marker | " .. _Hotspot.MarkerID)
          local markerTable_ = {
            MarkerID = _Hotspot.MarkerID,
          }
          table.insert(self.ZoneManager._removeMarkerQueue, markerTable_)
          -- trigger.action.removeMark(_Hotspot.MarkerID)
        end
      end
    end
    self.HotspotMarkers[_coal] = {}
  end
  return self
end

--- Gathers and displays intelligence information for hotspots in the zone.
-- This function compiles intelligence data for each hotspot in the zone, summarizing the types of units present within each hotspot.
-- It then visually represents this intelligence on the map, providing insights into the composition of forces or resources at strategic locations.
-- This information is valuable for tactical decision-making and understanding the nature of the opposition within different hotspots.
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after gathering and displaying intelligence information for its hotspots.
-- @usage local zoneWithIntel = someZone:getHotspotsIntel() -- Gathers and displays intelligence data for hotspots in the zone.
function SPECTRE.ZONEMGR.Zone:getHotspotsIntel()
  local _coalitionMap = {[0] = -1, [1] = 2, [2] = 1}

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | START ------------------------")
  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | Zone: " .. self.ZoneName)
  for _coalition = 1, 2 do
    local opposingCoalition = _coalitionMap[_coalition]
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | Coal: " .. _coalition)
    SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | Opposing Coal: " .. opposingCoalition)

    if self.HotspotClusters[_coalition] and #self.HotspotClusters[_coalition] > 0 then
      for _hotspotIndex, _Hotspot in ipairs(self.HotspotClusters[_coalition]) do
        local _hotspotAttributes = {}
        for _, _unitDetails in ipairs(_Hotspot.Units) do
          if _unitDetails.matchedType then
            table.insert(_hotspotAttributes, _unitDetails.matchedType)
          end
        end
        local _countedAttributes = SPECTRE.UTILS.CountValues(_hotspotAttributes)
        local totalTypes = 0
        for _, _numTypes in pairs(_countedAttributes) do
          totalTypes = totalTypes + _numTypes
        end

        local intelString = "Intel: "
        for _Type, _numTypes in pairs(_countedAttributes) do
          intelString = intelString .. _Type .. ", "
        end
        intelString = intelString:sub(1, -3) -- Remove trailing comma and space.

        -- Assign a new mark ID and increment the global marker counter.
        self.IntelMarkers[_coalition] = self.IntelMarkers[_coalition] or {}
        local _tLength = #self.IntelMarkers[_coalition] + 1
        self.IntelMarkers[_coalition][_tLength] = {
          MarkerID = self.ZoneManager.codeMarker_,
          intelString = intelString
        }
        self.ZoneManager.codeMarker_ = self.ZoneManager.codeMarker_ + 1
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | intelString: " .. intelString)
        SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | MarkerID: " .. tostring(self.IntelMarkers[_coalition][_tLength].MarkerID))

        local markerTable_ = {
          MarkerID = self.IntelMarkers[_coalition][_tLength].MarkerID,
          intelString = intelString,
          Vec3 = _Hotspot.CenterVec3,
          coal = opposingCoalition,
          ReadOnly = self.ReadOnly
        }
        table.insert(self.ZoneManager._markerQueue, markerTable_)
        --trigger.action.markToCoalition(self.IntelMarkers[_coalition][_tLength].MarkerID, intelString, _Hotspot.CenterVec3, opposingCoalition, self.ReadOnly)
      end
    end
  end

  SPECTRE.UTILS.debugInfo("SPECTRE.ZONEMGR.Zone:getHotspotsIntel | END ------------------------")
  return self
end

--- Clear all intelligence markers from the map for each coalition.
--
-- This function is responsible for removing all intelligence markers related to hotspots from the map.
-- It iterates through each coalition's intel markers and clears them, ensuring that the map reflects the most current intelligence information.
-- This action is crucial for maintaining an accurate and up-to-date strategic view of the zone, especially when situations change rapidly.
--
-- @param #ZONEMGR.Zone
-- @return #ZONEMGR.Zone self The Zone instance after clearing all intelligence markers.
-- @usage local zoneWithClearedIntel = someZone:ClearIntel() -- Clears all intelligence markers for each coalition in the zone.
function SPECTRE.ZONEMGR.Zone:ClearIntel()
  -- Debug information consolidated
  local debugInfo = "SPECTRE.ZONEMGR.Zone:ClearIntel | ------------------------\n"
  --local _coalt = {[0] = -1, [1] = 2, [2] = 1,}
  for _coal = 0, 2, 1 do

    --local oppcoal = _coalt[_coal]
    if self.IntelMarkers[_coal] and #self.IntelMarkers[_coal] > 0 then
      debugInfo = debugInfo .. "| Coal: " .. _coal .. " | Number of Intel to Clear: " .. #self.IntelMarkers[_coal] .. "\n"
      for _, _Hotspot in ipairs(self.IntelMarkers[_coal]) do
        if _Hotspot.MarkerID ~= 0 then
          debugInfo = debugInfo .. "| Removing Intel Marker: " .. _Hotspot.MarkerID .. "\n"

          local markerTable_ = {
            MarkerID = _Hotspot.MarkerID,
          }
          table.insert(self.ZoneManager._removeMarkerQueue, markerTable_)
          -- trigger.action.removeMark(_Hotspot.MarkerID)
        end
      end
    end
    self.IntelMarkers[_coal] = {}
  end
  SPECTRE.UTILS.debugInfo(debugInfo)
  return self
end

--- Sets the desired granularity for hotspots.
--
-- @param #ZONEMGR.Zone self 
-- @param factor Adjust this factor based on desired granularity for hotspots.
-- @return #ZONEMGR.Zone self 
function SPECTRE.ZONEMGR.Zone:setAI_granularityFactor(factor)
  self.AI_f = factor
  return self
end

--- Sets the Percentage of total units for hotspots.
--
-- @param #ZONEMGR.Zone self 
-- @param factor Adjust this factor based on Percentage of total units for hotspots.
-- @return #ZONEMGR.Zone self 
function SPECTRE.ZONEMGR.Zone:setAI_percentFactor(factor)
  self.AI_p = factor
  return self
end

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

