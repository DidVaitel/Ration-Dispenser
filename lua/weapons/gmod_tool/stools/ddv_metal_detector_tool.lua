--[[
	Script: Metal Detector
	Version: 1.0
	Created by DidVaitel (http://steamcommunity.com/profiles/76561198108670811)
]]

TOOL.Category		= "DidVaitel Tools"
TOOL.Name			= "Metal Detector Creator"

if CLIENT then
	language.Add( "Tool.ddv_metal_detector_tool.name", "Metal Detector Creator" );
	language.Add( "Tool.ddv_metal_detector_tool.desc", "Allows you to easily configure the metal detector configuration" );
	language.Add( "Tool.ddv_metal_detector_tool.0", "Left click to spawn detector. Right click on detector to edit his data." );
end

if SERVER then 
	util.AddNetworkString("Metal_Detector.SetWeaponsTable")
end


function TOOL:LeftClick( tr )

	if SERVER then

		net.Receive("Metal_Detector.SetWeaponsTable", function( Lenght, Player )

			if ( !Player:IsSuperAdmin() ) then return end
			
			Player.IllegalWeapons = net.ReadTable()

		end)

		local SpawnPos = tr.HitPos + tr.HitNormal * 65
		local SpawnAng = self:GetOwner():EyeAngles()
		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180

		local ent = ents.Create( "ddv_metal_detector" )
		ent:SetPos( SpawnPos )
		ent:SetAngles( SpawnAng )
		ent:Spawn()
		ent:Activate()
		ent.IllegalWeapons = self:GetOwner().IllegalWeapons

		undo.Create( "SENT" )
			undo.SetPlayer( self:GetOwner() )
			undo.AddEntity( ent )
			undo.SetCustomUndoText( "Undone Metal Detector" )
		undo.Finish( "Scripted Entity (Metal Detector)" )

		return true

	end



 	return true

end

function TOOL:RightClick( Trace )

	if SERVER then

		if ( Trace.Entity and Trace.Entity:GetClass() == "ddv_metal_detector" ) then
			Trace.Entity.IllegalWeapons = self:GetOwner().IllegalWeapons
		end

		return true

	end

 	return true

end

function TOOL:Think()

	if ( !self:GetOwner().WeaponsTable ) then
		self:GetOwner().WeaponsTable = {}
	end

	if ( CLIENT ) then
		if ( !LocalPlayer().WeaponsTable ) then
			LocalPlayer().WeaponsTable = {}
		end
	end

end

if ( CLIENT ) then

	function TOOL.BuildCPanel( CPanel )

		CPanel:AddControl( "Header", { Description	= [[Illegal Weapons. Each illegal weapon will be detected!]]})

		local Listbox = CPanel:AddControl( "listbox", { Label = "Legal Weapons", Height = 250  } )
		local ListboxSelected = CPanel:AddControl( "listbox", { Label = "Illegal Weapons", Height = 250  } )

		for k,v in pairs( list.Get( "Weapon" ) ) do
			Listbox:AddLine(v.ClassName)
		end

		ListboxSelected.OnRowSelected = function( List, Index, Panel )
			Listbox:AddLine( Panel:GetColumnText( 1 ) )
			ListboxSelected:RemoveLine( Index )

			table.RemoveByValue( LocalPlayer().WeaponsTable, Panel:GetColumnText( 1 ) )

			net.Start("Metal_Detector.SetWeaponsTable")
				net.WriteTable( LocalPlayer().WeaponsTable )
			net.SendToServer()	
		end

		Listbox.OnRowSelected = function( List, Index, Panel )
			ListboxSelected:AddLine( Panel:GetColumnText( 1 ) )
			Listbox:RemoveLine( Index )

			table.insert( LocalPlayer().WeaponsTable, Panel:GetColumnText( 1 ) )

			net.Start("Metal_Detector.SetWeaponsTable")
				net.WriteTable( LocalPlayer().WeaponsTable )
			net.SendToServer()	
		end

	end

end