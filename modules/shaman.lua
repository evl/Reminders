local addonName, addon = ...
local config = addon.config.shaman

if config.enabled and addon.playerClass == "SHAMAN" then	
	local mainHandTooltip, offHandTooltip = addon:GetWeaponEnchantTooltip(config.mainHandEnchants[1], config.mainHandEnchants[2]), addon:GetWeaponEnchantTooltip(config.offHandEnchants[1], config.offHandEnchants[2])
	local mainHandAttributes = {type = "spell", ["target-slot"] = 16, spell1 = config.mainHandEnchants[1], spell2 = config.mainHandEnchants[2], threshold = config.thresholdTime}
	local offHandAttributes = {type = "spell", ["target-slot"] = 17, spell1 = config.offHandEnchants[1], spell2 = config.offHandEnchants[2], threshold = config.thresholdTime}

	addon:AddReminder("Missing Shield", function() return not addon:HasAnyAura(config.shields) end, {type = "spell", spell1 = config.shields[1], spell2 = config.shields[2]})
	
	addon:AddReminder("Main hand weapon enchant", addon.WeaponEnchantCallback, mainHandAttributes, nil, nil, mainHandTooltip)
	addon:AddReminder("Off hand weapon enchant", addon.WeaponEnchantCallback, offHandAttributes, nil, nil, offHandTooltip)
end
