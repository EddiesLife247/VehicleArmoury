local QBCore = exports['qb-core']:GetCoreObject()
local registeredStashes = {}

RegisterCommand("armourydebug", function(source)
    Config.Debug = not Config.Debug
    print("Armoury debug is now " .. (Config.Debug and "enabled" or "disabled"))
end, true)

local function debugPrint(msg)
    if Config.Debug then
        if type(msg) == "table" then
            print("^3[armoury]^0 " .. json.encode(msg))
        else
            print("^3[armoury]^0 " .. tostring(msg))
        end
    end
end

local function getPlayerJobType(jobName)
    for jobType, jobs in pairs(Config.JobTypes) do
        for _, j in ipairs(jobs) do
            if j == jobName then
                return jobType
            end
        end
    end
    return nil
end

lib.callback.register('vehicle_armoury:getPlayerData', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        debugPrint("[SERVER] Player not found for source: " .. tostring(source))
        return nil
    end

    local job = Player.PlayerData.job
    local certs = Player.PlayerData.metadata["pdcerts"] or {}

    debugPrint("[SERVER] Job name: " .. tostring(job.name))
    debugPrint("[SERVER] Job grade: " .. tostring(job.grade.level))

    local data = {
        job = job,
        certs = certs
    }

    debugPrint("[SERVER] Returning player data: " .. json.encode(data))
    return data
end)

RegisterNetEvent('vehicle_armoury:logAccessDenied', function(stashId, vehicleModel)
    local src = source
    local playerName = GetPlayerName(src)
    sendToDiscord(
        'Armoury Access Denied',
        ('**Player:** %s (%s)\n**Stash:** `%s`\n**Vehicle:** `%s`'):format(
            playerName, src, stashId or 'unknown', vehicleModel or 'unknown'
        ),
        16711680
    )
end)

lib.callback.register('vehicle_armoury:createStash', function(source, stashId, items, jobType)
    if not stashId or type(items) ~= 'table' then
        debugPrint('[VehicleArmoury][SERVER] Invalid stash creation request.')
        return false
    end

    local owner = source
    local stashKey = stashId .. ':' .. owner

    local Player = QBCore.Functions.GetPlayer(owner)
    if not Player then
        debugPrint('[VehicleArmoury][SERVER] Player not found.')
        return false
    end

    debugPrint('[SERVER] Received items from client:')
    for _, item in ipairs(items) do
        debugPrint((' - %s x%s'):format(item.name, item.count))
    end

    -- If jobType wasn't passed, fall back to resolving from player job
    if not jobType then
        local job = Player.PlayerData.job.name
        jobType = getPlayerJobType(job)
        debugPrint('[VehicleArmoury][SERVER] jobType not provided, resolved from player job: ' .. tostring(jobType))
    end

    if not jobType then
        debugPrint('[VehicleArmoury][SERVER] Could not determine jobType.')
        return false
    end

    local config = Config.VehicleArmouries[jobType]
    if not config then
        debugPrint('[VehicleArmoury][SERVER] No config found for jobType: ' .. tostring(jobType))
        return false
    end

    local finalItems = items
    local slots = math.max(#finalItems, 60)

    local inventory = exports.ox_inventory:GetInventory({ id = stashId, owner = owner })
    debugPrint('Checking inventory for stash: ' .. stashId .. ' Owner: ' .. owner)

    if inventory and not registeredStashes[stashKey] then
        debugPrint('[VehicleArmoury][SERVER] Removing existing stale stash: ' .. stashKey)
        exports.ox_inventory:ClearInventory(inventory.id)
    end

    if not registeredStashes[stashKey] then
        exports.ox_inventory:RegisterStash(stashId, 'Vehicle Armoury', slots, 80000000, owner)
        registeredStashes[stashKey] = true
        debugPrint('[VehicleArmoury][SERVER] Registered new stash: ' .. stashKey)
    end

    local inv = exports.ox_inventory:GetInventory({ id = stashId, owner = owner })
    if not inv then
        debugPrint('[DEBUG] stash inventory not found for stashId: ' .. stashId)
        return false
    end

    debugPrint('[DEBUG] Found inventory for stashId: ' .. stashId)
    exports.ox_inventory:ClearInventory(inv.id)
    debugPrint('[DEBUG] Cleared existing inventory for stash: ' .. inv.id)

    debugPrint('[VehicleArmoury][SERVER] Preparing to add items:')
    for _, item in ipairs(finalItems) do
        debugPrint(('[VehicleArmoury][SERVER] Item: %s | Count: %s'):format(item.name, item.count))
        local success = exports.ox_inventory:AddItem(inv.id, item.name, item.count)
        debugPrint(('[VehicleArmoury][SERVER] AddItem result for %s: %s'):format(item.name, tostring(success)))
    end

    local updatedInv = exports.ox_inventory:GetInventory(inv.id)
    if updatedInv and updatedInv.items then
        debugPrint('[VehicleArmoury][SERVER] Final stash inventory:')
        for _, item in pairs(updatedInv.items) do
            debugPrint(('  - %s x%s'):format(item.name, item.count))
        end
    else
        debugPrint('[VehicleArmoury][SERVER] No items found in final stash inventory.')
    end

    debugPrint('[VehicleArmoury][SERVER] Stash populated with items.')
    return true
end)

-- Discord Logging for Hooks
CreateThread(function()
    while not exports.ox_inventory do Wait(100) end

    exports.ox_inventory:registerHook('remove', function(payload)
        local inv = payload.inventory
        local item = payload.item
        local player = payload.source

        if inv and inv.type == 'stash' and inv.id:find('vehicle_armoury_') then
            sendToDiscord('Armoury Item Removed',
                ('**Player:** %s (%s)\n**Stash:** `%s`\n**Item:** `%s`\n**Amount:** %s')
                    :format(GetPlayerName(player) or 'unknown', player, inv.id, item.name, item.count),
                16753920)
        end
    end, { inventory = { type = 'stash' } })

    exports.ox_inventory:registerHook('add', function(payload)
        local inv = payload.inventory
        local item = payload.item
        local player = payload.source

        if inv and inv.type == 'stash' and inv.id:find('vehicle_armoury_') then
            sendToDiscord('Armoury Item Added',
                ('**Player:** %s (%s)\n**Stash:** `%s`\n**Item:** `%s`\n**Amount:** %s')
                    :format(GetPlayerName(player) or 'unknown', player, inv.id, item.name, item.count),
                5763719)
        end
    end, { inventory = { type = 'stash' } })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for stashId, _ in pairs(registeredStashes) do
            exports.ox_inventory:ClearInventory(stashId)
        end
        registeredStashes = {}
    end
end)

lib.callback.register('adminstash:requestAccess', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return false end

    local job = xPlayer.PlayerData.job.name
    if job == "staff" or IsPlayerAceAllowed(source, "admin") then
        return true
    else
        return false
    end
end)