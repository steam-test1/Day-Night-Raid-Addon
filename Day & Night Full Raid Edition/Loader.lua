veritasreborn = veritasreborn or 
{
	 mod_path 	= ModPath
	,save_path 	= SavePath .. "veritasrebornNew.lua"
	,main_menu 	= "veritas_menu"
	,veritas_random_table_menu = "veritas_random_table_menu"
	,options 	= { random_table = {} }
	,levels		= {}
	,levels_data= {}
	,contracts	= { ["unknow"] = 0 }
	,override_all_value = {}
    ,override_all = {}
	,exclude_form_random = {}
}

--[[
	https://github.com/hipe/lua-table-persistence
	Copyright (c) 2010 Gerhard Roethlin
]]
local write, writeIndent, writers, refCount;

persistence =
{
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
			f, e = blt.vm.loadfile(path);
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

function veritasreborn:Load()
	local settings = persistence.load(self.save_path);
	if not settings then return end
	self.options = settings
	return settings
end

function veritasreborn:Save()
	persistence.store(self.save_path, self.options);
end
veritasreborn:Load()

function veritasreborn:LevelsByVal(fValue, tValue)
	if fValue == "all" then return self.levels end
	local levels = {}
	for k , v in pairs( self.levels_data or {} ) do
		if 		self.levels_data[k][fValue] == tValue 
		then	levels[v.level_id] = self.levels[v.level_id] end
	end
	if levels == {} then return nil end
	return levels
	--log(tostring(levels == {} and nil or levels))
	--return levels == {} and nil or levels
end

function veritasreborn:SetOptions(target, num, by)
	--if num == 1 then num = nil end
	local levels = target or {}
	if by == "contract" then levels = self:LevelsByVal("contact", target) 	end
	if by == "all"		then levels = self:LevelsByVal("all")				end
	
	for level_id, v in pairs( levels or {} ) do 
		self.options[level_id] = num
	end
	self:Save(veritasreborn.options)
	
	return levels
end

--------------------------------------------------------------------------------------------------------------

function GetTableValue(table,value)
	if table ~= nil then return table[value] end
	return nil
end

function ParseJob(data)
	for i , v in pairs( data.tables or {} ) do
		if v.level_id ~= nil then --log("level_id " ..tostring(v.level_id))
			--log("/ " .. v.level_id )
			veritasreborn.levels_data[ v.level_id ] = veritasreborn.levels_data[ v.level_id ] or 
			{
				 level_id 		= v.level_id
				,job_id 		= data.job_id
				,job_name_id	= GetTableValue(tweak_data.narrative.jobs[ data.job_id ], "name_id")
				,stage			= i + ( ( data.i and data.i - 1 ) or 0 )
				,contact		= GetTableValue(tweak_data.narrative.jobs[ data.job_id ], "contact") or "unknow"
			}
		elseif type(v) == "table" and v.level_id == nil then 
			ParseJob({ tables = v or {} , job_id = data.job_id , i = i })
		end
	end
end

function create_env_table()
    for k, v in pairs(veritasreborn.veritas_environments_table) do
        veritasreborn.override_all_value[k] = v.text_id
		veritasreborn.override_all[k] = v.value
    end
    return veritasreborn.override_all_value, veritasreborn.override_all
end

function VeritasSet()
	local 	CustomLoaded = 0

	if veritasreborn.options.disable_envs_change == nil then
		veritasreborn.options.disable_envs_change = true
	end

	local normal

	for k in pairs (veritasreborn.options.random_table) do
        table.insert(veritasreborn.exclude_form_random, k)
    end
    
	normal = veritasreborn.exclude_form_random[ math.random( #veritasreborn.exclude_form_random ) ] 
	
	math.randomseed(os.time())
	for i , level_id in pairs( tweak_data.levels._level_index ) do
		-- Override Set
		if		tweak_data.levels[ level_id ] 
		and		veritasreborn.options[ "override" ] ~= nil
		and 	veritasreborn.options[ "override" ] >  1 then	
			if 	veritasreborn.options[ "override" ] == 2 then
				tweak_data.levels[ level_id ].env_params = { environment = normal }
				-- log(normal)
			else	tweak_data.levels[ level_id ].env_params = { environment = veritasreborn.override_all[ veritasreborn.options[ "override" ] or 1 ] } end
		--end
		-- set per map
		elseif	tweak_data.levels[ level_id ] 
		and		veritasreborn.options[ level_id ] ~= nil
		and 	veritasreborn.options[ level_id ] ~= 1 then
			if 	veritasreborn.options[ level_id ] == 2 then
				tweak_data.levels[ level_id ].env_params = { environment = normal }
			else	tweak_data.levels[ level_id ].env_params = { environment = veritasreborn.override_all[ veritasreborn.options[ level_id ] ] } end
					CustomLoaded = CustomLoaded + 1
			--log( "Custom Time Loaded: " .. level_id )
		end
	end
	if CustomLoaded > 0 then log( "/Custom Time Loaded: " .. tostring( CustomLoaded ) ) end
end
function VeritasInstant()
	if not managers.worlddefinition then
		return
	end
	local 	CustomLoaded = 0

	if veritasreborn.options.disable_envs_change == nil then
		veritasreborn.options.disable_envs_change = true
	end

	local normal

	for k in pairs (veritasreborn.options.random_table) do
        table.insert(veritasreborn.exclude_form_random, k)
    end
    
	normal = veritasreborn.exclude_form_random[ math.random( #veritasreborn.exclude_form_random ) ]  

	local heist_name = managers.job:current_level_id()
	math.randomseed(os.time())
	for i , level_id in pairs( tweak_data.levels._level_index ) do
		-- Override Set
		if		tweak_data.levels[ level_id ] 
		and		veritasreborn.options[ "override" ] ~= nil
		and 	veritasreborn.options[ "override" ] >  1 then	
			if 	veritasreborn.options[ "override" ] == 2 then
				tweak_data.levels[ level_id ].env_params = { environment = normal }
				-- log(normal)
			elseif veritasreborn.options[ "override" ] > 2 then
				managers.worlddefinition:_set_environment(veritasreborn.override_all[ veritasreborn.options[ "override" ] ] ) end
		--end
		-- set per map
		elseif	tweak_data.levels[ level_id ] 
		and		veritasreborn.options[ level_id ] ~= nil
		and 	veritasreborn.options[ level_id ] ~= 1 then
			if 	veritasreborn.options[ level_id ] == 2 then
				tweak_data.levels[ level_id ].env_params = { environment = normal }
			elseif veritasreborn.options[ level_id ] > 2 then
				if heist_name == level_id then
					managers.worlddefinition:_set_environment(veritasreborn.override_all[ veritasreborn.options[ level_id ] ] ) end
				end
					CustomLoaded = CustomLoaded + 1
			--log( "Custom Time Loaded: " .. level_id )
		end
	end
	if CustomLoaded > 0 then log( "/Custom Time Loaded: " .. tostring( CustomLoaded ) ) end
end
--[[
function PrintTableNameList(table)
	for k , v in pairs(table) do
		log("/ " .. tostring(k) .. " /// " .. tostring(v) )
	end
end
--]]
--------------------------------------------------------------------------------------------------------------

	veritasreborn.veritas_environments_table = {
		{
			text_id = "veritas_env_default"
		},
		{
			text_id = "veritas_env_random"
		},
		{
			value = "environments/early_morning",
			text_id = "veritas_env_pd2_env_hox_02"
		},
		{
			value = "environments/morning",
			text_id = "veritas_env_pd2_env_morning_02"
		},
		{
			value = "environments/foggy_evening",
			text_id = "veritas_env_pd2_env_arm_hcm_02"
		},
		{
			value = "environments/night",
			text_id = "veritas_env_pd2_env_n2"
		},
		{
			value = "environments/mid_day",
			text_id = "veritas_env_pd2_env_mid_day"
		},
		{
			value = "environments/afternoon",
			text_id = "veritas_env_pd2_env_afternoon"
		},
		{
			value = "environments/foggy_bright_evening",
			text_id = "veritas_env_pd2_env_foggy_bright"
		},
		{
			value = "environments/foggy_day",
			text_id = "veritas_env_pd2_indiana_basement"
		},
		{
			value = "environments/sunset",
			text_id = "veritas_env_pd2_indiana_diamond_room"
		},
		{
			value = "environments/sunny",
			text_id = "veritas_env_env_cage_tunnels_02"
		},
		{
			value = "environments/mountain",
			text_id = "veritas_env_mountain"
		},
		{
			value = "environments/forest_night",
			text_id = "veritas_env_forest_night"
		},
		{
			value = "environments/docks",
			text_id = "veritas_env_docks"
		},
		{
			value = "environments/mid_day_2",
			text_id = "veritas_env_midday2"
		},
		{
			value = "environments/bettercoredefault",
			text_id = "veritas_env_bettercoredefault"
		},
		{
			value = "environments/rainbeforerain",
			text_id = "raidrain"
		},
		{
			value = "environments/raidtwilight_001",
			text_id = "raidtw1"
		},
		{
			value = "environments/raidsunny1",
			text_id = "raidsunny1"
		},

		
	}
-------------------------------------------------------------------------------------------------------------------
--managers.menu:open_node(veritasreborn.main_menu .. "_" .. type)
Hooks:Add("MenuManagerInitialize", "tDNCF_MMI", function(menu_manager)
	MenuCallbackHandler.DNF_Close_Options 	= function(self)
		--log("// DNF_Close_Options")
		VeritasSet()
		VeritasInstant()
	end
	MenuCallbackHandler.DNF_Config_Reset 	= function(self, item) 	
		local type = item:name():sub(string.len("veritasID_Reset_") + 1)
		
		local levels = {}
		if   type == "all" 
		then levels = veritasreborn:SetOptions({}	 , 1, "all")
		else levels = veritasreborn:SetOptions(type, 1, "contract") end
		
		levels["override"] = ""
		
		if type == "all" then
			for k , v in pairs( veritasreborn.contracts or {} ) do 
				local menu = MenuHelper:GetMenu( veritasreborn.main_menu .. "_" .. k )
				ResetItems(menu, levels, 1)
			end
		end
		
		local menu_id = type == "all" and veritasreborn.main_menu or veritasreborn.main_menu .. "_" .. type
		local menu = MenuHelper:GetMenu( menu_id )
		
		ResetItems(menu, levels, 1)
	end
	
	function ResetItems(menu, items, value)
		for k , v in pairs( items or {} ) do 
			local item = menu:item("veritasID_" .. k)
			if   item 
			then item._current_index = value or 1
				 item:dirty()
			end--item:set_enabled(false)
		end
	end
	
	MenuCallbackHandler.DNF_ValueSet 		= function(self, item)
		veritasreborn.options[ item:name():sub(11) ] = item:value()
		VeritasSet()
		VeritasInstant()
		veritasreborn:Save()
	end

	MenuCallbackHandler.DNF_disable_envs_change 		= function(self, item)
		veritasreborn.options.disable_envs_change = item:value() == "on" and true or false
		veritasreborn:Save()
	end

	veritasreborn:Load()

end)

Hooks:Add("MenuManagerSetupCustomMenus", "tDNCF_MMSC", function( menu_manager, nodes )
	MenuHelper:NewMenu( veritasreborn.main_menu )
	MenuHelper:NewMenu( veritasreborn.main_menu .. "_unknow" )
	MenuHelper:NewMenu( veritasreborn.veritas_random_table_menu )
	
	for k , v in pairs( tweak_data.narrative.contacts ) do 
		veritasreborn.contracts[k] = 0
		MenuHelper.menus = MenuHelper.menus or {}

		local new_menu = deep_clone( MenuHelper.menu_to_clone )
		-- local new_menu = deep_clone( MenuHelper.menus[veritasreborn.main_menu] )
		new_menu._items = {}
		MenuHelper.menus[veritasreborn.main_menu .. "_" .. k] = new_menu
	end
end)

function create_random_env_table()
    for k, v in pairs(veritasreborn.veritas_environments_table) do
        veritasreborn.override_all_value[k] = v.text_id
		veritasreborn.override_all[k] = v.value
    end
    return veritasreborn.override_all,veritasreborn.override_all_value
end

Hooks:Add("MenuManagerPopulateCustomMenus", "PopulateCustomMenus_VeritasRandomTable", function(menu_manager, nodes)
	MenuCallbackHandler.veritas_selected_random = function(self, item)
		veritasreborn.options.random_table[item:name()] = (item:value() == "on") or nil
		veritasreborn:Save()
	end
	
	veritasreborn:Load()
	
	for k, v in pairs(create_random_env_table()) do
		local random_env_prefix = "" 
        local random_env = v
		local get_environments_ids = random_env:gsub('[.].-$', ''):gsub('^[0-9]-environments/', '')
		-- if string.match(random_env, "veritas_env_") then
		-- 	get_environments_ids = get_environments_ids:gsub('_', ' ')
		-- end
		-- if managers.localization:exists("veritas_env_" .. random_env) then
		-- 	random_env_prefix = managers.localization:text("veritas_env_" .. random_env)
		-- end
		MenuHelper:AddToggle({
			id = random_env,
			title = get_environments_ids:gsub('_', ' '),
			desc = "Select the environments you want to appear in the random selection table",
			callback = "veritas_selected_random",
			menu_id = veritasreborn.veritas_random_table_menu,
			value = veritasreborn.options.random_table[random_env] or false,
			localized = false
		})
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "tDNCF_MMBCM", function( menu_manager, nodes )
	MenuHelper:AddButton({
		id 			= "veritasID_Reset_all",
		title 		= "veritas_Reset_all",
		desc 		= "veritasDesc_Resetall",
		callback 	= "DNF_Config_Reset",
		menu_id 	= veritasreborn.main_menu,
		priority 	= 100,
		localized	= true
	})
	
	MenuHelper:AddMultipleChoice( {
		id 			= "veritasID_override",
		title 		= "veritas_override",
		desc 		= "veritasDesc_override",
		callback 	= "DNF_ValueSet",
		items 		= create_env_table(),
		menu_id 	= veritasreborn.main_menu,
		value 		= veritasreborn.options[ "override" ] or 1,
		priority 	= 99,
		localized	= true
	})

	MenuHelper:AddToggle({
		id       = "veritasID_disable_envs_change",
		title    = "veritasID_disable_envs_change_title",
		desc     = "veritasID_disable_envs_change_desc",
		callback = "DNF_disable_envs_change",
		value    = veritasreborn.options.disable_envs_change,
		menu_id  = veritasreborn.main_menu,
		priority = 98,
		localized	= true
	})
	
	MenuHelper:AddDivider({ id = "veritasID_divider_main", size = 20, menu_id = veritasreborn.main_menu, priority = 98 })
	
	for level_id , name_id in pairs( veritasreborn.levels ) do
		local contract	= GetTableValue(veritasreborn.levels_data[ level_id ],"contact") or "unknow"
		local menu_id 	= veritasreborn.main_menu .. "_" .. contract
		
		veritasreborn.contracts[contract] = true
		
		MenuHelper:AddMultipleChoice( {
			id 			= "veritasID_" 		.. level_id,
			title 		= "veritas_" 		.. level_id,
			desc 		= "veritasDesc_" 	.. level_id,
			callback 	= "DNF_ValueSet",
			items 		= create_env_table(),
			menu_id 	= menu_id,
			value 		= veritasreborn.options[ level_id ] or 1,
			localized	= true
		} )
	end
	
	nodes[veritasreborn.main_menu] = 
		MenuHelper:BuildMenu	( veritasreborn.main_menu, { area_bg = "none" } )  
		MenuHelper:AddMenuItem	( nodes.blt_options, veritasreborn.main_menu, "veritas_menuTitle", "veritas_menuDesc")
	
	for k , v in pairs( veritasreborn.contracts ) do
		if v == true then
			local menu_id = veritasreborn.main_menu .. "_" .. k
			
			MenuHelper:AddButton({
				id 			= "veritasID_Reset_" 	.. k,
				--title 		= "veritas_Reset_" 		.. k,
				--desc 		= "veritasDesc_Reset_" 	.. k,
				title 		= "veritas_Reset_all",
				desc 		= "veritasDesc_Resetall",
				callback 	= "DNF_Config_Reset",
				menu_id 	= menu_id,
				priority 	= 100,
				localized	= true
			})
			
			MenuHelper:AddDivider({ id = "veritasID_divider_" .. k, size = 20, menu_id = menu_id,priority = 99 })
			
			nodes[menu_id] = 
			MenuHelper:BuildMenu	( menu_id, { area_bg = "half" } )  
			MenuHelper:AddMenuItem	( nodes[veritasreborn.main_menu], menu_id, menu_id, "veritas_menuDesc")
		end
	end

	nodes[veritasreborn.veritas_random_table_menu] = MenuHelper:BuildMenu( veritasreborn.veritas_random_table_menu )
	MenuHelper:AddMenuItem( nodes[veritasreborn.main_menu], veritasreborn.veritas_random_table_menu, "random_blacklist_environment", "random_blacklist_environment_desc" )
end)

--------------------------------------------------------------------------------------------------------------

Hooks:Add( "LocalizationManagerPostInit" , "veritasLocalization" , function( self )
	self:add_localized_strings({
		 ["veritas_menuTitle"] 			= "Day/Night Changes"
		,["veritas_menuDesc"] 			= "Change the day/night cycles for certain heists!"
		
		,["veritas_env_default"] 			= "Default"
		,["veritas_env_random"] 			= "Random"
		,["veritas_env_pd2_env_hox_02"] 	= "Early Morning"
		,["veritas_env_pd2_env_morning_02"]	= "Morning"
		,["veritas_env_pd2_env_arm_hcm_02"]	= "Foggy Evening"
		,["veritas_env_pd2_env_n2"] 		= "Night"
		
		,["veritas_env_pd2_env_mid_day"] 		= "Mid Day"
		,["veritas_env_pd2_env_afternoon"] 		= "AfterNoon"
		,["veritas_env_pd2_env_foggy_bright"] 	= "Foggy Bright Evening"

		--New Environments
		,["veritas_env_pd2_indiana_basement"] 	= "Foggy Day"
		,["veritas_env_pd2_indiana_diamond_room"] 	= "Sunset"
		,["veritas_env_env_cage_tunnels_02"] 	= "Sunny"
		,["veritas_env_mountain"] 	= "Mountain"
		,["veritas_env_forest_night"] 	= "Forest Night"
		,["veritas_env_docks"] 	= "Docks"
		,["veritas_env_midday2"] 	= "Mid Day 2"
		
		
		,["veritas_menu_unknow"]		= "Unknown Contracts"
		,["veritas_Reset_all"]			= "Reset All DayNight"
		,["veritasDesc_Resetall"]		= "set all to default"
		,["veritas_override"]			= "override"
		,["veritasDesc_override"]		= "This option will override all map's Day/Night\nUnless set it to default."
		,["veritasID_disable_envs_change_title"] = "Disable Indoors Environment Changes"
		,["veritasID_disable_envs_change_desc"] = "Disables the indoor environment changes\nEx enable on heists with multiple environments"
		,["random_blacklist_environment"] = "Random Environment List"
		,["random_blacklist_environment_desc"] = "Select the environments you want to appear in the random selection table"
	})
	
		for job_id , v in pairs( tweak_data.narrative.jobs ) do 
			for i , job_id2 in pairs( tweak_data.narrative.jobs[job_id].job_wrapper or {} ) do
				if tweak_data.narrative.jobs[ job_id2 ].name_id == nil then 
					ParseJob({ tables = tweak_data.narrative.jobs[job_id2].chain or {} , job_id = job_id })
				end
			end
		end
		
		for job_id , v in pairs( tweak_data.narrative.jobs ) do 
			ParseJob({ tables = tweak_data.narrative.jobs[job_id].chain or {} , job_id = job_id })
		end

		local 	CustomLoaded = 0
			for i , level_id in pairs( tweak_data.levels._level_index ) do
				-- Get levels id
				if 		tweak_data.levels[ level_id ] 
				and 	tweak_data.levels[ level_id ].name_id 
				--and not self[ level_id ].env_params 
				then	veritasreborn.levels[ level_id ] = tweak_data.levels[ level_id ].name_id end
			end
		
	VeritasSet()
	--tweak_data.levels[ level_id ].name_id
	
	for k , v in pairs( tweak_data.narrative.contacts ) do 
		self:add_localized_strings({ [veritasreborn.main_menu .. "_" .. k] = k:gsub('_', ' ') .. " Contracts" })
	end


	
	for level_id , name_id in pairs( veritasreborn.levels ) do 
		if veritasreborn.levels_data[ level_id ] then
			local job_name_id 	= veritasreborn.levels_data[ level_id ].job_name_id 	or ""
			local stage			= veritasreborn.levels_data[ level_id ].stage			or 0
			local LocText		= level_id
			local LocTextFull	= self:text(job_name_id)
			
			if Localizer:exists(Idstring(job_name_id)) then LocText = Localizer:lookup(Idstring(job_name_id)) end
			LocText = LocText .. " [" .. stage .. "]"
			
			self:add_localized_strings({ 
				 ["veritas_"		.. level_id] = LocText
				,["veritasDesc_" 	.. level_id] = level_id .. " :level_id\n" .. LocTextFull
			}) 
			
			--log("/ " .. level_id .. " //* " .. tostring(job_name_id) .. " */ " .. LocText)
		else
			self:add_localized_strings({ 
				 ["veritas_"		.. level_id] = level_id .. " [?]"
				,["veritasDesc_" 	.. level_id] = level_id .. " : unknow"
			}) 
		end
	end
end )

--------------------------------------------------------------------------------------------------------------
if not PackageManager:loaded("packages/skiesnewpack") then
	PackageManager:load("packages/skiesnewpack")
end

Hooks:Add("BeardLibCreateScriptDataMods", "VeritasCallBeardLibSequenceFuncs", function()
	local mod_path = tostring(veritasreborn.mod_path)
	
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/env_suburbia.environment", "generic_xml", "environments/early_morning", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/morning.environment", "custom_xml", "environments/morning", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/foggyevening.environment", "custom_xml", "environments/foggy_evening", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/night.environment", "custom_xml", "environments/night", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/midday.environment", "custom_xml", "environments/mid_day", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/afternoon.environment", "generic_xml", "environments/afternoon", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/foggybrightevening.environment", "custom_xml", "environments/foggy_bright_evening", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/foggyday.environment", "custom_xml", "environments/foggy_day", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/sunset.environment", "custom_xml", "environments/sunset", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/sunny.environment", "custom_xml", "environments/sunny", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/mountain.environment", "custom_xml", "environments/mountain", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/forestnight.environment", "custom_xml", "environments/forest_night", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/docks.environment", "generic_xml", "environments/docks", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/midday2.environment", "generic_xml", "environments/mid_day_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/bettercoredefault.environment", "generic_xml", "environments/bettercoredefault", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/core/environments/default.environment", "generic_xml", "core/environments/default", "environment")
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain.environment", "custom_xml", "environments/rainbeforerain", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight_001.environment", "custom_xml", "environments/raidtwilight_001", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny1.environment", "custom_xml", "environments/raidsunny1", "environment", true)
	-- BeardLib:ReplaceScriptData(mod_path .. "assets/environments/env_menu.environment", "custom_xml", "environments/env_menu/env_menu", "environment")

end)