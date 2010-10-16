local addonName, addon = ...
local config = addon.config.warlock

if config.enabled and addon.playerClass == "WARLOCK" then
	local hasDemon = function()
		local hasPetSpells, petType = HasPetSpells()
		return hasPetSpells and petType == "DEMON"
	end
	
	addon:AddReminder("Missing armor", function() return not addon:HasAnyAura(config.armors) end, {type = "spell", spell1 = config.armors[1], spell2 = config.armors[2]})
	addon:AddReminder("Weapon enchant", addon.WeaponEnchantCallback, {type = "item", ["target-slot"] = 16, item1 = "Grand Firestone", item2 = "Grand Spellstone", threshold = config.thresholdTime}, nil, nil, addon:GetWeaponEnchantTooltip("Grand Firestone", "Grand Spellstone"))
	
	-- Soul Link
	if addon:HasTalentRank(2, 9) then
		addon:AddReminder("Missing Soul Link", function() return not UnitAura("player", "Soul Link") and hasDemon() end, {type = "spell", spell = "Soul Link"})
	end
end

