local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp4 = Tunnel.getInterface("vrp_milkman-delivery")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local check = 0
local blips = false
local working = false
local hour = 0

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function CalculateTimeToDisplay4()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

--[ THREAD ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(configmilkmand.ini.x,configmilkmand.ini.y,configmilkmand.ini.z)
			local distance = Vdist(configmilkmand.ini.x,configmilkmand.ini.y,configmilkmand.ini.z,x,y,z)
			local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
			if distance < 15.1 then
				idle = 5
				DrawMarker(23,configmilkmand.ini.x,configmilkmand.ini.y,configmilkmand.ini.z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
				if distance <= 1.2 then
					drawTexts("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.92,0.35,255,255,255,180)
					if IsControlJustPressed(1,38) and lastVehicle == configmilkmand.lastve and emp4.checkPlate(lastVehicle) then
						if not working then
							CalculateTimeToDisplay4()
							if parseInt(hour) >= 00 and parseInt(hour) <= 23 then
								working = true
								check = math.random(#configmilkmand.deliverys)
								makeBlipsServices4()
								TriggerEvent("Notify","sucesso","Entregas iniciada com <b>sucesso</b>.",8000)
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>00:00</b> as <b>23:00</b>.",8000)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ THREAD ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if working then
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(configmilkmand.deliverys[check][1],configmilkmand.deliverys[check][2],configmilkmand.deliverys[check][3],x,y,z)
				local lastVehicle = GetEntityModel(GetPlayersLastVehicle())local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
				if distance < 15.1 then
					idle = 5
					DrawMarker(21,configmilkmand.deliverys[check][1],configmilkmand.deliverys[check][2],configmilkmand.deliverys[check][3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,136, 96, 240, 180,0,0,0,1)
					if distance <= 1.2 then
						drawTexts("PRESSIONE  ~b~E~w~  PARA ENTREGAR GARRAFAS DE LEITE",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and lastVehicle == 1026149675 and emp4.checkPlate(lastVehicle) then
							
							CalculateTimeToDisplay4()
							--if parseInt(hour) >= 00 and parseInt(hour) <= 23 then
								if emp4.startPayments() then
									RemoveBlip(blips)
									check = math.random(#configmilkmand.deliverys)
									makeBlipsServices4()
								end
							--else
							--	TriggerEvent("Notify","importante","Funcionamento é das <b>00:00</b> as <b>23:00</b>.",8000)
							--end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CANCEL | THREAD ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if working and IsControlJustPressed(1,168) then
			working = false
			RemoveBlip(blips)
			TriggerEvent("Notify","importante","Você saiu de serviço",8000)
		end
	end
end)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function drawTexts(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function makeBlipsServices4()
	blips = AddBlipForCoord(configmilkmand.deliverys[check][1],configmilkmand.deliverys[check][2],configmilkmand.deliverys[check][3])
	SetBlipSprite(blips,85)
	SetBlipColour(blips,26)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregas")
	EndTextCommandSetBlipName(blips)
end