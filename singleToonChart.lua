-- scroll function for both vertical and horizontal scrolling using 2 sliders. 
function Single_OnMouseWheel(self, delta) 
  local single = XPC_GUI.main.single
  local chart = XPC_GUI.main.single.chart
  local point, relativeTo, relativePoint, offsetX, offsetY = chart:GetPoint()
  
  if (IsShiftKeyDown()) then
    -- horizontal slider 
    local hSlider = XPC_GUI.main.single.hSlider
    local newValue = hSlider:GetValue() - (delta * .5);
    local minValue, maxValue = hSlider:GetMinMaxValues()
    
    if (newValue < minValue) then
      newValue = minValue
    elseif (newValue > maxValue) then
      newValue = maxValue
    elseif (newValue > hSlider:GetValue()) then
      newValue = hSlider:GetValueStep()
    elseif (newValue < hSlider:GetValue()) then
      newValue = -1* hSlider:GetValueStep()
    end
    
    hSlider:SetValue(newValue + hSlider:GetValue())

    -- chart
    XPC:ChartScroller(hSlider, maxValue)

  else
    -- vertical slider
    local vSlider = XPC_GUI.main.single.vSlider
    local newValue = vSlider:GetValue() - (delta * .5);
    local minValue, maxValue = vSlider:GetMinMaxValues()
    
    if (newValue < minValue) then
      newValue = minValue
    elseif (newValue > maxValue) then
      newValue = maxValue
    elseif (newValue > vSlider:GetValue()) then
      newValue = vSlider:GetValueStep()
    elseif (newValue < vSlider:GetValue()) then
      newValue = -1* vSlider:GetValueStep()
    end
    
    vSlider:SetValue(newValue + vSlider:GetValue())

    -- chart
    XPC:ChartScroller(vSlider, maxValue)
  end
end

function XPC:ChartScroller(slider, maxValue)
  local single = XPC_GUI.main.single
  local chart = XPC_GUI.main.single.chart
  local point, relativeTo, relativePoint, offsetX, offsetY = chart:GetPoint()
  
  local sliderValue = slider:GetValue()
  local scrollDist = sliderValue / maxValue
  if (slider:GetOrientation() == "HORIZONTAL") then 
    local scrollMaxLength = chart:GetWidth()  - single:GetWidth()
    local scrollPos = (scrollMaxLength / 100) * (-scrollDist * 100)
    if (scrollPos > -slider:GetValueStep()) then scrollPos = 0 end
    chart:SetPoint(point, relativeTo, relativePoint, scrollPos, offsetY)
  elseif (slider:GetOrientation() == "VERTICAL") then
    local scrollMaxLength = chart:GetHeight()  - single:GetHeight()
    local scrollPos = (scrollMaxLength / 100) * (scrollDist * 100)
    if (scrollPos < slider:GetValueStep() - 6) then scrollPos = 0 end
    chart:SetPoint(point, relativeTo, relativePoint, offsetX, scrollPos)
  end
end

function XPC:HideSingleToonChart()
  local main = XPC_GUI.main
  local single = main.single

  single.vSlider:Hide()
  single.hSlider:Hide()
  single.toonsBtn:Hide()
  single:Hide()
end

function XPC:BuildSingleToon()
  XPC_GUI.main.single = CreateFrame("Frame", single, XPC_GUI.main)
  local single = XPC_GUI.main.single
  single:SetSize(1166, 584)
  single:SetPoint("TOPLEFT", 4, -45)
  single:SetClipsChildren(true)
  single:SetScript("OnMouseWheel", Single_OnMouseWheel)
  
  -- switch toons button
  single.toonsBtn = CreateFrame("Button", nil, XPC_GUI.main, "UIPanelButtonTemplate")
  local toonsBtn = single.toonsBtn
  toonsBtn:SetSize(120, 25)
  toonsBtn:SetPoint("TOPRIGHT", -80, -14)
  toonsBtn:SetText("Choose Toon")
  toonsBtn:SetScript("OnClick", function() 
    local chooseToon = XPC_GUI.main.single.chooseToon
    if (chooseToon:IsVisible()) then
      chooseToon:Hide()
    else
      chooseToon:Show()
    end
  end)

  -- Chart hSlider
  XPC_GUI.main.single.hSlider = CreateFrame("Slider", nil, XPC_GUI.main, "OptionsSliderTemplate")
  local hSlider = XPC_GUI.main.single.hSlider
  hSlider:SetPoint("BOTTOMLEFT", 4, 1)
  hSlider:SetSize(1192, 20)
  hSlider:SetValueStep(25)
  hSlider:SetMinMaxValues(1, 200)
  hSlider:SetValue(1)
  hSlider:SetObeyStepOnDrag(true)
  hSlider:SetOrientation("HORIZONTAL")
  hSlider.High:Hide()
  hSlider.Low:Hide()
  hSlider:SetScript("OnValueChanged", function(self, value)
    local minVal, maxVal = self:GetMinMaxValues()
    XPC:ChartScroller(self, maxVal)
  end)
  
  -- Chart vSlider
  XPC_GUI.main.single.vSlider = CreateFrame("Slider", nil, XPC_GUI.main, "OptionsSliderTemplate")
  local vSlider = XPC_GUI.main.single.vSlider
  vSlider:SetPoint("TOPRIGHT", -6, -25)
  vSlider:SetSize(20, 610)
  vSlider:SetValueStep(20)
  vSlider:SetMinMaxValues(1, 100)
  vSlider:SetValue(1)
  vSlider:SetObeyStepOnDrag(true)
  vSlider:SetOrientation("VERTICAL")
  vSlider.High:Hide()
  vSlider.Low:Hide()
  vSlider:SetScript("OnValueChanged", function(self, value)
    local minVal, maxVal = self:GetMinMaxValues()
    XPC:ChartScroller(self, maxVal)
  end)

  -- Chart
  single.chart = CreateFrame("Frame", chart, single)
  local chart = single.chart
  
  -- create chart content 
  chart.content = CreateFrame("Frame", content, chart)
  local content = chart.content
  
  -- Vertical Value table init
  chart.vValues = {}
  -- Vertical Content Values table init
  content.values = {
    damageDealt = {},
    damageTaken = {},
    monstersKilledSolo = {},
    monstersKilledInGroup = {},
    monstersKilled = {},
    questsCompleted = {},
    food = {},
    drink = {},
    bandages = {},
    potions = {},
    elixirs = {},
    scrolls = {},
    flasks = {},
    healingPotions = {},
    manaPotions = {},
    MHPotions = {},
    healsGiven = {},
    healsReceived = {},
    deaths = {},
    duelsWon = {},
    duelsLost = {},
    honorKills = {},
    honor = {},
    flightPaths = {},
    timeAFK = {},
    timeInCombat = {},
    timePlayedAtLevel = {},
    timeOnTaxi = {},
    levelTime = {},
    xpPerHour = {},
    XPFromQuests = {},
    XPFromMobs = {},
    dungeons = {},
    killsPerHour = {},
    hearthstone = {},
    goldFromQuests = {},
    goldFromLoot = {},
    goldGainedMerchant = {},
    goldLostMerchant = {},
    goldTotal = {},
    percentInCombat = {},
    percentXPMobs = {},
    percentXPQuests = {},
  }
  -- Vertical and Horizontal Line Seperator table init
  content.vLines = {}
  content.hLines = {}
  
  -- set size after content.values object init
  local j = 1 
  for k,v in pairs(content.values) do
    j = j + 1
  end
  local l = 1
  for k,v in pairs(XPC.db.global.toons[XPC.currSingleToon].statsData) do
    l = l + 1
  end
  if (l * 30 + 35 < single:GetHeight()) then 
    chart:SetSize(j * 80, single:GetHeight())
  else
    chart:SetSize(j * 80, l * 30 + 35)
  end
  chart:SetPoint("TOPLEFT", 0, 0)
  content:SetSize(chart:GetWidth() - 63, chart:GetHeight() - 33)
  content:SetPoint("TOPLEFT", 63 , -43)

  -- Horizontal Border Line
  chart.hLine = chart:CreateLine()
  chart.hLine:SetColorTexture(0.7,0.7,0.7,1)
  chart.hLine:SetStartPoint("TOPLEFT", 60, -40)
  chart.hLine:SetEndPoint("TOPRIGHT", 0, -40)
  -- Vertical Border Line
  chart.vLine = chart:CreateLine()
  chart.vLine:SetColorTexture(0.7,0.7,0.7,1)
  chart.vLine:SetStartPoint("TOPLEFT", 60, -40)
  chart.vLine:SetEndPoint("BOTTOMLEFT", 60, 0)
  
  -- Horizontal Values
  -- 1
  chart.dmgDone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.dmgDone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.dmgDone:SetPoint("TOPLEFT", (80 * 1) - 11, -20)
  chart.dmgDone:SetText('Dmg Done')
  -- 2
  chart.damageTaken = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.damageTaken:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.damageTaken:SetPoint("TOPLEFT", (80 * 2) -2, -20)
  chart.damageTaken:SetText('Dmg In')
  -- 3
  chart.HealsGiven = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsGiven:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsGiven:SetPoint("TOPLEFT", (80 * 3) -10, -20)
  chart.HealsGiven:SetText('Heals Out')
  -- 4
  chart.HealsReceived = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsReceived:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsReceived:SetPoint("TOPLEFT", (80 * 4) -4, -20)
  chart.HealsReceived:SetText('Heals In')
  -- 5
  chart.killsSolo = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsSolo:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsSolo:SetPoint("TOPLEFT", (80 * 5) -7, -20)
  chart.killsSolo:SetText('Kills Solo')
  -- 6
  chart.killsGroup = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsGroup:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsGroup:SetPoint("TOPLEFT", (80 * 6) -11, -20)
  chart.killsGroup:SetText('Kills Group')
  -- 7
  chart.killsPerHour = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsPerHour:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsPerHour:SetPoint("TOPLEFT", (80 * 7) -9, -20)
  chart.killsPerHour:SetText('Kills/Hour')
  -- 8
  chart.kills = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.kills:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.kills:SetPoint("TOPLEFT", (80 * 8) +8, -20)
  chart.kills:SetText('Kills')
  -- 9
  chart.deaths = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.deaths:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.deaths:SetPoint("TOPLEFT", (80 * 9), -20)
  chart.deaths:SetText('Deaths')
  -- 10
  chart.questsCompleted = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.questsCompleted:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.questsCompleted:SetPoint("TOPLEFT", (80 * 10), -20)
  chart.questsCompleted:SetText('Quests')
  -- 11
  chart.XPFromMobs = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.XPFromMobs:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.XPFromMobs:SetPoint("TOPLEFT", (80 * 11) -4, -20)
  chart.XPFromMobs:SetText('Mob XP')
  -- 12
  chart.XPFromQuests = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.XPFromQuests:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.XPFromQuests:SetPoint("TOPLEFT", (80 * 12) -7, -20)
  chart.XPFromQuests:SetText('Quest XP')
  -- 13
  chart.xpPerHour = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.xpPerHour:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.xpPerHour:SetPoint("TOPLEFT", (80 * 13) -4, -20)
  chart.xpPerHour:SetText('XP/Hour')
  -- 14
  chart.percentXPMobs = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.percentXPMobs:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.percentXPMobs:SetPoint("TOPLEFT", (80 * 14) -15, -20)
  chart.percentXPMobs:SetText('% XP Mobs')
  -- 15
  chart.percentXPQuests = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.percentXPQuests:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.percentXPQuests:SetPoint("TOPLEFT", (80 * 15) -19, -20)
  chart.percentXPQuests:SetText('% XP Quests')
  -- 16
  chart.timePlayedAtLevel = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.timePlayedAtLevel:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.timePlayedAtLevel:SetPoint("TOPLEFT", (80 * 16) -17, -20)
  chart.timePlayedAtLevel:SetText('Time Played')
  -- 17 
  chart.levelTime = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.levelTime:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.levelTime:SetPoint("TOPLEFT", (80 * 17) -13, -20)
  chart.levelTime:SetText('Level Time')
  -- 18
  chart.timeInCombat = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.timeInCombat:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.timeInCombat:SetPoint("TOPLEFT", (80 * 18) -20, -20)
  chart.timeInCombat:SetText('Combat Time')
  -- 19
  chart.percentInCombat = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.percentInCombat:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.percentInCombat:SetPoint("TOPLEFT", (80 * 19) -15, -20)
  chart.percentInCombat:SetText('% in Combat')
  -- 20
  chart.TimeAFK = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.TimeAFK:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.TimeAFK:SetPoint("TOPLEFT", (80 * 20) -7, -20)
  chart.TimeAFK:SetText('Time AFK')
  -- 21
  chart.goldFromLoot = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldFromLoot:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldFromLoot:SetPoint("TOPLEFT", (80 * 21) -10, -20)
  chart.goldFromLoot:SetText('Loot Gold')
  -- 22
  chart.goldFromQuests = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldFromQuests:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldFromQuests:SetPoint("TOPLEFT", (80 * 22) -13, -20)
  chart.goldFromQuests:SetText('Quest Gold')
  -- 23
  chart.goldGainedMerchant = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldGainedMerchant:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldGainedMerchant:SetPoint("TOPLEFT", (80 * 23) +7, -20)
  chart.goldGainedMerchant:SetText('Sold')
  -- 24
  chart.goldTotal = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldTotal:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldTotal:SetPoint("TOPLEFT", (80 * 24) -17, -20)
  chart.goldTotal:SetText('Gold Gained')
  -- 25
  chart.goldLostMerchant = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldLostMerchant:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldLostMerchant:SetPoint("TOPLEFT", (80 * 25) +3, -20)
  chart.goldLostMerchant:SetText('Spent')
  -- 26
  chart.duelsWon = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.duelsWon:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.duelsWon:SetPoint("TOPLEFT", (80 * 26) -12, -20)
  chart.duelsWon:SetText('Duels Won')
  -- 27
  chart.duelsLost = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.duelsLost:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.duelsLost:SetPoint("TOPLEFT", (80 * 27) -11, -20)
  chart.duelsLost:SetText('Duels Lost')
  -- 28
  chart.honorKills = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.honorKills:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.honorKills:SetPoint("TOPLEFT", (80 * 28) +8, -20)
  chart.honorKills:SetText('HKs')
  -- 29
  chart.honor = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.honor:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.honor:SetPoint("TOPLEFT", (80 * 29), -20)
  chart.honor:SetText('Honor')
  -- 30
  chart.food = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.food:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.food:SetPoint("TOPLEFT", (80 * 30) +6, -20)
  chart.food:SetText('Food')
  -- 31
  chart.drink = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.drink:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.drink:SetPoint("TOPLEFT", (80 * 31) +5, -20)
  chart.drink:SetText('Drink')
  -- 32
  chart.bandages = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.bandages:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.bandages:SetPoint("TOPLEFT", (80 * 32) -9, -20)
  chart.bandages:SetText('Bandages')
  -- 33 
  chart.healingPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.healingPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.healingPotions:SetPoint("TOPLEFT", (80 * 33) -13, -20)
  chart.healingPotions:SetText('Health Pots')
  -- 34
  chart.manaPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.manaPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.manaPotions:SetPoint("TOPLEFT", (80 * 34) -11, -20)
  chart.manaPotions:SetText('Mana Pots')
  -- 35
  chart.MHPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.MHPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.MHPotions:SetPoint("TOPLEFT", (80 * 35) -7, -20)
  chart.MHPotions:SetText('H/M Pots')
  -- 36
  chart.potions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.potions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.potions:SetPoint("TOPLEFT", (80 * 36) +0, -20)
  chart.potions:SetText('Potions')
  -- 37
  chart.elixirs = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.elixirs:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.elixirs:SetPoint("TOPLEFT", (80 * 37) +2, -20)
  chart.elixirs:SetText('Elixirs')
  -- 38
  chart.flasks = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.flasks:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.flasks:SetPoint("TOPLEFT", (80 * 38) +2, -20)
  chart.flasks:SetText('Flasks')
  -- 39
  chart.scrolls = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.scrolls:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.scrolls:SetPoint("TOPLEFT", (80 * 39) +0, -20)
  chart.scrolls:SetText('Scrolls')
  -- 40
  chart.hearthstone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.hearthstone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.hearthstone:SetPoint("TOPLEFT", (80 * 40) -19, -20)
  chart.hearthstone:SetText('Hearthstones')
  -- 41
  chart.dungeons = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.dungeons:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.dungeons:SetPoint("TOPLEFT", (80 * 41) -8, -20)
  chart.dungeons:SetText('Dungeons')
  -- 42
  chart.flightPaths = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.flightPaths:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.flightPaths:SetPoint("TOPLEFT", (80 * 42) +4, -20)
  chart.flightPaths:SetText('Taxis')
  -- 43
  chart.timeOnTaxi = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.timeOnTaxi:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.timeOnTaxi:SetPoint("TOPLEFT", (80 * 43) -8, -20)
  chart.timeOnTaxi:SetText('Taxi Time')


  -- Vertical Seperator Lines
  local i = 1
  for k,v in pairs(content.values) do
    local line = content:CreateLine()
    line:SetColorTexture(0.7, 0.7, 0.7, .1)
    line:SetStartPoint("TOPLEFT", 80 * i, 0)
    line:SetEndPoint("BOTTOMLEFT", 80 * i, 0)

    table.insert(content.vLines, line)

    i = i + 1
  end

  XPC:BuildChooseToon()

  single:Hide()
end

function XPC:ShowSingleToonChart()
  local single = XPC_GUI.main.single
  local chart = XPC_GUI.main.single.chart
  local content = chart.content
  local toon = XPC.db.global.toons[XPC.currSingleToon]
  local levelData = toon.levelData
  local level = levelData[#levelData].level

  XPC_GUI.main.single:Show()
  single.vSlider:Show()
  single.hSlider:Show()
  single.toonsBtn:Show()
  
  -- Hide content that changes
  chart:Hide()
  for i, v in ipairs(chart.vValues) do
    v:Hide()
  end
  chart.vValues = {}
  -- hide values
  for k, v in pairs(content.values) do
    for i, p in ipairs(v) do
      p:Hide()
    end
  end
  -- hide horizontal seprator lines
  for k,v in pairs(content.hLines) do
    v:Hide()
  end

  -- Horizontal Seperator Lines
  local missedLevels = 0
  for j = level+1, 1, -1 do
    -- check if level is in statsData, not on first loop for total
    if (j == level+1 or toon.statsData[tostring(j)] ~= nil) then
      local line = content:CreateLine()
      line:SetColorTexture(0.7, 0.7, 0.7, .1)
      line:SetStartPoint("TOPLEFT", 0, ((level +1) - j +1 -missedLevels) * -30 + 2)
      line:SetEndPoint("TOPRIGHT", 0, ((level +1) - j +1 -missedLevels) * -30 + 2)

      table.insert(content.hLines, line)
    else
      missedLevels = missedLevels + 1
    end
  end

  -- V-values
  missedLevels = 0
  for i = level+1, 1, -1 do 
    -- check if level is in statsData, not on first loop for total
    if (i == level+1 or toon.statsData[tostring(i)] ~= nil) then
      local value = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
      value:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      if (i == level + 1) then 
        value:SetPoint("TOPLEFT", 12, -60 + (((level +1) - i) * -30) +8)
        value:SetText('Total') 
      else 
        value:SetPoint("TOPLEFT", 20, -60 + (((level +1) - i - missedLevels) * -30) +8)
        value:SetText(i) 
      end
      table.insert(chart.vValues, value)
    else
      missedLevels = missedLevels + 1
    end
  end
  
  -- chart values for levels. goes through each level and create a value for each data on the chart
  local totalXP = 0
  missedLevels = 0
  for i=level, 1, -1 do
    local stats = toon.statsData[tostring(i)]
    local lastLevelStats = toon.statsData[tostring(i -1)]
    if (stats ~= nil) then 
      totalXP = totalXP + XPC.levelChart[i]
      local v = stats
      local posY = ((level + 1) - i - missedLevels) * -30 -15
      local levelTime = 0

      -- 17 Level Time
      if (stats.timePlayedAtLevel ~= nil) then
        local levelTimeFrame = CreateFrame("Frame", nil, content)
        levelTimeFrame:SetPoint("TOPLEFT", (80 *17) - 40, posY)
        levelTimeFrame:SetSize(1,1)
        local levelTimeFS = levelTimeFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        levelTimeFS:SetPoint("CENTER")
        levelTimeFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        if (
        v.timePlayedAtLevel ~= 0 and 
        lastLevelStats ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= 0) then
          local t1 = v.timePlayedAtLevel
          local t2 = lastLevelStats.timePlayedAtLevel
          local timex = t1 - t2
          levelTime = timex
          local days, hours, minutes, seconds = XPC:TimeFormat(timex)
          if (days >= 1) then 
            levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
          else
            levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
          end
        elseif (
        lastLevelStats ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= 0) then
          local t2 = lastLevelStats.timePlayedAtLevel
          local t3 = toon.levelData[#toon.levelData].timePlayed
          local timex = t3 - t2
          levelTime = timex
          local days, hours, minutes, seconds = XPC:TimeFormat(timex)
          if (days >= 1) then 
            levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
          else
            levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
          end
        elseif (
        i == 1 and
        v.timePlayedAtLevel ~= 0) then
          local days, hours, minutes, seconds = XPC:TimeFormat(v.timePlayedAtLevel)
          if (days >= 1) then 
            levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
          else
            levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
          end
        end
        table.insert(content.values.levelTime, levelTimeFrame)
      end

      -- 1 Damage Dealt
      if (stats.damageDealt ~= nil) then
        local damageDealtFrame = CreateFrame("Frame", nil, content)
        damageDealtFrame:SetPoint("TOPLEFT", (80 *1) -40, posY)
        damageDealtFrame:SetSize(1,1)
        local damageDealtFS = damageDealtFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        damageDealtFS:SetPoint("CENTER")
        damageDealtFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        if (v.damageDealt >= 1000000) then 
          damageDealtFS:SetText(tostring(math.floor(v.damageDealt / 10000) / 100) .. 'M')
        elseif (v.damageDealt >= 1000) then 
          damageDealtFS:SetText(tostring(math.floor(v.damageDealt / 100) / 10) .. 'K')
        else
          damageDealtFS:SetText(tostring(v.damageDealt))
        end
        table.insert(content.values.damageDealt, damageDealtFrame)
      end

      -- 2 Damage Taken
      if (stats.damageTaken ~= nil) then
        local damageTakenFrame = CreateFrame("Frame", nil, content)
        damageTakenFrame:SetPoint("TOPLEFT", (80 *2) -40, posY)
        damageTakenFrame:SetSize(1,1)
        local damageTakenFS = damageTakenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        damageTakenFS:SetPoint("CENTER")
        damageTakenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        if (v.damageTaken >= 1000000) then 
          damageTakenFS:SetText(tostring(math.floor(v.damageTaken / 10000) / 100) .. 'M')
        elseif (v.damageTaken >= 1000) then 
          damageTakenFS:SetText(tostring(math.floor(v.damageTaken / 100) / 10) .. 'K')
        else
          damageTakenFS:SetText(tostring(v.damageTaken))
        end
        table.insert(content.values.damageTaken, damageTakenFrame)
      end

      -- 3 Heals Given
      if (stats.healsGiven ~= nil) then
        local healsGivenFrame = CreateFrame("Frame", nil, content)
        healsGivenFrame:SetPoint("TOPLEFT", (80 *3) -40, posY)
        healsGivenFrame:SetSize(1,1)
        local healsGivenFS = healsGivenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        healsGivenFS:SetPoint("CENTER")
        healsGivenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        if (v.healsGiven >= 1000000) then 
          healsGivenFS:SetText(tostring(math.floor(v.healsGiven / 10000) / 100) .. 'M')
        elseif (v.healsGiven >= 1000) then 
          healsGivenFS:SetText(tostring(math.floor(v.healsGiven / 100) / 10) .. 'K')
        else
          healsGivenFS:SetText(tostring(v.healsGiven))
        end
        table.insert(content.values.healsGiven, healsGivenFrame)
      end

      -- 4 Heals Received
      if (stats.healsReceived ~= nil) then
        local healsReceivedFrame = CreateFrame("Frame", nil, content)
        healsReceivedFrame:SetPoint("TOPLEFT", (80 *4) -40, posY)
        healsReceivedFrame:SetSize(1,1)
        local healsReceivedFS = healsReceivedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        healsReceivedFS:SetPoint("CENTER")
        healsReceivedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        if (v.healsReceived >= 1000000) then 
          healsReceivedFS:SetText(tostring(math.floor(v.healsReceived / 10000) / 100) .. 'M')
        elseif (v.healsReceived >= 1000) then 
          healsReceivedFS:SetText(tostring(math.floor(v.healsReceived / 100) / 10) .. 'K')
        else
          healsReceivedFS:SetText(tostring(v.healsReceived))
        end
        table.insert(content.values.healsReceived, healsReceivedFrame)
      end
      
      -- 5 Kills Solo
      if (stats.monstersKilledSolo ~= nil) then
        local monstersKilledSoloFrame = CreateFrame("Frame", nil, content)
        monstersKilledSoloFrame:SetPoint("TOPLEFT", (80 *5) -40, posY)
        monstersKilledSoloFrame:SetSize(1,1)
        local monstersKilledSoloFS = monstersKilledSoloFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        monstersKilledSoloFS:SetPoint("CENTER")
        monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        monstersKilledSoloFS:SetText(v.monstersKilledSolo) 
        table.insert(content.values.monstersKilledSolo, monstersKilledSoloFrame)
      end

      -- 6 Kills Group
      if (stats.monstersKilledInGroup ~= nil) then
        local monstersKilledInGroupFrame = CreateFrame("Frame", nil, content)
        monstersKilledInGroupFrame:SetPoint("TOPLEFT", (80 *6) -40, posY)
        monstersKilledInGroupFrame:SetSize(1,1)
        local monstersKilledInGroupFS = monstersKilledInGroupFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        monstersKilledInGroupFS:SetPoint("CENTER")
        monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        monstersKilledInGroupFS:SetText(v.monstersKilledInGroup) 
        table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFrame)
      end

      -- 7 Kills Per Hour
      if (levelTime ~= 0) then 
        local killsPerHourFrame = CreateFrame("Frame", nil, content)
        killsPerHourFrame:SetPoint("TOPLEFT", (80 *7) -40, posY)
        killsPerHourFrame:SetSize(1,1)
        local killsPerHourFS = killsPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        killsPerHourFS:SetPoint("CENTER")
        killsPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local killsPerHour = math.floor((v.monstersKilledInGroup + v.monstersKilledSolo) / (levelTime / 60 / 60) * 10) / 10
        killsPerHourFS:SetText(killsPerHour .. '/h') 
        table.insert(content.values.killsPerHour, killsPerHourFrame)
      end
      if (i == 1 and v.timePlayedAtLevel ~= 0) then 
        local killsPerHourFrame = CreateFrame("Frame", nil, content)
        killsPerHourFrame:SetPoint("TOPLEFT", (80 *7) -40, posY)
        killsPerHourFrame:SetSize(1,1)
        local killsPerHourFS = killsPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        killsPerHourFS:SetPoint("CENTER")
        killsPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local killsPerHour = math.floor((v.monstersKilledInGroup + v.monstersKilledSolo) / (v.timePlayedAtLevel / 60 / 60) * 10) / 10
        killsPerHourFS:SetText(killsPerHour .. '/h') 
        table.insert(content.values.killsPerHour, killsPerHourFrame) 
      end

      -- 8 Kills
      if (stats.monstersKilledSolo ~= nil and stats.monstersKilledInGroup ~= nil) then
        local monstersKilledFrame = CreateFrame("Frame", nil, content)
        monstersKilledFrame:SetPoint("TOPLEFT", (80 *8) -40, posY)
        monstersKilledFrame:SetSize(1,1)
        local monstersKilledFS = monstersKilledFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        monstersKilledFS:SetPoint("CENTER")
        monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        monstersKilledFS:SetText(v.monstersKilledInGroup + v.monstersKilledSolo) 
        table.insert(content.values.monstersKilled, monstersKilledFrame)
      end

      -- 9 Deaths
      if (stats.deaths ~= nil) then
        local deathsFrame = CreateFrame("Frame", nil, content)
        deathsFrame:SetPoint("TOPLEFT", (80 *9) -40, posY)
        deathsFrame:SetSize(1,1)
        local deathsFS = deathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        deathsFS:SetPoint("CENTER")
        deathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        deathsFS:SetText(v.deaths) 
        table.insert(content.values.deaths, deathsFrame)
      end

      -- 10 Quests Completed
      if (stats.questsCompleted ~= nil) then
        local questsCompletedFrame = CreateFrame("Frame", nil, content)
        questsCompletedFrame:SetPoint("TOPLEFT", (80 *10) -40, posY)
        questsCompletedFrame:SetSize(1,1)
        local questsCompletedFS = questsCompletedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        questsCompletedFS:SetPoint("CENTER")
        questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        questsCompletedFS:SetText(v.questsCompleted) 
        table.insert(content.values.questsCompleted, questsCompletedFrame)
      end

      -- 11 Mob XP
      if (stats.XPFromMobs ~= nil) then
        local XPFromMobsFrame = CreateFrame("Frame", nil, content)
        XPFromMobsFrame:SetPoint("TOPLEFT", (80 *11) -40, posY)
        XPFromMobsFrame:SetSize(1,1)
        local XPFromMobsFS = XPFromMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        XPFromMobsFS:SetPoint("CENTER")
        XPFromMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        XPFromMobsFS:SetText(v.XPFromMobs) 
        table.insert(content.values.XPFromMobs, XPFromMobsFrame)
      end

      -- 12 Quest XP
      if (stats.XPFromQuests ~= nil) then
        local XPFromQuestsFrame = CreateFrame("Frame", nil, content)
        XPFromQuestsFrame:SetPoint("TOPLEFT", (80 *12) -40, posY)
        XPFromQuestsFrame:SetSize(1,1)
        local XPFromQuestsFS = XPFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        XPFromQuestsFS:SetPoint("CENTER")
        XPFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        XPFromQuestsFS:SetText(v.XPFromQuests) 
        table.insert(content.values.XPFromQuests, XPFromQuestsFrame)
      end

      -- 13 XP per hour
      if (levelTime ~= 0) then
        local xpPerHourFrame = CreateFrame("Frame", nil, content)
        xpPerHourFrame:SetPoint("TOPLEFT", (80 *13) -40, posY)
        xpPerHourFrame:SetSize(1,1)
        local xpPerHourFS = xpPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        xpPerHourFS:SetPoint("CENTER")
        xpPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local xpPerHour = 0
        if (i == UnitLevel('player')) then
          xpPerHour = math.floor(toon.levelData[#toon.levelData].XPGainedThisLevel / (levelTime / 60 / 60))
        else
          xpPerHour = math.floor(XPC.levelChart[i] / (levelTime / 60 / 60))
        end
        xpPerHourFS:SetText(xpPerHour .. '/h') 
        table.insert(content.values.xpPerHour, xpPerHourFrame)
      end
      if (i == 1 and v.timePlayedAtLevel ~= 0) then
        local xpPerHourFrame = CreateFrame("Frame", nil, content)
        xpPerHourFrame:SetPoint("TOPLEFT", (80 *13) -40, posY)
        xpPerHourFrame:SetSize(1,1)
        local xpPerHourFS = xpPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        xpPerHourFS:SetPoint("CENTER")
        xpPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local xpPerHour = math.floor(XPC.levelChart[i] / (v.timePlayedAtLevel / 60 / 60))
        xpPerHourFS:SetText(xpPerHour .. '/h') 
        table.insert(content.values.xpPerHour, xpPerHourFrame)
      end

      -- 14 Percent XP Gained Mobs
      if (stats.XPFromMobs ~= nil) then
        local percentXPMobsFrame = CreateFrame("Frame", nil, content)
        percentXPMobsFrame:SetPoint("TOPLEFT", (80 *14) -40, posY)
        percentXPMobsFrame:SetSize(1,1)
        local percentXPMobsFS = percentXPMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        percentXPMobsFS:SetPoint("CENTER")
        percentXPMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local percent = math.floor((v.XPFromMobs / XPC.levelChart[i]) * 100)
        if (percent > 100) then percent = 100 end
        percentXPMobsFS:SetText(percent .. "%") 
        table.insert(content.values.percentXPMobs, percentXPMobsFrame)
      end
      
      -- 15 Percent XP Gained Quests
      if (stats.XPFromQuests ~= nil) then
        local percentXPQuestsFrame = CreateFrame("Frame", nil, content)
        percentXPQuestsFrame:SetPoint("TOPLEFT", (80 *15) -40, posY)
        percentXPQuestsFrame:SetSize(1,1)
        local percentXPQuestsFS = percentXPQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        percentXPQuestsFS:SetPoint("CENTER")
        percentXPQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local percent = math.floor((v.XPFromQuests / XPC.levelChart[i]) * 100)
        if (percent > 100) then percent = 100 end
        percentXPQuestsFS:SetText(percent .. "%") 
        table.insert(content.values.percentXPQuests, percentXPQuestsFrame)
      end

      -- 16 Time Played
      if (toon.levelData[#toon.levelData] ~= nil and stats.timePlayedAtLevel ~= nil) then
        local timePlayedFrame = CreateFrame("Frame", nil, content)
        timePlayedFrame:SetPoint("TOPLEFT", (80 *16) -40, posY)
        timePlayedFrame:SetSize(1,1)
        local timePlayedFS = timePlayedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        timePlayedFS:SetPoint("CENTER")
        timePlayedFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        if (v.timePlayedAtLevel ~= 0) then
          local days, hours, minutes, seconds = XPC:TimeFormat(v.timePlayedAtLevel)
          if (days >= 1) then 
            timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
          else
            timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
          end
        else
          local days, hours, minutes, seconds = XPC:TimeFormat(toon.levelData[#toon.levelData].timePlayed)
          if (days >= 1) then 
            timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
          else
            timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
          end
        end
        table.insert(content.values.timePlayedAtLevel, timePlayedFrame)
      end

      -- 18 Time in Combat
      if (stats.timeInCombat ~= nil) then
        local timeInCombatFrame = CreateFrame("Frame", nil, content)
        timeInCombatFrame:SetPoint("TOPLEFT", (80 *18) -40, posY)
        timeInCombatFrame:SetSize(1,1)
        local timeInCombatFS = timeInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        timeInCombatFS:SetPoint("CENTER")
        timeInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local days, hours, minutes, seconds = XPC:TimeFormat(v.timeInCombat)
        if (days >= 1) then 
          timeInCombatFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          timeInCombatFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
        table.insert(content.values.timeInCombat, timeInCombatFrame)
      end

      -- 19 Percent Time in Combat
      if (stats.timeInCombat ~= nil and stats.timePlayedAtLevel ~= nil) then
        if (
        v.timePlayedAtLevel ~= 0 and 
        lastLevelStats ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= 0
        ) then
          local percentInCombatFrame = CreateFrame("Frame", nil, content)
          percentInCombatFrame:SetPoint("TOPLEFT", (80 *19) -40, posY)
          percentInCombatFrame:SetSize(1,1)
          local percentInCombatFS = percentInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
          percentInCombatFS:SetPoint("CENTER")
          percentInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
          percentInCombatFS:SetText(math.floor((v.timeInCombat / (v.timePlayedAtLevel - lastLevelStats.timePlayedAtLevel)) * 100) .. "%") 
          table.insert(content.values.percentInCombat, percentInCombatFrame)
        elseif (
        lastLevelStats ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= nil and 
        lastLevelStats.timePlayedAtLevel ~= 0
        ) then
          local t3 = toon.levelData[#toon.levelData].timePlayed
          local percentInCombatFrame = CreateFrame("Frame", nil, content)
          percentInCombatFrame:SetPoint("TOPLEFT", (80 *19) -40, posY)
          percentInCombatFrame:SetSize(1,1)
          local percentInCombatFS = percentInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
          percentInCombatFS:SetPoint("CENTER")
          percentInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
          percentInCombatFS:SetText(math.floor((v.timeInCombat / (t3 - lastLevelStats.timePlayedAtLevel)) * 100) .. "%") 
          table.insert(content.values.percentInCombat, percentInCombatFrame)
        elseif (
        i == 1 and
        v.timePlayedAtLevel ~= 0
        ) then
          local percentInCombatFrame = CreateFrame("Frame", nil, content)
          percentInCombatFrame:SetPoint("TOPLEFT", (80 *19) -40, posY)
          percentInCombatFrame:SetSize(1,1)
          local percentInCombatFS = percentInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
          percentInCombatFS:SetPoint("CENTER")
          percentInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
          percentInCombatFS:SetText(math.floor((v.timeInCombat / v.timePlayedAtLevel )* 100) .. "%")
          table.insert(content.values.percentInCombat, percentInCombatFrame)
        end
      end

      -- 20 Time AFK
      if (stats.timeAFK ~= nil) then
        local timeAFKFrame = CreateFrame("Frame", nil, content)
        timeAFKFrame:SetPoint("TOPLEFT", (80 *20) -40, posY)
        timeAFKFrame:SetSize(1,1)
        local timeAFKFS = timeAFKFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        timeAFKFS:SetPoint("CENTER")
        timeAFKFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local days, hours, minutes, seconds = XPC:TimeFormat(v.timeAFK)
        if (days >= 1) then 
          timeAFKFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          timeAFKFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
        table.insert(content.values.timeAFK, timeAFKFrame)
      end

      -- 21 Gold From Loot
      if (stats.goldFromLoot ~= nil) then
        local goldFromLootFrame = CreateFrame("Frame", nil, content)
        goldFromLootFrame:SetPoint("TOPLEFT", (80 *21) -40, posY)
        goldFromLootFrame:SetSize(1,1)
        local goldFromLootFS = goldFromLootFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        goldFromLootFS:SetPoint("CENTER")
        goldFromLootFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local gold, silver, copper = XPC:MoneyFormat(v.goldFromLoot)
        goldFromLootFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
        table.insert(content.values.goldFromLoot, goldFromLootFrame)
      end

      -- 22 Quest Gold
      if (stats.goldFromQuests ~= nil) then
        local goldFromQuestsFrame = CreateFrame("Frame", nil, content)
        goldFromQuestsFrame:SetPoint("TOPLEFT", (80 *22) -40, posY)
        goldFromQuestsFrame:SetSize(1,1)
        local goldFromQuestsFS = goldFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        goldFromQuestsFS:SetPoint("CENTER")
        goldFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local gold, silver, copper = XPC:MoneyFormat(v.goldFromQuests)
        goldFromQuestsFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
        table.insert(content.values.goldFromQuests, goldFromQuestsFrame)
      end
      
      -- 23 Gold Gained Merchant
      if (stats.goldGainedMerchant ~= nil) then
        local goldGainedMerchantFrame = CreateFrame("Frame", nil, content)
        goldGainedMerchantFrame:SetPoint("TOPLEFT", (80 *23) -40, posY)
        goldGainedMerchantFrame:SetSize(1,1)
        local goldGainedMerchantFS = goldGainedMerchantFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        goldGainedMerchantFS:SetPoint("CENTER")
        goldGainedMerchantFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local gold, silver, copper = XPC:MoneyFormat(v.goldGainedMerchant)
        goldGainedMerchantFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
        table.insert(content.values.goldGainedMerchant, goldGainedMerchantFrame)
      end

      -- 24 Gold Gained Total
      if (stats.goldGainedMerchant ~= nil or stats.goldFromLoot ~= nil or stats.goldFromQuests ~= nil) then
        local goldTotalFrame = CreateFrame("Frame", nil, content)
        goldTotalFrame:SetPoint("TOPLEFT", (80 *24) -40, posY)
        goldTotalFrame:SetSize(1,1)
        local goldTotalFS = goldTotalFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        goldTotalFS:SetPoint("CENTER")
        goldTotalFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local gold, silver, copper = XPC:MoneyFormat(v.goldGainedMerchant + v.goldFromLoot + v.goldFromQuests)
        goldTotalFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
        table.insert(content.values.goldTotal, goldTotalFrame)
      end

      -- 25 Gold Lost Merchant
      if (stats.goldLostMerchant ~= nil) then
        local goldLostMerchantFrame = CreateFrame("Frame", nil, content)
        goldLostMerchantFrame:SetPoint("TOPLEFT", (80 *25) -40, posY)
        goldLostMerchantFrame:SetSize(1,1)
        local goldLostMerchantFS = goldLostMerchantFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        goldLostMerchantFS:SetPoint("CENTER")
        goldLostMerchantFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local gold, silver, copper = XPC:MoneyFormat(v.goldLostMerchant)
        goldLostMerchantFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
        table.insert(content.values.goldLostMerchant, goldLostMerchantFrame)
      end

      -- 26 Duels Won
      if (stats.duelsWon ~= nil) then
        local duelsWonFrame = CreateFrame("Frame", nil, content)
        duelsWonFrame:SetPoint("TOPLEFT", (80 *26) -40, posY)
        duelsWonFrame:SetSize(1,1)
        local duelsWonFS = duelsWonFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        duelsWonFS:SetPoint("CENTER")
        duelsWonFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        duelsWonFS:SetText(v.duelsWon) 
        table.insert(content.values.duelsWon, duelsWonFrame)
      end
      
      -- 27 Duels Lost
      if (stats.duelsLost ~= nil) then
        local duelsLostFrame = CreateFrame("Frame", nil, content)
        duelsLostFrame:SetPoint("TOPLEFT", (80 *27) -40, posY)
        duelsLostFrame:SetSize(1,1)
        local duelsLostFS = duelsLostFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        duelsLostFS:SetPoint("CENTER")
        duelsLostFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        duelsLostFS:SetText(v.duelsLost) 
        table.insert(content.values.duelsLost, duelsLostFrame)
      end

      -- 28 Honor Kills
      if (stats.honorKills ~= nil) then
        local honorKillsFrame = CreateFrame("Frame", nil, content)
        honorKillsFrame:SetPoint("TOPLEFT", (80 *28) -40, posY)
        honorKillsFrame:SetSize(1,1)
        local honorKillsFS = honorKillsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        honorKillsFS:SetPoint("CENTER")
        honorKillsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        honorKillsFS:SetText(v.honorKills) 
        table.insert(content.values.honorKills, honorKillsFrame)
      end

      -- 29 Honor
      if (stats.honor ~= nil) then
        local honorFrame = CreateFrame("Frame", nil, content)
        honorFrame:SetPoint("TOPLEFT", (80 *29) -40, posY)
        honorFrame:SetSize(1,1)
        local honorFS = honorFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        honorFS:SetPoint("CENTER")
        honorFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        honorFS:SetText(v.honor) 
        table.insert(content.values.honor, honorFrame)
      end

      -- 30 Food
      if (stats.food ~= nil) then
        local foodFrame = CreateFrame("Frame", nil, content)
        foodFrame:SetPoint("TOPLEFT", (80 *30) -40, posY)
        foodFrame:SetSize(1,1)
        local foodFS = foodFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        foodFS:SetPoint("CENTER")
        foodFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        foodFS:SetText(v.food) 
        table.insert(content.values.food, foodFrame)
      end

      -- 31 Drink
      if (stats.drink ~= nil) then
        local drinkFrame = CreateFrame("Frame", nil, content)
        drinkFrame:SetPoint("TOPLEFT", (80 *31) -40, posY)
        drinkFrame:SetSize(1,1)
        local drinkFS = drinkFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        drinkFS:SetPoint("CENTER")
        drinkFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        drinkFS:SetText(v.drink) 
        table.insert(content.values.drink, drinkFrame)
      end

      -- 32 Bandages
      if (stats.bandages ~= nil) then
        local bandagesFrame = CreateFrame("Frame", nil, content)
        bandagesFrame:SetPoint("TOPLEFT", (80 *32) -40, posY)
        bandagesFrame:SetSize(1,1)
        local bandagesFS = bandagesFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        bandagesFS:SetPoint("CENTER")
        bandagesFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        bandagesFS:SetText(v.bandages) 
        table.insert(content.values.bandages, bandagesFrame)
      end

      -- 33 Healing Potions
      if (stats.healingPotions ~= nil) then
        local healingPotionsFrame = CreateFrame("Frame", nil, content)
        healingPotionsFrame:SetPoint("TOPLEFT", (80 *33) -40, posY)
        healingPotionsFrame:SetSize(1,1)
        local healingPotionsFS = healingPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        healingPotionsFS:SetPoint("CENTER")
        healingPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        healingPotionsFS:SetText(v.healingPotions) 
        table.insert(content.values.healingPotions, healingPotionsFrame)
      end

      -- 34 Mana Potions
      if (stats.manaPotions ~= nil) then
        local manaPotionsFrame = CreateFrame("Frame", nil, content)
        manaPotionsFrame:SetPoint("TOPLEFT", (80 *34) -40, posY)
        manaPotionsFrame:SetSize(1,1)
        local manaPotionsFS = manaPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        manaPotionsFS:SetPoint("CENTER")
        manaPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        manaPotionsFS:SetText(v.manaPotions) 
        table.insert(content.values.manaPotions, manaPotionsFrame)
      end

      -- 35 Healing / Mana Potions
      if (stats.MHPotions ~= nil) then
        local MHPotionsFrame = CreateFrame("Frame", nil, content)
        MHPotionsFrame:SetPoint("TOPLEFT", (80 *35) -40, posY)
        MHPotionsFrame:SetSize(1,1)
        local MHPotionsFS = MHPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        MHPotionsFS:SetPoint("CENTER")
        MHPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        MHPotionsFS:SetText(v.MHPotions) 
        table.insert(content.values.MHPotions, MHPotionsFrame)
      end
      
      -- 36 Potions
      if (stats.potions ~= nil) then
        local potionsFrame = CreateFrame("Frame", nil, content)
        potionsFrame:SetPoint("TOPLEFT", (80 *36) -40, posY)
        potionsFrame:SetSize(1,1)
        local potionsFS = potionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        potionsFS:SetPoint("CENTER")
        potionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        potionsFS:SetText(v.potions) 
        table.insert(content.values.potions, potionsFrame)
      end
      
      -- 37 elixirs
      if (stats.elixirs ~= nil) then
        local elixirsFrame = CreateFrame("Frame", nil, content)
        elixirsFrame:SetPoint("TOPLEFT", (80 *37) -40, posY)
        elixirsFrame:SetSize(1,1)
        local elixirsFS = elixirsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        elixirsFS:SetPoint("CENTER")
        elixirsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        elixirsFS:SetText(v.elixirs) 
        table.insert(content.values.elixirs, elixirsFrame)
      end
      
      -- 38 flasks
      if (stats.flasks ~= nil) then
        local flasksFrame = CreateFrame("Frame", nil, content)
        flasksFrame:SetPoint("TOPLEFT", (80 *38) -40, posY)
        flasksFrame:SetSize(1,1)
        local flasksFS = flasksFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        flasksFS:SetPoint("CENTER")
        flasksFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        flasksFS:SetText(v.flasks) 
        table.insert(content.values.flasks, flasksFrame)
      end

      -- 39 scrolls
      if (stats.scrolls ~= nil) then
        local scrollsFrame = CreateFrame("Frame", nil, content)
        scrollsFrame:SetPoint("TOPLEFT", (80 *39) -40, posY)
        scrollsFrame:SetSize(1,1)
        local scrollsFS = scrollsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        scrollsFS:SetPoint("CENTER")
        scrollsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        scrollsFS:SetText(v.scrolls) 
        table.insert(content.values.scrolls, scrollsFrame)
      end
      
      -- 40 Hearthstones
      if (stats.hearthstone ~= nil) then
        local hearthstoneFrame = CreateFrame("Frame", nil, content)
        hearthstoneFrame:SetPoint("TOPLEFT", (80 *40) -40, posY)
        hearthstoneFrame:SetSize(1,1)
        local hearthstoneFS = hearthstoneFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        hearthstoneFS:SetPoint("CENTER")
        hearthstoneFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        hearthstoneFS:SetText(v.hearthstone) 
        table.insert(content.values.hearthstone, hearthstoneFrame)
      end
      
      -- 41 Dungeons
      if (stats.dungeonsEntered ~= nil) then
        local dungeonsFrame = CreateFrame("Frame", nil, content)
        dungeonsFrame:SetPoint("TOPLEFT", (80 *41) -40, posY)
        dungeonsFrame:SetSize(1,1)
        local dungeonsFS = dungeonsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        dungeonsFS:SetPoint("CENTER")
        dungeonsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        dungeonsFS:SetText(v.dungeonsEntered) 
        table.insert(content.values.dungeons, dungeonsFrame)
      end

      -- 42 Flight Paths 
      if (stats.flightPaths ~= nil) then
        local flightPathsFrame = CreateFrame("Frame", nil, content)
        flightPathsFrame:SetPoint("TOPLEFT", (80 *42) -40, posY)
        flightPathsFrame:SetSize(1,1)
        local flightPathsFS = flightPathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        flightPathsFS:SetPoint("CENTER")
        flightPathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        flightPathsFS:SetText(v.flightPaths) 
        table.insert(content.values.flightPaths, flightPathsFrame)
      end

      -- 43 Time on Taxi
      if (stats.timeOnTaxi ~= nil) then
        local timeOnTaxiFrame = CreateFrame("Frame", nil, content)
        timeOnTaxiFrame:SetPoint("TOPLEFT", (80 *43) -40, posY)
        timeOnTaxiFrame:SetSize(1,1)
        local timeOnTaxiFS = timeOnTaxiFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        timeOnTaxiFS:SetPoint("CENTER")
        timeOnTaxiFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
        local days, hours, minutes, seconds = XPC:TimeFormat(v.timeOnTaxi)
        if (days >= 1) then 
          timeOnTaxiFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          timeOnTaxiFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
        table.insert(content.values.timeOnTaxi, timeOnTaxiFrame)
      end
      
    else
      missedLevels = missedLevels + 1
    end

    i = i + 1
  end

  -- chart values for total
  local stats = toon.statsData[tostring(level)]
  local totalDamageDealt = 0
  local totalMonstersKilledSolo = 0
  local totalMonstersKilledInGroup = 0
  local totalQuestsCompleted = 0
  local totalFood = 0
  local totalDrink = 0
  local totalFlightPaths = 0
  local totalHearthstone = 0
  local totalDamageTaken = 0
  local totalHealsGiven = 0
  local totalHealsReceived = 0
  local totalTimeAFK = 0
  local totalDungeons = 0
  local totalPotions = 0
  local totalElixirs = 0
  local totalFlasks = 0
  local totalScrolls = 0
  local totalHealingPotions = 0
  local totalManaPotions = 0
  local totalMHPotions = 0
  local totalXPFromMobs = 0
  local totalXPFromQuests = 0
  local totalGoldFromQuests = 0
  local totalDeaths = 0
  local totalBandages = 0
  local totalGoldFromLoot = 0
  local totalGoldGainedMerchant = 0
  local totalGoldLostMerchant = 0
  local totalTimeOnTaxi = 0
  local totalHonorKills = 0
  local totalDuelsWon = 0
  local totalDuelsLost = 0
  local totalHonor = 0
  local totalTimeInCombat = 0
  for k,v in pairs(toon.statsData) do
    if (v.damageDealt) then totalDamageDealt = totalDamageDealt + v.damageDealt end
    if (v.monstersKilledSolo) then totalMonstersKilledSolo = totalMonstersKilledSolo + v.monstersKilledSolo end
    if (v.monstersKilledInGroup) then totalMonstersKilledInGroup = totalMonstersKilledInGroup + v.monstersKilledInGroup end
    if (v.questsCompleted) then totalQuestsCompleted = totalQuestsCompleted + v.questsCompleted end
    if (v.food) then totalFood = totalFood + v.food end
    if (v.drink) then totalDrink = totalDrink + v.drink end
    if (v.flightPaths) then totalFlightPaths = totalFlightPaths + v.flightPaths end
    if (v.hearthstone) then totalHearthstone = totalHearthstone + v.hearthstone end
    if (v.damageTaken) then totalDamageTaken = totalDamageTaken + v.damageTaken end
    if (v.healsGiven) then totalHealsGiven = totalHealsGiven + v.healsGiven end
    if (v.healsReceived) then totalHealsReceived = totalHealsReceived + v.healsReceived end
    if (v.timeAFK) then totalTimeAFK = totalTimeAFK + v.timeAFK end
    if (v.dungeonsEntered) then totalDungeons = totalDungeons + v.dungeonsEntered end
    if (v.potions) then totalPotions = totalPotions + v.potions end
    if (v.elixirs) then totalElixirs = totalElixirs + v.elixirs  end
    if (v.flasks) then totalFlasks = totalFlasks + v.flasks  end
    if (v.scrolls) then totalScrolls = totalScrolls + v.scrolls  end
    if (v.healingPotions) then totalHealingPotions = totalHealingPotions + v.healingPotions end
    if (v.manaPotions) then totalManaPotions = totalManaPotions + v.manaPotions end
    if (v.MHPotions) then totalMHPotions = totalMHPotions + v.MHPotions end
    if (v.XPFromMobs) then totalXPFromMobs = totalXPFromMobs + v.XPFromMobs end
    if (v.XPFromQuests) then totalXPFromQuests = totalXPFromQuests + v.XPFromQuests end
    if (v.goldFromQuests) then totalGoldFromQuests = totalGoldFromQuests + v.goldFromQuests end
    if (v.deaths) then totalDeaths = totalDeaths + v.deaths end
    if (v.bandages) then totalBandages = totalBandages + v.bandages end
    if (v.goldFromLoot) then totalGoldFromLoot = totalGoldFromLoot + v.goldFromLoot end
    if (v.goldGainedMerchant) then totalGoldGainedMerchant = totalGoldGainedMerchant + v.goldGainedMerchant end
    if (v.goldLostMerchant) then totalGoldLostMerchant = totalGoldLostMerchant + v.goldLostMerchant end
    if (v.timeOnTaxi) then totalTimeOnTaxi = totalTimeOnTaxi + v.timeOnTaxi end
    if (v.honorKills) then totalHonorKills = totalHonorKills + v.honorKills end
    if (v.duelsWon) then totalDuelsWon = totalDuelsWon + v.duelsWon end
    if (v.duelsLost) then totalDuelsLost = totalDuelsLost + v.duelsLost end
    if (v.honor) then totalHonor = totalHonor + v.honor end
    if (v.timeInCombat) then totalTimeInCombat = totalTimeInCombat + v.timeInCombat end
  end

  -- 1 Damage Dealt
  if (stats.damageDealt ~= nil) then
    local damageDealtFrame = CreateFrame("Frame", nil, content)
    damageDealtFrame:SetPoint("TOPLEFT", (80 *1) -40, -15)
    damageDealtFrame:SetSize(1,1)
    local damageDealtFS = damageDealtFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    damageDealtFS:SetPoint("CENTER")
    damageDealtFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (totalDamageDealt >= 1000000) then 
      damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 10000) / 100) .. 'M')
    elseif (totalDamageDealt >= 1000) then 
      damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 100) / 10) .. 'K')
    else
      damageDealtFS:SetText(tostring(totalDamageDealt))
    end
    table.insert(content.values.damageDealt, damageDealtFrame)
  end

    -- 2 Damage Taken
  if (stats.damageTaken ~= nil) then
    local damageTakenFrame = CreateFrame("Frame", nil, content)
    damageTakenFrame:SetPoint("TOPLEFT", (80 *2) -40, -15)
    damageTakenFrame:SetSize(1,1)
    local damageTakenFS = damageTakenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    damageTakenFS:SetPoint("CENTER")
    damageTakenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (totalDamageTaken >= 1000000) then 
      damageTakenFS:SetText(tostring(math.floor(totalDamageTaken / 10000) / 100) .. 'M')
    elseif (totalDamageTaken >= 1000) then 
      damageTakenFS:SetText(tostring(math.floor(totalDamageTaken / 100) / 10) .. 'K')
    else
      damageTakenFS:SetText(tostring(totalDamageTaken))
    end
    table.insert(content.values.damageTaken, damageTakenFrame)
  end

    -- 3 Heals Given
  if (stats.healsGiven ~= nil) then
    local healsGivenFrame = CreateFrame("Frame", nil, content)
    healsGivenFrame:SetPoint("TOPLEFT", (80 *3) -40, -15)
    healsGivenFrame:SetSize(1,1)
    local healsGivenFS = healsGivenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    healsGivenFS:SetPoint("CENTER")
    healsGivenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (totalHealsGiven >= 1000000) then 
      healsGivenFS:SetText(tostring(math.floor(totalHealsGiven / 10000) / 100) .. 'M')
    elseif (totalHealsGiven >= 1000) then 
      healsGivenFS:SetText(tostring(math.floor(totalHealsGiven / 100) / 10) .. 'K')
    else
      healsGivenFS:SetText(tostring(totalHealsGiven))
    end
    table.insert(content.values.healsGiven, healsGivenFrame)
  end

    -- 4 Heals Received
  if (stats.healsReceived ~= nil) then
    local healsReceivedFrame = CreateFrame("Frame", nil, content)
    healsReceivedFrame:SetPoint("TOPLEFT", (80 *4) -40, -15)
    healsReceivedFrame:SetSize(1,1)
    local healsReceivedFS = healsReceivedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    healsReceivedFS:SetPoint("CENTER")
    healsReceivedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (totalHealsReceived >= 1000000) then 
      healsReceivedFS:SetText(tostring(math.floor(totalHealsReceived / 10000) / 100) .. 'M')
    elseif (totalHealsReceived >= 1000) then 
      healsReceivedFS:SetText(tostring(math.floor(totalHealsReceived / 100) / 10) .. 'K')
    else
      healsReceivedFS:SetText(tostring(totalHealsReceived))
    end
    table.insert(content.values.healsReceived, healsReceivedFrame)
  end

    -- 5 Kills Solo
  if (stats.monstersKilledSolo ~= nil) then
    local monstersKilledSoloFrame = CreateFrame("Frame", nil, content)
    monstersKilledSoloFrame:SetPoint("TOPLEFT", (80 *5) -40, -15)
    monstersKilledSoloFrame:SetSize(1,1)
    local monstersKilledSoloFS = monstersKilledSoloFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledSoloFS:SetPoint("CENTER")
    monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledSoloFS:SetText(totalMonstersKilledSolo) 
    table.insert(content.values.monstersKilledSolo, monstersKilledSoloFrame)
  end

    -- 6 Kills Group
  if (stats.monstersKilledInGroup ~= nil) then
    local monstersKilledInGroupFrame = CreateFrame("Frame", nil, content)
    monstersKilledInGroupFrame:SetPoint("TOPLEFT", (80 *6) -40, -15)
    monstersKilledInGroupFrame:SetSize(1,1)
    local monstersKilledInGroupFS = monstersKilledInGroupFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledInGroupFS:SetPoint("CENTER")
    monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledInGroupFS:SetText(totalMonstersKilledInGroup) 
    table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFrame)
  end
    
    -- 7 Kills Per Hour
  if (stats.monstersKilledSolo ~= nil and stats.monstersKilledInGroup ~= nil) then
    if (toon.levelData[#toon.levelData] ~= nil) then
      local killsPerHourFrame = CreateFrame("Frame", nil, content)
      killsPerHourFrame:SetPoint("TOPLEFT", (80 *7) -40, -15)
      killsPerHourFrame:SetSize(1,1)
      local killsPerHourFS = killsPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      killsPerHourFS:SetPoint("CENTER")
      killsPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      local timePlayed = toon.levelData[#toon.levelData].timePlayed
      local killsPerHour = math.floor((totalMonstersKilledInGroup + totalMonstersKilledSolo) / (timePlayed / 60 / 60) * 10) / 10
      killsPerHourFS:SetText(killsPerHour .. '/h') 
      table.insert(content.values.killsPerHour, killsPerHourFrame)
    end
  end
  
  -- 8 Killed
  if (stats.monstersKilledSolo ~= nil and stats.monstersKilledInGroup ~= nil) then
    local monstersKilledFrame = CreateFrame("Frame", nil, content)
    monstersKilledFrame:SetPoint("TOPLEFT", (80 *8) -40, -15)
    monstersKilledFrame:SetSize(1,1)
    local monstersKilledFS = monstersKilledFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledFS:SetPoint("CENTER")
    monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledFS:SetText(totalMonstersKilledInGroup + totalMonstersKilledSolo) 
    table.insert(content.values.monstersKilled, monstersKilledFrame)
  end

    -- 9 Deaths
  if (stats.deaths ~= nil) then
    local deathsFrame = CreateFrame("Frame", nil, content)
    deathsFrame:SetPoint("TOPLEFT", (80 *9) -40, -15)
    deathsFrame:SetSize(1,1)
    local deathsFS = deathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    deathsFS:SetPoint("CENTER")
    deathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    deathsFS:SetText(totalDeaths) 
    table.insert(content.values.deaths, deathsFrame)
  end
    
    -- 10 Quests Completed
  if (stats.questsCompleted ~= nil) then
    local questsCompletedFrame = CreateFrame("Frame", nil, content)
    questsCompletedFrame:SetPoint("TOPLEFT", (80 *10) -40, -15)
    questsCompletedFrame:SetSize(1,1)
    local questsCompletedFS = questsCompletedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    questsCompletedFS:SetPoint("CENTER")
    questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    questsCompletedFS:SetText(totalQuestsCompleted) 
    table.insert(content.values.questsCompleted, questsCompletedFrame)
  end

    -- 11 Mob XP
  if (stats.XPFromMobs ~= nil) then
    local XPFromMobsFrame = CreateFrame("Frame", nil, content)
    XPFromMobsFrame:SetPoint("TOPLEFT", (80 *11) -40, -15)
    XPFromMobsFrame:SetSize(1,1)
    local XPFromMobsFS = XPFromMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    XPFromMobsFS:SetPoint("CENTER")
    XPFromMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    XPFromMobsFS:SetText(totalXPFromMobs) 
    table.insert(content.values.XPFromMobs, XPFromMobsFrame)
  end

    -- 12 Quest XP
  if (stats.XPFromQuests ~= nil) then
    local XPFromQuestsFrame = CreateFrame("Frame", nil, content)
    XPFromQuestsFrame:SetPoint("TOPLEFT", (80 *12) -40, -15)
    XPFromQuestsFrame:SetSize(1,1)
    local XPFromQuestsFS = XPFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    XPFromQuestsFS:SetPoint("CENTER")
    XPFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    XPFromQuestsFS:SetText(totalXPFromQuests) 
    table.insert(content.values.XPFromQuests, XPFromQuestsFrame)
  end
    
  -- 13 XP Per Hour
  if (toon.levelData[#toon.levelData] ~= nil) then
    local xpPerHourFrame = CreateFrame("Frame", nil, content)
    xpPerHourFrame:SetPoint("TOPLEFT", (80 *13) -40, -15)
    xpPerHourFrame:SetSize(1,1)
    local xpPerHourFS = xpPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    xpPerHourFS:SetPoint("CENTER")
    xpPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    local timePlayed = toon.levelData[#toon.levelData].timePlayed
    local totalXP = toon.levelData[#toon.levelData].totalXP
    local xpPerHour = math.floor(totalXP / (timePlayed / 60 / 60))
    xpPerHourFS:SetText(xpPerHour .. '/h') 
    table.insert(content.values.xpPerHour, xpPerHourFrame)
  end
    
    -- 14 Percent XP Gained Mobs
  if (stats.XPFromMobs ~= nil) then
    local percentXPMobsFrame = CreateFrame("Frame", nil, content)
    percentXPMobsFrame:SetPoint("TOPLEFT", (80 *14) -40, -15)
    percentXPMobsFrame:SetSize(1,1)
    local percentXPMobsFS = percentXPMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    percentXPMobsFS:SetPoint("CENTER")
    percentXPMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    local percent = math.floor((totalXPFromMobs / totalXP) * 100) 
    if (percent > 100) then percent = 100 end
    percentXPMobsFS:SetText(percent .. "%")
    table.insert(content.values.percentXPMobs, percentXPMobsFrame)
  end

    -- 15 Percent XP Gained Quests
  if (stats.XPFromQuests ~= nil) then
    local percentXPQuestsFrame = CreateFrame("Frame", nil, content)
    percentXPQuestsFrame:SetPoint("TOPLEFT", (80 *15) -40, -15)
    percentXPQuestsFrame:SetSize(1,1)
    local percentXPQuestsFS = percentXPQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    percentXPQuestsFS:SetPoint("CENTER")
    percentXPQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    local percent = math.floor((totalXPFromQuests / totalXP) * 100)
    if (percent > 100) then percent = 100 end
    percentXPQuestsFS:SetText(percent .. "%")
    table.insert(content.values.percentXPQuests, percentXPQuestsFrame)
  end

  -- 16 Time Played
  if (toon.levelData[#toon.levelData] ~= nil) then
    local timePlayedFrame = CreateFrame("Frame", nil, content)
    timePlayedFrame:SetPoint("TOPLEFT", (80 *16) -40, -15)
    timePlayedFrame:SetSize(1,1)
    local timePlayedFS = timePlayedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    timePlayedFS:SetPoint("CENTER")
    timePlayedFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local days, hours, minutes, seconds = XPC:TimeFormat(toon.levelData[#toon.levelData].timePlayed)
    if (days >= 1) then 
      timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
    else
      timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
    end
    table.insert(content.values.timePlayedAtLevel, timePlayedFrame)
  end

  -- 18 Time in Combat
  if (stats.timeInCombat ~= nil) then
    local timeInCombatFrame = CreateFrame("Frame", nil, content)
    timeInCombatFrame:SetPoint("TOPLEFT", (80 *18) -40, -15)
    timeInCombatFrame:SetSize(1,1)
    local timeInCombatFS = timeInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    timeInCombatFS:SetPoint("CENTER")
    timeInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local days, hours, minutes, seconds = XPC:TimeFormat(totalTimeInCombat)
    if (days >= 1) then 
      timeInCombatFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
    else
      timeInCombatFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
    end
    table.insert(content.values.timeInCombat, timeInCombatFrame)
  end
  
  -- 19 Percent Time In Combat
  if (stats.timeInCombat ~= nil) then
    if (toon.levelData[#toon.levelData] ~= nil) then
      local percentInCombatFrame = CreateFrame("Frame", nil, content)
      percentInCombatFrame:SetPoint("TOPLEFT", (80 *19) -40, -15)
      percentInCombatFrame:SetSize(1,1)
      local percentInCombatFS = percentInCombatFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      percentInCombatFS:SetPoint("CENTER")
      percentInCombatFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      percentInCombatFS:SetText(math.floor((totalTimeInCombat / toon.levelData[#toon.levelData].timePlayed) * 100) .. "%")
      table.insert(content.values.percentInCombat, percentInCombatFrame)
    end
  end

    -- 20 Time AFK
  if (stats.timeAFK ~= nil) then
    local timeAFKFrame = CreateFrame("Frame", nil, content)
    timeAFKFrame:SetPoint("TOPLEFT", (80 *20) -40, -15)
    timeAFKFrame:SetSize(1,1)
    local timeAFKFS = timeAFKFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    timeAFKFS:SetPoint("CENTER")
    timeAFKFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    local days, hours, minutes, seconds = XPC:TimeFormat(totalTimeAFK)
    if (days >= 1) then 
      timeAFKFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
    else
      timeAFKFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
    end
    table.insert(content.values.timeAFK, timeAFKFrame)
  end

    -- 21 Gold From Loot
  if (stats.goldFromLoot ~= nil) then
    local goldFromLootFrame = CreateFrame("Frame", nil, content)
    goldFromLootFrame:SetPoint("TOPLEFT", (80 *21) -40, -15)
    goldFromLootFrame:SetSize(1,1)
    local goldFromLootFS = goldFromLootFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    goldFromLootFS:SetPoint("CENTER")
    goldFromLootFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local gold, silver, copper = XPC:MoneyFormat(totalGoldFromLoot)
    goldFromLootFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
    table.insert(content.values.goldFromLoot, goldFromLootFrame)
  end
    
    -- 22 Quest Gold
  if (stats.goldFromQuests ~= nil) then
    local goldFromQuestsFrame = CreateFrame("Frame", nil, content)
    goldFromQuestsFrame:SetPoint("TOPLEFT", (80 *22) -40, -15)
    goldFromQuestsFrame:SetSize(1,1)
    local goldFromQuestsFS = goldFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    goldFromQuestsFS:SetPoint("CENTER")
    goldFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local gold, silver, copper = XPC:MoneyFormat(totalGoldFromQuests)
    goldFromQuestsFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
    table.insert(content.values.goldFromQuests, goldFromQuestsFrame)
  end

    -- 23 Gold Gained Merchant
  if (stats.goldGainedMerchant ~= nil) then
    local goldGainedMerchantFrame = CreateFrame("Frame", nil, content)
    goldGainedMerchantFrame:SetPoint("TOPLEFT", (80 *23) -40, -15)
    goldGainedMerchantFrame:SetSize(1,1)
    local goldGainedMerchantFS = goldGainedMerchantFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    goldGainedMerchantFS:SetPoint("CENTER")
    goldGainedMerchantFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local gold, silver, copper = XPC:MoneyFormat(totalGoldGainedMerchant)
    goldGainedMerchantFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
    table.insert(content.values.goldGainedMerchant, goldGainedMerchantFrame)
  end

    -- 24 Gold Gained Total
  if (stats.goldGainedMerchant ~= nil  and stats.goldFromLoot ~= nil and stats.goldFromQuests ~= nil) then
    local goldTotalFrame = CreateFrame("Frame", nil, content)
    goldTotalFrame:SetPoint("TOPLEFT", (80 *24) -40, -15)
    goldTotalFrame:SetSize(1,1)
    local goldTotalFS = goldTotalFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    goldTotalFS:SetPoint("CENTER")
    goldTotalFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local gold, silver, copper = XPC:MoneyFormat(totalGoldGainedMerchant + totalGoldFromLoot + totalGoldFromQuests)
    goldTotalFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
    table.insert(content.values.goldTotal, goldTotalFrame)
  end

    -- 25 Gold Lost Merchant
  if (stats.goldLostMerchant ~= nil) then
    local goldLostMerchantFrame = CreateFrame("Frame", nil, content)
    goldLostMerchantFrame:SetPoint("TOPLEFT", (80 *25) -40, -15)
    goldLostMerchantFrame:SetSize(1,1)
    local goldLostMerchantFS = goldLostMerchantFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    goldLostMerchantFS:SetPoint("CENTER")
    goldLostMerchantFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local gold, silver, copper = XPC:MoneyFormat(totalGoldLostMerchant)
    goldLostMerchantFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
    table.insert(content.values.goldLostMerchant, goldLostMerchantFrame)
  end

    -- 26 Duels Won
  if (stats.duelsWon ~= nil) then
    local duelsWonFrame = CreateFrame("Frame", nil, content)
    duelsWonFrame:SetPoint("TOPLEFT", (80 *26) -40, -15)
    duelsWonFrame:SetSize(1,1)
    local duelsWonFS = duelsWonFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    duelsWonFS:SetPoint("CENTER")
    duelsWonFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    duelsWonFS:SetText(totalDuelsWon) 
    table.insert(content.values.duelsWon, duelsWonFrame)
  end
    
    -- 27 Duels Lost
  if (stats.duelsLost ~= nil) then
    local duelsLostFrame = CreateFrame("Frame", nil, content)
    duelsLostFrame:SetPoint("TOPLEFT", (80 *27) -40, -15)
    duelsLostFrame:SetSize(1,1)
    local duelsLostFS = duelsLostFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    duelsLostFS:SetPoint("CENTER")
    duelsLostFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    duelsLostFS:SetText(totalDuelsLost) 
    table.insert(content.values.duelsLost, duelsLostFrame)
  end

    -- 28 Honor Kills
  if (stats.honorKills ~= nil) then
    local honorKillsFrame = CreateFrame("Frame", nil, content)
    honorKillsFrame:SetPoint("TOPLEFT", (80 *28) -40, -15)
    honorKillsFrame:SetSize(1,1)
    local honorKillsFS = honorKillsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    honorKillsFS:SetPoint("CENTER")
    honorKillsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    honorKillsFS:SetText(totalHonorKills) 
    table.insert(content.values.honorKills, honorKillsFrame)
  end

    -- 29 Honor
  if (stats.honor ~= nil) then
    local honorFrame = CreateFrame("Frame", nil, content)
    honorFrame:SetPoint("TOPLEFT", (80 *29) -40, -15)
    honorFrame:SetSize(1,1)
    local honorFS = honorFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    honorFS:SetPoint("CENTER")
    honorFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    honorFS:SetText(totalHonor) 
    table.insert(content.values.honor, honorFrame)
  end
    
    -- 30 Food
  if (stats.food ~= nil) then
    local foodFrame = CreateFrame("Frame", nil, content)
    foodFrame:SetPoint("TOPLEFT", (80 *30) -40, -15)
    foodFrame:SetSize(1,1)
    local foodFS = foodFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    foodFS:SetPoint("CENTER")
    foodFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    foodFS:SetText(totalFood) 
    table.insert(content.values.food, foodFrame)
  end

    -- 31 Drink
  if (stats.drink ~= nil) then
    local drinkFrame = CreateFrame("Frame", nil, content)
    drinkFrame:SetPoint("TOPLEFT", (80 *31) -40, -15)
    drinkFrame:SetSize(1,1)
    local drinkFS = drinkFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    drinkFS:SetPoint("CENTER")
    drinkFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    drinkFS:SetText(totalDrink) 
    table.insert(content.values.drink, drinkFrame)
  end

    -- 32 Bandages
  if (stats.bandages ~= nil) then
    local bandagesFrame = CreateFrame("Frame", nil, content)
    bandagesFrame:SetPoint("TOPLEFT", (80 *32) -40, -15)
    bandagesFrame:SetSize(1,1)
    local bandagesFS = bandagesFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    bandagesFS:SetPoint("CENTER")
    bandagesFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    bandagesFS:SetText(totalBandages) 
    table.insert(content.values.bandages, bandagesFrame)
  end

    -- 33 Healing Potions
  if (stats.healingPotions ~= nil) then
    local healingPotionsFrame = CreateFrame("Frame", nil, content)
    healingPotionsFrame:SetPoint("TOPLEFT", (80 *33) -40, -15)
    healingPotionsFrame:SetSize(1,1)
    local healingPotionsFS = healingPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    healingPotionsFS:SetPoint("CENTER")
    healingPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    healingPotionsFS:SetText(totalHealingPotions) 
    table.insert(content.values.healingPotions, healingPotionsFrame)
  end

    -- 34 Mana Potions
  if (stats.manaPotions ~= nil) then
    local manaPotionsFrame = CreateFrame("Frame", nil, content)
    manaPotionsFrame:SetPoint("TOPLEFT", (80 *34) -40, -15)
    manaPotionsFrame:SetSize(1,1)
    local manaPotionsFS = manaPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    manaPotionsFS:SetPoint("CENTER")
    manaPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    manaPotionsFS:SetText(totalManaPotions) 
    table.insert(content.values.manaPotions, manaPotionsFrame)
  end

    -- 35 Mana/Healing Potions
  if (stats.MHPotions ~= nil) then
    local MHPotionsFrame = CreateFrame("Frame", nil, content)
    MHPotionsFrame:SetPoint("TOPLEFT", (80 *35) -40, -15)
    MHPotionsFrame:SetSize(1,1)
    local MHPotionsFS = MHPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    MHPotionsFS:SetPoint("CENTER")
    MHPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    MHPotionsFS:SetText(totalMHPotions) 
    table.insert(content.values.MHPotions, MHPotionsFrame)
  end

    -- 36 Potions
  if (stats.potions ~= nil) then
    local potionsFrame = CreateFrame("Frame", nil, content)
    potionsFrame:SetPoint("TOPLEFT", (80 *36) -40, -15)
    potionsFrame:SetSize(1,1)
    local potionsFS = potionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    potionsFS:SetPoint("CENTER")
    potionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    potionsFS:SetText(totalPotions) 
    table.insert(content.values.potions, potionsFrame)
  end

    -- 37 Elixirs
  if (stats.elixirs ~= nil) then
    local elixirsFrame = CreateFrame("Frame", nil, content)
    elixirsFrame:SetPoint("TOPLEFT", (80 *37) -40, -15)
    elixirsFrame:SetSize(1,1)
    local elixirsFS = elixirsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    elixirsFS:SetPoint("CENTER")
    elixirsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    elixirsFS:SetText(totalElixirs) 
    table.insert(content.values.elixirs, elixirsFrame)
  end

    -- 38 Flasks
  if (stats.flasks ~= nil) then
    local flasksFrame = CreateFrame("Frame", nil, content)
    flasksFrame:SetPoint("TOPLEFT", (80 *38) -40, -15)
    flasksFrame:SetSize(1,1)
    local flasksFS = flasksFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    flasksFS:SetPoint("CENTER")
    flasksFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    flasksFS:SetText(totalFlasks) 
    table.insert(content.values.flasks, flasksFrame)
  end

    -- 39 Scrolls
  if (stats.scrolls ~= nil) then
    local scrollsFrame = CreateFrame("Frame", nil, content)
    scrollsFrame:SetPoint("TOPLEFT", (80 *39) -40, -15)
    scrollsFrame:SetSize(1,1)
    local scrollsFS = scrollsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    scrollsFS:SetPoint("CENTER")
    scrollsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    scrollsFS:SetText(totalScrolls) 
    table.insert(content.values.scrolls, scrollsFrame)
  end

    -- 40 Hearthstones
  if (stats.hearthstone ~= nil) then
    local hearthstoneFrame = CreateFrame("Frame", nil, content)
    hearthstoneFrame:SetPoint("TOPLEFT", (80 *40) -40, -15)
    hearthstoneFrame:SetSize(1,1)
    local hearthstoneFS = hearthstoneFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    hearthstoneFS:SetPoint("CENTER")
    hearthstoneFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    hearthstoneFS:SetText(totalHearthstone) 
    table.insert(content.values.hearthstone, hearthstoneFrame)
  end
    
    -- 41 Dungeons
  if (stats.dungeonsEntered ~= nil) then
    local dungeonsFrame = CreateFrame("Frame", nil, content)
    dungeonsFrame:SetPoint("TOPLEFT", (80 *41) -40, -15)
    dungeonsFrame:SetSize(1,1)
    local dungeonsFS = dungeonsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    dungeonsFS:SetPoint("CENTER")
    dungeonsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    dungeonsFS:SetText(totalDungeons) 
    table.insert(content.values.dungeons, dungeonsFrame)
  end

    -- 42 Flight Paths
  if (stats.flightPaths ~= nil) then
    local flightPathsFrame = CreateFrame("Frame", nil, content)
    flightPathsFrame:SetPoint("TOPLEFT", (80 *42) -40, -15)
    flightPathsFrame:SetSize(1,1)
    local flightPathsFS = flightPathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    flightPathsFS:SetPoint("CENTER")
    flightPathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    flightPathsFS:SetText(totalFlightPaths) 
    table.insert(content.values.flightPaths, flightPathsFrame)
  end

    -- 43 Time on Taxi
  if (stats.timeOnTaxi ~= nil) then
    local timeOnTaxiFrame = CreateFrame("Frame", nil, content)
    timeOnTaxiFrame:SetPoint("TOPLEFT", (80 *43) -40, -15)
    timeOnTaxiFrame:SetSize(1,1)
    local timeOnTaxiFS = timeOnTaxiFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    timeOnTaxiFS:SetPoint("CENTER")
    timeOnTaxiFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
    local days, hours, minutes, seconds = XPC:TimeFormat(totalTimeOnTaxi)
    if (days >= 1) then 
      timeOnTaxiFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
    else
      timeOnTaxiFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
    end
    table.insert(content.values.timeOnTaxi, timeOnTaxiFrame)
  end

  chart:Show()
end

function XPC:BuildChooseToon()
  -- choose toon window
  XPC_GUI.main.single.chooseToon = CreateFrame("Frame", chooseToon, XPC_GUI.main, "InsetFrameTemplate")
  local chooseToon = XPC_GUI.main.single.chooseToon
  chooseToon:SetSize(290, 280)
  chooseToon:SetPoint("TOPRIGHT", -60, -60)
  chooseToon:SetMovable(true)
  chooseToon:EnableMouse(true)
  chooseToon:RegisterForDrag('LeftButton')
  chooseToon:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  chooseToon:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)

  -- close button 
  local closeBtn = CreateFrame("Button", closeBtn, chooseToon, "UIPanelCloseButtonNoScripts")
  closeBtn:SetPoint("TOPRIGHT")
  closeBtn:SetScript('OnClick', function() chooseToon:Hide() end)

  -- scroll frame
  chooseToon.scroll = CreateFrame("ScrollFrame", scroll, chooseToon, 'UIPanelScrollFrameTemplate')
  local scroll = chooseToon.scroll
  scroll:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
  scroll:SetPoint("TOPRIGHT", -31, -30)
  scroll:SetSize(250,245)

  -- content 
  scroll.content = CreateFrame("Frame", content)
  local content = scroll.content
  content:SetPoint("TOPLEFT")
  content:SetSize(250, XPC.numOfToons * 30 + 30)
  content:SetClipsChildren(true)
  scroll:SetScrollChild(content)

  -- make line for each toon
  local i = 0
  for k, toon in pairs(XPC.db.global.toons) do
    -- toon name
    local name = content:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
    name:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
    name:SetPoint("TOPLEFT", 5, (i * -30) -5)
    name:SetText(k)
    local nameBtn = CreateFrame("Button", nil, content)
    nameBtn:SetSize(250, 22)
    nameBtn:SetPoint("TOPLEFT", 5, (i * -30) -2)
    nameBtn:SetScript("OnClick", function() 
      XPC.currSingleToon = k  
      XPC:ShowSingleToonChart()
    end)

    i = i + 1
  end 

  chooseToon:Hide()
end

function XPC:StatsTracker()
  XPC_GUI.statsTracker = CreateFrame("Frame", statsTracker)
  local tracker = XPC_GUI.statsTracker
  local stats = XPC.db.global.toons[XPC.currSingleToon].statsData[tostring(UnitLevel('player'))]
  local foods = {25691, 25690, 25692, 25693, 24707, 29029, 434, 18229, 10257, 22731, 25695, 25700, 26401, 26260, 26472, 29008, 1131, 435, 18231, 18232, 18234, 24869, 6410, 28616, 25886, 433, 7737, 2639, 10256, 24800, 1127, 1129, 25660, 5006, 5005, 5007, 18233, 24005, 5004, 18230, 29073, 53283, 58886, 29073, 28616, 33266, 46898, 43777, 33253, 33269, 33260, 48720, 43180, 33264, 35270, 33255, 61829, 57069, 46812, 42308, 41030, 40768, 35271, 45618, 33725, 57084, 43763, 40745, 33262, 33258, 45548}
  local drinks = {25691, 25690, 25692, 25693, 24707, 29029, 430, 24355, 1135, 26475, 22734, 1133, 432, 1137, 26473, 10250, 25696, 26261, 29007, 44114, 10250, 22734, 34291, 65363, 69560, 49472, 44116, 43706, 61830, 44115, 27089, 69561, 45020, 43182, 52911, 43183}
  -- potionItemIDs = {9030,5634,13444,13457,5816,929,13446,3823,13443,3387,2459,13442,9172,20008,6149,3928,1710,6049,3827,6372,5633,13461,13455,858,9144,13462,3385,13459,6048,5631,13458,118,2455,13506,12190,18253,23579,20002,13456,4623,6052,3386,2456,6051,5632,13460,6050,18841,4596,23578,18839,1450,17348,3087,17351,17349,23696,23698,17352, i:40211,i:40212,i:40093,i:33448,i:42545,i:40081,i:39671,i:33447,i:40077,i:40067,i:41166,i:40087,i:40216,i:40217,i:40214,i:40215,i:40213, i:22832,i:22829,i:34440,i:22836,i:28100,i:33093,i:22838,i:22841,i:22850,i:22845,i:22849,i:22842,i:31677,i:33092,i:22828,i:22844,i:22847,i:22871,i:22839,i:22846,i:22826,i:31676,i:22837,i:28101}
  local potionSpellIDs = {11359, 6615, 17543, 6724, 3680, 3169, 2379, 17528, 11392, 24364, 7233, 7840, 6613, 17549, 17540, 17550, 17548, 7242, 6612, 17546, 17624, 15822, 24360, 17544, 4941, 7254, 26677, 7245, 6614, 17545, 7239, 806, 53908, 53909, 53762, 53914, 53915, 53911, 53913, 53910, 28504, 28507, 28511, 28512, 28515, 28536, 28517, 28494, 28492, 28537, 28508, 28548, 28538, 28513, 28506}
  local healingPotionSpellIDs = {441, 17534, 4042, 2024, 440, 439, 17534, 21393, 21394, 28495, 43185, 67489, 17534, 67486, 38908, }
  local manaPotionSpellIDs = {17530, 17531, 11903, 2023, 438, 437, 29236, 21395, 21396, 43186, 67490, 28499, 67487, 38929, }
  local wildVineSpellIDs = {11387, 22729, 2370, 53753, 53750, 53761, 45051, }
  -- elixirItemIDs = {9155,10592,8949,13453,3389,9224,9233,3828,9154,9197,6373,3825,17708,6662,9206,9187,8951,21546,9179,18294,3390,2454,2457,5997,2458,3391,9264,13445,13452,13447,5996,8827,3383,9088,13454,20007,3826,20004,3388,3382, i:40070,i:44012,i:40073,i:39666,i:45621,i:44332,i:44327,i:40072,i:44331,i:40076,i:40109,i:44330,i:44329,i:40068,i:40078,i:40097,i:44328,i:37449,i:44325 i:22831,i:32067,i:22840,i:22825,i:28103,i:22835,i:32062,i:28104,i:22834,i:22833,i:32068,i:31679,i:22824,i:32063,i:22848,i:25539,i:28102,i:22827,i:22823,i:22830,i:23871,i:23444,i:34537,i:34130}
  local elixirSpellIDs = {3219, 11390, 12608, 11328, 17537, 3220, 11406, 11407, 6512, 11389, 11403, 7844, 3593, 21920, 8212, 11405, 11334, 11349, 26276, 11396, 22807, 3160, 2367, 2374, 673, 2378, 3164, 11474, 11348, 17538, 17535, 7178, 11319, 3166, 11371, 17539, 24363, 3223, 24361, 3222, 33721, 59640, 53748, 28497, 63729, 60347, 60341, 53747, 60346, 53749, 53764, 60345, 60344, 53746, 53751, 53763, 60343, 48719, 60340, 54494, 39627, 28509, 28491, 54452, 28503, 39625, 33726, 28502, 28501, 39628, 38954, 28490, 39626, 28514, 22807, 33720, 28493, 28489, 28496, 7178, 29348, 45373, 44467}
  -- flaskItemIDs = {13510,13512,13511,13506,13513, i:22854,i:22866,i:22861,i:32901,i:33208,i:22851,i:35716,i:13511,i:22853,i:32898,i:13512,i:35717,i:32900,i:32899,i:32598,i:32601,i:13513,i:32599,i:32600,i:32597,i:32596,i:13510, i:46376,i:40082,i:46377,i:46378,i:40404,i:40084,i:40083,i:46379,i:40079,i:44939}
  local flaskSpellIDs = {17629, 17624, 17627, 17628, 17626, 28520, 28540, 28521, 41608, 42735, 28518, 46837, 17627, 28519, 41609, 17628, 46839, 41611, 41610, 40572, 40576, 17629, 40567, 40573, 40575, 40568, 17626, 53755, 53760, 54212, 53758, 53752, 62380}
  -- scrollItemIDs = {i:955,i:1180,i:3012,i:1711,i:2290,i:3013,i:4425,i:4419,i:1478,i:4421,i:4422,i:10305,i:954,i:1477,i:4426,i:2289,i:10307,i:10308,i:10309,i:10310,i:27503,i:27498,i:27500,i:27502,i:27499,i:43465,i:33458,i:37091,i:43467,i:37093,i:43463,i:33457,i:33459,i:33462,i:33461,i:37092,i:43466,i:37094,i:43464}
  local scrollSpellIDs = {8112, 8113, 8114, 12177, 33080, 43197, 48103, 48104, 8096, 8099, 8115, 8100, 8097, 8091, 8117, 8094, 8095, 8101, 12175, 8118, 8116, 8120, 8119, 12178, 12176, 12174, 12179, 33082, 33077, 33079, 33081, 33078, 58448, 43195, 48099, 58452, 48101, 58450, 43194, 43196, 43199, 43198, 48100, 58449, 48102, 58451}
  local bandageSpellIDs = {746, 1159, 3267, 3268, 7926, 7927, 10838, 10839, 18608, 18610, 27030, 27031, 45543, 51827, 45544, 51803}
  local potionBuffNames = {
    "Free Action",
    "Living Free Action",
    "Noggenfogger Elixir",
    "Fire Protection",
    "Nature Protection",
    "Shadow Protection",
    "Frost Protection",
    "Holy Protection",
    "Arcane Protection",
    "Restoration",
    "Mana Regeneration",
    "Speed",
    "Swim Speed", 
    "Regeneration",
    "Greater Stoneshield",
    "Stoneshield",
    "Invulnerability",
    "Lesser Invisibility",
    "Invisibility",
    "Resistance",
    "Spirit of Boar",
    "Rage of Ages",
    "Strike of the Scorpok",
    "Spiritual Domination",
    "Infallible Mind",
    "Greater Dreamless Sleep",
    "Dreamless Sleep",
    "Purification",
    "Mighty Rage",
    "Great Rage",
    "Rage",
    "Frost Resistance",
  }
  local scrollBuffNames = {
    "Armor",
    "Spirit",
    "Intellect",
    "Agility",
    "Stamina",
    "Strength",
  }
  local elixirBuffNames = {
    "Arcane Elixir",
    "Greater Arcane Elixir",
    "Shadow Power",
    "Fire Power",
    "Greater Fire Power",
    "Frost Power",
    "Elixir of the Mongoose",
    "Elixir of the Giants",
    "Elixir of Brute Force",
    "Elixir of the Sages",
    "Elixir of Demonslaying",
    "Agility",
    "Minor Agility",
    "Lesser Agility",
    "Greater Agility",
    "Health",
    "Health II",
    "Lesser Intellect",
    "Greater Intellect",
    "Enlarge",
    "Strength",
    "Lesser Strength",
    "Armor",
    "Lesser Armor",
    "Greater Armor",
    "Cure Poison",
    "Water Breathing",
    "Greater Water Breathing",
    "Detect Undead",
    "Posion Resistance",
    "Detect Lesser Invisibility",
    "Detect Demon",
    "Stealth Detection",
    "Winterfall Firewater"
  }
  local flaskBuffNames = {
    "Supreme Power",
    "Flask of the Titans",
    "Flask of Chromatic Resistance",
    "Distilled Wisdom",
    "Petrification",
  }
  local timeAFK = 0

  tracker:RegisterEvent("PLAYER_LEVEL_UP")
  tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  tracker:RegisterEvent("QUEST_COMPLETE")
  tracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  tracker:RegisterEvent("TAXIMAP_CLOSED")
  tracker:RegisterEvent("CHAT_MSG_SYSTEM")
  tracker:RegisterEvent("PLAYER_ENTERING_WORLD")
  tracker:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
  tracker:RegisterEvent("QUEST_TURNED_IN")
  tracker:RegisterEvent("PLAYER_DEAD")
  tracker:RegisterEvent("CHAT_MSG_MONEY")
  tracker:RegisterEvent("PLAYER_MONEY")
  tracker:RegisterEvent("MERCHANT_CLOSED")
  tracker:RegisterEvent("MERCHANT_SHOW")
  tracker:RegisterEvent("DUEL_FINISHED")
  tracker:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")
  tracker:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
  tracker:RegisterEvent("PLAYER_REGEN_DISABLED")
  tracker:RegisterEvent("PLAYER_REGEN_ENABLED")

  tracker:SetScript("OnEvent", function(self, event, ...) 
  
    -- Combat Time Tracker
    if (event == "PLAYER_REGEN_DISABLED") then
      XPC.combatTime = GetTime()
    end
    if (event == "PLAYER_REGEN_ENABLED") then
      stats.timeInCombat = stats.timeInCombat + (GetTime() - XPC.combatTime)
      XPC.combatTime = 0
    end
    
    -- Honor Gained Tracker
    if (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
      local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...
      local l = string.match(text, "%d")
      stats.honor = stats.honor + l
    end

    -- Honor Kill Tracker
    if (event == "PLAYER_PVP_KILLS_CHANGED") then
      stats.honorKills = stats.honorKills + 1
    end

    -- Duel Tracker
    if (event == "DUEL_FINISHED") then
      C_Timer.After(.1, function()
        if (UnitHealth('target') == 1) then
          stats.duelsWon = stats.duelsWon + 1
        end
      end)
      C_Timer.After(.1, function()
        if (UnitHealth('player') == 1) then
          stats.duelsLost = stats.duelsLost + 1
        end
      end)
    end

    -- Gold Gained / Lost Merchant Tracker
    if (event == "MERCHANT_SHOW") then
      XPC.prevMoney = GetMoney()
      XPC.merchantShow = true
    end
    if (event == "MERCHANT_CLOSED") then
      XPC.prevMoney = 0
      XPC.merchantShow = false
    end
    if (event == "PLAYER_MONEY" and XPC.merchantShow == true) then
      local currMoney = GetMoney()
      if (currMoney > XPC.prevMoney) then
        stats.goldGainedMerchant = stats.goldGainedMerchant + (currMoney - XPC.prevMoney)
      end
      if (currMoney < XPC.prevMoney) then
        stats.goldLostMerchant = stats.goldLostMerchant + (XPC.prevMoney - currMoney)
      end
      XPC.prevMoney = currMoney
    end

    -- Gold Looted Tracker
    if (event == "CHAT_MSG_MONEY") then
      local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...
      local gold = string.match(text, "%d+")
      stats.goldFromLoot = stats.goldFromLoot + gold
    end

    -- Deaths Tracker
    if (event == "PLAYER_DEAD") then
      stats.deaths = stats.deaths + 1
    end

    -- Mob XP Tracker 
    if (event == "CHAT_MSG_COMBAT_XP_GAIN") then
      local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...
      local xp = string.match(text, "%d+")
      stats.XPFromMobs = stats.XPFromMobs + xp
    end

    -- Quest Tracker 
    if (event == "QUEST_TURNED_IN") then
      local questID, xpReward, moneyReward = ...
      stats.XPFromQuests = stats.XPFromQuests + xpReward
      stats.goldFromQuests = stats.goldFromQuests + moneyReward
    end

    -- Instance Tracker
    if (event == "PLAYER_ENTERING_WORLD") then
      local isInitialLogin, isReloadingUi = ...
      local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
      if (isReloadingUi == false) then
        if (instanceType == 'party' or instanceType == 'raid') then
          stats.dungeonsEntered = stats.dungeonsEntered + 1
        end
      end
    end

    -- AFK tracker
    if (event == "CHAT_MSG_SYSTEM") then
      local msg = ...
      if (msg == 'You are now AFK: Away from Keyboard') then
        XPC.isAFK = true
        local function counter() 
          C_Timer.After(1, function() 
            if (XPC.isAFK == true) then
              timeAFK = timeAFK + 1
              counter()
            end
          end)
        end
        counter()
      end
      if (msg == 'You are no longer AFK.') then
        stats.timeAFK = stats.timeAFK + timeAFK
        XPC.isAFK = false
        timeAFK = 0
      end
    end
    
    -- taxi tracker
    if (event == "TAXIMAP_CLOSED" and XPC.justStartedFlightPath == false) then
      XPC.justStartedFlightPath = true
      C_Timer.After(5, function() XPC.justStartedFlightPath = false end)
      C_Timer.After(1, function() 
        if (UnitOnTaxi('player')) then
          stats.flightPaths = stats.flightPaths + 1
        end
      end)
      local function loopx()
        C_Timer.After(1, function()
          if (UnitOnTaxi('player')) then
            stats.timeOnTaxi = stats.timeOnTaxi + 1
            loopx()
          end
        end)
      end
      loopx()
    end

    -- level up tracker
    if (event == "PLAYER_LEVEL_UP") then 
      local level, healthDelta, powerDelta, numNewTalents, numNewPvpTalentSlots, strengthDelta, agilityDelta, staminaDelta, intellectDelta = ...
      XPC.justLeveled = true
      XPC:CreateStatsData(level)    
      stats = XPC.db.global.toons[XPC.currSingleToon].statsData[tostring(level)]
      RequestTimePlayed()
    end
    
    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
      local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, a, b, c, d, e, f, g, h, i, j, k = CombatLogGetCurrentEventInfo()

      -- damage dealt tracker
      if (sourceName == GetUnitName("player")) then
        if (subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
          local spellId, spellName, spellSchool
          local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

          if subevent == "SWING_DAMAGE" then
            amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          elseif (subevent == "SPELL_DAMAGE"  or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
            spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          end

          stats.damageDealt = stats.damageDealt + amount 
        end
      end

      -- damage taken tracker
      if (destName == GetUnitName("player")) then
        if (subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
          local spellId, spellName, spellSchool
          local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

          if subevent == "SWING_DAMAGE" then
            amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          elseif (subevent == "SPELL_DAMAGE"  or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
            spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          end

          stats.damageTaken = stats.damageTaken + amount 
        end
      end

      -- heals given tracker
      if (sourceName == GetUnitName("player")) then
        if (subevent == "SWING_HEAL" or subevent == "SPELL_HEAL" or subevent == "RANGE_HEAL" or subevent == "SPELL_PERIODIC_HEAL" or subevent == "SPELL_BUILDING_HEAL" or subevent == "ENVIRONMENTAL_HEAL") then
          local spellId, spellName, spellSchool
          local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

          if subevent == "SWING_HEAL" then
            amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          elseif (subevent == "SPELL_HEAL"  or subevent == "RANGE_HEAL" or subevent == "SPELL_PERIODIC_HEAL" or subevent == "SPELL_BUILDING_HEAL" or subevent == "ENVIRONMENTAL_HEAL") then
            spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          end

          stats.healsGiven = stats.healsGiven + amount 
        end
      end

      -- heals given tracker
      if (destName == GetUnitName("player")) then
        if (subevent == "SWING_HEAL" or subevent == "SPELL_HEAL" or subevent == "RANGE_HEAL" or subevent == "SPELL_PERIODIC_HEAL" or subevent == "SPELL_BUILDING_HEAL" or subevent == "ENVIRONMENTAL_HEAL") then
          local spellId, spellName, spellSchool
          local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

          if subevent == "SWING_HEAL" then
            amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          elseif (subevent == "SPELL_HEAL"  or subevent == "RANGE_HEAL" or subevent == "SPELL_PERIODIC_HEAL" or subevent == "SPELL_BUILDING_HEAL" or subevent == "ENVIRONMENTAL_HEAL") then
            spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
          end

          stats.healsReceived = stats.healsReceived + amount 
        end
      end

      -- kill tracker
      if (subevent == "PARTY_KILL") then
        if (IsInGroup() or IsInRaid()) then
          stats.monstersKilledInGroup = stats.monstersKilledInGroup + 1
        else
          stats.monstersKilledSolo = stats.monstersKilledSolo + 1
        end 
      end
    end

    -- quest complete
    if (event == "QUEST_COMPLETE") then
      stats.questsCompleted = stats.questsCompleted + 1
    end

    if (event == "UNIT_SPELLCAST_SUCCEEDED") then
      local unit, castGUID, spellID = ...
      if (unit == 'player') then
        -- eating
        for i,v in ipairs(foods) do
          if (spellID == v) then
            stats.food = stats.food + 1
          end
        end
        -- drink
        for i,v in ipairs(drinks) do
          if (spellID == v) then
            stats.drink = stats.drink + 1
          end
        end
        -- hearthstone
        if (spellID == 8690) then
          stats.hearthstone = stats.hearthstone + 1
        end
        -- bandages
        for i,v in ipairs(bandageSpellIDs) do 
          if (spellID == v) then
            stats.bandages = stats.bandages + 1
          end
        end
        -- scrolls
        for i,v in ipairs(scrollSpellIDs) do
          if (spellID == v ) then
            stats.scrolls = stats.scrolls + 1
          end
        end
        -- potions
        for i,v in ipairs(potionSpellIDs) do
          if (spellID == v ) then
            stats.potions = stats.potions + 1
          end
        end      
        -- elixirs  
        for i,v in ipairs(elixirSpellIDs) do
          if (spellID == v ) then
            stats.elixirs = stats.elixirs + 1
          end
        end       
        -- flasks 
        for i,v in ipairs(flaskSpellIDs) do
          if (spellID == v ) then
            stats.flasks = stats.flasks + 1
          end
        end        
        -- Mana / Health Potions
        for i,v in ipairs(wildVineSpellIDs) do
          if (spellID == v ) then
            stats.MHPotions = stats.MHPotions + 1
          end
        end        
        -- Health Potions
        for i,v in ipairs(healingPotionSpellIDs) do
          if (spellID == v ) then
            stats.healingPotions = stats.healingPotions + 1
          end
        end        
        -- Mana Potions
        for i,v in ipairs(manaPotionSpellIDs) do
          if (spellID == v ) then
            stats.manaPotions = stats.manaPotions + 1
          end
        end             
      end
    end
  end)
end

function XPC:TimeFormat(timex)
  local days = math.floor(timex / 60 / 60 / 24) 
  local hours = math.floor(timex / 60 / 60) % 24
  local minutes = math.floor(timex / 60) % 60
  local seconds = math.floor(timex % 60)
  return days, hours, minutes, seconds
end

function XPC:MoneyFormat(money)
  local gold = math.floor(money  / 10000)
  local silver = math.floor(money / 100 % 100)
  local copper = math.floor(money % 100)
  return gold, silver, copper
end

--- ALl Tracked Items in Order ---

-- 1 dmg done
-- 2 dmg taken
-- 3 heals out
-- 4 heals in
 
-- 5 kills solo
-- 6 kills group
-- 7 kills / hour
-- 8 kills
-- 9 deaths
 
-- 10 quests
-- 11 mob xp
-- 12 quest xp
-- 13 xp / hour
-- 14 % XP mobs
-- 15 % xp quests
 
-- 16 time played
-- 17 level time
-- 18 combat time 
-- 19 % in combat
-- 20 time afk
 
-- 21 loot gold
-- 22 quests gold
-- 23 sold
-- 24 gold gained
-- 25 spent
 
-- 26 duels won
-- 27 duels lost
-- 28 hks
-- 29 honor
 
-- 30 food
-- 31 drink
-- 32 bandages
-- 33 health pots
-- 34 mana pots
-- 35 h/m pots
-- 36 potions
-- 37 elixirs
-- 38 flasks
-- 39 scrolls

-- 40 hearthstones
-- 41 dungeons
-- 42 taxis
-- 43 taxi time


-- move time trackers to first columns
-- change color of seperator lines for each column
-- make grid move without hiding label column/row
