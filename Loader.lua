local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

-----------------------------------------------------------------------
-- Generate our version variables
--

local ALPHA = "ALPHA"
local RELEASE = "RELEASE"
local UNKNOWN = "UNKNOWN"

do
	local L_RELEASE = L["You are running an official release of Big Wigs %s (revision %d)"]
	local L_ALPHA = L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"]
	local L_SOURCE = L["You are running a source checkout of Big Wigs %s directly from the repository."]
	local majorVersion = GetAddOnMetadata("BigWigs", "Version") or "3.?"

	-- START: MAGIC WOWACE VOODOO VERSION STUFF
	local releaseType = RELEASE
	local releaseRevision = nil
	local releaseString = nil
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- This will (in ZIPs), be replaced by the highest revision number in the source tree.
	releaseRevision = "@project-revision@"
	releaseRevision = tonumber(releaseRevision)

	-- If the releaseRevision ends up NOT being a number, it means we're running a SVN copy.
	-- In which case, we also have to set the releaseType to ALPHA manually.
	if type(releaseRevision) ~= "number" then
		releaseRevision = -1
		releaseType = ALPHA
	end

	-- Then build the release string, which we can add to the interface option panel.
	if releaseRevision == -1 then
		releaseString = L_SOURCE:format(majorVersion)
	elseif releaseType == RELEASE then
		releaseString = L_RELEASE:format(majorVersion, releaseRevision)
	elseif releaseType == ALPHA then
		releaseString = L_ALPHA:format(majorVersion, releaseRevision)
	end
	_G.BIGWIGS_RELEASE_TYPE = releaseType
	_G.BIGWIGS_RELEASE_REVISION = releaseRevision
	_G.BIGWIGS_RELEASE_STRING = releaseString
	-- END:   MAGIC WOWACE VOODOO VERSION STUFF
end

BigWigsLoader = LibStub("AceAddon-3.0"):NewAddon("BigWigsLoader", "AceEvent-3.0")
local loader = BigWigsLoader

local LOCALE = GetLocale()
if LOCALE == "enGB" then
	LOCALE = "enUS"
end
-- uncomment next line to debug Foreign Loading
-- LOCALE = "Foreignese"
loader.LOCALE = LOCALE

-----------------------------------------------------------------------
-- Locals
--

local ldb
local pName = UnitName("player")

local tooltipFunctions = {}

-- Grouping
local BWRAID = 2
local BWPARTY = 1
local grouped = nil

-- Version
local usersAlpha = {}
local usersRelease = {}
local usersUnknown = {}
local highestReleaseRevision = _G.BIGWIGS_RELEASE_REVISION

-- Loading
local loadOnZoneAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-Zone directive. Filled in OnInitialize, garbagecollected in OnEnable.
local BZ -- BabbleZone-3.0 lookup table, will only be used if the foreign language pack is loaded aka LBZ-3.0 and LBB-3.0
local BB -- BabbleBoss-3.0 lookup table, will only be used if the foreign language pack is loaded aka LBZ-3.0 and LBB-3.0
local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadOnZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnCoreLoaded = {} -- BigWigs modulepacks that should load when the core is loaded
-- XXX shouldn't really be named "menus", it's actually panels in interface options now
local menus = {} -- contains the main menus for BigWigs, once the core is loaded they will get injected
local enableZones = {} -- contains the zones in which BigWigs will enable

-----------------------------------------------------------------------
-- Utility
--

local getGroupMembers = nil
do
	local members = {}
	function getGroupMembers()
		local raid = GetRealNumRaidMembers()
		local party = GetRealNumPartyMembers()
		if raid == 0 and party == 0 then return end
		wipe(members)
		if raid > 0 then
			for i = 1, raid do
				local n = GetRaidRosterInfo(i)
				if n then members[#members + 1] = n end
			end
		elseif party > 0 then
			members[#members + 1] = UnitName("player")
			for i = 1, 4, 1 do
				local n = UnitName("party" .. i)
				if n then members[#members + 1] = n end
			end
		end
		return members
	end
end

local function loadZone(zone)
	if not zone then return end
	if loadOnZone[zone] then
		local addonsLoaded = {}
		for i, v in next, loadOnZone[zone] do
			if not IsAddOnLoaded(v) then
				LoadAddOn(v)
				loader:SendMessage("BigWigs_ModulePackLoaded", v)
			end
			tinsert(addonsLoaded, v)
			loadOnZone[zone][i] = nil
		end
		if #loadOnZone[zone] == 0 then
			loadOnZone[zone] = nil
		end

		-- Remove all already loaded addons from the loadOnZone table so that
		-- the "Load all" options for the zone menus that are affected by these
		-- addons are hidden.
		for i, addon in next, addonsLoaded do
			for k in pairs(loadOnZone) do
				for j, z in next, loadOnZone[k] do
					if z == addon or IsAddOnLoaded(z) then
						loadOnZone[k][j] = nil
					end
				end
				if #loadOnZone[k] == 0 then
					loadOnZone[k] = nil
				end
			end
			addonsLoaded[i] = nil
		end
		addonsLoaded = nil
	end
end

local function registerEnableZone(zone, groupsize)
	if BZ then zone = BZ[zone] or zone end
	-- only update enablezones if content is of lower level than before.
	-- if someone adds a party module to a zone that is already in the table as a raid, set the level of that zone to party
	if not enableZones[zone] or (enableZones[zone] and enableZones[zone] > groupsize) then
		enableZones[zone] = tonumber(groupsize) -- needs to be a number.
	end
end

local function iterateZones(addon, override, partyContent, ...)
	for i = 1, select("#", ...) do
		local zone = (select(i, ...)):trim()
		-- register the zone for enabling.
		registerEnableZone(zone, partyContent and BWPARTY or BWRAID)
		if BZ then zone = BZ[zone] or zone end
		
		if not loadOnZone[zone] then loadOnZone[zone] = {} end
		tinsert(loadOnZone[zone], addon)

		if override then
			tinsert(loadOnZone[override], addon)
		else
			menus[zone] = true
		end
	end
end

local function load(obj, name)
	if obj then return true end
	-- Verify that the addon isn't disabled
	local enabled = select(4, GetAddOnInfo(name))
	if not enabled then 
		print("Error loading " .. name .. " ("..name.." is not enabled)")
		return
	end
	-- Load the addon
	local succ, err = LoadAddOn(name)
	if not succ then
		print("Error loading " .. name .. " (" .. err .. ")")
		return false, err
	end
	return true
end

local function loadAddons(tbl)
	if not tbl then return end
	for i, addon in next, tbl do
		if not IsAddOnLoaded(addon) then LoadAddOn(addon) end
	end
	tbl = nil
end

-----------------------------------------------------------------------
-- Version listing functions
--

local function versionTooltipFunc(tt)
	local m = getGroupMembers()
	if not m then return end
	local add = nil
	for i, player in next, m do
		if usersRelease[player] then
			if usersRelease[player] < highestReleaseRevision then
				add = true
				break
			end
		elseif usersAlpha[player] then
			-- version == -1 means the user is using a svn checkout, and not a downloadable alpha zip
			-- we ignore svn users
			if usersAlpha[player] < (highestReleaseRevision - 1) and usersAlpha[player] ~= -1 then
				add = true
				break
			end
		else
			add = true
			break
		end
	end
	if add then
		tt:AddLine(L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."], 1, 0, 0, 1)
	end
end

function loader:OnInitialize()
	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then
				tinsert(loadOnCoreEnabled, name)
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreLoaded")
			if meta then
				tinsert(loadOnCoreLoaded, name)
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-Zone")
			if meta then
				tinsert(loadOnZoneAddons, name)
			end
		end
	end
	
	-- register for these messages OnInit so we receive these messages when the core and modules oninitialize fires
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_CoreLoaded")

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon then
		if not BigWigs3IconDB then BigWigs3IconDB = {} end
		icon:Register("BigWigs", ldb, BigWigs3IconDB)
	end
	self:RegisterTooltipInfo(versionTooltipFunc)
end

function loader:OnEnable()
	if LOCALE ~= "enUS" and (not BZ or not BB) then
		if not LibStub("LibBabble-Boss-3.0", true) or not LibStub("LibBabble-Zone-3.0", true) then
			load(false, "BigWigs_Foreign")
		end
		-- check again and error if you can't find
		if not LibStub("LibBabble-Zone-3.0", true) or not LibStub("LibBabble-Boss-3.0", true) then
			print("Error retrieving LibBabble-Zone-3.0 and LibBabble-Boss-3.0, please reinstall Big Wigs.")
		else
			BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
			BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
		end
	end
	
	if loadOnZoneAddons then
		-- From this point onward BZ and BB should be available for non-english locales
		for i, name in next, loadOnZoneAddons do
			local menu = GetAddOnMetadata(name, "X-BigWigs-Menu")
			if menu then
				if BZ then menu = BZ[menu] or menu end
				if not loadOnZone[menu] then loadOnZone[menu] = {} end
				menus[menu] = true
			end
			local partyContent = GetAddOnMetadata(name, "X-BigWigs-PartyContent")
			local meta = GetAddOnMetadata(name, "X-BigWigs-LoadOn-Zone")
			iterateZones(name, menu, partyContent, strsplit(",", meta))
		end
		loadOnZoneAddons = nil
	end

	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "CheckRoster")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "CheckRoster")
	
	self:RegisterEvent("CHAT_MSG_ADDON")
	
	self:RegisterMessage("BigWigs_JoinedGroup")
	self:RegisterMessage("BigWigs_LeftGroup")
	self:RegisterMessage("BigWigs_CoreEnabled")
	self:RegisterMessage("BigWigs_CoreDisabled")
	
	self:CheckRoster()
	self:ZoneChanged()
end

local warned = nil
local delayTransmitter = CreateFrame("Frame", nil, UIParent)
delayTransmitter:Hide()
delayTransmitter:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 5 then
		self:Hide()
		if BIGWIGS_RELEASE_TYPE == ALPHA then
			SendAddonMessage("BWVRA3", BIGWIGS_RELEASE_REVISION, "RAID")
		else
			SendAddonMessage("BWVR3", BIGWIGS_RELEASE_REVISION, "RAID")
		end
	end
end)

function loader:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if prefix == "BWVQ3" then
		-- send the unknown message, this person might have already sent their own version but the possible Version module can sort that out
		if not usersRelease[sender] and not usersAlpha[sender] then
			usersUnknown[sender] = true
		end
		--self:SendMessage("BigWigs_Version", sender, UNKNOWN)
		delayTransmitter.elapsed = 0
		delayTransmitter:Show()
	elseif prefix == "BWOOD3" then
		if not tonumber(message) or warned then return end
		if tonumber(message) > BIGWIGS_RELEASE_REVISION then
			warned = true
			print(L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."])
		end
	elseif prefix == "BWVR3" then
		message = tonumber(message)
		if not message then return end
		usersRelease[sender] = message
		usersAlpha[sender] = nil
		usersUnknown[sender] = nil
		if message > highestReleaseRevision then highestReleaseRevision = message end
		--self:SendMessage("BigWigs_Version", sender, RELEASE, message)
		if sender ~= pName and BIGWIGS_RELEASE_REVISION > message then
			-- The sender is running an old version.
			SendAddonMessage("BWOOD3", BIGWIGS_RELEASE_REVISION, "WHISPER", sender)
		end
	elseif prefix == "BWVRA3" then
		message = tonumber(message)
		if not message then return end
		usersAlpha[sender] = message
		usersRelease[sender] = nil
		usersUnknown[sender] = nil
		--self:SendMessage("BigWigs_Version", sender, ALPHA, message)
	end
end

function loader:RegisterTooltipInfo(func)
	for i, v in next, tooltipFunctions do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	tinsert(tooltipFunctions, func)
end

function loader:GetZoneMenus()
	return menus
end

function loader:HasZone(zone)
	if not zone then return false end
	if loadOnZone[zone] then return true end
	return false
end

function loader:LoadZone(zone)
	loadZone(zone)
end

function loader:ZoneChanged()
	if not grouped then return end
	local z1, z2 = GetRealZoneText(), GetZoneText()
	-- load party content in raid, but don't load raid content in a party...
	if (enableZones[z1] and enableZones[z1] <= grouped) or (enableZones[z2] and enableZones[z2] <= grouped) then
		if self:LoadCore() then
			if BigWigs:IsEnabled() and (loadOnZone[z1] or loadOnZone[z2]) then
				loadZone(z1)
				loadZone(z2)
			else
				BigWigs:Enable()
			end
		end
	end	
end

function loader:CheckRoster()
	local raid = GetRealNumRaidMembers()
	local party = GetRealNumPartyMembers()
	if not grouped and raid > 0 then
		grouped = BWRAID
		self:SendMessage("BigWigs_JoinedGroup", grouped)
	elseif not grouped and party > 0 then
		grouped = BWPARTY
		self:SendMessage("BigWigs_JoinedGroup", grouped)
	elseif grouped then
		if grouped == BWPARTY and raid > 0 then
			grouped = BWRAID
			self:SendMessage("BigWigs_JoinedGroup", grouped)
		elseif raid == 0 and party == 0 then
			grouped = nil
			self:SendMessage("BigWigs_LeftGroup")
		end
	end
end

function loader:BigWigs_BossModuleRegistered(message, name, module)
	registerEnableZone(module.zoneName, module.partyContent and BWPARTY or BWRAID)
end

function loader:BigWigs_CoreEnabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
	end

	loadAddons(loadOnCoreEnabled)

	-- core is enabled, unconditionally load the zones
	loadZone(GetRealZoneText())
	loadZone(GetZoneText())
end

function loader:BigWigs_CoreDisabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-disabled"
	end
end

function loader:BigWigs_CoreLoaded()
	loadAddons(loadOnCoreLoaded)
end

function loader:BigWigs_JoinedGroup()
	self:ZoneChanged()
	SendAddonMessage("BWVQ3", BIGWIGS_RELEASE_REVISION, "RAID")
end

function loader:BigWigs_LeftGroup()
	wipe(usersRelease)
	wipe(usersAlpha)
	wipe(usersUnknown)
	-- BigWigs might not have loaded yet, fringe case, but better prevent errors
	if BigWigs then
		BigWigs:Disable()
	end
end

function loader:LoadCore() return load(BigWigs, "BigWigs_Core") end
function loader:LoadOptions() return load(BigWigsOptions, "BigWigs_Options") end

ldb = LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs")

if not ldb then
	ldb = LibStub("LibDataBroker-1.1"):NewDataObject("BigWigs", {
		type = "launcher",
		label = "Big Wigs",
		icon = "Interface\\AddOns\\BigWigs\\Icons\\core-disabled",
	})
else
	ldb.label = "Big Wigs"
end

function ldb.OnClick(self, button)
	if BigWigs and BigWigs:IsEnabled() then
		if button == "RightButton" and loader:LoadOptions() then
			BigWigsOptions:Open()
		else
			if IsAltKeyDown() then
				if IsControlKeyDown() then
					BigWigs:Disable()
				else
					for name, module in BigWigs:IterateBossModules() do
						if module:IsEnabled() then module:Disable() end
					end
					BigWigs:Print(L["All running modules have been disabled."])
				end
			else
				for name, module in BigWigs:IterateBossModules() do
					if module:IsEnabled() then module:Reboot() end
				end
				BigWigs:Print(L["All running modules have been reset."])
			end
		end
	elseif BigWigs then
		BigWigs:Enable()
		if button == "RightButton" then
			if loader:LoadOptions() then
				BigWigsOptions:Open()
			end
		end
	elseif loader:LoadCore() then
		BigWigs:Enable()
		if button == "RightButton" then
			if loader:LoadOptions() then
				BigWigsOptions:Open()
			end
		end
	end
end

function ldb.OnTooltipShow(tt)
	tt:AddLine("Big Wigs")
	local h = nil
	if BigWigs and BigWigs:IsEnabled() then
		local added = nil
		for name, module in BigWigs:IterateBossModules() do
			if module:IsEnabled() then
				if not added then
					tt:AddLine(L["Active boss modules:"], 1, 1, 1)
					added = true
				end
				tt:AddLine(module.displayName)
			end
		end
		h = L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."]
	else
		tt:AddLine(L["Big Wigs is currently disabled."])
		h = L["|cffeda55fClick|r to enable."]
	end
	for i, v in next, tooltipFunctions do
		v(tt)
	end
	tt:AddLine(h, 0.2, 1, 0.2, 1)
end

local function slashfunction(text)
	if loader:LoadCore() and loader:LoadOptions() then
		BigWigsOptions:Open()
	end
end

hash_SlashCmdList['/bw'] = nil
hash_SlashCmdList['/bigwigs'] = nil
SLASH_BIGWIGS1 = "/bw"
SLASH_BIGWIGS2 = "/bigwigs"
SlashCmdList.BIGWIGS = slashfunction

do
	local hexColors = nil
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local class = select(2, UnitClass(key))
			if class then
				self[key] = hexColors[class]  .. key .. "|r"
			else
				self[key] = "|cffcccccc"..key.."|r"
			end
			return self[key]
		end
	})
	local function coloredNameVersion(name, version)
		if version == -1 then version = "svn" end
		return string.format("%s|cffcccccc(%s)|r", coloredNames[name], version or "unknown")
	end
	local function showVersions()
		local m = getGroupMembers()
		if not m then return end
		if not hexColors then
			hexColors = {}
			for k, v in pairs(RAID_CLASS_COLORS) do
				hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
			end
		end
		local good = {} -- highest release users
		local ugly = {} -- old version users
		local bad  = {} -- non-bw users
		for i, player in next, m do
			if usersRelease[player] then
				if usersRelease[player] < highestReleaseRevision then
					tinsert(ugly, coloredNameVersion(player, usersRelease[player]))
				else
					tinsert(good, coloredNameVersion(player, usersRelease[player]))
				end
			elseif usersUnknown[player] then
				tinsert(ugly, coloredNames[k])
			elseif usersAlpha[player] then
				-- release revision -1 because of tagging
				if usersAlpha[player] >= (highestReleaseRevision - 1) or usersAlpha[player] == -1 then
					tinsert(good, coloredNameVersion(player, usersAlpha[player]))
				else
					tinsert(ugly, coloredNameVersion(player, usersAlpha[player]))
				end
			else
				tinsert(bad, coloredNames[player])
			end
		end
		if #good > 0 then print(L["Up to date:"], table.concat(good, ", ")) end
		if #ugly > 0 then print(L["Out of date:"], table.concat(ugly, ", ")) end
		if #bad > 0 then print(L["No Big Wigs 3.x:"], table.concat(bad, ", ")) end
		good, bad, ugly = nil, nil, nil
	end

	SLASH_BIGWIGSVERSION1 = "/bwv"
	SlashCmdList.BIGWIGSVERSION = showVersions
end

-- interface options
local frame = CreateFrame("Frame", nil, UIParent)
frame.name = "Big Wigs"
frame:Hide()

frame:SetScript("OnShow", function(frame)
	for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
	if loader:LoadCore() then
		BigWigs:Enable()
		if loader:LoadOptions() then
			BigWigsOptions:Open()
		end
	end
end)

if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions("Big Wigs")
end
InterfaceOptions_AddCategory(frame)

function loader:RemoveInterfaceOptions()
	for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
end

