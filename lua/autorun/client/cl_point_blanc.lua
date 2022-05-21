file.CreateDir("crossair_hestiarp")
file.CreateDir("crossair_hestiarp/couleur")

function drawCrosshair()
        
        CrosshairHestiaRp = CrosshairHestiaRp or {} 
            tempCouleur = {
                r=file.Read("crossair_hestiarp/couleur/r.txt", "DATA"), 
                g=file.Read("crossair_hestiarp/couleur/g.txt", "DATA"), 
                b=file.Read("crossair_hestiarp/couleur/b.txt", "DATA"), 
                a=file.Read("crossair_hestiarp/couleur/a.txt", "DATA"),
            }
            if countTable(tempCouleur) == 4 then
                CrosshairHestiaRp.couleur = tempCouleur
            else
                CrosshairHestiaRp.couleur = {r=149,g=108,b=108,a=255,}
            end
            CrosshairHestiaRp.taille = file.Read("crossair_hestiarp/taille.txt", "DATA") or 7
            CrosshairHestiaRp.actif = file.Read("crossair_hestiarp/actif.txt", "DATA") or false

        if CrosshairHestiaRp.actif == "true" then
            local circle_rad = CrosshairHestiaRp.taille
            draw.RoundedBox( 50, ScrW()/2-(circle_rad/2+0.5), ScrH()/2-(circle_rad/2-0.5), circle_rad, circle_rad, CrosshairHestiaRp.couleur)
        end
end

function countTable(liste)
    taille = 0
    for _ in pairs(liste) do taille = taille + 1 end
    return taille
end
------------

hook.Add( "HUDPaint", "crosshairHestia", function()
    drawCrosshair()
end )

hook.Add( "OnContextMenuOpen", "Pannel_crosshairHestiaOpen", function()

        Frame_Crosshair = vgui.Create("DFrame")
        Frame_Crosshair:SetSize(200, 200)
        Frame_Crosshair:AlignTop(50)
        Frame_Crosshair:CenterHorizontal()
        Frame_Crosshair:SetBGColor(Color(0,0,0))
        Frame_Crosshair:SetTitle("Options Pointeur")
        Frame_Crosshair:SetDraggable(true)
        Frame_Crosshair:ShowCloseButton(false)
        Frame_Crosshair:MakePopup()
        Frame_Crosshair:SetScreenLock(true)
        Frame_Crosshair.Paint = function()
            surface.SetDrawColor(Color(40, 40, 40))
            surface.DrawRect( 0, 0, Frame_Crosshair:GetWide(), Frame_Crosshair:GetTall() )
        end
    local Panel_Crosshair = vgui.Create( "DPanel", Frame_Crosshair)
        Panel_Crosshair:SetSize(180, 160)
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
        ColorM_Crosshair:SetPos( 5, 30 )
        ColorM_Crosshair:SetSize(160, 100)
        ColorM_Crosshair:SetColor(CrosshairHestiaRp.couleur)
        ColorM_Crosshair:SetLabel("Couleur du Pointeur")
        ColorM_Crosshair.label:SetDark(false)	
        ColorM_Crosshair:SetPalette(false)
        ColorM_Crosshair:SetAlphaBar(false)
        ColorM_Crosshair:SetWangs(true)
        function ColorM_Crosshair.ValueChanged()
            drawCrosshair()
            Couleur = ColorM_Crosshair:GetColor()
            file.Write("crossair_hestiarp/couleur/r.txt", tostring(Couleur["r"]))
            file.Write("crossair_hestiarp/couleur/g.txt", tostring(Couleur["g"]))
            file.Write("crossair_hestiarp/couleur/b.txt", tostring(Couleur["b"]))
            file.Write("crossair_hestiarp/couleur/a.txt", tostring(Couleur["a"]))
        end
    local Slider_Crosshair = vgui.Create( "DNumSlider", Panel_Crosshair )
        Slider_Crosshair:SetPos( 5, 95 )			
        Slider_Crosshair:SetSize( 200, 100 )			
        Slider_Crosshair:SetText( "Taille Pointeur" )	
        Slider_Crosshair:SetMinMax( 2, 15 )
        Slider_Crosshair:SetValue(CrosshairHestiaRp.taille)				
        Slider_Crosshair:SetDecimals( 0 )				
        function Slider_Crosshair.OnValueChanged()
            file.Write("crossair_hestiarp/taille.txt", tostring(Slider_Crosshair:GetValue()))
            drawCrosshair()
        end
end)

hook.Add( "OnContextMenuClose", "Pannel_crosshairHestiaClose", function()
    Frame_Crosshair:Close()
end)

drawCrosshair()