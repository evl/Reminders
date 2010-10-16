local addonName, addon = ...
local config = addon.config.priest

if config.enabled and addon.playerClass == "PRIEST" then
	addon:AddReminder("Missing Power Word: Fortitude", function() return not addon:PlayerHasAnyAura({"Power Word: Fortitude", "Prayer of Fortitude"}) end, {type = "spell", unit = "player", spell1 = "Power Word: Fortitude", spell2 = "Prayer of Fortitude"})
	addon:AddReminder("Missing Divine Spirit", function() return not addon:PlayerHasAnyAura({"Divine Spirit", "Prayer of Spirit"}) end, {type = "spell", unit = "player", spell1 = "Divine Spirit", spell2 = "Prayer of Spirit"})
	addon:AddReminder("Missing Inner Fire", function() return not addon:PlayerHasBuff("Inner Fire") end, {type = "spell", spell = "Inner Fire"})
	
	-- Shadow
	if addon:HasTalentRank(3, 14) then
		addon:AddReminder("Missing Vampiric Embrace", function() return not addon:PlayerHasBuff("Vampiric Embrace") end, {type = "spell", spell = "Vampiric Embrace"})
	end
end