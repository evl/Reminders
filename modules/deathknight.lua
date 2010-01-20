if select(2, UnitClass("player")) == "DEATHKNIGHT" then
	-- Master of Ghouls
	--[[
	if evl_Reminders:HasTalent(3, 20) then
		evl_Reminders:AddReminder("Missing Ghoul", function() return not (IsMounted() or PetHasActionBar()) end, "spell_shadow_animatedead", {type = "spell", spell = "Raise Dead"})	
	end
	]]
end