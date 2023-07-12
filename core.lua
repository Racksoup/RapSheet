XPC = LibStub("AceAddon-3.0"):NewAddon("RapSheet")
local L = LibStub("AceLocale-3.0"):GetLocale("RapSheetLocale")
XPC_GUI = {}
local icon = LibStub("LibDBIcon-1.0")
local XPC_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("XPC", {
  type = "data source",
  text = "Rap Sheet",
  icon = "interface/icons/inv_misc_book_12.blp",
  OnClick = function()
    if (XPC_GUI.main:IsVisible()) then 
      XPC_GUI.main:Hide()
    else 
      RequestTimePlayed()
      XPC:ShowView()
      XPC_GUI.main:Show()
    end
  end,
  OnTooltipShow = function(tooltip)
    tooltip:SetText("Rap Sheet")
  end,
})

local defaults = {
  global = {
    settings = {
      view = 'xpGraph'
    },
    toons = {
    },
    levelCharts = {
      classic = {
        400,    900,    1400,   2100,   2800,   3600,   4500,   5400,   6500,   7600, -- 1-10
        8800,   10100,  11400,  12900,  14400,  16000,  17700,  19400,  21300,  23200, -- 11- 20
        25200,  27300,  29400,  31700,  34000,  36400,  38900,  41400,  44300,  47400, -- 21-30
        50800,  54500,  58600,  62800,  67100,  71600,  76100,  80800,  85700,  90700, -- 31-40
        95800,  101000, 106300, 111800, 117500, 123200, 129100, 135100, 141200, 147500, -- 41-50
        153900, 160400, 167100, 173900, 180800, 187900, 195000, 202300, 209800, 217400 -- 51-60
      },
      wrath = {
        400,     900,     1400,    2100,    2800,    3600,    4500,    5400,    6500,    7600,
        8700,    9800,    11000,   12300,   13600,   15000,   16400,   17800,   19300,   20800,
        22400,   24000,   25500,   27200,   28900,   30500,   32200,   33900,   36300,   38800,
        41600,   44600,   48000,   51400,   55000,   58700,   62400,   66200,   70200,   74300,
        78500,   82800,   87100,   91600,   96300,   101000,  105800,  110700,  115700,  120900,
        126100,  131500,  137000,  142500,  148200,  154000,  159900,  165800,  172000,  290000,
        317000,  349000,  386000,  428000,  475000,  527000,  585000,  648000,  717000,  1523800,
        1539000, 1555700, 1571800, 1587900, 1604200, 1620700, 1637400, 1653900, 1670800
      },
      dragonlands = {
        250,    590,    1065,   1675,   2420,   3305,   4325,   5485,   6775,   8205, 
        9765,   11030,  12360,  13755,  15220,  16750,  18345,  20005,  21730,  23525, 
        25385,  27310,  29305,  31365,  33490,  35680,  37935,  40260,  42650,  45105, 
        45590,  46005,  46360,  46655,  46880,  47045,  47145,  47185,  47160,  47070, 
        46915,  46700,  46420,  46075,  45670,  45200,  44670,  44070,  43410,  42690,
        47565,  52600,  57785,  63135,  68635,  74295,  80110,  86085,  92215,  194815,
        214540, 234805, 255610, 276945, 298820, 321235, 344185, 367675, 391700 
      }
    },
  }
}

SLASH_XPC1 = "/xpc"

SlashCmdList["XPC"] = function()
  RequestTimePlayed()
  XPC:ShowView()
  XPC_GUI.main:Show()
end

function XPC:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("RapSheetDB", defaults, true)
  icon:Register("RapSheet", XPC_LDB, self.db.realm.minimap)
  -- self.db:ResetDB()

  XPC:CreateVars()

  XPC:StartTimePlayedLoop()
  XPC:StatsTracker()

  XPC:BuildMainWindow()
end

function ScrollFrame_OnMouseWheel(self, delta)
  local newValue = self:GetVerticalScroll() - (delta * 20);
 
  if (newValue < 0) then
    newValue = 0;
  elseif (newValue > self:GetVerticalScrollRange()) then
    newValue = self:GetVerticalScrollRange();
  end
 
  self:SetVerticalScroll(newValue);
end

function XPC:CreateVars()
  local name = UnitName('player')
  local server = GetRealmName()
  -- variables
  XPC.currToonName = name .. "-" .. server
  XPC.currSingleToon = XPC.currToonName
  XPC_GUI.XAxis = {}
  XPC_GUI.YAxis = {}
  XPC_GUI.Lines = {}
  XPC.numOfToons = 0
  XPC.justLeveled = false
  XPC.justStartedFlightPath = false
  XPC.isAFK = false
  XPC.currDeleteToon = nil
  XPC.prevMoney = 0
  XPC.merchantShow = false
  XPC.combatTime = 0
  for k,v in pairs(XPC.db.global.toons) do
    XPC.numOfToons = XPC.numOfToons + 1
  end
  -- init db vars
  XPC:InitToonData()
  -- set level chart  
  XPC.levelChart = XPC.db.global.levelCharts.classic
  version, build, datex, tocversion = GetBuildInfo()
  if (tocversion > 30000) then 
    XPC.levelChart = XPC.db.global.levelCharts.wrath
  end
  if (tocversion > 40000) then 
    XPC.levelChart = XPC.db.global.levelCharts.dragonlands
  end
end

function XPC:BuildMainWindow()
  -- main window
  XPC_GUI.main = CreateFrame("Frame", nil, UIParent, "InsetFrameTemplate")
  local main = XPC_GUI.main
  main:SetMovable(true)
  main:EnableMouse(true)
  main:RegisterForDrag("LeftButton")
  main:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  main:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  main:SetFrameStrata("HIGH")
  main:SetPoint("CENTER")
  main:SetWidth(1200)
  main:SetHeight(650)

  -- close button 
  main.closeBtn = CreateFrame("Button", nil, main, "UIPanelCloseButtonNoScripts")
  local closeBtn = main.closeBtn
  closeBtn:SetPoint("TOPRIGHT")
  closeBtn:SetScript('OnClick', function() main:Hide() end)

  -- options button
  main.optionsBtn = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  local optionsBtn = main.optionsBtn
  optionsBtn:SetSize(120, 25)
  optionsBtn:SetPoint("TOPRIGHT", -80, -14)
  optionsBtn:SetText("Options")
  optionsBtn:SetScript("OnClick", function() 
    local options = XPC_GUI.main.options
    if (options:IsVisible()) then
      options:Hide()
    else
      options:Show()
    end
  end)

  -- xp graph view button
  main.xpGraphBtn = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  local xpGraphBtn = main.xpGraphBtn
  xpGraphBtn:SetSize(120, 25)
  xpGraphBtn:SetPoint("TOPLEFT", 20, -14)
  xpGraphBtn:SetText("XP Chart")
  xpGraphBtn:SetScript("OnClick", function()
    XPC.db.global.settings.view = 'xpGraph'
    XPC:ShowView()
  end)

  -- single toon chart button 
  main.singleToon = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  local singleToon = main.singleToon
  singleToon:SetSize(120, 25)
  singleToon:SetPoint("TOPLEFT", 150, -14)
  singleToon:SetText("Stats")
  singleToon:SetScript("OnClick", function()
    XPC.db.global.settings.view = 'singleToonChart'
    XPC:ShowView()
  end)

  -- all toons chart button 
  -- main.allToonsBtn = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  -- local allToonsBtn = main.allToonsBtn
  -- allToonsBtn:SetSize(120, 25)
  -- allToonsBtn:SetPoint("TOPLEFT", 280, -14)
  -- allToonsBtn:SetText("Stats - All")
  -- allToonsBtn:SetScript("OnClick", function()
  --   XPC.db.global.settings.view = 'allToonsChart'
  --   XPC:ShowView()
  -- end)
  
  XPC:BuildXPGraphOptions()
  XPC:BuildSingleToon()
  -- show chart or graph
  -- XPC:ShowView()
  
  main:Hide()
end

function XPC:InitToonData()
  local toons = XPC.db.global.toons
  -- if toon data doesn't exist create it
  if (toons[XPC.currToonName] == nil) then 
    toons[XPC.currToonName] = {
      lineVisible = true,
      lineColor = {r = 1, g = 0, b = 0, a = 1},
      levelData = {},
      statsData = {}
    }
    -- call time played to init levelData
    RequestTimePlayed()
  end
  
 XPC:CreateStatsData(0)
end

function XPC:CreateStatsData(level) 
  local toon = XPC.db.global.toons[XPC.currToonName]
  local statList = {
    damageDealt = 0,
    damageTaken = 0,
    healsGiven = 0,
    healsReceived = 0,
    monstersKilledSolo = 0,
    monstersKilledInGroup = 0,
    questsCompleted = 0,
    food = 0,
    drink = 0,
    bandages = 0,
    potions = 0,
    scrolls = 0,
    elixirs = 0,
    flasks = 0,
    healingPotions = 0,
    manaPotions = 0,
    MHPotions = 0,
    healsGiven = 0,
    healsRecieved = 0,
    deaths = 0,
    pvpDeaths = 0,
    duelsWon = 0,
    duelsLost = 0,
    honorKills = 0,
    honor = 0,
    flightPaths = 0,
    timeOnTaxi = 0,
    timeAFK = 0,
    timeInCombat = 0,
    timePlayedAtLevel = 0,
    XPFromQuests = 0,
    XPFromMobs = 0,
    dungeonsEntered = 0,
    hearthstone = 0,
    goldFromQuests = 0,
    goldFromLoot = 0,
    goldLostMerchant = 0,
    goldGainedMerchant = 0,
  }
  
  -- init statsData and its level objects
  if (XPC.justLeveled) then 
    if (toon.statsData[tostring(level)] == nil) then
      toon.statsData[tostring(level)] = statList
    end
  else
    local stats = toon.statsData[tostring(UnitLevel('player'))]
    if (stats == nil) then
      stats = statList
    end
    if (stats.damageDealt == nil) then stats.damageDealt = 0 end
    if (stats.damageTaken == nil) then stats.damageTaken = 0 end
    if (stats.healsGiven == nil) then stats.healsGiven = 0 end
    if (stats.healsReceived == nil) then stats.healsReceived = 0 end
    if (stats.monstersKilledSolo == nil) then stats.monstersKilledSolo = 0 end
    if (stats.monstersKilledInGroup == nil) then stats.monstersKilledInGroup = 0 end
    if (stats.questsCompleted == nil) then stats.questsCompleted = 0 end
    if (stats.food == nil) then stats.food = 0 end
    if (stats.drink == nil) then stats.drink = 0 end
    if (stats.bandages == nil) then stats.bandages = 0 end
    if (stats.potions == nil) then stats.potions = 0 end
    if (stats.scrolls == nil) then stats.scrolls = 0 end
    if (stats.elixirs == nil) then stats.elixirs = 0 end
    if (stats.flasks == nil) then stats.flasks = 0 end
    if (stats.healingPotions == nil) then stats.healingPotions = 0 end
    if (stats.manaPotions == nil) then stats.manaPotions = 0 end
    if (stats.MHPotions == nil) then stats.MHPotions = 0 end
    if (stats.healsGiven == nil) then stats.healsGiven = 0 end
    if (stats.healsReceived == nil) then stats.healsReceived = 0 end
    if (stats.deaths == nil) then stats.deaths = 0 end
    if (stats.pvpDeaths == nil) then stats.pvpDeaths = 0 end
    if (stats.duelsWon == nil) then stats.duelsWon = 0 end
    if (stats.duelsLost == nil) then stats.duelsLost = 0 end
    if (stats.honorKills == nil) then stats.honorKills = 0 end
    if (stats.honor == nil) then stats.honor = 0 end
    if (stats.flightPaths == nil) then stats.flightPaths = 0 end
    if (stats.timeOnTaxi == nil) then stats.timeOnTaxi = 0 end
    if (stats.timeAFK == nil) then stats.timeAFK = 0 end
    if (stats.timeInCombat == nil) then stats.timeInCombat = 0 end
    if (stats.timePlayedAtLevel == nil) then stats.timePlayedAtLevel = 0 end
    if (stats.XPFromQuests == nil) then stats.XPFromQuests = 0 end
    if (stats.XPFromMobs == nil) then stats.XPFromMobs = 0 end
    if (stats.dungeonsEntered == nil) then stats.dungeonsEntered = 0 end
    if (stats.hearthstone == nil) then stats.hearthstone = 0 end
    if (stats.goldFromQuests == nil) then stats.goldFromQuests = 0 end
    if (stats.goldFromLoot == nil) then stats.goldFromLoot = 0 end
    if (stats.goldLostMerchant == nil) then stats.goldLostMerchant = 0 end
    if (stats.goldGainedMerchant == nil) then stats.goldGainedMerchant = 0 end
  end
end

function XPC:ShowView()
  local view = XPC.db.global.settings.view
  XPC:HideXPGraph()
  XPC:HideSingleToonChart()
  XPC:HideAllToonsChart()
  if (view == 'xpGraph') then
    XPC:ShowXPGraph()
  end
  if (view == 'singleToonChart') then
    XPC:ShowSingleToonChart()
  end
  if (view == 'AllToonsChart') then
    XPC:ShowAllToonsChart()
  end
end

function XPC:StartTimePlayedLoop() 
  -- only track data if the player is less than lvl 60
  local currLvl = UnitLevel("player")
  local maxLevel = 60
  version, build, datex, tocversion = GetBuildInfo()
  if (tocversion > 20000) then 
    maxLevel = 70
  end
  if (tocversion > 30000) then 
    maxLevel = 80
  end
  if (tocversion > 40000) then 
    maxLevel = 70
  end
  if (currLvl < maxLevel) then
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
      totalXP = totalXP + XPC.levelChart[i]
    end
    totalXP = totalXP + currXP

    local levelData = {
      timePlayed = arg1, 
      level = currLvl, 
      XPGainedThisLevel = currXP, 
      totalXP = totalXP
    }

    table.insert(XPC.db.global.toons[XPC.currToonName].levelData, levelData)

    if (XPC.justLeveled == true) then
      XPC.justLeveled = false
      local stats = XPC.db.global.toons[XPC.currSingleToon].statsData[tostring(UnitLevel('player') -1)]
      stats.timePlayedAtLevel = arg1
    end
  end
end

function XPC:StoD(val)
    return val / 60 / 60 / 24
end

function XPC:DtoS(val)
    return val * 60 * 60 * 24
end

function XPC:ShowColorPicker(color, changedCallback)
  local r, g, b, a = color.r, color.g, color.b, color.a;
  ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
  ColorPickerFrame.previousValues = {r,g,b,a};
  ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
    changedCallback, changedCallback, changedCallback;
  ColorPickerFrame:SetColorRGB(r,g,b);
  ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
  ColorPickerFrame:Show();
end

-- change addon name to 'Level Stats'??? maybe

-- list of quests completed per level
-- list of monsters killed by name.  per level. solo and total