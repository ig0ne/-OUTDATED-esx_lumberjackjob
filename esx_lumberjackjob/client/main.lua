local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local GUI                     = {}
GUI.Time                      = 0
local hasAlreadyEnteredMarker = false;
local lastZone                = nil;
local Blips                   = {}

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('esx_lumberjackjob:requestPlayerData', 'playerSpawned')
end)

AddEventHandler('esx_lumberjackjob:hasEnteredMarker', function(zone)

	if zone == 'CloakRoom' then
		SendNUIMessage({
			showControls = true,
			controls     = 'cloakroom'
		})
	end

	if zone == 'Wood' then
		SendNUIMessage({
			showControls = true,
			controls     = 'wood'
		})
	end

	if zone == 'CuttedWood' then
		SendNUIMessage({
			showControls = true,
			controls     = 'cuttedwood'
		})
	end

	if zone == 'Planks' then
		SendNUIMessage({
			showControls = true,
			controls     = 'planks'
		})
	end

	if zone == 'VehicleSpawner' then
		SendNUIMessage({
			showControls = true,
			controls     = 'vehiclespawner'
		})
	end

	if zone == 'Delivery' then
		
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		SendNUIMessage({
			showControls = true,
			controls     = 'delivery'
		})

	end

end)

AddEventHandler('esx_lumberjackjob:hasExitedMarker', function(zone)

	if zone == 'Wood' then
		TriggerServerEvent('esx_lumberjackjob:stopHarvestWood')
	end

	if zone == 'CuttedWood' then
		TriggerServerEvent('esx_lumberjackjob:stopCutingWood')
	end

	if zone == 'Planks' then
		TriggerServerEvent('esx_lumberjackjob:stopPackagePlank')
	end

	if zone == 'Delivery' then
		TriggerServerEvent('esx_lumberjackjob:stopResell')
	end

	SendNUIMessage({
		showControls = false,
		showMenu     = false,
	})

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_lumberjackjob:responsePlayerData')
AddEventHandler('esx_lumberjackjob:responsePlayerData', function(data, reason)
	PlayerData = data
end)

RegisterNUICallback('select', function(data, cb)

	if data.menu == 'cloakroom' then

		if data.val == 'citizen_wear' then
			TriggerEvent('esx_skin:loadSkin', PlayerData.skin)
		end

		if data.val == 'lumberjack_wear' then
			if PlayerData.skin.sex == 0 then
				TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_male)
			else
				TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_female)
			end
		end

	end

	if data.menu == 'vehiclespawner' then

    local playerPed = GetPlayerPed(-1)

		Citizen.CreateThread(function()

			local coords       = Config.Zones.VehicleSpawnPoint.Pos
			local vehicleModel = GetHashKey(data.val)

			RequestModel(vehicleModel)

			while not HasModelLoaded(vehicleModel) do
				Citizen.Wait(0)
			end

			if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, 45.0, true, false)
				SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
				SetEntityAsMissionEntity(vehicle,  true,  true)
				local id = NetworkGetNetworkIdFromEntity(vehicle)
				SetNetworkIdCanMigrate(id, true)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end

		end)

		Blips['delivery'] = AddBlipForCoord(Config.Zones.Delivery.Pos.x,  Config.Zones.Delivery.Pos.y,  Config.Zones.Delivery.Pos.z)
		SetBlipRoute(Blips['delivery'], true)

		TriggerEvent('esx:showNotification', 'Rendez-vous au point de livraison')

		SendNUIMessage({
			showControls = false,
			showMenu     = false,
		})

	end

	cb('ok')

end)

RegisterNUICallback('select_control', function(data, cb)

	if data.control == 'wood' then

		TriggerServerEvent('esx_lumberjackjob:startHarvestWood')

		SendNUIMessage({
			showControls = false
		})

	end

	if data.control == 'cuttedwood' then

		TriggerServerEvent('esx_lumberjackjob:startCutingWood')

		SendNUIMessage({
			showControls = false
		})
		
	end

	if data.control == 'planks' then

		TriggerServerEvent('esx_lumberjackjob:startPackagePlank')

		SendNUIMessage({
			showControls = false
		})
		
	end

	if data.control == 'delivery' then
		
		TriggerServerEvent('esx_lumberjackjob:startResell')

		SendNUIMessage({
			showControls = false
		})

	end

	cb('ok')
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if(PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if(PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack') then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x / 2) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_lumberjackjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_lumberjackjob:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- Create blips
Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.Wood.Pos.x, Config.Zones.Wood.Pos.y, Config.Zones.Wood.Pos.z)
  
  SetBlipSprite (blip, 237)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 4)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Scierie")
  EndTextCommandSetBlipName(blip)

end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				enterPressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['BACKSPACE']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				backspacePressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'LEFT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'RIGHT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'UP'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'DOWN'
			})

			GUI.Time = GetGameTimer()

		end

	end
end)