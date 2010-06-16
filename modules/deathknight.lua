local addonName, addon = ...
local config = addon.config.deathKnight

if addon.playerClass == "DEATHKNIGHT" then
	-- Master of Ghouls
	--[[
	if addon:HasTalent(3, 20) then
		addon:AddReminder("Missing Ghoul", function() return not (IsMounted() or PetHasActionBar()) end, "spell_shadow_animatedead", {type = "spell", spell = "Raise Dead"})	
	end
	]]
end