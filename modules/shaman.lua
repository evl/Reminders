if select(2, UnitClass("player")) == "SHAMAN" then	
	local config = evl_Reminders.config.shaman

	evl_Reminders:AddReminder("Missing Shield", function() return not evl_Reminders:PlayerHasBuff("Water Shield") and not evl_Reminders:PlayerHasBuff("Lightning Shield") end, "Ability_Shaman_WaterShield", {type = "spell", spell1 = "Water Shield", spell2 = "Lightning Shield", unit = "player"})

	--Temporary Weapon Echants
	local icons = {
		["Windfury Weapon"] = "Spell_Nature_Cyclone",
		["Rockbiter Weapon"] = "Spell_Nature_RockBiter",
		["Earhliving Weapon"] = "Spell_Shaman_EarthlivingWeapon",
		["Flametongue Weapon"] = "Spell_Fire_FlameTounge",
		["Frostbrand Weapon"] = "Spell_Frost_FrostBrand",
	}

	local getEnchantIcon = function(enchant)
		return icons[enchant]
	end

	local getEnchantDuration = function(offHand)
		local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()

		if offHand then
			return hasOffHandEnchant and (offHandExpiration / 1000) or -1
		else
			return hasMainHandEnchant and (mainHandExpiration / 1000) or -1
		end
	end

	local getEnchantTooltip = function(enchant, secondaryEnchant)
		local tooltip

		if secondaryEnchant == enchant then
			tooltip = "Click to apply " .. enchant
		else
			tooltip = "Left-click to apply " .. enchant .. "\nRight-click to apply " .. secondaryEnchant
		end

		return tooltip
	end

	local hasValidWeapon = function(offHand)
		local quality = GetInventoryItemQuality("player", offHand and 17 or 16)
		return quality and quality > 1 and (not IsEquippedItemType("Shields"))
	end

	local mainHandIcon = getEnchantIcon(config.mainHandEnchant)
	local mainHandAttributes = {type = "spell", spell1 = config.mainHandEnchant, spell2 = config.mainHandSecondaryEnchant}
	local mainHandTooltip = getEnchantTooltip(config.mainHandEnchant, config.mainHandSecondaryEnchant)
	local offHandIcon = getEnchantIcon(config.offHandEnchant)
	local offHandAttributes = {type = "spell", spell1 = config.offHandEnchant, spell2 = config.offHandSecondaryEnchant}
	local offHandTooltip = getEnchantTooltip(config.offHandEnchant, config.offHandSecondaryEnchant)

	evl_Reminders:AddReminder("Main-Hand weapon enchant expiring soon", function() return hasValidWeapon() and getEnchantDuration() > 0 and getEnchantDuration() <= (config.thresholdTime * 60) end, mainHandIcon, mainHandAttributes, mainHandTooltip)
	evl_Reminders:AddReminder("Off-Hand weapon enchant expiring soon", function() return hasValidWeapon(true) and getEnchantDuration(true) > 0 and getEnchantDuration(true) <= (config.thresholdTime * 60) end, offHandIcon, offHandAttributes, offHandTooltip)
	evl_Reminders:AddReminder("Main-hand weapon enchant missing", function() return hasValidWeapon() and getEnchantDuration() == -1 end, mainHandIcon, mainHandAttributes, mainHantTooltip, {1, 0.1, 0.1})
	evl_Reminders:AddReminder("Off-hand weapon enchant missing", function() return hasValidWeapon(true) and getEnchantDuration(true) == -1 end, offHandIcon, offHandAttributes, offHantTooltip, {1, 0.1, 0.1})
end
