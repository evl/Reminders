local addonName, addon = ...
local config = addon.config.druid

if config.enabled and addon.playerClass == "DRUID" then	
	addon:AddReminder("Missing Mark of the Wild", function() return not addon:PlayerHasAnyAura({"Mark of the Wild", "Gift of the Wild"}) end, "Spell_Nature_Regeneration", {type = "spell", unit = "player", spell1 = "Mark of the Wild", spell2 = "Gift of the Wild"})
	addon:AddReminder("Missing Thorns", function() return not addon:PlayerHasBuff("Thorns") end, "Spell_Nature_Thorns", {type = "spell", spell = "Thorns", unit = "player"})
end