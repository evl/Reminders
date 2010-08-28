local addonName, addon = ...
local config = addon.config.paladin

if config.enabled and addon.playerClass == "PALADIN" then
	addon:AddReminder("No active aura", function() return not UnitIsDeadOrGhost("player") and not addon:PlayerHasAnyAura(config.auras, "PLAYER|HELPFUL") end, "Spell_Holy_DevotionAura", {type = "spell", unit = "player", spell1 = config.auras[1], spell2 = config.auras[2]})
	addon:AddReminder("No active seal", function() return not addon:PlayerHasAnyAura(config.seals, "PLAYER|HELPFUL") end, "Spell_Holy_SealOfVengeance", {type = "spell", unit = "player", spell1 = config.seals[1], spell2 = config.seals[2]})
	addon:AddReminder("Missing blessing", function() return not addon:PlayerHasAnyAura(config.blessings, "PLAYER|HELPFUL") end, "Spell_Holy_GreaterBlessingOfKings", {type = "spell", unit = "player", spell1 = config.blessings[1], spell2 = config.blessings[2]})
	
	if config.righteousFury then
		addon:AddReminder("Missing Righteous Fury", function() return addon:PlayerInPVEInstance() and ((addon:HasTalent(2, 26) or UnitLevel("player") < 80) and not addon:PlayerHasBuff("Righteous Fury")) end, "Spell_Holy_SealOfFury", {type = "spell", unit = "player", spell = "Righteous Fury"})
	end
end