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

