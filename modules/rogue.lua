local addonName, addon = ...
local config = addon.config.rogue

if config.enabled and addon.playerClass == "ROGUE" then
	-- Poisons
	local poisons = {
		["Anesthetic Poison"] = {
			{level = 68, itemId = 21835},
			{level = 77, itemId = 43237}
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

	addon:AddReminder("Main hand poison", addon.WeaponEnchantCallback, mainHandAttributes, nil, nil, mainHandTooltip)
	addon:AddReminder("Off hand poison", addon.WeaponEnchantCallback, offHandAttributes, nil, nil, offHandTooltip)
	
	function addon:GetMerchantItems()
		local count = GetMerchantNumItems()
		
		if count > 0 then
			local result = {}
		
			for i = 1, count do
				local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(i)
				result[name] = i
			end

			return result
		end
	end
	
	function addon:MerchantHasItem(name)
		local count = GetMerchantNumItems()
		
		if count > 0 then
			for i = 1, count do
				local name, _, _, quantity = GetMerchantItemInfo(i)
				
				if name and quantity > 0 then
					return true
				end
			end
		end
	end
	
	local poisonItems = {}
	
	for _, slot in pairs({config.mainHandPoisons, config.offHandPoisons}) do
		for _, name in pairs(slot) do
			poisonItems[name] = getPoisonItemString(name)
		end
	end
	
	local checkPoisonStock = function(self)
		for _, itemString in pairs(poisonItems) do
			if (GetItemCount(itemString) < config.restockThreshold) then
				return true
			end
		end
	end
	
	local restockPoisons = function(self)
		local merchantItems = addon:GetMerchantItems()
		
		if merchantItems then
			for name, itemString in pairs(poisonItems) do
				local item = GetItemInfo(itemString)
				local merchantIndex = merchantItems[item]
				
				if merchantIndex then
					local count = GetItemCount(itemString)
					local maxStack = GetMerchantItemMaxStack(merchantIndex)
					
					while count < config.restockAmount do
						local buyCount = math.min(maxStack, config.restockAmount - count)
						
						if addon.debug then
							print("Buying", item, "x", buyCount, "count:", count)
						end
						
						BuyMerchantItem(merchantIndex, buyCount)
						
						count = count + buyCount
					end
				end
			end
		else
			UIErrorsFrame:AddMessage("Invalid poison vendor.", 1.0, 0.1, 0.1)
		end
	end
	
	local poisonStockReminder = addon:AddReminder("Poison stock low", checkPoisonStock, {type = "handler", _handler = restockPoisons}, "trade_brewpoison", nil, "Click to restock poisons", 2)
	poisonStockReminder:SetScript("OnEnter", function(self)
		addon:PrepareReminderTooltip(self)
		
		GameTooltip:AddLine(" ")
		
		local validMerchant
		
		for name, itemString in pairs(poisonItems) do
			local item, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemString)
			local count = GetItemCount(itemString)
			local r, g, b = addon:ConditionColorGradient(math.max(1, count / config.restockThreshold))
			
			GameTooltip:AddDoubleLine(item, count, 1, 1, 1, r, g, b)
			GameTooltip:AddTexture(texture)
			
			-- Check if we are at a merchant selling our preferred poisons
			if not validMerchant then
				validMerchant = addon:MerchantHasItem(item)
			end
		end
		
		if validMerchant then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(self.tooltip)
		end
		
		GameTooltip:Show()
	end)
end