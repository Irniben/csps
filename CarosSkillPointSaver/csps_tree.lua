
local GS = GetString
local cspsPost = CSPS.post
local cspsD = CSPS.cspsD
local cpIcInact = {0.21, 0.33, 0.63}
local myTree = false
local cpControls = {}
local cpClusterControls = {}
local ec = CSPS.ec
local colTbl = CSPS.colors
local cpColors = CSPS.cpColors
local cp = CSPS.cp
local cpBar = cp.bar
local cpTable = cp.table
local cpOvernode = false
local cpDisciplineNodes = false

local TREE_SECTION_SKILLTYPES = 1
local TREE_SECTION_SKILLLINES = 2
local TREE_SECTION_SKILLS = 3
local TREE_SECTION_CHAMPIONPOINTS = 4
local TREE_SECTION_ATTRIBUTES = 6
local TREE_SECTION_GEAR = 7
local TREE_SECTION_QS = 8

local sectionNodes = {}

local errorColors = { -- ec = {correct = 1, wrongMorph = 2, rankHigher = 3, skillLocked = 4, rankLocked = 5, morphLocked = 6}, >>> + 1
	colTbl.white,	
	colTbl.green,  
	colTbl.red,
	colTbl.orange, 
	colTbl.red,    
	colTbl.red,    
	colTbl.red,   
}

local cp2ColorsA = {{70/255,107/255,7/255}, {23/255,101/255,135/255}, {166/255,58/255,11/255}}

-- local cpColTex = {"esoui/art/champion/champion_points_stamina_icon-hud-32.dds","esoui/art/champion/champion_points_magicka_icon-hud-32.dds","esoui/art/champion/champion_points_health_icon-hud-32.dds",}

local cpSlT = {
		"esoui/art/champion/actionbar/champion_bar_world_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_combat_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_conditioning_selection.dds",
}


local werewolfNode = false
local werewolfParentNode = false

CSPS.sectionNodes = sectionNodes
--/script for i, v in pairs(CSPS.sectionNodes) do d(v and v.data and i..v.data.name) end
-- /script CSPS.getTreeControl().rootNode:UpdateAllChildrenHeightsAndCurrentHeights()
local function refreshWerewolfMode(allowWerewolfMode)
	if not werewolfNode or not werewolfParentNode then return end
	local oldWerewolfMode = CSPS.werewolfMode
	CSPS.werewolfMode = allowWerewolfMode and werewolfNode:IsOpen() and werewolfParentNode:IsOpen() and not werewolfNode.data.fillContent
	if CSPS.werewolfMode == oldWerewolfMode then return end
	CSPS.hbPopulate()
end

local function toggleNode(node, buttonControl, callOnLastEntry)
	buttonControl = buttonControl or node.control:GetNamedChild("Toggle")
	local createdNew = false
	if node.data.fillContent then
		createdNew = true
		if callOnLastEntry then 
			node.data.fillContent[#node.data.fillContent][2].callbackFunc = callOnLastEntry 
		end
		for _, v in pairs(node.data.fillContent) do
			myTree:AddNode(v[1], v[2], node) --v[1] = template, v[2] = content
		end
		node.data.fillContent = nil
	end
	if buttonControl.state == node:IsOpen() then ZO_ToggleButton_Toggle(buttonControl) end
	node:SetOpen(not node:IsOpen(), USER_REQUESTED_OPEN)
	
	if buttonControl.cpSection then
		CSPSWindowCPSideBar:SetHidden(not node:IsOpen())
	elseif buttonControl.isWerewolf then
		refreshWerewolfMode(true)
	end
	return createdNew
end

local function openNode(node, callOnLastEntry)
	if not node or node:IsOpen() and not node.data.fillContent then return end
	return toggleNode(node, nil, callOnLastEntry)
end

function CSPS.openTreeToSection(sectionIndex, subIndex)
	local parentNode = sectionNodes[sectionIndex]
	if not parentNode then return end
	
	local function scrollToNode(targetNode)
		ZO_Scroll_SetScrollToRealOffsetAccountingForGradients(
			myTree.scrollControl, 
			myTree.rootNode:GetCurrentChildrenHeight(), --
			targetNode.control:GetTop() - myTree.rootNode.children[1].control:GetTop() , -- offset
			150	-- duration for animated scrolling
		) 
	end
	
	local targetNode = parentNode
	
	if subIndex then 
		openNode(targetNode[1])
		targetNode = parentNode[subIndex + 1]
		if not openNode(targetNode, function() zo_callLater(function() scrollToNode(targetNode) end, 100) end) then scrollToNode(targetNode) end
	else
		if not openNode(targetNode, function() zo_callLater(function() scrollToNode(targetNode) end, 100) end) then scrollToNode(targetNode) end
	end
	
	
	
	--myTree:SetScrollToTargetNode(parentNode, childNode)
end



function CSPS.onToggleSektion(buttonControl, button)
	if button == MOUSE_BUTTON_INDEX_LEFT then
		toggleNode(buttonControl:GetParent().node, buttonControl)
	end
end

local function showSimpleTT(control, ttInd, includeShiftKey)
	local ttText = includeShiftKey and string.format(GS(ttInd), GS("SI_KEYCODE", CSPS.savedVariables.settings.jumpShiftKey or 7)) or GS(ttInd)
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, ttText)
end
	

local function showSkTT(control, i,j,k, morph, rank, errorCode, skillData)
	local myTooltip = GetAbilityDescription(GetSpecificSkillAbilityInfo(i,j,k, morph, rank))
	errorCode = errorCode or 0
	local errorAlerts = {
		[ec.correct] = function() return colTbl.green:Colorize(GS("CSPS_ErrorNumber", errorCode)) end,
		[ec.wrongMorph] = function() return colTbl.red:Colorize(GS("CSPS_ErrorNumber", errorCode)) end,
		[ec.rankHigher] = function() return colTbl.orange:Colorize(GS("CSPS_ErrorNumber", errorCode)) end,
		[ec.skillLocked] = function() 	local rankNeeded = skillData.zo_data:GetLineRankNeededToPurchase() return colTbl.red:Colorize(zo_strformat(GS(SI_ABILITY_UNLOCKED_AT), skillData.lineData.name, rankNeeded)) end,
		[ec.rankLocked] = function() local rankNeeded = skillData.zo_data:GetProgressionData(rank):GetLineRankNeededToUnlock() return colTbl.red:Colorize(zo_strformat(GS(SI_ABILITY_UNLOCKED_AT), skillData.lineData.name, rankNeeded)) end,
		[ec.morphLocked] = function() return colTbl.red:Colorize(GS(SI_ABILITYPROGRESSIONRESULT7)) end,
	}
	
	myTooltip = errorAlerts[errorCode] and string.format("%s\n\n%s", myTooltip, errorAlerts[errorCode]()) or myTooltip
	
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, myTooltip)
end

local function NodeSetup(node, control, data, open, userRequested, enabled)

	local i, j, k, mySkill = unpack(data)

	--Entries: [1]Name [2]Texture [3] Rank [4]Progression [5]Purchased [6]Morph [7] Points [8] Auxlistindex [9] MaxRank/Morph [10] Errorcode
		
	local myCtrIcon = control:GetNamedChild("Icon")
	local myCtrText = control:GetNamedChild("Text")
	local myCtrPoints = control:GetNamedChild("Points")
	local myCtrMorph = control:GetNamedChild("Morph")
	local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	local morphOrRank = ""
	
	if not mySkill.passive then
		morphOrRank = zo_strformat(GS(CSPS_MORPH), mySkill.morph)
		
		myCtrIcon:SetMouseEnabled(true)
		myCtrIcon:SetHandler("OnMouseUp", function(self, mouseButton, upInside) WINDOW_MANAGER:SetMouseCursor(0) end)
		myCtrIcon:SetHandler("OnDragStart", 
			function(self, button) 
				WINDOW_MANAGER:SetMouseCursor(15)
				 CSPS.onSkillDrag(i, j, k)
			end)
	else
		morphOrRank = string.format(GS(CSPS_MyRank), mySkill.rank)
		myCtrIcon:SetMouseEnabled(false)
		myCtrIcon:SetHandler("OnMouseUp", function()  end)
	end
	
	
	myCtrPoints:SetText(string.format("(%s)", mySkill.points))

	local myErrorCode = mySkill.error or 0
	local myColor = mySkill.purchased and errorColors[myErrorCode + 1] or colTbl.gray
	
	myCtrText:SetHandler("OnMouseEnter", function() showSkTT(myCtrText, i, j, k, mySkill.morph, mySkill.rank, myErrorCode, mySkill) end)
	
	myCtrText:SetHandler("OnMouseUp", 
		function(_, mouseButton, upInside, ctrl, _, shift) 
			if mouseButton == 1 and upInside and ctrl and shift then 
				cspsPost(string.format("%s - %s - %s (Morph %s, Rank %s) - ID: %s", i, j, k, mySkill.morph or "-", mySkill.rank or "-", (GetSpecificSkillAbilityInfo(i, j, k, mySkill.morph, mySkill.rank))))
			end 
		end)
	myCtrText:SetColor(myColor:UnpackRGBA())
	myCtrIcon:SetDesaturation(mySkill.purchased and 0 or 1)
	
	myCtrMorph:SetHidden(not mySkill.purchased)
	
	myCtrPoints:SetHidden(mySkill.points <= 0)
	
	myCtrBtnMinus:SetHidden(not mySkill.purchased or (mySkill.autoGrant and (mySkill.passive and mySkill.rank == 1 or not mySkill.passive and mySkill.morph == 0)))
	myCtrBtnPlus:SetHidden(mySkill.maxRaMo)
	
	myCtrBtnPlus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.plusClickSkill(mySkill, ctrl,alt,shift) end)
	myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnPlus, CSPS_Tooltiptext_PlusSk) end)
	
	myCtrBtnMinus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.minusClickSkill(mySkill, ctrl,alt,shift) end)
	myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, CSPS_Tooltiptext_MinusSk) end)
	
	
	myCtrIcon:SetTexture(mySkill.morph and mySkill.morph > 0 and mySkill.morphTextures[mySkill.morph] or mySkill.texture)
	myCtrText:SetText(mySkill.morph and mySkill.morph > 0 and mySkill.morphNames[mySkill.morph] or mySkill.name)

	myCtrMorph:SetText(morphOrRank)
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

local function NodeSetupAttr(node, control, data, open, userRequested, enabled)
	--Entries in data: Text, Value, entrColor
	local myText = data.name
	local myCtrText = control:GetNamedChild("Text")
	local myCtrValue = control:GetNamedChild("Value")
	local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	myCtrText:SetText(myText)
	myCtrValue:SetText(CSPS.attrPoints[data.i])
	
	myCtrBtnMinus:SetHidden(CSPS.attrPoints[data.i] == 0)
	myCtrBtnPlus:SetHidden(CSPS.attrPoints[1] + CSPS.attrPoints[2] + CSPS.attrPoints[3] >= CSPS.attrSum())
	
	myCtrBtnMinus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.attrBtnPlusMinus(data.i, -1, ctrl,alt,shift) end)
	myCtrBtnPlus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.attrBtnPlusMinus(data.i, 1, ctrl,alt,shift) end)
	myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(control:GetNamedChild("BtnPlus"), CSPS_Tooltiptext_PlusAttr, true) end)
	myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(control:GetNamedChild("BtnMinus"), CSPS_Tooltiptext_MinusAttr, true) end)

	myCtrText:SetColor(data.entrColor:UnpackRGBA())
	myCtrValue:SetColor(data.entrColor:UnpackRGBA())
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

local function getErrorSumColor(data)
	if data.errorSums[ec.rankLocked] > 0 or data.errorSums[ec.skillLocked] > 0 or data.errorSums[ec.morphLocked] > 0 or data.errorSums[ec.wrongMorph] > 0 then 
		return colTbl.red 
	end
	if	data.errorSums[ec.rankHigher] > 0 then return colTbl.orange end 
	return colTbl.white
end


function CSPS.NodeSectionSetup(node, control, data, open, userRequested, enabled)
    local myText = data.name
	local myCtrText = control:GetNamedChild("Name")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
	local btnToggle = GetControl(control, "Toggle")
	-- BtnSave
	-- IndicatorSaveNew
	
	if data.variant == TREE_SECTION_SKILLTYPES or data.variant == TREE_SECTION_SKILLLINES then -- Skill type/line
		local myData = data.variant == TREE_SECTION_SKILLTYPES and data.typeData or data.lineData
		myText = string.format("%s (%s)", myText, myData.points)

		myCtrText:SetColor(getErrorSumColor(myData):UnpackRGBA())
		
		if myData.isWerewolf then 
			btnToggle.isWerewolf = true 
			werewolfNode = node
		end
		
		if myData.isWerewolfParent then 
			btnToggle.isWerewolf = true 
			werewolfParentNode = node 
		end
		
		if node:IsOpen() and not data.fillContent then 
			myCtrBtnMinus:SetHidden(myData.points <= 0)
			myCtrBtnMinus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.minusClickSkillLine(data.skillType, data.skillLineIndex, shift) end)
			myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, data.variant == TREE_SECTION_SKILLTYPES and CSPS_Tooltiptext_MinusSkType or CSPS_Tooltiptext_MinusSkLine) end)
			myCtrBtnPlus:SetHidden(false)
			myCtrBtnPlus:SetWidth(21)
			myCtrBtnPlus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.plusClickSkillLine(data.skillType, data.skillLineIndex, shift) end)
			myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnPlus, CSPS_Tooltiptext_PlusSkLine) end)
			if myData.isWerewolf then refreshWerewolfMode(true) end
		else
			myCtrBtnMinus:SetHidden(true)
			myCtrBtnPlus:SetHidden(true)
			if myData.isWerewolf then refreshWerewolfMode(false) end
		end
		
	elseif data.variant == TREE_SECTION_SKILLS then -- Skills section
		myCtrText:SetColor(colTbl.white:UnpackRGBA())
		sectionNodes[TREE_SECTION_SKILLS] = sectionNodes[TREE_SECTION_SKILLS] or node
	elseif data.variant == TREE_SECTION_GEAR then -- Gear section
		myCtrText:SetColor(colTbl.white:UnpackRGBA())
		CSPS.setupGearSection(control, node, data)
		sectionNodes[TREE_SECTION_GEAR] = sectionNodes[TREE_SECTION_GEAR] or node
	elseif data.variant == TREE_SECTION_QS then
		myCtrText:SetColor(colTbl.white:UnpackRGBA())
		sectionNodes[TREE_SECTION_QS] = sectionNodes[TREE_SECTION_QS] or node
		CSPS.setupQsSection(control, node, data)
	elseif data.variant == TREE_SECTION_CHAMPIONPOINTS then -- Champion Points section
		sectionNodes[TREE_SECTION_CHAMPIONPOINTS] = sectionNodes[TREE_SECTION_CHAMPIONPOINTS] or {node}
		if (CSPS.applyCP and CSPS.unlockedCP)  or (not CSPS.showApply) then 
			myCtrText:SetColor(colTbl.white:UnpackRGBA())
		else
			myCtrText:SetColor(colTbl.gray:UnpackRGBA())
		end		
		btnToggle.cpSection = true
		
	elseif data.variant == TREE_SECTION_ATTRIBUTES then -- Attributes section
		sectionNodes[TREE_SECTION_ATTRIBUTES] = sectionNodes[TREE_SECTION_ATTRIBUTES] or node
		myCtrText:SetColor(colTbl.white:UnpackRGBA())
	end
	
	myCtrText:SetText(myText)
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

function CSPS.setupTreeSectionConnections(node, control, discipline, entrColor, mayShowConnection, mayShowSaveButton, qsBarIndex)

	local myProfile = CSPS.currentProfile == 0 and CSPS.currentCharData or CSPS.profiles[CSPS.currentProfile]
	myProfile = myProfile.connections and myProfile.connections[discipline] or false
	
	local ctrConnect = GetControl(control, "Connection")
	ctrConnect:SetColor(entrColor:UnpackRGBA())
	
	ctrConnect:SetHidden(not mayShowConnection or not myProfile)
	ctrConnect:SetWidth(mayShowConnection and myProfile and 24 or 0)
	
	if myProfile then
		ctrConnect:SetHandler("OnMouseEnter",
			function()
				ZO_Tooltips_ShowTextTooltip(ctrConnect, RIGHT, string.format(GS(CSPS_Tooltip_ShowConnection), CSPS.getConnectedProfileName(myProfile)))
			end)
		ctrConnect:SetHandler("OnMouseUp", 
			function(_, mouseButton, upInside) 
				if upInside and mouseButton == MOUSE_BUTTON_INDEX_RIGHT then 
					local theProfile = CSPS.currentProfile == 0 and CSPS.currentCharData or CSPS.profiles[CSPS.currentProfile]
					theProfile.connections[discipline] = nil
					myTree:RefreshVisible() 
					CSPS.subProfileList:RefreshVisible()
				end 
			end)
		
		local myType, myId = SplitString("-", myProfile)
		myType = tonumber(myType)
		myId = tonumber(myId)	
		
		control:GetNamedChild("IndicatorSaveNew"):SetHidden(true)
		
		if mayShowSaveButton then 
			control:GetNamedChild("BtnSave"):SetHidden(myType > 2 and myType < 6)
			control:GetNamedChild("BtnSave").tooltip = GS(CSPS_Tooltiptext_Save)
			control:GetNamedChild("BtnSave"):SetHandler("OnClicked", 
				function()  
					CSPS.showSubProfileDiscipline(discipline, true)
					CSPS.subProfileSaveGo(myId, myType)
			end)
		else
			control:GetNamedChild("BtnSave"):SetHidden(true)
		end	
	else
		if mayShowSaveButton then 
			control:GetNamedChild("BtnSave"):SetHidden(false)
			control:GetNamedChild("IndicatorSaveNew"):SetHidden(false)
			control:GetNamedChild("BtnSave").tooltip = GS(CSPS_Tooltiptext_AddProfile)
			control:GetNamedChild("BtnSave"):SetHandler("OnClicked", 
				function()  
					AddCustomMenuItem(string.gsub(GS(CSPS_CPP_BtnCustAcc), "\n", " "), 
						function()
							CSPS.subProfileType = 1
							CSPS.showSubProfileDiscipline(discipline, false)
							CSPS.setSubProfileType() -- check if it fits the discipline or change it 
							CSPS.subProfilePlus(CSPS.subProfileType, qsBarIndex)
						end)
					AddCustomMenuItem(string.gsub(GS(CSPS_CPP_BtnCustChar), "\n", " "), 
						function() 
							CSPS.subProfileType = 2
							CSPS.showSubProfileDiscipline(discipline, false)
							CSPS.setSubProfileType()
							CSPS.subProfilePlus(CSPS.subProfileType, qsBarIndex)
						end)
					ShowMenu()
					
			end)
		else
			control:GetNamedChild("BtnSave"):SetHidden(true)
			control:GetNamedChild("IndicatorSaveNew"):SetHidden(true)
		end	
		
	end	
end

local function NodeSetupCP2Discipline(node, control, data, open, userRequested, enabled) -- cp section (2.0)
	local myText = data.name
	myText = string.format("%s (%s/%s)", myText, cp.sums[data.discipline], GetNumSpentChampionPoints(data.disciplineId) + GetNumUnspentChampionPoints(data.disciplineId)) -- CSPS.cpColorSum[data.i] instead of ""
	
	sectionNodes[TREE_SECTION_CHAMPIONPOINTS][data.discipline + 1] = sectionNodes[TREE_SECTION_CHAMPIONPOINTS][data.discipline + 1] or node
	
	if (CSPS.applyCPc[data.discipline] and CSPS.unlockedCP) or (not CSPS.showApply) then 
		control:GetNamedChild("Name"):SetColor(data.entrColor:UnpackRGBA())
	else
		control:GetNamedChild("Name"):SetColor(colTbl.gray:UnpackRGBA())
	end
		
	CSPS.setupTreeSectionConnections(node, control, data.discipline, data.entrColor, not data.fillContent, not data.fillContent and node:IsOpen())

	control:GetNamedChild("Name"):SetText(myText)
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

local function NodeSetupCP2Cluster(node, control, data, open, userRequested, enabled)
	local clusterData = data.clusterData
	local myId = clusterData.id
	cpClusterControls[clusterData.id] = control
	control:GetNamedChild("Name"):SetText(zo_strformat("<<C:1>> (<<2>>)", clusterData.name, clusterData.sum or 0))
	local r,g,b = data.entrColor:UnpackRGB()
	control:GetNamedChild("Marker"):SetCenterColor(r, g, b, 0.25)
	control:GetNamedChild("Marker"):SetEdgeColor(r, g, b, 0)
	control:GetNamedChild("Name"):SetColor((clusterData.active and colTbl.white or colTbl.gray):UnpackRGBA())
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

local function markLinkNodes(skillData, arg)
	if not skillData.linked then return end
	
	local function markNode(id)
		if cp.clusterParents[id] then
			local clusterMark = cpClusterControls[cp.clusterParents[id].id]:GetNamedChild("Marker")
			clusterMark:SetHidden(not arg)
		end
		if cpControls[id] then
			local myMark = cpControls[id]:GetNamedChild("Marker")
			myMark:SetHidden(not arg)
		end
	end
	
	markNode(skillData.id)
	
	for _, v in pairs(skillData.linked) do
		markNode(v)
	end
end

local function NodeSetupCpEntry(node, control, data, open, userRequested, enabled)
	--data: entrColor = , i=disciplineIndex, j=j,  skId, skType (and l if clusterentry)	
	local skillData = data.skillData
	local myCurrentValue = GetNumPointsSpentOnChampionSkill(skillData.id)
	local myValPercent = skillData.value / skillData.maxValue
	control.ctrValue:SetText(skillData.value)
	
	if myValPercent <= 1 then control.ctrProgress:SetWidth(76 * myValPercent) else control.ctrProgress:SetWidth(76) end
	
	if not cpControls[skillData.id] then	
		control.ctrName:SetText(zo_strformat("<<C:1>>", GetChampionSkillName(skillData.id)))
		local r,g,b = data.entrColor:UnpackRGB()
		control.ctrMarker:SetCenterColor(r,g,b, 0.4)
		control.ctrMarker:SetEdgeColor(0,0,0,0)
		control.ctrProgress:SetColor(r,g,b, 0.4)
		if skillData.jumpPoints then
			control.jP = {}
			for i, v in pairs(skillData.jumpPoints) do
				local xPos = v/skillData.maxValue * 76
				if not control.jP[i] then
					control.jP[i] =  WINDOW_MANAGER:CreateControl(nil, control, CT_TEXTURE)
				end
				control.jP[i]:SetAnchor(TOP, control.ctrProgress, TOPLEFT, xPos, 1)
				control.jP[i]:SetDimensions(1, 14)
			end
		end
		if data.clusterId ~= nil then
			control.ctrName:SetWidth(260)
			control.ctrMarker:SetWidth(260)
		end
		cpControls[skillData.id] = control
	end
	for i, v in pairs(skillData.jumpPoints or {}) do
		if i > 1 then
			if v > skillData.value or skillData.value == 0 then 
				control.jP[i]:SetColor(0.66,0.66,0.66) 
				control.jP[i]:SetWidth(1)
			else 
				control.jP[i]:SetColor(1,0.8,0) 
				control.jP[i]:SetWidth(3)
			end
		end
	end	
	control.ctrValue:SetHandler("OnMouseEnter", function() CSPS.showCpTT(control.ctrValue, skillData) end)
	control.ctrProgBg:SetHandler("OnMouseEnter", function() CSPS.showCpTT(control.ctrValue, skillData) end)
	control.ctrName:SetHandler("OnMouseEnter", function() markLinkNodes(skillData, true) CSPS.showCpTT(control.ctrName, skillData) end)
	control.ctrName:SetHandler("OnMouseExit", function() markLinkNodes(skillData, false) ZO_Tooltips_HideTextTooltip() end)
	
	if skillData.type ~= 3 then
		control.ctrBtnPlus:SetHandler("OnMouseEnter", function() markLinkNodes(skillData, true) showSimpleTT(control.ctrBtnPlus, CSPS_Tooltiptext_PlusCP, true) end)
		control.ctrBtnPlus:SetHandler("OnMouseExit", function() markLinkNodes(skillData, false)	ZO_Tooltips_HideTextTooltip() end)
	else
		control.ctrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(control.ctrBtnPlus, CSPS_Tooltiptext_PlusCP, true) end)
		control.ctrBtnPlus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	end
	control.ctrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(control.ctrBtnMinus, CSPS_Tooltiptext_MinusCP, true) end)
	control.ctrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	
	local inCol = cpIcInact[skillData.discipline]
	if skillData.type == 1  then
		control.ctrIcon:SetTexture(CSPS.cpColTex[skillData.discipline])
		control.ctrIcon:SetColor(1,1,1)
	else 
		control.ctrIcon:SetTexture("esoui/art/champion/champion_icon_32.dds")
		control.ctrIcon:SetTextureCoords(-0.1,1.1,-0.1,1.1)
		control.ctrIcon:SetColor(unpack(cp2ColorsA[skillData.discipline]))
		control.ctrIcon:SetMouseEnabled(true)
		control.ctrIcon:SetHandler("OnMouseUp", function(self, mouseButton, upInside) WINDOW_MANAGER:SetMouseCursor(0) if upInside then CSPS.clickCPIcon(skillData, mouseButton) end end)
		control.ctrIcon:SetHandler("OnDragStart", 
			function(self, button) 
				 WINDOW_MANAGER:SetMouseCursor(15)
				 CSPS.onCpDrag(skillData)
			end)
		inCol = cpIcInact[1]
	end
	if not skillData.unlocked then
		control.ctrIcon:SetDesaturation(1)
		control.ctrIcon:SetColor(inCol, inCol, inCol)		
		control.ctrName:SetColor(colTbl.gray:UnpackRGBA())
		control.ctrValue:SetColor(colTbl.gray:UnpackRGBA())
		control.ctrBtnMinus:SetHidden(true)
		control.ctrBtnPlus:SetHidden(true)
		control.ctrCircle:SetHidden(true)		
	else
		control.ctrIcon:SetDesaturation(0)
		if cp.isInHb(skillData.id) == true then
			control.ctrIcon:SetDesaturation(0)
			control.ctrIcon:SetColor(1,1,1)
			control.ctrCircle:SetHidden(false)
			control.ctrCircle:SetTexture(cpSlT[skillData.discipline])
			if skillData.discipline == 1 then control.ctrCircle:SetColor(0.8235, 0.8235, 0) end	-- re-color the not-so-green circle for the green cp...
		elseif skillData.type > 1 and skillData.active then
			control.ctrCircle:SetHidden(false)
			control.ctrCircle:SetTexture("esoui/art/champion/actionbar/champion_bar_slot_frame.dds")
			control.ctrCircle:SetColor(1,1,1)
		else
			control.ctrCircle:SetHidden(true)			
		end
		control.ctrName:SetColor(colTbl.white:UnpackRGBA())
		if skillData.value < myCurrentValue then
			control.ctrValue:SetColor(colTbl.orange:UnpackRGBA())
		elseif skillData.value == myCurrentValue and skillData.value > 0 then
			control.ctrValue:SetColor(colTbl.green:UnpackRGBA())
		else
			control.ctrValue:SetColor(colTbl.white:UnpackRGBA())
		end
		
		control.ctrBtnPlus:SetHidden(skillData.value >= skillData.maxValue)
		control.ctrBtnMinus:SetHidden(skillData.value <= 0)
	end
	control.ctrName:SetHandler("OnMouseUp", function(self, mouseButton, upInside, ctrl, _, shift) 
		if upInside then 
			if mouseButton == 1 and ctrl and shift then
				cspsPost(skillData.id)
			else
				CSPS.cpClicked(self, skillData, mouseButton) 
			end
		end 
	end)
	control.ctrBtnPlus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.cpBtnPlusMinus(skillData, 1, ctrl, alt, shift) end)
	control.ctrBtnMinus:SetHandler("OnClicked", function(_,_,ctrl,alt,shift) CSPS.cpBtnPlusMinus(skillData, -1,ctrl,alt,shift) end)
	
	if data.callbackFunc then data.callbackFunc() data.callbackFunc = nil end
end

function CSPS.prepareTheTree()
	local scrollContainer = CSPSWindow:GetNamedChild("ScrollList")
	myTree = ZO_Tree:New(scrollContainer:GetNamedChild("ScrollChild"), 24, 0, 2000)
	myTree:AddTemplate("CSPSLE", NodeSetup, nil, nil, 24, 0)
	myTree:AddTemplate("CSPSLATTR", NodeSetupAttr, nil, nil, 24, 0)
	myTree:AddTemplate("CSPSLH", CSPS.NodeSectionSetup, nil, nil, 24, 0)

	myTree:AddTemplate("CSPSCP2HB", NodeSetupCP2Discipline, nil, nil, 24, 0)
	myTree:AddTemplate("CSPSCP2CL", NodeSetupCP2Cluster, nil, nil, 24, 0)
	myTree:AddTemplate("CSPSCP2L", NodeSetupCpEntry, nil, nil, 24, 0)
	myTree:RefreshVisible() 
end

function CSPS.refreshTree()
	if myTree then myTree:RefreshVisible() end
end

function CSPS.createCPTree()
	cpOvernode = cpOvernode or myTree:AddNode("CSPSLH", {name = GS(CSPS_TxtCpNew), variant=TREE_SECTION_CHAMPIONPOINTS})
	cpDisciplineNodes = cpDisciplineNodes or {}
	cpControls = {}
	cpClusterControls = {}
	
	local changeOrder = {2,3,1}
	for auxId = 1, 3 do
		local discipline = changeOrder[auxId]
		
		local disciplineId = GetChampionDisciplineId(discipline)
		local fillContent = {}
		for _, skillData in pairs(cp.sortedLists[discipline]) do
			if skillData.cluster then
				local subContent = {}
				for _, subSkillData in pairs(skillData.cluster) do					
					table.insert(subContent, {"CSPSCP2L", {entrColor = cpColors[discipline], discipline=discipline, clusterId = skillData.id, skillData = subSkillData}})
				end
				table.insert(fillContent, {"CSPSCP2CL", {entrColor = cpColors[discipline], discipline=discipline, clusterData=skillData, fillContent=subContent}})
			else
				table.insert(fillContent, {"CSPSCP2L", {entrColor = cpColors[discipline], skillData=skillData}})
			end
		end
		if cpDisciplineNodes[discipline] then
			if cpDisciplineNodes[discipline]:IsOpen() and not cpDisciplineNodes[discipline].data.fillContent then
				cpDisciplineNodes[discipline]:SetOpen(false) 
				ZO_ToggleButton_Toggle(cpDisciplineNodes[discipline].control:GetNamedChild("Toggle"))
			end
			cpDisciplineNodes[discipline].children = nil
		end
		cpDisciplineNodes[discipline] = cpDisciplineNodes[discipline]  or myTree:AddNode("CSPSCP2HB", {name = zo_strformat("<<C:1>>", GetChampionDisciplineName(disciplineId)), disciplineId=disciplineId, entrColor = cpColors[discipline], discipline=discipline, fillContent=fillContent}, cpOvernode)
		
		cpDisciplineNodes[discipline].data.fillContent = fillContent
	end
end

function CSPS.createTable()

	-- Generate tree for skills

	local typeContent = {}
	for skillType, typeData in ipairs(CSPS.skillTable) do
		local lineContent = {}
		for skillLineIndex, lineData in ipairs(typeData) do
			if not (skillType == 6 and skillLineIndex == CSPS.kaiserFranz) then
				local fillContent = {}
				for skillIndex, skillData in ipairs(lineData) do
					table.insert(fillContent, {"CSPSLE", {skillType, skillLineIndex, skillIndex, skillData}})
				end
				
				table.insert(lineContent, {"CSPSLH", {name = lineData.name, variant = TREE_SECTION_SKILLLINES, skillType=skillType, skillLineIndex=skillLineIndex, fillContent=fillContent, lineData=lineData}})

			end
		end
		table.insert(typeContent, {"CSPSLH", {name = GS("SI_SKILLTYPE", skillType), variant = TREE_SECTION_SKILLTYPES, skillType=skillType, fillContent=lineContent, typeData = typeData}})
	end
	local overnode = myTree:AddNode("CSPSLH", {name = GS(SI_CHARACTER_MENU_SKILLS), variant=TREE_SECTION_SKILLS, fillContent=typeContent})
	
	-- Generate tree for attribute points
	local fillContent = {
		{"CSPSLATTR", {name = GS(SI_ATTRIBUTES1), i=1, entrColor=cpColors[3]}},
		{"CSPSLATTR", {name = GS(SI_ATTRIBUTES2), i=2, entrColor=cpColors[2]}},
		{"CSPSLATTR", {name = GS(SI_ATTRIBUTES3), i=3, entrColor=cpColors[1]}}
	}
	local overnode = myTree:AddNode("CSPSLH", {name = GS(SI_STATS_ATTRIBUTES), variant=TREE_SECTION_ATTRIBUTES, fillContent=fillContent})
	
		-- Generate tree for CP
	if CSPS.unlockedCP then
		CSPS.createCPTree()
	end
	
	if CSPS.doGear then CSPS.setupGearTree() end
	CSPS.setupQsTree()
	
	CSPS.tabEx = true
end

function CSPS.getTreeControl()
	return myTree
end