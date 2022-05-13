file.CreateDir("crossair_hestiarp")

local function drawCrosshair()
        CrosshairHestiaRp = CrosshairHestiaRp or {} 
        CrosshairHestiaRp.couleur = file.Read("crossair_hestiarp/couleur.txt", "DATA") or {r=149,b=108,a=255,g=108,}
        CrosshairHestiaRp.actif = file.Read("crossair_hestiarp/actif.txt", "DATA") or true
    if CrosshairHestiaRp.actif then
        local circle_rad = 7
        draw.RoundedBox( 50, ScrW()/2-(circle_rad/2), ScrH()/2-(circle_rad/2), circle_rad, circle_rad, Color(255,255,255))
    end
end
drawCrosshair()
------------
hook.Add( "HUDPaint", "crosshairHestia", function()
    drawCrosshair()
end )

hook.Add( "OnContextMenuOpen", "Pannel_crosshairHestiaOpen", function()

        Frame_Crosshair = vgui.Create("DFrame")
        Frame_Crosshair:SetSize(200, 180)
        Frame_Crosshair:Center()
        Frame_Crosshair:SetBGColor(Color(0,0,0))
        Frame_Crosshair:SetTitle("Options Crosshair")
        Frame_Crosshair:SetDraggable(true)
        Frame_Crosshair:ShowCloseButton(true)
        Frame_Crosshair:MakePopup()
        Frame_Crosshair:SetScreenLock(true)
        Frame_Crosshair.Paint = function()
            surface.SetDrawColor(Color(40, 40, 40))
            surface.DrawRect( 0, 0, Frame_Crosshair:GetWide(), Frame_Crosshair:GetTall() )
        end
    local Panel_Crosshair = vgui.Create( "DPanel", Frame_Crosshair)
        Panel_Crosshair:SetSize(180, 140)
        Panel_Crosshair:SetPos( 10, 30 )
        Panel_Crosshair.Paint = function()
            surface.SetDrawColor(Color(65, 65, 65))
            surface.DrawRect( 0, 0, Panel_Crosshair:GetWide(), Panel_Crosshair:GetTall() )
        end
    local CB_Activer = vgui.Create("DCheckBoxLabel", Panel_Crosshair)
        CB_Activer:SetPos( 5, 5 )
        CB_Activer:SetText("Activer le Pointeur")
        CB_Activer:SetChecked(CrosshairHestiaRp.actif)
        function CB_Activer.OnChange()
            file.Write("crossair_hestiarp/actif.txt", tostring(CB_Activer:GetChecked()))
        end
    local ColorM_Crosshair = vgui.Create("DColorMixer", Panel_Crosshair)
        ColorM_Crosshair:SetSize(160, 100)
        ColorM_Crosshair:SetPos( 5, 30 )
        ColorM_Crosshair:SetLabel("Couleur du Pointeur")
        ColorM_Crosshair.label:SetDark(false)
        ColorM_Crosshair:SetColor(Color(255,255,255))	
        ColorM_Crosshair:SetPalette(false)
        ColorM_Crosshair:SetAlphaBar(false)
        ColorM_Crosshair:SetWangs(true)
        ColorM_Crosshair:SetColor(CrosshairHestiaRp.couleur)
        function ColorM_Crosshair.ValueChanged()
            local couleur = {a = 255, r = ColorM_Crosshair:GetColor()["r"], g = ColorM_Crosshair:GetColor()["g"], b = ColorM_Crosshair:GetColor()["b"]}
            file.Write("crossair_hestiarp/couleur.txt", table.ToString(couleur))
            drawCrosshair()
        end
end)

hook.Add( "OnContextMenuClose", "Pannel_crosshairHestiaClose", function()
    Frame_Crosshair:Close()
end)



