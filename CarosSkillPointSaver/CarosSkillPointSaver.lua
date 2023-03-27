CSPS = {
	name = "CarosSkillPointSaver",
	tabEx = false,
	skillTable = {},
	applyCP = false,
	applyCPc = {false, false, false},
	showApply = false,
	cp = {table = {}, bar = {{},{},{}}, sums = {0,0,0}}, -- will be filled in csps_cp2.lua
	cpProfiles = {},
	cpColors = {
		ZO_ColorDef:New(0.65098, 0.84706, 0.32157), -- 166/255, 216/255, 82/255
		ZO_ColorDef:New(0.36863, 0.74118, 0.90588), --94/255, 189/255, 231/255 
		ZO_ColorDef:New(0.870588, 0.396078, 0.192157), --222/255, 101/255, 49/255 
		ZO_ColorDef:New(0.83137, 0.196078, 0.87451), --212/255, 50/255, 223/255	-- quickslots
		ZO_ColorDef:New(0.784314, 0.635294, 0.392157), --(200/255, 162/255, 100/255 -- skills?
		ZO_ColorDef:New(0.337255, 0.529412, 0.427451), -- gear 86, 135, 109 --gear
	},
	colors = {
		white = ZO_ColorDef:New(1,1,1),
		green = ZO_ColorDef:New(0.1,0.7,0.1),
		red = ZO_ColorDef:New(0.84, 0.12, 0.12),
		orange = ZO_ColorDef:New(1, 0.24, 0),
		gray = ZO_ColorDef:New(0.21, 0.21, 0.21),
	},
	cp2ColorsA = {{70/255,107/255,7/255}, {23/255,101/255,135/255}, {166/255,58/255,11/255}},
	cpAutoOpen = false,
	cpImportCap = false,
	cpImportReverse = false,
	useCustomIcons = false,
	hbTables = {{},{}, {}},
	attrPoints = {0, 0, 0},
	unlockedCP = true,
	kaiserFranz = 1,
	subProfileDiscipline = 1,
	subProfileType = 1,
	ec = {correct = 1, wrongMorph = 2, rankHigher = 3, skillLocked = 4, rankLocked = 5, morphLocked = 6},
	showHotbar = false,
	bindings = {},
	profiles = {
	},
	currentProfile = 0,
	profileToLoad = 0,
	unsavedChanges = false,
}

local GS = GetString
local sdm = SKILLS_DATA_MANAGER

local skillTable = CSPS.skillTable
local cspsDoDebug = false

local ec = CSPS.ec
local cp = CSPS.cp

local function anyEntryNotFalse(table1, checkForSubTables)
	if not table1 then return false end
	for i, v in pairs(table1) do
		if v then
			if type(v) == "table" and checkForSubTables then 
				if anyEntryNotFalse(v) then return true end 
			else 
				return true 
			end
		end
	end
	return false
end

local hf = {
	tableParamsFit = function(table1, table2, paramList)
		for i, v in pairs(paramList) do
			if table1[v] ~= table2[v] then return false end
		end
		return true
	end,
	anyEntryNotFalse = anyEntryNotFalse,
	anyEntryFalse = function(table1, maxIndex)
		if maxIndex then
			for i=1, maxIndex do
				if not table1[i] then return true end
			end
			return false
		end
		for i, v in pairs(table1) do
			if v == false then return true end
		end
	end,
	getEmptyEntries = function(table1, maxIndex)
		local returnTable = {}
		for i=1, maxIndex do if not table1[i] then table.insert(returnTable, i) end end
		return returnTable
	end,
	fillNumericTable = function(fillTable, maxIndex, fillValue, fillWithEmptyTables, deleteHigher, deleteNonNumeric)
		if deleteHigher or deleteNonNumeric then
			for i, v in pairs(fillTable) do
				if type(i) ~= number then
					if deleteNonNumeric then fillTable[i] = nil end
				else
					if i > maxIndex and deleteHigher then fillTable[i] = nil end
				end
			end
		end
		for i=1, maxIndex do
			if fillTable[i] == nil then fillTable[i] = fillWithEmptyTables and {} or fillValue end
		end
	end,
	
}

CSPS.helperFunctions = hf

function CSPS.cspsD(...)
	if not cspsDoDebug then return end
	if #{...} == 1 and type((...)) ~= "table" then d(string.format("|c9e0911[CSPS-DEBUG]|r %s", tostring((...)))) return end
	d("|c9e0911[CSPS-DEBUG]:|r")
	d(...)
end

local cspsD = CSPS.cspsD

function CSPS.debug(arg)
	if arg ~= nil then cspsDoDebug = arg else cspsDoDebug = not cspsDoDebug end
	d("|c9e0911[CSPS IS DEBUGGING]:|r"..tostring(cspsDoDebug))
end

local function cspsPost(myMessage, noFormatter)
	if type(myMessage) ~= "table" then 
		myMessage = noFormatter and myMessage or string.format("|c9e0911[CSPS]|r %s", tostring(myMessage))
		CHAT_SYSTEM:AddMessage(myMessage)
		return
	end
	local addFormatter = not noFormatter
	for i, v in pairs(myMessage) do
		cspsPost(v, noFormatter)
	end
end

CSPS.post = cspsPost

function CSPS.isMagOrStam()
	local magStam = 0
	if CSPS.attrPoints[2] == 0 and CSPS.attrPoints[3] == 0 then
		if GetAttributeSpentPoints(2) > GetAttributeSpentPoints(3) then
			magStam = 1
		elseif GetAttributeSpentPoints(3) > GetAttributeSpentPoints(2) then
			magStam = 2
		end
	else
		if CSPS.attrPoints[2] > CSPS.attrPoints[3] then
			magStam = 1
		elseif CSPS.attrPoints[2] < CSPS.attrPoints[3] then
			magStam = 2
		end
	end
	return magStam
end


function CSPS.attrBtnPlusMinus(i, x, ctrl,alt,shift)
	local myShiftKey = CSPS.savedVariables.settings.jumpShiftKey or 7
	myShiftKey = myShiftKey == 7 and shift or myShiftKey == 4 and ctrl or myShiftKey == 5 and alt or false
	if myShiftKey then x = x * 10 end
	CSPS.attrPoints[i] = CSPS.attrPoints[i] + x
	if CSPS.attrPoints[i] < 0 then CSPS.attrPoints[i] = 0 end
	local diff = CSPS.attrPoints[1] + CSPS.attrPoints[2] + CSPS.attrPoints[3] - CSPS.attrSum()
	if diff > 0 then CSPS.attrPoints[i] = CSPS.attrPoints[i] - diff end
	 CSPS.refreshTree()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end



-- Initializing the addon on load

function CSPS:Initialize()
	local svName= "CSPSSavedVariables"
	local svVersion = 1
	local svNamesSpace = nil
	local currentCharId = GetCurrentCharacterId()
	local svDefaults = {	
		wasConverted = false,
		settings = {
			applyCP = false,
		},
		charData = {
			[currentCharId] = {},
		},
	} 
	local svProfile = GetWorldName()
	
	CSPS.doGear = LibSets and true or false
	CSPSWindowBuildGearProfiles:SetHidden(not CSPS.doGear)
	if not CSPS.doGear then CSPSWindowBuildGearProfiles:SetWidth(0) end
	
	CSPS.savedVariables = ZO_SavedVars:NewAccountWide(svName, svVersion, svNamesSpace, svDefaults, svProfile, nil) -- savedvars account wide, server dependent
	-- CSPS.kaiserFranz: id for the emperor skill line (named after emperor Franz, the 52nd of his name)
	if string.lower(GetCVar("Language.2")) ~= "de" then
		_, CSPS.kaiserFranz, _ = GetSkillLineIndicesFromSkillLineId(71)
	end
	
	CSPS.currentCharData = CSPS.savedVariables.charData[currentCharId]
		
	-- if no skills have been saved yet for this char, save everything once
	if CSPS.currentCharData.werte == nil then
		CSPS.populateTable()
		CSPS.saveBuildGo()
	end
	-- if no attributes have been saved yet for this char, save the current attributes
	if CSPS.currentCharData.attribute == nil then	
		CSPS.populateAttributes()
		local attrComp = CSPS.attrCompress(CSPS.attrPoints)
		CSPS.currentCharData.attribute = attrComp
	end
	
	-- if no hotbars have been saved yet for this char, save the current attributes
	if CSPS.currentCharData.hbwerte == nil then
		CSPS.populateTable(true)
		CSPS.hbRead()
	    local hbComp = CSPS.hbCompress(CSPS.hbTables)
		CSPS.currentCharData.hbwerte = hbComp
	end
	
	-- Hide CP-Option if no Character has reached level 50 yet.
	if GetPlayerChampionPointsEarned() == 0 then 
		CSPS.unlockedCP = false
		CSPS.applyCP = false
	end
				
				
	CSPS.currentCharData.profiles = CSPS.currentCharData.profiles or {}
	CSPS.currentCharData.bindings = CSPS.currentCharData.bindings or {} -- connections between hotkey-groups and situations etc.
	CSPS.savedVariables.bindings = CSPS.savedVariables.bindings or {}
	
	CSPS.profiles = CSPS.currentCharData.profiles
	CSPS.bindings = CSPS.currentCharData.bindings
	CSPS.bindingsA = CSPS.savedVariables.bindings
	
	CSPS.currentCharData.cpHbProfiles = CSPS.currentCharData.cpHbProfiles  or {}
	CSPS.savedVariables.cpHbProfiles = CSPS.savedVariables.cpHbProfiles  or {}
	
	local mySettings = CSPS.savedVariables.settings
	
	CSPS.setupImportExportTextEdit()
	
	local formatImpExp = mySettings.formatImpExp or "sf"
	CSPS.toggleImpExpSource(formatImpExp, true)
	
	mySettings.importExportParts = mySettings.importExportParts or {skills = true, hotbar = true, attributes = true, mundus = true, cp = true, gear = true, quickslots = true}
	CSPS.toggleCPImpExpParts()
	
	CSPS.cpImportCap =  mySettings.cpImportCap or false
	CSPS.cpImportLang = mySettings.cpImportLang or false
	CSPS.cpImportReverse = mySettings.cpImportReverse or false
	
	CSPS.toggleCPCapImport(CSPS.cpImportCap)
	CSPS.toggleCPImportLanguage(CSPS.cpImportLang)
	CSPS.toggleCPReverseImport(CSPS.cpImportReverse)
	
	CSPS.InitLocalText()
	
	if not CSPS.savedVariables.wasConverted then
		CSPS.convertOldSVs()
	end
		
	cp.CreateTable()
	cp.createList()
	
	CSPS.InitializeMundusMenu()
	
	CSPS:RestorePosition()
	CSPS.prepareTheTree()
	
	CSPS.currentCharData.cp2hbpHotkeys = CSPS.currentCharData.cp2hbpHotkeys or {}
	CSPS.spHotkeysC = CSPS.currentCharData.cp2hbpHotkeys
	CSPS.savedVariables.spHotkeys = CSPS.savedVariables.spHotkeys or {}
	CSPS.spHotkeysA = CSPS.savedVariables.spHotkeys
	
	if #CSPS.spHotkeysC < 20 then
		for i=1, 20 do
			table.insert(CSPS.spHotkeysC, {})
			if #CSPS.spHotkeysC == 20 then break end
		end
	end
	
	if #CSPS.spHotkeysA < 20 then
		for i=1, 20 do
			table.insert(CSPS.spHotkeysA, {})
			if #CSPS.spHotkeysA == 20 then break end
		end
	end
	
	mySettings.accountWideShiftKey = mySettings.accountWideShiftKey or 7
	
	CSPS.initConnect()
	
	CSPS.showElement("checkCP")
	CSPS.showElement("apply", false)

	
	CSPS.toggleStrictOrder(mySettings.strictOrder or false)
	--local cpRemindMe = mySettings.cpReminder or false
	CSPS.toggleCPAutoOpen()
	CSPS.toggleArmoryAutoOpen()
	CSPS.toggleCP(0, mySettings.applyCP and CSPS.unlockedCP)
	mySettings.showHotbar = nil
	
	CSPS.showElement("hotbar", not mySettings.hideHotbar)
	
	CSPS.toggleCPCustomBar()
	CSPS.toggleCPCustomIcons()
	CSPSWindowBtnApplyAll:SetHidden(not mySettings.showApplyAll)
	
	CSPS.setGearMarkerOption(CSPS.savedVariables.settings.showGearMarkers)
	CSPS.setGearMarkerOptionData(CSPS.savedVariables.settings.showGearMarkerDataBased)
	
	if CSPS.doGear then 
		CSPS.setupGearMarkers()
	end
	
	CSPS.setupLam()
		
	EVENT_MANAGER:RegisterForEvent(CSPS.name.."OnCpPurchase", EVENT_CHAMPION_PURCHASE_RESULT, cp.onCPChange)
	EVENT_MANAGER:RegisterForEvent(CSPS.name.."OnPlayerActivated", EVENT_PLAYER_ACTIVATED, function() CSPS.onPlayerActivated() end)
	EVENT_MANAGER:UnregisterForEvent(CSPS.name.."OnAddOnLoaded", EVENT_ADD_ON_LOADED)
end

function CSPS.OnAddOnLoaded(event, addonName)
	if addonName == CSPS.name then
		EVENT_MANAGER:UnregisterForEvent(CSPS.name.."OnAddOnLoaded", EVENT_ADD_ON_LOADED)
		CSPS:Initialize()
	end
end

-- display the current skills

function CSPS.showBuild(initOpen)
	CSPS.showElement("apply", false)
	CSPS.showElement("save", true)
	CSPS.populateTable()
	cp.readCurrent()
	CSPS.hbRead()
	CSPS.hbPopulate()
	CSPS.readCurrentQS()
	if not CSPS.tabEx then 
		CSPS.createTable() 
	end
	
	cp.updateSidebarIcons()
	cp.updateSlottedMarks()
	
	if CSPS.doGear then
		CSPS.getCurrentGear()
	end
	
	CSPS.refreshTree() 
	CSPS.unsavedChanges = not initOpen
end

function CSPS.saveBuild()
	local myName = GS(CSPS_Txt_StandardProfile)
	if CSPS.currentProfile ~= 0 then myName = CSPS.profiles[CSPS.currentProfile].name end
	local myWarning = not CSPS.savedVariables.settings.suppressSaveOther and (not CSPSWindowSubProfiles:IsHidden()) and GS(CSPS_MSG_NoCPProfiles) or ""
	
	ZO_Dialogs_ShowDialog(CSPS.name.."_OkCancelDiag", 
		{returnFunc = function() CSPS.saveBuildGo()   end},  
		{mainTextParams = {zo_strformat(GS(CSPS_MSG_ConfirmSave), myName, myWarning)}, titleParams = {GS(CSPS_MyWindowTitle)}})
end


function CSPS.saveBuildGo()
	local skillTableClean = CSPS.compressLists()
	local hbComp = CSPS.hbCompress(CSPS.hbTables)
	local attrComp = CSPS.attrCompress(CSPS.attrPoints)
	local cpComp = cp.compress(cp.table) 
	local cpHbComp = cp.hotBarCompress(cp.bar)
	local gearComp, gearCompUnique = nil
	if CSPS.doGear then
		gearComp, gearCompUnique = CSPS.buildGearString()
	end
	
	-- local myKeys = generateKeys()
	local profileToSave = {}
	if CSPS.currentProfile == 0 then
		profileToSave = CSPS.currentCharData
	else 
		profileToSave = CSPS.profiles[CSPS.currentProfile]
	end

	profileToSave.werte = skillTableClean
	profileToSave.hbwerte = hbComp
	profileToSave.attribute = attrComp
	
	profileToSave.cp2werte = cpComp
	profileToSave.cp2hbwerte = cpHbComp
	profileToSave.mundus = CSPS.currentMundus
	profileToSave.gearComp = gearComp
	profileToSave.gearCompUnique = gearCompUnique
	profileToSave.qs = CSPS.compressQS(CSPS.getQsBars())
	profileToSave.lastSaved = os.time()
	
	CSPS.currentCharData.profiles = CSPS.profiles
	
	if CSPS.doGear then 
		CSPS.buildGearMarkerTable()
	end

	CSPS.currentCharData.svApi = GetAPIVersion()
	-- CSPS.currentCharData.myKeys = myKeys
	CSPS.currentCharData["$lastCharacterName"] = ZO_CachedStrFormat(SI_UNIT_NAME, GetRawUnitName('player'))
	CSPS.showElement("load")
	CSPS.unsavedChanges = false
	if CSPSWindowBuildProfiles.comboBox then CSPS.UpdateProfileCombo() end
end

function CSPS.populateAttributes()
	-- Read current attribute points
	for i=1, 3 do
		CSPS.attrPoints[i] = GetAttributeSpentPoints(i) 
	end
end


function CSPS.populateTable(doNotFill)
	CSPS.populateAttributes()
	cp.resetTable()
	CSPS.refreshTree()
	--- Read Current Skills
	if #skillTable == 0 then CSPS.createSkillTable() else CSPS.resetSkills() end	
	if not doNotFill then CSPS.readCurrentSkills() end
end

function CSPS.attrCompress(attrPoints)
	local attrComp = table.concat(attrPoints, ";")
	return attrComp
end

function CSPS.hbCompress(hbTables)
	local hbComp = ""
	local auxHb = {}
	for i=1,3 do
		if hbTables[i] then
			local auxHb1 = {}
			local anySkillsInBar = false
			for j=1,6 do
				if hbTables[i][j] ~= nil then 
					-- auxHb1[j] = table.concat(hbTables[i][j], "-")
					auxHb1[j] = GetSpecificSkillAbilityInfo(hbTables[i][j][1], hbTables[i][j][2], hbTables[i][j][3], 0, 1)
					anySkillsInBar = true
				else
					auxHb1[j] = "-"
				end
			end
			auxHb[i] = table.concat(auxHb1, ",")
			if i == 3 and not anySkillsInBar then auxHb[i] = nil end
		end
	end
	hbComp = table.concat(auxHb, ";")
	return hbComp
end

function CSPS.compressLists(skillTableToCompress)
	skillTableToCompress = skillTableToCompress or skillTable
	local activeAbs, passiveAbs = {{}}, {{}}
	local activeTab, passiveTab = {},{}
	for skillType, skillTypeData in ipairs(skillTable) do
		for skillLineIndex, skillLineData in ipairs(skillTypeData) do
			for skillIndex, skEntry in ipairs(skillLineData) do
				if skEntry.purchased then
					local myId = GetSpecificSkillAbilityInfo(skillType, skillLineIndex, skillIndex, not skEntry.passive and skEntry.morph or 0, 1)
					if skEntry.passive and not (skEntry.autoGrant and skEntry.rank == 1) then
						table.insert(passiveAbs[#passiveAbs], string.format("%s:%s", myId, skEntry.rank or 1))
						if #passiveAbs[#passiveAbs] == 100 then table.insert(passiveAbs, {}) end
					elseif not skEntry.passive and not (skEntry.autoGrant and skEntry.morph == 0) then
						table.insert(activeAbs[#activeAbs], string.format("%s:%s", myId, skEntry.morph or 0))
						if #activeAbs[#activeAbs] == 100 then table.insert(activeAbs, {}) end
					end
				end
			end
		end
	end
	
	for i, v in pairs(passiveAbs) do passiveTab[string.format("part%s", i)] = table.concat(v, ",") end	
	for i, v in pairs(activeAbs) do activeTab[string.format("part%s", i)] = table.concat(v, ",") end
	
	return {prog = activeTab, pass = passiveTab}
end


function CSPS.skTableExtract(progTab, passTab, ignoreClass, changeSilent)
	local racialChange = false
	if type(progTab) == "table"  or type(passTab) == "table" then 
		progTab = progTab or {} 
		passTab = passTab or {}
		if not progTab["part1"] and not passTab["part1"] then return CSPS.oldSkExtract(progTab, passTab) end
		local morphs, upgrades = {}, {}
		
		for listIndex, myList in pairs(progTab) do
			local thisList = {SplitString(",", myList)}
			for progInd, skMorph in pairs(thisList) do --extract all the skills with progressionIndices (morphable skills)
				local myId, l = SplitString(":", skMorph)
				myId, l = tonumber(myId), tonumber(l)
				local i, j, k = GetSpecificSkillAbilityKeysByAbilityId(myId) 
				if i ~= 1 or j < 4 or ignoreClass then
					if i == 7 and j > 1 then racialChange = true j = 1 end -- If racial skills just change to the current race
					if IsSkillAbilityPassive(i,j,k) then 
						l = 0
						table.insert(upgrades, {i, j, k, l})
						local myName = GetSkillAbilityInfo(i,j,k)
						d(string.format("[CSPS] %s", zo_strformat(GS(CSPS_LoadingError), myName)))
					else 
						table.insert(morphs, {i, j, k, l})
					end
				end
			end
		end	
		for listIndex, myList in pairs(passTab) do
			local thisList = {SplitString(",", myList)}
			for passInd, skPass in pairs(thisList) do --extract all the skills without progressionIndices (passives)
				local myId, l = SplitString(":", skPass)
				myId, l = tonumber(myId), tonumber(l)
				local i, j, k = GetSpecificSkillAbilityKeysByAbilityId(myId) 
				if i ~= 1 or j < 4 or ignoreClass then
					if i == 7 and j > 1 then racialChange = true j = 1 end -- If racial skills just change to the current race
					if IsSkillAbilityPassive(i,j,k) then
						local _, maxRank = GetSkillAbilityUpgradeInfo(i, j, k)
						if maxRank then
							if l > maxRank then
								l = maxRank
								local myName = GetSkillAbilityInfo(i,j,k)
								d(string.format("[CSPS] %s", zo_strformat(GS(CSPS_LoadingError), myName)))
							end
						end
						table.insert(upgrades, {i, j, k, l})
					else
						l = 0 
						local myName = GetSkillAbilityInfo(i,j,k)
						d(string.format("[CSPS] %s", zo_strformat(GS(CSPS_LoadingError), myName)))
						table.insert(morphs, {i, j, k, l})
					end
				end	
			end
		end	
		if racialChange and not changeSilent then d(zo_strformat("[CSPS] <<C:1>>!", GS(SI_SERVICETOKENTYPE2))) end
		return morphs, upgrades, racialChange
	else
		return {}, {}, racialChange
	end
end

function CSPS.tableExtract(progTab, passTab)
	local morphs, upgrades = CSPS.skTableExtract(progTab, passTab)
	CSPS.populateSkills(morphs, upgrades)
end

function CSPS.populateSkills(morphs, upgrades, keepOld)
	if #skillTable == 0 then CSPS.createSkillTable() elseif not keepOld then CSPS.resetSkills() end
	
	local function fillSkill(auxListIndex, skillData, isActive)
		local skillType, skillLineIndex, skillIndex, rankOrMorph = unpack(skillData)
	
		-- Fill in the table entry
		local theSkill = skillTable[skillType][skillLineIndex][skillIndex] 
		if theSkill then
			theSkill.rank = isActive and 1 or rankOrMorph
			theSkill.purchased = true
			theSkill.morph = isActive and (rankOrMorph or 0) or nil
			theSkill.hb = {}
		end	
	end
	
	for progInd, mV in pairs(morphs) do
		fillSkill(progInd, mV, true)
	end
	for passInd, mV in pairs(upgrades) do
		fillSkill(passInd, mV, false)
	end
	CSPS.refreshSkillSumsAndErrors()
end

function CSPS.attrExtract(attrComp)
	if attrComp ~= "" then
		CSPS.attrPoints = {SplitString(";", attrComp)}
	end
end

function CSPS.hbExtract(hbComp, classId)
	local hbTables = {{},{},{}}
	hbComp = hbComp or ""
	if hbComp ~= "" then
		local auxHb = {SplitString(";", hbComp)}
		hbTables = {}
		for hbIndex=1,3 do
			hbTables[hbIndex] = {}
			if auxHb[hbIndex] then
				local auxHb1 = {SplitString(",", auxHb[hbIndex])}
				for hbPosition, aSkill in pairs(auxHb1) do
					if aSkill == "" or aSkill == "-" then 
						hbTables[hbIndex][hbPosition] = nil
					else
						local skTyp, skLin, skId
						if string.find(aSkill, "-") then
							skTyp, skLin, skId = CSPS.extractOldHbSkill(aSkill)
						else
							local myAbId = tonumber(aSkill)
							skTyp, skLin, skId = GetSpecificSkillAbilityKeysByAbilityId(aSkill)
						end
						if skTyp and skLin and skId and (skTyp ~=1 or skLin < 4 or classId) then hbTables[hbIndex][hbPosition] = {skTyp, skLin, skId} end
					end
				end
			end
		end
	end
	return hbTables
end


	
function CSPS.loadBuild()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	if CSPS.currentCharData.werte == nil and CSPS.profiles == {} then cspsPost(GS(CSPS_NoSavedData)) return end
		
	local myProfile = CSPS.currentProfile == 0 and CSPS.currentCharData or CSPS.profiles[CSPS.currentProfile]

	local skillTableClean = myProfile.werte
	local cpComp = myProfile.cp2werte or ""
	local cpHbComp = myProfile.cp2hbwerte or ""
	local attrComp = myProfile.attribute
	local hbComp = myProfile.hbwerte
	local gearComp = myProfile.gearComp or ""
	local gearCompUnique = myProfile.gearCompUnique
	CSPS.setMundus(myProfile.mundus)
	CSPS.tableExtract(skillTableClean.prog, skillTableClean.pass)
	
	myProfile.connections = myProfile.connections or {}
	
	local hasConnections = {}
	local cpProfilesToLoad = {}
	local cpPresetsToLoad = {}
		
	for myDiscipline=1, 3 do
		if myProfile.connections[myDiscipline] then 
			hasConnections[myDiscipline] = true 
		end
	end
	
	CSPS.extractQS(myProfile.qs, CSPS.getQsBars())
	CSPS.loadConnectedQuickSlots() 
		
	cp.extract(cpComp, hasConnections)
	cp.hotBarExtract(cpHbComp, cp.bar, hasConnections)

	local outdatedPresets = false
	
		for myDiscipline=1, 3 do
		if myProfile.connections[myDiscipline] then 
			local myType, myId = SplitString("-", myProfile.connections[myDiscipline])
			if myType == "4" then 
				outdatedPresets = CSPS.loadCPPreset(tonumber(myType), tonumber(myId), myDiscipline, true) or outdatedPresets
			else
				CSPS.loadCPProfile(tonumber(myType), tonumber(myId), myDiscipline)
			end
		end
	end

	if outdatedPresets then cspsPost(GS(CSPS_CPOldPreset)) end

	CSPS.hbTables = CSPS.hbExtract(hbComp)
	CSPS.hbLinkToSkills(CSPS.hbTables)
	CSPS.hbPopulate()
	CSPS.attrExtract(attrComp)
	if not CSPS.tabEx then CSPS.createTable() end
	
	cp.updateSidebarIcons()
	
	cp.updateSlottedMarks()
	
	if CSPS.doGear then
		CSPS.setTheGear(CSPS.extractGearString(gearComp, gearCompUnique))
	end

	CSPS.refreshTree() 
	CSPS.unsavedChanges = false
end


function CSPS.attrSum()
	return GetAttributeSpentPoints(1) + GetAttributeSpentPoints(2) + GetAttributeSpentPoints(3) + GetAttributeUnspentPoints()
end

function CSPS.applyAttr(skipDiag)
	if not CSPS.tabEx then return end
	local attr1 = CSPS.attrPoints[1] -  GetAttributeSpentPoints(1)
	local attr2 = CSPS.attrPoints[2] -  GetAttributeSpentPoints(2)
	local attr3 = CSPS.attrPoints[3] -  GetAttributeSpentPoints(3)
	if attr1 == 0 and attr2 == 0 and attr3 == 0 then return end
	if attr1 + attr2 + attr3 > GetAttributeUnspentPoints() then	--- Are there enough points to spend?
		ZO_Dialogs_ShowDialog(CSPS.name.."_OkDiag", {},  {mainTextParams = {GS(CSPS_MSG_ConfirmAttr1)}, titleParams = {GS(CSPS_MSG_ConfirmAttrTitle)}})
		return 
	end 
	if attr1 < 0 or attr2 < 0 or attr3 < 0 then -- any attr points already higher than intended?
		ZO_Dialogs_ShowDialog(CSPS.name.."_OkDiag", {},  {mainTextParams = {GS(CSPS_MSG_ConfirmAttr2)}, titleParams = {GS(CSPS_MSG_ConfirmAttrTitle)}})
		return 
	end
	if not skipDiag then
		ZO_Dialogs_ShowDialog(CSPS.name.."_OkCancelDiag", 
			{returnFunc = function() 
				PurchaseAttributes(attr1, attr2, attr3)
			end},  
			{mainTextParams = {zo_strformat(GS(CSPS_MSG_ConfirmAttr), attr1+attr2+attr3, GetAttributeUnspentPoints())}, titleParams = {GS(CSPS_MSG_ConfirmAttrTitle)}})
	else
		PurchaseAttributes(attr1, attr2, attr3)
	end
end




function CSPS.carotest42(args)
	d('[CSPS] Congratulations, you found my internal function for testing purposes. Have a good day and remember to always bring a towel! (Irniben)')
end

 SLASH_COMMANDS["/carotest42"] = CSPS.carotest42
 SLASH_COMMANDS["/csps"] = function() CSPSWindow:SetHidden(not CSPSWindow:IsHidden()) end
 EVENT_MANAGER:RegisterForEvent(CSPS.name.."OnAddOnLoaded", EVENT_ADD_ON_LOADED, CSPS.OnAddOnLoaded)