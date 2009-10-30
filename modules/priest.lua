if select(2, UnitClass("player")) == "PRIEST" then	
	evl_Reminders:AddReminder("Missing Power Word: Fortitude", function() return not evl_Reminders:PlayerHasBuff("Power Word: Fortitude") and not evl_Reminders:PlayerHasBuff("Prayer of Fortitude") end, "Spell_Holy_WordFortitude", {type = "spell", unit = "player", spell1 = "Power Word: Fortitude", spell2 = "Prayer of Fortitude"})
	evl_Reminders:AddReminder("Missing Inner Fire", function() return not evl_Reminders:PlayerHasBuff("Inner Fire") end, "Spell_Holy_InnerFire", {type1 = "spell", spell1 = "Inner Fire", unit1 = "player"})
end