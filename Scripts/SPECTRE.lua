env.info(" *** LOAD S.P.E.C.T.R.E. *** ")
--https://stevedonovan.github.io/ldoc/manual/doc.md.html
--https://www.eclipse.org/forums/index.php/t/1077818/

--- Special Purpose Extension for Creating Truly Reactive Environments.
-- Requires MOOSE, MIST, SSB to be loaded before SPECTRE lua
-- @field #SPECTRE
SPECTRE = {
  ClassName = "SPECTRE",
}

---Settings for a point based redeem system.
-- Point cost for redeems + Point Reward for Kills based on type
SPECTRE.POINTMANAGER = {
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

--- Truncate a number's decimal to a specified amount of digits.
-- @param num number to do work on.
-- @param digits amount of digits to truncate decimal to.
-- @return output : worked on number
function SPECTRE.trunc(num, digits)
  local mult = 10^(digits)
  local output = math.modf(num*mult)/mult
  return output
end

--- Enable/Disable Slot for player aircraft based on a known group naming convention.
-- Player Aircraft slots must be named in the format:
-- "field .. aircraft .. number".
--
-- EX. Name of group to be enabled: "Abu_F18-1"
--
-- @param AircraftList Table of all aircraft types names, EX. {"\_F18-", "_F16-", ... }
-- @param field The airfield denotation of group name, EX. "Abu"
-- @param flag Flag value for SSB enable/Disable, EX. 0
-- @param startNum starting number value, EX. 1
-- @param endNum End Number Value, EX. 4
function SPECTRE.SlotEnableDisable(AircraftList, field, flag, startNum, endNum)
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

--- Convert PlaceName from OnEventBaseCaptured to match AirfieldName in AIRBASE class.
-- @param PlaceName Paramter returned from OnEventBaseCaptured.place event data
-- @return output : Converted name to Airfield name list format
function SPECTRE.AirfieldNameConvert(PlaceName)
  -- Replace "-" with "_"
  local sub1 = string.gsub(PlaceName, '-', '_')
  -- Replace " " with "_"
  local sub2 = string.gsub(sub1, ' ', '_')
  -- Remove '
  local output = string.gsub(sub2, '\'', '')
  return output
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
function SPECTRE.TargetMarker_CreateAtPointIfUnitsExistInZone(ZoneName, ObjectCategory, Table_UnitCategory, UnitCoalition, Coordinate, MarkCoalition, MarkerRadius, MarkText)
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

--- Modify a Counter.
-- add or subtract 1
-- @param Resource : The counter to be modified
-- @param Operation : Takes "add" or "sub"
-- @return value : new value of resource
function SPECTRE.Ticker(Resource, Operation)
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

--- Limits the maximum amount of marks able to be stored.
-- Removes oldest marker from map and marker table.
-- @param type : Type of Marker to Remove - Takes: CAP\_Markers, Bomber\_Markers, Tomahawk\_Markers, Airdrop\_Markers
-- @param PlayerName : PlayerName for operation
-- @param limit : Total amount of markers to allow
function SPECTRE.LimitMaxMarkers(type, PlayerName, limit)
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

---Setup Tables for Players in the global environment for tracking + operations.
-- If PlayerTable !exist, create; else update unit/group info for table
--
-- Uses PlayerManagerMod database to get UCID + stored points
-- @param SlotData Returned Event inforation from Player Event, EnterAircraft
function SPECTRE.SetupPlayerTable(SlotData)
  local PlayerName = SlotData.IniPlayerName
  if DEBUG == 1 then
    BASE:E("DEBUG: SETUP PLAYER TABLE:  ".. PlayerName )
    BASE:E("DEBUG: PLAYER TABLE Init:  ")
    BASE:E(_G["Player_".. PlayerName])
  end
  if _G["Player_".. PlayerName] == SNULL then
    local PlayerPersistanceData = SPECTRE.GetPlayerData(PlayerName)
    local PlayerUCID = PlayerPersistanceData[1]
    local PlayerPoints = PlayerPersistanceData[2]
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
    if DEBUG == 1 then
      BASE:E("DEBUG: Setup Player Table for " .. PlayerName)
      BASE:E(_G[ "Player_".. PlayerName])
    end
  else
    local PlayerPersistanceData = SPECTRE.GetPlayerData(PlayerName)
    local PlayerUCID = PlayerPersistanceData[1]
    local PlayerPoints = PlayerPersistanceData[2]
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
    if DEBUG == 1 then
      BASE:E("DEBUG: Update Player Table for " .. PlayerName)
      BASE:E(_G[ "Player_".. PlayerName])
    end
  end
end

---Access and return info from PlayerDatabase from PlayerManagerMod.
-- REQUIRES PLAYERMANAGERMOD
-- @param PlayerName_ The playername to search for
-- @return result : Table of {PlayerUCID\_, PlayerPoints_} for requested player
function SPECTRE.GetPlayerData(PlayerName_)
  if DEBUG == 1 then
    BASE:E("DEBUG: GetPlayerData : " .. PlayerName_)
    BASE:E(result)
  end
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "PlayerDatabase.lua"
  local LoadedDatabase = persistence.load(PlayerDatabase_File)
  if DEBUG == 1 then
    BASE:E("DEBUG: LoadedDatabase : ")
    BASE:E(LoadedDatabase)
  end
  local PlayerUCID_
  local PlayerPoints_
  local result
  for _i = 1, #LoadedDatabase, 1 do
    if LoadedDatabase[_i]["name"] == PlayerName_ then
      PlayerUCID_ = LoadedDatabase[_i]["ucid"]
      PlayerPoints_ = LoadedDatabase[_i]["points"]
      result = {PlayerUCID_, PlayerPoints_}
      if DEBUG == 1 then
        BASE:E("DEBUG: GetPlayerData Result : " .. PlayerName_)
        BASE:E(result)
      end
      return result
    end
  end

end

---Access and store info from PlayerDatabase from PlayerManagerMod.
-- REQUIRES PLAYERMANAGERMOD
-- @param PlayerName_ The playername to search for
function SPECTRE.StorePlayerData(PlayerName_)
  if DEBUG == 1 then
    BASE:E("DEBUG: StorePlayerData : " .. PlayerName_)
  end
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "PlayerDatabase.lua"
  local LoadedDatabase = persistence.load(PlayerDatabase_File)
  if DEBUG == 1 then
    BASE:E("DEBUG: LoadedDatabase : ")
    BASE:E(LoadedDatabase)
  end
  local PlayerUCID_ = _G[ "Player_".. PlayerName_].UCID
  local PlayerPoints_ = _G[ "Player_".. PlayerName_].Points
  for _i = 1, #LoadedDatabase, 1 do
    if LoadedDatabase[_i]["ucid"] == PlayerUCID_ then
      LoadedDatabase[_i]["points"] = PlayerPoints_
      persistence.store(PlayerDatabase_File, LoadedDatabase)
      if DEBUG == 1 then
        BASE:E("DEBUG: SentPlayerData : " .. PlayerName_)
      end
    end
  end
end

---Access and return info from GetGroundResourceData from PlayerManagerMod.
-- REQUIRES PLAYERMANAGERMOD
-- @return LoadedDatabase : Table of GetGroundResourceData
function SPECTRE.GetGroundResourceData()
  if DEBUG == 1 then
    BASE:E("DEBUG: GetGroundResourceData : ")
  end
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "GroundResources.lua"
  local LoadedDatabase = persistence.load(PlayerDatabase_File)
  if DEBUG == 1 then
    BASE:E("DEBUG: LoadedDatabase GroundResourceData: ")
    BASE:E(LoadedDatabase)
  end
  return LoadedDatabase
end

---Access and store info from GetGroundResourceData from PlayerManagerMod.
-- REQUIRES PLAYERMANAGERMOD
-- @return LoadedDatabase : Table of GetGroundResourceData
function SPECTRE.StoreGroundResourceData(GroundDataTable)
  if DEBUG == 1 then
    BASE:E("DEBUG: Store GroundResourceData : ")
  end
  local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
  local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "GroundResources.lua"
  persistence.store(PlayerDatabase_File, GroundDataTable)

  --local LoadedDatabase = persistence.load(PlayerDatabase_File)
  --  if DEBUG == 1 then
  --    BASE:E("DEBUG: LoadedDatabase : ")
  --    BASE:E(LoadedDatabase)
  --  end
  --return LoadedDatabase
end

--- Defines a menu slot to let the escort Join and Follow you at a certain distance.
-- This menu will appear under **Navigation**.
-- @param EscortGroup ESCORT group Object
-- @param DCS#Distance Distance The distance in NM that the escort needs to follow the client.
-- @return #ESCORT
function SPECTRE.MenuFollowAtNM( EscortGroup, Distance )

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

---Set up event handlers for already existing airdropped units.
-- @param coal coalition to search for units and add event handlers. takes "blue", "red", or "neutral"
function SPECTRE.AddEventHandler_ExistingAirdrop(coal)

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
        if DEBUG == 1 then
          BASE:E("DEBUG : ADD EWR TO BLUE IADS")
        end
        blueIADS:addEarlyWarningRadar(groupname .. "-01")--:sub(1, -5))
      end

      GroupObject:HandleEvent(EVENTS.Dead)
      local DroppedDead = function(eventData)
        if DEBUG == 1 then
          BASE:E("DEBUG: DroppedGroup Event dead")
        end
        if GroupObject:CountAliveUnits() == 0 then
          MESSAGE:New(descriptor .. " group destroyed! Prepping new assets.", 10, "NOTICE"):ToCoalition( coal )

          local restockTimer=TIMER:New(function()
            if descriptor == "TANK" then
              RESOURCES.Airdrop[1]["_Tank"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_Tank"],"add")
              COUNTERS.RESTOCK.Airdrop.Tank = COUNTERS.RESTOCK.Airdrop.Tank - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_Tank"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "IFV" then
              RESOURCES.Airdrop[1]["_IFV"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_IFV"],"add")
              COUNTERS.RESTOCK.Airdrop.IFV = COUNTERS.RESTOCK.Airdrop.IFV - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_IFV"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "ARTILLERY" then
              RESOURCES.Airdrop[1]["_Artillery"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_Artillery"],"add")
              COUNTERS.RESTOCK.Airdrop.Artillery = COUNTERS.RESTOCK.Airdrop.Artillery - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_Artillery"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "AAA" then
              RESOURCES.Airdrop[1]["_AAA"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_AAA"],"add")
              COUNTERS.RESTOCK.Airdrop.AAA = COUNTERS.RESTOCK.Airdrop.AAA - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_AAA"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "IRSAM" then
              RESOURCES.Airdrop[1]["_SAM_IR"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_SAM_IR"],"add")
              COUNTERS.RESTOCK.Airdrop.SAM_IR = COUNTERS.RESTOCK.Airdrop.SAM_IR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_SAM_IR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "RDRSAM" then
              RESOURCES.Airdrop[1]["_SAM_RDR"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_SAM_RDR"],"add")
              COUNTERS.RESTOCK.Airdrop.SAM_RDR = COUNTERS.RESTOCK.Airdrop.SAM_RDR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_SAM_RDR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "EWR" then
              RESOURCES.Airdrop[1]["_EWR"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_EWR"],"add")
              COUNTERS.RESTOCK.Airdrop.EWR = COUNTERS.RESTOCK.Airdrop.EWR - 1
              local report = REPORT:New("New " .. descriptor .. " group is available for airdrop.")
              report:AddIndent(descriptor .. " Airdrop Resources available: " .. RESOURCES.Airdrop[1]["_EWR"], "-")
              trigger.action.outTextForCoalition(coal,report:Text(), 10 )
            end
            if descriptor == "SUPPLY" then
              RESOURCES.Airdrop[1]["_Supply"] = SPECTRE.Ticker(RESOURCES.Airdrop[1]["_Supply"],"add")
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

--- Find closest friendly airfield to the unit.
-- @param PlayerName Name of the unit
-- @return NearestAirbaseInfo The closest airfield to the player
function SPECTRE.ClosestAirfield(PlayerName)

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


  if DEBUG == 1 then
    BASE:E("DEBUG: airbaseObject")
    BASE:E(NearestAirbaseInfo)
  end

  return NearestAirbaseInfo
end

--- Find closest friendly airfield to vec2.
-- @param coal : Takes 0, 1, 2 (2=blue, 1 = red, 0 = neutral)
-- @param _vec2 vec2 to check for closest friendly airbase
-- @param map : theatre of war, "Persia", "Syria", Caucuses"
-- @return NearestAirbaseInfo The closest airfield to the player
function SPECTRE.ClosestAirfieldVec2(coal, _vec2, map)

  local _Airfields = SPECTRE.GetOwnedAirbaseCoal(coal, map)

  if coal == 2 then coal = "blue" end
  if coal == 1 then coal = "red" end
  if coal == 0 then coal = "neutral" end


  local NearestAirbase = SPECTRE.FindNearestAirbaseToPointVec2(_Airfields, _vec2)

  local NearestAirbaseInfo = {
    Name = NearestAirbase[1],
    Vec3 = NearestAirbase[2],
  }

  if DEBUG == 1 then
    BASE:E("DEBUG: airbaseObject")
    BASE:E(NearestAirbaseInfo)
  end

  return NearestAirbaseInfo
end

--- Get and create list of all airbases owned by coalition.
-- @param coal coalition
-- @param map Map, takes "Syria", "Persia", or "Caucasus"
-- @return _AirbaseListOwned : List of owned airfields
function SPECTRE.GetOwnedAirbaseCoal(coal,map)

  local _AirbaseListTheatre
  local _AirbaseListOwned = {}

  if map == "Syria" then
    _AirbaseListTheatre = AIRBASE.Syria
  elseif map == "Persia" then
    _AirbaseListTheatre = AIRBASE.PersianGulf
  elseif map == "Caucasus" then
    _AirbaseListTheatre = AIRBASE.Caucasus
  end

  if DEBUG == 1 then
    BASE:E("DEBUG: _AirbaseListTheatre")
    BASE:E(_AirbaseListTheatre)
  end

  for key, value in pairs(_AirbaseListTheatre) do

    local airbase_ = AIRBASE:FindByName(value)
    if DEBUG == 1 then
      BASE:E("DEBUG: airbase_")
      BASE:E(airbase_)
    end
    local airbase_Coal = airbase_:GetCoalition()
    if DEBUG == 1 then
      BASE:E("DEBUG: airbase_Coal")
      BASE:E(airbase_Coal)
    end
    if airbase_Coal == coal then
      _AirbaseListOwned[#_AirbaseListOwned+1]= value
      --      {
      --        name = value,
      --        airbase = airbase_,
      --      }
    end
  end

  if DEBUG == 1 then
    BASE:E("DEBUG: _AirbaseListOwned")
    BASE:E(_AirbaseListOwned)
  end

  return _AirbaseListOwned
end

---Finds closest airbase to vec2.
-- @param AirbaseList List of airbases to evaluate
-- @param _vec2 for check
-- @return ClosestAirbase : {Name, Vec3} of closest airbase from list to desired Vec2
function SPECTRE.FindNearestAirbaseToPointVec2(AirbaseList, _vec2)

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

--- Disperse Points from kill.
function SPECTRE.DispersePoints(EventData)
  EventData = EventData or nil
  if DEBUG == 1 then
    BASE:E("DEBUG: DispersePoints")
    BASE:E(EventData)
  end
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
  if SPECTRE.table_contains(TargetAttributes, "Air") then
    for _i = 1, #SPECTRE.POINTMANAGER._KillTypes_Air,1 do
      if SPECTRE.table_contains(TargetAttributes, SPECTRE.POINTMANAGER._KillTypes_Air[_i]) then
        if   SPECTRE.POINTMANAGER._KillTypes_Air[_i] == "Helicopters" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_Heli then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_Heli end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Air[_i] == "Planes" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AA then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AA end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Air[_i] == "AWACS" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AWACS then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AWACS end
        end
      end
    end
  else
    PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._General
    for _i = 1, #SPECTRE.POINTMANAGER._KillTypes_Ground,1 do
      if SPECTRE.table_contains(TargetAttributes, SPECTRE.POINTMANAGER._KillTypes_Ground[_i]) then

        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "Buildings" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AG._Buildings then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._Buildings end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "AAA" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AAA then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AAA end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "Buildings" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AG._Buildings then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._Buildings end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "Tanks" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AG._Tanks then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._Tanks end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "APC" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AG._APC then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._APC end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "IFV" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_AG._IFV then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_AG._IFV end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "EWR" then
          if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_SAM._EWR then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_SAM._EWR end
        end
        if   SPECTRE.POINTMANAGER._KillTypes_Ground[_i] == "SAM elements" then
          PointReward = SPECTRE.POINTMANAGER._PointsPerKill_SAM._General
          for _i = 1, #SPECTRE.POINTMANAGER._KillTypes_SAM ,1 do
            if SPECTRE.table_contains(TargetAttributes, SPECTRE.POINTMANAGER._KillTypes_SAM[_i]) then
              if   SPECTRE.POINTMANAGER._KillTypes_SAM[_i] == "SR SAM" then
                if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_SAM._SRSam then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_SAM._SRSam end
              end
              if   SPECTRE.POINTMANAGER._KillTypes_SAM[_i] == "MR SAM" then
                if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_SAM._MRSam then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_SAM._MRSam end
              end
              if   SPECTRE.POINTMANAGER._KillTypes_SAM[_i] == "LR SAM" then
                if PointReward < SPECTRE.POINTMANAGER._PointsPerKill_SAM._LRSam then PointReward = SPECTRE.POINTMANAGER._PointsPerKill_SAM._LRSam end
              end
            end
          end
        end

      end
    end

  end

  if DEBUG == 1 then
    BASE:E("DEBUG: PointReward")
    BASE:E(PointReward)
    local oldPoints = _G["Player_".. ShooterName].Points
    BASE:E("DEBUG: Old Points")
    BASE:E(oldPoints)
  end
  if ShooterCoalition ~= TargetCoalition then
    _G["Player_".. ShooterName].Points = _G["Player_".. ShooterName].Points + PointReward
  else
    PointReward = math.ceil(PointReward/2)
    _G["Player_".. ShooterName].Points = _G["Player_".. ShooterName].Points - PointReward
    if _G["Player_".. ShooterName].Points < 0 then
      _G["Player_".. ShooterName].Points = 0
    end
    trigger.action.outTextForGroup( _G["Player_".. ShooterName].GroupID_, "Destroying friendly assets is a court martialable offense! Deducting " .. PointReward .. " points." ,10)
  end
  if DEBUG == 1 then
    BASE:E("DEBUG: New Points")
    BASE:E(_G["Player_".. ShooterName].Points)
  end
end

--- Clear perm world markers associated with the player
-- @param PlayerName Name of player to clear markers for
-- @param flag Indicates type of markers to clear. 0 = All, 1 = CAP, 2 = Tomahawk, 3 = Bomber, 4 = Airdrop
function SPECTRE.ClearWorldMarkers(PlayerName, flag)

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

--- Check if table contains element.
-- If contains, Return True
-- @param table table to check
-- @param Key_element what to check for
-- @return return true or false
function SPECTRE.table_contains(table, Key_element)
  --  if DEBUG == 1 then
  --    BASE:E("DEBUG: table_contains")
  --    BASE:E("DEBUG: table")
  --    BASE:E(table)
  --  end
  for key, value in pairs(table) do
    --    if DEBUG == 1 then
    --      BASE:E("DEBUG: key")
    --      BASE:E(key)
    --      BASE:E("DEBUG: value")
    --      BASE:E(value)
    --    end
    if key == Key_element then
      --      if DEBUG == 1 then
      --        BASE:E("DEBUG: element found")
      --      end
      return true
    end
  end
  --  if DEBUG == 1 then
  --    BASE:E("DEBUG: element NOT found")
  --  end
  return false
end

--- Merge 2 Tables.
-- @param t1 : Table 1 (to be added to)
-- @param t2 : Table 2 (To be added to Table 1)
-- @return t1
function SPECTRE.merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      SPECTRE.merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

---File Manipulation
--Export Table to File
--Import Table from file
--Convert table to string to output to console
do
  local write, writeIndent, writers, refCount;

  persistence =
    {
      dump = function (o)
        if type(o) == 'table' then
          local s = '{ '
          for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. persistence.dump(v) .. ','
          end
          return s .. '} '
        else
          return tostring(o)
        end
      end,
      store = function (path, ...)
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

      load = function (path)
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
    }

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

local function file_exists(filePath)
  local file = io.open(filePath, "r")--PlayerDatabase_Path .. "/" ..  filename, "r")
  if (file) then

    if DEBUG == 1 then BASE:E("PLAYERMANAGER - Database file found") end
    io.close(file)
    return true
  else
    if DEBUG == 1 then BASE:E("PLAYERMANAGER - Database file not found") end
    return false
  end
end

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      DYNAMIC SPAWNER START

--- Houses List of Spawnable Templates.
--
-- @field #SpawnerTemplates
SpawnerTemplates = {
  ClassName = "SpawnerTemplates",
}
do
  SpawnerTemplates.APC  = {
    "Template_APC_BTR80",
    "Template_APC_MTLB",
    "Template_APC_BTRRD",
    "Template_APC_ZBD",
    "Template_APC_M113",
  }
  SpawnerTemplates.IFV  = {
    "Template_IFV_BMD1",
    "Template_IFV_BMP1",
    "Template_IFV_BMP2",
    "Template_IFV_BMP3",
    "Template_IFV_BTR82A",
    "Template_IFV_LAV25",
    "Template_IFV_Stryker",
    "Template_IFV_Bradley",
    "Template_IFV_Marder",
    "Template_IFV_Warrior",
  }
  SpawnerTemplates.MBT  = {
    "Template_MBT_Challenger",
    "Template_MBT_Chieftain",
    "Template_MBT_Leclerc",
    "Template_MBT_Leopard1A3",
    "Template_MBT_Leopard2A4",
    "Template_MBT_Leopard2A4T",
    "Template_MBT_Leopard2A5",
    "Template_MBT_Leopard2A6M",
    "Template_MBT_M1A2",
    "Template_MBT_Merkava",
    "Template_MBT_T55",
    "Template_MBT_T72B",
    "Template_MBT_T72B3",
    "Template_MBT_T80U",
    "Template_MBT_T90",
    "Template_MBT_T59",
    "Template_MBT_ZTZ",
  }
  SpawnerTemplates.Scout  = {
    "Template_Scout_Cobra",
    "Template_Scout_HL_DSHK",
    "Template_Scout_HL_KORD",
    "Template_Scout_HMMWV",
    "Template_Scout_LC_DSHK",
    "Template_Scout_LC_KORD",
  }
  SpawnerTemplates.ATGM  = {
    "Template_ATGM_BTRRD",
    "Template_ATGM_HMMWV",
    "Template_ATGM_Stryker",
    "Template_ATGM_Mephisto",
  }
  SpawnerTemplates.Gun  = {
    "Template_Gun_Stryker",
  }
  SpawnerTemplates.LBT  = {
    "Template_LBT_PT76",
    "Template_LBT_Sherman",
    "Template_LBT_Pz4",
  }
  SpawnerTemplates.Artillery  = {
    "Template_Artillery_MRL",
    "Template_Artillery_SmerchCM",
    "Template_Artillery_SmerchHE",
    "Template_Artillery_SmerchBM27",
    "Template_Artillery_SmerchBM21",
    "Template_Artillery_HL",
    "Template_Artillery_LC",
    "Template_Artillery_M270",
    "Template_Artillery_2B11",
    "Template_Artillery_FDDM",
    "Template_Artillery_PLZ",
    "Template_Artillery_2S1",
    "Template_Artillery_2S19",
    "Template_Artillery_2S3",
    "Template_Artillery_Dana",
    "Template_Artillery_M109",
    "Template_Artillery_T155",
    "Template_Artillery_Nona",
  }
  SpawnerTemplates.Fortification  = {
    "Template_Fortification_Barracks",
    "Template_Fortification_Building",
    "Template_Fortification_Bunker1",
    "Template_Fortification_Bunker2",
    "Template_Fortification_Outpost",
    "Template_Fortification_RoadOutpost",
    "Template_Fortification_WatchTower"
  }
  SpawnerTemplates.Infantry  = {
    "Template_Infantry_AK74",
    "Template_Infantry_M249",
    "Template_Infantry_M4",
    "Template_Infantry_RPG",
    "Template_Infantry_JTAC"
  }
  SpawnerTemplates.Supply  = {
    "Template_Supply_ZIL131",
    "Template_Supply_Bedford",
    "Template_Supply_GAZ",
    "Template_Supply_Kamaz",
    "Template_Supply_KrAZ",
    "Template_Supply_M939",
    "Template_Supply_Blitz",
    "Template_Supply_Ural375",
    "Template_Supply_Ural4320",
    "Template_Supply_Ural4320T",
    "Template_Supply_ZIL135",
  }
  SpawnerTemplates.AAA  = {
    "Template_AAA_ZU23Closed",
    "Template_AAA_ZU23",
    "Template_AAA_Flak18",
    "Template_AAA_Bofors",
    "Template_AAA_KS19",
    "Template_AAA_S60",
    "Template_AAA_HL",
    "Template_AAA_ZSU57",
    "Template_AAA_LC",
    "Template_AAA_ZU232",
  }
  SpawnerTemplates.SPAAA  = {
    "Template_SPAAA_Gepard",
    "Template_SPAAA_Vulcan",
    "Template_SPAAA_Shilka",
  }
  SpawnerTemplates.MANPAD  = {
    "Template_MANPAD_Igla",
    "Template_MANPAD_IglaS",
    "Template_MANPAD_Stinger",
  }
  SpawnerTemplates.SAM_Radar_Singles = {
    }
  SpawnerTemplates.SAM_Radar_Range_Short = { -- < 15 mi
    "Template_SAM_SA8",
    "Template_SAM_SA15",
    "Template_SAM_Roland",
    "Template_SAM_SA3",
    "Template_SAM_NASAMS",
  }
  SpawnerTemplates.SAM_Radar_Range_Medium = { -- >20mi
    "Template_SAM_Hawk",
    "Template_SAM_SA11",
    "Template_SAM_SA2",
    "Template_SAM_SA6",
  }
  SpawnerTemplates.SAM_Radar_Range_Long = { -- >40mi
    "Template_SAM_SA10",
  }
  SpawnerTemplates.SAM_Radar_Range_ExtraLong = { -- >60mi
    "Template_SAM_SA5",
  }
  SpawnerTemplates.SAM_IR_Singles = {
    }
  SpawnerTemplates.SAM_IR_Range_Short = { -- <5mi
    "Template_SAM_Avenger",
    "Template_SAM_SA13",
    "Template_SAM_SA9",
    "Template_SAM_Linebacker",
    "Template_SAM_Chaparral",
  }
  SpawnerTemplates.SAM_IR_Range_Medium = {
    "Template_SAM_HQ7",
    "Template_SAM_SA8",
  }
  SpawnerTemplates.SAM_IR_Range_Long = {
    }
  SpawnerTemplates.SAM_Optical_Singles = {
    }
  SpawnerTemplates.SAM_Optical_Range_Short = {
    "Template_SAM_Rapier",
    "Template_SAM_SA19",
  }
  SpawnerTemplates.SAM_Optical_Range_Medium = {
    }
  SpawnerTemplates.SAM_Optical_Range_Long = {
    }
end

--- Controls DynamicSpawner for filling zones.
--
-- @field #DynamicSpawner
DynamicSpawner = {
  ClassName = "DynamicSpawner",
}

local function PointInZone(vec2, zoneName)


end
--- Determines if vec2 is in the zone.
-- Requires quadpoint zone, defined in ME.
-- @param vec2 : Vector to check
-- @param zoneName : Name of quadpoint zone.
-- @return true or false
DynamicSpawner.PointInZone = PointInZone

local function Shuffle(t)
  local s = {}
  for i = 1, #t do s[i] = t[i] end
  for i = #t, 2, -1 do
    local j = math.random(i)
    s[i], s[j] = s[j], s[i]
  end
  return s
end
---Shuffles a Table.
-- @param t : Table to be shuffled
-- @return s : Shuffled table
DynamicSpawner.Shuffle = Shuffle

local function FindObjectsInZone(zoneName)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("DEBUG - FindObjectsInZone - zoneName")
    BASE:E(zoneName)
  end

  local ObjectCoords = {}
  ObjectCoords.buildings = {}
  ObjectCoords.others = {}
  ObjectCoords.units = {}
  local objects = {}
  local buildings = {}
  local others = {}
  local units = {}

  local _zone = ZONE:FindByName(zoneName)

  if DEBUG == 1 then
    BASE:E("DEBUG - FindObjectsInZone - zone")
    BASE:E(_zone)
  end
  _zone:Scan({Object.Category.SCENERY, Object.Category.STATIC, Object.Category.UNIT}, {Unit.Category.GROUND_UNIT, Unit.Category.STRUCTURE, Unit.Category.SHIP})
  if DEBUG == 1 then
    local foundObjects = _zone.ScanData
    BASE:E("DEBUG - FindObjectsInZone - foundObjects")
    BASE:E(foundObjects)
    BASE:E("DEBUG - FindObjectsInZone - ScanData")
    for _key,_value in pairs(_zone.ScanData) do
      BASE:E("DEBUG - FindObjectsInZone - ScanData - _key")
      BASE:E(_key)
      BASE:E("DEBUG - FindObjectsInZone - ScanData - _value")
      BASE:E(_value)
    end
  end
  --SCENERY
  if _zone.ScanData and _zone.ScanData.Scenery and #_zone.ScanData.Scenery > 0 then
    objects = _zone.ScanData.Scenery
    for _,_object in pairs (objects) do
      for _,_scen in pairs (_object) do
        local scenery = _scen
        if DEBUG == 1 then
          BASE:E("DEBUG - FindObjectsInZone - scenery")
          BASE:E(scenery)
        end
        local description=scenery:GetDesc()
        if description and description.attributes and description.attributes.Buildings then
          buildings[#buildings+1] = scenery:GetCoordinate()
        else
          others[#others+1] = scenery.SceneryObject:getPosition()
        end
      end
    end
  end
  --UNITS
  if _zone.ScanData and _zone.ScanData.Units and #_zone.ScanData.Units > 0 then
    objects = _zone.ScanData.Units
    if DEBUG == 1 then
      BASE:E("DEBUG - FindObjectsInZone - unit - objects")
      BASE:E(objects)
    end
    for _,_object in pairs (objects) do
      if DEBUG == 1 then
        BASE:E("DEBUG - FindObjectsInZone - unit")
        BASE:E(_object)
      end
      units[#units+1] = UNIT:FindByName( _object:getName() ):GetPosition()--UNIT.--UNIT:Find(unit):GetCoordinate()
    end
  end
  --SCENERY TABLE
  if _zone.ScanData and _zone.ScanData.SceneryTable and #_zone.ScanData.SceneryTable > 0 then
    objects = _zone.ScanData.SceneryTable
    for _i = 1, #objects, 1 do
      others[#others+1] = objects[_i].SceneryObject:getPosition()
      if DEBUG == 1 then
        BASE:E("DEBUG - FindObjectsInZone - SCENERY TABLE")
        BASE:E(others[#others])
      end
    end
  end
  if DEBUG == 1 then
    BASE:E("DEBUG - FindObjectsInZone - objects")
    BASE:E(objects)
    BASE:E("DEBUG - FindObjectsInZone - buildings")
    BASE:E(buildings)
    BASE:E("DEBUG - FindObjectsInZone - others")
    BASE:E(others)
    BASE:E("DEBUG - FindObjectsInZone - units")
    BASE:E(units)
  end
  for _i = 1, #buildings, 1 do
    ObjectCoords.buildings[#ObjectCoords.buildings + 1] = {x = buildings[_i].x, y = buildings[_i].z}
  end
  for _i = 1, #others, 1 do
    ObjectCoords.others[#ObjectCoords.others + 1] = {x = others[_i].p.x, y = others[_i].p.z}
  end
  for _i = 1, #units, 1 do
    ObjectCoords.units[#ObjectCoords.units + 1] = {x = units[_i].p.x, y = units[_i].p.z}
  end
  if DEBUG == 1 then
    BASE:E("DEBUG - FindObjectsInZone - ObjectCoords")
    BASE:E(ObjectCoords)
    BASE:E("DEBUG - FindObjectsInZone - ObjectCoords.buildings")
    BASE:E(ObjectCoords.buildings)
    BASE:E("DEBUG - FindObjectsInZone - #ObjectCoords.buildings")
    BASE:E(#ObjectCoords.buildings)
    BASE:E("DEBUG - FindObjectsInZone - ObjectCoords.others")
    BASE:E(ObjectCoords.others)
    BASE:E("DEBUG - FindObjectsInZone - #ObjectCoords.others")
    BASE:E(#ObjectCoords.others)
    BASE:E("DEBUG - FindObjectsInZone - ObjectCoords.units")
    BASE:E(ObjectCoords.units)
    BASE:E("DEBUG - FindObjectsInZone - #ObjectCoords.units")
    BASE:E(#ObjectCoords.units)
  end
  return ObjectCoords
end
--- Returns a table of coords for each ObjectType in a Zone_Radius.
-- Meant to provide information for spawning, preventing spawning on existing objects.
-- Looks for: Scenery, Statics, Ground Units, Ground Structures, Ships
-- @param zoneName : Zone must be a ZONE_RADIUS type
-- @return foundObjectCoords : List of coords for all objects in zone.
DynamicSpawner.FindObjectsInZone = FindObjectsInZone

local function Weight_ZoneSize(ZoneArray)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - Weight_ZoneSize : ZoneArray")
    BASE:E(ZoneArray)
  end
  local WeightedArray = {
    Main = {},
    Sub = {},
  }
  local ZoneSizes = {
    Main = {},
    Sub = {},
  }
  local MainZone = ZONE:FindByName(ZoneArray.MainZone)
  local radius_MainZone = MainZone:GetRadius()
  ZoneSizes.Main = {zoneName = ZoneArray.MainZone, radius = radius_MainZone}
  --determine zone sizes
  for _i = 1, #ZoneArray.SpawnZones, 1 do
    local subZone = ZONE:FindByName(ZoneArray.SpawnZones[_i].Name)
    local radius_subZone = subZone:GetRadius()
    ZoneSizes.Sub[#ZoneSizes.Sub + 1] = {zoneName = ZoneArray.SpawnZones[_i].Name, radius = radius_subZone}
    if DEBUG == 1 then
      BASE:E("Dynamic - Weight_ZoneSize : ZoneSizes.Sub")
      BASE:E(ZoneSizes.Sub[#ZoneSizes.Sub])
    end
  end
  --determine zone weights
  local totaltab = 0
  local MainArea = math.pi * (ZoneSizes.Main.radius)^2
  if DEBUG == 1 then
    BASE:E("Dynamic - Weight_ZoneSize : MainArea")
    BASE:E(MainArea)
  end
  for _i = 1, #ZoneSizes.Sub, 1 do
    local subArea = math.pi * (ZoneSizes.Sub[_i].radius)^2
    if DEBUG == 1 then
      BASE:E("Dynamic - Weight_ZoneSize : subArea")
      BASE:E(subArea)
    end
    local _weight = subArea/MainArea
    WeightedArray.Sub[#WeightedArray.Sub + 1] = {name = ZoneSizes.Sub[_i].zoneName, weight = _weight}
    totaltab = totaltab + _weight
  end
  WeightedArray.Main = {name = ZoneSizes.Main.zoneName, weight = 1 - totaltab}
  if DEBUG == 1 then
    BASE:E("Dynamic - Weight_ZoneSize : WeightedArray")
    BASE:E(WeightedArray)
  end
  return WeightedArray
end
--- Determines the weighting for placing units in zone.
-- @param ZoneArray : Takes zone array information
-- @return WeightedArray : Array of weighted zone. {[1] = {Zone = "", Weight = #}, .. n}
DynamicSpawner.Weight_ZoneSize = Weight_ZoneSize

local function UnitSpread(ZoneArray, WeightedArray)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - UnitSpread")
  end
  local SpreadArray = {
    Main = {},
    Sub = {},
  }
  local unitsMax  = ZoneArray.Units.Max
  local unitsMin  = ZoneArray.Units.Min
  local GroupsMax = ZoneArray.Units.NumGroupsMax
  local GroupsMin = ZoneArray.Units.NumGroupsMin
  local ActualUnits  = math.random(unitsMin, unitsMax)
  local ActualGroups = math.random(GroupsMin, GroupsMax)
  if DEBUG == 1 then
    BASE:E("Dynamic - UnitSpread - ActualUnits")
    BASE:E(ActualUnits)
    BASE:E("Dynamic - UnitSpread - ActualGroups")
    BASE:E(ActualGroups)
  end
  local mainZone_Name = WeightedArray.Main.name
  local mainZone_Weight = WeightedArray.Main.weight or 0
  local mainZonenumUnits = math.ceil(mainZone_Weight * ActualUnits)
  SpreadArray.Main = {name = mainZone_Name, numUnits = mainZonenumUnits}
  local tally = 0
  for _i = 1, #WeightedArray.Sub, 1 do
    local name = WeightedArray.Sub[_i].name
    local numUnits = math.ceil(WeightedArray.Sub[_i].weight * ActualUnits)
    tally = tally + numUnits
    SpreadArray.Sub[#SpreadArray.Sub + 1] = {name = name, numUnits = numUnits,}
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - tally")
    BASE:E(tally)
  end
  if tally > ActualUnits then
    SpreadArray.Main.numUnits = SpreadArray.Main.numUnits - (tally - ActualUnits)
  end
  if (tally + mainZonenumUnits) > ActualUnits then
    if DEBUG == 1 then
      BASE:E("Dynamic - tally check")
      BASE:E(tally + mainZonenumUnits)
    end
    SpreadArray.Main.numUnits = SpreadArray.Main.numUnits - ((tally + mainZonenumUnits) - ActualUnits  )
    if DEBUG == 1 then
      BASE:E("Dynamic - check 1")
    end
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - check 2")
  end
  if SpreadArray.Main.numUnits < 0 then
    if DEBUG == 1 then
      BASE:E("Dynamic - check 3")
    end
    SpreadArray.Main.numUnits = 0
    if DEBUG == 1 then
      BASE:E("Dynamic - check 4")
    end
  end
  repeat
    if DEBUG == 1 then
      BASE:E("Dynamic - check 5")
    end
    --------------------------------------------------------------
    if SpreadArray.Main.numUnits >= #SpreadArray.Sub then
      if DEBUG == 1 then
        BASE:E("Dynamic - check 6")
      end
      SpreadArray.Main.numUnits = SpreadArray.Main.numUnits - #SpreadArray.Sub
      if DEBUG == 1 then
        BASE:E("Dynamic - check 7")
      end
      for _i = 1, #SpreadArray.Sub, 1 do
        if DEBUG == 1 then
          BASE:E("Dynamic - check 8")
        end
        SpreadArray.Sub[_i].numUnits = SpreadArray.Sub[_i].numUnits + 1
        if DEBUG == 1 then
          BASE:E("Dynamic - check 9")
        end
      end
      if DEBUG == 1 then
        BASE:E("Dynamic - check 10")
      end
    end
    ----------------------------------------------------------------
    if DEBUG == 1 then
      BASE:E("Dynamic - check 11")
    end
  until(SpreadArray.Main.numUnits <= #SpreadArray.Sub)
  if DEBUG == 1 then
    BASE:E("Dynamic - SpreadArray")
    BASE:E(SpreadArray)
  end
  return SpreadArray
end
--- Determines the UnitSpread across Zones.
-- @param ZoneArray : Takes zone array information
-- @param WeightedArray : Array of weighted spread in zone. {[1] = {Zone = "", Weight = #}, .. n}
-- @return SpreadArray : Distribution of units per zone
DynamicSpawner.UnitSpread = UnitSpread

local function GroupSpread(ZoneArray, SpreadArray)
  local DEBUG = 1
  local Tally_usedUnits = 0
  if DEBUG == 1 then
    BASE:E("Dynamic - GroupSpread")
  end
  local _groupSizes = ZoneArray.Units.GroupSizes
  local _GroupSizesMainZone = ZoneArray.Units.GroupSizesMainZone
  local _GroupSpacingSettings = ZoneArray.Units.GroupSpacingSettings
  if DEBUG == 1 then
    BASE:E("Dynamic - GroupSpread - _groupSizes")
    BASE:E(_groupSizes)
    BASE:E("Dynamic - GroupSpread - _GroupSpacingSettings")
    BASE:E(_GroupSpacingSettings)
  end
  local GroupSpreadArray = {
    Main = {},
    Sub = {},
  }
  GroupSpreadArray.Main = {name = SpreadArray.Main.name, numUnits = SpreadArray.Main.numUnits, GroupSpread = {}, CoordStack = {}, CoordStackGroupCenters = {},}
  for _i = 1, #SpreadArray.Sub, 1 do
    if DEBUG == 1 then
      BASE:E("Dynamic - GroupSpread - SpreadArray.Sub[_i].name")
      BASE:E(SpreadArray.Sub[_i].name)
    end
    local units = SpreadArray.Sub[_i].numUnits
    GroupSpreadArray.Sub[#GroupSpreadArray.Sub+1] = {name = SpreadArray.Sub[_i].name, numUnits = units, GroupSpread = {}, CoordStack = {}, CoordStackGroupCenters = {},}
    for _j = 1, #_groupSizes, 1 do
      local GroupSize = _groupSizes[_j]
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupSpread - GroupSize")
        BASE:E(GroupSize)
      end
      local _numGroup = math.floor(units/GroupSize)
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupSpread - divedend")
        BASE:E(_numGroup)
      end
      local modulo = (units % GroupSize)
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupSpread - modulo")
        BASE:E(modulo)
      end
      if _numGroup ~= 0 then
        local distanceFromBuildings =  ZoneArray.SpawnZones[_i].DistanceFromBuildings
        local randunitsep_general = math.random(_GroupSpacingSettings.General.minSeperation,_GroupSpacingSettings.General.maxSeperation)
        local randunitsep_groupSize = nil
        if DEBUG == 1 then
          BASE:E("Dynamic - GroupSpread - GroupSize")
          BASE:E(GroupSize)
        end
        if _GroupSpacingSettings[GroupSize].minSeperation and _GroupSpacingSettings[GroupSize].maxSeperation then
          randunitsep_groupSize = math.random(_GroupSpacingSettings[GroupSize].minSeperation,_GroupSpacingSettings[GroupSize].maxSeperation)
        end
        local distanceFromUnits =  randunitsep_groupSize or randunitsep_general
        local randgroupsep_general = _GroupSpacingSettings.General.minSeparation_Groups
        local randgroupsep_groupSize = nil
        if _GroupSpacingSettings[GroupSize].minSeparation_Groups then
          randgroupsep_groupSize = _GroupSpacingSettings[GroupSize].minSeparation_Groups
        end
        local distanceFromGroups =  randgroupsep_groupSize or randgroupsep_general
        GroupSpreadArray.Sub[_i].GroupSpread[#GroupSpreadArray.Sub[_i].GroupSpread + 1]  = {groupSize = GroupSize, numGroup = _numGroup, distanceFromBuildings = distanceFromBuildings, distanceFromUnits = distanceFromUnits, distanceFromGroups = distanceFromGroups}--= {name = SpreadArray.Sub[_i].name, numUnits = units, GroupSpread = {},}
      end
      if _numGroup > 0 then
        units = units - (_numGroup * GroupSize )
      end
      if DEBUG == 1 then
        Tally_usedUnits = Tally_usedUnits + (_numGroup * GroupSize)
        BASE:E("Dynamic - GroupSpread - Tally_usedUnits")
        BASE:E(Tally_usedUnits)
      end
    end
  end
  local units = GroupSpreadArray.Main.numUnits
  for _j = 1, #_GroupSizesMainZone, 1 do
    local GroupSize = _GroupSizesMainZone[_j]
    if DEBUG == 1 then
      BASE:E("Dynamic - GroupSpread - GroupSize")
      BASE:E(GroupSize)
    end
    local _numGroup = math.floor(units/GroupSize)
    if DEBUG == 1 then
      BASE:E("Dynamic - GroupSpread - divedend")
      BASE:E(_numGroup)
    end
    local modulo = (units % GroupSize)
    if DEBUG == 1 then
      BASE:E("Dynamic - GroupSpread - modulo")
      BASE:E(modulo)
    end
    if _numGroup ~= 0 then
      local distanceFromBuildings =  _GroupSpacingSettings.General.DistanceFromBuildings
      local randunitsep_general = math.random(_GroupSpacingSettings.General.minSeperation,_GroupSpacingSettings.General.maxSeperation)
      local randunitsep_groupSize = nil
      if _GroupSpacingSettings[GroupSize].minSeperation and _GroupSpacingSettings[GroupSize].maxSeperation then
        randunitsep_groupSize = math.random(_GroupSpacingSettings[GroupSize].minSeperation,_GroupSpacingSettings[GroupSize].maxSeperation)
      end
      local distanceFromUnits =  randunitsep_groupSize or randunitsep_general

      local randgroupsep_general = _GroupSpacingSettings.General.minSeparation_Groups
      local randgroupsep_groupSize = nil
      if _GroupSpacingSettings[GroupSize].minSeparation_Groups then
        randgroupsep_groupSize = _GroupSpacingSettings[GroupSize].minSeparation_Groups
      end
      local distanceFromGroups =  randgroupsep_groupSize or randgroupsep_general
      GroupSpreadArray.Main.GroupSpread[#GroupSpreadArray.Main.GroupSpread + 1]  = {groupSize = GroupSize, numGroup = _numGroup, distanceFromBuildings = distanceFromBuildings, distanceFromUnits = distanceFromUnits, distanceFromGroups = distanceFromGroups}--= {name = SpreadArray.Sub[_i].name, numUnits = units, GroupSpread = {},}
    end
    if _numGroup > 0 then
      units = units - (_numGroup * GroupSize )
    end
    if DEBUG == 1 then
      Tally_usedUnits = Tally_usedUnits + (_numGroup * GroupSize)
      BASE:E("Dynamic - GroupSpread - Tally_usedUnits")
      BASE:E(Tally_usedUnits)
    end
  end
  return GroupSpreadArray
end
--- Determines the GroupSpread across Zones.
-- @param ZoneArray : Takes zone array information
-- @param SpreadArray : Array of UnitSpread in zone.
-- @return GroupSpreadArray : Distribution of group centers per zone
DynamicSpawner.GroupSpread = GroupSpread

local function ConfigParse(ConfigArray)
  local DEBUG = 1
  local Config = {}
  for _, value in pairs(ConfigArray) do
    if DEBUG == 1 then
      BASE:E("Dynamic - ConfigParse : _")
      BASE:E(_)
    end
    local numMin = value.min
    local numMax = value.max
    if DEBUG == 1 then
      BASE:E("Dynamic - ConfigParse : numMin")
      BASE:E(numMin)
      BASE:E("Dynamic - ConfigParse : numMax")
      BASE:E(numMax)
    end
    if numMax ~= 0 then
      local rand = math.random(numMin,numMax)
      numMin = rand
      if DEBUG == 1 then
        BASE:E("Dynamic - ConfigParse : randomizer")
        BASE:E(numMin)
      end
    end
    if numMin ~= 0 then
      Config[_] = numMin
    end
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - ConfigParse : Config")
    BASE:E(Config)
  end
  return Config
end
--- Determines the Group structures for groups.
-- @param ConfigArray : Takes Config array information
-- @return Config : config for groups per zone
DynamicSpawner.ConfigParse = ConfigParse

local function GroupRandomizer(spawnConfig_Original, spawnConfig, GroupSpreadArray_i)
  local DEBUG = 1
  --Holds Randomized Group return.
  local RandomizedGroup = {}
  --Holds Structures of group.
  local GroupStructures = {}
  --Set up for spawn coords of group.
  local CoordStructures = {}
  local CoordStackGroupCenters = {}
  --Holds working, reducing (min) spawn unit cfg array.
  local newspawnConfig = {}
  --Holds original, untouched (min) spawn unit cfg array.
  local origTypes = {}
  --Holds original array of group spreads.
  local GroupSpreadArray_ = GroupSpreadArray_i
  --Holds array of working spawnconfig.
  local newspawnConfig = spawnConfig
  -- Flag if units quota was met
  local unitsQuota = 0
  if DEBUG == 1 then
    BASE:E("Dynamic - GroupRandomizer : spawnConfig")
    BASE:E(spawnConfig)
  end
  -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - START ------------- Build list of original possible unit types.
  for _k,_v in pairs(spawnConfig_Original) do
    local _kCheck = string.match(_k, "SAM_")
    if DEBUG == 1 then
      BASE:E("Dynamic - GroupRandomizer : k Check")
      BASE:E(_kCheck)
    end
    if _kCheck == nil then --if _k ~= "SAM" then --string.match(str, "tiger")
      origTypes[#origTypes+1] = _k
    end
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - GroupRandomizer : origTypes")
    BASE:E(origTypes)
  end
  -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - End  ------------

  --   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - START ------------ Iterate through number of groups.
  for _i = 1, GroupSpreadArray_.numGroup, 1 do
    GroupStructures[_i] = {}
    CoordStructures[_i] = {}
    CoordStackGroupCenters[_i] = {}
    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -  Iterate through each unit for groupsize.
    for _j = 1, GroupSpreadArray_.groupSize, 1 do
      -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - Build available spawn types to meet minimums
      local countTypes = {}
      for _k,_v in pairs(newspawnConfig) do
        countTypes[#countTypes+1] = _k
      end
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupRandomizer : countTypes")
        BASE:E(countTypes)
      end
      -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - If minimum units met, set random spawn array
      local next = next
      if next(countTypes) == nil then
        unitsQuota = 1
        if DEBUG == 1 then
          BASE:E("Dynamic - GroupRandomizer : unitsQuota")
          BASE:E(unitsQuota)
        end
        countTypes = DynamicSpawner.Shuffle(origTypes)
      end
      -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - Select random Type based of available for minimums
      local randomTypeIndex = math.random(1, #countTypes)
      countTypes = DynamicSpawner.Shuffle(countTypes)
      local randomType = countTypes[randomTypeIndex]
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupRandomizer : randomType")
        BASE:E(randomType)
      end
      -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - If doesnt contain subtable
      --Set groupstructure array type to selected type.
      GroupStructures[_i][_j] = randomType
      CoordStructures[_i][_j] = {}
      if DEBUG == 1 then
        BASE:E("Dynamic - GroupRandomizer : GroupStructures")
        BASE:E(GroupStructures)
        BASE:E("Dynamic - GroupRandomizer : PRE new_Array")
        BASE:E(newspawnConfig[randomType])
      end
      -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - If unitsQuota has not been maxed, subtract and rebuild table
      if unitsQuota == 0 then
        -- remove 1 from current selection available pool
        newspawnConfig[randomType] = newspawnConfig[randomType] - 1
        --if available pool is now 0
        if newspawnConfig[randomType] == 0 then
          if DEBUG == 1 then
            BASE:E("Dynamic - GroupRandomizer : newspawnConfig[randomType] equal 0")
          end
          --temporary array for rebuilding the newspawnConfig
          local new_Array = {}
          -- For each Subcategory and alloted amount do
          for _k_, _v_ in pairs(newspawnConfig) do
            if DEBUG == 1 then
              BASE:E("Dynamic - GroupRandomizer : pairs : KEY")
              BASE:E(_k_)
              BASE:E("Dynamic - GroupRandomizer : pairs : VALUE")
              BASE:E(_v_)
              BASE:E("Dynamic - GroupRandomizer : pairs : VALUE type")
              local _type_ = type(newspawnConfig[_k_])
              BASE:E(_type_)
            end
            -- if value != 0 and not a table then
            if _v_ > 0  then--_v_ ~= {} then
              new_Array[_k_] = _v_
            end
          end
          -- Update config.
          newspawnConfig = new_Array
          if DEBUG == 1 then
            BASE:E("Dynamic - GroupRandomizer : newspawnConfig = new_Array")
            BASE:E(newspawnConfig)
          end
        end
      end
    end
  end
  RandomizedGroup = {cfg = newspawnConfig, grp = GroupStructures, CoordStack = CoordStructures, CoordStackGroupCenters = CoordStackGroupCenters}
  return RandomizedGroup
end
--- Determines group structure based on configs and groupspread.
-- @param spawnConfig_Original : Original spawnconfig
-- @param spawnConfig : working Array of spawnConfig in zone.
-- @param GroupSpreadArray_i : Takes GroupSpread[_i] Array for zone
-- @return RandomizedGroup : Array of {newspawnConfig, GroupStructures = {[1] = {Type = #, },}
DynamicSpawner.GroupRandomizer = GroupRandomizer

local function StructureGroups(spawnConfig_Original, GroupSpreadArray, spawnConfig)
  local DEBUG = 1
  local StructuredGroups = {}
  local GroupSpreadArray_ = GroupSpreadArray
  local spawnConfig_ = spawnConfig
  for _i = 1, #GroupSpreadArray_.Sub, 1 do
    local ZoneObjectCoords = DynamicSpawner.FindObjectsInZone(GroupSpreadArray_.Sub[_i].name)
    GroupSpreadArray_.Sub[_i].ZoneObjectCoords = ZoneObjectCoords
    local zoneArray = GroupSpreadArray_.Sub[_i]
    GroupSpreadArray_.Sub[_i].GroupList = {}
    for _j = 1, #zoneArray.GroupSpread, 1 do
      if DEBUG == 1 then
        BASE:E("Dynamic - StructureGroups : zoneArray.GroupSpread[_j]")
        BASE:E(zoneArray.GroupSpread[_j])
      end
      local result = DynamicSpawner.GroupRandomizer(spawnConfig_Original, spawnConfig_, zoneArray.GroupSpread[_j])
      spawnConfig_ = result.cfg
      if DEBUG == 1 then
        BASE:E("Dynamic - StructureGroups : result")
        BASE:E(result)
      end
      GroupSpreadArray_.Sub[_i].CoordStackGroupCenters[#GroupSpreadArray_.Sub[_i].CoordStackGroupCenters + 1] = result.CoordStackGroupCenters
      GroupSpreadArray_.Sub[_i].CoordStack[#GroupSpreadArray_.Sub[_i].CoordStack + 1] = result.CoordStack
      GroupSpreadArray_.Sub[_i].GroupList[#GroupSpreadArray_.Sub[_i].GroupList + 1] = result.grp-- = merge(GroupSpreadArray_.Sub[_i].GroupList,result.grp)
      if DEBUG == 1 then
        BASE:E("Dynamic - StructureGroups : GroupSpreadArray_")
        BASE:E(GroupSpreadArray_)
      end
    end
  end
  local zoneArray = GroupSpreadArray_.Main
  GroupSpreadArray_.Main.GroupList = {}
  for _j = 1, #zoneArray.GroupSpread, 1 do
    if DEBUG == 1 then
      BASE:E("Dynamic - StructureGroups : MAIN zoneArray.GroupSpread[_j]")
      BASE:E(zoneArray.GroupSpread[_j])
    end
    local result = DynamicSpawner.GroupRandomizer(spawnConfig_Original, spawnConfig_, zoneArray.GroupSpread[_j])
    spawnConfig_ = result.cfg
    if DEBUG == 1 then
      BASE:E("Dynamic - StructureGroups : MAIN result")
      BASE:E(result)
    end
    GroupSpreadArray_.Main.CoordStackGroupCenters[#GroupSpreadArray_.Main.CoordStackGroupCenters + 1] = result.CoordStackGroupCenters
    GroupSpreadArray_.Main.CoordStack[#GroupSpreadArray_.Main.CoordStack + 1] = result.CoordStack
    GroupSpreadArray_.Main.GroupList[#GroupSpreadArray_.Main.GroupList + 1] = result.grp-- = merge(GroupSpreadArray_.Sub[_i].GroupList,result.grp)
    if DEBUG == 1 then
      BASE:E("Dynamic - StructureGroups : MAIN GroupSpreadArray_")
      BASE:E(GroupSpreadArray_)
    end
  end
  StructuredGroups = GroupSpreadArray_
  return StructuredGroups
end
--- Determines group structure based on configs and groupspread.
-- @param spawnConfig_Original
-- @param GroupSpreadArray : Array of GroupSpreadArray in zone.
-- @param spawnConfig : Takes spawn config array
-- @return StructuredGroups : StructuredGroups Generated for groups per zone
DynamicSpawner.StructureGroups = StructureGroups

local function GroupGenerator(ZoneArray, GroupSpreadArray)
  local DEBUG = 1
  local GroupsGenerated = {}
  local spawnConfig = DynamicSpawner.ConfigParse(ZoneArray.Units.ConfigTypes)
  local spawnConfig_Original = spawnConfig
  local GroupStructure = DynamicSpawner.StructureGroups(spawnConfig_Original, GroupSpreadArray, spawnConfig)
  GroupsGenerated = GroupStructure
  return GroupsGenerated
end
--- Determines the Group structures for groups.
-- @param ZoneArray : Takes zone array information
-- @param GroupSpreadArray : Array of GroupSpreadArray in zone.
-- @return GroupsGenerated : GroupsGenerated for groups per zone
DynamicSpawner.GroupGenerator = GroupGenerator

local function PointRandomizer_Groups_SubZone(GroupArray, subZone, GroupInfo_Array )
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - PointRandomizer_Groups_SubZone : Start")
    BASE:E("Dynamic - PointRandomizer_Groups_SubZone : GroupArray")
    BASE:E(GroupArray)
    BASE:E("Dynamic - PointRandomizer_Groups_SubZone : subZone")
    BASE:E(subZone)
    BASE:E("Dynamic - PointRandomizer_Groups_SubZone : GroupInfo_Array")
    BASE:E(GroupInfo_Array)
  end
  --- Find possible Group Center Coord.
  local Flag_GroupTooClose = 0
  local Flag_GroupIteration_Count = 0
  local Flag_GroupIteration_Cutoff = 2
  local groupCenter_possible
  local possibleVec2
  local confirmedVec2
  local distanceFromGroups = GroupInfo_Array.distanceFromGroups
  repeat
    Flag_GroupTooClose = 0
    local Flag_FindRandomPoint = 0
    local Flag_EmergencyCut = 0
    local Flag_FindRandomPoint_Counter = 0
    local Flag_FindRandomPoint_Cutoff = 2

    repeat
      if Flag_EmergencyCut == 0 then
        groupCenter_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
      else
        groupCenter_possible = subZone.zone:GetRandomCoordinate(0, subZone.radius)
      end
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Groups_SubZone : groupCenter_possible")
        BASE:E(groupCenter_possible)
      end
      if groupCenter_possible then
        Flag_FindRandomPoint = 1
        possibleVec2 = {x = groupCenter_possible.x, y = groupCenter_possible.z }
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Groups_SubZone : possibleVec2")
          BASE:E(possibleVec2)
        end
      end
      if Flag_FindRandomPoint_Counter > Flag_FindRandomPoint_Cutoff then
        Flag_FindRandomPoint_Counter = 0
        Flag_FindRandomPoint = 0
        Flag_EmergencyCut = 1
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Groups_SubZone : possibleVec2 CUTOFF")
        end
        --  subZone.radius = subZone.radius * 1.15
        -- GroupInfo_Array.distanceFromBuildings = GroupInfo_Array.distanceFromBuildings * 1.15
        -------- --groupCenter_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
        ---------  -- local dd = subZone.zone:GetRandomCoordinate(0,subZone.radius,surfacetypes)
      else
        Flag_FindRandomPoint_Counter = Flag_FindRandomPoint_Counter + 1
      end
    until Flag_FindRandomPoint == 1
    ---Compare to existing group Center points, if within minimum group find another.
    for numSubZone = 1, #GroupArray.Sub, 1 do
      local _CoordStackGroupCenters = GroupArray.Sub[numSubZone].CoordStackGroupCenters
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Groups_SubZone :  _CoordStackGroupCenters")
        BASE:E(_CoordStackGroupCenters)
        local _distance
        for numGrouping = 1, #_CoordStackGroupCenters, 1 do
          for numGroupCenter = 1, #_CoordStackGroupCenters[numGrouping], 1 do
            local _GroupCenterCoordsStored =  _CoordStackGroupCenters[numGrouping][numGroupCenter]
            if _GroupCenterCoordsStored.x and _GroupCenterCoordsStored.y then
              _distance = math.sqrt((_GroupCenterCoordsStored.x - possibleVec2.x)^2 + (_GroupCenterCoordsStored.y - possibleVec2.y)^2)
              if _distance < distanceFromGroups then
                Flag_GroupTooClose = 1
                break
              end
            end
            if Flag_GroupTooClose == 1 then
              break
            end
          end
          if Flag_GroupTooClose == 1 then
            break
          end
        end
      end
    end
    if DEBUG == 1 then
      BASE:E("Dynamic - PointRandomizer_Groups_SubZone : Flag_GroupIteration_Count")
      BASE:E(Flag_GroupIteration_Count)
      BASE:E("Dynamic - PointRandomizer_Groups_SubZone : Flag_GroupTooClose")
      BASE:E(Flag_GroupTooClose)
    end
    if Flag_GroupIteration_Count > Flag_GroupIteration_Cutoff then
      Flag_GroupTooClose = 0
    else
      Flag_GroupIteration_Count = Flag_GroupIteration_Count + 1
    end
    if Flag_GroupTooClose == 0 then
      confirmedVec2 = possibleVec2
    end
  until Flag_GroupTooClose == 0
  return confirmedVec2
    --- END Find possible Group Center Coord.
end
--- determines placement for Placement_Groups based on generated groups per zones.
-- @param subZone :
-- @param GroupInfo_Array :
-- @param selectedPointsAll :
-- @param NumZone :
-- @param _numgroup :
-- @return PlacedUnits :
DynamicSpawner.PointRandomizer_Groups_SubZone = PointRandomizer_Groups_SubZone

local function f_distance(p1, p2)
  return math.sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end
--- Standard formula for distance between 2 points.
-- @param p1 : Point 1 {x = , y = }
-- @param p2 : Point 2 {x = , y = }
-- @return Distance between p1 and p2
DynamicSpawner.f_distance = f_distance

local function PointRandomizer_Units_SubZone(GroupArray, GroupInfo_Array, subZone, NumZone, _i, _numgroup)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : Start")

    BASE:E("Dynamic - PointRandomizer_Units_SubZone : GroupArray")
    BASE:E(GroupArray)
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : GroupInfo_Array")
    BASE:E(GroupInfo_Array)
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : subZone")
    BASE:E(subZone)
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : NumZone")
    BASE:E(NumZone)
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : _i")
    BASE:E(_i)
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : _numgroup")
    BASE:E(_numgroup)

  end


  local PlacedUnits = {}
  local possibleVec2 = {}
  local confirmedVec2 = {}
  local flag_goodcoord = 0
  local restrictedCoords = GroupArray.Sub[NumZone].ZoneObjectCoords

  while #PlacedUnits < GroupInfo_Array.groupSize do
    local debugcycleCounter = 0
    flag_goodcoord = 0
    while flag_goodcoord == 0 do
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Units_SubZone : debugcycleCounter")
        debugcycleCounter = debugcycleCounter + 1
        BASE:E(debugcycleCounter)
      end
      flag_goodcoord = 1
      --select random coord in zone
      possibleVec2 = subZone.zone:GetRandomVec2()
      --check if coord too close to restricted
      for _k,_v in pairs(restrictedCoords) do
        --set distance restriction
        local distance
        if _k == "units" then
          distance = GroupInfo_Array.distanceFromUnits
        else
          distance = GroupInfo_Array.distanceFromBuildings
        end
        for _i = 1, #restrictedCoords[_k] do
          local checkCoord = restrictedCoords[_k][_i]
          if DynamicSpawner.f_distance(checkCoord,possibleVec2) < distance then
            flag_goodcoord = 0
            break
          end
        end
        if flag_goodcoord == 0 then break end
      end

      PlacedUnits[#PlacedUnits + 1] = possibleVec2
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Units_SubZone : PlacedUnits[#PlacedUnits]")
        BASE:E(PlacedUnits[#PlacedUnits])
      end
      restrictedCoords.units[#restrictedCoords.units+1] = possibleVec2
    end
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - PointRandomizer_Units_SubZone : PlacedUnits")
    BASE:E(PlacedUnits)
  end
  return PlacedUnits
end
--- determines placement for PointRandomizer_Units_SubZone based on generated groups per zones.
-- @param subZone :
-- @param GroupInfo_Array :
-- @param selectedPointsAll :
-- @param NumZone :
-- @param _numgroup :
-- @return PlacedUnits :
DynamicSpawner.PointRandomizer_Units_SubZone = PointRandomizer_Units_SubZone

local function PointRandomizer_Groups_MainZone(GroupArray, subZone, GroupInfo_Array)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - PointRandomizer_Groups_MainZone : Start")
    BASE:E("Dynamic - PointRandomizer_Groups_MainZone : GroupArray")
    BASE:E(GroupArray)
    BASE:E("Dynamic - PointRandomizer_Groups_MainZone : subZone")
    BASE:E(subZone)
    BASE:E("Dynamic - PointRandomizer_Groups_MainZone : GroupInfo_Array")
    BASE:E(GroupInfo_Array)
  end
  --- Find possible Group Center Coord.
  local Flag_GroupTooClose = 0
  local Flag_EmergencyCut = 0
  local Flag_GroupIteration_Count = 0
  local Flag_GroupIteration_Cutoff = 2
  local groupCenter_possible
  local possibleVec2
  local confirmedVec2
  local distanceFromGroups = GroupInfo_Array.distanceFromGroups
  repeat
    Flag_GroupTooClose = 0
    local Flag_FindRandomPoint = 0
    local Flag_FindRandomPoint_Counter = 0
    local Flag_FindRandomPoint_Cutoff = 2

    repeat
      if Flag_EmergencyCut == 0 then
        groupCenter_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
      else
        groupCenter_possible = subZone.zone:GetRandomCoordinate(0, subZone.radius)
      end
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Groups_MainZone : groupCenter_possible")
        BASE:E(groupCenter_possible)
      end
      if groupCenter_possible then
        Flag_FindRandomPoint = 1
        possibleVec2 = {x = groupCenter_possible.x, y = groupCenter_possible.z }
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Groups_MainZone : possibleVec2")
          BASE:E(possibleVec2)
        end
      end
      if Flag_FindRandomPoint_Counter > Flag_FindRandomPoint_Cutoff then
        Flag_FindRandomPoint_Counter = 0
        Flag_FindRandomPoint = 0
        Flag_EmergencyCut = 1
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Groups_MainZone : possibleVec2 CUTOFF")
        end
        --  subZone.radius = subZone.radius * 1.15
        -- GroupInfo_Array.distanceFromBuildings = GroupInfo_Array.distanceFromBuildings * 1.15
        -------- --groupCenter_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
        ---------  -- local dd = subZone.zone:GetRandomCoordinate(0,subZone.radius,surfacetypes)
      else
        Flag_FindRandomPoint_Counter = Flag_FindRandomPoint_Counter + 1
      end
    until Flag_FindRandomPoint == 1
    ---Compare to existing group Center points, if within minimum group find another.
    for numSubZone = 1, #GroupArray.Sub, 1 do
      local _CoordStackGroupCenters = GroupArray.Sub[numSubZone].CoordStackGroupCenters
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Groups_MainZone :  _CoordStackGroupCenters")
        BASE:E(_CoordStackGroupCenters)
        for numGrouping = 1, #_CoordStackGroupCenters, 1 do
          for numGroupCenter = 1, #_CoordStackGroupCenters[numGrouping], 1 do
            local _GroupCenterCoordsStored =  _CoordStackGroupCenters[numGrouping][numGroupCenter]
            if _GroupCenterCoordsStored.x and _GroupCenterCoordsStored.y then
              local _distance = math.sqrt((_GroupCenterCoordsStored.x - possibleVec2.x)^2 + (_GroupCenterCoordsStored.y - possibleVec2.y)^2)
              if _distance < distanceFromGroups then
                Flag_GroupTooClose = 1
                break
              end
            end
          end
          if Flag_GroupTooClose == 1 then
            break
          end
        end
      end
      if Flag_GroupTooClose == 1 then
        break
      end
    end
    if DEBUG == 1 then
      BASE:E("Dynamic - PointRandomizer_Groups_MainZone : Flag_GroupIteration_Count")
      BASE:E(Flag_GroupIteration_Count)
      BASE:E("Dynamic - PointRandomizer_Groups_MainZone : Flag_GroupTooClose")
      BASE:E(Flag_GroupTooClose)
    end
    if Flag_GroupIteration_Count > Flag_GroupIteration_Cutoff then
      Flag_GroupTooClose = 0
    else
      Flag_GroupIteration_Count = Flag_GroupIteration_Count + 1
    end
    if Flag_GroupTooClose == 0 then
      confirmedVec2 = possibleVec2
    end
  until Flag_GroupTooClose == 0
  return confirmedVec2
    --- END Find possible Group Center Coord.
end
--- determines placement for units based on generated groups per zones.
-- @param subZone :
-- @param GroupInfo_Array :
-- @param selectedPointsAll :
-- @param NumZone :
-- @param _numgroup :
-- @return PlacedUnits :
DynamicSpawner.PointRandomizer_Groups_MainZone = PointRandomizer_Groups_MainZone

local function PointRandomizer_Units_MainZone(GroupArray, GroupInfo_Array, subZone, _i, _numgroup)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - PointRandomizer_Units_MainZone : Start")
    BASE:E("Dynamic - PointRandomizer_Units_MainZone : GroupArray")
    BASE:E(GroupArray)
    BASE:E("Dynamic - PointRandomizer_Units_MainZone : GroupInfo_Array")
    BASE:E(GroupInfo_Array)
  end

  --- Find possible Group Center Coord.
  local Flag_GroupTooClose = 0
  local Flag_GroupIteration_Count = 0
  local Flag_GroupIteration_Cutoff = 1
  local unitPlace_possible
  local possibleVec2
  local confirmedVec2
  local distanceFromGroups = GroupInfo_Array.distanceFromGroups
  local distanceFromUnits = GroupInfo_Array.distanceFromUnits

  repeat
    Flag_GroupTooClose = 0
    local Flag_FindRandomPoint = 0
    local Flag_EmergencyCut = 0
    local Flag_FindRandomPoint_Counter = 0
    local Flag_FindRandomPoint_Cutoff = 1
    if DEBUG == 1 then
      BASE:E("Dynamic - PointRandomizer_Units_MainZone : subZone.radius")
      BASE:E(subZone.radius)
    end
    repeat
      if Flag_EmergencyCut == 0 then
        unitPlace_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
      else
        unitPlace_possible = subZone.zone:GetRandomCoordinate(0, subZone.radius)
      end
      if DEBUG == 1 then
        BASE:E("Dynamic - PointRandomizer_Units_MainZone : unitPlace_possible")
        BASE:E(unitPlace_possible)
      end
      if unitPlace_possible then
        Flag_FindRandomPoint = 1
        possibleVec2 = {x = unitPlace_possible.x, y = unitPlace_possible.z }
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Units_MainZone : possibleVec2")
          BASE:E(possibleVec2)
        end
      end
      if Flag_FindRandomPoint_Counter > Flag_FindRandomPoint_Cutoff then
        Flag_FindRandomPoint_Counter = 0
        Flag_FindRandomPoint = 0
        Flag_EmergencyCut = 1
        if DEBUG == 1 then
          BASE:E("Dynamic - PointRandomizer_Units_MainZone : possibleVec2 CUTOFF")
        end
        --  subZone.radius = subZone.radius * 1.15
        -- GroupInfo_Array.distanceFromBuildings = GroupInfo_Array.distanceFromBuildings * 1.15
        -------- --groupCenter_possible = subZone.zone:GetRandomCoordinateWithoutBuildings(0, subZone.radius, GroupInfo_Array.distanceFromBuildings)
        ---------  -- local dd = subZone.zone:GetRandomCoordinate(0,subZone.radius,surfacetypes)
      else
        Flag_FindRandomPoint_Counter = Flag_FindRandomPoint_Counter + 1
      end
    until Flag_FindRandomPoint == 1
    ---Compare to existing group Center points, if within minimum group find another.
    -- for numSubZone = 1, #GroupArray.Sub, 1 do
    local _CoordStackGroupCenters = GroupArray.Main.CoordStackGroupCenters
    local _CoordStack = GroupArray.Main.CoordStack
    if DEBUG == 1 then
      BASE:E("Dynamic - PointRandomizer_Units_MainZone :  _CoordStackGroupCenters")
      BASE:E(_CoordStackGroupCenters)
      for numGrouping = 1, #_CoordStackGroupCenters, 1 do
        for numGroupCenter = 1, #_CoordStackGroupCenters[numGrouping], 1 do
          if _numgroup ~= numGroupCenter then
            local _GroupCenterCoordsStored =  _CoordStackGroupCenters[numGrouping][numGroupCenter]
            if _GroupCenterCoordsStored.x and _GroupCenterCoordsStored.y then
              local _distance = math.sqrt((_GroupCenterCoordsStored.x - possibleVec2.x)^2 + (_GroupCenterCoordsStored.y - possibleVec2.y)^2)
              if _distance < distanceFromGroups then
                Flag_GroupTooClose = 1
                break
              end
              for numUnit = 1, #_CoordStack[numGrouping][numGroupCenter], 1 do
                local _unitPlaceCoordsStored =  _CoordStack[numGrouping][numGroupCenter][numUnit]
                if _unitPlaceCoordsStored.x and _unitPlaceCoordsStored.y then
                  local _distance = math.sqrt((_unitPlaceCoordsStored.x - possibleVec2.x)^2 + (_unitPlaceCoordsStored.y - possibleVec2.y)^2)
                  if _distance < distanceFromUnits then
                    Flag_GroupTooClose = 1
                    break
                  end
                end
              end
            end
          end
          if Flag_GroupTooClose == 1 then
            break
          end
        end
        if Flag_GroupTooClose == 1 then
          break
        end
        --     end
      end
    end
    if DEBUG == 1 then
      BASE:E("Dynamic - PointRandomizer_Units_MainZone : Flag_GroupIteration_Count")
      BASE:E(Flag_GroupIteration_Count)
      BASE:E("Dynamic - PointRandomizer_Units_MainZone : Flag_GroupTooClose")
      BASE:E(Flag_GroupTooClose)
    end
    if Flag_GroupIteration_Count > Flag_GroupIteration_Cutoff then
      Flag_GroupTooClose = 0
    else
      Flag_GroupIteration_Count = Flag_GroupIteration_Count + 1
    end
    if Flag_GroupTooClose == 0 then
      confirmedVec2 = possibleVec2
    end
  until Flag_GroupTooClose == 0
  return confirmedVec2
    --- END Find possible Group Center Coord.
end
--- determines placement for units based on generated groups per zones.
-- @param subZone :
-- @param GroupInfo_Array :
-- @param selectedPointsAll :
-- @param NumZone :
-- @param _numgroup :
-- @return PlacedUnits :
DynamicSpawner.PointRandomizer_Units_MainZone = PointRandomizer_Units_MainZone

local function Placement_Groups(ZoneArray, GroupArray)
  local DEBUG = 1
  --- For each zone in sub
  for NumZone, ZoneArray in pairs(GroupArray.Sub) do
    local subZone = {
      zone = ZONE:New(GroupArray.Sub[NumZone].name),
    }
    subZone.radius = subZone.zone:GetRadius()
    --     subZone.area = math.pi * (subZone.radius)^2
    --    subZone.center = subZone.zone:GetVec2()
    --- GroupSpread array for loop iteration.
    for _i = 1, #GroupArray.Sub[NumZone].GroupSpread do
      local GroupInfo_Array = GroupArray.Sub[NumZone].GroupSpread[_i]
      ---Loop through numGroup
      for _numgroup = 1, GroupArray.Sub[NumZone].GroupSpread[_i].numGroup do
        ---Loop through grouplist
        local randpoints_ = DynamicSpawner.PointRandomizer_Groups_SubZone(GroupArray, subZone, GroupInfo_Array)
        GroupArray.Sub[NumZone].CoordStackGroupCenters[_i][_numgroup] = randpoints_
        if DEBUG == 1 then
          BASE:E("Dynamic - Placement_Groups : GroupArray")
          BASE:E(GroupArray)
        end
      end
    end
  end
  --- For MainZone
  local subZone = {
    zone = ZONE:New(GroupArray.Main.name),
  }
  subZone.radius = subZone.zone:GetRadius()
  --    subZone.area = math.pi * (subZone.radius)^2
  --     subZone.center = subZone.zone:GetVec2()
  --- GroupSpread array for loop iteration.
  for _i = 1, #GroupArray.Main.GroupSpread do
    local GroupInfo_Array = GroupArray.Main.GroupSpread[_i]
    ---Loop through numGroup
    for _numgroup = 1, GroupArray.Main.GroupSpread[_i].numGroup do
      ---Loop through grouplist
      local randpoints_ = DynamicSpawner.PointRandomizer_Groups_MainZone(GroupArray, subZone, GroupInfo_Array )
      GroupArray.Main.CoordStackGroupCenters[_i][_numgroup] = randpoints_
      if DEBUG == 1 then
        BASE:E("Dynamic - Placement_Groups : GroupArray")
        BASE:E(GroupArray)
      end
    end
  end
  local PlacedGroupArray = GroupArray
  return PlacedGroupArray
end
--- determines placement for Placement_Groups based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param _GroupGenerator : Array of _GroupGenerator in zone.
-- @return PlacedGroupArray : group array with added group coords for groups per zone
DynamicSpawner.Placement_Groups = Placement_Groups

local function Placement_Units(ZoneArray, PlacedGroups)
  local DEBUG = 1
  local GroupArray = PlacedGroups
  local GroupArray_t = GroupArray
  --- For each zone in sub
  for NumZone, ZoneArray in pairs(GroupArray.Sub) do
    --- GroupSpread array for loop iteration.
    for _i = 1, #GroupArray.Sub[NumZone].GroupSpread do
      ---Loop through numGroup
      for _numgroup = 1, GroupArray.Sub[NumZone].GroupSpread[_i].numGroup do
        GroupArray_t.Sub[NumZone].CoordStack[_i][_numgroup] = {}
        local GroupInfo_Array = GroupArray.Sub[NumZone].GroupSpread[_i]
        local subZone = {}
        local tempZoneName = "Temp"
        local tempZoneVec2 = GroupArray.Sub[NumZone].CoordStackGroupCenters[_i][_numgroup]
        local tempZoneRadius = (GroupInfo_Array.distanceFromUnits * GroupInfo_Array.groupSize) + (GroupInfo_Array.distanceFromGroups * GroupInfo_Array.numGroup ) + GroupInfo_Array.distanceFromBuildings
        subZone.zone = ZONE_RADIUS:New(tempZoneName,tempZoneVec2,tempZoneRadius)--ZONE:New(GroupArray.Sub[NumZone].name),
        subZone.radius = tempZoneRadius
        -- for _numUnit = 1, GroupArray.Sub[NumZone].GroupSpread[_i].groupSize do
        ---Loop through grouplist
        -- local randpoints_ = bridson_sampling({x = tempZoneVec2.x,y = tempZoneVec2.y}, GroupInfo_Array.distanceFromUnits, GroupInfo_Array.groupSize, subZone,GroupInfo_Array.distanceFromBuildings)
        local randpoints_ = DynamicSpawner.PointRandomizer_Units_SubZone(GroupArray, GroupInfo_Array, subZone, NumZone, _i, _numgroup)
        GroupArray.Sub[NumZone].CoordStack[_i][_numgroup] = randpoints_--[#GroupArray.Sub[NumZone].CoordStack[_i][_numgroup] + 1] = randpoints_
        if DEBUG == 1 then
          BASE:E("Dynamic - Placement_Units : GroupArray")
          BASE:E(GroupArray)
        end
        --  end

      end
    end
    GroupArray.Sub[NumZone].ZoneObjectCoords = {}
  end

  --- For MainZone
  GroupArray_t = GroupArray
  --    subZone.area = math.pi * (subZone.radius)^2
  --     subZone.center = subZone.zone:GetVec2()
  --- GroupSpread array for loop iteration.
  for _i = 1, #GroupArray.Main.GroupSpread do
    ---Loop through numGroup
    for _numgroup = 1, GroupArray.Main.GroupSpread[_i].numGroup do
      GroupArray_t.Main.CoordStack[_i][_numgroup] = {}
      local GroupInfo_Array = GroupArray.Main.GroupSpread[_i]
      local subZone = {}
      local tempZoneName = "Temp"
      local tempZoneVec2 = GroupArray.Main.CoordStackGroupCenters[_i][_numgroup]
      local tempZoneRadius = (GroupInfo_Array.distanceFromUnits * GroupInfo_Array.groupSize) + (GroupInfo_Array.distanceFromGroups * GroupInfo_Array.numGroup ) + GroupInfo_Array.distanceFromBuildings
      subZone.zone = ZONE_RADIUS:New(tempZoneName,tempZoneVec2,tempZoneRadius)--ZONE:New(GroupArray.Sub[NumZone].name),
      subZone.radius = tempZoneRadius
      for _numUnit = 1, GroupArray.Main.GroupSpread[_i].groupSize do
        ---Loop through grouplist
        local randpoints_ = DynamicSpawner.PointRandomizer_Units_MainZone(GroupArray, GroupInfo_Array, subZone, _i, _numgroup )
        GroupArray.Main.CoordStack[_i][_numgroup][#GroupArray.Main.CoordStack[_i][_numgroup] + 1] = randpoints_
        if DEBUG == 1 then
          BASE:E("Dynamic - Placement_Units : GroupArray")
          BASE:E(GroupArray)
        end
      end
      --        ---Loop through grouplist
      --        local GroupInfo_Array = GroupArray.Main.GroupSpread[_i]
      --        local randpoints_ = DynamicSpawner.PointRandomizer_Units_MainZone(GroupArray, GroupInfo_Array, subZone, _i, _numgroup )
      --        GroupArray.Main.CoordStack[_i][_numgroup][#GroupArray.Main.CoordStack[_i][_numgroup] + 1] = randpoints_
      --        if DEBUG == 1 then
      --          BASE:E("Dynamic - Placement_Units : GroupArray")
      --          BASE:E(GroupArray)
      --        end
    end
  end
  local PlacedGroupArray = GroupArray
  return PlacedGroupArray
end
--- determines placement for Placement_Units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param PlacedGroups : Array of PlacedGroups in zone.
-- @return PlacedGroupArray : group array with added group coords for groups per zone
DynamicSpawner.Placement_Units = Placement_Units

local function DeterminePlacement(ZoneArray, _GroupGenerator)
  local DEBUG = 1
  local PlacedUnits = {}
  local GroupArray = _GroupGenerator


  local PlacedGroups = DynamicSpawner.Placement_Groups(ZoneArray, GroupArray)
  if DEBUG == 1 then
    BASE:E("Dynamic - DeterminePlacement : PlacedGroups")
    BASE:E(PlacedGroups)
  end
  local PlacedUnits = DynamicSpawner.Placement_Units(ZoneArray, PlacedGroups)
  return PlacedUnits
end
--- determines placement for units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param _GroupGenerator : Array of _GroupGenerator in zone.
-- @return PlacedUnits : spawnedUnits for groups per zone
DynamicSpawner.DeterminePlacement = DeterminePlacement

local function SelectTemplate(numGroup,numSubGroup,numUnit,SubZoneArray)--ZoneArray, SubZoneArray, groupUnits)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : START")
    --      BASE:E("Dynamic - SelectTemplate : ZoneArray")
    --      BASE:E(ZoneArray)
    BASE:E("Dynamic - SelectTemplate : SubZoneArray")
    BASE:E(SubZoneArray)
    --      BASE:E("Dynamic - SelectTemplate : groupUnits")
    --      BASE:E(groupUnits)
    BASE:E("Dynamic - SelectTemplate : #SubZoneArray.GroupSpread")
    BASE:E(#SubZoneArray.GroupSpread)

    for _k,_v in pairs(SubZoneArray) do
      BASE:E("Dynamic - SelectTemplate : SubZoneArray _k")
      BASE:E(_k)
      BASE:E("Dynamic - SelectTemplate : SubZoneArray _v")
      BASE:E(_v)
    end
  end
  local UnitName
  ---Spawn Units Main.
  --    for numGroup = 1, #SubZoneArray.GroupList, 1 do
  --      for numSubGroup = 1, SubZoneArray.GroupSpread[numGroup].numGroup, 1 do
  --        for numUnit = 1, SubZoneArray.GroupSpread[numGroup].groupSize, 1 do
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : SubZoneArray.GroupSpread[numGroup].numGroup")
    BASE:E(SubZoneArray.GroupSpread[numGroup].numGroup)
    BASE:E("Dynamic - SelectTemplate : SubZoneArray.GroupSpread[numGroup].groupSize")
    BASE:E(SubZoneArray.GroupSpread[numGroup].groupSize)
    BASE:E("Dynamic - SelectTemplate : numGroup")
    BASE:E(numGroup)
    BASE:E("Dynamic - SelectTemplate : numSubGroup")
    BASE:E(numSubGroup)
    BASE:E("Dynamic - SelectTemplate : numUnit")
    BASE:E(numUnit)
    BASE:E("Dynamic - SelectTemplate : SubZoneArray.GroupList[numGroup][numSubGroup]")
    BASE:E(SubZoneArray.GroupList[numGroup][numSubGroup])
  end
  --- Select Random Unit from appropriate Table
  local type_ = SubZoneArray.GroupList[numGroup][numSubGroup][numUnit]
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : type_")
    BASE:E(type_)
  end
  local configTemplates = SpawnerTemplates[type_]
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : configTemplates")
    BASE:E(configTemplates)
  end
  local shuffle1 = DynamicSpawner.Shuffle(configTemplates)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : shuffle1")
    BASE:E(shuffle1)
  end
  local randompick = math.random(1, #shuffle1)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : randompick")
    BASE:E(randompick)
  end
  local shuffle2 = DynamicSpawner.Shuffle(shuffle1)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : shuffle2")
    BASE:E(shuffle2)
  end
  --          TemplateArray[#TemplateArray+1] = shuffle2[randompick]
  --        end
  --      end
  --    end
  --    if DEBUG == 1 then
  --      BASE:E("Dynamic - SelectTemplate : TemplateArray")
  --      BASE:E(TemplateArray)
  --    end
  --    ---Spawn Units Sub.
  UnitName = shuffle2[randompick]
  return UnitName
end
--- SelectTemplate for units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param groupPlacement : Array of groupPlacement in zone.
-- @return UnitName : UnitName fpr se;ected template
DynamicSpawner.SelectTemplate = SelectTemplate

local function SelectTemplateU(numGrouping,numGroup,numUnit,SubZoneArray)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : START")
  end
  local UnitName
  --- Select Random Unit from appropriate Table
  local type_ = SubZoneArray.GroupList[numGrouping][numGroup][numUnit]
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : type_")
    BASE:E(type_)
  end
  local configTemplates = SpawnerTemplates[type_]
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : configTemplates")
    BASE:E(configTemplates)
  end
  local shuffle1 = DynamicSpawner.Shuffle(configTemplates)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : shuffle1")
    BASE:E(shuffle1)
  end
  local randompick = math.random(1, #shuffle1)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : randompick")
    BASE:E(randompick)
  end
  local shuffle2 = DynamicSpawner.Shuffle(shuffle1)
  if DEBUG == 1 then
    BASE:E("Dynamic - SelectTemplate : shuffle2")
    BASE:E(shuffle2)
  end
  --          TemplateArray[#TemplateArray+1] = shuffle2[randompick]
  --        end
  --      end
  --    end
  --    if DEBUG == 1 then
  --      BASE:E("Dynamic - SelectTemplate : TemplateArray")
  --      BASE:E(TemplateArray)
  --    end
  --    ---Spawn Units Sub.
  UnitName = shuffle2[randompick]
  return UnitName
end
--- SelectTemplate for units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param groupPlacement : Array of groupPlacement in zone.
-- @return UnitName : UnitName fpr se;ected template
DynamicSpawner.SelectTemplateU = SelectTemplateU

local function ActivateUnits(ZoneArray, groupPlacement)
  local DEBUG = 1
  if DEBUG == 1 then
    BASE:E("Dynamic - ActivateUnits : START")
  end
  local ActivatedUnits = {}
  local GroupArray = groupPlacement
  GroupArray.Main.SelectedUnitStack = {}
  GroupArray.Main.ActivatedUnits = {}
  GroupArray.Main.Counter = 1
  local SubZoneArray = GroupArray.Main
  ---Spawn Units Main.
  for numGroup = 1, #GroupArray.Main.CoordStack, 1 do
    GroupArray.Main.SelectedUnitStack[numGroup] = {}
    GroupArray.Main.ActivatedUnits[numGroup] = {}
    for numSubGroup = 1, #GroupArray.Main.CoordStack[numGroup], 1 do
      --- Select Random Unit Templates for all units in sub group
      GroupArray.Main.SelectedUnitStack[numGroup][numSubGroup] ={}-- DynamicSpawner.SelectTemplate(ZoneArray, SubZoneArray, GroupArray.Main.GroupList[numGroup][numSubGroup])--[#GroupArray.Main.SelectedUnitStack[numGroup][numSubGroup]+1] = {}--DynamicSpawner.SelectTemplate(ZoneArray, SubZoneArray, GroupArray.Main.GroupList[numGroup][numSubGroup])
      GroupArray.Main.ActivatedUnits[numGroup][numSubGroup] = {}

      for numUnit = 1, #GroupArray.Main.CoordStack[numGroup][numSubGroup], 1 do
        GroupArray.Main.SelectedUnitStack[numGroup][numSubGroup][numUnit] = {}
        GroupArray.Main.SelectedUnitStack[numGroup][numSubGroup][numUnit] = DynamicSpawner.SelectTemplate(numGroup,numSubGroup,numUnit,SubZoneArray) --ZoneArray, SubZoneArray, GroupArray.Main.GroupList[numGroup][numSubGroup])


        local _spawnunit = SPAWN:NewWithAlias(GroupArray.Main.SelectedUnitStack[numGroup][numSubGroup][numUnit], GroupArray.Main.name .. "_" .. GroupArray.Main.Counter)
          :InitHeading(0,364)
          :SpawnFromVec2(GroupArray.Main.CoordStack[numGroup][numSubGroup][numUnit])
        GroupArray.Main.Counter = GroupArray.Main.Counter + 1
        GroupArray.Main.ActivatedUnits[numGroup][numSubGroup][numUnit] = _spawnunit

      end
    end
  end
  ---Spawn Units Sub.

  for zoneNum = 1, #GroupArray.Sub, 1 do
    GroupArray.Sub[zoneNum].SelectedUnitStack = {}
    GroupArray.Sub[zoneNum].ActivatedUnits = {}
    GroupArray.Sub[zoneNum].Counter = 1
    local SubZoneArray = GroupArray.Sub[zoneNum]
    for numGrouping = 1, #GroupArray.Sub[zoneNum].GroupSpread, 1 do
      GroupArray.Sub[zoneNum].SelectedUnitStack[numGrouping] = {}
      GroupArray.Sub[zoneNum].ActivatedUnits[numGrouping] = {}

      for numGroup = 1, GroupArray.Sub[zoneNum].GroupSpread[numGrouping].numGroup, 1 do
        GroupArray.Sub[zoneNum].SelectedUnitStack[numGrouping][numGroup] ={}
        GroupArray.Sub[zoneNum].ActivatedUnits[numGrouping][numGroup] = {}

        for numUnit = 1, GroupArray.Sub[zoneNum].GroupSpread[numGrouping].groupSize, 1 do

          local unitTemplate = DynamicSpawner.SelectTemplateU(numGrouping,numGroup,numUnit,SubZoneArray)
          local _spawnunit = SPAWN:NewWithAlias(unitTemplate, GroupArray.Sub[zoneNum].name .. "_" .. GroupArray.Sub[zoneNum].Counter)
            :InitHeading(0,364)
            :SpawnFromVec2(GroupArray.Sub[zoneNum].CoordStack[numGrouping][numGroup][numUnit])


          GroupArray.Sub[zoneNum].SelectedUnitStack[numGrouping][numGroup][numUnit] = unitTemplate
          GroupArray.Sub[zoneNum].ActivatedUnits[numGrouping][numGroup][numUnit] = _spawnunit
          GroupArray.Sub[zoneNum].Counter = GroupArray.Sub[zoneNum].Counter + 1
        end
      end
    end
  end

  if DEBUG == 1 then
    BASE:E("Dynamic - ActivateUnits : GroupArray.Main")
    BASE:E(GroupArray.Main)
  end
  if DEBUG == 1 then
    BASE:E("Dynamic - ActivateUnits : GroupArray.Sub")
    BASE:E(GroupArray)
  end
  ActivatedUnits = GroupArray
  return ActivatedUnits
end
--- determines placement for units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param groupPlacement : Array of groupPlacement in zone.
-- @return ActivatedUnits : spawned Units for groups per zone
DynamicSpawner.ActivateUnits = ActivateUnits

local function SpawnUnits(ZoneArray, _GroupGenerator)
  local DEBUG = 1
  local T0 = os.time()
  local groupPlacement =  DynamicSpawner.DeterminePlacement(ZoneArray, _GroupGenerator)
  if DEBUG == 1 then
    BASE:E("Dynamic - SpawnUnits : groupPlacement")
    BASE:E(groupPlacement)
  end

  local T1=os.time()
  BASE:E(string.format("Dynamic - FILLZONE COMPLETE Time: %d",T1-T0))
  local spawnedUnits =  DynamicSpawner.ActivateUnits(ZoneArray, groupPlacement)
  if DEBUG == 1 then
    BASE:E("Dynamic - SpawnUnits : spawnedUnits")
    BASE:E(spawnedUnits)
  end
  return spawnedUnits
end
--- Spawns units based on generated groups per zones.
-- @param ZoneArray : Takes zone array information
-- @param _GroupGenerator : Array of _GroupGenerator in zone.
-- @return spawnedUnits : spawnedUnits for groups per zone
DynamicSpawner.SpawnUnits = SpawnUnits

local function FillZone(ZoneArray)
  local DEBUG = 1
  local FilledArray = {}
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : ZoneArray")
    BASE:E(ZoneArray)
  end



  local WeightedZones = DynamicSpawner.Weight_ZoneSize(ZoneArray)
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : WeightedZones")
    BASE:E(WeightedZones)
  end


  local _UnitSpread = DynamicSpawner.UnitSpread(ZoneArray, WeightedZones)
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : _UnitSpread")
    BASE:E(_UnitSpread)
  end


  local _GroupSpread = DynamicSpawner.GroupSpread(ZoneArray, _UnitSpread)
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : _GroupSpread")
    BASE:E(_GroupSpread)
  end


  local _GroupGenerator = DynamicSpawner.GroupGenerator(ZoneArray, _GroupSpread)
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : _GroupGenerator")
    BASE:E(_GroupGenerator)
  end

  local _SpawnUnits = DynamicSpawner.SpawnUnits(ZoneArray, _GroupGenerator)
  if DEBUG == 1 then
    BASE:E("Dynamic - FillZone : _SpawnUnits")
    BASE:E(_SpawnUnits)
  end


  FilledArray = _SpawnUnits
  return FilledArray
end
--- Fills Zone with Units.
-- @param ZoneArray : Takes zone array information
-- @return FilledArray : All information about spawned units/groups for zone
DynamicSpawner.FillZone = FillZone

