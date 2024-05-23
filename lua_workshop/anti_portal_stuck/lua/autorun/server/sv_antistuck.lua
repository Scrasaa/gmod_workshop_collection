local function SetupMapLua()
	local MapLua = ents.Create( "lua_run" )
	MapLua:SetName( "triggerhook" )
	MapLua:Spawn()

	for _, v in ipairs( ents.FindByClass( "trigger_teleport" ) ) do
		v:Fire( "AddOutput", "OnStartTouch triggerhook:RunPassedCode:hook.Run( 'OnTeleport' ):0:-1" )
	end
end

function ActivateNoCollision(target, min)

	local oldCollision = COLLISION_GROUP_PLAYER
	target:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR) -- Players can walk through target

	if (min and (tonumber(min) > 0)) then 

		timer.Simple(min, function() --after 'min' seconds
			timer.Create(target:SteamID64().."_checkBounds_cycle", 0.5, 0, function() -- check every half second
				local penetrating = ( target:GetPhysicsObject() and target:GetPhysicsObject():IsPenetrating() ) or false --if we are penetrating an object
				local tooNearPlayer = false --or inside a player's hitbox
				for i, ply in ipairs( player.GetAll() ) do
					if target:GetPos():DistToSqr(ply:GetPos()) <= (80*80) then
						tooNearPlayer = true
					end
				end
				if not (penetrating and tooNearPlayer) then --if both false then 
					target:SetCollisionGroup(oldCollision) -- Stop no-colliding by returning the original collision group (or default player collision)
					timer.Destroy(target:SteamID64().."_checkBounds_cycle")
				end
			end)
		end)
	else
        target:SetCollisionGroup(oldCollision)
	end
end

hook.Add( "InitPostEntity", "SetupMapLua", SetupMapLua )
hook.Add( "PostCleanupMap", "SetupMapLua", SetupMapLua )
hook.Add( "OnTeleport", "AntiStuckHook", function()
	local activator, caller = ACTIVATOR, CALLER
	ActivateNoCollision(activator, 7)
end )

