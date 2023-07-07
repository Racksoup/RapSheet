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
    xpFromQuests = {},
    xpFromMobs = {},
    dungeonsEntered = {},
    killsPerHour = {},
    hearthstone = {},
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
  chart.food:SetPoint("TOPLEFT", 487, -20)
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
  chart.flightPaths:SetPoint("TOPLEFT", 964, -20)
  chart.flightPaths:SetText('Taxis')
  chart.hearthstone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.hearthstone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.hearthstone:SetPoint("TOPLEFT", 1020, -20)
  chart.hearthstone:SetText('Hearthstones')
  chart.damageTaken = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.damageTaken:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.damageTaken:SetPoint("TOPLEFT", 1116, -20)
  chart.damageTaken:SetText('Dmg In')
  chart.HealsGiven = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsGiven:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsGiven:SetPoint("TOPLEFT", 1190, -20)
  chart.HealsGiven:SetText('Heals Out')
  chart.HealsReceived = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.HealsReceived:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.HealsReceived:SetPoint("TOPLEFT", 1276, -20)
  chart.HealsReceived:SetText('Heals In')
  chart.TimeAFK = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.TimeAFK:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.TimeAFK:SetPoint("TOPLEFT", 1353, -20)
  chart.TimeAFK:SetText('Time AFK')

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
  local timeAFK = 0

  tracker:RegisterEvent("PLAYER_LEVEL_UP")
  tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  tracker:RegisterEvent("QUEST_COMPLETE")
  tracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  tracker:RegisterEvent("TAXIMAP_CLOSED")
  tracker:RegisterEvent("CHAT_MSG_SYSTEM")

  tracker:SetScript("OnEvent", function(self, event, ...) 

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
      end
    end
  end)
end

-- # of dungeons entered
-- raw gold looted
-- gold vendored
-- gold gained
-- # of bandaids bandaged
-- # of potions used
-- # of deaths
-- # of pvp deaths
-- # of duels won
-- # of duels lost
-- # of hk's
-- time on flight paths
-- time in combat
-- % of time in combat
-- xp gained from quests
-- xp gained from mobs
-- % of xp gained from quests
-- % of xp gained from mobs