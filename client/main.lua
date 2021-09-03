ESX = nil
searching  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local place = { 
	-- Wash money
    {x = 1136.69,y = -992.00,z = 45.21},
	{x = 1136.09,y = -988.05,z = 45.21}
}

local token = {
	-- Buy tokens
    {x = 1132.90,y = -990.96,z = 45.21}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(place) do
            DrawMarker(27, place[k].x, place[k].y, place[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 0, 255, 50, 200, 0, 0, 0, 0)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(token) do
            DrawMarker(27, token[k].x, token[k].y, token[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 0, 255, 150, 200, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(place) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local placedist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, place[k].x, place[k].y, place[k].z)

            if placedist <= 1.5 then
			
				drawText3D(place[k].x, place[k].y, place[k].z + 0.8, '[~g~E~s~] to use~b~ Laundry~s~')
				
				if IsControlJustPressed(0, 38) then -- "E"
				
					TriggerServerEvent('esx_blackmoney:checkToken')
				end			
            end
        end
    end
end)

RegisterNetEvent('esx_blackmoney:success')
AddEventHandler('esx_blackmoney:success', function (source)	
ESX.ShowNotification('1 Small Load Token = $1000!')
		playerPed = PlayerPedId()
		SetEntityHeading(playerPed, 97.37)
		searching  = true		
		exports.rprogress:Custom({
								Async = true,
								x = 0.5,
								y = 0.5,
								From = 0,
								To = 100,
								Duration = 5000,
								Radius = 60,
								Stroke = 10,
								MaxAngle = 360,
								Rotation = 0,
								Easing = "easeLinear",
								Label = "WASHING",
								LabelPosition = "right",
								Color = "rgba(255, 255, 255, 1.0)",
								BGColor = "rgba(107, 109, 110, 0.95)",
								Animation = {
								--scenario = "CODE_HUMAN_MEDIC_TEND_TO_DEAD", -- https://pastebin.com/6mrYTdQv
								animationDictionary = "amb@prop_human_parking_meter@male@idle_a", -- https://alexguirre.github.io/animations-list/
								animationName = "idle_a",
								},
								DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true
								},
								})
				Citizen.Wait(5000)
				searching  = false
		TriggerServerEvent('esx_blackmoney:washMoney')	
		
end)

RegisterNetEvent('esx_blackmoney:success2')
AddEventHandler('esx_blackmoney:success2', function (source)	
ESX.ShowNotification('1 Large Load Token = $5000!')
		playerPed = PlayerPedId()
		SetEntityHeading(playerPed, 97.37)
		searching  = true
		exports.rprogress:Custom({
								Async = true,
								x = 0.5,
								y = 0.5,
								From = 0,
								To = 100,
								Duration = 10000,
								Radius = 60,
								Stroke = 10,
								MaxAngle = 360,
								Rotation = 0,
								Easing = "easeLinear",
								Label = "WASHING",
								LabelPosition = "right",
								Color = "rgba(255, 255, 255, 1.0)",
								BGColor = "rgba(107, 109, 110, 0.95)",
								Animation = {
								--scenario = "CODE_HUMAN_MEDIC_TEND_TO_DEAD", -- https://pastebin.com/6mrYTdQv
								animationDictionary = "amb@prop_human_parking_meter@male@idle_a", -- https://alexguirre.github.io/animations-list/
								animationName = "idle_a",
								},
								DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true
								},
								})
				Citizen.Wait(10000)
				searching  = false
		TriggerServerEvent('esx_blackmoney:washMoney2')	
		
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(token) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local tokendist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, token[k].x, token[k].y, token[k].z)

            if tokendist <= 1.5 then
				drawText3D(token[k].x, token[k].y, token[k].z + 0.8, '[~g~E~s~] to buy~b~ Tokens~s~')
				if IsControlJustPressed(0, 38) then -- "E"
					OpenBuyTokenMenu()
				end
            end
        end
    end
end)

function OpenBuyTokenMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'buy_token_menu',
        {
            title    = 'Buy Laundry Tokens',
			align    = 'top-left',
            elements = {
                
				{label = 'Small Load Token($50)', item = 'washtoken', type = 'slider', price = 50, value = 1, min = 1, max = 100},
				{label = 'Large Load Token($250)', item = 'washtoken2', type = 'slider', price = 250, value = 1, min = 1, max = 100}
				
            }
        },
        function(data, menu)
				TriggerServerEvent('esx_blackmoney:buyToken', data.current.item, data.current.price, data.current.value)
				ESX.UI.Menu.CloseAll()
        end,
        function(data, menu)
            ESX.UI.Menu.CloseAll()
        end)
end

drawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	local scale = 0.30
   
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 650
        DrawRect(_x, _y + 0.0120, 0.030 + factor , 0.030, 66, 66, 66, 100)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 38) 
			DisableControlAction(0, 47)
			DisableControlAction(0, 74)
        end
    end
end)
