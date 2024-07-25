local QBCore = exports['qb-core']:GetCoreObject()
local isUsed = 0
local hasNotify = false


QBCore.Functions.CreateUseableItem('crutch', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        if not hasNotify then
            hasNotify = true
            TriggerClientEvent('QBCore:Notify', source, "Je kan de kruk maar 5x gebruiken.")
        end
        if isUsed < 9 then
            isUsed = isUsed + 1
            TriggerClientEvent('mh-crutches:client:crutch', source)
        else
            TriggerClientEvent('mh-crutches:client:crutch', source)
            Wait(10)
            Player.Functions.RemoveItem('crutch', 1)
            TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items["crutch"], "remove", 1)
            isUsed = 0     
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        isUsed = 0
        hasNotify = false
    end
end)
