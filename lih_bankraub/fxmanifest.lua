fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author 'Justin'
description 'liH Bank Robbery'
version '1.0.2'

shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

client_scripts {
	'language.lua',
	'config.lua',
	'client/main.lua',
	'client/drilling.lua',
	'client/utils.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'language.lua',
	'config.lua',
	'server/main.lua'
}

escrow_ignore {
    "config.lua",
    "language.lua",
    "client/*.lua",
    "server/*.lua",
}