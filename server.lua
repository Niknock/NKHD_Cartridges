if Config.Framework == 'ESX' then
    ESX = nil
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'QBCore' then
    QBCore = nil
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
else
    print('No Framework has loaded!')
end

RegisterServerEvent('checkTaserCartridges')
AddEventHandler('checkTaserCartridges', function()
    local hasCartridge = false

    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local cartridgeItem = xPlayer.getInventoryItem(Config.ESXItemName)
            if cartridgeItem and cartridgeItem.count > 0 then
                xPlayer.removeInventoryItem(Config.ESXItemName, 1)
                hasCartridge = true
            end
        end
    elseif Config.Framework == 'QBCore' then
        local qbPlayer = QBCore.Functions.GetPlayer(source)
        if qbPlayer then
            local cartridgeItem = qbPlayer.Functions.GetItemByName(Config.QBCoreItemName)
            if cartridgeItem and cartridgeItem.amount > 0 then
                qbPlayer.Functions.RemoveItem(Config.QBCoreItemName, 1)
                hasCartridge = true
            end
        end
    else
        print('No Framework has loaded!')
    end

    TriggerClientEvent('reloadTaser', source, hasCartridge)
end)
