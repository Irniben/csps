local GS = GetString

local mundusLocs = { -- mundus locations for tooltip
	[13984] = { 108,	20, 117}, 	-- shadow
	[13985] = {383, 19, 57}, 		-- tower
	[13940] = {58, 104, 101}, 		-- warrior
	[13974] = {108,	20, 117,}, 		-- serpent
	[13943] = {383, 19, 57 ,}, 		-- mage
	[13976] = {381 ,3, 41 ,}, 		-- lord
	[13977] = {382, 92, 103,}, 		-- steed
	[13978] = {383, 19, 57,}, 		-- lady
	[13979] = {382 ,92, 103,}, 		-- apprentice
	[13980] = {58, 104 ,101,} ,		-- ritual
	[13981] = {381, 3, 41,}, 		-- lover
	[13982] = {108, 20, 117,},		-- atronarch
	[13975] = {58, 104, 101,}, 		-- thief
}

local mundusAbs = {
  [13984] = 60599, -- shadow
  [13985] = 60554, -- tower
  [13940] = 60462, -- warrior
  [13974] = 60594, -- serpent
  [13943] = 60550, -- mage
  [13978] = 60579, -- lord
  [13977] = 60604, -- steed
  [13976] = 60574, -- lady
  [13979] = 60556, -- apprentice
  [13980] = 60589, -- ritual
  [13981] = 60584, -- lover
  [13982] = 60569, -- atronach
  [13975] = 60610, -- thief
}

local currentMundusId = false

local function getCurrentMundus()
	local numBuffs = GetNumBuffs("player")
    for i = 1, numBuffs do
        local _, _, _, _, _, _, _, _, _, _, id = GetUnitBuffInfo("player", i)
		if mundusAbs[id] then return id end
	end
	return false
end

function CSPS.showMundusTooltip(control, mundusId)	
	mundusId = mundusId or currentMundusId
	if mundusId then
		InitializeTooltip(InformationTooltip, control, LEFT)
		InformationTooltip:AddLine(zo_strformat("<<C:1>> |t28:28:<<2>>|t", GetAbilityName(mundusId), GetAbilityIcon(mundusId)), "ZoFontWinH2")
		ZO_Tooltip_AddDivider(InformationTooltip)
		local r,g,b =  ZO_NORMAL_TEXT:UnpackRGB()
		local mundusDescription = GetAbilityDescription(mundusAbs[mundusId])
		-- Who knows why some descriptions are missing the dot. Or why they have separate abilityIds for the stones...
		if not string.sub(mundusDescription, -1) == "." then mundusDescription = string.format("%s.", mundusDescription) end
		InformationTooltip:AddLine(mundusDescription, "ZoFontGame", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true) 
		local mLL = mundusLocs[mundusId]
		local mundusLocText = {}
		for i, v in pairs(mLL) do
			table.insert(mundusLocText, zo_strformat("<<C:1>>", GetZoneNameById(v)))
		end
		InformationTooltip:AddLine(string.format("%s: %s", GS(SI_ZONECOMPLETIONTYPE12), ZO_GenerateCommaSeparatedList(mundusLocText)), "ZoFontGame", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true) 
	end
end

local function changeMundus(_, entryText, entry)
	entryText = entryText or entry and entry.mundusId and zo_strformat("<<C:1>>", GetAbilityName(entry.mundusId)) or "-"
	CSPSWindowMundusComboBox.comboBox:SetSelectedItemText(string.match(entryText, "%s(%S+)$"))
	currentMundusId = entry.mundusId
	CSPS.currentMundus = currentMundusId
	if currentMundusId == getCurrentMundus() then
		CSPSWindowMundusComboBoxSelectedItemText:SetColor(CSPS.colors.green:UnpackRGB())
	else
		CSPSWindowMundusComboBoxSelectedItemText:SetColor(CSPS.colors.orange:UnpackRGB())
	end
end
	
function CSPS.InitializeMundusMenu()
	local mCB = CSPSWindowMundusComboBox
	
    mCB.comboBox = ZO_ComboBox_ObjectFromContainer(mCB)
    mCB.comboBox:SetSortsItems(true)
    mCB.comboBox:SetSelectedItemFont("ZoFontGame")
    mCB.comboBox:SetDropdownFont("ZoFontGame")
    mCB.comboBox:SetSpacing(8)
    local comboBoxLabel = mCB:GetNamedChild("SelectedItemText")

	
    mCB.comboBox:ClearItems()
	
	for mundusId, abilityId in pairs(mundusAbs) do
		local entry = mCB.comboBox:CreateItemEntry(zo_strformat("<<C:1>>", GetAbilityName(mundusId)), changeMundus)
		entry.mundusId = mundusId
		entry.description = GetAbilityDescription(abilityId)
		mCB.comboBox:AddItem(entry)
	end

	changeMundus(false, false, {mundusId =  getCurrentMundus()})
	
	local EM = EVENT_MANAGER
	for mundusId, abilityId in pairs(mundusAbs) do
		EM:RegisterForEvent("CSPS_MUNDUS_"..mundusId, EVENT_EFFECT_CHANGED, function() CSPS.setMundus() end)
		EM:AddFilterForEvent("CSPS_MUNDUS_"..mundusId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, mundusId)
		EM:AddFilterForEvent("CSPS_MUNDUS_"..mundusId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, "player")
	end
	
end

function CSPS.setMundus(mundusId)
	mundusId = mundusId or currentMundusId
	changeMundus(false, false, {mundusId = mundusId})
end

function CSPS.setCurrentMundus()
	currentMundusId = getCurrentMundus()
	CSPS.setMundus(currentMundusId)
end