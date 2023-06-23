XPC = LibStub("AceAddon-3.0"):NewAddon("XPChart")
local L = LibStub("AceLocale-3.0"):GetLocale("XPChartLocale")
local XPC_GUI = LibStub("AceGUI-3.0")

local defaults = {
  global = {
    toons = {
    },
    XPToLevel = {
      Classic = {
        400,    900,    1400,   2100,   2800,   3600,   4500,   5400,   6500,   7600, -- 1-10
        8800,   10100,  11400,  12900,  14400,  16000,  17700,  19400,  21300,  23200, -- 11- 20
        25200,  27300,  29400,  31700,  34000,  36400,  38900,  41400,  44300,  47400, -- 21-30
        50800,  54500,  58600,  62800,  67100,  71600,  76100,  80800,  85700,  90700, -- 31-40
        95800,  101000, 106300, 111800, 117500, 123200, 129100, 135100, 141200, 147500, -- 41-50
        153900, 160400, 167100, 173900, 180800, 187900, 195000, 202300, 209800, 217400 -- 51-60
      },
    },
  }
}

SLASH_XPC1 = "/xpc"

SlashCmdList["XPC"] = function()
  RequestTimePlayed()
  XPC_GUI.MainFrame:Show()
end

function XPC:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("XPChartDB", defaults, true)
  -- self.db:ResetDB()

  XPC:StartTimePlayedLoop()

  XPC:CreateUI()
end

function XPC:CreateUI()
  -- variables
  local name, server = UnitFullName('player', true)
  XPC.currToonName = name .. "-" .. server
  -- init db vars
  XPC:InitToonData()

  -- build
  XPC:BuildChartLayout()
  XPC:BuildSideFrameLayout();
  XPC_GUI.MainFrame:Hide()
  XPC_GUI.MainFrame.SideFrame:Hide()
end

function XPC:BuildChartLayout()
  -- main window
  XPC_GUI.MainFrame = CreateFrame("Frame", nil, UIParent, "InsetFrameTemplate")
  local mainFrame = XPC_GUI.MainFrame
  mainFrame:SetMovable(true)
  mainFrame:EnableMouse(true)
  mainFrame:RegisterForDrag("LeftButton")
  mainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  mainFrame:SetFrameStrata("HIGH")
  mainFrame:SetPoint("CENTER")
  mainFrame:SetWidth(1200)
  mainFrame:SetHeight(650)

  -- close button 
  local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButtonNoScripts")
  closeButton:SetPoint("TOPRIGHT")
  closeButton:SetScript('OnClick', function() mainFrame:Hide() end)

  -- options button
  local optionsButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
  optionsButton:SetSize(150, 16)
  optionsButton:SetPoint("TOPRIGHT", -100, -7)
  optionsButton:SetText("Options")
  optionsButton:SetScript("OnClick", function() XPC_GUI.MainFrame.SideFrame:Show() end)

  local mostTimePlayed, highestLevel, totalXPOfHighestLevelToon = XPC:GetGraphData()
  
  local frameWidth = 1150
  local frameHeight = 590
  local frameWidthInterval = frameWidth / mostTimePlayed 
  local frameHeightInterval = frameHeight / totalXPOfHighestLevelToon
  local mostDaysPlayed = math.floor(XPC:StoD(mostTimePlayed))

  XPC:BuildXAxis(mostTimePlayed, mostDaysPlayed, frameWidthInterval, frameHeight)
  XPC:BuildYAxis(highestLevel, frameHeightInterval, totalXPOfHighestLevelToon, frameWidth)
  XPC:BuildAllLines(frameWidthInterval, frameHeightInterval)
  XPC:BuildSideFrameLayout()
  
  mainFrame:Show()
end

function XPC:InitToonData()
  local toons = XPC.db.global.toons
  -- if toon data doesn't exist create it
  if (toons[XPC.currToonName] == nil) then 
    toons[XPC.currToonName] = {
      lineVisible = true,
      lineColor = {r = 1, g = 0, b = 0, a = 1},
      levelData = {}
    }
    -- call time played to init levelData
    RequestTimePlayed()
  end
end

function XPC:GetGraphData()
  -- find and save highest amount of time played on any character, highest level of any character
  local mostTimePlayed = 0
  local highestLevel = 0
  local totalXPOfHighestLevelToon = 0
  local XPOnLastLvl = 0
  for i, toon in pairs(XPC.db.global.toons) do
    if (toon.lineVisible == true) then
      local lastData = toon.levelData[#toon.levelData]
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

  -- save total collected xp from highest level toon
  for i = 2, highestLevel do 
    totalXPOfHighestLevelToon = totalXPOfHighestLevelToon + XPC.db.global.XPToLevel.Classic[i - 1]
  end
  totalXPOfHighestLevelToon = totalXPOfHighestLevelToon + XPOnLastLvl

  return mostTimePlayed, highestLevel, totalXPOfHighestLevelToon
end

function  XPC:BuildSideFrameLayout()
  local r,g,b,a = 1, 0, 0, 1;
  

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
    XPC.db.global.toons[XPC.currColorToon].lineColor.r = r
    XPC.db.global.toons[XPC.currColorToon].lineColor.g = g
    XPC.db.global.toons[XPC.currColorToon].lineColor.b = b
    XPC.db.global.toons[XPC.currColorToon].lineColor.a = a
  end

  -- side frame
  XPC_GUI.MainFrame.SideFrame = CreateFrame("Frame", nil, XPC_GUI.MainFrame, "InsetFrameTemplate")
  local sideFrame = XPC_GUI.MainFrame.SideFrame
  sideFrame:SetMovable(true)
  sideFrame:EnableMouse(true)
  sideFrame:RegisterForDrag("LeftButton")
  sideFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  sideFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  sideFrame:SetPoint("CENTER", 200, 0);
  sideFrame:SetWidth(400)
  sideFrame:SetHeight(400) 

  -- close button 
  local closeButton = CreateFrame("Button", nil, sideFrame, "UIPanelCloseButtonNoScripts")
  closeButton:SetPoint("TOPRIGHT")
  closeButton:SetScript('OnClick', function() sideFrame:Hide() end)
  
  -- make line for each toon
  local lastbtn
  local firstLoop = true
  local toons = XPC.db.global.toons
  for k, toon in pairs(toons) do
    
    -- make button change toon color (sets point for label and checkbox to position off of)
    local button
    if (firstLoop) then
      button = CreateFrame("Button", toon, XPC_GUI.MainFrame.SideFrame, "UIPanelButtonTemplate")
      button:SetPoint("TOPRIGHT", -16 , -40)
      firstLoop = false;
    else
      button = CreateFrame("Button", toon, lastbtn, "UIPanelButtonTemplate")
      button:SetPoint("TOP", 0, -30)
    end
    button:SetWidth(100)
    button:SetHeight(25)
    button:SetText("Pick Color")
    button:SetScript("OnClick", function() 
      XPC.currColorToon = k
      local color = toon.lineColor
      XPC:ShowColorPicker(color.r, color.g, color.b, color.a, myColorCallback) 
    end)
    -- lists all lines after eachother using first btn pos
    lastbtn = button

    -- toon name
    local buttonLabel = button:CreateFontString(nil, "OVERLAY", "GameToolTipText")
    buttonLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
    buttonLabel:SetPoint("LEFT", -240, 0)
    local fString = string.format("Show - %s", k)
    buttonLabel:SetText(fString)

    -- show toon checkbox
    local checkbox = CreateFrame("CheckButton", nil, button, "ChatConfigCheckButtonTemplate")
    checkbox:SetPoint("LEFT", -265, 0)
    checkbox:SetSize(20, 20)
    checkbox:SetChecked(toon.lineVisible)
    checkbox:SetScript("OnClick", function() 
      toon.lineVisible = not toon.lineVisible 
    end)
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
      if (i <= #v - counterLimit) then 
        local EndTime = v[i + counterLimit].timePlayed
        local EndXP = v[i + counterLimit].totalXP
        XPC:BuildALine(frameWidthInterval, frameHeightInterval, StartTime, StartXP, EndTime, EndXP, v.lineColor)
      end
      counter = 1
    else 
      counter = counter + 1
    end
  end
end

function XPC:BuildALine(frameWidthInterval, frameHeightInterval, StartTime, StartXP, EndTime, EndXP, LC)
  local line = XPC_GUI.MainFrame:CreateLine()
  local offset = 10
  
  line:SetColorTexture(LC[1], LC[2], LC[3], LC[4])
  line:SetStartPoint("BOTTOMLEFT", frameWidthInterval * StartTime + offset, frameHeightInterval * StartXP + offset )
  line:SetEndPoint("BOTTOMLEFT", frameWidthInterval * EndTime + offset, frameHeightInterval * EndXP + offset )
end

function XPC:BuildXAxis(mostTimePlayed, mostDaysPlayed, frameWidthInterval, frameHeight)
  -- find spacing. we want to divide by 5 then 4 then 3 then 2 trying to find a mod% full remainder value
  -- if mod == division
  -- else go with divide by 4 and decimal points
  local mostDaysPlayed = mostDaysPlayed
  if (mostDaysPlayed < 5) then
    mostDaysPlayed = XPC:StoD(mostTimePlayed)

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
      local fstring = XPC_GUI.MainFrame:CreateFontString(nil, "OVERLAY", "GameToolTipText")
      fstring:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
      fstring:SetText(math.floor(10 * (mostDaysPlayed * 24) * (i / numOfTextObjs)) /10)
      fstring:SetPoint("BOTTOMLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) - alignLines + offset, 4)
      local line = XPC_GUI.MainFrame:CreateLine()
      line:SetColorTexture(0.7,0.7,0.7,.1)
      line:SetStartPoint("BOTTOMLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) + alignLines + offset, 0)
      line:SetEndPoint("TOPLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) + alignLines + offset, -20)
    end
  else
    local numOfTextObjs = 0
    local modNum = 0
    
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
      local fstring = XPC_GUI.MainFrame:CreateFontString(nil, "OVERLAY", "GameToolTipText")
      local offset = 8
      fstring:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
      fstring:SetText(math.floor(100 * mostDaysPlayed * (i / numOfTextObjs)) /100)
      fstring:SetPoint("BOTTOMLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) - offset, 4)
      local line = XPC_GUI.MainFrame:CreateLine()
      line:SetColorTexture(0.7,0.7,0.7,.1)
      line:SetStartPoint("BOTTOMLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) + offset, 0)
      line:SetEndPoint("TOPLEFT", frameWidthInterval * XPC:DtoS(mostDaysPlayed) * (i / numOfTextObjs) +offset, -20)
    end
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
          totalXPOfGraphIndex = totalXPOfGraphIndex + XPC.db.global.XPToLevel.Classic[j - 1]
      end
      local fstring = XPC_GUI.MainFrame:CreateFontString(nil, "OVERLAY", "GameToolTipText")
      fstring:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
      fstring:SetText(highestLevel * lineLevelPercentage)

      fstring:SetPoint("BOTTOMLEFT", 5, frameHeightInterval * totalXPOfGraphIndex -alignLines + offset)
      local line = XPC_GUI.MainFrame:CreateLine()
      line:SetColorTexture(0.7,0.7,0.7,.1)
      line:SetStartPoint("BOTTOMLEFT", 0, frameHeightInterval * totalXPOfGraphIndex +alignLines + offset)
      line:SetEndPoint("BOTTOMRIGHT", 0, frameHeightInterval * totalXPOfGraphIndex +alignLines + offset)
    end
  end
end

function XPC:StartTimePlayedLoop() 
  -- only track data if the player is less than lvl 60
  local currLvl = UnitLevel("player")
  if (currLvl < 60) then
    -- create frame&script to track time played msg
    XPC_GUI.scripts = CreateFrame("Frame")
    XPC_GUI.scripts:RegisterEvent("TIME_PLAYED_MSG")
    XPC_GUI.scripts:SetScript("OnEvent", function(self, event, ...) XPC:OnTimePlayedEvent(self, event, ...) end)
    
    -- request time played every 15min, works on login too
    function TimePlayedLoop()
      RequestTimePlayed() 
      C_Timer.After(900, function() TimePlayedLoop() end)
    end
    -- starts 60 seconds after login
    C_Timer.After(60, function() TimePlayedLoop() end)
  end
end

function XPC:OnTimePlayedEvent(self, event, ...)
  if (event == "TIME_PLAYED_MSG") then
    local currXP = UnitXP("player")
    local currLvl = UnitLevel("player")
    local arg1, arg2 = ...
    local totalXP = 0
    for i = 1, currLvl -1 do 
      totalXP = totalXP + XPC.db.global.XPToLevel.Classic[i]
    end
    totalXP = totalXP + currXP

    print('here')
    table.insert(XPC.db.global.toons[XPC.currToonName].levelData, {
      timePlayed = arg1, 
      level = currLvl, 
      XPGainedThisLevel = currXP, 
      totalXP = totalXP
    })
  end
end

function XPC:StoD(val)
    return val / 60 / 60 / 24
end

function XPC:DtoS(val)
    return val * 60 * 60 * 24
end

function XPC:ShowColorPicker(r, g, b, a, changedCallback)
  ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
  ColorPickerFrame.previousValues = {r,g,b,a};
  ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
    changedCallback, changedCallback, changedCallback;
  ColorPickerFrame:SetColorRGB(r,g,b);
  ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
  ColorPickerFrame:Show();
end


-- restructure. this code is bs
-- condense to one addon
-- make for all game versions with xp tables 
-- minimap icon
-- reset all data button

-- max levels checkbox. perspective with max xp as height for the chart (shows progress out of full level 60 xp amount, 6,079,800)
-- even levels checkbox. view where every level is spaced equally on y-axis

-- list view, can show most stats. overall time at level, gold made, damage taken, damage dealt
-- number of monsters killed
-- number of quests comleted
-- percentage and number of quest/farm xp gained  
-- potions used
-- food / bandages used
-- gold made per level 
-- average/overall dps per level
-- average/overall damage taken per level

