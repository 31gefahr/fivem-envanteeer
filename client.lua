local isInventoryOpen = false


RegisterKeyMapping('toggleinv', 'Envanteri Aç/Kapat', 'keyboard', 'F2')

RegisterCommand('toggleinv', function()
    if not isInventoryOpen then
        OpenInventory()
    else
        CloseInventory()
    end
end)

function OpenInventory()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = GetVehiclePedIsIn(ped, false)
    local targetInv = "ground"
    local netId = 0

   
    if veh ~= 0 then
        targetInv = "glovebox"
        netId = VehToNet(veh)
    else
        local closeVeh = GetClosestVehicle(coords, 3.0, 0, 71)
        if DoesEntityExist(closeVeh) then
            local trunkCoords = GetWorldPositionOfEntityBone(closeVeh, GetEntityBoneIndexByName(closeVeh, "boot"))
            if #(coords - trunkCoords) < 2.0 then
                SetVehicleDoorOpen(closeVeh, 5, false, false) 
                targetInv = "trunk"
                netId = VehToNet(closeVeh)
            end
        end
    end

   
    
    TriggerServerEvent('inventory:requestPlayerData', targetInv, netId)
    
    isInventoryOpen = true
    SetNuiFocus(true, true)
end

function CloseInventory()
    isInventoryOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    
    
    local ped = PlayerPedId()
    local closeVeh = GetClosestVehicle(GetEntityCoords(ped), 3.0, 0, 71)
    if DoesEntityExist(closeVeh) then
        SetVehicleDoorShut(closeVeh, 5, false)
    end
end


RegisterNUICallback('closeInv', function(data, cb)
    CloseInventory()
    cb('ok')
end)


RegisterNUICallback('giveItem', function(data, cb)
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('inventory:giveItem', GetPlayerServerId(closestPlayer), data.slot)
    else
        print("Yakında kimse yok!")
    end
    cb('ok')
end)


for i = 1, 5 do
    RegisterKeyMapping('slot_'..i, 'Slot '..i, 'keyboard', tostring(i))
    RegisterCommand('slot_'..i, function()
        if not isInventoryOpen then 
            TriggerServerEvent('inventory:useHotkey', i)
        end
    end)
end


function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for i=1, #players, 1 do
        local target = GetPlayerPed(players[i])
        if target ~= ply then
            local targetCoords = GetEntityCoords(target, 0)
            local distance = #(targetCoords - plyCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end
