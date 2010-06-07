local config = evl_Reminders.config.druid

if config.enabled and select(2, UnitClass("player")) == "DRUID" then	
	evl_Reminders:AddReminder("Missing Mark of the Wild", function() return not evl_Reminders:PlayerHasAnyAura({"Mark of the Wild", "Gift of the Wild"}) end, "Spell_Nature_Regeneration", {type = "spell", unit = "player", spell1 = "Mark of the Wild", spell2 = "Gift of the Wild"})
	evl_Reminders:AddReminder("Missing Thorns", function() return not evl_Reminders:PlayerHasBuff("Thorns") end, "Spell_Nature_Thorns", {type = "spell", spell = "Thorns", unit = "player"})
end