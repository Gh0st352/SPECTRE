# SPECTRE

S.P.E.C.T.R.E. (Special Purpose Extension for Creating Truly Reactive Environments)

BETA RELEASE

This class acts as the access point for all aspects and functionalities of SPECTRE, offering capabilities to enhance and manage the simulation environment dynamically.

Fully compatible with IntelliSense and IntelliJ.

All features of SPECTRE automatically account for and work with multi-coalition and PvP missions, in addition to PvE (one coalition) missions.

------------------------------------------------------------------------------------------

---

## `ZONEMGR` Key features:

- All in one intelligent framework for speeding mission development.
- Utilizes DBSCAN Clustering Algorithm to contribute to mission learning.
- System is capable of using the determined clusters to decide course of action for mission zones based on cluster information.
- Currently used in Hotspot, Intel, and ZONEMGR's intelligent wrapper for `SPAWNER`
- LiveEditor functionality. Adds brushlike generation and deletion tools for generating and deleting dynamic ground units in game via markers to tailor your experience.

  - `SPAWNER` wrapper:
    - Uses mission learning strategies to detect existing units in zone and classifies them.
    - Ability to dynamically spawn units in an area with regard to detected units' attributes.
    - Ex: Intelligent Bias towards friendly units, bias towards enemy units, no bias for spawn placement.

  - Hotspot:
    - Uses ML strategies to detect concentrations of units in zones and display them as drawn circles on the F10 map for appropriate coalitions. (ex: Blue sees Red Hotspots)
    - Completely tunable so you get the hotspot sizes you prefer.
    - Great for general unit location at a glance for fog-of-war.

  - Intel:
    - Uses the Hotspots and analyzes all units within.
    - Provides Text marker at the center of the hotspot.
    - Marker contains a description of enemy unit types found in the hotspot.

  - F10 Map Sitrep:
    - All Zones are colored according to their owned coalitions.
    - Zone ownership is determined by majority ownership of airfields within the zone.
    - Arrows are drawn across opposing borders indicating frontlines.
    - Automatically updates.

- More advanced implementations to come (Directing ground forces to opposing forces, directing air response, gameplay mechanics, secret sauce).

---

## SSB Automation:

- Will automatically detect all client or player spawn slots in managed zones and assign them to an internal manager.
- When the airfield coalition changes, the manager will automatically enable/disable any relevant slots.
- Optional - Able to detect all ground spawn slots and add them to the manager for their nearest airfield.
- Enables automated SSB toggles for FARP spawns:
  - (ex. Farp A is nearest to airfield X. When airfield X is captured by Red, both airfield X and Farp A slots are enabled for red, disabled for blue).

---

## `SPAWNER` Key features:

- Capable of spawning thousands of unique unit combinations and sizes in fractions of a second.
- Detects and avoids prescribed no-go zones and no-go surfaces (water, runways, player set zones, etc.)
- Detects and avoids obstacles such as buildings and other dynamically spawned units with configurable distance from obstacle limits.
- Zero server/client lag. (Unless you spawn 100 SAM sites at once or large amounts of units in a small area, but that's on you).

  - If you *must* spawn hundreds of units in a small area, configure a smaller operation limit and distance limit from other units.
  - SPAWNER will continuously iterate to find an acceptable spawn location for a group up to the operation limit.
  - As you add units, that is now a smaller acceptable spawn area, leading to increased possibility of not finding an acceptable spawn location.
  - (depending on your no-go & distance limit settings).

## `IADS` Key features:

- Automatically set up and add any SAM/EW unit on the map to the relevant coalition's IADS.
- Uses an active `ZONEMGR` to automatically detect and classify any units (fresh spawned or existing) into their corresponding coalition IADS.
- Able to call all SKYNET functions as normal by using the `IADS.SkynetIADS` field.

      zoneManager = SPECTRE.ZONEMGR:New() (... rest of the ZONEMGR setup)
  
			redIADS = SPECTRE.IADS:New(1,zoneManager):createSkynet("REDIADS")
			redIADS.SkynetIADS:addSAMSite("SAM Site Name")
    
---

## `BRAIN` Key features:

- Easy ability to save and persist data. (see `SPECTRE.BRAIN:checkAndPersist`)
- When using checkAndPersist, you have the ability to give the persistence check a function as an argument.
- This function will execute if the desired object persistence files do not exist to give you the ability to perform whatever actions you need on a first run.
- (see `SPECTRE.ZONEMGR.AddFillSpawnerTemplate` implementation for example)
- Will soon contain modularized and more advanced implementations of the clustering methods in `ZONEMGR` to provide easy access to machine learning strategies.

---

## `PLYRMGR` Key features:

- Ability to automatically create and enable a rewards system for players in the mission.
    - Configurable point rewards for destroying units.
    - SPECTRE uses internal DCS unit attributes to classify units for reward points, so you can be as granular as you like with reward settings.
    - (Rewards highest point value possible from all Unit attribute reward settings)
- Ability to automatically create and enable a support menu system for players in the mission based on your support templates.
- Players can call in any of the following aid types from the comms menu (all redeem costs configurable): 
    - AIRDROP
        - Tank groups
        - AAA groups
        - IFV groups
        - APC groups
        - Supply groups
        - and many more!
    - CAP
    - BOMBER
    - TOMAHAWK
    - STRIKE
- More automated support and reward options to come.
- (One of the earliest parts of SPECTRE, will receive massive updates in the future to add `ZONEMGR`'s 'intelligence')

---

## `IO` Key features:

- Easily accessible way to import/export data to the game environment.

      SPECTRE.IO.PersistenceToFile(filepath, objectToStore, noFunc)
      SPECTRE.IO.PersistenceFromFile(filepath)
  
- Usage:

  
      local noFunc = true
  
  This toggle allows you to skip exporting any key within a table that has a function value.
  
  Defaults to false if ommitted.
  
  Useful for creating templates or save states of existing objects


      local filepath = "TEST/storedObject.lua"
    
  This is relative to the Saved Games Mission Folder.
  
  The example to above would store to "C:\Users\YOU\Saved Games\DCS.openbetaMission\TEST/storedObject.lua")

 
      local objectToStore = SPECTRE
  
  You can export *anything*, even SPECTRE itself.
  
  The main persistence functions for SPECTRE do a version of what I mention above.

 
      SPECTRE.IO.PersistenceToFile(filepath, objectToStore, noFunc)
    
  Saves Object to file.

 
      local loadedObject = {}
      loadedObject = SPECTRE.IO.PersistenceFromFile(filepath)
    
  Loads Object from file to object.
      
---

## `SPECTRE` Key features:

- Debugging capabilities controlled by `DebugEnabled`.
- Configuration for map, coalitions, and countries.
- Persistence management, including flags and file paths for various components.
- Mission status tracking and management.
- Storage for user-defined data in `SPECTRE.USERSTORAGE`:
  
        local userinfo = {
                         x = "I want to save this",
                        [3] = false
                       }

        SPECTRE.USERSTORAGE["userinfo"] = userinfo
  
  - If persistence is enabled, you can get your data back the next load:

        local userinfo = {}
        userinfo = SPECTRE.USERSTORAGE["userinfo"]

---

- Most features require MOOSE and MIST to be loaded before SPECTRE.lua in order to work.
- Most features also require you to desanitize your DCS.
  - `io`, `lfs`, are used for persistence import/export functions.
  - `os.time()` is used for dynamic name generation for various objects when not given name parameters.
- SSB automation requires DCS-SimpleSlotBlock by ciribob to be loaded before SPECTRE.lua.
- IADS automation requires Skynet-IADS by walder to be loaded before SPECTRE.lua.
- For easy units persistence, I recommend using DSMC by Chromium18.
- SPECTRE was designed for and is fully compatible with DSMC use.


------------------------------------------------------------------------------------------

S. - Special         

P. - Purpose         

E. - Extension for   

C. - Creating        

T. - Truly           

R. - Reactive        

E. - Environments    

------------------------------------------------------------------------------------------

CompileTime : Wednesday, November 15, 2023 6:48:27 PM

Commit : 6adc313af566c4a566e5aefe11b85fc2bd03d026

Version : 0.9.5

Discord : gh0st352

75% of the function comment headers & documentation were generated by giving ChatGPT the code. 

If something is off let me know and I will correct it :) 

------------------------------------------------------------------------------------------

This is free software, and you are welcome to redistribute it with certain conditions.

-------------------GNU General Public License v3.0 ------------------------------------

This program is free software: you can redistribute it and/or modify it under the terms 
of the GNU General Public License as published by the Free Software Foundation, 
Version 3 of the License.



This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.


You should have received a copy of the GNU General Public License in the downloaded 
program folder.  If not, see https://www.gnu.org/licenses/.


Copyright (C) 2023 Gh0st - This program comes with ABSOLUTELY NO WARRANTY
------------------------------------------------------------------------------------------
