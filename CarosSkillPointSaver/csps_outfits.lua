local GS = GetString
CSPS.outfits = {current = {slots = {}}}
local outfits = CSPS.outfits
local outfitCollectibleTypes = {
	COLLECTIBLE_CATEGORY_TYPE_HAT,
	COLLECTIBLE_CATEGORY_TYPE_HAIR,
	COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING,
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS,
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY,
	COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY,
	COLLECTIBLE_CATEGORY_TYPE_COSTUME,
	COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING,
	COLLECTIBLE_CATEGORY_TYPE_SKIN,
	COLLECTIBLE_CATEGORY_TYPE_PERSONALITY,
	COLLECTIBLE_CATEGORY_TYPE_POLYMORPH,

	COLLECTIBLE_CATEGORY_TYPE_MOUNT,
	COLLECTIBLE_CATEGORY_TYPE_VANITY_PET,
}

outfits.current = {}

local function getMonturName(monturIndex)
	if not monturIndex or monturIndex == 0 then return GS(SI_NO_OUTFIT_EQUIP_ENTRY) end
	local monturName = GetOutfitName(GAMEPLAY_ACTOR_CATEGORY_PLAYER, monturIndex)
	if not monturName or monturName == "" then monturName = string.format("%s %s", GS(SI_OUTFIT_SELECTOR_TITLE), monturIndex) end
	return string.format("%s) %s", monturIndex, monturName)
end

function outfits.read()
	
	local currentlyEquipped = GetEquippedOutfitIndex(GAMEPLAY_ACTOR_CATEGORY_PLAYER)
	if not STATS.control:IsHidden() then currentlyEquipped = STATS.pendingEquipOutfitIndex end
	
	outfits.current.montur = currentlyEquipped
	outfits.current.title = GetCurrentTitleIndex()
	outfits.current.slots = {}
	for _, outfitCollectibleType in pairs(outfitCollectibleTypes) do
		outfits.current.slots[outfitCollectibleType] = GetActiveCollectibleByType(outfitCollectibleType, GAMEPLAY_ACTOR_CATEGORY_PLAYER)
	end
end

function outfits.apply(outfitTable)
	outfitTable = outfitTable or outfits.current
	local currentlyEquipped = GetEquippedOutfitIndex(GAMEPLAY_ACTOR_CATEGORY_PLAYER)
	if not STATS.control:IsHidden() then currentlyEquipped = STATS.pendingEquipOutfitIndex end
	if outfitTable.montur ~= currentlyEquipped then
		if not outfitTable.montur or outfitTable.montur == 0 then
			UnequipOutfit(GAMEPLAY_ACTOR_CATEGORY_PLAYER)
		else
			EquipOutfit(GAMEPLAY_ACTOR_CATEGORY_PLAYER, outfitTable.montur)
		end
	end

	if outfitTable.title ~= GetCurrentTitleIndex() then
		SelectTitle(outfitTable.title)
	end
	
	for outfitCollectibleType, collectibleId in pairs(outfitTable.slots) do
		if collectibleId ~= GetActiveCollectibleByType(outfitCollectibleType, GAMEPLAY_ACTOR_CATEGORY_PLAYER) then
			if collectibleId and collectibleId ~= 0 then
				UseCollectible(collectibleId, GAMEPLAY_ACTOR_CATEGORY_PLAYER)
			else
				UseCollectible(GetActiveCollectibleByType(outfitCollectibleType, GAMEPLAY_ACTOR_CATEGORY_PLAYER), GAMEPLAY_ACTOR_CATEGORY_PLAYER)
			end
		end
	end
end

function outfits.addToTooltip(outfitTable)
	outfitTable = outfitTable or outfits.current	
	local outfitName = getMonturName(outfitTable.montur)
	InformationTooltip:AddLine(string.format("%s: %s", GS(SI_OUTFIT_SELECTOR_TITLE), outfitName), "ZoFontGame")
	InformationTooltip:AddLine(string.format("%s: %s", GS(SI_STATS_TITLE), GetTitle(outfitTable.title or 0) or "-"), "ZoFontGame")
	for outfitCollectibleType, collectibleId in pairs(outfitTable.slots) do
		InformationTooltip:AddLine(string.format("%s: %s", GS("SI_COLLECTIBLECATEGORYTYPE", outfitCollectibleType), GetCollectibleLink(collectibleId)), "ZoFontGame")
	end
end

function outfits.compress(outfitTable)
	outfitTable = outfitTable or outfits.current
	local compressedSlots = {}
	for outfitCollectibleType, collectibleId in pairs(outfits.current.slots) do
		if collectibleId and collectibleId ~= 0 then table.insert(compressedSlots, string.format("%s:%s", outfitCollectibleType, collectibleId)) end
	end
	local compressedString = {outfitTable.montur or "-", outfitTable.title or "-", table.concat(compressedSlots, ",")}
	return table.concat(compressedString, ";")
end

function outfits.extract(compressedString, outfitTable)
	outfitTable = outfitTable or outfits.current
	outfitTable.montur = 0
	outfitTable.title = 0
	outfitTable.slots = {}
	if not compressedString or compressedString == "" then return outfitTable end
	local montur, title, slots = SplitString(";", compressedString)
	outfitTable.montur = tonumber(montur)
	outfitTable.title = tonumber(title)
	if slots and slots ~= "" then
		for _, collectibleEntry in pairs({SplitString(",", slots)}) do
			local outfitCollectibleType, collectibleId = SplitString(":", collectibleEntry)
			outfitTable.slots[tonumber(outfitCollectibleType)] = tonumber(collectibleId)
		end
	end
	return outfitTable
end

function outfits.setSlot(outfitCollectibleType, actionValue)
	outfits.current.slots[outfitCollectibleType] = actionValue
	CSPS.refreshTree()
end

function outfits.showMonturMenu()
	ClearMenu()
	
	for i=0, GetNumUnlockedOutfits() do
		AddCustomMenuItem(getMonturName(i), function() outfits.current.montur = i CSPS.refreshTree() end)
	end
	
	ShowMenu()
end

local function getAchievementListByTitles(titleTable)
	local achievementIds = {}
	
	for achievementTopLevelIndex=1, GetNumAchievementCategories() do
		local _, numSubCats, numAchievements = GetAchievementCategoryInfo(achievementTopLevelIndex)
		local function checkAchievement(achievementId) 
			local _, achievedTitle =  GetAchievementRewardTitle(achievementId)
			
			if titleTable[achievedTitle] then
				achievementIds[achievedTitle] = achievementId
			end
		end
		for achievementIndex=1, numAchievements do
			local achievementId = GetAchievementId(achievementTopLevelIndex, nil, achievementIndex)
			checkAchievement(achievementId)
		end
		for subCategoryIndex=1, numSubCats do
			local _, numAchievements = GetAchievementSubCategoryInfo(achievementTopLevelIndex, subCategoryIndex)
			for achievementIndex=1, numAchievements do
				local achievementId = GetAchievementId(achievementTopLevelIndex, subCategoryIndex, achievementIndex)
				checkAchievement(achievementId)
			end
		end
	end
	return achievementIds
end

local function getAchievementByTitle(title)
	if not title or title == "" then return false end
	local achievementIds = getAchievementListByTitles({[title] = true})
	return achievementIds[title] or false
end

function outfits.showTitleMenu()
	
	local titlesByName = {}
	local alphabeticalTitles = {}
	
	for i=1, GetNumTitles() do
		titlesByName[GetTitle(i)] = i
		table.insert(alphabeticalTitles, GetTitle(i))
	end
	
	local sortedTitleNames = {{}}
	local sortedTitleListNames = {}
	
	local firstLetter = false
	local nextList = {}
	table.sort(alphabeticalTitles)
	
	for _, title in pairs(alphabeticalTitles) do
		local myFirstLetter = string.upper(string.sub(title, 1,1))
		firstLetter = firstLetter or myFirstLetter
		if myFirstLetter == firstLetter then 
			table.insert(nextList, title)
		else
			if #sortedTitleNames[#sortedTitleNames] + #nextList >= 21 and #sortedTitleNames[#sortedTitleNames] > 0 then
				table.insert(sortedTitleNames, {})
			end
			for i, v in pairs(nextList) do
				table.insert(sortedTitleNames[#sortedTitleNames], v)
			end
			nextList = {title}
			firstLetter = myFirstLetter
		end
	end
	
	for listIndex, subList in pairs(sortedTitleNames) do
		sortedTitleListNames[listIndex] = string.format("%s-%s", string.sub(subList[1], 1,1), string.sub(subList[#subList], 1,1))
	end
	
	local achievementIds = getAchievementListByTitles(titlesByName)
			
	ClearMenu()
	for listIndex, subList in pairs(sortedTitleNames) do
		local subMenu = {}
		for _, titleName in pairs(subList) do
			local achievementId = achievementIds[titleName]
			local tooltip = false
			if achievementId then 
				tooltip = function(control, inside) -- would use AchievementTooltip but there's no icon in it and me wants more beautiful icons!
					if not inside then ClearTooltip(InformationTooltip) return "" end
					local name, description, _, texture = GetAchievementInfo(achievementId)
					InitializeTooltip(InformationTooltip, control, LEFT, 0, 15, RIGHT)
					InformationTooltip:AddLine(zo_strformat("<<C:1>>", name), "ZoFontWinH2")
					InformationTooltip:AddLine(string.format("\n|t48:48:%s|t\n", texture), "ZoFontGame")
					ZO_Tooltip_AddDivider(InformationTooltip)
					InformationTooltip:AddLine(description, "ZoFontGame")
					return ""
				end
			end
			table.insert(subMenu, {label = titleName, callback = function() outfits.current.title = titlesByName[titleName] CSPS.refreshTree() end, tooltip = tooltip or nil})
		end
		AddCustomSubMenuItem(sortedTitleListNames[listIndex], subMenu) 
	end
	ShowMenu()
	return titlesByName, achievementIds
end


local function NodeSetupOutfit(node, control, data, open, userRequested, enabled)

	-- control.receiveDragFunction = function() receiveDrag(mySlot) end
	local ctrText = control:GetNamedChild("Text")
	local ctrIndicator = control:GetNamedChild("Indicator")
	local ctrIcon = control:GetNamedChild("Icon")
	local ctrMinus = control:GetNamedChild("BtnMinus")
	
	ctrIndicator:SetHidden(true) -- will add this later
	control:SetHandler("OnMouseUp", function(self, button, upInside, ctrl, alt, shift)
		if not upInside then return end
		if button == 2 then
			if data.outfitCollectibleType then
				CSPS.openCollectibleList(data.outfitCollectibleType)
				CSPS.getTreeControl():RefreshVisible()
			elseif data.isTitle then
				outfits.showTitleMenu()
			elseif data.isMontur then
				outfits.showMonturMenu()
			end
		end
	end)
	if data.isMontur then
		local monturName = getMonturName(outfits.current.montur)	
		control.tooltipFunction = function() ZO_Tooltips_ShowTextTooltip(ctrText, RIGHT, GS(CSPS_QS_TT_Edit)) end
		if outfits.current.montur and outfits.current.montur ~= 0 then
			ctrMinus:SetHidden(false)
			ctrMinus:SetHandler("OnClicked", function() outfits.current.montur = 0 CSPS.refreshTree() end)
		else
			ctrMinus:SetHidden(true)
		end
		ctrText:SetText(string.format("%s: %s", GS(SI_OUTFIT_SELECTOR_TITLE), monturName))
		ctrIcon:SetTexture("ESOUI/art/restyle/keyboard/dyes_tabicon_outfitstyledye_up.dds")
	elseif data.isTitle then
		local title = GetTitle(outfits.current.title)
		title = title ~= "" and title or "-"
		if title == "-" then
			ctrMinus:SetHidden(true)
			control.tooltipFunction = function() ZO_Tooltips_ShowTextTooltip(ctrText, RIGHT, GS(CSPS_QS_TT_Edit)) end
		else
			ctrMinus:SetHidden(false)
			ctrMinus:SetHandler("OnClicked", function() outfits.current.title = 0 CSPS.refreshTree() end)
			control.tooltipFunction = function()
				InitializeTooltip(InformationTooltip, ctrText, LEFT, 0, 0, RIGHT)
				InformationTooltip:AddLine(zo_strformat("<<C:1>>", title), "ZoFontWinH2")
				local achievementId = getAchievementByTitle(title)
				if achievementId then
					local achievementName, achievementDescription, _, achievementTexture = GetAchievementInfo(achievementId)
					ZO_Tooltip_AddDivider(InformationTooltip)
					InformationTooltip:AddLine(string.format("\n|t48:48:%s|t\n", achievementTexture), "ZoFontGame")
					InformationTooltip:AddLine(achievementName, "ZoFontWinH3")
					InformationTooltip:AddLine(achievementDescription, "ZoFontGame")			
					InformationTooltip:AddLine(GS(CSPS_QS_TT_Edit), "ZoFontGame")		
				end
			end
		end
		ctrText:SetText(string.format("%s: %s", GS(SI_STATS_TITLE), title))
		ctrIcon:SetTexture("ESOUI/art/treeicons/achievements_indexicon_general_up.dds")
	else
		local name = "-"
		local description = ""
		local textureName = "esoui/art/actionbar/passiveabilityframe_round_empty.dds"
		local slotData = outfits.current.slots[data.outfitCollectibleType]
		if slotData and slotData ~= 0 then
			name, description, textureName = GetCollectibleInfo(slotData)
			ctrMinus:SetHidden(false)
			ctrMinus:SetHandler("OnClicked", function() outfits.current.slots[data.outfitCollectibleType] = 0 CSPS.refreshTree() end)
			control.tooltipFunction = function()
				InitializeTooltip(InformationTooltip, ctrText, LEFT, 0, 0, RIGHT)
				InformationTooltip:AddLine(zo_strformat("<<C:1>>", name), "ZoFontWinH2")
				InformationTooltip:AddLine(string.format("\n|t48:48:%s|t\n", textureName), "ZoFontGame")
				ZO_Tooltip_AddDivider(InformationTooltip)
				InformationTooltip:AddLine(description, "ZoFontGame")
				InformationTooltip:AddLine(GS(CSPS_QS_TT_Edit), "ZoFontGame")
			end
		else
			ctrMinus:SetHidden(true)
			control.tooltipFunction = function() ZO_Tooltips_ShowTextTooltip(ctrText, RIGHT, GS(CSPS_QS_TT_Edit)) end
		end
		ctrText:SetText(zo_strformat("<<1>>: <<C:2>>", GS("SI_COLLECTIBLECATEGORYTYPE", data.outfitCollectibleType), name))
		ctrIcon:SetTexture(textureName)
	end
end

function CSPS.setupOutfitSection(control, node, data)
	local btnApply = control:GetNamedChild("BtnApply")
	if node:IsOpen() and not data.fillContent then
		btnApply:SetHidden(false)
		btnApply:SetWidth(21)
		btnApply:SetHandler("OnClicked", function() 	
			outfits.apply()
		end)
	else
		btnApply:SetHidden(true)
	end
end

function CSPS.setupOutfitTree()
	local myTree = CSPS.getTreeControl()
	myTree:AddTemplate("CSPSOutfitLE", NodeSetupOutfit, nil, nil, 24, 0)
	local fillContent = {}
	table.insert(fillContent, {"CSPSOutfitLE", {isTitle = true}})
	table.insert(fillContent, {"CSPSOutfitLE", {isMontur = true}})
	for _, outfitCollectibleType in pairs(outfitCollectibleTypes) do
		table.insert(fillContent, {"CSPSOutfitLE", {outfitCollectibleType = outfitCollectibleType}})
	end
	local overNode = myTree:AddNode("CSPSLH", {name = GetCollectibleCategoryNameByCategoryId(13), isMainCat=true, variant=9, fillContent=fillContent})
end

function outfits.toggleShowInTree()
	CSPSWindowBuildOutfitProfiles:SetHidden(not CSPS.savedVariables.settings.showOutfits)
	CSPSWindowBuildOutfitProfiles:SetWidth(CSPS.savedVariables.settings.showOutfits and 27 or 0)
	if not CSPS.tabEx then return end
	local myNode = CSPS.sectionNodes[9]
	if CSPS.savedVariables.settings.showOutfits then
		if not myNode then CSPS.setupOutfitTree() return end
		myNode.control:SetHidden(false)
	else
		if not myNode then return end
		myNode:SetOpen(false)
		myNode.control:SetHidden(true)
	end
end