local addonName, addon = ...
local config = addon.config.inventory

if config.enabled then
	-- Bag slots
	addon:AddReminder("Bag space", function(self)
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
	end, nil, "inv_misc_bag_13", nil, nil, true)
	
	-- Repair
	local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand", "Ranged"}
	local slotIds = {}

	for _, slot in pairs(slots) do 
		slotIds[slot] = GetInventorySlotInfo(slot .. "Slot")
	end
	
	local repairReminder = addon:AddReminder("Equipment damaged", function(self)
		local minDurability = 1

		for _, id in pairs(slotIds) do
			local durability, maxDurability = GetInventoryItemDurability(id)

			if durability then
				minDurability = math.min(durability / maxDurability, minDurability)
			end
		end
		
		if minDurability < config.repairThreshold / 100 then
			local r, g, b = addon:ConditionColorGradient(minDurability)
			self.setColor(r, g, b)

			return true
		end
	end, nil, "ability_repair", nil, nil, true)
	
	local round = function(value) return floor(value + 0.5) end
	repairReminder:SetScript("OnEnter", function(self)
		addon:PrepareReminderTooltip(self)
		
		GameTooltip:AddLine(" ")

		for _, id in pairs(slotIds) do
			local durability, maxDurability = GetInventoryItemDurability(id)

			if durability then
				local percent = durability / maxDurability
				
				if percent < config.repairThreshold / 100 then
					local link = GetInventoryItemLink("player", id)
					local name, _, quality = GetItemInfo(link)
					local qualityColor = ITEM_QUALITY_COLORS[quality]
					local icon = GetItemIcon(link)
					local r, g, b = addon:ConditionColorGradient(percent)
				
					GameTooltip:AddDoubleLine(name, math.floor((percent * 100) + 0.5) .. "%", qualityColor.r, qualityColor.g, qualityColor.b, r, g, b)
					GameTooltip:AddTexture(icon)
				end
			end
		end

		GameTooltip:Show()
	end)
end