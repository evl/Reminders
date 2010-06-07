local config = evl_Reminders.config.consumables

if config.enabled then
	local hasAuraDuration = function(name, duration)
		local name, _, _, _, _, _, expirationTime = UnitAura("player", "Well Fed", nil, "HELPFUL")
	
		if name then
			return expirationTime - GetTime() <= duration
		end
	end

	local hasFlaskDuration = function(duration)
		for i = 1, BUFF_MAX_DISPLAY do
			local name, _, _, _, _, _, expirationTime = UnitAura("player", i, "HELPFUL|CANCELABLE")
	
			if name then
				if name:sub(1, 5) == "Flask" then
					return expirationTime - GetTime() <= duration
				end			
			else
				return false
			end
		end
	end

	evl_Reminders:AddReminder("Food buff expiring soon", function() return hasAuraDuration("Well Fed", config.foodThresholdTime * 60) end, "spell_misc_food")
	evl_Reminders:AddReminder("Flask expiring soon", function() return hasFlaskDuration(config.flaskThresholdTime * 60) end, "inv_alchemy_endlessflask_06")
end