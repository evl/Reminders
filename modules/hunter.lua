local addonName, addon = ...
local config = addon.config.warlock

if config.enabled and addon.playerClass == "HUNTER" then
	-- Improved tracking
	if addon:HasTalent(tabIndex, talentIndex) then
		addon:AddReminder("Undead tracking inactive within Icecrown Citadel", function() return GetTrackingTexture() ~= "Interface\\Icons\\Spell_Shadow_DarkSummoning" and GetZoneText() == "Icecrown Citadel" end, {type = "spell", spell = "Track Undead"})
		addon:AddReminder("Dragonkin tracking inactive within Ruby Sanctum", function() return GetTrackingTexture() ~= "Interface\\Icons\\Spell_Shadow_DarkSummoning" and GetZoneText() == "The Ruby Sanctum" end, {type = "spell", spell = "Track Dragonkin"})
	end
end