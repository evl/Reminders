-- Karabor
evl_Reminders:AddReminder("Blessed Medallion of Karabor equipped wihout additional Shadow Resistance items", function() return IsEquippedItem("Blessed Medallion of Karabor") and select(2, UnitResistance("player", 5)) < 150 end, "INV_Jewelry_Amulet_04")

-- Bag slots
evl_Reminders:AddReminder("Less than 3 bag-slots available", function() return MainMenuBarBackpackButton.freeSlots < 3 and MainMenuBarBackpackButton.freeSlots > 0 end, "INV_Misc_Bag_19")
evl_Reminders:AddReminder("No bag-slots available", function() return MainMenuBarBackpackButton.freeSlots == 0 end, "INV_Misc_Bag_19", nil, nil, {1, 0.1, 0.1})

-- Kirin Tor ring
evl_Reminders:AddReminder("Band of the Kirin Tor equipped", function() return IsEquippedItem("Band of the Kirin Tor") end, "INV_Jewelry_Ring_74", {type = "item", item1 = "Band of the Kirin Tor"})
