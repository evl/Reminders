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

function addon:HasEnchantableWeapon(slot)
	local link = GetInventoryItemLink("player", slot)
	
	if link then
		local equipSlot = _G[select(9, GetItemInfo(link))]

		return equipSlot == INVTYPE_WEAPON or equipSlot == (slot == 16 and INVTYPE_WEAPONMAINHAND or INVTYPE_WEAPONOFFHAND)
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