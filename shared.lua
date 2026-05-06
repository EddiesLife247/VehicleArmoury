-- Used by ox_inventory item registration
exports('getVehicleArmouryItems', function(vehicleModel)
    vehicleModel = vehicleModel:lower()
    for cert, data in pairs(Config.VehicleArmouries) do
        for _, model in ipairs(data.models) do
            if model == vehicleModel then
                return data.items
            end
        end
    end
    return nil
end)
