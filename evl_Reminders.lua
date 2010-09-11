local addonName, addon = ...

addon.config = {
	scale = 1,
	position = {"CENTER", UIParent, "CENTER", 300, 0},
	
	consumables = {
		enabled = true,
		foodThresholdTime = 10,
		flaskThresholdTime = 5
	},
	
	druid = {
		enabled = true
	},
	
	general = {
		enabled = true
	},
	
	mage = {
		enabled = true,
		armors = {"Molten Armor", "Mage Armor"}
	},
	
	paladin = {
		enabled = true,
		auras = {"Devotion Aura", "Retribution Aura", "Crusader Aura", "Shadow Resistance Aura", "Frost Resistance Aura", "Fire Resistance Aura"},
		seals = {"Seal of Command", "Seal of Righteousness", "Seal of Justice", "Seal of Light", "Seal of Wisdom", "Seal of Corruption", "Seal of Vengeance"},
		blessings = {"Blessing of Might", "Greater Blessing of Might", "Blessing of Wisdom", "Greater Blessing of Wisdom", "Blessing of Kings", "Greater Blessing of Kings", "Blessing of Sanctuary"},
		righteousFury = true
	},

	priest = {
		enabled = true
	},
	
	rogue = {
		enabled = true,
		mainHandPoisons = {"Instant Poison", "Wound Poison"},
		offHandPoisons = {"Deadly Poison", "Mind-numbing Poison"},
		thresholdTime = 10
	},
	
	shaman = {
		enabled = true,
		shields = {"Water Shield", "Lightning Shield"},
		mainHandEnchants = {"Windfury Weapon", "Flametongue Weapon"},
		offHandEnchants = {"Flametongue Weapon", "Windfury Weapon"},
		thresholdTime = 10
	},
	
	warlock = {
		enabled = true,
		armors = {"Demon Skin", "Fel Armor"},
		thresholdTime = 10
	},
}

addon.playerClass = select(2, UnitClass("player"))

local config = addon.config
local frame = CreateFrame("Frame", nil, UIParent)
local reminders = {}

local onEvent = function(self, event, ...)
	addon:UpdateReminder(self, event, ...)
end

local onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetWidth(250)
	GameTooltip:AddLine(self.title)

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

local suppressReminder = function(self, reminder, suppressTime)
	reminder.suppressed = true
	reminder.suppressTime = suppressTime and (GetTime() + suppressTime) or 0
end

local menu
local menuFrame = CreateFrame("Frame", addonName .. "Menu", UIParent, "UIDropDownMenuTemplate")
local showReminderMenu = function(self)
	menu = {
		{text = self.title, isTitle = true},
		{text = "Suppress for 5 minutes", func = disableReminder, arg1 = self, arg2 = 5 * 60},
		{text = "Suppress for 30 minutes", func = disableReminder, arg1 = self, arg2 = 30 * 60},
		{text = "Disable for this session", func = disableReminder, arg1 = self}
	}

	EasyMenu(menu, menuFrame, "cursor", nil, nil, "MENU")
end

function addon:AddReminder(name, events, callback, icon, attributes, tooltip, parameters)
	if type(events) == "function" then
		print("WARNING: Reminder", name, " is in deprecated format.")
		return
	end
	
	if not parameters then
		parameters = {}
	end
	
	local buttonName = "ReminderButton" .. #reminders
	local reminder = CreateFrame("Button", buttonName, frame, "SecureActionButtonTemplate, ActionButtonTemplate")
	
	local texture = reminder:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(reminder)
	texture:SetTexCoord(.07, .93, .07, .93)
	texture:SetTexture("Interface\\Icons\\" .. (icon or "Temp"))

	_G[buttonName .. "Icon"]:SetTexture(texture)
	
	-- icon, attributes, tooltip, color, activeWhileResting
	reminder.title = name
	reminder.tooltip = tooltip

	reminder.callback = callback
	reminder.active = nil
	reminder.activeWhileResting = parameters.activeWhileResting
	reminder.suppressed = false
	reminder.suppressTime = 0
	
	reminder:RegisterForClicks("AnyUp")
	reminder:SetScript("OnEnter", onEnter)
	reminder:SetScript("OnLeave", onLeave)
	reminder:SetScript("OnEvent", onEvent)
	reminder:SetAttribute("alt-type*", "showMenu")

	reminder.showMenu = showReminderMenu
	reminder.setColor = function (...) texture:SetVertexColor(...) end
	reminder.setIcon = function(...) texture:SetTexture(...) end
	
	for _, event in pairs(type(events) == "string" and {events} or events) do
		reminder:RegisterEvent(event)
	end

	if attributes then
		for key, value in pairs(attributes) do
			reminder:SetAttribute(key, value)
		end
	end
	
	if parameters.color then
		reminder.setColor(unpack(parameters.color))
	end

	table.insert(reminders, reminder)
	
	return reminder
end

function addon:UpdateReminder(reminder, event, ...)
--if not reminder.suppressed then
	local previousState = reminder.active

	reminder.active = (not reminder.activeWhileResting or not IsResting()) and reminder.callback(reminder, event, ...)

	if reminder.active and not previousState then
		self:UpdateLayout()
	end
	--end
end

function addon:UpdateLayout()
	local inCombat = InCombatLockdown()
	local previousReminder

	for _, reminder in pairs(reminders) do
		if reminder.active then
			if not inCombat then
				if previousReminder then
					reminder:SetPoint("TOPLEFT", previousReminder, "TOPRIGHT", 5, 0)
				else
					reminder:SetPoint("TOPLEFT", frame)
				end

				reminder:Show()
			end

			reminder:SetAlpha(1)
			
			previousReminder = reminder
		else
			if not inCombat then
				reminder:Hide()
			end
			
			reminder:SetAlpha(0)
		end	
	end
end

function addon:UpdateAllReminders(event)
	--print("Updating", #reminders, "reminders.")
	
	for _, reminder in pairs(reminders) do
		reminder.active = (reminder.activeWhileResting or not IsResting()) and reminder.callback(reminder, event or "UPDATE_ALL_REMINDERS")
	end
	
	self:UpdateLayout()
end

local lastUpdate = 0
local updateInterval = 10

frame:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	
	if lastUpdate > updateInterval then
		lastUpdate = 0
		
		addon:UpdateAllReminders()
	end
end)

frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)

		frame:SetWidth(36)
		frame:SetHeight(36)
		frame:SetScale(config.scale)
		frame:SetPoint(unpack(config.position))
	end
	
	if event == "PLAYER_REGEN_ENABLED" then
		addon:UpdateLayout()
	else
		addon:UpdateAllReminders()
	end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_UPDATE_RESTING")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")