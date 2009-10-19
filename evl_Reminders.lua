evl_Reminders = CreateFrame("Frame", "EvlReminders", UIParent)

local UPDATE_INTERVAL = 0.5
local ICON_PATH = "Interface\\Icons\\"
local DEFAULT_ICON = "Temp"

local lastUpdate = 0
local reminders = {}
local menuFrame = CreateFrame("Frame", "evl_RemindersMenu", UIParent, "UIDropDownMenuTemplate")
local menu = {}

local supressReminder = function(self, reminder)
	reminder.active = false
	reminder.reactivateTime = GetTime() + 300
end

local disableReminder = function(self, reminder)
	reminder.active = false
end

local onUpdate = function(self, elapsed)
	if InCombatLockdown() then return end

	lastUpdate = lastUpdate + elapsed

	if lastUpdate > UPDATE_INTERVAL then
		lastUpdate = 0

		for _, reminder in ipairs(reminders) do
			if not reminder.active and (reminder.reactivateTime > 0 and GetTime() >= reminder.reactivateTime) then
				reminder.active = true
				reminder.reactivateTime = 0
			end

			local result = reminder.active and reminder.callback()

			if result then
				reminder:Show()
			else
				reminder:Hide()
			end
		end

		self:UpdatePositions()
	end
end

local onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetWidth(250)
	GameTooltip:AddLine(self.name)

	if self.tooltip then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(self.tooltip)
	else
		local left = self:GetAttribute("item1")
		if left then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Left-click to use " .. left)
		else
			left = self:GetAttribute("spell1")
			if left then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine("Left-click to cast " .. left)
			end
		end

		local right = self:GetAttribute("item2")
		if right then
			if not left then
				GameTooltip:AddLine(" ")
			end

			GameTooltip:AddLine("Right-click to use " .. right)
		else
			right = self:GetAttribute("spell2")
			if right then
				if not left then
					GameTooltip:AddLine(" ")
				end

				GameTooltip:AddLine("Right-click to cast " .. right)
			end
		end
	end

	GameTooltip:Show()
end

local onLeave = function(self)
	GameTooltip:Hide()
end

local onClick = function(self)
	menu = {
		{text = self.name, isTitle = true},
		{text = "Supress for 5 minutes", func = supressReminder, arg1 = self},
		{text = "Disable for this session", func = disableReminder, arg1 = self}
	}

	EasyMenu(menu, menuFrame, "cursor", nil, nil, "MENU")
end


-- Utility functions
function evl_Reminders:IsInPartyWith(class)
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

function evl_Reminders:IsBigWigsModuleActive(name)
	local bw = _G.BigWigs

	return bw and bw:IsModuleActive(name)
end

function evl_Reminders:PlayerHasBuff(name)
	for i = 1, 32 do
		local buffName = UnitBuff("player", i)

		if not buffName then
			break
		elseif buffName == name then
			return true
		end
	end

	return false
end

function evl_Reminders:AddReminder(name, callback, icon, attributes, tooltip, color)
	local buttonName = "ReminderButton" .. #reminders
	local frame = CreateFrame("Button", buttonName, self, "SecureActionButtonTemplate, ActionButtonTemplate")

	frame.name = name
	frame.callback = callback
	frame.attributes = attributes
	frame.tooltip = tooltip
	frame.active = true
	frame.reactivateTime = 0

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(frame)
	texture:SetTexture(ICON_PATH .. (icon or DEFAULT_ICON))
	texture:SetTexCoord(.07, .93, .07, .93)
	
	if color then
		texture:SetVertexColor(color[1], color[2], color[3])
	end

	_G[frame:GetName() .. "Icon"]:SetTexture(texture)

	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnEnter", onEnter)
	frame:SetScript("OnLeave", onLeave)

	if attributes then
		for key, value in pairs(attributes) do
			frame:SetAttribute(key, value)
		end
	end

	frame:SetAttribute("alt-type*", "showmenu")
	frame.showmenu = onClick

	table.insert(reminders, frame)
	return frame
end

function evl_Reminders:UpdatePositions()
	local previousReminder = nil

	for _, reminder in ipairs(reminders) do
		if reminder:IsVisible() then
			reminder:ClearAllPoints()

			if previousReminder then
				reminder:SetPoint("LEFT", previousReminder, "RIGHT", 5, 0)
			else
				reminder:SetPoint("TOPLEFT", self)
			end

			previousReminder = reminder
		end
	end
end

evl_Reminders:SetWidth(36)
evl_Reminders:SetHeight(36)
evl_Reminders:SetPoint("CENTER", UIParent, 300, 0)
evl_Reminders:SetScript("OnUpdate", onUpdate)