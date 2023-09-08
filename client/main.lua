RegisterCommand("ShareOutfit", function(source, args, rawCommand)
    local toplayer = tonumber(args[1])
    local fromplayer = GetPlayerServerId(PlayerId())
    local toped = GetPlayerFromServerId(toplayer)
    if type(toplayer) ~= "number" then
        Notify("Invalid player ID")
        return
    elseif toplayer == fromplayer then
        Notify("You cannot share clothes with yourself")
        return
    elseif NetworkIsPlayerActive(toped) == false then
        Notify("Player is not active")
        return
    else
        Notify("Request sent")
        TriggerServerEvent("TLClothesShare:ShareRequest", toplayer)
    end
end, false)

RegisterNetEvent('TLClothesShare:Share', function(toplayer)
    local name = GetPlayerName(GetPlayerFromServerId(toplayer))
    local toped = GetPlayerFromServerId(toplayer)
    if not NetworkIsPlayerActive(toped) then
        Notify("Player is not active")
        TriggerEvent("TLClothesShare:NotifyPlayer", toplayer, 'Share Canceled')
        return
    end
    Notify("Shared clothes with ~g~" .. name .. "~w~")
    local ped = PlayerPedId()
    local data = {}

    
    for i = 1, 12 do
        data[tonumber(i)] = {draw = GetPedDrawableVariation(ped, i), texture = GetPedTextureVariation(ped, i)}
    end
    local hat = {prop = GetPedPropIndex(ped, 0), texture = GetPedPropTextureIndex(ped, 0)}
    TriggerServerEvent("TLClothesShare:SendData", toplayer, data, hat)
end)

RegisterNetEvent('TLClothesShare:Recieve', function(data, hat)
    for k, v in ipairs(data) do
        if k ~= 2 then
            exports.TLdevtools:NewLog('info', 'Setting component ' .. tonumber(k) .. ' to draw ' .. tonumber(v.draw) .. ' and texture ' .. tonumber(v.texture))
            SetPedComponentVariation(PlayerPedId(), k, v.draw, v.texture, 0)
        end
    end
    exports.TLdevtools:NewLog('info', 'Setting prop to draw ' .. tonumber(hat.prop) .. ' and texture ' .. tonumber(hat.texture))
    SetPedPropIndex(PlayerPedId(), 0, hat.prop, hat.texture, true)
end)

RegisterNetEvent('TLClothesShare:Notify', function(text)
    Notify(text)
end)
function Notify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(0, 1)
end

RegisterNetEvent("TLClothesShare:RequestClient", function(returnplayer)
    isrequestshare = true
    PlaySound(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 0, 0, 1)
    Notify('~y~Y~w~ to accept, ~r~L~w~ to refuse (~g~' .. returnplayer .. '~w~)')
    local timer = 10 * 1000
    while isrequestshare do
        Wait(5)
        timer = timer - 5
        if timer == 0 then
            isrequestshare = false
            Notify("Request timed out")
        end
        if IsControlJustPressed(0, 246) then
            isrequestshare = false
            TriggerServerEvent("TLClothesShare:ShareAccepted", returnplayer)
        elseif IsControlJustPressed(0, 182) then
            isrequestshare = false
            Notify("Request declined")
        end
    end
end)