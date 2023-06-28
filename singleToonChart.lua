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
  chart:SetSize(1500, 905)
  -- slider:SetScrollChild(chart)
  chart:SetPoint("TOPLEFT", 0, 0)

  -- create chart content 
  chart.content = CreateFrame("Frame", content, chart)
  local content = chart.content
  content:SetSize(1437, 872)
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
  chart.killsSolo:SetPoint("TOPLEFT", 148, -20)
  chart.killsSolo:SetText('Kills Solo')
  chart.killsGroup = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.killsGroup:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.killsGroup:SetPoint("TOPLEFT", 228, -20)
  chart.killsGroup:SetText('Kills Group')
  chart.kills = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.kills:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.kills:SetPoint("TOPLEFT", 308, -20)
  chart.kills:SetText('Kills')
  chart.questsCompleted = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.questsCompleted:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.questsCompleted:SetPoint("TOPLEFT", 388, -20)
  chart.questsCompleted:SetText('Quests')

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
    totalTimePlayedWhenLeveled = {},
    xpFromQuests = {},
    xpFromMobs = {},
    dungeonsEntered = {}
  }
  -- Vertical and Horizontal Line Seperator table init
  content.vLines = {}
  content.hLines = {}

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
  for j=1, level+1 do
    local line = content:CreateLine()
    line:SetColorTexture(0.7, 0.7, 0.7, .1)
    line:SetStartPoint("TOPLEFT", 0, j * -30 + 2)
    line:SetEndPoint("TOPRIGHT", 0, j * -30 + 2)

    table.insert(content.hLines, line)

  end

  -- V-values
  for i = level+1, 1, -1 do 
    local value = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
    value:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (i == level + 1) then 
      value:SetPoint("TOPLEFT", 12, -60 + (((level +1) - i) * -30) +8)
      value:SetText('Total') 
    else 
      value:SetPoint("TOPLEFT", 20, -60 + (((level +1) - i) * -30) +8)
      value:SetText(i) 
    end
    table.insert(chart.vValues, value)
  end
  
  -- levels
  local i = 1
  for k,v in pairs(toon.statsData) do
    -- Damage Dealt
    local damageDealtFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    damageDealtFS:SetPoint("TOPLEFT", 20, i * -30 - 12)
    damageDealtFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (v.damageDealt >= 1000000) then 
      damageDealtFS:SetText(tostring(math.floor(v.damageDealt / 10000) / 100) .. 'M')
    elseif (v.damageDealt >= 1000) then 
      damageDealtFS:SetText(tostring(math.floor(v.damageDealt / 100) / 10) .. 'K')
    else
      damageDealtFS:SetText(tostring(v.damageDealt))
    end
    table.insert(content.values.damageDealt, damageDealtFS)
    
    -- Kills Solo
    local monstersKilledSoloFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledSoloFS:SetPoint("TOPLEFT", 100, i * -30 - 12)
    monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledSoloFS:SetText(v.monstersKilledSolo) 
    table.insert(content.values.monstersKilledSolo, monstersKilledSoloFS)

    -- Kills Group
    local monstersKilledInGroupFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledInGroupFS:SetPoint("TOPLEFT", 180, i * -30 - 12)
    monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledInGroupFS:SetText(v.monstersKilledInGroup) 
    table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFS)

    -- Kills
    local monstersKilledFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    monstersKilledFS:SetPoint("TOPLEFT", 260, i * -30 - 12)
    monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    monstersKilledFS:SetText(v.monstersKilledInGroup + v.monstersKilledSolo) 
    table.insert(content.values.monstersKilled, monstersKilledFS)

    -- Quests Completed
    local questsCompletedFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
    questsCompletedFS:SetPoint("TOPLEFT", 340, i * -30 - 12)
    questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    questsCompletedFS:SetText(v.questsCompleted) 
    table.insert(content.values.questsCompleted, questsCompletedFS)

    i = i + 1
  end
  
  -- total
  local damageDealtFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  damageDealtFS:SetPoint("TOPLEFT", 20, - 12)
  damageDealtFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  local totalDamageDealt = 0
  local totalMonstersKilledSolo = 0
  local totalMonstersKilledInGroup = 0
  local totalQuestsCompleted = 0
  for k,v in pairs(toon.statsData) do
    totalDamageDealt = totalDamageDealt + v.damageDealt
    totalMonstersKilledSolo = totalMonstersKilledSolo + v.monstersKilledSolo
    totalMonstersKilledInGroup = totalMonstersKilledInGroup + v.monstersKilledInGroup
    totalQuestsCompleted = totalQuestsCompleted + v.questsCompleted
  end
  if (totalDamageDealt >= 1000000) then 
    damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 10000) / 100) .. 'M')
  elseif (totalDamageDealt >= 1000) then 
    damageDealtFS:SetText(tostring(math.floor(totalDamageDealt / 100) / 10) .. 'K')
  else
    damageDealtFS:SetText(tostring(totalDamageDealt))
  end
  table.insert(content.values.damageDealt, damageDealtFS)

  -- Kills Solo
  local monstersKilledSoloFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledSoloFS:SetPoint("TOPLEFT", 100, -12)
  monstersKilledSoloFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledSoloFS:SetText(totalMonstersKilledSolo) 
  table.insert(content.values.monstersKilledSolo, monstersKilledSoloFS)

  -- Kills Group
  local monstersKilledInGroupFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledInGroupFS:SetPoint("TOPLEFT", 180, -12)
  monstersKilledInGroupFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledInGroupFS:SetText(totalMonstersKilledInGroup) 
  table.insert(content.values.monstersKilledInGroup, monstersKilledInGroupFS)

  -- Killed
  local monstersKilledFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  monstersKilledFS:SetPoint("TOPLEFT", 260, - 12)
  monstersKilledFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  monstersKilledFS:SetText(totalMonstersKilledInGroup + totalMonstersKilledSolo) 
  table.insert(content.values.monstersKilled, monstersKilledFS)

  -- Quests Completed
  local questsCompletedFS = content:CreateFontString(nil, "OVERLAY", 'SharedTooltipTemplate')
  questsCompletedFS:SetPoint("TOPLEFT", 340, - 12)
  questsCompletedFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  questsCompletedFS:SetText(totalQuestsCompleted) 
  table.insert(content.values.questsCompleted, questsCompletedFS)

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
  content:SetSize(250, XPC.numOfToons * 30 + 5)
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
  local toon = XPC.db.global.toons[XPC.currToonName]
  local stats = toon.statsData[tostring(UnitLevel('player'))]
  local tracker = XPC_GUI.statsTracker
  local statList = {
    damageDealt = 0,
    damageTaken = 0,
    monstersKilledSolo = 0,
    monstersKilledInGroup = 0,
    questsCompleted = 0,
    food = 0,
    drink = 0,
    bandages = 0,
    potions = 0,
    healsGiven = 0,
    healsRecieved = 0,
    deaths = 0,
    pvpDeaths = 0,
    duelsWon = 0,
    duelsLost = 0,
    honorKills = 0,
    flightPaths = 0,
    timeAFK = 0,
    timeInCombat = 0,
    timePlayedAtLevel = 0,
    totalTimePlayedWhenLeveled = 0,
    xpFromQuests = 0,
    xpFromMobs = 0,
    dungeonsEntered = 0
  }

  
  -- init statsData and its level objects
  if (toon.statsData == nil) then toon.statsData = {} end
  if (stats == nil) then 
    stats = statList
  end

  tracker:RegisterEvent("PLAYER_LEVEL_UP")
  tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  tracker:RegisterEvent("QUEST_COMPLETE")

  tracker:SetScript("OnEvent", function(self, event, ...) 
    -- level up tracker
    if (event == "PLAYER_LEVEL_UP") then     
      stats = statList
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
          print(stats.monstersKilledSolo)
        end 
      end
    end

    -- quest complete
    if (event == "QUEST_COMPLETE") then
      stats.questsCompleted = stats.questsCompleted + 1
    end
  end)
end


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
-- xp per hour
-- time played at level
-- overall time played when leveled
-- # of dungeons entered