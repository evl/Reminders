local addonName, addon = ...
local config = addon.config.shaman

if config.enabled and addon.playerClass == "SHAMAN" then	
	local mainHandTooltip, offHandTooltip = addon:GetWeaponEnchantTooltip(config.mainHandEnchants[1], config.mainHandEnchants[2]), addon:GetWeaponEnchantTooltip(config.offHandEnchants[1], config.offHandEnchants[2])
	local mainHandAttributes = {type = "spell", spell1 = config.mainHandEnchants[1], spell2 = config.mainHandEnchants[2]}
	local offHandAttributes = {type = "spell", spell1 = config.offHandEnchants[1], spell2 = config.offHandEnchants[2]}
	
	local onEvent = function(self, event, unit)
		if not (event == "UNIT_INVENTORY_CHANGED" and unit ~= "player") then
			local slot = self:GetAttribute("target-slot")
			local hasEnchant, expiration = select(slot == 16 and 1 or 4, GetWeaponEnchantInfo())
			local validWeapon = addon:HasEnchantableWeapon(slot)
			
			if hasEnchant then
				local timeLeft = expiration / 1000
				
				if timeLeft < config.thresholdTime * 60 then
					self.title = self.name .." expiring in " .. SecondsToTime(timeLeft, nil, true):lower()
					self.setColor(1, 1, 1)
					
					return validWeapon
				end
			else
				-- If we just lost or applied an enchant we need to poll the weapon enchant info for a while until we're sure it's changed
				if event == "UNIT_INVENTORY_CHANGED" and validWeapon then
					local poller = self.poller or addon:CreatePoller(self, 2)
					poller.elapsed = 0
				end
				
				if validWeapon then
					self.title = self.name .." missing"
					self.setColor(1, 0.1, 0.1)
					
					return true
				end
			end
		end
	end

	addon:AddReminder("Missing Shield", function() return not addon:PlayerHasAnyAura(config.shields) end, nil, nil, {type = "spell", unit = "player", spell1 = config.shields[1], spell2 = config.shields[2]})
	
	addon:AddReminder("Main hand weapon enchant", "UNIT_INVENTORY_CHANGED", onEvent, nil, nil, mainHandAttributes, mainHandTooltip)
	addon:AddReminder("Off hand weapon enchant", "UNIT_INVENTORY_CHANGED", onEvent, nil, nil, offHandAttributes, offHandTooltip)
end
