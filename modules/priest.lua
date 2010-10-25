local addonName, addon = ...
local config = addon.config.priest

if config.enabled and addon.playerClass == "PRIEST" then
	addon:AddReminder("Missing Power Word: Fortitude", function() return not addon:PlayerHasAnyAura({"Power Word: Fortitude", "Blood Pact"}) end, {type = "spell", unit = "player", spell = "Power Word: Fortitude"})
	addon:AddReminder("Missing Inner Fire", function() return not addon:PlayerHasBuff("Inner Fire") end, {type = "spell", spell = "Inner Fire"})
	
	-- Shadow
	if addon:HasTalentRank(3, 12) then
		addon:AddReminder("Missing Vampiric Embrace", function() return not addon:PlayerHasBuff("Vampiric Embrace") end, {type = "spell", spell = "Vampiric Embrace"})
	end
end