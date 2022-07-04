-- Day and Night 3 support
if not tweak_data then
	return
end

if veritasreborn then
    table.insert(tweak_data.veritas_environments_table, 
        {
            value = "environments/rainbeforerain",
            text_id = "veritas_rainbeforerain"		
        }
    )
    table.insert(tweak_data.veritas_environments_table, 
        {
            value = "environments/raidtwilight_001",
            text_id = "veritas_raidtwilight_001"		
        }
    )
    table.insert(tweak_data.veritas_environments_table, 
        {
            value = "environments/raidsunny1",
            text_id = "veritas_raidsunny1"		
        }
    )
end