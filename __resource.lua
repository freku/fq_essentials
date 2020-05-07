resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'freecam'

client_scripts {
    'shared/config.lua',
    'client/client.lua',
    'client/zoneBuilder.lua',
}

server_scripts {
    'shared/config.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/qChat.lua',
    'server/server.lua',
    'server/commands.lua',
    'server/account.lua',
    'server/permissions.lua',
}