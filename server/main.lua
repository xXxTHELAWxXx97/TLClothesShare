RegisterNetEvent('TLClothesShare:ShareRequest', function(target)
    local src = source
    TriggerClientEvent("TLClothesShare:RequestClient", target, src)
end)

RegisterNetEvent('TLClothesShare:ShareAccepted', function(fromplayer)
    local toplayer = source
    TriggerClientEvent("TLClothesShare:Share", fromplayer, toplayer)
    name = GetPlayerName(fromplayer)
    TriggerClientEvent('TLClothesShare:Notify', toplayer, "Received clothes from ~g~" .. name .. "~w~")
end)

RegisterNetEvent('TLClothesShare:SendData', function(toplayer, t, p)
    TriggerClientEvent("TLClothesShare:Recieve", toplayer, t, p)
end)

RegisterNetEvent('TLClothesShare:NotifyPlayer', function(toplayer, text)
    TriggerClientEvent('TLClothesShare:Notify', toplayer, text)
end)