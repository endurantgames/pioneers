#!/usr/bin/lua

local CONFIG = {
  appname    = "make-markdown.lua",
  bin_dir    = "./bin",
  build_dir  = "./build",
  errors     = true,
  extension  = ".md",
  ignore     = "^(%.git|Makefile|%.test|%.)",
  index      = "intro",
  logformat  = "  %-30s %-40s",
  out_suffix = ".md",
  outdir     = "./out",
  outfile    = "build",
  recipe     = "test",
  recipe_dir = "./",
  recipe_sfx = ".recipe",
  src_dir    = "./src",
  summary    = true,
  verbose    = true,
  };

local lfs = require "lfs"
local cli =  require "cliargs";

local function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

-- =======================================================================================================================
-- code by GianlucaVespignani - 2012-03-04; 2013-01-26
-- Search files in a path, alternative in sub directory
-- @param dir_path string (";" for multiple paths supported)
-- @param filter string - eg.: ".txt" or ".mp3;.wav;.flac"
-- @param s bool - search in subdirectories
-- @param pformat format of data - 'system' for system-dependent number; nil or string with formatting directives
-- @return  files, dirs - files and dir are tables {name, modification, path, size}

function file_search(dir_path, filter, s, pformat)
	-- === Preliminary functions ===
	-- comparison function like the IN() function like SQLlite, item in a array
	-- useful for compair table for escaping already processed item
	-- Gianluca Vespignani 2012-03-03
	local c_in = function(value, tab)
		for k,v in pairs(tab) do
			if v==value then
				return true
			end
		end
		return false
	end

	local string = string	-- http://lua-users.org/wiki/SplitJoin
	function string:split(sep)
		local sep, fields = sep or ":", {}
		local pattern = string.format("([^%s]+)", sep)
		self:gsub(pattern, function(c) fields[#fields+1] = c end)
		return fields
	end

	local ExtensionOfFile = function(filename)
		local rev = string.reverse(filename)
		local len = rev:find("%.")
		local rev_ext = rev:sub(1,len)
		return string.reverse(rev_ext)
	end

	-- === Init ===
	dir_path = dir_path or cwd
	filter = string.lower(filter) or "*"
	extensions = filter:split(";")
	s = s or false -- as /s : subdirectories

	if pformat == 'system' then	-- if 4th arg is explicity 'system', then return the system-dependent number representing date/time
		os_date = function(os_time)
			return os_time
		end
	else
		-- if 4th arg is nil use default, else it could be a string that respects the Time formatting directives
		pformat = pformat or "%Y/%m/%d" -- eg.: "%Y/%m/%d %H:%M:%S"
		os_date = function(os_time)
			return os.date(pformat, os_time)
		end
	end

	-- == MAIN ==
	local files = {}
	local dirs = {}
	local paths = dir_path:split(";")
	for i,path in ipairs(paths) do
		for f in lfs.dir(path) do
			if f ~= "." and f ~= ".." then
				local attr = lfs.attributes ( path.."/"..f )
				if attr.mode == "file" then
					if filter=="*"
					or c_in( string.lower( ExtensionOfFile(f) ), extensions)
					then
						table.insert(files,{
							name = f,
							modification = os_date(attr.modification) ,
							path = path.."/",
							size = attr.size
						})
					end
				else
					if filter=="*" then			-- if attr.mode == "directory" and file ~= "." and file ~= ".." then end
						table.insert(dirs,{
							name = f ,
							modification = os_date(attr.modification) ,
							path = path.."/",
							size = attr.size
						})
					end
					if s and attr.mode == "directory" then
						local subf={}
						local subd={}
						subf, subd = file_search(path.."/"..f, filter, s, pformat)
						for i,v in ipairs(subf) do
							table.insert(files,{
								name = v.name ,
								modification = v.modification ,
								path = v.path,
								size = v.size
							})
						end
						for i,v in ipairs(subd) do
							table.insert(dirs,{
								name = v.name ,
								modification = v.modification ,
								path = v.path,
								size = v.size
							})
						end
					end
				end
			end
		end
	end
	return files,dirs

	--[=[	ABOUT ATTRIBUTES
> for k,v in pairs(a) do print(k..' \t'..v..'') end
dev     2
change  1175551262	-- date of file Creation
access  1235831652
rdev    2
nlink   1
uid     0
gid     0
ino     0
mode    file
modification    1181692021 -- Date of Last Modification
size    805 in byte
	]=]
end



local function vprint(s, l) if CONFIG.verbose then print(string.format(CONFIG.logformat, s or "", l or "")) end; end;
local function eprint(s, l) if CONFIG.errors  then print(string.format(CONFIG.logformat, s or "", l or "")) end; end;
local function sprint(s, l) if CONFIG.summary then print(string.format(CONFIG.logformat, s or "", l or "")) end; end;

-- http://lua-users.org/wiki/FileInputOutput

local function slug(filename)
  filename = string.gsub(filename, "^%" .. CONFIG.src_dir, "");
  filename = string.gsub(filename, "%" .. CONFIG.extension .. "$", "");
  filename = string.gsub(filename, "^/", "");
  filename = string.gsub(filename, "/$", "");
  return filename;
  end;

local function path_level(path)
  path = slug(path);
--  vprint("considering this", path);
  local pathdirs = split(path, "/");
  local level = #pathdirs;
  if string.find(path, CONFIG.index) 
     then vprint("*** found an index", path) 
     else level = level + 1;
     end;
  return level;
  end;

-- see if the file exists
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function slurp(file, no_parse)
  if not file_exists(file) then return nil end
  lines = {}
  for line in io.lines(file) do lines[#lines + 1] = line end
  local slurped = "\n" .. table.concat(lines, "\n") .. "\n";
  if not no_parse 
     then -- normalize the number of octothorpes
   
     local octo, _ = string.match(slurped, "(#+)");
     local octo_level = string.len(octo or "");

     if octo_level > 1
        then local mod = octo_level - 1;
             local oldhash = "\n" .. string.rep("#", mod);
             local newhash = "\n";
             slurped = string.gsub(slurped, oldhash, newhash);
        end;

      local level = path_level(file);
      vprint(slug(file), "should be " .. level .. ", is " .. octo_level);
      if level >= 1
         then local mod = level - 1;
              local oldhash = "\n#";
              local newhash = "\n#" .. string.rep("#", mod)
              slurped = string.gsub(slurped, oldhash, newhash);
              slurped = string.gsub(slurped, "\n#####+", "\n#####");
              -- handle the H6 headings
              slurped = string.gsub(slurped, "\n:#", "\n######");
         end; -- if
  end;
  return slurped;
end

local function dump(file, contents)
  local f = io.open(file, "wb");
  f:write(contents);
  f:close();
end

local outtxt = "";
local FILES  = {};
local DIRS   = {};
local BUILD  = {};
local USED   = {};
local ERR    = {};


local function load_fs()
  files, dirs = file_search(CONFIG.src_dir, "*", true)
  for k, v in pairs(dirs)
    do 
      if string.find(v.path, CONFIG.ignore) then vprint("Skipping directory", v.name); break end;
      local filename = slug(v.path .. v.name);
      DIRS[filename] = true;
      vprint("Learning directory location", filename);
      end;
  
  for k, v in pairs(files)
    do --
      if string.find(v.path, CONFIG.ignore) then break end;
      if string.find(v.name, "%" .. CONFIG.extension .. "$") 
         then --
              local filename = slug(v.path..v.name);
              local pathdirs = split(filename, "/");
              FILES[filename] = true;
          end;
      end;
  return files, dirs;
  end;

local TEMPLATE = { };

local function parse_line(line)
  local asterisk, template = false;
  line = string.gsub(line, "/$", "");
  if string.find(line, "/%*$")
     then asterisk = true;
          line = string.gsub(line, "/%*$", "");
          end;
  if string.find(line, "/?::[a-z]+$")
     then 
          vprint("looks like a template", line);
          template = string.match(line, "/?::([a-z]+)$");
          vprint("i think it's this template", template);
          line = string.gsub(line, "/?::[a-z]+$", "");
          if not TEMPLATE[template] 
             then template = nil; 
                  vprint("the template doesn't exist")
             else vprint("the template DOES exit!")
             end;
          end;
  if string.find(line, "^>")
    then --
         local outfile = string.gsub(line, "^>%s*", "");
               outfile = string.gsub(outfile, ".out$", "");
         CONFIG.outfile = outfile;
         vprint("setting the output file", "\"" .. outfile .. "\"");
    elseif string.find(line, "^#")
    then --
         vprint("comment", line);
    elseif DIRS[line] 
    then --
         vprint("found a directory", line);
         vprint("looking for index", line .. "/" .. CONFIG.index);
         parse_line(line .. "/" .. CONFIG.index);

         if template
            then
              vprint("found a template call", line .. "/::" .. template);
              for k, v in pairs(TEMPLATE[template]) 
                  do parse_line(v(line));
                  end;
            end;

         if asterisk 
            then 
              vprint("found a /* construction", line .. "/*");
              local dir = CONFIG.src_dir .. "/" .. line;
              vprint("looking for files in ", dir)
              local md_files, _ = file_search(dir, CONFIG.extension);

              vprint("found this many", #md_files .. " files");
              for k, v in pairs(md_files)
                  do local sl = v.name;
                     sl = string.gsub(sl, "%" .. CONFIG.extension .. "$", "");
                     parse_line(line .. "/" .. sl)
              end; -- for
            end; -- if asterisk
    elseif FILES[line] and not USED[line]
    then --
         vprint("found an entry", line);
         table.insert(BUILD, CONFIG.src_dir .. "/" .. line .. CONFIG.extension);
         USED[line] = true;
    elseif FILES[line] and USED[line]
    then --
         vprint("skipping entry", line);
    else --
         vprint("this doesn't exist", line);
         table.insert(ERR, line);
    end;
end; 


local function recipe_list()
   local files, dirs = file_search(CONFIG.recipe_dir, CONFIG.recipe_sfx, false)
    sprint("Listing Recipes:", #files .. " known");
    sprint("Recipe directory", CONFIG.recipe_dir);
    for k, v in pairs(files) 
        do print(string.format(CONFIG.logformat, 
              v.path .. v.name,  CONFIG.bin_dir .. "/" .. CONFIG.appname .. " " .. string.gsub(v.name, CONFIG.recipe_sfx, "")
              )); end;
              
    os.exit(1);
end;

-- =======================================================================================================================
-- Command line interface
-- https://lua-cliargs.netlify.com/#/

cli:set_name(CONFIG.appname);
cli:set_description("it creates the .md files we need");

cli:splat("RECIPE", "the recipe to build", "", 1);
-- cli:argument("RECIPE", "the recipe to build");

cli:option("-o, --outfile=OUTFILE", "specify the outfile");

cli:flag( "-v, --verbose", "be more wordy than usual", false);
cli:flag("-q, --quiet", "don't summarize each step", false);
cli:flag("-l, --list", "list the known recipes", false);
cli:flag("-e, --[no-]errors", "show errors", true);

local args, err = cli:parse(arg);
if not args then cli:print_help(); os.exit(1); end;
if err then print(string.format("%s: %s", cli.name, err)); os.exit(1); end;

if args and  args.list then recipe_list() end;

if args.quiet   then CONFIG.summary = false else CONFIG.summary = true;  end;
if args.verbose then CONFIG.verbose = true  else CONFIG.verbose = false; end;
if args.errors  then CONFIG.errors  = true  else CONFIG.errors  = false; end;

if args.RECIPE  
   then CONFIG.recipe  = args.RECIPE;
        CONFIG.outfile = args.RECIPE;
   end;

if args.outfile then CONFIG.outfile = args.outfile end;

-- 

-- =======================================================================================================================
-- Everything above this is initializion
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================

-- start run ------------------------------------------------------------------------------
vprint("Running in verbose mode");
sprint("Showing summaries");

-- read the recipe
sprint("reading recipe", CONFIG.recipe);
local recipe_src = slurp(CONFIG.recipe_dir .. "/" .. CONFIG.recipe .. CONFIG.recipe_sfx, true);

if not recipe_src then print("Error: Can't read that recipe file"); os.exit() end
local recipe = split(recipe_src, "[\r\n]+");
sprint("recipe read", #recipe .. " lines");

-- parse the filesystem tree
sprint("Loading the filesystem map", "source = " .. CONFIG.src_dir );
load_fs();

-- parse the recipe
for _, i in pairs(recipe) do parse_line(i) end;

sprint("slurping other files now", #BUILD .. " files");
for i, v in pairs(BUILD) do outtxt = outtxt .. slurp(v) end;

-- save the output
local outfile = CONFIG.build_dir .. "/" .. CONFIG.outfile .. CONFIG.out_suffix;

sprint("Writing to file", outfile);
sprint("Content size is", string.len(outtxt) .. " characters");
dump(outfile, outtxt);

-- notify of errors
sprint("number of errors", (#ERR or 0) .. " error" .. ((#ERR and #ERR == 1) and "" or "s" ));
if #ERR 
   then for i, v in pairs(ERR) 
        do local errmsg = "Alert: Missing file";
           if string.find(v, CONFIG.index .. "$") then errmsg = "Warning: Missing index"; end;
           eprint(errmsg, v)
        end; -- do
   end; -- if #ERR
