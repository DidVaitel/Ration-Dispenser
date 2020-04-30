--[[
	Script: Ration Dispenser
	Version: 1.0
	Created by DidVaitel (http://steamcommunity.com/profiles/76561198108670811)
]]

include("shared.lua")

local cam, render, surface, draw, math = cam, render, surface, draw, math
local COLOR_RED, COLOR_ORANGE, COLOR_BLUE, COLOR_GREEN = 1, 2, 3, 4

function ENT:Draw()

	local position, angles = self:GetPos(), self:GetAngles()


	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 270)


	cam.Start3D2D(position + self:GetForward()*5.6 + self:GetRight()*8.5 + self:GetUp()*3, angles, 0.1)

		render.PushFilterMin(TEXFILTER.NONE)
		render.PushFilterMag(TEXFILTER.NONE)

		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(0, 0, 66, 28)

		draw.SimpleText(self.DetailTable.text[self:GetText()] or "", "Default", 33, 0, Color(255, 255, 255, math.abs(math.cos(RealTime() * 1.5) * 255)), 1, 0)

		surface.SetDrawColor(self.DetailTable.colors[self:GetDisplayColor()] or color_white)
		surface.DrawRect(4, 14, 58, 10)

		surface.SetDrawColor(60, 60, 60)
		surface.DrawOutlinedRect(4, 14, 58, 10)

		render.PopFilterMin()
		render.PopFilterMag()

	cam.End3D2D()

end