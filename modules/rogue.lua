local addonName, addon = ...
local config = addon.config.rogue

if config.enabled and addon.playerClass == "ROGUE" then
	local mainHandTooltip, offHandTooltip, throwingTooltip = addon:GetWeaponEnchantTooltip(config.mainHandPoisons[1], config.mainHandPoisons[2]), addon:GetWeaponEnchantTooltip(config.offHandPoisons[1], config.offHandPoisons[2]), addon:GetWeaponEnchantTooltip(config.throwingPoisons[1], config.throwingPoisons[2])
	local mainHandAttributes = {type = "item", ["target-slot"] = 16, item1 = config.mainHandPoisons[1], item2 = config.mainHandPoisons[2], threshold = config.thresholdTime}
	local offHandAttributes = {type = "item", ["target-slot"] = 17, item1 = config.offHandPoisons[1], item2 = config.offHandPoisons[2], threshold = config.thresholdTime}
	local throwingAttributes = {type = "item", ["target-slot"] = 18, item1 = config.throwingPoisons[1], item2 = config.throwingPoisons[2], threshold = config.thresholdTime}

	addon:AddReminder("Main hand poison", addon.WeaponEnchantCallback, mainHandAttributes, nil, nil, mainHandTooltip)
	addon:AddReminder("Off hand poison", addon.WeaponEnchantCallback, offHandAttributes, nil, nil, offHandTooltip)
	addon:AddReminder("Throwing weapon poison", addon.WeaponEnchantCallback, throwingAttributes, nil, nil, throwingTooltip)
	
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
	
	for _, slot in pairs({config.mainHandPoisons, config.offHandPoisons, config.throwingPoisons}) do
		for _, name in pairs(slot) do
			poisonItems[name] = true
		end
	end
	
	local checkPoisonStock = function(self)
		for name in pairs(poisonItems) do
			if (GetItemCount(name) < config.restockThreshold) then
				return true
			end
		end
	end
	
	local restockPoisons = function(self)
		local merchantItems = addon:GetMerchantItems()
		
		if merchantItems then
			for name in pairs(poisonItems) do
				local merchantIndex = merchantItems[name]
				
				if merchantIndex then
					local count = GetItemCount(name)
					local maxStack = GetMerchantItemMaxStack(merchantIndex)
					
					while count < config.restockAmount do
						local buyCount = math.min(maxStack, config.restockAmount - count)
						
						if addon.debug then
							print("Buying", name, "x", buyCount, "count:", count)
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
		
		for name in pairs(poisonItems) do
			local texture = select(10, GetItemInfo(name))
			local count = GetItemCount(name)
			local r, g, b = addon:ConditionColorGradient(math.max(1, count / config.restockThreshold))
			
			GameTooltip:AddDoubleLine(name, count, 1, 1, 1, r, g, b)
			GameTooltip:AddTexture(texture)
			
			-- Check if we are at a merchant selling our preferred poisons
			if not validMerchant then
				validMerchant = addon:MerchantHasItem(name)
			end
		end
		
		if validMerchant then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(self.tooltip)
		end
		
		GameTooltip:Show()
	end)
end