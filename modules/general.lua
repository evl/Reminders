local addonName, addon = ...
local config = addon.config.general

if config.enabled then
	-- Bag slots
	addon:AddReminder("Less than 3 bag-slots available", function() return MainMenuBarBackpackButton.freeSlots < 3 and MainMenuBarBackpackButton.freeSlots > 0 end, "INV_Misc_Bag_19")
	addon:AddReminder("No bag-slots available", function() return MainMenuBarBackpackButton.freeSlots == 0 end, "INV_Misc_Bag_19", nil, nil, {1, 0.1, 0.1})
end