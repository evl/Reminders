local config = evl_Reminders.config.general

if config.enabled then
	-- Bag slots
	evl_Reminders:AddReminder("Less than 3 bag-slots available", function() return MainMenuBarBackpackButton.freeSlots < 3 and MainMenuBarBackpackButton.freeSlots > 0 end, "INV_Misc_Bag_19")
	evl_Reminders:AddReminder("No bag-slots available", function() return MainMenuBarBackpackButton.freeSlots == 0 end, "INV_Misc_Bag_19", nil, nil, {1, 0.1, 0.1})
end