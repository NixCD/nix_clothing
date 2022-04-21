local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local activateboth = true
local distance = 2

Citizen.CreateThread(function()
	while true do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z)) < distance and activateboth and not IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowFloatingHelpNotification(_U('floating_action'), vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z+1))
			if IsControlJustReleased(1, 38) then
				activateboth = false
				OpenCriminalMenu()
				Citizen.Wait(1000)
				activateboth = true
			end
		end
	end
end)

function animation()
     RequestAnimDict("mp_common")
    while (not HasAnimDictLoaded("mp_common")) do
        Citizen.Wait(10) 
    end
    TaskPlayAnim(playerPed,"mp_common","givetake1_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
end

-- FUNCTIONS
function OpenCriminalMenu()
	ESX.UI.Menu.CloseAll()

	RequestAnimDict('clothingtie')
	while not HasAnimDictLoaded('clothingtie') do
		Citizen.Wait(1)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'nix_clothing', {
		title = _U('Title'),
		align = "bottom-right",
		elements = {
			{label = _U('Clothing'), value = "clothing"},
			{label = _U('citizen_Clothing'), value = "citizen_clothing"},
			{label = _U('close_menu'), value = "close"},
		}
	}, function(data, menu)
		menu.close()
		local val = data.current.value
		if val == "clothing" and Config.Sound.activate then
			FreezeEntityPosition(playerPed, true)
			ESX.ShowNotification('Buenas, aquí tienes la ropa que ~b~necesitas~w~')
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, Config.Sound.sound2, Config.Sound.volume)
			Citizen.Wait(1000)
			animation()
			Citizen.Wait(2000)
			TaskPlayAnim(playerPed, "clothingtie", "try_tie_positive_a", 1.0, -1.0, 2000, 0, 1, true, true, true)
			Citizen.Wait(2000)
			ESX.TriggerServerCallback("esx_skin:getPlayerSkin",	function(skin, jobSkin)
			Criminal(data.current.value, playerPed)
			Citizen.Wait(100)
		    ESX.ShowNotification(_U('notify_criminal'))
		    end)
			activateboth = true
			FreezeEntityPosition(playerPed, false)

		elseif val == "clothing" and not Config.Sound.activate then
			FreezeEntityPosition(playerPed, true)
			TaskPlayAnim(playerPed, "clothingtie", "try_tie_positive_a", 1.0, -1.0, 2000, 0, 1, true, true, true)
			Citizen.Wait(2000)
			ESX.TriggerServerCallback("esx_skin:getPlayerSkin",	function(skin, jobSkin)
			Criminal(data.current.value, playerPed)
			Citizen.Wait(100)
			ESX.ShowNotification(_U('notify_criminal'))
			end)
			activateboth = true
			FreezeEntityPosition(playerPed, false)

		elseif val == "close" then
			activateboth = true
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, false)

		elseif val == "citizen_clothing" and Config.Sound.activate then
			FreezeEntityPosition(playerPed, true)
			ESX.ShowNotification(_U'npc_message')
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, Config.Sound.sound, Config.Sound.volume)
			animation()
			Citizen.Wait(2000)
			TaskPlayAnim(playerPed, "clothingtie", "try_tie_positive_a", 1.0, -1.0, 2000, 0, 1, true, true, true)
			Citizen.Wait(2000)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			activate = true
			FreezeEntityPosition(playerPed, false)

		elseif val == "citizen_clothing" and not Config.Sound.activate then
			FreezeEntityPosition(playerPed, true)
			TaskPlayAnim(pedspawn,"anim@amb@nightclub@peds@","rcmme_amanda1_stand_loop_cop",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
			Citizen.Wait(2000)
			TaskPlayAnim(playerPed, "clothingtie", "try_tie_positive_a", 1.0, -1.0, 2000, 0, 1, true, true, true)
			Citizen.Wait(2000)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
		    ESX.ShowNotification(_U('notify_citizen'))
			end)
		    activateboth = true
			FreezeEntityPosition(playerPed, false)

		end
	end, function(data, menu)
		menu.close()
end)
end

function Criminal(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
  
	  if skin.sex == 0 then
		if Config.Clothing[job].male ~= nil then
		  TriggerEvent('skinchanger:loadClothes', skin, Config.Clothing[job].male)
		end
	  else
		if Config.Clothing[job].female ~= nil then
		  TriggerEvent('skinchanger:loadClothes', skin, Config.Clothing[job].female)
		end
	  end
	end)
  end

-- THREADS

Citizen.CreateThread(function()
	while Config.Marker.activate do 
		Citizen.Wait(1)
		    if GetDistanceBetweenCoords(GetEntityCoords(playerPed), vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z+1)) < distance and activateboth and not IsPedInAnyVehicle(playerPed, false) then 
		    DrawMarker(Config.Marker.type,Config.Coords.x, Config.Coords.y, Config.Coords.z,0.0,0.0,0.0,0.0,0.0,0.0,Config.Marker.x,Config.Marker.y,Config.Marker.z,Config.Marker.r,Config.Marker.g,Config.Marker.b,150,false, true, 2, Config.Marker.rotation, nil, false)
	    end
    end

	RequestModel(GetHashKey(Config.NPC.model))
	while not HasModelLoaded(GetHashKey(Config.NPC.model)) do
		Wait(1)
	end

	if Config.NPC.activate then
	    local pedspawn = CreatePed(4, Config.NPC.hash, Config.Coords.x, Config.Coords.y, Config.Coords.z-1, Config.Coords.heading, false, true)
	    SetEntityHeading(pedspawn, Config.Coords.heading)
	    FreezeEntityPosition(pedspawn, true)
	    SetEntityInvincible(pedspawn, true)
    	SetBlockingOfNonTemporaryEvents(pedspawn, true)
       	RequestAnimDict("amb@world_human_cop_idles@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_cop_idles@male@idle_a")) do			
    Citizen.Wait(1000)
end
	Citizen.Wait(200)
	TaskPlayAnim(pedspawn,"amb@world_human_cop_idles@male@idle_a","idle_b",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
    end
end)
