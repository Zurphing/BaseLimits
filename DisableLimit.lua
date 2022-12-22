LUAGUI_NAME = 'Limits on Base Sora'
LUAGUI_AUTH = 'Zurph'
LUAGUI_DESC = 'Required LUA script for this mod, to prevent crashes in certain instances.'

local canExecute = false

function _OnInit()
	if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
		ConsolePrint("Companion LUA Script to the Limit mod that prevents crashes")
		canExecute = true
		offset = 0x56454E
		sysbin = 0x2A59DF0 - offset
		Ragnarok = sysbin+0x7BF6
		Sonic = sysbin+0x7D16
		Ars = sysbin+0x7DA6
		Raid = sysbin+0x7E36
		FormCheck = 0x0446086
	else
		ConsolePrint("Installation Failed.")
	end
end


function _OnFrame()
CurrentSummon = 0x9AA5D5 - offset
CommandMenuCheck = 0x2A0E06A-offset
SVE = ReadString(0x9B8130 - offset, 4) --Read a string up to 4 characters in length. Need this to remove limits from Carpet Sora.
SVE2 = ReadString(0x9B8130 - offset, 2) --Read a string up to 2 characters in length. Need this to remove limits from Lion Sora.
	if ReadShort(CommandMenuCheck) == 316 and ReadShort(Ragnarok) ~= 0 or SVE == "al14" and ReadShort(Ragnarok) ~= 0 or SVE == "al05" and ReadShort(Ragnarok) ~= 0 or SVE2 == "lk" and ReadShort(Ragnarok) ~= 0 or ReadByte(FormCheck) ~= 0 and ReadByte(FormCheck) ~= 3 and ReadShort(Ragnarok) ~= 0 then
		ConsolePrint("DEBUG: Crash case detected, disabling")
		WriteShort(Ragnarok, 0)
		WriteShort(Sonic, 0)
		WriteShort(Ars, 0)
		WriteShort(Raid, 0)
	end
	if ReadShort(CommandMenuCheck) == 72 and ReadShort(Ragnarok) ~= 707 and SVE ~= "al14" and SVE ~= "al05" and SVE2 ~= "lk" and ReadByte(FormCheck) == 0 or ReadShort(CommandMenuCheck) == 72 and ReadShort(Ragnarok) ~= 707 and SVE ~= "al14" and SVE ~= "al05" and SVE2 ~= "lk" and ReadByte(FormCheck) == 3 then
		ConsolePrint("DEBUG: Setting back to normal")
		WriteShort(Ragnarok, 707)
		WriteShort(Sonic, 707)
		WriteShort(Ars, 707)
		WriteShort(Raid, 707)
	end
	WriteShort(Ragnarok, 707)
	WriteShort(Sonic, 707)
	WriteShort(Ars, 707)
	WriteShort(Raid, 707)
end