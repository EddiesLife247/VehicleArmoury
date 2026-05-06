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
    return GetVehicleDoorAngleRatio(vehicle, 5) > 0.1
end

local function getPlayerJobType(job)
    for type, jobs in pairs(Config.JobTypes) do
        for _, j in ipairs(jobs) do
            if j == job then
                return type
            end
        end
    end
    return nil
end

local function getVehicleInfo(vehicle, playerData, cb)
    local plate = trim(GetVehicleNumberPlateText(vehicle))
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
    local vehicleConfig = Config.ApprovedVehicles[model]
    debugPrint('[DEBUG] Vehicle:', model, 'Plate:', plate)

    if not vehicleConfig then
        debugPrint('[DEBUG] No config found for vehicle model:', model)
        return cb(nil)
    end

    local jobType = getPlayerJobType(playerData.job.name)
    local armoury = Config.VehicleArmouries[Config.JobTypes[jobType]]
    if not armoury then
        debugPrint('[DEBUG] No armoury config for job type:', jobType)
        return cb(nil)
    end

    -- Initialize items at the start for all job types
    local items = {}

if jobType == 'pd' then
    if playerData.certs then
        if armoury.certChecks and armoury.certChecks.general then
            -- Add general items first (if defined)
            for _, item in ipairs(armoury.certChecks.general.items or {}) do
                table.insert(items, item)
            end
        end

        -- Loop through all certs the player has
        for certName, hasCert in pairs(playerData.certs) do
            if hasCert and armoury.certChecks and armoury.certChecks[certName] then
                for _, item in ipairs(armoury.certChecks[certName].items or {}) do
                    table.insert(items, item)
                end
            end
        end
    else
        debugPrint('[DEBUG] Player has no certs')
        return cb(nil)
    end
    else
        -- For fire, ambulance, and other job types (skip cert checks)
        local grade = playerData.job.grade.level
        debugPrint('[ARMOURY] Gathering items for all grades up to:', grade)

        -- Ensure all items are added from grade 0 up to the player’s grade
        for i = 0, grade do
            local gradeData = armoury[i]
            if gradeData and gradeData.items then
                for _, item in ipairs(gradeData.items) do
                    table.insert(items, item)
                end
                debugPrint('[ARMOURY] Added grade-based items for level:', i)
            else
                debugPrint('[ARMOURY] No items found for grade level:', i)
            end
        end
    end

    -- Return the stash info and the accumulated items
    return cb({
        stashId = plate,
        label = model,
        items = items
    })
end

local function openArmoury(vehicle, playerData)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local stashId = 'vehicle_armoury_' .. netId
    local ownedStashId = stashId .. ':' .. cache.serverId

    getVehicleInfo(vehicle, playerData, function(info)
        if not info then
            lib.notify({ description = 'You are not certified to access this vehicle armoury.', type = 'error' })
            return
        end

        lib.callback('vehicle_armoury:createStash', false, function(success)
            if success then
                exports.ox_inventory:openInventory('stash', { id = ownedStashId })
            else
                lib.notify({ description = 'Failed to open vehicle stash.', type = 'error' })
            end
        end, stashId, info.items)
    end)
end

local function setupVehicleArmouryTarget(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if addedTargets[netId] then return end

    lib.callback('vehicle_armoury:getPlayerData', false, function(playerData)
        if not playerData then return end

        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
        if not Config.ApprovedVehicles[model] then return end

        exports.ox_target:addLocalEntity(vehicle, {
            {
                name = 'vehicle_armoury',
                icon = 'fa-solid fa-box-open',
                label = 'Access Vehicle Armoury',
                distance = 2.5,
                canInteract = function(entity)
                    return isBootOpen(entity)
                end,
                onSelect = function()
                    openArmoury(vehicle, playerData)
                end
            }
        })

        addedTargets[netId] = true
    end)
end

CreateThread(function()
    while true do
        Wait(1500)
        local playerPed = cache.ped
        local veh = GetVehiclePedIsIn(playerPed, false)
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == playerPed then
            setupVehicleArmouryTarget(veh)
        end
    end
end)

CreateThread(function()
    for _, location in pairs(Config.StandardLocations) do
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
                        lib.callback('vehicle_armoury:getPlayerData', false, function(playerData)
                            if not playerData then
                                debugPrint('[ARMOURY] No playerData returned from callback')
                                return
                            end

                            local jobType = getPlayerJobType(playerData.job.name)
                            if not jobType then
                                debugPrint('[ARMOURY] Player job type not recognized:', playerData.job.name)
                                return
                            end
                            debugPrint('[ARMOURY] Player job type:', jobType)

                            local isAllowed = false
                            for _, allowedType in ipairs(location.jobTypes) do
                                if allowedType == jobType then
                                    isAllowed = true
                                    break
                                end
                            end

                            if not isAllowed then
                                debugPrint('[ARMOURY] Access denied to location:', location.label, 'for jobType:', jobType)
                                lib.notify({ description = 'You do not have access to this armoury.', type = 'error' })
                                return
                            end

			    local armoury = Config.VehicleArmouries[Config.JobTypes[jobType]]
                            if not armoury then
                                debugPrint('[ARMOURY] No armoury config for job type:', jobType)
                                return
                            end

                            local items = deepcopy(armoury.certChecks and armoury.certChecks.general.items or {})

                            if jobType == 'pd' and playerData.certs then
                                debugPrint('[ARMOURY] Gathering items for PD certs')
for cert, hasCert in pairs(playerData.certs) do
    if hasCert and armoury.certChecks and armoury.certChecks[cert] then
        for _, item in ipairs(armoury.certChecks[cert].items) do
            table.insert(items, item)
        end
    end
                                end
                            else
                                local grade = playerData.job.grade.level
                                debugPrint('[ARMOURY] Gathering items for all grades up to:', grade)
                                for i = 0, grade do
                                    local gradeData = armoury[i]
                                    if gradeData and gradeData.items then
                                        for _, item in ipairs(gradeData.items) do
                                            table.insert(items, item)
                                        end
                                        debugPrint('[ARMOURY] Added grade-based items for level:', i)
                                    else
                                        debugPrint('[ARMOURY] No items found for grade level:', i)
                                    end
                                end
                            end

                            debugPrint('[ARMOURY] Final item count:', #items)

local stashId = "static_" .. location.label:gsub(" ", "_")
local ownedStashId = stashId .. ':' .. cache.serverId
-- Sanitize and flatten items
local stashItems = {}
for _, item in ipairs(items) do
    if item.name and item.count then
        table.insert(stashItems, {
            name = item.name,
            count = item.count
        })
    end
end
debugPrint('[ARMOURY] Items being added to stash:', json.encode(stashItems))

lib.callback('vehicle_armoury:createStash', false, function(success)
    if success then
        debugPrint('[ARMOURY] Stash created successfully, opening inventory')
        debugPrint('[ARMOURY] Items being added to stash:', json.encode(stashItems))

        exports.ox_inventory:openInventory("stash", {
            id = ownedStashId
        })
    else
        lib.notify({ description = 'Failed to open armoury stash.', type = 'error' })
        debugPrint('[ARMOURY] Failed to create stash')
    end
end, stashId, stashItems)
                        end)
                    end
                }
            }
        })
    end
end)

RegisterCommand("adminstash", function()
    local stashId = "admin_stash"
    local ownedStashId = stashId .. ":" .. cache.serverId

    lib.callback('adminstash:requestAccess', false, function(success)
        if success then
            lib.callback('vehicle_armoury:createStash', false, function(success)
                if success then
                    exports.ox_inventory:openInventory("stash", {
                        id = ownedStashId
                    })
                else
                    lib.notify({ description = 'Failed to open admin stash.', type = 'error' })
                end
            end, stashId, Config.AdminStashItems.items)
        else
            lib.notify({ description = 'You do not have permission to access this.', type = 'error' })
        end
    end)
end)

