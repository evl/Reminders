local addonName, addon = ...
local config = addon.config.mage

if config.enabled and addon.playerClass == "MAGE" then	
	local manaGems = {
		["Rank 1"] = "Mana Agate",
		["Rank 2"] = "Mana Jade",
		["Rank 3"] = "Mana Citrine",
		["Rank 4"] = "Mana Ruby",
		["Rank 5"] = "Mana Emerald",
		["Rank 6"] = "Mana Sapphire",
	}
	
	local missingManaGem = function(self)
		local name, rank, icon = GetSpellInfo("Conjure Mana Gem")
		
		if name then
			local gem = manaGems[rank]
		
			if gem and GetItemCount(gem, false, true) == 3 then
				self.setIcon(icon)
					
				return true
			end
		end
	end
	
	addon:AddReminder("Missing Armor", function() return not addon:HasAnyAura(config.armors) end, {type = "spell", spell1 = config.armors[1], spell2 = config.armors[2]})
	addon:AddReminder("Less than 3 Mana Gems remaining", function(self) return missingManaGem(self) end, {type = "spell", spell = "Conjure Mana Gem"})
end