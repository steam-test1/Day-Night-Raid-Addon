if not veritasreborn then
    return
end

-- Day and Night 3 support
local mod_path = tostring(TastNightDayRebornRaidAddon._mod_path)

if not PackageManager:loaded("packages/raidenvaddon") then
    PackageManager:load("packages/raidenvaddon")
end

Hooks:Add("BeardLibCreateScriptDataMods", "VeritasRaidAddonCallBeardLibSequenceFuncs", function()
	
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain.environment", "custom_xml", "environments/rainbeforerain", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight_001.environment", "custom_xml", "environments/raidtwilight_001", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny1.environment", "custom_xml", "environments/raidsunny1", "environment", true)
end)