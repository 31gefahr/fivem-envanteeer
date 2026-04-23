local userInventories = {} 


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
