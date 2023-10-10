function XPC:GetGraphData()
  -- find and save highest amount of time played on any character, highest level of any character
  local mostTimePlayed = 0
  local highestLevel = 0
  local totalXPOfHighestLevelToon = 0
  local XPOnLastLvl = 0
  for i, toon in pairs(XPC.db.global.toons) do
    if (toon.lineVisible == true) then
      local lastData = toon.levelData[#toon.levelData]
      if (lastData) then
        if (lastData.timePlayed > mostTimePlayed) then 
          mostTimePlayed = lastData.timePlayed 
        end
        if (lastData.level > highestLevel) then 
          highestLevel = lastData.level 
          XPOnLastLvl = 0 
        end
        if (lastData.level == highestLevel) then 
          if (lastData.XPGainedThisLevel > XPOnLastLvl) then 
            XPOnLastLvl = lastData.XPGainedThisLevel  
          end
        end
      end
    end 
  end

  -- save total collected xp from highest level toon
  for i = 2, highestLevel do 
    totalXPOfHighestLevelToon = totalXPOfHighestLevelToon + XPC.levelChart[i - 1]
  end
  totalXPOfHighestLevelToon = totalXPOfHighestLevelToon + XPOnLastLvl

  -- frame values
  local frameWidth = 1150
  local frameHeight = 590
  local frameWidthInterval = frameWidth / mostTimePlayed 
  local frameHeightInterval = frameHeight / totalXPOfHighestLevelToon
  local mostDaysPlayed = math.floor(XPC:StoD(mostTimePlayed))

  return mostTimePlayed, highestLevel, totalXPOfHighestLevelToon, frameWidth, frameHeight, frameWidthInterval, frameHeightInterval, mostDaysPlayed
end

function XPC:HideXPGraph()
  XPC_GUI.main.optionsBtn:Hide()
  -- reset axis and lines
  for i, v in ipairs(XPC_GUI.XAxis) do
    v.fstring:Hide()
    v.line:Hide()
  end
  for i, v in ipairs(XPC_GUI.YAxis) do
    v.fstring:Hide()
    v.line:Hide()
  end
  for i, v in ipairs(XPC_GUI.Lines) do
    v:Hide()
  end
end

function XPC:ShowXPGraph()
  XPC:HideXPGraph()
  XPC_GUI.main.optionsBtn:Show()

  -- setup values to make graph and lines
  local mostTimePlayed, highestLevel, totalXPOfHighestLevelToon, frameWidth, frameHeight, frameWidthInterval, frameHeightInterval, mostDaysPlayed = XPC:GetGraphData()

  XPC:BuildXAxis(mostTimePlayed, mostDaysPlayed, frameWidthInterval, frameHeight)
  XPC:BuildYAxis(highestLevel, frameHeightInterval, totalXPOfHighestLevelToon, frameWidth)
  XPC:BuildAllLines(frameWidthInterval, frameHeightInterval)
end

function XPC:BuildXAxis(mostTimePlayed, mostDaysPlayed, frameWidthInterval, frameHeight)
  -- find spacing. we want to divide by 5 then 4 then 3 then 2 trying to find a mod% full remainder value
  -- if mod == division
  -- else go with divide by 4 and decimal points
  local function BuildXAxisHoursOrDays(hoursOrDays)
    if (hoursOrDays == 24) then mostDaysPlayed = XPC:StoD(mostTimePlayed)end
    local numOfTextObjs = 0
    local modNum = 0
    local alignLines = 8
    local offset = 10

    -- mod mostDaysPlayed from 5 to 1.
    for i=5, 0, -1 do      
      modNum = math.floor(mostDaysPlayed) % i
      -- if modNum is 0 break the loop and set numOfTextObjs to i 
      if (modNum == 0) then
        -- if we reach 1 numOfTextObjs should be 4
        if (i == 1) then numOfTextObjs = 4 
        else numOfTextObjs = i end
        break
      end 
    end

    -- make x-axis text
    for i=1, numOfTextObjs do 
      local fstring = XPC_GUI.main:CreateFontString(nil, "OVERLAY", "GameToolTipText")
      fstring:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
      fstring:SetText(math.floor(10 * (mostDaysPlayed * hoursOrDays) * (i / numOfTextObjs)) /10)
      fstring:SetPoint("BOTTOMLEFT", frameWidthInterval * mostTimePlayed * (i / numOfTextObjs) - alignLines + offset, 4)
      local line = XPC_GUI.main:CreateLine()
      line:SetColorTexture(0.7,0.7,0.7,.1)
      line:SetStartPoint("BOTTOMLEFT", frameWidthInterval * mostTimePlayed * (i / numOfTextObjs) + alignLines + offset, 0)
      line:SetEndPoint("TOPLEFT", frameWidthInterval * mostTimePlayed * (i / numOfTextObjs) + alignLines + offset, -40)
      table.insert(XPC_GUI.XAxis, {line = line, fstring = fstring})
    end
  end
    
  if (mostDaysPlayed < 5) then
    BuildXAxisHoursOrDays(24)
  else
    BuildXAxisHoursOrDays(1)
  end
end

function XPC:BuildYAxis(highestLevel, frameHeightInterval, totalXPOfHighestLevelToon, frameWidth)
  -- find spacing. we want to divide by 5 then 4 then 3 then 2 trying to find a mod% full remainder value
  -- if mod == division
  -- else go with divide by 4 and decimal points

  local alignLines = 5
  local offset = 6

  if (highestLevel < 60) then
    local numOfTextObjs = 0
    local modNum = 0

    -- mod highestLevel from 15 to 1.
    for i=15, 0, -1 do      
      modNum = highestLevel % i
      -- if modNum is 0 break the loop and set numOfTextObjs to i 
      if (modNum == 0) then
        -- if we reach 1 numOfTextObjs should be 4
        if (i <= 4) then numOfTextObjs = 8 
        else numOfTextObjs = i end
        break
      end 
    end
    
    -- make y-axis text
    local x 
    if (highestLevel < 5) then
      x = 1
    elseif (highestLevel < 10) then
      x = 3
    else
      x = 4
    end

    for i = x, numOfTextObjs do 
      local totalXPOfGraphIndex = 0
      local lineLevelPercentage = (i / numOfTextObjs)
      for j = 2, (highestLevel * lineLevelPercentage) do 
        totalXPOfGraphIndex = totalXPOfGraphIndex + XPC.levelChart[j - 1]
      end
      local fstring = XPC_GUI.main:CreateFontString(nil, "OVERLAY", "GameToolTipText")
      fstring:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
      fstring:SetText(highestLevel * lineLevelPercentage)

      fstring:SetPoint("BOTTOMLEFT", 5, frameHeightInterval * totalXPOfGraphIndex -alignLines + offset)
      local line = XPC_GUI.main:CreateLine()
      line:SetColorTexture(0.7,0.7,0.7,.1)
      line:SetStartPoint("BOTTOMLEFT", 0, frameHeightInterval * totalXPOfGraphIndex +alignLines + offset)
      line:SetEndPoint("BOTTOMRIGHT", 0, frameHeightInterval * totalXPOfGraphIndex +alignLines + offset)

      table.insert(XPC_GUI.YAxis, {line = line, fstring = fstring})
    end
  end
end

function XPC:BuildAllLines(frameWidthInterval, frameHeightInterval)
  --find biggest DB
  local longestDB = 1
  local counterLimit = 1
  for i, v in pairs(XPC.db.global.toons) do 
      if(XPC.db.global.toons[XPC.currToonName].lineVisible == true) then 
        if (longestDB < #v) then longestDB = #v end
    end
  end

  -- set number of data point to skip (when data gets larger, skip some data)
  if (longestDB > 100) then counterLimit = 2 end
  if (longestDB > 300) then counterLimit = 3 end
  if (longestDB > 500) then counterLimit = 4 end
  if (longestDB > 1000) then counterLimit = 5 end
  if (longestDB > 1500) then counterLimit = 6 end
  if (longestDB > 2000) then counterLimit = 7 end
  if (longestDB > 2500) then counterLimit = 8 end
  if (longestDB > 3000) then counterLimit = 9 end
  if (longestDB > 3500) then counterLimit = 10 end
  if (longestDB > 4000) then counterLimit = 11 end
  if (longestDB > 4500) then counterLimit = 12 end
  if (longestDB > 5000) then counterLimit = 13 end
  if (longestDB > 5500) then counterLimit = 14 end
  if (longestDB > 6000) then counterLimit = 15 end
  if (longestDB > 6500) then counterLimit = 16 end
  if (longestDB > 7000) then counterLimit = 17 end
  if (longestDB > 7500) then counterLimit = 18 end
  if (longestDB > 8000) then counterLimit = 19 end
  if (longestDB > 8500) then counterLimit = 20 end
  if (longestDB > 9000) then counterLimit = 21 end
  if (longestDB > 9500) then counterLimit = 22 end
  if (longestDB > 10000) then counterLimit = 23 end
  if (longestDB > 10500) then counterLimit = 24 end
  if (longestDB > 11000) then counterLimit = 25 end
  if (longestDB > 11500) then counterLimit = 26 end
  if (longestDB > 12000) then counterLimit = 27 end
  if (longestDB > 12500) then counterLimit = 28 end
  if (longestDB > 13000) then counterLimit = 29 end
  if (longestDB > 13500) then counterLimit = 30 end
  if (longestDB > 14000) then counterLimit = 31 end
  if (longestDB > 14500) then counterLimit = 32 end
  if (longestDB > 15000) then counterLimit = 33 end
  if (longestDB > 15500) then counterLimit = 34 end
  if (longestDB > 16000) then counterLimit = 35 end
  if (longestDB > 16500) then counterLimit = 36 end

  -- build lines
  for k, toon in pairs(XPC.db.global.toons) do
    if(toon.lineVisible == true) then 
      XPC:BuildFullLine(frameWidthInterval, frameHeightInterval, toon, counterLimit)
    end
  end
end

function XPC:BuildFullLine(frameWidthInterval, frameHeightInterval, toon, counterLimit)
  local counter = 1

  -- creates lines for all values in toon.levelData
  for i, v in ipairs(toon.levelData) do
    -- skips curr levelData if there is a limit to reduce number of lines created
    if (counter >= counterLimit) then
      local StartTime = v.timePlayed
      local StartXP = v.totalXP
      -- stops from making last line with incomplete data
      if (i <= #toon.levelData - counterLimit) then 
        local EndTime = toon.levelData[i + counterLimit].timePlayed
        local EndXP = toon.levelData[i + counterLimit].totalXP
        XPC:BuildALine(frameWidthInterval, frameHeightInterval, StartTime, StartXP, EndTime, EndXP, toon.lineColor)
      end
      counter = 1
    else 
      counter = counter + 1
    end
  end
end

function XPC:BuildALine(frameWidthInterval, frameHeightInterval, StartTime, StartXP, EndTime, EndXP, color)
  local line = XPC_GUI.main:CreateLine()
  local offset = 10
  
  line:SetColorTexture(color.r, color.g, color.b, color.a)
  line:SetStartPoint("BOTTOMLEFT", frameWidthInterval * StartTime + offset, frameHeightInterval * StartXP + offset )
  line:SetEndPoint("BOTTOMLEFT", frameWidthInterval * EndTime + offset, frameHeightInterval * EndXP + offset )

  table.insert(XPC_GUI.Lines, line)
end

function XPC:BuildXPGraphOptions()
  local function myColorCallback(restore)
    local newR, newG, newB, newA;
    if restore then
      -- The user bailed, we extract the old color from the table created by ShowColorPicker.
      newR, newG, newB, newA = unpack(restore);
    else
      -- Something changed
      newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
    
    -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA;
    -- And update any UI elements that use this color...
    local color = XPC.db.global.toons[XPC.currColorToon].lineColor
    color.r = r
    color.g = g
    color.b = b
    color.a = a

    XPC:ShowXPGraph()
  end
  
  -- side frame
  XPC_GUI.main.options = CreateFrame("Frame", nil, XPC_GUI.main, "InsetFrameTemplate")
  local options = XPC_GUI.main.options
  options:SetMovable(true)
  options:EnableMouse(true)
  options:RegisterForDrag("LeftButton")
  options:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  options:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  options:SetPoint("TOPRIGHT", -60, -60);
  options:SetWidth(390)
  options:SetHeight(341) 
  
  -- scroll frame
  options.scrollFrame = CreateFrame("ScrollFrame", nil, options, "UIPanelScrollFrameTemplate")
  local scrollFrame = options.scrollFrame
  scrollFrame:SetScript('OnMouseWheel', ScrollFrame_OnMouseWheel)
  scrollFrame:SetPoint("TOPRIGHT", -31, -30)
  scrollFrame:SetSize(345, 302)

  -- side frame content
  options.content = CreateFrame("Frame", nil, scrollFrame)
  local content = options.content
  content:SetSize(345, XPC.numOfToons * 30 + 35)
  content:SetClipsChildren(true)
  scrollFrame:SetScrollChild(content)

  -- close button 
  local closeBtn = CreateFrame("Button", nil, options, "UIPanelCloseButtonNoScripts")
  closeBtn:SetPoint("TOPRIGHT")
  closeBtn:SetScript('OnClick', function() options:Hide() end)
  
  -- make line for each toon
  local i = 0
  for k, toon in pairs(XPC.db.global.toons) do
    local button = CreateFrame("Button", toon, content, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", 35, i * -30)
    button:SetSize(25, 25)
    button:SetText("C")
    button:SetScript("OnClick", function() 
      XPC.currColorToon = k
      XPC:ShowColorPicker(toon.lineColor, myColorCallback) 
    end)

    local deleteBtn = CreateFrame("Button", toon, content, "UIPanelButtonTemplate")
    deleteBtn:SetPoint("TOPLEFT", 65, i * -30)
    deleteBtn:SetSize(25, 25)
    deleteBtn:SetText("X")
    deleteBtn:SetScript("OnClick", function() 
      local del = XPC_GUI.main.del
      del.l2:SetText(k)
      XPC.currDeleteToon = nil
      XPC.currDeleteToon = k
      del:Hide()
      del:Show()
      XPC.delTimer = C_Timer.NewTicker(5, function() 
        XPC.currDeleteToon = nil
        del:Hide() 
      end, 1)
    end)

    -- toon name
    local label = content:CreateFontString(nil, "OVERLAY", "GameToolTipText")
    label:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
    label:SetPoint("TOPLEFT", 100, (i * -30) -5)
    label:SetText(k)

    -- show toon checkbox
    local checkbox = CreateFrame("CheckButton", nil, content, "ChatConfigCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 0, i * -30)
    checkbox:SetSize(25, 25)
    checkbox:SetChecked(toon.lineVisible)
    checkbox:SetScript("OnClick", function() 
      toon.lineVisible = not toon.lineVisible 
      XPC:ShowXPGraph()
    end)

    i = i + 1
  end 

  XPC:BuildDeleteWindow()

  options:Hide()
end

function XPC:BuildDeleteWindow()
  local main = XPC_GUI.main

  main.delPosFrame = CreateFrame("Frame", nil, UIParent)
  main.delPosFrame:SetPoint("CENTER")
  main.delPosFrame:SetSize(300,120)
  main.delPosFrame:SetFrameStrata("TOOLTIP")
  main.del = CreateFrame("Frame", del, main.delPosFrame, "DialogBorderDarkTemplate")
  local del = main.del
  del:SetPoint("CENTER")

  del.l1 = del:CreateFontString()
  del.l1:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
  del.l1:SetPoint("TOP", 0, -20)
  del.l1:SetText('Delete Character Data?')
  del.l2 = del:CreateFontString()
  del.l2:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
  del.l2:SetPoint("TOP", 0, -45)

  del.deleteBtn = CreateFrame("Button", nil, del, "UIPanelButtonTemplate")
  local deleteBtn = del.deleteBtn
  deleteBtn:SetSize(100, 25)
  deleteBtn:SetPoint("BOTTOMLEFT", 40, 20)
  deleteBtn:SetText('Delete')
  deleteBtn:SetScript("OnClick", function()
    XPC.db.global.toons[XPC.currDeleteToon] = nil
    print(XPC.currDeleteToon .. 'has been deleted')
    XPC.currDeleteToon = nil
    XPC.delTimer:Cancel()
    del:Hide() 
  end)

  del.cancelBtn = CreateFrame("Button", nil, del, "UIPanelButtonTemplate")
  local cancelBtn = del.cancelBtn
  cancelBtn:SetSize(100, 25)
  cancelBtn:SetPoint("BOTTOMRIGHT", -40, 20)
  cancelBtn:SetText('Cancel')
  cancelBtn:SetScript("OnClick", function()
    XPC.currDeleteToon = nil
    XPC.delTimer:Cancel()
    del:Hide() 
  end)

  del:Hide()
end

-- max levels checkbox. perspective with max xp as height for the chart (shows progress out of full level 60 xp amount, 6,079,800)
-- even levels checkbox. view where every level is spaced equally on y-axis
-- push graph in so it isn't on the labels

-- if no lines visible on startup show current toon
-- create real graph object to hold all lines and fstrings. makes hiding a lot easier