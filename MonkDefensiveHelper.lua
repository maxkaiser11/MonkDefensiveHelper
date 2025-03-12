local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("PLAYER_LOGIN")

-- Create the warning frame
local warningFrame = CreateFrame("Frame", nil, UIParent)
warningFrame:SetSize(300, 100)
warningFrame:SetPoint("CENTER")
warningFrame:SetAlpha(0)

local warningText = warningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
warningText:SetPoint("CENTER")
warningText:SetText("USE DEFENSIVE!")
warningText:SetTextColor(1, 0, 0, 1) -- red color

-- Animation group
local fadeGroup = warningFrame:CreateAnimationGroup()
local fadeOut = fadeGroup:CreateAnimation("Alpha")
fadeOut:SetFromAlpha(1)
fadeOut:SetToAlpha(0)
fadeOut:SetDuration(1.5)
fadeOut:SetSmoothing("OUT")

local function ShowWarning()
    warningFrame:SetAlpha(1)
    fadeGroup:Stop()
    fadeGroup:Play()
end

local function GetSpellCooldownSeconds(spellID)
    local start, duration = C_Spell.GetSpellCooldown(spellID)
    if not start or duration == 0 then return 0 end
    return start + duration - GetTime()
end

local function CheckDefensives()
    local healthPercent = (UnitHealth("player") / UnitHealthMax("player")) * 100

    local brewCD = GetSpellCooldownSeconds(115203)   -- Fortifying Brew
    local dampenCD = GetSpellCooldownSeconds(122278) -- Dampen Harm

    if healthPercent <= 40 then
        if brewCD <= 0 or dampenCD <= 0 then
            ShowWarning()
        end
    end
end

f:SetScript("OnEvent", function(_, event, arg)
    if event == "UNIT_HEALTH" and arg == "player" then
        CheckDefensives()
    end
end)
