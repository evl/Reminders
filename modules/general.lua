local addonName, addon = ...
local config = addon.config.general

if config.enabled then
	-- Bag slots
	addon:AddReminder("Bag space", "BAG_UPDATE", function(self)
		local slots = MainMenuBarBackpackButton.freeSlots

		if slots < 3 then
			if slots == 0 then
				self.title = "No bag-slots available"
				self.setColor(1, 0.1, 0.1)
			else
				self.title = "Less than 3 bag-slots available"
				self.setColor(1, 1, 1)
			end

			return true
		end
	end, "inv_misc_bag_13")
end