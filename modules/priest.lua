local config = evl_Reminders.config.priest

if config.enabled and select(2, UnitClass("player")) == "PRIEST" then	
	evl_Reminders:AddReminder("Missing Power Word: Fortitude", function() return not evl_Reminders:PlayerHasAnyAura({"Power Word: Fortitude", "Prayer of Fortitude"}) end, "Spell_Holy_WordFortitude", {type = "spell", unit = "player", spell1 = "Power Word: Fortitude", spell2 = "Prayer of Fortitude"})
	evl_Reminders:AddReminder("Missing Divine Spirit", function() return not evl_Reminders:PlayerHasAnyAura({"Divine Spirit", "Prayer of Spirit"}) end, "Spell_Holy_DivineSpirit", {type = "spell", unit = "player", spell1 = "Divine Spirit", spell2 = "Prayer of Spirit"})
	evl_Reminders:AddReminder("Missing Inner Fire", function() return not evl_Reminders:PlayerHasBuff("Inner Fire") end, "Spell_Holy_InnerFire", {type = "spell", spell = "Inner Fire", unit = "player"})
end