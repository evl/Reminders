local addonName, addon = ...
local config = addon.config.shaman

if config.enabled and addon.playerClass == "SHAMAN" then	
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
		if offHand and IsEquippedItemType("Shields") then
			return false
		end

		local quality = GetInventoryItemQuality("player", offHand and 17 or 16)
		return quality and quality > 1
	end

	local mainHandIcon = getEnchantIcon(config.mainHandEnchants[1])
	local mainHandAttributes = {type = "spell", spell1 = config.mainHandEnchants[1], spell2 = config.mainHandEnchants[2]}
	local mainHandTooltip = getEnchantTooltip(config.mainHandEnchants[1], config.mainHandEnchants[2])
	local offHandIcon = getEnchantIcon(config.offHandEnchants[1])
	local offHandAttributes = {type = "spell", spell1 = config.offHandEnchants[1], spell2 = config.offHandEnchants[2]}
	local offHandTooltip = getEnchantTooltip(config.offHandEnchants[1], config.offHandEnchants[2])

	addon:AddReminder("Missing Shield", function() return not addon:PlayerHasAnyAura(config.shields) end, "Ability_Shaman_WaterShield", {type = "spell", unit = "player", spell1 = config.shields[1], spell2 = config.shields[2]})
	addon:AddReminder("Main-Hand weapon enchant expiring soon", function() return hasValidWeapon() and getEnchantDuration() > 0 and getEnchantDuration() <= (config.thresholdTime * 60) end, mainHandIcon, mainHandAttributes, mainHandTooltip)
	addon:AddReminder("Main-hand weapon enchant missing", function() return hasValidWeapon() and getEnchantDuration() == -1 end, mainHandIcon, mainHandAttributes, mainHantTooltip, {1, 0.1, 0.1})
	addon:AddReminder("Off-Hand weapon enchant expiring soon", function() return hasValidWeapon(true) and getEnchantDuration(true) > 0 and getEnchantDuration(true) <= (config.thresholdTime * 60) end, offHandIcon, offHandAttributes, offHandTooltip)
	addon:AddReminder("Off-hand weapon enchant missing", function() return hasValidWeapon(true) and getEnchantDuration(true) == -1 end, offHandIcon, offHandAttributes, offHantTooltip, {1, 0.1, 0.1})
end
