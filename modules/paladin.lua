local addonName, addon = ...
local config = addon.config.paladin

if config.enabled and addon.playerClass == "PALADIN" then
	addon:AddReminder("No active aura", "UNIT_AURA", function() return not addon:HasAnyAura(config.auras, "PLAYER|HELPFUL") end, nil, nil, {type = "spell", unit = "player", spell1 = config.auras[1], spell2 = config.auras[2]})
	addon:AddReminder("No active seal", "UNIT_AURA", function() return not addon:HasAnyAura(config.seals, "PLAYER|HELPFUL") end, nil, nil, {type = "spell", unit = "player", spell1 = config.seals[1], spell2 = config.seals[2]})
	addon:AddReminder("Missing blessing", "UNIT_AURA", function() return not addon:HasAnyAura(config.blessings, "PLAYER|HELPFUL") end, nil, nil, {type = "spell", unit = "player", spell1 = config.blessings[1], spell2 = config.blessings[2]})
	
	if config.righteousFury then
		addon:AddReminder("Missing Righteous Fury", "UNIT_AURA", function() return addon:InPVEInstance() and ((addon:HasTalent(2, 26) or UnitLevel("player") < 80) and not UnitAura("player", "Righteous Fury")) end, nil, nil, {type = "spell", unit = "player", spell = "Righteous Fury"})
		addon:AddReminder("Crusader Aura active", "UNIT_AURA", function() return not IsMounted() and UnitAura("player", "Crusader Aura") end, "spell_holy_crusaderaura", nil, {type = "spell", unit = "player", spell1 = config.auras[1], spell2 = config.auras[2]})
	end
end