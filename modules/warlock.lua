local addonName, addon = ...
local config = addon.config.warlock

if config.enabled and addon.playerClass == "WARLOCK" then
	local getEnchantDuration = function()
		local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()

		return hasMainHandEnchant and (mainHandExpiration / 1000) or -1
	end

	local getEnchantTooltip = function(enchant, secondaryEnchant)
		local tooltip

		if secEnchant == enchant then
			tooltip = "Click to apply " .. enchant
		else
			tooltip = "Left-click to apply " .. enchant .. "\nRight-click to apply " .. secondaryEnchant
		end

		return tooltip
	end

	local hasValidWeapon = function(offHand)
		local quality = GetInventoryItemQuality("player", offHand and 17 or 16)
		return quality and quality > 1 
	end

	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = "Grand Firestone", item2 = "Grand Spellstone"}
	local mainHandTooltip = getEnchantTooltip("Grand Firestone", "Grand Spellstone")
	
	local hasDemon = function()
		local hasPetSpells, petType = HasPetSpells()
		return hasPetSpells and petType == "DEMON"
	end
	
	addon:AddReminder("Missing armor", function() return not addon:PlayerHasAnyAura(config.armors) end, "Spell_Shadow_FelArmour", {type = "spell", unit = "player", spell1 = config.armors[1], spell2 = config.armors[2]})
	addon:AddReminder("Weapon enchant expiring soon", function() return hasValidWeapon() and getEnchantDuration() > 0 and getEnchantDuration() <= (addon.config.warlock.thresholdTime * 60) end, "INV_Misc_Gem_Bloodstone_01", mainHandAttributes, mainHandTooltip)
	addon:AddReminder("Weapon enchant missing", function() return hasValidWeapon() and getEnchantDuration() == -1 end, "INV_Misc_Gem_Bloodstone_01", mainHandAttributes, mainHantTooltip, {1, 0.1, 0.1})
	
	addon:AddReminder("Missing Soul Link", function() return addon:HasTalent(2, 9) and not addon:PlayerHasBuff("Soul Link") and hasDemon() end, "Spell_Shadow_GatherShadows", {type = "spell", spell = "Soul Link", unit = "player"})
end

