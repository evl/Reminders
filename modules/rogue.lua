local addonName, addon = ...
local config = addon.config.rogue

if config.enabled and addon.playerClass == "ROGUE" then
	-- Poisons
	local poisons = {
		["Anesthetic Poison"] = {
			{level = 68, itemId = 21835},
			{level = 7, itemId = 43237}
		},

		["Crippling Poison"] = {
			{level = 20, itemId = 3775}
		},

		["Deadly Poison"] = {
			{level = 30, itemId = 2892},
			{level = 38, itemId = 2893},
			{level = 46, itemId = 8984},
			{level = 54, itemId = 8985},
			{level = 60, itemId = 20844},
			{level = 62, itemId = 22053},
			{level = 70, itemId = 22054},
			{level = 76, itemId = 43232},
			{level = 80, itemId = 43233}
		},

		["Instant Poison"] = {
			{level = 20, itemId = 6947},
			{level = 28, itemId = 6949},
			{level = 36, itemId = 6950},
			{level = 44, itemId = 8926},
			{level = 52, itemId = 8927},
			{level = 60, itemId = 8928},
			{level = 68, itemId = 21927},
			{level = 73, itemId = 43230},
			{level = 79, itemId = 43231}
		},

		["Mind-numbing Poison"] = {
			{level = 24, itemId = 5237}
		},

		["Wound Poison"] = {
			{level = 32, itemId = 10918},
			{level = 40, itemId = 10920},
			{level = 48, itemId = 10921},
			{level = 56, itemId = 10922},
			{level = 64, itemId = 22055},
			{level = 72, itemId = 43234},
			{level = 78, itemId = 43235}
		}
	}

	local getPoisonItemString = function(poison)
		local poisonData = poisons[poison]

		if poisonData then
			local level = UnitLevel("player")
			local itemId

			for _, rank in ipairs(poisonData) do
				if level >= rank.level then
					itemId = rank.itemId
				else
					break
				end
			end

			if itemId then
				return "item:" .. itemId
			end
		end
	end
		
	local mainHandTooltip, offHandTooltip = addon:GetWeaponEnchantTooltip(config.mainHandPoisons[1], config.mainHandPoisons[2]), addon:GetWeaponEnchantTooltip(config.offHandPoisons[1], config.offHandPoisons[2])
	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = getPoisonItemString(config.mainHandPoisons[1]), item2 = getPoisonItemString(config.mainHandPoisons[2]), threshold = config.thresholdTime}
	local offHandAttributes = {type = "item", ["target-slot"] = 17, item1 = getPoisonItemString(config.offHandPoisons[1]), item2 = getPoisonItemString(config.offHandPoisons[2]), threshold = config.thresholdTime}

	addon:AddReminder("Main hand poison", "UNIT_INVENTORY_CHANGED", addon.WeaponEnchantEventHandler, mainHandAttributes, nil, nil, mainHandTooltip)
	addon:AddReminder("Off hand poison", "UNIT_INVENTORY_CHANGED", addon.WeaponEnchantEventHandler, offHandAttributes, nil, nil, offHandTooltip)
	
	local restockPoisons = function(self)
		
	end

	addon:AddReminder("Poison stock low", "UNIT_INVENTORY_CHANGED", function(self) end, {type = restockPoisons}, nil, nil, "Click to restock poisons")
end