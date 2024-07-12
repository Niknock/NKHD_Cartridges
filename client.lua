local cartridges = Config.MaxCartridges
local NoCartgridgesMessage = false
local cartridgesin = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if cartridgesin == false then
            if IsControlJustReleased(0, Config.ReloadKey) then
                TriggerServerEvent('checkTaserCartridges')
            end
        end
    end
end)

RegisterNetEvent('reloadTaser')
AddEventHandler('reloadTaser', function(hasCartridge)
    if hasCartridge then
        cartridgesin = true
        cartridges = Config.MaxCartridges
        ShowNotification('~g~Taser Reloaded')
        NoCartgridgesMessage = false
    else
        ShowNotification('~r~There are no Cartridges left.')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_STUNGUN') then
            if cartridges <= 0 then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 142, true) 
                SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey('WEAPON_STUNGUN'))
                if NoCartgridgesMessage == false then
                    cartridgesin = false
                    NoCartgridgesMessage = true
                    ShowNotification('~r~Out of cartridges! Press R to reload.')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedShooting(PlayerPedId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_STUNGUN') then
            if cartridges > 0 then
                cartridges = cartridges - 1
                if NoCartgridgesMessage == false then
                    if cartridges <= 0 then
                        cartridgesin = false
                        NoCartgridgesMessage = true
                        ShowNotification('~r~Out of cartridges! Press R to reload.')
                    end
                end
            end
        end
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end