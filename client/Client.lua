ESX = nil
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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['F7']) and not isDead then
			local grczPed = PlayerPedId()    
			local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
			if wPojezdzieCzek then  
				local poyazd = GetVehiclePedIsIn(grczPed, false) 
				
				if GetPedInVehicleSeat(poyazd, -1) == grczPed then
					otfuszMenuPoyazdu()
				end
			end
		end
		
		if (IsControlJustReleased(0, Keys['Y']) or IsDisabledControlJustReleased(0, Keys['Y'])) and not isDead then
			local grczPed = PlayerPedId()    
			local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
			
			if wPojezdzieCzek then  
				local poyazd = GetVehiclePedIsIn(grczPed, false)
				
				if GetPedInVehicleSeat(poyazd, -1) == grczPed then
					wlonczwylonczsilnior()
				end
			end
        end

		if DoesEntityExist(PlayerPedId()) and IsPedInAnyVehicle(PlayerPedId(), false) and IsControlPressed(2, 75) and not isDead and not IsPauseMenuActive() then
			local ped = PlayerPedId()
			local ChudziSilnior = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
			Citizen.Wait(1000)
			if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not isDead and not IsPauseMenuActive() then
				local poyazd = GetVehiclePedIsIn(ped, true)
				if (ChudziSilnior) then
					SetVehicleEngineOn(poyazd, true, true, true)
				end
			end
		end
		
	end
end)

function otfuszMenuPoyazdu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_poyazdu', {
		title	= 'Pojazd',
		align	= 'bottom-right',
		elements = {
			{label = 'Włącz / wyłącz silnik', value = 'silnik'},
			{label = 'Otwórz / zamknij maskę', value = 'masunia'},
			{label = 'Otwórz / zamknij bagażnik', value = 'bagolik'},
			{label = 'Otwórz / zamknij drzwi', value = 'dszwi'},
			{label = 'Otwórz / zamknij okno', value = 'ukno'},	
		}
	}, function(data, menu)
		local akszja_menu_poyazdu = data.current.value

		if akszja_menu_poyazdu == 'silnik' then
			wlonczwylonczsilnior()
		elseif akszja_menu_poyazdu == 'masunia' then
			OtwuszDszwi(4)
		elseif akszja_menu_poyazdu == 'bagolik' then
			OtwuszDszwi(5)
		elseif akszja_menu_poyazdu == 'dszwi' then
			menu.close()
			MenuDszwi()
		elseif akszja_menu_poyazdu == 'ukno' then
			menu.close()
			MenuOknaYebanego()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function MenuDszwi()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_doors_menu', {
		title	= 'Pojazd - drzwi',
		align	= 'bottom-right',
		elements = {
			{label = 'Zamknij wszystkie drzwi', value = 'zamknyi'},
			{label = 'Lewy przód', value = 0},
			{label = 'Prawy przód', value = 1},
			{label = 'Lewy tył', value = 2},
			{label = 'Prawy tył', value = 3},
		}
	}, function(data, menu)
		local action = data.current.value
		if data.current.value == 'zamknyi' then
			ZamknijDszwi()
		elseif data.current.value > -1 and data.current.value < 4 then
			OtwuszDszwi(data.current.value)
		end
	end, function(data, menu)
		menu.close()
		otfuszMenuPoyazdu()
	end)
end

function OtwuszDszwi(id)
	local grczPed = PlayerPedId()    
	local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
	if wPojezdzieCzek then  
		local poyazd = GetVehiclePedIsIn(grczPed, false) 
		
		if GetPedInVehicleSeat(poyazd, -1) == grczPed then
			if GetVehicleDoorAngleRatio(poyazd, id) > 0 then
				SetVehicleDoorShut(poyazd, id, false)
			else
				SetVehicleDoorOpen(poyazd, id, false, false)
			end
		end
	end
end

function ZamknijDszwi()
	local grczPed = PlayerPedId()    
	local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
	if wPojezdzieCzek then  
		local poyazd = GetVehiclePedIsIn(grczPed, false) 
		
		if GetPedInVehicleSeat(poyazd, -1) == grczPed then
			for i = 0, 6 do
				SetVehicleDoorShut(poyazd, i, false)
			end
		end
	end
end

function MenuOknaYebanego()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_doors_menu', {
		title	= 'Pojazd - okna',
		align	= 'bottom-right',
		elements = {
			{label = 'Zamknij wszystkie okna', value = 'close'},
			{label = 'Lewy przód', value = 0},
			{label = 'Prawy przód', value = 1},
			{label = 'Lewy tył', value = 2},
			{label = 'Prawy tył', value = 3},
		}
	}, function(data, menu)
		local action = data.current.value
		if data.current.value == 'close' then
			ZamkyiUkno()
		elseif data.current.value > -1 and data.current.value < 4 then
			OtfuszOkno(data.current.value)
		end
	end, function(data, menu)
		menu.close()
		otfuszMenuPoyazdu()
	end)
end

function OtfuszOkno(id)
	local grczPed = PlayerPedId()    
	local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
	if wPojezdzieCzek then  
		local poyazd = GetVehiclePedIsIn(grczPed, false) 
		
		if GetPedInVehicleSeat(poyazd, -1) == grczPed then
			if IsVehicleWindowIntact(poyazd, id) then
				RollDownWindow(poyazd, id)
			else
				RollUpWindow(poyazd, id)
				
			end
		end
	end
end

function ZamkyiUkno()
	local grczPed = PlayerPedId()    
	local wPojezdzieCzek = IsPedInAnyVehicle(grczPed, false) 
	if wPojezdzieCzek then  
		local poyazd = GetVehiclePedIsIn(grczPed, false) 
		
		for i = 0, 4 do
			RollUpWindow(poyazd, i)
		end
	end
end

function wlonczwylonczsilnior()
    local poyazd = GetVehiclePedIsIn(PlayerPedId(), false)
    if poyazd ~= nil and poyazd ~= 0 and GetPedInVehicleSeat(poyazd, -1) then
        SetVehicleEngineOn(poyazd, (not GetIsVehicleEngineRunning(poyazd)), false, true)
    end
end 