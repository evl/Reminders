if select(2, UnitClass("player")) == "WARLOCK" then	
	evl_Reminders:AddReminder("Armor missing", function() return not evl_Reminders:PlayerHasBuff("Demon Skin") and not evl_Reminders:PlayerHasBuff("Fel Armor") end, "Spell_Shadow_FelArmour", {type = "spell", spell1 = "Fel Armor", spell2 = "Demon Skin", unit = "player"})

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

	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = "Master Firestone", item2 = "Master Spellstone"}
	local mainHandTooltip = getEnchantTooltip("Master Firestone", "Master Spellstone")
	evl_Reminders:AddReminder("Weapon enchant expiring soon", function() return hasValidWeapon() and getEnchantDuration() > 0 and getEnchantDuration() <= (evl_Reminders.config.warlock.thresholdTime * 60) end, "INV_Misc_Gem_Bloodstone_01", mainHandAttributes, mainHandTooltip)
	evl_Reminders:AddReminder("Weapon enchant missing", function() return hasValidWeapon() and getEnchantDuration() == -1 end, "INV_Misc_Gem_Bloodstone_01", mainHandAttributes, mainHantTooltip, {1, 0.1, 0.1})
end

