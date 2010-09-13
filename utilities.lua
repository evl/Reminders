local addonName, addon = ...

function addon:IsInPartyWith(class)
	local numMembers = GetNumPartyMembers()

	if numMembers then
		for i = 1, numMembers do
			local unit = "party" .. i

			if not UnitIsPlayer("unit") and select(2, UnitClass(unit)) == class then
				return true
			end
		end
	end

	return false
end

function addon:HasAnyAura(names, filter)
	if not filter then
		filter = "HELPFUL"
	end

	for _, name in pairs(names) do
		if UnitAura("player", name, nil, filter) then
			return true
		end
	end
	
	return false
end

function addon:InPVEInstance()
	isInstance, instanceType = IsInInstance()
	
	if isInstance then
		return instanceType == "party" or instanceType == "raid"
	end
	
	return false
end

function addon:HasTalent(tabIndex, talentIndex, rankRequired)
	return select(5, GetTalentInfo(tabIndex, talentIndex)) >= (rankRequired or 1)
end

function addon:HasGlyph(id)
	for i = 1, 6 do
		local _, _, glyphSpell = GetGlyphSocketInfo(i)
		
		if glyphSpell == id then
			return true
		end
	end
	
	return false
end

local fishingPole = select(17, GetAuctionItemSubClasses(1))

function addon:HasEnchantableWeapon(slot)
	local link = GetInventoryItemLink("player", slot)
	
	if link then
		local subClass, _, equipSlot = _G[select(7, GetItemInfo(link))]
		
		return equipSlot == INVTYPE_WEAPON or equipSlot == (slot == 16 and INVTYPE_WEAPONMAINHAND or INVTYPE_WEAPONOFFHAND) or (equipSlot == INVTYPE_2HWEAPON and subClass ~= fishingPole)
	end
end

function addon:GetWeaponEnchantTooltip(primary, secondary)
	local tooltip

	if primary == secondary then
		tooltip = "Click to apply " .. primary
	else
		tooltip = "Left-click to apply " .. primary .. "\nRight-click to apply " .. secondary
	end

	return tooltip
end

function addon:WeaponEnchantEventHandler(event, unit)
	if not (event == "UNIT_INVENTORY_CHANGED" and unit ~= "player") then
		local slot = self:GetAttribute("target-slot")
		local hasEnchant, expiration = select(slot == 16 and 1 or 4, GetWeaponEnchantInfo())
		local validWeapon = addon:HasEnchantableWeapon(slot)
		
		if hasEnchant then
			local timeLeft = expiration / 1000
			local threshold = self:GetAttribute("threshold") * 60
			
			if timeLeft < threshold then
				self.title = self.name .." expiring in " .. SecondsToTime(timeLeft, nil, true):lower()
				self.setColor(1, 1, 1)
				
				return validWeapon
			end
		else
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
	
function addon:CreatePoller(reminder, duration)
	local poller = CreateFrame("Frame")
	poller.reminder = reminder
	poller.duration = duration
	poller:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed

		if self.elapsed < self.duration then
			addon:UpdateReminder(self.reminder, "UPDATE_POLL")
		end
	end)

	return poller
end

local infinity = math.huge

function addon:ColorGradient(value, ...)
	if value ~= value or value == infinity then
		value = 0
	end
	
	if value >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		
		return r, g, b
	elseif value <= 0 then
		local r, g, b = ...
		
		return r, g, b
	end
	
	local segmentCount = select('#', ...) / 3
	local segment, relativePercent = math.modf(value * (segmentCount - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3)+1, ...)
	
	return r1 + (r2 - r1) * relativePercent, g1 + (g2 - g1) * relativePercent, b1 + (b2 - b1) * relativePercent
end