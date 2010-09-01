local addonName, addon = ...
local config = addon.config.priest

if config.enabled and addon.playerClass == "PRIEST" then
	addon:AddReminder("Missing Power Word: Fortitude", function() return not addon:PlayerHasAnyAura({"Power Word: Fortitude", "Prayer of Fortitude"}) end, "Spell_Holy_WordFortitude", {type = "spell", unit = "player", spell1 = "Power Word: Fortitude", spell2 = "Prayer of Fortitude"})
	addon:AddReminder("Missing Divine Spirit", function() return not addon:PlayerHasAnyAura({"Divine Spirit", "Prayer of Spirit"}) end, "Spell_Holy_DivineSpirit", {type = "spell", unit = "player", spell1 = "Divine Spirit", spell2 = "Prayer of Spirit"})
	addon:AddReminder("Missing Inner Fire", function() return not addon:PlayerHasBuff("Inner Fire") end, "Spell_Holy_InnerFire", {type = "spell", spell = "Inner Fire", unit = "player"})
	
	-- Shadow
	addon:AddReminder("Missing Vampiric Embrace", function() return addon:HasTalent(3, 14) and not addon:PlayerHasBuff("Vampiric Embrace") end, "Spell_Shadow_UnsummonBuilding", {type = "spell", spell = "Vampiric Embrace", unit = "player"})
end