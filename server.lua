local userInventories = {} 
local OX = exports.oxmysql


RegisterNetEvent('envanter:esyaEkle')
AddEventHandler('envanter:esyaEkle', function(itemName, count)
    local src = source
    local license = GetPlayerIdentifiers(src)[1]

   
    OX:execute('INSERT INTO user_inventory (identifier, item_name, count) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE count = count + ?', 
    {license, itemName, count, count}, function(result)
        TriggerClientEvent('chat:addMessage', src, {args = {"SİSTEM", count .. " adet " .. itemName .. " eklendi."}})
    end)
end)


RegisterServerEvent('envanter:esyaKullan')
AddEventHandler('envanter:esyaKullan', function(itemName)
    local src = source
    local license = GetPlayerIdentifiers(src)[1]

    OX:scalar('SELECT count FROM user_inventory WHERE identifier = ? AND item_name = ?', {license, itemName}, function(count)
        if count and count > 0 then
            
            OX:execute('UPDATE user_inventory SET count = count - 1 WHERE identifier = ? AND item_name = ?', {license, itemName})
            
          
            TriggerClientEvent('envanter:efektTetikle', src, itemName)
        else
            TriggerClientEvent('chat:addMessage', src, {args = {"HATA", "Üzerinde bu eşyadan yok!"}})
        end
    end)
end)

RegisterNetEvent('inventory:addItem')
AddEventHandler('inventory:addItem', function(itemName, count)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1] 

    if not userInventories[identifier] then
        userInventories[identifier] = {}
    end

    if userInventories[identifier][itemName] then
        userInventories[identifier][itemName] = userInventories[identifier][itemName] + count
    else
        userInventories[identifier][itemName] = count
    end

    print(string.format("[Envanter] %s isimli oyuncuya %d adet %s eklendi.", GetPlayerName(src), count, itemName))
end)


RegisterCommand('envanter', function(source, args, rawCommand)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local inv = userInventories[identifier]

    if inv then
        TriggerClientEvent('chat:addMessage', src, { args = { '^2Envanterin:' } })
        for item, amount in pairs(inv) do
            TriggerClientEvent('chat:addMessage', src, { args = { '- ' .. item .. ': ' .. amount } })
        end
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^1Envanterin boş!' } })
    end
end, false)
