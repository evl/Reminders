local addonName, addon = ...
local config = addon.config.consumables

if config.enabled then
	local hasExpiringAura = function(name, duration)
		local name, _, _, _, _, _, expirationTime = UnitAura("player", "Well Fed", nil, "HELPFUL")
	
		if name then
			return expirationTime - GetTime() <= duration * 60
		end
	end

	local hasExpiringFlask = function(duration)
		for i = 1, BUFF_MAX_DISPLAY do
			local name, _, _, _, _, _, expirationTime = UnitAura("player", i, "HELPFUL|CANCELABLE")
	
			if name then
				if name:sub(1, 5) == "Flask" then
					return expirationTime - GetTime() <= duration * 60
				end			
			else
				return false
			end
		end
	end

	addon:AddReminder("Food buff expiring soon", function() return hasExpiringAura("Well Fed", config.foodThresholdTime) end, nil, "spell_misc_food")
	addon:AddReminder("Flask expiring soon", function() return hasExpiringFlask(config.flaskThresholdTime) end, nil, "inv_alchemy_endlessflask_06")
end