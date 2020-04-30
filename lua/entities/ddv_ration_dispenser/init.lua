--[[
	Script: Ration Dispenser
	Version: 1.0
	Created by DidVaitel (http://steamcommunity.com/profiles/76561198108670811)
]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local COLOR_RED, COLOR_ORANGE, COLOR_BLUE, COLOR_GREEN = 1, 2, 3, 4

function ENT:Initialize()

	self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl") // Reference model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	self:SetText(1)
	self:SetDisplayColor(COLOR_GREEN)
	self.canUse = true

	self.dummy = ents.Create("prop_dynamic")
	self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
	self.dummy:SetPos(self:LocalToWorld(Vector(-2,0,0)))
	self.dummy:SetAngles(self:GetAngles())
	self.dummy:SetParent(self)
	self.dummy:Spawn()
	self.dummy:DrawShadow(false)
	self.dummy:Activate()


	self:DeleteOnRemove(self.dummy)

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then

		physObj:EnableMotion(false)
		physObj:Sleep()

	end

end

function ENT:Use(activator)

	if (self.nextUse and self.nextUse >= CurTime()) then
		return
	end

	if (!self.canUse) then
		return
	end

	self:SetUseAllowed(false)
	self:SetText(3) // Checking
	self:SetDisplayColor(COLOR_BLUE)
	self:EmitSound("ambient/machines/combine_terminal_idle2.wav")

	timer.Simple(2, function()

		if (!IsValid(self)) then return end

		if IsValid(activator) then

			if (activator.nextUse and activator.nextUse > CurTime()) then
				return self:Error(6)
			else

				activator.nextUse = CurTime() + 30

				self:SetText(4)
				self:EmitSound("buttons/button14.wav", 100, 50)
				self:SetDisplayColor(COLOR_GREEN)

				timer.Simple(1.5, function()

					if (!IsValid(self)) then return end

					if IsValid(activator) then
						self:Dispense(1, activator)
					else
						self:SetUseAllowed(true)
					end

				end)

			end

		else

			self:SetUseAllowed(true)

		end

	end)

end

function ENT:SetUseAllowed(state)

	if state then

		self:SetText(1)
		self:SetDisplayColor(COLOR_GREEN)

	end

	self.canUse = state

end


function ENT:Error(text)

	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetText(text)
	self:SetDisplayColor(COLOR_RED)


	timer.Create("ddv_dispenser_error"..self:EntIndex(), 1.4, 1, function()

		if (IsValid(self)) then

			self:SetText(1)
			self:SetDisplayColor(COLOR_RED)

			timer.Simple(0.5, function()

				if (!IsValid(self)) then return end
				self:SetUseAllowed(true)

			end)

		end

	end)

end


function ENT:CreateRation(activator)

	local entity = ents.Create("prop_physics")
	entity:SetAngles(self:GetAngles())
	entity:SetModel("models/weapons/w_package.mdl")
	entity:SetPos(self:GetPos())
	entity:Spawn()
	entity:SetNotSolid(true)
	entity:SetParent(self.dummy)
	entity:Fire("SetParentAttachment", "package_attachment")

	timer.Simple(1.9, function()

		if (IsValid(self) and IsValid(entity)) then

			entity:Remove()

			local ration = ents.Create("ddv_ration_package")
			ration:SetAngles(entity:GetAngles())
			ration:SetPos(entity:GetPos())
			ration:Spawn()
			ration:Activate()
			ration:GetPhysicsObject():Wake()

		end

	end)

end



function ENT:Dispense(amount, activator)

	self:SetUseAllowed(false)
	self:SetText(7)
	self:SetDisplayColor(COLOR_BLUE)

	self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
	self:CreateRation(activator)
	self.dummy:Fire("SetAnimation", "dispense_package", 0)

	timer.Simple(3.5, function()

		if (!IsValid(self)) then return end

		self:SetText(2)
		self:SetDisplayColor(COLOR_ORANGE)
		self:EmitSound("buttons/combine_button7.wav")

		timer.Simple(8, function()

			if (!IsValid(self)) then return end

			self:SetText(1)
			self:SetDisplayColor(COLOR_GREEN)
			self:EmitSound("buttons/combine_button1.wav")

			timer.Simple(0.75, function()

				if (!IsValid(self)) then return end
				
				self:SetUseAllowed(true)

			end)

		end)

	end)

end
