local config = evl_Reminders.config.mage

if config.enabled and select(2, UnitClass("player")) == "MAGE" then	
	local manaGems = {
		["Rank 1"] = "Mana Agate",
		["Rank 2"] = "Mana Jade",
		["Rank 3"] = "Mana Citrine",
		["Rank 4"] = "Mana Ruby",
		["Rank 5"] = "Mana Emerald",
		["Rank 6"] = "Mana Sapphire",
	}
	
	local hasManaGem = function()
		local _, rank = GetSpellInfo("Conjure Mana Gem")
		local gem = manaGems[rank]
		
		if gem then
			return GetItemCount(gem, false, true) == 3
		end
	end
	
	evl_Reminders:AddReminder("Missing Armor", function() return not evl_Reminders:PlayerHasAnyAura(config.armors) end, "Ability_Mage_MoltenArmor", {type = "spell", unit = "player", spell1 = config.armors[1], spell2 = config.armors[2]})
	evl_Reminders:AddReminder("Less than 3 Mana Gems remaining", function() return not hasManaGem() end, "INV_Misc_Gem_Sapphire_02",  {type = "spell", spell = "Conjure Mana Gem"})
end