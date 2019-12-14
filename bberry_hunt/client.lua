local starting = false
local already = false
local testpedd = {}
local blip = {}


function missionstart()

	local hash = GetHashKey('A_C_Fox_01')
	starting = true
	testped = {
	{ x = -2044.69, y = -488.16, z = 150.0, true, true},
	{ x = -2047.01, y = -493.41, z = 149.69, true, true},
	{ x = -1821.81, y = -818.22, z = 106.22, true, true},
	{ x = -1657.83, y = -681.25, z = 148.64, true, true}
			  }
			  
	for k,item in pairs(testped) do
		testpedd[k] = CreatePed(hash, item.x, item.y, item.z, true, true)
		Citizen.InvokeNative(0x283978A15512B2FE, testpedd[k], true)
		Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, testpedd[k])
		blip[k] = (testpedd[k])
	end

	Citizen.CreateThread(function()
		local x = #testped
			while starting == true do
			Citizen.Wait(0)
			for k,v in pairs(testpedd) do
					if IsEntityDead(v) then
						if blip[k] ~= nil then
							x = x - 1
							blip[k] = nil
							if x == 0 then
							TriggerServerEvent('bberry_hunt:AddSomeMoney')
							Citizen.InvokeNative(0x4AD96EF928BD4F9A, hash)
						end
					end
				end
			end
		end
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		starting = false
		blip = nil
		testpedd = nil
		already = false
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, -1791.3, -387.11, 160.33, true) < 2.0 then
			DrawTxt(Config.HuntingMessage, 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
			if IsControlJustPressed(2, 0x4AF4D473) and not already then
				GiveWeaponToPed_2(playerPed, 0x772C8DD6, 10, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
				SetPedAmmo(playerPed, 0x772C8DD6, 10)
				Wait(500)
				missionstart()
				already = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	Wait(0)
	Citizen.InvokeNative(0x554d9d53f696d002, 1560611276, -1791.3, -387.11, 160.33)
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end