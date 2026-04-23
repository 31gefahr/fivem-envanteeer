local OX = exports.oxmysql


RegisterServerEvent('inventory:requestPlayerData')
AddEventHandler('inventory:requestPlayerData', function(invType, netId)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    
    OX:query('SELECT item_name as name, count, slot, weight FROM user_inventory WHERE identifier = ?', {identifier}, function(playerItems)
        local totalWeight = 0
        if playerItems then
            for _, v in pairs(playerItems) do
                totalWeight = totalWeight + (v.weight * v.count)
            end
        end

       
        if invType == "trunk" and netId ~= 0 then
            local plate = GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(netId))
            OX:query('SELECT item_name as name, count, slot, weight FROM trunk_inventory WHERE plate = ?', {plate}, function(otherItems)
                TriggerClientEvent('inventory:openUI', src, {
                    action = "display",
                    playerItems = playerItems or {},
                    otherItems = otherItems or {},
                    currentWeight = totalWeight,
                    otherTitle = "Araç Bagajı (" .. plate .. ")"
                })
            end)
        else
            
            TriggerClientEvent('inventory:openUI', src, {
                action = "display",
                playerItems = playerItems or {},
                otherItems = {},
                currentWeight = totalWeight,
                otherTitle = "Yer"
            })
        end
    end)
end)


RegisterNetEvent('inventory:moveItem')
AddEventHandler('inventory:moveItem', function(data)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    
    
    if data.fromInv == data.toInv and data.fromInv == "player-slots" then
        OX:execute('UPDATE user_inventory SET slot = ? WHERE identifier = ? AND slot = ?', 
        {data.toSlot, identifier, data.fromSlot})
    
   
    elseif data.fromInv == "player-slots" and data.toInv == "other-slots" then
       
        print("Eşya çantadan dışarı çıkarıldı slot: " .. data.fromSlot)
    end
end)


RegisterNetEvent('inventory:useHotkey')
AddEventHandler('inventory:useHotkey', function(slotId)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    OX:query('SELECT item_name, count FROM user_inventory WHERE identifier = ? AND slot = ?', {identifier, slotId}, function(result)
        if result and result[1] and result[1].count > 0 then
            local itemName = result[1].item_name
            
            
            if string.find(itemName, "WEAPON_") then
                TriggerClientEvent('inventory:toggleWeapon', src, itemName)
            else
                TriggerClientEvent('envanter:efektTetikle', src, itemName)
            end
        end
    end)
end)


RegisterNetEvent('inventory:addItem')
AddEventHandler('inventory:addItem', function(itemName, count, weight)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local itemWeight = weight or 1.0

    OX:scalar('SELECT SUM(count * weight) FROM user_inventory WHERE identifier = ?', {identifier}, function(currentTotal)
        if (currentTotal or 0) + (count * itemWeight) <= 100.0 then
          
            OX:execute('INSERT INTO user_inventory (identifier, item_name, count, slot, weight) VALUES (?, ?, ?, (SELECT COALESCE(MAX(slot), 0) + 1 FROM user_inventory WHERE identifier = ?), ?) ON DUPLICATE KEY UPDATE count = count + ?',
            {identifier, itemName, count, identifier, itemWeight, count})
        else
            TriggerClientEvent('chat:addMessage', src, {args = {"SİSTEM", "Envanterin çok ağır!"}})
        end
    end)
end)
