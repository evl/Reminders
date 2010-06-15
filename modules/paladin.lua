local config = evl_Reminders.config.paladin

if config.enabled and select(2, UnitClass("player")) == "PALADIN" then
	evl_Reminders:AddReminder("No active aura", function() return not UnitIsDeadOrGhost("player") and not evl_Reminders:PlayerHasAnyAura(config.auras, "PLAYER|HELPFUL") end, "Spell_Holy_DevotionAura", {type = "spell", unit = "player", spell1 = config.auras[1], spell2 = config.auras[2]})
	evl_Reminders:AddReminder("No active seal", function() return not evl_Reminders:PlayerHasAnyAura(config.seals, "PLAYER|HELPFUL") end, "Spell_Holy_SealOfVengeance", {type = "spell", unit = "player", spell1 = config.seals[1], spell2 = config.seals[2]})
	evl_Reminders:AddReminder("Missing blessing", function() return not evl_Reminders:PlayerHasAnyAura(config.blessings, "PLAYER|HELPFUL") end, "Spell_Holy_GreaterBlessingOfKings", {type = "spell", unit = "player", spell1 = config.blessings[1], spell2 = config.blessings[2]})
	
	if config.righteousFury then
		evl_Reminders:AddReminder("Missing Righteous Fury", function() return evl_Reminders:PlayerInPVEInstance() and not evl_Reminders:PlayerHasBuff("Righteous Fury") end, "Spell_Holy_SealOfFury", {type = "spell", unit = "player", spell = "Righteous Fury"})
	end
end