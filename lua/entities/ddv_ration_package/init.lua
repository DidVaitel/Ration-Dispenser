--[[
	Script: Ration Dispenser
	Version: 1.0
	Created by DidVaitel (http://steamcommunity.com/profiles/76561198108670811)
]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/weapons/w_package.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

 	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
end

function ENT:Use(activator, caller)

	local heatlhValue = math.Round(math.Rand(15,50))

	if (activator:Health() + heatlhValue) <= activator:GetMaxHealth() then
		activator:SetHealth(activator:Health() + heatlhValue)
	else
		activator:SetHealth(activator:GetMaxHealth())
	end

	self:Remove()
	activator:EmitSound("weapons/bugbait/bugbait_squeeze3.wav")
end