MsgN("[SimpleThirdPerson] Addon successfully loaded.")


   --     DECLERATIONS


local scrw, scrh = ScrW(), ScrH()
local bThirdPerson = false
local bReadData = false
local thirdperson = {}


       -- VGUI - STUFF, just made it simple because im the laziest guy in the world


local function drawMenu()
    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle( "Thirdperson Settings" )
    Frame:SetSize( scrw * 0.2, scrh * 0.2 )
    Frame:Center()
    Frame:MakePopup()
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 255 ) )
    end

    local FovSlider = vgui.Create( "DNumSlider", Frame )
    FovSlider:SetPos( Frame:GetWide() * 0.15, Frame:GetTall() * 0.1 )
    FovSlider:SetSize( Frame:GetWide() * 0.6, Frame:GetTall() * 0.2 )
    FovSlider:SetText( "Camera Fov" )
    FovSlider:SetMin( 1 )
    FovSlider:SetMax( 50 )
    FovSlider:SetDecimals( 0 )
    FovSlider:SetValue(thirdperson.fov)

    FovSlider.OnValueChanged = function( self, value )
        thirdperson.fov = math.floor(value)
    end

    local ForwardSlider = vgui.Create( "DNumSlider", Frame )
    ForwardSlider:SetPos( Frame:GetWide() * 0.15, Frame:GetTall() * 0.25  )
    ForwardSlider:SetSize( Frame:GetWide() * 0.6, Frame:GetTall() * 0.2)
    ForwardSlider:SetText( "Camera Forward/Backwards" )
    ForwardSlider:SetMin( -250 )
    ForwardSlider:SetMax( 250 )
    ForwardSlider:SetDecimals( 0 )
    ForwardSlider:SetValue(thirdperson.forward)

    ForwardSlider.OnValueChanged = function( self, value )
        thirdperson.forward = math.floor(value)
    end

    local UpSlider = vgui.Create( "DNumSlider", Frame )
    UpSlider:SetPos( Frame:GetWide() * 0.15, Frame:GetTall() * 0.4  )
    UpSlider:SetSize( Frame:GetWide() * 0.6, Frame:GetTall() * 0.2)
    UpSlider:SetText( "Camera Down/Up" )
    UpSlider:SetMin( -250 )
    UpSlider:SetMax( 250 )
    UpSlider:SetDecimals( 0 )
    UpSlider:SetValue(thirdperson.up)

    UpSlider.OnValueChanged = function( self, value )
        thirdperson.up = math.floor(value)
    end

    local RightSlider = vgui.Create( "DNumSlider", Frame )
    RightSlider:SetPos( Frame:GetWide() * 0.15, Frame:GetTall() * 0.55  )
    RightSlider:SetSize( Frame:GetWide() * 0.6, Frame:GetTall() * 0.2)
    RightSlider:SetText( "Camera Left/Right" )
    RightSlider:SetMin( -250 )
    RightSlider:SetMax( 250 )
    RightSlider:SetDecimals( 0 )
    RightSlider:SetValue(thirdperson.right)

    RightSlider.OnValueChanged = function( self, value )
        thirdperson.right = math.floor(value)
    end

    local Binder = vgui.Create("DBinder", Frame)

    if (thirdperson.key != nil) then
        Binder:SetText( "Bound to: " .. input.GetKeyName(thirdperson.key) )
    else
        Binder:SetText( "Bound to: NOT BOUND YET!" )
    end

    Binder:SetTextColor( Color(255,255,255) )
    Binder:Dock(BOTTOM)
    Binder:DockMargin( 50, 0, 50, 10)
    Binder:SetSize( Frame:GetWide() * 0.2, Frame:GetTall() * 0.1)
    Binder.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
    end

    function Binder:OnChange( num )
        thirdperson.key = num
    end

    local saveButton = vgui.Create("DButton", Frame)
    saveButton:SetTextColor( Color(255,255,255) )
    saveButton:SetText("Save Settings!")
    saveButton:Dock(BOTTOM)
    saveButton:DockMargin( 150, 0, 150, 10)
    saveButton:SetSize( Frame:GetWide() * 0.2, Frame:GetTall() * 0.1)
    saveButton.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
    end

    saveButton.DoClick = function()
        file.Write("simplethirdperson/" .. LocalPlayer():SteamID64() .. ".txt", util.TableToJSON(thirdperson, true))
    end

end

 --[[
        HOOKS
--]]

hook.Add("OnPlayerChat", "ThirdPersonCommand", function( ply, strText, bTeam, bDead)
    if (ply != LocalPlayer() or !IsValid(ply)) then end

    if (string.lower(strText) == "!thirdmenu") then
        drawMenu()
    end

end)

hook.Add( "CalcView", "CameraOverride", function( ply, pos, angles, fov )

    if (bThirdPerson) then
        local view = {}
        view.origin = pos - (( angles:Forward() * thirdperson.forward) - ( angles:Up() * thirdperson.up) - (angles:Right() * thirdperson.right))
        view.angles = angles
        view.fov = fov + thirdperson.fov
        view.drawviewer = true
        return view
    else
        local view = {}
        view.origin = pos
        view.angles = angles
        view.fov = fov
        view.drawviewer = false
        return view
    end

end)

hook.Add( "PlayerButtonDown", "PlayerInputCheck", function( ply, button )
    if button != thirdperson.key then return end

    if CLIENT and !IsFirstTimePredicted() then
        return
    end

    if (!bThirdPerson) then
        bThirdPerson = !bThirdPerson
    else
        bThirdPerson = !bThirdPerson
    end

end)

hook.Add( "InitPostEntity", "Ready", function()

    if (!file.Exists("simplethirdperson", "DATA")) then
        file.CreateDir("simplethirdperson")
    end

    if (!file.Exists("simplethirdperson/" .. LocalPlayer():SteamID64() .. ".txt", "DATA")) then
        thirdperson.fov = 1
        thirdperson.angles = 1
        thirdperson.forward = 100
        thirdperson.up = 0
        thirdperson.right = 0
        thirdperson.key = KEY_T
    else
        local savedsettings = util.JSONToTable(file.Read("simplethirdperson/" .. LocalPlayer():SteamID64() .. ".txt", "DATA"))
        bReadData = true
        thirdperson.fov = savedsettings.fov
        thirdperson.angles = savedsettings.angles
        thirdperson.key = savedsettings.key
        thirdperson.forward = savedsettings.forward
        thirdperson.up = savedsettings.up
        thirdperson.right = savedsettings.right
    end

end )
