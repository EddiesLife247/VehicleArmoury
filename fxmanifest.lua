fx_version 'cerulean'
game 'gta5'
-- Resource Metadata
author 'EddiesLife247'
description 'Vehicle Emergency Armoury'
version '1.0.0'
lua54 'yes' -- This ensures the asset is compatible with Lua 5.4



shared_script {
    '@ox_lib/init.lua',
    'config.lua',
    'shared.lua',

}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
escrow_ignore {
    'config.lua',              -- Ignoring the main configuration file
}

dependencies {
    'ox_inventory',
    'ox_lib',
    'qbx_core'
}