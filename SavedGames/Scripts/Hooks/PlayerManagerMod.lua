local Debug_PlayerManager = 0

net.log("PLAYERMANAGER LOADED")
--https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
require('io')
require('lfs')
require('os')

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
    if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - Database file found") end
    io.close(file)
    return true
  else
    if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - Database file not found") end
    return false
  end
end
--END FILE MANIPULATION


local PlayerDatabase_Path  = lfs.writedir() .. "PlayerDatabase/"
local PlayerDatabase_File = PlayerDatabase_Path .. "/" ..  "PlayerDatabase.lua"
if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - PlayerDatabase_File: " .. PlayerDatabase_File) end

local PlayerDatabase = {}

function PlayerDatabase.onPlayerConnect(id)
  if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - onPlayerConnect") end
  if  DCS.isServer() and DCS.isMultiplayer() then
    local data = {
      name = net.get_player_info(id, 'name'),
      ucid = net.get_player_info(id, 'ucid'),
    }
    if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - name = " .. data.name .. " -  ucid = " .. data.ucid) end
    if file_exists(PlayerDatabase_File) then
      local LoadedDatabase = persistence.load(PlayerDatabase_File)
      if LoadedDatabase then
        if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - Loaded_PlayerDatabase - " .. persistence.dump(LoadedDatabase)) end
        local flagFoundPlayerUCID = 0
        for _i = 1, #LoadedDatabase, 1 do
          if LoadedDatabase[_i]["ucid"] == data.ucid then
            LoadedDatabase[_i]["name"] = data.name
            flagFoundPlayerUCID = 1
            break
          end
        end
        if flagFoundPlayerUCID == 0 then
          LoadedDatabase[#LoadedDatabase+1] = {name = data.name, ucid = data.ucid, pointsred = 100, pointsblue = 100,}
          if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - New_PlayerDatabase - " .. persistence.dump(LoadedDatabase)) end
        end
        if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - Updated_PlayerDatabase - " .. persistence.dump(LoadedDatabase)) end
        persistence.store(PlayerDatabase_File, LoadedDatabase)
      else
        local PrimeDatabase = {}
        PrimeDatabase[#PrimeDatabase+1] = {name = data.name, ucid = data.ucid, pointsred = 100, pointsblue = 100,}
        if Debug_PlayerManager == 1 then net.log("PLAYERMANAGER - Prime_PlayerDatabase - " .. persistence.dump(PrimeDatabase)) end
        persistence.store(PlayerDatabase_File, PrimeDatabase)
      end
    end
  end
  return
end
DCS.setUserCallbacks(PlayerDatabase)
