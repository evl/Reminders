if select(2, UnitClass("player")) == "ROGUE" then
	local config = evl_Reminders.config.rogue

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
		local icon
		
		if poisonData then
			return poisonData.icon
		end
	end
	
	local getPoisonDuration = function(offHand)
		local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()
		
		if offHand then
			return hasOffHandEnchant and (offHandExpiration / 1000) or -1
		else
			return hasMainHandEnchant and (mainHandExpiration / 1000) or -1
		end
	end
	
	local hasValidWeapon = function(offHand)
		local quality = GetInventoryItemQuality("player", offHand and 17 or 16)
		return quality and quality > 1
	end
	
	local poisonTooltip = "Left-click to apply %s\nRight-click to apply %s"
	local mainHandIcon = getPoisonIcon(config.mainHandPoison)
	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = getPoisonItemString(config.mainHandPoison), item2 = getPoisonItemString(config.mainHandSecondaryPoison)}
	local mainHandTooltip = poisonTooltip:format(config.mainHandPoison, config.mainHandSecondaryPoison)
	local offHandIcon = getPoisonIcon(config.offHandPoison)
	local offHandAttributes = {type = "item", ["target-slot"] = 17, item1 = getPoisonItemString(config.offHandPoison), item2 = getPoisonItemString(config.offHandSecondaryPoison)}
	local offHandTooltip = poisonTooltip:format(config.offHandPoison, config.offHandSecondaryPoison)
	
	evl_Reminders:AddReminder("Main-hand poison expiring soon", function() return hasValidWeapon() and getPoisonDuration() > 0 and getPoisonDuration() <= (config.thresholdTime * 60) end, mainHandIcon, mainHandAttributes, mainHandTooltip)
	evl_Reminders:AddReminder("Off-hand poison expiring soon", function() return hasValidWeapon(true) and getPoisonDuration(true) > 0 and getPoisonDuration(true) <= (config.thresholdTime * 60) end, offHandIcon, offHandAttributes, offHandTooltip)
	evl_Reminders:AddReminder("Main-hand poison missing", function() return hasValidWeapon() and getPoisonDuration() == -1 end, mainHandIcon, mainHandAttributes, mainHandTooltip, {1, 0.1, 0.1})
	evl_Reminders:AddReminder("Off-hand poison missing", function() return hasValidWeapon(true) and getPoisonDuration(true) == -1 end, offHandIcon, offHandAttributes, offHandTooltip, {1, 0.1, 0.1})
end