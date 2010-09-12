local addonName, addon = ...
local config = addon.config.shaman

if config.enabled and addon.playerClass == "SHAMAN" then	
	local mainHandTooltip, offHandTooltip = addon:GetWeaponEnchantTooltip(config.mainHandEnchants[1], config.mainHandEnchants[2]), addon:GetWeaponEnchantTooltip(config.offHandEnchants[1], config.offHandEnchants[2])
	local mainHandAttributes = {type = "spell", spell1 = config.mainHandEnchants[1], spell2 = config.mainHandEnchants[2]}
	local offHandAttributes = {type = "spell", spell1 = config.offHandEnchants[1], spell2 = config.offHandEnchants[2]}

	addon:AddReminder("Missing Shield", function() return not addon:PlayerHasAnyAura(config.shields) end, nil, nil, {type = "spell", unit = "player", spell1 = config.shields[1], spell2 = config.shields[2]})
	
	addon:AddReminder("Main hand weapon enchant", "UNIT_INVENTORY_CHANGED", addon.WeaponEnchantEventHandler, nil, nil, mainHandAttributes, mainHandTooltip)
	addon:AddReminder("Off hand weapon enchant", "UNIT_INVENTORY_CHANGED", addon.WeaponEnchantEventHandler, nil, nil, offHandAttributes, offHandTooltip)
end
