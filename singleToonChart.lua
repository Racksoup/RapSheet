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
    healsRecieved = {},
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
    xpFromQuests = {},
    xpFromMobs = {},
    dungeonsEntered = {},
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
  chart.food:SetPoint("TOPLEFT", 479, -20)
  chart.food:SetText('Food')
  chart.drink = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.drink:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.drink:SetPoint("TOPLEFT", 559, -20)
  chart.drink:SetText('Drink')
  chart.timePlayedAtLevel = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.timePlayedAtLevel:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.timePlayedAtLevel:SetPoint("TOPLEFT", 622, -20)
  chart.timePlayedAtLevel:SetText('Time Played')
  chart.levelTime = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.levelTime:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.levelTime:SetPoint("TOPLEFT", 708, -20)
  chart.levelTime:SetText('Level Time')

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
      levelTimeFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
      if (
      v.timePlayedAtLevel ~= 0 and 
      toon.statsData[tostring(i -1)] ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= nil and 
      toon.statsData[tostring(i -1)].timePlayedAtLevel ~= 0) then
        local t1 = v.timePlayedAtLevel
        local t2 = toon.statsData[tostring(i -1)].timePlayedAtLevel
        local timex = t1 - t2
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

  tracker:RegisterEvent("PLAYER_LEVEL_UP")
  tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  tracker:RegisterEvent("QUEST_COMPLETE")
  tracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

  tracker:SetScript("OnEvent", function(self, event, ...) 
    
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
      end
    end
  end)
end

-- xp per hour
-- number of monsters killed per hour
-- # of bandaids bandaged
-- # of potions used
-- # of heals given
-- # of heals received
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
-- # of dungeons entered
-- hearthstone