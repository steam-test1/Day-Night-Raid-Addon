if not veritasreborn then
    return
end

-- Day and Night 3 support
local mod_path = tostring(TastNightDayRebornRaidAddon._mod_path)

Hooks:Add( "LocalizationManagerPostInit" , "veritasLocalizationRaid" , function( self )
    self:add_localized_strings({
		["veritas_raid_default"] = "Raid Default",
        ["veritas_rain_before_rain_1"] = "Raid Before Rain 1",
		["veritas_rain_before_rain_2"] = "Raid Before Rain 2",
        ["veritas_rain_before_rain_3"] = "Raid Before Rain 3",
        ["veritas_rain_before_rain_4"] = "Raid Before Rain 4",
		["veritas_rain_before_rain_5"] = "Raid Before Rain 5",
        ["veritas_rain_before_rain_6"] = "Raid Before Rain 6",
		["veritas_berlin_day_1"] = "Raid Berlin Day 1",
		["veritas_raid_unkn_1"] = "Raid Unknown 1",
		["veritas_raid_bridge"] = "Raid Bridge",
		["veritas_raid_camp_night"] = "Raid Camp Night",
		["veritas_raid_convoy"] = "Raid Convoy",
		["veritas_raid_sunny_1"] = "Raid Sunny 1",
		["veritas_raid_sunny_2"] = "Raid Sunny 2",
		["veritas_raid_sunny_3"] = "Raid Sunny 3",
        ["veritas_raid_sunny_4"] = "Raid Sunny 4",
        ["veritas_raid_sunny_5"] = "Raid Sunny 5",
		["veritas_raid_sunny_6"] = "Raid Sunny 6",
        ["veritas_raid_sunny_7"] = "Raid Sunny 7",
		["veritas_raid_sunny_8"] = "Raid Sunny 8",
		["veritas_raid_sunny_9"] = "Raid Sunny 9",
        ["veritas_raid_sunny_10"] = "Raid Sunny 10",
		["veritas_raid_fog_1"] = "Raid Foggy 1",
		["veritas_raid_fog_2"] = "Raid Foggy 2",
		["veritas_raid_fog_3"] = "Raid Foggy 3",
        ["veritas_raid_fog_4"] = "Raid Foggy 4",
		["veritas_raid_basement_hq"] = "Raid Basement HQ",
		["veritas_raid_hunter_day"] = "Raid Hunter Day",
		["veritas_raid_hunter_night"] = "Raid Hunter Night",
		["veritas_raid_kelly_outside"] = "Raid Kelly Outside",
		["veritas_raid_morning_1"] = "Raid Morning 1",
		["veritas_raid_morning_2"] = "Raid Morning 2",
		["veritas_raid_morning_3"] = "Raid Morning 3",
        ["veritas_raid_morning_4"] = "Raid Morning 4",
        ["veritas_raid_morning_5"] = "Raid Morning 5",
		["veritas_raid_night_1"] = "Raid Night 1",
		["veritas_raid_night_2"] = "Raid Night 2",
		["veritas_raid_night_3"] = "Raid Night 3",
        ["veritas_raid_night_4"] = "Raid Night 4",
        ["veritas_raid_night_5"] = "Raid Night 5",
		["veritas_raid_night_5a"] = "Raid Night 5A",
		["veritas_raid_night_6"] = "Raid Night 6",
        ["veritas_raid_night_7"] = "Raid Night 7",
		["veritas_raid_night_fog_1"] = "Raid Night Fog 1",
		["veritas_raid_overcast_1"] = "Raid Overcast 1",
		["veritas_raid_overcast_2"] = "Raid Overcast 2",
		-- ["veritas_raid_reichsbank"] = "Raid Reichsbank",
		["veritas_raid_silo_exit"] = "Raid Silo Exit",
		["veritas_raid_spies_1"] = "Raid Spies 1",
		["veritas_raid_sto_1"] = "Raid Sto 1",
		["veritas_raid_sunset_1"] = "Raid Sunset 1",
		["veritas_raid_sunset_2"] = "Raid Sunset 2",
		["veritas_raid_sunset_3"] = "Raid Sunset 3",
        ["veritas_raid_sunset_4"] = "Raid Sunset 4",
        ["veritas_raid_sunset_5"] = "Raid Sunset 5",
		["veritas_raid_sunset_6"] = "Raid Sunset 6",
        ["veritas_raid_sunset_7"] = "Raid Sunset 7",
		["veritas_raid_sunset_8"] = "Raid Sunset 8",
		["veritas_raid_sunset_9"] = "Raid Sunset 9",
        ["veritas_raid_sunset_10"] = "Raid Sunset 10",
		["veritas_raid_sunset_11"] = "Raid Sunset 11",
		["veritas_raid_sunset_12"] = "Raid Sunset 12",
		["veritas_raid_sunset_13"] = "Raid Sunset 13",
        ["veritas_raid_sunset_14"] = "Raid Sunset 14",
        ["veritas_raid_twilight_1"] = "Raid Twillight 1",
		["veritas_raid_twilight_2"] = "Raid Twillight 2",
		["veritas_raid_twilight_3"] = "Raid Twillight 3",
		["veritas_raid_twilight_4"] = "Raid Twillight 4",
		["veritas_raid_twilight_5"] = "Raid Twillight 5",
		["veritas_raid_twilight_6"] = "Raid Twillight 6",
		["veritas_raid_twilight_7"] = "Raid Twillight 7"
    })
end)

if not PackageManager:loaded("packages/raidenvaddon") then
    PackageManager:load("packages/raidenvaddon")
end

Hooks:Add("BeardLibCreateScriptDataMods", "VeritasRaidAddonCallBeardLibSequenceFuncs", function()

	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raiddefault.environment", "custom_xml", "environments/raid_default", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain1.environment", "custom_xml", "environments/rain_before_rain_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain2.environment", "custom_xml", "environments/rain_before_rain_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain3.environment", "custom_xml", "environments/rain_before_rain_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain4.environment", "custom_xml", "environments/rain_before_rain_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain5.environment", "custom_xml", "environments/rain_before_rain_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/rainbeforerain6.environment", "custom_xml", "environments/rain_before_rain_6", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidberlinday1.environment", "custom_xml", "environments/raid_berlin_day_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidunkn1.environment", "custom_xml", "environments/raid_unkn_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidbridge.environment", "custom_xml", "environments/raid_bridge", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidcampnight.environment", "custom_xml", "environments/raid_camp_night", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidcvy.environment", "custom_xml", "environments/raid_convoy", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny1.environment", "custom_xml", "environments/raid_sunny_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny2.environment", "custom_xml", "environments/raid_sunny_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny3.environment", "custom_xml", "environments/raid_sunny_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny4.environment", "custom_xml", "environments/raid_sunny_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny5.environment", "custom_xml", "environments/raid_sunny_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny6.environment", "custom_xml", "environments/raid_sunny_6", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny7.environment", "custom_xml", "environments/raid_sunny_7", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny8.environment", "custom_xml", "environments/raid_sunny_8", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny9.environment", "custom_xml", "environments/raid_sunny_9", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunny10.environment", "custom_xml", "environments/raid_sunny_10", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidfog1.environment", "custom_xml", "environments/raid_fog_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidfog2.environment", "custom_xml", "environments/raid_fog_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidfog3.environment", "custom_xml", "environments/raid_fog_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidfog4.environment", "custom_xml", "environments/raid_fog_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidgermanybasementhq.environment", "custom_xml", "environments/raid_basement_hq", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidhunterday.environment", "custom_xml", "environments/raid_hunter_day", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidhunternight.environment", "custom_xml", "environments/raid_hunter_night", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidkellyoutside.environment", "custom_xml", "environments/raid_kelly_outside", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidmorning1.environment", "custom_xml", "environments/raid_morning_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidmorning2.environment", "custom_xml", "environments/raid_morning_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidmorning3.environment", "custom_xml", "environments/raid_morning_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidmorning4.environment", "custom_xml", "environments/raid_morning_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidmorning5.environment", "custom_xml", "environments/raid_morning_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight1.environment", "custom_xml", "environments/raid_night_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight2.environment", "custom_xml", "environments/raid_night_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight3.environment", "custom_xml", "environments/raid_night_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight4.environment", "custom_xml", "environments/raid_night_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight5.environment", "custom_xml", "environments/raid_night_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight5a.environment", "custom_xml", "environments/raid_night_5a", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight6.environment", "custom_xml", "environments/raid_night_6", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnight7.environment", "custom_xml", "environments/raid_night_7", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidnightfog1.environment", "custom_xml", "environments/raid_night_fog_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidovercast1.environment", "custom_xml", "environments/raid_overcast_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidovercast2.environment", "custom_xml", "environments/raid_overcast_2", "environment", true)
	-- BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidreichsbank.environment", "custom_xml", "environments/raid_reichsbank", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsiloexit.environment", "custom_xml", "environments/raid_silo_exit", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidspies1.environment", "custom_xml", "environments/raid_spies_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsto1.environment", "custom_xml", "environments/raid_sto_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset1.environment", "custom_xml", "environments/raid_sunset_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset2.environment", "custom_xml", "environments/raid_sunset_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset3.environment", "custom_xml", "environments/raid_sunset_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset4.environment", "custom_xml", "environments/raid_sunset_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset5.environment", "custom_xml", "environments/raid_sunset_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset6.environment", "custom_xml", "environments/raid_sunset_6", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset7.environment", "custom_xml", "environments/raid_sunset_7", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset8.environment", "custom_xml", "environments/raid_sunset_8", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset9.environment", "custom_xml", "environments/raid_sunset_9", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset10.environment", "custom_xml", "environments/raid_sunset_10", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset11.environment", "custom_xml", "environments/raid_sunset_11", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset12.environment", "custom_xml", "environments/raid_sunset_12", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset13.environment", "custom_xml", "environments/raid_sunset_13", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidsunset14.environment", "custom_xml", "environments/raid_sunset_14", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight1.environment", "custom_xml", "environments/raid_twilight_1", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight2.environment", "custom_xml", "environments/raid_twilight_2", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight3.environment", "custom_xml", "environments/raid_twilight_3", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight4.environment", "custom_xml", "environments/raid_twilight_4", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight5.environment", "custom_xml", "environments/raid_twilight_5", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight6.environment", "custom_xml", "environments/raid_twilight_6", "environment", true)
	BeardLib:ReplaceScriptData(mod_path .. "assets/environments/raidtwilight7.environment", "custom_xml", "environments/raid_twilight_7", "environment", true)
end)