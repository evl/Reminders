local addonName, addon = ...
local config = addon.config.druid

if config.enabled and addon.playerClass == "DRUID" then
	addon:AddReminder("Missing Mark of the Wild", function() return not addon:HasAnyAura({"Mark of the Wild", "Blessing of Kings"}) end, {type = "spell", unit = "player", spell = "Mark of the Wild"})
end