--[[
	Script: Ration Dispenser
	Version: 1.0
	Created by DidVaitel (http://steamcommunity.com/profiles/76561198108670811)
]]

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Ration Dispenser"
ENT.Author = "DidVaitel"
ENT.Contact = "contact@poorpixel.eu"
ENT.Purpose = "Dispense ration packages"
ENT.Category = "DidVaitel Entities"

ENT.Spawnable = true
ENT.AdminOnly = false

local COLOR_RED, COLOR_ORANGE, COLOR_BLUE, COLOR_GREEN = 1, 2, 3, 4

ENT.DetailTable = {
	text = {[1] = "WAITING", [2] = "CHARGING", [3] = "CHECKING", [4] = "SUCCESSFULL", [5] = 'ERROR', [6] = "LIMIT", [7] = "DISPENSING"},
	colors = {
		[COLOR_RED] = Color(255, 50, 50),
		[COLOR_ORANGE] = Color(255, 80, 20),
		[COLOR_BLUE] = Color(50, 80, 230),
		[COLOR_GREEN] = Color(50, 240, 50)
	}
}

function ENT:SetupDataTables()

	self:NetworkVar("Int", 0, "DisplayColor")
	self:NetworkVar("Int", 1, "Text")

end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 22
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end