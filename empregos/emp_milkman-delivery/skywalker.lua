local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp4 = {}
Tunnel.bindInterface("vrp_milkman-delivery",emp4)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local amount2 = {}

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp4.startPayments()
	local source = source

	if amount2[source] == nil then
		amount2[source] = parseInt(math.random(configmilkmand.deliveryss[1],configmilkmand.deliveryss[2]))
	end

	local user_id = vRP.getUserId(source)
	if user_id then
	
		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,configmilkmand.milkman1,amount2[source]) then
				local pagamento = parseInt(math.random(configmilkmand.milkman2[1],configmilkmand.milkman2[2]))
				vRP.giveDinheirama(user_id,parseInt(pagamento+amount2[source]))
				TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
				TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(pagamento+amount2[source])).." reais</b>.",8000)

				amount2[source] = nil
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount2[source].."x Garrafas de Leite</b>.",8000)
			end
		end
		return false
	end
end

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp4.checkPlate(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	local veh,vhash,vplaca,vname = vRPclient.vehListHash(source,4)
	if veh and vhash == modelo then
		local placa_user_id = vRP.getUserByRegistration(vplaca)
		if user_id == placa_user_id then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você <b>precisa usar o carro</b> de serviço.",10000)
			return false
		end
	end
end

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------
--[[
function emp4.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.checkCrimeRecord(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
			return false
		else
			return true
		end
	end
end
]]--