local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

local activeStashes = {}
local addedTargets = {}

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function debugPrint(...)
    if Config.Debug then
        print('[VehicleArmoury]', ...)
    end
end

local function isBootOpen(vehicle)
    local angle = GetVehicleDoorAngleRatio(vehicle, 5)
    debugPrint('[BOOT] Door angle ratio for vehicle', vehicle, ':', angle)
    return angle > 0.1
end

local function getPlayerJobType(job)
    debugPrint('[JOB] Looking up job type for job:', job)
    for type, jobs in pairs(Config.JobTypes) do
        for _, j in ipairs(jobs) do
            if j == job then
                debugPrint('[JOB] Matched job:', job, '-> jobType:', type)
                return type
            end
        end
    end
    debugPrint('[JOB] No job type found for job:', job)
    return nil
end

local function buildItems(armoury, jobType, playerData)
    local items = {}
    if jobType == 'pd' then
        if armoury.certChecks then
            debugPrint('[ITEMS] PD - Using certChecks path')
            for _, item in ipairs(armoury.certChecks.general and armoury.certChecks.general.items or {}) do
                table.insert(items, item)
            end
            if playerData.certs then
                for cert, hasCert in pairs(playerData.certs) do
                    if hasCert and armoury.certChecks[cert] then
                        for _, item in ipairs(armoury.certChecks[cert].items) do
                            table.insert(items, item)
                        end
                    end
                end
            end
        else
            debugPrint('[ITEMS] PD - Using grade path')
            local grade = playerData.job.grade.level
            for i = 0, grade do
                local gradeData = armoury[i]
                if gradeData and gradeData.items then
                    debugPrint('[ITEMS] Adding', #gradeData.items, 'items from grade', i)
                    for _, item in ipairs(gradeData.items) do
                        table.insert(items, item)
                    end
                end
            end
        end
    else
        debugPrint('[ITEMS] Non-PD - Using grade path for jobType:', jobType)
        local grade = playerData.job.grade.level
        for i = 0, grade do
            local gradeData = armoury[i]
            if gradeData and gradeData.items then
                debugPrint('[ITEMS] Adding', #gradeData.items, 'items from grade', i)
                for _, item in ipairs(gradeData.items) do
                    table.insert(items, item)
                end
            end
        end
    end
    return items
end

local function getVehicleInfo(vehicle, playerData, cb)
    local plate = trim(GetVehicleNumberPlateText(vehicle))
    local vehicleHash = GetEntityModel(vehicle)
    debugPrint('[VEHICLEINFO] Checking vehicle - Plate:', plate, '| Hash:', vehicleHash)
    debugPrint('[VEHICLEINFO] Player job:', playerData.job.name, '| Grade:', playerData.job.grade.level)

    local jobType = getPlayerJobType(playerData.job.name)
    if not jobType then
        debugPrint('[VEHICLEINFO] FAIL - Could not resolve job type for:', playerData.job.name)
        return cb(nil)
    end

    debugPrint('[VEHICLEINFO] Resolved jobType:', jobType)

    local allItems = {}
    local matchedAny = false

    for armouryJobList, armoury in pairs(Config.VehicleArmouries) do
        if type(armoury.vehicleModels) == 'table' then
            local vehicleMatches = false
            local matchedModel = ''
            for _, m in ipairs(armoury.vehicleModels) do
                if GetHashKey(m) == vehicleHash then
                    vehicleMatches = true
                    matchedModel = m
                    break
                end
            end

            if vehicleMatches then
                local jobAllowed = false
                for _, j in ipairs(armouryJobList) do
                    if j == playerData.job.name then
                        jobAllowed = true
                        break
                    end
                end

                if jobAllowed then
                    matchedAny = true
                    debugPrint('[VEHICLEINFO] Player job', playerData.job.name, 'has access to armoury containing model:', matchedModel)
                    local armouryJobType = jobType
                    local builtItems = buildItems(armoury, armouryJobType, playerData)
                    for _, item in ipairs(builtItems) do
                        table.insert(allItems, item)
                    end
                else
                    debugPrint('[VEHICLEINFO] Vehicle matched but player job', playerData.job.name, 'not in this armoury job list - skipping')
                end
            end
        end
    end

    if not matchedAny then
        debugPrint('[VEHICLEINFO] FAIL - No matching armoury found for this vehicle + job combo')
        return cb(nil)
    end

    local seen = {}
    local dedupedItems = {}
    for _, item in ipairs(allItems) do
        if not seen[item.name] then
            seen[item.name] = true
            table.insert(dedupedItems, item)
        else
            debugPrint('[VEHICLEINFO] Deduplicating item:', item.name)
        end
    end

    debugPrint('[VEHICLEINFO] Total items after dedup:', #dedupedItems, '| Plate:', plate)

    return cb({
        stashId = plate,
        label = plate,
        items = dedupedItems,
        jobType = jobType
    })
end

local function openArmoury(vehicle, playerData)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local stashId = 'vehicle_armoury_' .. netId
    local ownedStashId = stashId .. ':' .. cache.serverId
    debugPrint('[OPEN] Attempting to open armoury - NetID:', netId, '| StashID:', stashId, '| OwnedStashID:', ownedStashId)

    getVehicleInfo(vehicle, playerData, function(info)
        if not info then
            debugPrint('[OPEN] FAIL - getVehicleInfo returned nil')
            lib.notify({ description = 'You are not certified to access this vehicle armoury.', type = 'error' })
            return
        end

        debugPrint('[OPEN] Vehicle info OK - Label:', info.label, '| Items:', #info.items, '| StashID:', info.stashId)

        lib.callback('vehicle_armoury:createStash', false, function(success)
            if success then
                debugPrint('[OPEN] Stash created successfully, opening inventory for:', ownedStashId)
                exports.ox_inventory:openInventory('stash', { id = ownedStashId })
            else
                debugPrint('[OPEN] FAIL - createStash callback returned false for stashId:', stashId)
                lib.notify({ description = 'Failed to open vehicle stash.', type = 'error' })
            end
        end, stashId, info.items, info.jobType)
    end)
end

local function setupVehicleArmouryTarget(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if addedTargets[netId] then
        debugPrint('[SETUP] Target already registered for netId:', netId, '- skipping')
        return
    end

    debugPrint('[SETUP] Setting up armoury target for vehicle netId:', netId)

    lib.callback('vehicle_armoury:getPlayerData', false, function(playerData)
        if not playerData then
            debugPrint('[SETUP] FAIL - getPlayerData returned nil')
            return
        end

        debugPrint('[SETUP] Player data received - Job:', playerData.job.name, '| Grade:', playerData.job.grade.level)

        local vehicleHash = GetEntityModel(vehicle)
        local isAllowed = false

        for armouryJobList, armoury in pairs(Config.VehicleArmouries) do
            if type(armoury.vehicleModels) == 'table' then
                local vehicleMatches = false
                for _, m in ipairs(armoury.vehicleModels) do
                    if GetHashKey(m) == vehicleHash then
                        vehicleMatches = true
                        break
                    end
                end

                if vehicleMatches then
                    for _, j in ipairs(armouryJobList) do
                        if j == playerData.job.name then
                            isAllowed = true
                            debugPrint('[SETUP] Access granted via armoury job list for job:', playerData.job.name)
                            break
                        end
                    end
                end
            end
            if isAllowed then break end
        end

        if not isAllowed then
            debugPrint('[SETUP] FAIL - No armoury access for job:', playerData.job.name, 'on vehicle hash:', vehicleHash)
            return
        end

        debugPrint('[SETUP] Adding ox_target interaction for netId:', netId)
        exports.ox_target:addLocalEntity(vehicle, {
            {
                name = 'vehicle_armoury_' .. netId,
                icon = 'fa-solid fa-box-open',
                label = 'Access Vehicle Armoury',
                distance = 2.5,
                canInteract = function(entity)
                    local open = isBootOpen(entity)
                    debugPrint('[TARGET] canInteract check for entity', entity, '- Boot open:', open)
                    return open
                end,
                onSelect = function()
                    debugPrint('[TARGET] Armoury interaction selected for netId:', netId)
                    openArmoury(vehicle, playerData)
                end
            }
        })

        addedTargets[netId] = true
        debugPrint('[SETUP] Target successfully registered for netId:', netId)
    end)
end

CreateThread(function()
    debugPrint('[THREAD] Vehicle scan thread started')
    while true do
        Wait(2000)
        local playerPed = cache.ped
        local playerCoords = GetEntityCoords(playerPed)
        local vehicles = GetGamePool('CVehicle')
        debugPrint('[THREAD] Scanning', #vehicles, 'vehicles in pool')

        local nearby = 0
        for _, vehicle in ipairs(vehicles) do
            if vehicle ~= 0 then
                local vehicleCoords = GetEntityCoords(vehicle)
                local dist = #(playerCoords - vehicleCoords)
                if dist < 10.0 then
                    nearby = nearby + 1
                    setupVehicleArmouryTarget(vehicle)
                end
            end
        end
        debugPrint('[THREAD] Found', nearby, 'vehicles within 10m')
    end
end)

CreateThread(function()
    debugPrint('[STATIC] Registering', #Config.StandardLocations, 'static armoury locations')
    for _, location in pairs(Config.StandardLocations) do
        debugPrint('[STATIC] Registering location:', location.label, '| JobTypes:', table.concat(location.jobTypes, ', '))
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = vec3(1.5, 1.5, 2.0),
            rotation = location.heading,
            debug = Config.Debug,
            options = {
                {
                    name = "armoury_static_" .. location.label,
                    icon = "fas fa-warehouse",
                    label = "Open Armoury",
                    onSelect = function()
                        debugPrint('[STATIC] Armoury zone selected at:', location.label)
                        lib.callback('vehicle_armoury:getPlayerData', false, function(playerData)
                            if not playerData then
                                debugPrint('[STATIC] FAIL - No playerData returned')
                                return
                            end

                            debugPrint('[STATIC] Player job:', playerData.job.name, '| Grade:', playerData.job.grade.level)

                            -- jobType is driven by the armoury location, not the player's job
                            local jobType = location.jobTypes[1]
                            local playerJobType = getPlayerJobType(playerData.job.name)

                            if not playerJobType then
                                debugPrint('[STATIC] FAIL - Player job type not recognized:', playerData.job.name)
                                return
                            end

                            debugPrint('[STATIC] Player jobType:', playerJobType, '| Location jobType:', jobType)

                            -- Check player's job type is allowed at this location
                            local isAllowed = false
                            for _, allowedType in ipairs(location.jobTypes) do
                                if allowedType == playerJobType then
                                    isAllowed = true
                                    break
                                end
                            end

                            if not isAllowed then
                                debugPrint('[STATIC] FAIL - Access denied at:', location.label, '| Player jobType:', playerJobType)
                                lib.notify({ description = 'You do not have access to this armoury.', type = 'error' })
                                return
                            end

                            debugPrint('[STATIC] Access granted at:', location.label)

                            local armoury = Config.VehicleArmouries[jobType]
                            if not armoury then
                                debugPrint('[STATIC] FAIL - No armoury config for jobType:', jobType)
                                return
                            end

                            local items = buildItems(armoury, jobType, playerData)

                            debugPrint('[STATIC] Total items built:', #items)

                            local stashId = "static_" .. location.label:gsub(" ", "_")
                            local ownedStashId = stashId .. ':' .. cache.serverId
                            debugPrint('[STATIC] StashID:', stashId, '| OwnedStashID:', ownedStashId)

                            local stashItems = {}
                            for _, item in ipairs(items) do
                                if item.name and item.count then
                                    table.insert(stashItems, { name = item.name, count = item.count })
                                else
                                    debugPrint('[STATIC] WARN - Skipping malformed item:', json.encode(item))
                                end
                            end

                            debugPrint('[STATIC] Final stash items:', json.encode(stashItems))

                            lib.callback('vehicle_armoury:createStash', false, function(success)
                                if success then
                                    debugPrint('[STATIC] Stash created, opening inventory:', ownedStashId)
                                    exports.ox_inventory:openInventory("stash", { id = ownedStashId })
                                else
                                    debugPrint('[STATIC] FAIL - createStash returned false for:', stashId)
                                    lib.notify({ description = 'Failed to open armoury stash.', type = 'error' })
                                end
                            end, stashId, stashItems, jobType)
                        end)
                    end
                }
            }
        })
    end
end)

RegisterCommand("adminstash", function()
    debugPrint('[ADMINSTASH] Command triggered by serverId:', cache.serverId)
    local stashId = "admin_stash"
    local ownedStashId = stashId .. ":" .. cache.serverId

    lib.callback('adminstash:requestAccess', false, function(success)
        if success then
            debugPrint('[ADMINSTASH] Access granted, creating stash:', stashId)
            lib.callback('vehicle_armoury:createStash', false, function(success)
                if success then
                    debugPrint('[ADMINSTASH] Stash created, opening inventory:', ownedStashId)
                    exports.ox_inventory:openInventory("stash", { id = ownedStashId })
                else
                    debugPrint('[ADMINSTASH] FAIL - createStash returned false')
                    lib.notify({ description = 'Failed to open admin stash.', type = 'error' })
                end
            end, stashId, Config.AdminStashItems.items, 'admin')
        else
            debugPrint('[ADMINSTASH] FAIL - Access denied for serverId:', cache.serverId)
            lib.notify({ description = 'You do not have permission to access this.', type = 'error' })
        end
    end)
end)