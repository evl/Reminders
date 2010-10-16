local addonName, addon = ...
local config = addon.config.paladin

if config.enabled and addon.playerClass == "PALADIN" then
	addon:AddReminder("No active aura", function() return not addon:HasAnyAura(config.auras, "PLAYER") end, {type = "spell", spell1 = config.auras[1], spell2 = config.auras[2]})
	addon:AddReminder("No active seal", function() return not addon:HasAnyAura(config.seals, "PLAYER") end, {type = "spell", spell1 = config.seals[1], spell2 = config.seals[2]})
	addon:AddReminder("Missing blessing", function() return not addon:HasAnyAura(config.blessings, "PLAYER") end, {type = "spell", unit = "player", spell1 = config.blessings[1], spell2 = config.blessings[2]})
	
	if config.righteousFury and (addon:HasTalentRank(2, 26) or UnitLevel("player") < 80) then
		addon:AddReminder("Missing Righteous Fury", function() return addon:InPVEInstance() and not UnitAura("player", "Righteous Fury") end, {type = "spell", spell = "Righteous Fury"})
	end
	
	addon:AddReminder("Crusader Aura active", function() return not IsMounted() and UnitAura("player", "Crusader Aura", nil, "PLAYER") end, {type = "spell", spell1 = config.auras[1], spell2 = config.auras[2]}, "spell_holy_crusaderaura")
end