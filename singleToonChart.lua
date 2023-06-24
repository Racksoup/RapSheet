function XPC:BuildSingleToon()
  XPC_GUI.main.single = CreateFrame("Frame", single, XPC_GUI.main)
  local single = XPC_GUI.main.single
  single:SetSize(1200, 650)
  single:SetPoint("TOPLEFT")

  single.chart = CreateFrame("Frame", chart, single)
  local chart = single.chart
  chart:SetSize(1150, 595)
  chart:SetPoint("BOTTOMLEFT")
  
  -- switch toons button
  single.toonsBtn = CreateFrame("Button", nil, single, "UIPanelButtonTemplate")
  local toonsBtn = single.toonsBtn
  toonsBtn:SetSize(120, 25)
  toonsBtn:SetPoint("TOPRIGHT", -80, -12)
  toonsBtn:SetText("Choose Toon")
  toonsBtn:SetScript("OnClick", function() end)

  single:Hide()
end

function XPC:ShowSingleToonChart()


  XPC_GUI.main.single:Show()
end

-- button to switch toons
-- button to see list of quests completed per level
-- button to see list of monsters killed by name.  per level. solo and total

-- # of monsters killed. 
-- # of monsters killed in a group 
-- # of monsters killed total
-- # of quests comleted
-- # of food eaten
-- # of drink drank
-- # of bandaids bandaged
-- # of potions used
-- # of heals given
-- # of heals received
-- # of damage dealt
-- # of damage taken
-- # of deaths
-- # of pvp deaths
-- # of duels won
-- # of duels lost
-- # of hk's
-- # of flight paths taken
-- time on flight paths
-- time afk
-- time in combat
-- % of time in combat
-- % of xp gained from quests
-- % of xp gained from mobs
-- time played at level
-- overall time played when leveled
-- # of dungeons entered