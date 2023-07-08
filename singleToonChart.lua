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
  hSlider:SetValueStep(20)
  hSlider:SetMinMaxValues(1, 100)
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
    healingPotions = {},
    manaPotions = {},
    MHPotions = {},
    healsGiven = {},
    healsReceived = {},
    deaths = {},
    pvpDeaths = {},
    duelsWon = {},
    duelsLost = {},
    honorKills = {},
    flightPaths = {},
    timeAFK = {},
    timeInCombat = {},
    timePlayedAtLevel = {},
    levelTime = {},
    xpPerHour = {},
    XPFromQuests = {},
    XPFromMobs = {},
    dungeons = {},
    killsPerHour = {},
    hearthstone = {},
    goldFromQuests = {},
    goldFromLoot = {},
  }
  -- Vertical and Horizontal Line Seperator table init
  content.vLines = {}
  content.hLines = {}
  
  -- set size after content.values object init
  local j = 0 
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

  -- Horizonatl Border Line
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
  chart.dmgDone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.dmgDone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.dmgDone:SetPoint("TOPLEFT", 68, -20)
  chart.dmgDone:SetText('Dmg Done')
  chart.killsSolo = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsSolo:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsSolo:SetPoint("TOPLEFT", 152, -20)
  chart.killsSolo:SetText('Kills Solo')
  chart.killsGroup = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsGroup:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsGroup:SetPoint("TOPLEFT", 227, -20)
  chart.killsGroup:SetText('Kills Group')
  chart.kills = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.kills:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.kills:SetPoint("TOPLEFT", 327, -20)
  chart.kills:SetText('Kills')
  chart.questsCompleted = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.questsCompleted:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.questsCompleted:SetPoint("TOPLEFT", 399, -20)
  chart.questsCompleted:SetText('Quests')
  chart.food = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.food:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.food:SetPoint("TOPLEFT", 486, -20)
  chart.food:SetText('Food')
  chart.drink = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.drink:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.drink:SetPoint("TOPLEFT", 564, -20)
  chart.drink:SetText('Drink')
  chart.timePlayedAtLevel = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.timePlayedAtLevel:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.timePlayedAtLevel:SetPoint("TOPLEFT", 622, -20)
  chart.timePlayedAtLevel:SetText('Time Played')
  chart.levelTime = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.levelTime:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.levelTime:SetPoint("TOPLEFT", 708, -20)
  chart.levelTime:SetText('Level Time')
  chart.xpPerHour = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.xpPerHour:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.xpPerHour:SetPoint("TOPLEFT", 796, -20)
  chart.xpPerHour:SetText('XP/Hour')
  chart.killsPerHour = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsPerHour:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsPerHour:SetPoint("TOPLEFT", 870, -20)
  chart.killsPerHour:SetText('Kills/Hour')
  chart.flightPaths = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.flightPaths:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.flightPaths:SetPoint("TOPLEFT", 962, -20)
  chart.flightPaths:SetText('Taxis')
  chart.hearthstone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.hearthstone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.hearthstone:SetPoint("TOPLEFT", 1020, -20)
  chart.hearthstone:SetText('Hearthstones')
  chart.damageTaken = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.damageTaken:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.damageTaken:SetPoint("TOPLEFT", 1117, -20)
  chart.damageTaken:SetText('Dmg In')
  chart.HealsGiven = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsGiven:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsGiven:SetPoint("TOPLEFT", 1188, -20)
  chart.HealsGiven:SetText('Heals Out')
  chart.HealsReceived = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsReceived:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsReceived:SetPoint("TOPLEFT", 1276, -20)
  chart.HealsReceived:SetText('Heals In')
  chart.TimeAFK = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.TimeAFK:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.TimeAFK:SetPoint("TOPLEFT", 1352, -20)
  chart.TimeAFK:SetText('Time AFK')
  chart.dungeons = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.dungeons:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.dungeons:SetPoint("TOPLEFT", 1429, -20)
  chart.dungeons:SetText('Dungeons')
  chart.potions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.potions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.potions:SetPoint("TOPLEFT", 1510, -20)
  chart.potions:SetText('Misc Pots')
  chart.healingPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.healingPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.healingPotions:SetPoint("TOPLEFT", 1585, -20)
  chart.healingPotions:SetText('Health Pots')
  chart.manaPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.manaPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.manaPotions:SetPoint("TOPLEFT", 1669, -20)
  chart.manaPotions:SetText('Mana Pots')
  chart.healingPotions:SetText('Health Pots')
  chart.MHPotions = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.MHPotions:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.MHPotions:SetPoint("TOPLEFT", 1751, -20)
  chart.MHPotions:SetText('H/M Pots')
  chart.XPFromMobs = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.XPFromMobs:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.XPFromMobs:SetPoint("TOPLEFT", 1836, -20)
  chart.XPFromMobs:SetText('Mob XP')
  chart.XPFromQuests = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.XPFromQuests:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.XPFromQuests:SetPoint("TOPLEFT", 1912, -20)
  chart.XPFromQuests:SetText('Quest XP')
  chart.goldFromQuests = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldFromQuests:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldFromQuests:SetPoint("TOPLEFT", 1986, -20)
  chart.goldFromQuests:SetText('Quest Gold')
  chart.deaths = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.deaths:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.deaths:SetPoint("TOPLEFT", 2077, -20)
  chart.deaths:SetText('Deaths')
  chart.bandages = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.bandages:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.bandages:SetPoint("TOPLEFT", 2151, -20)
  chart.bandages:SetText('Bandages')
  chart.goldFromLoot = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.goldFromLoot:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.goldFromLoot:SetPoint("TOPLEFT", 2231, -20)
  chart.goldFromLoot:SetText('Loot Gold')

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
  local level = 1

  level = levelData[#levelData].level
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
  missedLevels = 0
  for i=level, 1, -1 do
    if (toon.statsData[tostring(i)] ~= nil) then 
      local v = toon.statsData[tostring(i)]
      local posY = ((level + 1) - i - missedLevels) * -30 -15

      -- Damage Dealt
      local damageDealtFrame = CreateFrame("Frame", nil, content)
      damageDealtFrame:SetPoint("TOPLEFT", 40, posY)
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
      
      -- Kills Solo
      local monstersKilledSoloFrame = CreateFrame("Frame", nil, content)
      monstersKilledSoloFrame:SetPoint("TOPLEFT", 120, posY)
      monstersKilledSoloFrame:SetSize(1,1)
      local monstersKilledSoloFS = monstersKilledSoloFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      monstersKilledSoloFS:SetPoint("CENTER")
      monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      monstersKilledSoloFS:SetText(v.monstersKilledSolo) 
      table.insert(content.values.monstersKilledSolo, monstersKilledSoloFrame)

      -- Kills Group
      local monstersKilledInGroupFrame = CreateFrame("Frame", nil, content)
      monstersKilledInGroupFrame:SetPoint("TOPLEFT", 200, posY)
      monstersKilledInGroupFrame:SetSize(1,1)
      local monstersKilledInGroupFS = monstersKilledInGroupFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      monstersKilledInGroupFS:SetPoint("CENTER")
      monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      monstersKilledInGroupFS:SetText(v.monstersKilledInGroup) 
      table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFrame)

      -- Kills
      local monstersKilledFrame = CreateFrame("Frame", nil, content)
      monstersKilledFrame:SetPoint("TOPLEFT", 280, posY)
      monstersKilledFrame:SetSize(1,1)
      local monstersKilledFS = monstersKilledFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      monstersKilledFS:SetPoint("CENTER")
      monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      monstersKilledFS:SetText(v.monstersKilledInGroup + v.monstersKilledSolo) 
      table.insert(content.values.monstersKilled, monstersKilledFrame)

      -- Quests Completed
      local questsCompletedFrame = CreateFrame("Frame", nil, content)
      questsCompletedFrame:SetPoint("TOPLEFT", 360, posY)
      questsCompletedFrame:SetSize(1,1)
      local questsCompletedFS = questsCompletedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      questsCompletedFS:SetPoint("CENTER")
      questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      questsCompletedFS:SetText(v.questsCompleted) 
      table.insert(content.values.questsCompleted, questsCompletedFrame)

      -- Food
      local foodFrame = CreateFrame("Frame", nil, content)
      foodFrame:SetPoint("TOPLEFT", 440, posY)
      foodFrame:SetSize(1,1)
      local foodFS = foodFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      foodFS:SetPoint("CENTER")
      foodFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      foodFS:SetText(v.food) 
      table.insert(content.values.food, foodFrame)

      -- Drink
      local drinkFrame = CreateFrame("Frame", nil, content)
      drinkFrame:SetPoint("TOPLEFT", 520, posY)
      drinkFrame:SetSize(1,1)
      local drinkFS = drinkFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      drinkFS:SetPoint("CENTER")
      drinkFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      drinkFS:SetText(v.drink) 
      table.insert(content.values.drink, drinkFrame)

      -- Time Played
      local timePlayedFrame = CreateFrame("Frame", nil, content)
      timePlayedFrame:SetPoint("TOPLEFT", 600, posY)
      timePlayedFrame:SetSize(1,1)
      local timePlayedFS = timePlayedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      timePlayedFS:SetPoint("CENTER")
      timePlayedFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
      if (v.timePlayedAtLevel ~= 0) then
        local timex = v.timePlayedAtLevel
        local days = math.floor(timex / 60 / 60 / 24) 
        local hours = math.floor(timex / 60 / 60) % 24
        local minutes = math.floor(timex / 60) % 60
        local seconds = timex % 60
        if (days >= 1) then 
          timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
      else
        local timex = toon.levelData[#toon.levelData].timePlayed
        local days = math.floor(timex / 60 / 60 / 24) 
        local hours = math.floor(timex / 60 / 60) % 24
        local minutes = math.floor(timex / 60) % 60
        local seconds = timex % 60
        if (days >= 1) then 
          timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
      end
      table.insert(content.values.timePlayedAtLevel, timePlayedFrame)

      -- Level Time
      local levelTimeFrame = CreateFrame("Frame", nil, content)
      levelTimeFrame:SetPoint("TOPLEFT", 680, posY)
      levelTimeFrame:SetSize(1,1)
      local levelTimeFS = levelTimeFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      levelTimeFS:SetPoint("CENTER")
      levelTimeFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
      local levelTime = 0
      if (
      v.timePlayedAtLevel ~= 0 and 
      toon.statsData[tostring(i -1)] ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= 0) then
        local t1 = v.timePlayedAtLevel
        local t2 = toon.statsData[tostring(i -1)].timePlayedAtLevel
        local timex = t1 - t2
        levelTime = timex
        local days = math.floor(timex / 60 / 60 / 24) 
        local hours = math.floor(timex / 60 / 60) % 24
        local minutes = math.floor(timex / 60) % 60
        local seconds = timex % 60
        if (days >= 1) then 
          levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
      elseif (
      toon.statsData[tostring(i -1)] ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= 0) then
        local t2 = toon.statsData[tostring(i -1)].timePlayedAtLevel
        local t3 = toon.levelData[#toon.levelData].timePlayed
        local timex = t3 - t2
        levelTime = timex
        local days = math.floor(timex / 60 / 60 / 24) 
        local hours = math.floor(timex / 60 / 60) % 24
        local minutes = math.floor(timex / 60) % 60
        local seconds = timex % 60
        if (days >= 1) then 
          levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
      elseif (
      i == 1 and
      v.timePlayedAtLevel ~= 0) then
        local timex = v.timePlayedAtLevel
        local days = math.floor(timex / 60 / 60 / 24) 
        local hours = math.floor(timex / 60 / 60) % 24
        local minutes = math.floor(timex / 60) % 60
        local seconds = timex % 60  
        if (days >= 1) then 
          levelTimeFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
        else
          levelTimeFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
        end
      end
      table.insert(content.values.levelTime, levelTimeFrame)

      -- XP per hour
      if (levelTime ~= 0) then
        local xpPerHourFrame = CreateFrame("Frame", nil, content)
        xpPerHourFrame:SetPoint("TOPLEFT", 760, posY)
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
        xpPerHourFrame:SetPoint("TOPLEFT", 760, posY)
        xpPerHourFrame:SetSize(1,1)
        local xpPerHourFS = xpPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        xpPerHourFS:SetPoint("CENTER")
        xpPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local xpPerHour = math.floor(XPC.levelChart[i] / (v.timePlayedAtLevel / 60 / 60))
        xpPerHourFS:SetText(xpPerHour .. '/h') 
        table.insert(content.values.xpPerHour, xpPerHourFrame)
      end

      -- Kills Per Hour
      if (levelTime ~= 0) then 
        local killsPerHourFrame = CreateFrame("Frame", nil, content)
        killsPerHourFrame:SetPoint("TOPLEFT", 840, posY)
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
        killsPerHourFrame:SetPoint("TOPLEFT", 840, posY)
        killsPerHourFrame:SetSize(1,1)
        local killsPerHourFS = killsPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
        killsPerHourFS:SetPoint("CENTER")
        killsPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
        local killsPerHour = math.floor((v.monstersKilledInGroup + v.monstersKilledSolo) / (v.timePlayedAtLevel / 60 / 60) * 10) / 10
        killsPerHourFS:SetText(killsPerHour .. '/h') 
        table.insert(content.values.killsPerHour, killsPerHourFrame) 
      end

      -- Flight Paths 
      local flightPathsFrame = CreateFrame("Frame", nil, content)
      flightPathsFrame:SetPoint("TOPLEFT", 920, posY)
      flightPathsFrame:SetSize(1,1)
      local flightPathsFS = flightPathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      flightPathsFS:SetPoint("CENTER")
      flightPathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      flightPathsFS:SetText(v.flightPaths) 
      table.insert(content.values.flightPaths, flightPathsFrame)

      -- Hearthstones
      local hearthstoneFrame = CreateFrame("Frame", nil, content)
      hearthstoneFrame:SetPoint("TOPLEFT", 1000, posY)
      hearthstoneFrame:SetSize(1,1)
      local hearthstoneFS = hearthstoneFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      hearthstoneFS:SetPoint("CENTER")
      hearthstoneFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      hearthstoneFS:SetText(v.hearthstone) 
      table.insert(content.values.hearthstone, hearthstoneFrame)

      -- Damage Taken
      local damageTakenFrame = CreateFrame("Frame", nil, content)
      damageTakenFrame:SetPoint("TOPLEFT", 1080, posY)
      damageTakenFrame:SetSize(1,1)
      local damageTakenFS = damageTakenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      damageTakenFS:SetPoint("CENTER")
      damageTakenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      damageTakenFS:SetText(v.damageTaken) 
      table.insert(content.values.damageTaken, damageTakenFrame)

      -- Heals Given
      local healsGivenFrame = CreateFrame("Frame", nil, content)
      healsGivenFrame:SetPoint("TOPLEFT", 1160, posY)
      healsGivenFrame:SetSize(1,1)
      local healsGivenFS = healsGivenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      healsGivenFS:SetPoint("CENTER")
      healsGivenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      healsGivenFS:SetText(v.healsGiven) 
      table.insert(content.values.healsGiven, healsGivenFrame)

      -- Heals Given
      local healsReceivedFrame = CreateFrame("Frame", nil, content)
      healsReceivedFrame:SetPoint("TOPLEFT", 1240, posY)
      healsReceivedFrame:SetSize(1,1)
      local healsReceivedFS = healsReceivedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      healsReceivedFS:SetPoint("CENTER")
      healsReceivedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      healsReceivedFS:SetText(v.healsReceived) 
      table.insert(content.values.healsReceived, healsReceivedFrame)

      -- Time AFK
      local timeAFKFrame = CreateFrame("Frame", nil, content)
      timeAFKFrame:SetPoint("TOPLEFT", 1320, posY)
      timeAFKFrame:SetSize(1,1)
      local timeAFKFS = timeAFKFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      timeAFKFS:SetPoint("CENTER")
      timeAFKFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      timex = v.timeAFK
      days = math.floor(timex / 60 / 60 / 24) 
      hours = math.floor(timex / 60 / 60) % 24
      minutes = math.floor(timex / 60) % 60
      seconds = timex % 60
      if (days >= 1) then 
        timeAFKFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
      else
        timeAFKFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
      end
      table.insert(content.values.timeAFK, timeAFKFrame)

      -- Dungeons
      local dungeonsFrame = CreateFrame("Frame", nil, content)
      dungeonsFrame:SetPoint("TOPLEFT", 1400, posY)
      dungeonsFrame:SetSize(1,1)
      local dungeonsFS = dungeonsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      dungeonsFS:SetPoint("CENTER")
      dungeonsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      dungeonsFS:SetText(v.dungeonsEntered) 
      table.insert(content.values.dungeons, dungeonsFrame)

      -- Potions
      local potionsFrame = CreateFrame("Frame", nil, content)
      potionsFrame:SetPoint("TOPLEFT", 1480, posY)
      potionsFrame:SetSize(1,1)
      local potionsFS = potionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      potionsFS:SetPoint("CENTER")
      potionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      potionsFS:SetText(v.potions) 
      table.insert(content.values.potions, potionsFrame)

      -- Healing Potions
      local healingPotionsFrame = CreateFrame("Frame", nil, content)
      healingPotionsFrame:SetPoint("TOPLEFT", 1560, posY)
      healingPotionsFrame:SetSize(1,1)
      local healingPotionsFS = healingPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      healingPotionsFS:SetPoint("CENTER")
      healingPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      healingPotionsFS:SetText(v.healingPotions) 
      table.insert(content.values.healingPotions, healingPotionsFrame)

      -- Mana Potions
      local manaPotionsFrame = CreateFrame("Frame", nil, content)
      manaPotionsFrame:SetPoint("TOPLEFT", 1640, posY)
      manaPotionsFrame:SetSize(1,1)
      local manaPotionsFS = manaPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      manaPotionsFS:SetPoint("CENTER")
      manaPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      manaPotionsFS:SetText(v.manaPotions) 
      table.insert(content.values.manaPotions, manaPotionsFrame)

      -- Healing / Mana Potions
      local MHPotionsFrame = CreateFrame("Frame", nil, content)
      MHPotionsFrame:SetPoint("TOPLEFT", 1720, posY)
      MHPotionsFrame:SetSize(1,1)
      local MHPotionsFS = MHPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      MHPotionsFS:SetPoint("CENTER")
      MHPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      MHPotionsFS:SetText(v.MHPotions) 
      table.insert(content.values.MHPotions, MHPotionsFrame)

      -- Mob XP
      local XPFromMobsFrame = CreateFrame("Frame", nil, content)
      XPFromMobsFrame:SetPoint("TOPLEFT", 1800, posY)
      XPFromMobsFrame:SetSize(1,1)
      local XPFromMobsFS = XPFromMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      XPFromMobsFS:SetPoint("CENTER")
      XPFromMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      XPFromMobsFS:SetText(v.XPFromMobs) 
      table.insert(content.values.XPFromMobs, XPFromMobsFrame)

      -- Quest XP
      local XPFromQuestsFrame = CreateFrame("Frame", nil, content)
      XPFromQuestsFrame:SetPoint("TOPLEFT", 1880, posY)
      XPFromQuestsFrame:SetSize(1,1)
      local XPFromQuestsFS = XPFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      XPFromQuestsFS:SetPoint("CENTER")
      XPFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      XPFromQuestsFS:SetText(v.XPFromQuests) 
      table.insert(content.values.XPFromQuests, XPFromQuestsFrame)

      -- Quest Gold
      local goldFromQuestsFrame = CreateFrame("Frame", nil, content)
      goldFromQuestsFrame:SetPoint("TOPLEFT", 1960, posY)
      goldFromQuestsFrame:SetSize(1,1)
      local goldFromQuestsFS = goldFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      goldFromQuestsFS:SetPoint("CENTER")
      goldFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
      local gold = math.floor(v.goldFromQuests / 10000)
      local silver = math.floor(v.goldFromQuests / 100 % 100)
      local copper = math.floor(v.goldFromQuests % 100)
      goldFromQuestsFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
      table.insert(content.values.goldFromQuests, goldFromQuestsFrame)

      -- Quest Gold
      local deathsFrame = CreateFrame("Frame", nil, content)
      deathsFrame:SetPoint("TOPLEFT", 2040, posY)
      deathsFrame:SetSize(1,1)
      local deathsFS = deathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      deathsFS:SetPoint("CENTER")
      deathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      deathsFS:SetText(v.deaths) 
      table.insert(content.values.deaths, deathsFrame)

      -- Bandages
      local bandagesFrame = CreateFrame("Frame", nil, content)
      bandagesFrame:SetPoint("TOPLEFT", 2120, posY)
      bandagesFrame:SetSize(1,1)
      local bandagesFS = bandagesFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      bandagesFS:SetPoint("CENTER")
      bandagesFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      bandagesFS:SetText(v.bandages) 
      table.insert(content.values.bandages, bandagesFrame)

      -- Gold From Loot
      local goldFromLootFrame = CreateFrame("Frame", nil, content)
      goldFromLootFrame:SetPoint("TOPLEFT", 2200, posY)
      goldFromLootFrame:SetSize(1,1)
      local goldFromLootFS = goldFromLootFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
      goldFromLootFS:SetPoint("CENTER")
      goldFromLootFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
      local gold = math.floor(v.goldFromLoot / 10000)
      local silver = math.floor(v.goldFromLoot / 100 % 100)
      local copper = math.floor(v.goldFromLoot % 100)
      goldFromLootFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
      table.insert(content.values.goldFromLoot, goldFromLootFrame)
      

    else
      missedLevels = missedLevels + 1
    end

    i = i + 1
  end
  
  -- chart values for total
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
  local totalHealingPotions = 0
  local totalManaPotions = 0
  local totalMHPotions = 0
  local totalXPFromMobs = 0
  local totalXPFromQuests = 0
  local totalGoldFromQuests = 0
  local totalDeaths = 0
  local totalBandages = 0
  local totalGoldFromLoot = 0
  local damageDealtFrame = CreateFrame("Frame", nil, content)
  damageDealtFrame:SetPoint("TOPLEFT", 40, -15)
  damageDealtFrame:SetSize(1,1)
  local damageDealtFS = damageDealtFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  damageDealtFS:SetPoint("CENTER")
  damageDealtFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  for k,v in pairs(toon.statsData) do
    totalDamageDealt = totalDamageDealt + v.damageDealt
    totalMonstersKilledSolo = totalMonstersKilledSolo + v.monstersKilledSolo
    totalMonstersKilledInGroup = totalMonstersKilledInGroup + v.monstersKilledInGroup
    totalQuestsCompleted = totalQuestsCompleted + v.questsCompleted
    totalFood = totalFood + v.food
    totalDrink = totalDrink + v.drink
    totalFlightPaths = totalFlightPaths + v.flightPaths
    totalHearthstone = totalHearthstone + v.hearthstone
    totalDamageTaken = totalDamageTaken + v.damageTaken
    totalHealsGiven = totalHealsGiven + v.healsGiven
    totalHealsReceived = totalHealsReceived + v.healsReceived
    totalTimeAFK = totalTimeAFK + v.timeAFK
    totalDungeons = totalDungeons + v.dungeonsEntered
    totalPotions = totalPotions + v.potions
    totalHealingPotions = totalHealingPotions + v.healingPotions
    totalManaPotions = totalManaPotions + v.manaPotions
    totalMHPotions = totalMHPotions + v.MHPotions
    totalXPFromMobs = totalXPFromMobs + v.XPFromMobs
    totalXPFromQuests = totalXPFromQuests + v.XPFromQuests
    totalGoldFromQuests = totalGoldFromQuests + v.goldFromQuests
    totalDeaths = totalDeaths + v.deaths
    totalBandages = totalBandages + v.bandages
    totalGoldFromLoot = totalGoldFromLoot + v.goldFromLoot
  end
  if (totalDamageDealt >= 1000000) then 
    damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 10000) / 100) .. 'M')
  elseif (totalDamageDealt >= 1000) then 
    damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 100) / 10) .. 'K')
  else
    damageDealtFS:SetText(tostring(totalDamageDealt))
  end
  table.insert(content.values.damageDealt, damageDealtFrame)

  -- Kills Solo
  local monstersKilledSoloFrame = CreateFrame("Frame", nil, content)
  monstersKilledSoloFrame:SetPoint("TOPLEFT", 120, -15)
  monstersKilledSoloFrame:SetSize(1,1)
  local monstersKilledSoloFS = monstersKilledSoloFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledSoloFS:SetPoint("CENTER")
  monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledSoloFS:SetText(totalMonstersKilledSolo) 
  table.insert(content.values.monstersKilledSolo, monstersKilledSoloFrame)

  -- Kills Group
  local monstersKilledInGroupFrame = CreateFrame("Frame", nil, content)
  monstersKilledInGroupFrame:SetPoint("TOPLEFT", 200, -15)
  monstersKilledInGroupFrame:SetSize(1,1)
  local monstersKilledInGroupFS = monstersKilledInGroupFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledInGroupFS:SetPoint("CENTER")
  monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledInGroupFS:SetText(totalMonstersKilledInGroup) 
  table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFrame)

  -- Killed
  local monstersKilledFrame = CreateFrame("Frame", nil, content)
  monstersKilledFrame:SetPoint("TOPLEFT", 280, -15)
  monstersKilledFrame:SetSize(1,1)
  local monstersKilledFS = monstersKilledFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledFS:SetPoint("CENTER")
  monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledFS:SetText(totalMonstersKilledInGroup + totalMonstersKilledSolo) 
  table.insert(content.values.monstersKilled, monstersKilledFrame)

  -- Quests Completed
  local questsCompletedFrame = CreateFrame("Frame", nil, content)
  questsCompletedFrame:SetPoint("TOPLEFT", 360, -15)
  questsCompletedFrame:SetSize(1,1)
  local questsCompletedFS = questsCompletedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  questsCompletedFS:SetPoint("CENTER")
  questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  questsCompletedFS:SetText(totalQuestsCompleted) 
  table.insert(content.values.questsCompleted, questsCompletedFrame)

  -- Food
  local foodFrame = CreateFrame("Frame", nil, content)
  foodFrame:SetPoint("TOPLEFT", 440, -15)
  foodFrame:SetSize(1,1)
  local foodFS = foodFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  foodFS:SetPoint("CENTER")
  foodFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  foodFS:SetText(totalFood) 
  table.insert(content.values.food, foodFrame)

  -- Drink
  local drinkFrame = CreateFrame("Frame", nil, content)
  drinkFrame:SetPoint("TOPLEFT", 520, -15)
  drinkFrame:SetSize(1,1)
  local drinkFS = drinkFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  drinkFS:SetPoint("CENTER")
  drinkFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  drinkFS:SetText(totalDrink) 
  table.insert(content.values.drink, drinkFrame)

  -- Time Played
  local timePlayedFrame = CreateFrame("Frame", nil, content)
  timePlayedFrame:SetPoint("TOPLEFT", 600, -15)
  timePlayedFrame:SetSize(1,1)
  local timePlayedFS = timePlayedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  timePlayedFS:SetPoint("CENTER")
  timePlayedFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
  local timex = toon.levelData[#toon.levelData].timePlayed
  local days = math.floor(timex / 60 / 60 / 24) 
  local hours = math.floor(timex / 60 / 60) % 24
  local minutes = math.floor(timex / 60) % 60
  local seconds = timex % 60
  if (days >= 1) then 
    timePlayedFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
  else
    timePlayedFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
  end
  table.insert(content.values.timePlayedAtLevel, timePlayedFrame)

  -- XP Per Hour
  local xpPerHourFrame = CreateFrame("Frame", nil, content)
  xpPerHourFrame:SetPoint("TOPLEFT", 760, -15)
  xpPerHourFrame:SetSize(1,1)
  local xpPerHourFS = xpPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  xpPerHourFS:SetPoint("CENTER")
  xpPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  local timePlayed = toon.levelData[#toon.levelData].timePlayed
  local totalXP = toon.levelData[#toon.levelData].totalXP
  local xpPerHour = math.floor(totalXP / (timePlayed / 60 / 60))
  xpPerHourFS:SetText(xpPerHour .. '/h') 
  table.insert(content.values.xpPerHour, xpPerHourFrame)

  -- Kills Per Hour
  local killsPerHourFrame = CreateFrame("Frame", nil, content)
  killsPerHourFrame:SetPoint("TOPLEFT", 840, -15)
  killsPerHourFrame:SetSize(1,1)
  local killsPerHourFS = killsPerHourFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  killsPerHourFS:SetPoint("CENTER")
  killsPerHourFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  local timePlayed = toon.levelData[#toon.levelData].timePlayed
  local killsPerHour = math.floor((totalMonstersKilledInGroup + totalMonstersKilledSolo) / (timePlayed / 60 / 60) * 10) / 10
  killsPerHourFS:SetText(killsPerHour .. '/h') 
  table.insert(content.values.killsPerHour, killsPerHourFrame)

  -- Flight Paths
  local flightPathsFrame = CreateFrame("Frame", nil, content)
  flightPathsFrame:SetPoint("TOPLEFT", 920, -15)
  flightPathsFrame:SetSize(1,1)
  local flightPathsFS = flightPathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  flightPathsFS:SetPoint("CENTER")
  flightPathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  flightPathsFS:SetText(totalFlightPaths) 
  table.insert(content.values.flightPaths, flightPathsFrame)

  -- Hearthstones
  local hearthstoneFrame = CreateFrame("Frame", nil, content)
  hearthstoneFrame:SetPoint("TOPLEFT", 1000, -15)
  hearthstoneFrame:SetSize(1,1)
  local hearthstoneFS = hearthstoneFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  hearthstoneFS:SetPoint("CENTER")
  hearthstoneFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  hearthstoneFS:SetText(totalHearthstone) 
  table.insert(content.values.hearthstone, hearthstoneFrame)

  -- Damage Taken
  local damageTakenFrame = CreateFrame("Frame", nil, content)
  damageTakenFrame:SetPoint("TOPLEFT", 1080, -15)
  damageTakenFrame:SetSize(1,1)
  local damageTakenFS = damageTakenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  damageTakenFS:SetPoint("CENTER")
  damageTakenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  damageTakenFS:SetText(totalDamageTaken) 
  table.insert(content.values.damageTaken, damageTakenFrame)

  -- Heals Given
  local healsGivenFrame = CreateFrame("Frame", nil, content)
  healsGivenFrame:SetPoint("TOPLEFT", 1160, -15)
  healsGivenFrame:SetSize(1,1)
  local healsGivenFS = healsGivenFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  healsGivenFS:SetPoint("CENTER")
  healsGivenFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  healsGivenFS:SetText(totalHealsGiven) 
  table.insert(content.values.healsGiven, healsGivenFrame)

  -- Heals Received
  local healsReceivedFrame = CreateFrame("Frame", nil, content)
  healsReceivedFrame:SetPoint("TOPLEFT", 1240, -15)
  healsReceivedFrame:SetSize(1,1)
  local healsReceivedFS = healsReceivedFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  healsReceivedFS:SetPoint("CENTER")
  healsReceivedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  healsReceivedFS:SetText(totalHealsReceived) 
  table.insert(content.values.healsReceived, healsReceivedFrame)

  -- Time AFK
  local timeAFKFrame = CreateFrame("Frame", nil, content)
  timeAFKFrame:SetPoint("TOPLEFT", 1320, -15)
  timeAFKFrame:SetSize(1,1)
  local timeAFKFS = timeAFKFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  timeAFKFS:SetPoint("CENTER")
  timeAFKFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  timex = totalTimeAFK
  days = math.floor(timex / 60 / 60 / 24) 
  hours = math.floor(timex / 60 / 60) % 24
  minutes = math.floor(timex / 60) % 60
  seconds = timex % 60
  if (days >= 1) then 
    timeAFKFS:SetText(days .. 'd ' .. hours .. 'h ' .. minutes .. 'm') 
  else
    timeAFKFS:SetText(hours .. 'h ' .. minutes .. 'm ' .. seconds .. 's') 
  end
  table.insert(content.values.timeAFK, timeAFKFrame)

  -- Dungeons
  local dungeonsFrame = CreateFrame("Frame", nil, content)
  dungeonsFrame:SetPoint("TOPLEFT", 1400, -15)
  dungeonsFrame:SetSize(1,1)
  local dungeonsFS = dungeonsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  dungeonsFS:SetPoint("CENTER")
  dungeonsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  dungeonsFS:SetText(totalDungeons) 
  table.insert(content.values.dungeons, dungeonsFrame)

  -- Potions
  local potionsFrame = CreateFrame("Frame", nil, content)
  potionsFrame:SetPoint("TOPLEFT", 1480, -15)
  potionsFrame:SetSize(1,1)
  local potionsFS = potionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  potionsFS:SetPoint("CENTER")
  potionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  potionsFS:SetText(totalPotions) 
  table.insert(content.values.potions, potionsFrame)

  -- Healing Potions
  local healingPotionsFrame = CreateFrame("Frame", nil, content)
  healingPotionsFrame:SetPoint("TOPLEFT", 1560, -15)
  healingPotionsFrame:SetSize(1,1)
  local healingPotionsFS = healingPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  healingPotionsFS:SetPoint("CENTER")
  healingPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  healingPotionsFS:SetText(totalHealingPotions) 
  table.insert(content.values.healingPotions, healingPotionsFrame)

  -- Mana Potions
  local manaPotionsFrame = CreateFrame("Frame", nil, content)
  manaPotionsFrame:SetPoint("TOPLEFT", 1640, -15)
  manaPotionsFrame:SetSize(1,1)
  local manaPotionsFS = manaPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  manaPotionsFS:SetPoint("CENTER")
  manaPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  manaPotionsFS:SetText(totalManaPotions) 
  table.insert(content.values.manaPotions, manaPotionsFrame)

  -- Mana/Healing Potions
  local MHPotionsFrame = CreateFrame("Frame", nil, content)
  MHPotionsFrame:SetPoint("TOPLEFT", 1720, -15)
  MHPotionsFrame:SetSize(1,1)
  local MHPotionsFS = MHPotionsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  MHPotionsFS:SetPoint("CENTER")
  MHPotionsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  MHPotionsFS:SetText(totalMHPotions) 
  table.insert(content.values.MHPotions, MHPotionsFrame)

  -- Mob XP
  local XPFromMobsFrame = CreateFrame("Frame", nil, content)
  XPFromMobsFrame:SetPoint("TOPLEFT", 1800, -15)
  XPFromMobsFrame:SetSize(1,1)
  local XPFromMobsFS = XPFromMobsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  XPFromMobsFS:SetPoint("CENTER")
  XPFromMobsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  XPFromMobsFS:SetText(totalXPFromMobs) 
  table.insert(content.values.XPFromMobs, XPFromMobsFrame)

  -- Quest XP
  local XPFromQuestsFrame = CreateFrame("Frame", nil, content)
  XPFromQuestsFrame:SetPoint("TOPLEFT", 1880, -15)
  XPFromQuestsFrame:SetSize(1,1)
  local XPFromQuestsFS = XPFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  XPFromQuestsFS:SetPoint("CENTER")
  XPFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  XPFromQuestsFS:SetText(totalXPFromQuests) 
  table.insert(content.values.XPFromQuests, XPFromQuestsFrame)

  -- Quest Gold
  local goldFromQuestsFrame = CreateFrame("Frame", nil, content)
  goldFromQuestsFrame:SetPoint("TOPLEFT", 1960, -15)
  goldFromQuestsFrame:SetSize(1,1)
  local goldFromQuestsFS = goldFromQuestsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  goldFromQuestsFS:SetPoint("CENTER")
  goldFromQuestsFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
  local gold = math.floor(totalGoldFromQuests / 10000)
  local silver = math.floor(totalGoldFromQuests / 100 % 100)
  local copper = math.floor(totalGoldFromQuests % 100)
  goldFromQuestsFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c") 
  table.insert(content.values.goldFromQuests, goldFromQuestsFrame)

  -- Deaths
  local deathsFrame = CreateFrame("Frame", nil, content)
  deathsFrame:SetPoint("TOPLEFT", 2040, -15)
  deathsFrame:SetSize(1,1)
  local deathsFS = deathsFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  deathsFS:SetPoint("CENTER")
  deathsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  deathsFS:SetText(totalDeaths) 
  table.insert(content.values.deaths, deathsFrame)
  
  -- Bandages
  local bandagesFrame = CreateFrame("Frame", nil, content)
  bandagesFrame:SetPoint("TOPLEFT", 2120, -15)
  bandagesFrame:SetSize(1,1)
  local bandagesFS = bandagesFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  bandagesFS:SetPoint("CENTER")
  bandagesFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  bandagesFS:SetText(totalBandages) 
  table.insert(content.values.bandages, bandagesFrame)
  
  -- Gold From Loot
  local goldFromLootFrame = CreateFrame("Frame", nil, content)
  goldFromLootFrame:SetPoint("TOPLEFT", 2200, -15)
  goldFromLootFrame:SetSize(1,1)
  local goldFromLootFS = goldFromLootFrame:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  goldFromLootFS:SetPoint("CENTER")
  goldFromLootFS:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
  local gold = math.floor(totalGoldFromLoot / 10000)
  local silver = math.floor(totalGoldFromLoot / 100 % 100)
  local copper = math.floor(totalGoldFromLoot % 100)
  goldFromLootFS:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
  table.insert(content.values.goldFromLoot, goldFromLootFrame)
  

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
  local foods = {25691, 25690, 25692, 25693, 24707, 29029, 434, 18229, 10257, 22731, 25695, 25700, 26401, 26260, 26472, 29008, 1131, 435, 18231, 18232, 18234, 24869, 6410, 28616, 25886, 433, 7737, 2639, 10256, 24800, 1127, 1129, 25660, 5006, 5005, 5007, 18233, 24005, 5004, 18230, 29073}
  local drinks = {25691, 25690, 25692, 25693, 24707, 29029, 430, 24355, 1135, 26475, 22734, 1133, 432, 1137, 26473, 10250, 25696, 26261, 29007}
  local potions = {9030,5634,13444,13457,5816,929,13446,3823,13443,3387,2459,13442,9172,20008,6149,3928,1710,6049,3827,6372,5633,13461,13455,858,9144,13462,3385,13459,6048,5631,13458,118,2455,13506,12190,18253,23579,20002,13456,4623,6052,3386,2456,6051,5632,13460,6050,18841,4596,23578,18839,1450,17348,3087,17351,17349,23696,23698,17352}
  local elixirs = {9155,10592,8949,13453,3389,9224,9233,3828,9154,9197,6373,3825,17708,6662,9206,9187,8951,21546,9179,18294,3390,2454,2457,5997,2458,3391,9264,13445,13452,13447,5996,8827,3383,9088,13454,20007,3826,20004,3388,3382}
  local flasks = {13510,13512,13511,13506,13513}
  local bandages = {10841, 7928, 3278, 18629, 18630, 3276, 3277, 10840, 7929, 3275, 30021, 746, 1159, 3267, 3268, 7926, 24412, 10838, 23568, 23696, 18608, 30020}
  local potionBuffNames = {
    "Free Action",
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
    "Living Free Action",
    "Spirit of Boar",
    "Rage of Ages",
    "Strike of the Scorpok",
    "Spiritual Domination",
    "Infallible Mind",
    "Greater Dreamless Sleep",
    "Dreamless Sleep",
    "Purification",
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
    "Stealth Detection"
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

  tracker:SetScript("OnEvent", function(self, event, ...) 

    -- Gold Tracker
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

      -- potions/elixirs/flasks
      if (sourceName == GetUnitName('player')) then
        if (subevent == "SPELL_CAST_SUCCESS") then
          if (b == 'Restore Mana') then
            stats.manaPotions = stats.manaPotions + 1
          end
          if (b == 'Healing Potion') then
            stats.healingPotions = stats.healingPotions + 1
          end
          if (b == 'Wildvine Potion' or b == 'Rejuvenation Potion') then
            stats.MHPotions = stats.MHPotions + 1
          end
        end
        if (subevent == "SPELL_CAST_SUCCESS") then
          local isPot = false
          for i,v in ipairs(potionBuffNames) do
            if (b == v) then
              isPot = true
            end
          end
          for i,v in ipairs(elixirBuffNames) do
            if (b == v) then
              isPot = true
            end
          end
          for i,v in ipairs(flaskBuffNames) do
            if (b == v) then
              isPot = true
            end
          end
          for i,v in ipairs(scrollBuffNames) do
            if (b == v) then
              isPot = true
            end
          end
          if (isPot == true) then
            stats.potions = stats.potions + 1
          end
        end
      end

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
        for i,v in ipairs(bandages) do 
          if (spellID == v) then
            stats.bandages = stats.bandages + 1
          end
        end
      end
    end
  end)
end


-- raw gold looted
-- gold vendored
-- gold gained
-- buffs given
-- buffs received
-- # of duels won
-- # of duels lost
-- # of hk's
-- honor gained
-- time on flight paths
-- time in combat
-- % of time in combat
-- % of xp gained from quests
-- % of xp gained from mobs
