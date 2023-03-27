local skillTable = CSPS.skillTable
local GS = GetString
local sdm = SKILLS_DATA_MANAGER
local ec = CSPS.ec
local skillForHB = false
local tryingToApplySkills = false

local skillTypes = {SKILL_TYPE_CLASS, SKILL_TYPE_WEAPON, SKILL_TYPE_ARMOR, SKILL_TYPE_WORLD, SKILL_TYPE_GUILD, SKILL_TYPE_AVA, SKILL_TYPE_RACIAL, SKILL_TYPE_TRADESKILL}

-- Drag and drop functions for hotbars ---
function CSPS.onSkillDrag(i, j, k)
	skillForHB = {i,j,k,IsSkillAbilityUltimate(i,j,k)}
end

function CSPS.onHbIconDrag(myBar, icon)

	if CSPS.werewolfMode then myBar = 3 end
	
	local thisSkill = CSPS.hbTables[myBar][icon]
	if thisSkill ~= nil then
		local i = thisSkill[1]
		local j = thisSkill[2]
		local k = thisSkill[3]
		skillForHB = {i,j,k,IsSkillAbilityUltimate(i,j,k)}
	end
end


function CSPS.onHbIconReceive(myBar, icon)
	if not skillForHB then return end 
	if icon == 6 and skillForHB[4] == false then return end
	if icon < 6 and skillForHB[4] == true then return end
	
	local i = skillForHB[1]
	local j = skillForHB[2]
	local k = skillForHB[3]
	
	if IsWerewolfSkillLineById(GetSkillLineId(i, j)) then
		-- if not CSPS.werewolfMode then return end -- can slot werewolf skills on any bar
	else
		if CSPS.werewolfMode then return end
	end
	
	if CSPS.werewolfMode then myBar = 3 end
	
	CSPS.hbSkillRemove(myBar, icon)
	local indOld = skillTable[i][j][k].hb[myBar]
	if 	indOld ~= nil then
			CSPS.hbTables[myBar][indOld] = nil
	end
	CSPS.hbTables[myBar][icon] = {i, j, k}
	skillTable[i][j][k].hb[myBar] = icon
	skillForHB = false
	CSPS.hbPopulate()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

function CSPS.hbSkillRemove(myBar, icon)
	if CSPS.werewolfMode then myBar = 3 end
	if CSPS.hbTables[myBar][icon] ~= nil then
		local i = CSPS.hbTables[myBar][icon][1] 
		local j = CSPS.hbTables[myBar][icon][2] 
		local k = CSPS.hbTables[myBar][icon][3]
		skillTable[i][j][k].hb[myBar] = nil
		CSPS.hbTables[myBar][icon] = nil
	end
	CSPS.hbPopulate()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

local function refreshSkillPointSum()
	skillTable:sumUpSkills()
	CSPSWindowIncludeSkLabel:SetText(string.format("%s (%s/%s)", GetString(SI_CHARACTER_MENU_SKILLS), skillTable.pointsToSpend, GetAvailableSkillPoints()))
end

-- plus and minus functions for skills from the list

function CSPS.minusClickSkill(theSkill, ctrl, alt, shift)
	local myShiftKey = CSPS.savedVariables.settings.jumpShiftKey or 7
	myShiftKey = myShiftKey == 7 and shift or myShiftKey == 4 and ctrl or myShiftKey == 5 and alt or false
	if not theSkill.passive then		-- progression skill?
		theSkill.morph = theSkill.morph or 0
		if myShiftKey or theSkill.morph == 0 then -- delete if not morphed
			theSkill.purchased = false
			for myBar = 1, 3 do
				if theSkill.hb[myBar] ~= nil then CSPS.hbSkillRemove(myBar, theSkill.hb[myBar]) end
			end
		else
			theSkill.morph = theSkill.morph - 1 -- if morphed change/remove morph
		end
	else		-- Passive
		if not myShiftKey and theSkill.rank > 1 then -- if rank > 1 substract 1
			theSkill.rank = theSkill.rank - 1
		else
			theSkill.purchased = false -- otherwise delete
		end
	end

	theSkill:setPoints()
	theSkill.lineData:sumUpSkills()
	theSkill.typeData:sumUpSkills()
	
	refreshSkillPointSum()
	CSPS.hbPopulate()
	 CSPS.refreshTree()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end

function CSPS.minusClickSkillLine(skTyp, skLin, shift)
	local name = GS("SI_SKILLTYPE", skTyp)
	if skLin ~= nil then name = skillTable[skTyp][skLin].name end
	ZO_Dialogs_ShowDialog(CSPS.name.."_OkCancelDiag", 
		{returnFunc = function() CSPS.removeSkillLine(skTyp, skLin) end},  
		{mainTextParams = {zo_strformat(GS(CSPS_MSG_DeleteSkillType), name)}, titleParams = {GS(CSPS_MyWindowTitle)}})
end

function CSPS.removeSkillLine(skTyp, skLin)
	local typeData = skillTable[skTyp]
	for lineIndex, skillLine in ipairs(typeData) do
		if not skLin or skLin == lineIndex then
			for _, skillData in ipairs(skillLine) do
				if skillData.purchased then
					skillData.purchased = false
					skillData:setPoints()
					if not skillData.purchased then
						for myBar = 1, 3 do
							if skillData.hb[myBar] ~= nil then CSPS.hbSkillRemove(myBar, skillData.hb[myBar]) end
						end	
					end
				end
			end
			skillLine:sumUpSkills()
		end
	end
	typeData:sumUpSkills()
	refreshSkillPointSum()
	CSPS.refreshTree()
end

function CSPS.plusClickSkillLine(skillType, skillLineIndex, shift)
	local typeData = skillTable[skillType]
	for lineIndex, skillLine in ipairs(typeData) do
		if not skillLineIndex or skillLineIndex == lineIndex then
			for _, skillData in ipairs(skillLine) do
				if skillData.passive then
					skillData.purchased = true
					skillData.rank = 42 -- will be reduced to max rank in the next function call
					skillData:setPoints()
				end
			end
			skillLine:sumUpSkills()
		end
	end
	typeData:sumUpSkills()
	refreshSkillPointSum()
	CSPS.refreshTree()
end

function CSPS.plusClickSkill(theSkill, ctrl, alt, shift)
	local myShiftKey = CSPS.savedVariables.settings.jumpShiftKey or 7
	myShiftKey = myShiftKey == 7 and shift or myShiftKey == 4 and ctrl or myShiftKey == 5 and alt or false
	
	if theSkill.purchased == false then	-- Skill is not purchased?
			theSkill.purchased = true
			theSkill.rank = theSkill.passive and (myShiftKey and 42 or 1) or nil	-- 42 will later be reduced to the maxRank
			theSkill.morph = not theSkill.passive and 0 or nil
	else
		
		if not theSkill.passive then
			theSkill.morph = theSkill.morph + 1
		else
			theSkill.rank = myShiftKey and 42 or theSkill.rank + 1
		end
	end
	theSkill:setPoints()
	theSkill.lineData:sumUpSkills()
	theSkill.typeData:sumUpSkills()

	refreshSkillPointSum()
	CSPS.refreshTree()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end




local function setPointsActive(self)
	-- ec = {correct = 1, wrongMorph = 2, rankHigher = 3, skillLocked = 4, rankLocked = 5, morphLocked = 6}
	local currentlyPurchased = self.zo_data:GetPointAllocator():IsPurchased()
	local currentMorph = self.zo_data:GetCurrentSkillProgressionKey() 
	local lineUnlocked = self.lineData.zo_data:IsActive() and self.zo_data:MeetsLinePurchaseRequirement()
	local points = self.autoGrant and 0 or 1
	
	self.morph = self.morph or 0
	self.morph = self.morph > 2 and 2 or self.morph
	self.maxRaMo = self.morph == 2
	points = self.morph > 0 and points + 1 or points
	if not lineUnlocked then
		self.pointsToSpend = 0
		self.error = not (self.autoGrant and self.morph == 0) and ec.skillLocked
	elseif currentlyPurchased then
		if currentMorph > 0 and currentMorph ~= self.morph then
			self.pointsToSpend = 0
			self.error = ec.wrongMorph
		elseif currentMorph == self.morph then
			self.pointsToSpend = 0
			self.error = ec.correct
		else
			self.pointsToSpend = 1
		end
	else
		self.pointsToSpend = points
	end
	if self.morph > 0 and not self.zo_data:GetProgressionData(self.morph):IsUnlocked() then 
		self.error = ec.morphLocked 
		self.pointsToSpend = lineUnlocked and points - 1 or 0
	end
	return points
end

local function setPointsPassive(self)
	local maxRank = self.zo_data:GetNumRanks()
	local currentlyPurchased = self.zo_data:GetPointAllocator():IsPurchased()
	local currentRank = self.zo_data:GetCurrentSkillProgressionKey()
	local lineUnlocked = self.lineData.zo_data:IsActive() and self.zo_data:MeetsLinePurchaseRequirement()
	local points = self.autoGrant and 0 or 1
	
	self.maxRaMo = self.rank >= maxRank
	self.rank = self.rank <= maxRank and self.rank or maxRank
	self.rank = self.rank > 0 and self.rank or 1
	points = points + self.rank - 1
	if not lineUnlocked then
		self.pointsToSpend = 0
		self.error = not (self.autoGrant and self.rank == 1) and ec.skillLocked
	elseif currentlyPurchased then
		if currentRank > self.rank then
			self.pointsToSpend = 0
			self.error = ec.rankHigher
		elseif currentRank == self.rank then
			self.pointsToSpend = 0
			self.error = ec.correct
		else
			self.pointsToSpend = self.rank - currentRank
		end
	else
		self.pointsToSpend = points
	end
	if not self.zo_data:GetProgressionData(self.rank):IsUnlocked() and not (self.autoGrant and self.rank == 1) then 
		local possibleRank = 0 -- will only be used for skill points to invest
		for i=1, self.rank do
			if self.zo_data:GetProgressionData(i):IsUnlocked() then
				possibleRank = i
			else
				break
			end
		end
		self.pointsToSpend = possibleRank > currentRank and possibleRank - currentRank or 0
		self.error = ec.rankLocked 
	end
	return points
end

local function setPoints(self)
	self.error = nil
	if not self.purchased then 
		self.points = 0 
		self.pointsToSpend = 0
		self.maxRaMo = false
		self.rank = 1
		self.morph = not self.passive and 0 or nil
		if self.autoGrant then self.purchased = true else return end  
	end
	
	self.points = self.passive and setPointsPassive(self) or setPointsActive(self)
end

local function sumUpSkills(self)
	local points = 0
	local pointsToSpend = 0
	local errorSums = {0,0,0,0,0,0,0,0}
	for i, v in ipairs(self) do
		points = v.points and points + v.points or points
		pointsToSpend = v.pointsToSpend and pointsToSpend + v.pointsToSpend or pointsToSpend
		if v.error then 
			errorSums[v.error] = errorSums[v.error] or 0
			errorSums[v.error] = errorSums[v.error] + 1
		elseif v.errorSums then 
			for j, w in pairs(v.errorSums) do
				errorSums[j] = errorSums[j] or 0
				errorSums[j] = errorSums[j] + v.errorSums[j]
			end
		end
	end
	self.points = points
	self.pointsToSpend = pointsToSpend
	self.errorSums = errorSums
end

function CSPS.createSkillTable()
	skillTable.sumUpSkills = sumUpSkills
	for skillType=1, #skillTypes do
		skillTable[skillType] = {sumUpSkills = sumUpSkills}
		local skillTypeData = skillTable[skillType]
		for skillLineIndex = 1, GetNumSkillLines(skillType) do
			-- stop after your own class and race skilllines
			if skillType==1 and skillLineIndex==4 or skillType==7 and skillLineIndex==2 then break end
			
			local zoSkillLineData = sdm:GetSkillLineDataByIndices(skillType, skillLineIndex)
			skillTypeData[skillLineIndex] = {name = zoSkillLineData:GetFormattedName(), type = skillType, sumUpSkills = sumUpSkills, zo_data = zoSkillLineData, points = 0}
			
			local skillLineData = skillTypeData[skillLineIndex]
			
			if IsWerewolfSkillLineById(GetSkillLineId(skillType, skillLineIndex)) then 
				skillLineData["isWerewolf"] = true 
				skillTypeData["isWerewolfParent"] = true
			end
			
			for skillIndex = 1, GetNumSkillAbilities(skillType, skillLineIndex) do
				local zoSkillData = zoSkillLineData:GetSkillDataByIndex(skillIndex)
				
				skillLineData[skillIndex] = {
					type = skillType,
					line = skillLineIndex,
					index = skillIndex,
					typeData = skillTypeData,
					lineData = skillLineData,
					autoGrant = zoSkillData:IsAutoGrant(),
					setPoints = setPoints,
					zo_data = zoSkillData,
					passive = zoSkillData:IsPassive(),
				}
				
				local skEntry = skillLineData[skillIndex]
								
				local baseData = skEntry.passive and zoSkillData:GetRankData(1) or zoSkillData:GetMorphData(MORPH_SLOT_BASE)
					
				skEntry.name = baseData:GetFormattedName()
				skEntry.texture = baseData:GetIcon()
				
				if not skEntry.passive then
					skEntry.morphNames = {zoSkillData:GetMorphData(MORPH_SLOT_MORPH_1):GetFormattedName(), zoSkillData:GetMorphData(MORPH_SLOT_MORPH_2):GetFormattedName()}
					skEntry.morphTextures = {zoSkillData:GetMorphData(MORPH_SLOT_MORPH_1):GetIcon(), zoSkillData:GetMorphData(MORPH_SLOT_MORPH_2):GetIcon()}
				end
				
				skEntry.morph = not skEntry.passive and 0 or nil
				skEntry.points = 0
				skEntry.auxListIndex = 0
				skEntry.maxRaMo = false
				skEntry.rank = 1
				skEntry.hb = {}
				skEntry.purchased = false
			end
			skillLineData:sumUpSkills()
		end
		skillTypeData:sumUpSkills()
	end
	refreshSkillPointSum()
end

function CSPS.resetSkills()
	for skillType, skillTypeData in ipairs(skillTable) do
		for skillLineIndex, skillLineData in ipairs(skillTypeData) do
			for skillIndex, skEntry in ipairs(skillLineData) do
				skEntry.purchased = skEntry.autoGrant
				skEntry.rank = 1
				skEntry.morph = not skEntry.passive and 0 or nil
				skEntry:setPoints()
			end	
			skillLineData:sumUpSkills()
		end
		skillTypeData:sumUpSkills()
	end			
	refreshSkillPointSum()
end

function CSPS.readCurrentSkills()
	for skillType, skillTypeData in ipairs(skillTable) do
		for skillLineIndex, skillLineData in ipairs(skillTypeData) do
			for skillIndex, skEntry in ipairs(skillLineData) do
				skEntry.purchased = skEntry.zo_data:GetPointAllocator():IsPurchased()
					
				skEntry.morph = skEntry.purchased and not skEntry.passive and skEntry.zo_data:GetCurrentSkillProgressionKey() or nil
				skEntry.rank = skEntry.purchased and skEntry.passive and skEntry.zo_data:GetCurrentSkillProgressionKey() or 1
					
				skEntry:setPoints()	
			end	
			skillLineData:sumUpSkills()
		end
		skillTypeData:sumUpSkills()
	end			
	refreshSkillPointSum()
end

function CSPS.hbLinkToSkills(hbTables)
	for hbIndex, singleHotbarTable in pairs(hbTables) do
		for slotIndex, skillParams in pairs(singleHotbarTable) do
			local skillType, skillLine, skillIndex = unpack(skillParams)
			if #skillParams > 0 and (skillType ~= 1 or skillLine < 4) then
				local skillEntry = skillTable[skillType][skillLine][skillIndex]
				skillEntry.hb = skillEntry.hb or {}
				skillEntry.hb[hbIndex] = slotIndex
			end
		end
	end
end

function CSPS.refreshSkillSumsAndErrors()
	for skillType, typeData in ipairs(skillTable) do
		for skillLineIndex, lineData in ipairs(typeData) do
			for skillIndex, skillData in ipairs(lineData) do
				skillData:setPoints()
			end
			lineData:sumUpSkills()
		end
		typeData:sumUpSkills()
	end
	refreshSkillPointSum()
end

local function applySkillsGo(callAfterSkillChange)
	for skillType, typeData in ipairs(skillTable) do
		for skillLineIndex, lineData in ipairs(typeData) do
			if lineData.zo_data:IsActive() then
				for skillIndex, skillData in ipairs(lineData) do
					if skillData.purchased then
						skillData.zo_data:GetPointAllocator():Purchase()
						if skillData.passive then
							skillData.rank = skillData.rank or 0
							local j = skillData.zo_data:GetCurrentSkillProgressionKey() or 1
							while j < skillData.rank do
								skillData.zo_data:GetPointAllocator():IncreaseRank()
								j = j + 1
							end
						else
							skillData.zo_data:GetPointAllocator():Morph(skillData.morph)
						end
					end
				end
			end	
		end
	end	
	tryingToApplySkills = true
	zo_callLater(function() tryingToApplySkills = false CSPS.refreshSkillSumsAndErrors()  CSPS.refreshTree() if callAfterSkillChange then callAfterSkillChange() end end, 500)	
end

function CSPS.applySkills(skipDiag, callAfterSkillChange)
	if not CSPS.tabEx then return end
	refreshSkillPointSum()
	local sumConflicts = 0
	for i, v in pairs(skillTable.errorSums) do
		if i ~= ec.correct then sumConflicts = sumConflicts + v end
	end
	local myParameters =	{
		GetAvailableSkillPoints(), 
		skillTable.pointsToSpend, 
		sumConflicts, 
		skillTable.errorSums[ec.skillLocked], 
		skillTable.errorSums[ec.wrongMorph],
		skillTable.errorSums[ec.rankHigher],
		skillTable.errorSums[ec.rankLocked] + skillTable.errorSums[ec.morphLocked],
	}
	if not skipDiag or sumConflicts > 0 then
		ZO_Dialogs_ShowDialog(CSPS.name.."_OkCancelDiag", 
				{
					returnFunc = function() applySkillsGo(callAfterSkillChange) end,
				},
				{
					mainTextParams = {string.format(GS(CSPS_MSG_ConfirmApply), unpack(myParameters))}, 
					titleParams = {GS(CSPS_MyWindowTitle)}
				}
			)
	else
		applySkillsGo(callAfterSkillChange)
	end
end


function CSPS.hbEmpty(barIndex)
	CSPS.hbTables[barIndex] = CSPS.hbTables[barIndex] or {}
	for j=1, 6 do
		if CSPS.hbTables[barIndex][j] ~= nil then
			
			local skTyp, skLin, skId = unpack(CSPS.hbTables[barIndex][j])
			if not skTyp == 0 and skLin == 0 and skId == 0 then
				skillTable[skTyp][skLin][skId].hb[barIndex] = nil
			end
		end
	end
    CSPS.hbTables[barIndex] = {}
end


function CSPS.hbRead()
	local hotBarCats = {HOTBAR_CATEGORY_PRIMARY, HOTBAR_CATEGORY_BACKUP, HOTBAR_CATEGORY_WEREWOLF}
	
    for barIndex, barCategory in pairs(hotBarCats) do
		CSPS.hbEmpty(barIndex)
		
		local hbManager = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar(barCategory)
        for i = 1, 6 do
			local slotData = hbManager:GetSlotData(ACTION_BAR_FIRST_NORMAL_SLOT_INDEX + i)
            local skillData = slotData and slotData:GetPlayerSkillData()
			if skillData then 
				local skTyp, skLin, skId = skillData:GetIndices()
				CSPS.hbTables[barIndex][i] = {skTyp, skLin, skId} 
				skillTable[skTyp][skLin][skId].hb[barIndex] =  i
			end
		end
			
    end
end

function CSPS.hbApply()
	for i,v in pairs(CSPS.hbTables) do
		local hbCat = i < 3 and i-1 or HOTBAR_CATEGORY_WEREWOLF
		local hbManager = ACTION_BAR_ASSIGNMENT_MANAGER:GetHotbar(hbCat)
		for j, w in pairs(v) do
			local theSkillData = sdm:GetSkillDataByIndices(w[1], w[2],w[3])
			if theSkillData:IsPurchased() then hbManager:AssignSkillToSlot(j+2, theSkillData) end
		end
	end
end

function CSPS.hbPopulate()
	local function populateSingleBar(indBar, indCtr)
		local ctrBar = CSPSWindowFooter:GetNamedChild(string.format("Bar%s", indCtr))
		for ind2=1,6 do
			local ctrSkill = ctrBar:GetNamedChild(string.format("Icon%s", ind2))
			local ijk = CSPS.hbTables[indBar][ind2]
			if ijk ~= nil then
				local i, j, k = unpack(ijk)
				local skillEntry = skillTable[i][j][k]
				ctrSkill:SetTexture(skillEntry.morph == 0 and skillEntry.texture or skillEntry.morphTextures[skillEntry.morph])
				ctrSkill:SetColor(1,1,1)
			else 
				ctrSkill:SetTexture(nil)
				ctrSkill:SetColor(0.141,0.141,0.141)
			end
		end
	end
	if CSPS.werewolfMode then
		CSPSWindowFooterBar2:SetHidden(true)
		populateSingleBar(3, 1)
	else
		CSPSWindowFooterBar2:SetHidden(false)
		for ind1= 1, 2 do
			populateSingleBar(ind1, ind1)
		end
	end

end

EVENT_MANAGER:RegisterForEvent(CSPS.name.."SkillsUpdate", EVENT_SKILL_POINTS_CHANGED, 
	function(_, _, _, _, _, reason) 
		if #skillTable > 0 and not tryingToApplySkills then 
			local reasons = {[SKILL_POINT_CHANGE_REASON_PURCHASE] = true, [SKILL_POINT_CHANGE_REASON_SKILL_RESET] = true, [SKILL_POINT_CHANGE_REASON_SKILL_RESPEC] = true}
			--d("Reason: "..reason)
			if reasons[reason] then
				CSPS.refreshSkillSumsAndErrors() 
				CSPS.setMundus() -- refresh mundus box in case of armory reset
				if not CSPSWindow:IsHidden() then 
					CSPS.refreshTree() 
				end
			else
				refreshSkillPointSum()
			end
		end 
	end)