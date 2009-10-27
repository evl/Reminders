if select(2, UnitClass("player")) == "MAGE" then	
	evl_Reminders:AddReminder("Armor missing", "UNIT_AURA", function() return not evl_Reminders:PlayerHasBuff("Molten Armor") and not evl_Reminders:PlayerHasBuff("Mage Armor") end, "Ability_Mage_MoltenArmor", {type = "spell", spell1 = "Molten Armor",spell2 = "Mage Armor", unit = "player"})

	-- TODO: Needs to be fixed so it works with all levels of mana gems, please submit a patch!
	--evl_Reminders:AddReminder("Less than 3 Mana Gems remaining", "UNIT_INVENTORY_CHANGED", function() return GetItemCount("Mana Sapphire", false, true) < 3 end, "INV_Misc_Gem_Sapphire_02",  {type1 = "spell", spell1 = "Conjure Mana Gem"})
end