if select(2, UnitClass("player")) == "DRUID" then	
	evl_Reminders:AddReminder("Missing Mark of the Wild", "UNIT_AURA", function() return not evl_Reminders:PlayerHasBuff("Mark of the Wild") and not evl_Reminders:PlayerHasBuff("Gift of the Wild") end, "Spell_Nature_Regeneration", {type = "spell", unit = "player", spell1 = "Mark of the Wild", spell2 = "Gift of the Wild"})
	evl_Reminders:AddReminder("Missing Thorns", "UNIT_AURA", function() return not evl_Reminders:PlayerHasBuff("Thorns") end, "Spell_Nature_Thorns", {type1 = "spell", spell1 = "Thorns", unit1 = "player"})
end