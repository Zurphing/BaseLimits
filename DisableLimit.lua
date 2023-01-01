LUAGUI_NAME = 'Limits on Base Sora'
LUAGUI_AUTH = 'Zurph'
LUAGUI_DESC = 'Required LUA script for this mod, to prevent crashes in certain instances.'

local canExecute = false

function _OnInit()
	if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
		ConsolePrint("Companion LUA Script to the Limit mod that prevents crashes. Press F1 to reload the script if Limits are unexpectedly disabled.")
		canExecute = true
		offset = 0x56454E
		Save = 0x09A70B0 - offset --SaveFile Anchor
		sysbin = 0x2A59DF0 - offset --Sysbin Anchor
		Ragnarok = sysbin+0x7BF6
		Sonic = sysbin+0x7D16
		Ars = sysbin+0x7DA6
		Raid = sysbin+0x7E36
		FormCheck = Save+0x3524
		--FormCheck2 = 0x0446086
		Inventory = 0x9A70B0 - offset
		CurrentSummon = 0x9AA5D5 - offset
		CommandMenuCheck = 0x2A0E06A-offset
		--Save = 0x09A70B0 - offset
		SVE = Save+0x11080
		SVE2 = Save+0x11080
		--SVE = 0x9B8130 - offset
		--SVE2 = 0x9B8130 - offset
		SVE3 = 0x444861 -- This is 0x9A8D6F. SVE is normally 0x09A7070. 0x09A7070-0x9A8D6F = 0x1CFF. So, SVE+0x1CFF. Offset for checking
		STTCheck = Save+0x1CFF
		LimitCheck()
	else
		ConsolePrint("Installation Failed.")
	end
end


function _OnFrame()
--SVE = ReadString(0x9B8130 - offset, 4) --Read a string up to 4 characters in length. Need this to remove limits from Carpet Sora.
--SVE2 = ReadString(0x9B8130 - offset, 2) --Read a string up to 2 characters in length. Need this to remove limits from Lion Sora.
	if ReadShort(CommandMenuCheck) == 316 and ReadShort(Ragnarok) ~= 0 or ReadString(SVE, 4) == "al14" and ReadShort(Ragnarok) ~= 0 or ReadString(SVE, 4) == "al05" and ReadShort(Ragnarok) ~= 0 or ReadString(SVE2, 2) == "lk" and ReadShort(Ragnarok) ~= 0 or ReadByte(FormCheck) ~= 0 and ReadByte(FormCheck) ~= 3 and ReadShort(Ragnarok) ~= 0 or ReadByte(STTCheck) == 13 and ReadByte(FormCheck) ~= 3 and ReadShort(Ragnarok) ~= 0 then
		ConsolePrint("DEBUG: Crash case detected, disabling")
		WriteShort(Ragnarok, 0)
		WriteShort(Sonic, 0)
		WriteShort(Ars, 0)
		WriteShort(Raid, 0)
		--Conditions to disable: If Summon was used, or if carpet detected, or if pride lands detected, or if detected in another form besides limit and base, or if in STT and in a form thats not limit.
	elseif ReadShort(CommandMenuCheck) ~= 316 and ReadShort(Ragnarok) ~= 707 and ReadString(SVE, 4) ~= "al14" and ReadString(SVE,4) ~= "al05" and ReadString(SVE2, 2) ~= "lk" and ReadByte(FormCheck) == 0 and ReadByte(STTCheck) ~= 13 or ReadShort(CommandMenuCheck) ~= 316 and ReadShort(Ragnarok) ~= 707 and ReadByte(FormCheck) == 3 and ReadByte(STTCheck) ~= 13 or ReadByte(FormCheck) == 3 and ReadByte(STTCheck) == 13 and ReadShort(Ragnarok) ~= 707 then --and ReadByte(STTCheck) == 13 and ReadShort(Ragnarok) ~= 707 then
		ConsolePrint("DEBUG: Setting back to normal")
		WriteShort(Ragnarok, 707)
		WriteShort(Sonic, 707)
		WriteShort(Ars, 707)
		WriteShort(Raid, 707)
		--Conditions to re-enable: Must meet ALL of these conditions; Summon is not out, Not on carpet or in pridelands, are in base-form, and are NOT in STT. A 2nd check is also run. That you are in Limit Form, that your command menu is NOT detecting a summon, and that you are not in STT. One final check; That you're in STT, in Limit Form, and in 
	end
	if ReadByte(Inventory+0x3607) ~= 1 then
		ConsolePrint("DEBUG: Set Limits to 1")
		WriteByte(Inventory+0x3607, 1)
		WriteByte(Inventory+0x3608, 1)
		WriteByte(Inventory+0x3609, 1)
		WriteByte(Inventory+0x360A, 1)
	end
end

function LimitCheck()

if ReadShort(Ragnarok) ~= 707 then
	ConsolePrint("Limits are disabled!")
elseif ReadShort(Ragnarok) == 707 then
	ConsolePrint("Limits are enabled!")
end

if ReadShort(Ragnarok) == 0 and ReadByte(FormCheck) == 0 then
	WriteShort(Ragnarok, 707)
	WriteShort(Sonic, 707)
	WriteShort(Ars, 707)
	WriteShort(Raid, 707)
end
end