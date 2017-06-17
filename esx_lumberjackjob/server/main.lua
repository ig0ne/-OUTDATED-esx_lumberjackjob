--<-.(`-')               _                         <-. (`-')_  (`-')  _                          (`-')              _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
-- __( OO)      .->     (_)        .->                \( OO) ) ( OO).-/    <-.          .->   <-.(OO )     <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--'-'---.\  ,--.'  ,-.  ,-(`-') ,---(`-')  .----.  ,--./ ,--/ (,------. (`-')-----.(`-')----. ,------,) (`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--| .-. (/ (`-')'.'  /  | ( OO)'  .-(OO ) /  ..  \ |   \ |  |  |  .---' (OO|(_\---'( OO).-.  '|   /`. ' (OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
--| '-' `.)(OO \    /   |  |  )|  | .-, \|  /  \  .|  . '|  |)(|  '--.   / |  '--. ( _) | |  ||  |_.' |  / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
--| /`'.  | |  /   /)  (|  |_/ |  | '.(_/'  \  /  '|  |\    |  |  .--'   \_)  .--'  \|  |)|  ||  .   .'  \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--| '--'  / `-/   /`    |  |'->|  '-'  |  \  `'  / |  | \   |  |  `---.   `|  |_)    '  '-'  '|  |\  \    `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--`------'    `--'      `--'    `-----'    `---''  `--'  `--'  `------'    `--'       `-----' `--' '--'    `--'    `--'       `-'     `------' `------'  `------'    `-'    


local PlayersHarvestingWood 		 = {}
local PlayersCutingWood    			 = {}
local PlayersPackagingPlank      	 = {}
local PlayersReselling            	 = {}

RegisterServerEvent('esx_lumberjackjob:requestPlayerData')
AddEventHandler('esx_lumberjackjob:requestPlayerData', function(reason)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		TriggerEvent('esx_skin:requestPlayerSkinInfosCb', source, function(skin, jobSkin)

			local data = {
				job       = xPlayer.job,
				inventory = xPlayer.inventory,
				skin      = skin
			}

			TriggerClientEvent('esx_lumberjackjob:responsePlayerData', source, data, reason)
		end)
	end)
end)
-----------------------------Recolte---------------------------------------------
local function HarvestWood(source)

	SetTimeout(3000, function()

		if PlayersHarvestingWood[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local woodQuantity = xPlayer:getInventoryItem('wood').count

				if woodQuantity >= 20 then
					TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de Bois')
				else
					
					xPlayer:addInventoryItem('wood', 1)
					HarvestWood(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_lumberjackjob:startHarvestWood')
AddEventHandler('esx_lumberjackjob:startHarvestWood', function()
	PlayersHarvestingWood[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Ramassage en cours...')
	HarvestWood(source)
end)

RegisterServerEvent('esx_lumberjackjob:stopHarvestWood')
AddEventHandler('esx_lumberjackjob:stopHarvestWood', function()
	PlayersHarvestingWood[source] = false
end)
-------------------------------------------Coupage--------------------------------
local function CutWood(source)

	SetTimeout(5000, function()

		if PlayersCutingWood[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local woodQuantity = xPlayer:getInventoryItem('wood').count

				if woodQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de bois à couper')
				else
					
					xPlayer:removeInventoryItem('wood', 1)
					xPlayer:addInventoryItem('cutted_wood', 1)

					CutWood(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_lumberjackjob:startCutingWood')
AddEventHandler('esx_lumberjackjob:startCutingWood', function()
	PlayersCutingWood[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Coupage en cours...')
	CutWood(source)
end)

RegisterServerEvent('esx_lumberjackjob:stopCutingWood')
AddEventHandler('esx_lumberjackjob:stopCutingWood', function()
	PlayersCutingWood[source] = false
end)
-----------------------------Conditionement--------------------------------
local function PackagePlank(source)

	SetTimeout(4000, function()

		if PlayersPackagingPlank[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cutedWoodQuantity = xPlayer:getInventoryItem('cutted_wood').count
				local packagedWoodQuantity    = xPlayer:getInventoryItem('packaged_plank').count

				if cutedWoodQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de planches à conditionner')
				elseif packagedWoodQuantity >= 100 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place pour des paquets de planches')
				else
					
					xPlayer:removeInventoryItem('cutted_wood', 1)
					xPlayer:addInventoryItem('packaged_plank', 5)
					
					PackagePlank(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_lumberjackjob:startPackagePlank')
AddEventHandler('esx_lumberjackjob:startPackagePlank', function()
	PlayersPackagingPlank[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Conditonnement en cours...')
	PackagePlank(source)
end)

RegisterServerEvent('esx_lumberjackjob:stopPackagePlank')
AddEventHandler('esx_lumberjackjob:stopPackagePlank', function()
	PlayersPackagingPlank[source] = false
end)
----------------Revente---------------------------
local function Resell(source)

	SetTimeout(500, function()

		if PlayersReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local packagedPlankQuantity = xPlayer:getInventoryItem('packaged_plank').count

				if packagedPlankQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de planches à vendre')
				else
					
					xPlayer:removeInventoryItem('packaged_plank', 1)
					xPlayer:addMoney(9)
					
					Resell(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_lumberjackjob:startResell')
AddEventHandler('esx_lumberjackjob:startResell', function()
	PlayersReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	Resell(source)
end)

RegisterServerEvent('esx_lumberjackjob:stopResell')
AddEventHandler('esx_lumberjackjob:stopResell', function()
	PlayersReselling[source] = false
end)
