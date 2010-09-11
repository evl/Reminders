local addonName, addon = ...
local config = addon.config.rogue

if config.enabled and addon.playerClass == "ROGUE" then
	-- Poisons
	local poisons = {
		["Anesthetic Poison"] = {
			icon = "Spell_Nature_SlowPoison",
			ranks = {
				{level = 68, itemId = 21835},
				{level = 7, itemId = 43237}
			}
		},

		["Crippling Poison"] = {
			icon = "Ability_PoisonSting",
			ranks = {
				{level = 20, itemId = 3775}
			}
		},

		["Deadly Poison"] = {
			icon = "Ability_Rogue_DualWeild",
			ranks = {
				{level = 30, itemId = 2892},
				{level = 38, itemId = 2893},
				{level = 46, itemId = 8984},
				{level = 54, itemId = 8985},
				{level = 60, itemId = 20844},
				{level = 62, itemId = 22053},
				{level = 70, itemId = 22054},
				{level = 76, itemId = 43232},
				{level = 80, itemId = 43233}
			}
		},

		["Instant Poison"] = {
			icon = "Ability_Poisons",
			ranks = {
				{level = 20, itemId = 6947},
				{level = 28, itemId = 6949},
				{level = 36, itemId = 6950},
				{level = 44, itemId = 8926},
				{level = 52, itemId = 8927},
				{level = 60, itemId = 8928},
				{level = 68, itemId = 21927},
				{level = 73, itemId = 43230},
				{level = 79, itemId = 43231}
			}
		},

		["Mind-numbing Poison"] = {
			icon = "Spell_Nature_NullifyDisease",
			ranks = {
				{level = 24, itemId = 5237}
			}
		},

		["Wound Poison"] = {
			icon = "INV_Misc_Herb_16",
			ranks = {
				{level = 32, itemId = 10918},
				{level = 40, itemId = 10920},
				{level = 48, itemId = 10921},
				{level = 56, itemId = 10922},
				{level = 64, itemId = 22055},
				{level = 72, itemId = 43234},
				{level = 78, itemId = 43235}
			}
		}
	}

	local getPoisonItemString = function(poison)
		local poisonData = poisons[poison]

		if poisonData then
			local level = UnitLevel("player")
			local itemId

			for _, rank in ipairs(poisonData.ranks) do
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

	local getPoisonIcon = function(poison)
		local poisonData = poisons[poison]

		if poisonData then
			return poisonData.icon
		end
	end

	local getPoisonTooltip = function(poison, secondaryPoison)
		local tooltip

		if secondaryPoison == poison then
			tooltip = "Click to apply " .. poison
		else
			tooltip = "Left-click to apply " .. poison .. "\nRight-click to apply " .. secondaryPoison
		end

		return tooltip
	end
	
	local onEvent = function(self, event, unit)
		if not (event == "UNIT_INVENTORY_CHANGED" and unit ~= "player") then
			local slot = self:GetAttribute("target-slot")
			local hasEnchant, expiration = select(slot == 16 and 1 or 4, GetWeaponEnchantInfo())
			
			if hasEnchant then
				local timeLeft = expiration / 1000
				
				if timeLeft < config.thresholdTime * 60 then
					self.title = self.name .." expiring in " .. SecondsToTime(timeLeft, nil, true):lower()
					self.setColor(1, 1, 1)
					
					return true
				end
			else
				local validWeapon = addon:HasEnchantableWeapon(slot)
				
				-- If we just lost or applied an enchant we need to poll the weapon enchant info for a while until we're sure it's changed
				if event == "UNIT_INVENTORY_CHANGED" and validWeapon then
					local poller = self.poller or addon:CreatePoller(self, 2)
					poller.elapsed = 0
				end
				
				if validWeapon then
					self.title = self.name .." missing"
					self.setColor(1, 0.1, 0.1)
					
					return true
				end
			end
		end
	end
		
	local mainHandIcon, offHandIcon = getPoisonIcon(config.mainHandPoisons[1]), getPoisonIcon(config.offHandPoisons[1])
	local mainHandTooltip, offHandTooltip = getPoisonTooltip(config.mainHandPoisons[1], config.mainHandPoisons[2]), getPoisonTooltip(config.offHandPoisons[1], config.offHandPoisons[2])
	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = getPoisonItemString(config.mainHandPoisons[1]), item2 = getPoisonItemString(config.mainHandPoisons[2])}
	local offHandAttributes = {type = "item", ["target-slot"] = 17, item1 = getPoisonItemString(config.offHandPoisons[1]), item2 = getPoisonItemString(config.offHandPoisons[2])}

	addon:AddReminder("Main hand poison", "UNIT_INVENTORY_CHANGED", onEvent, mainHandIcon, nil, mainHandAttributes, mainHandTooltip)
	addon:AddReminder("Off hand poison", "UNIT_INVENTORY_CHANGED", onEvent, offHandIcon, nil, offHandAttributes, offHandTooltip)
end