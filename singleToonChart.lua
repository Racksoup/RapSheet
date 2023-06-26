function Single_OnMouseWheel(self, delta) 
  local single = XPC_GUI.main.single
  local chart = XPC_GUI.main.single.chart
  local point, relativeTo, relativePoint, offsetX, offsetY = chart:GetPoint()
  
  if (IsShiftKeyDown()) then
    -- slider 
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
    local sliderValue = hSlider:GetValue()
    local scrollDist = sliderValue / maxValue
    local scrollMaxLength = chart:GetWidth()  - single:GetWidth()
    local scrollPos = (scrollMaxLength / 100) * (scrollDist * 100) - 40
    if (scrollPos < 6) then scrollPos = 0 end
    print(scrollPos)
    chart:SetPoint(point, relativeTo, relativePoint, scrollPos, offsetY)

  else
    -- slider
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
    local sliderValue = vSlider:GetValue()
    local scrollDist = sliderValue / maxValue
    local scrollMaxLength = chart:GetHeight()  - single:GetHeight()
    local scrollPos = (scrollMaxLength / 100) * (scrollDist * 100) - 40
    if (scrollPos < -34) then scrollPos = -40 end
    print(scrollPos)
    chart:SetPoint(point, relativeTo, relativePoint, offsetX, scrollPos)
  end
end

function XPC:BuildSingleToon()
  XPC_GUI.main.single = CreateFrame("Frame", single, XPC_GUI.main)
  local single = XPC_GUI.main.single
  single:SetSize(1175, 634)
  single:SetPoint("TOPLEFT")
  single:SetClipsChildren(true)
  single:SetScript("OnMouseWheel", Single_OnMouseWheel)
  
  -- switch toons button
  single.toonsBtn = CreateFrame("Button", nil, single, "UIPanelButtonTemplate")
  local toonsBtn = single.toonsBtn
  toonsBtn:SetSize(120, 25)
  toonsBtn:SetPoint("TOPRIGHT", -80, -12)
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
  hSlider:SetValueStep(1)
  hSlider:SetMinMaxValues(1, 100)
  hSlider:SetValue(5)
  hSlider:SetObeyStepOnDrag(true)
  hSlider:SetOrientation("HORIZONTAL")
  hSlider.High:Hide()
  hSlider.Low:Hide()
  
  -- Chart vSlider
  XPC_GUI.main.single.vSlider = CreateFrame("Slider", nil, XPC_GUI.main, "OptionsSliderTemplate")
  local vSlider = XPC_GUI.main.single.vSlider
  vSlider:SetPoint("TOPRIGHT", -6, -25)
  vSlider:SetSize(20, 610)
  vSlider:SetValueStep(1)
  vSlider:SetMinMaxValues(1, 100)
  vSlider:SetValue(5)
  vSlider:SetObeyStepOnDrag(true)
  vSlider:SetOrientation("VERTICAL")
  vSlider.High:Hide()
  vSlider.Low:Hide()

  -- Chart
  single.chart = CreateFrame("Frame", chart, single)
  local chart = single.chart
  chart:SetSize(1500, 905)
  -- slider:SetScrollChild(chart)
  chart:SetPoint("TOPLEFT", 0, -40)

  -- H-Line
  chart.hLine = chart:CreateLine()
  chart.hLine:SetColorTexture(0.7,0.7,0.7,.5)
  chart.hLine:SetStartPoint("TOPLEFT", 60, -40)
  chart.hLine:SetEndPoint("TOPRIGHT", 0, -40)
  -- V-Line
  chart.vLine = chart:CreateLine()
  chart.vLine:SetColorTexture(0.7,0.7,0.7,.5)
  chart.vLine:SetStartPoint("TOPLEFT", 60, -40)
  chart.vLine:SetEndPoint("BOTTOMLEFT", 60, 0)
  
  -- H-Values
  chart.dmgDone = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
  chart.dmgDone:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
  chart.dmgDone:SetPoint("TOPLEFT", 80, -20)
  chart.dmgDone:SetText('Dmg Done')
  -- V-Value table init
  chart.vValues = {}

  XPC:BuildChooseToon()

  single:Hide()
end

function XPC:ShowSingleToonChart()
  local chart = XPC_GUI.main.single.chart
  XPC_GUI.main.single:Show()

  -- Hide content that changes
  chart:Hide()
  for i, v in ipairs(chart.vValues) do
    v:Hide()
  end
  chart.vValues = {}

  -- V-values
  local levelData = XPC.db.global.toons[XPC.currSingleToon].levelData
  local level = levelData[#levelData].level
  for i = 0, level do 
    local value = chart:CreateFontString(nil, "OVERLAY", "SharedTooltipTemplate")
    value:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    if (i == 0) then 
      value:SetPoint("TOPLEFT", 12, -60 + (i * -30) )
      value:SetText('Total') 
    else 
      value:SetPoint("TOPLEFT", 24, -60 + (i * -30) )
      value:SetText(i) end
    table.insert(chart.vValues, value)
  end

  -- create chart content 
  chart.content = CreateFrame("Frame", content, chart)
  local content = chart.content
  content:SetSize(1140, 575)
  content:SetPoint("TOPLEFT")

  chart:Show()
end

function XPC:BuildChooseToon()
  -- choose toon window
  XPC_GUI.main.single.chooseToon = CreateFrame("Frame", chooseToon, XPC_GUI.main.single, "InsetFrameTemplate")
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