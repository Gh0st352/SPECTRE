SPECTRE.DebugEnabled = 1


--- Basic ZONEMGR setup.
--
-- The ZONEMGR allows macro level descision making based on what is happening in a given quadpoint zone.



SPECTRE:setTerrainCaucasus() -- Set the map for SPECTRE using `setTerrain` method.


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


SPECTRE.ZONEMGR:New():Setup(zoneNames):Init()

local _placeholder = ""
